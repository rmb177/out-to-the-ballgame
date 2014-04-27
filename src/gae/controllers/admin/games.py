# !/usr/bin/env python
#

"""
Controllers for adding/updating game data in the
datastore
"""

#pylint: disable=C0103, E1101, R0201, W1401

import csv
import datetime
import os
import re
import time
import webapp2

from google.appengine.api import taskqueue

import models.game as game
import models.team as team


GAME_DATA_PATH = '../../data/schedules/2014/'

GAME_DATE_INDEX = 0
GAME_TIME_INDEX = 2
TEAMS_INDEX = 3
LOCATION_INDEX = 4


class AdminGameHandler(webapp2.RequestHandler):
    """
    Controller to add/update game info. This controller
    is used to kick off a task for each team to load each
    team's home games into the system. Need to use a task
    queue to stay within GAE request time limits.
    """

    def post(self):
        """
        Read game data files and kick off a task for each team.
        """
        path = os.path.join(os.path.split(__file__)[0], GAME_DATA_PATH)
        file_names = [os.path.join(path, f) for f in
         os.listdir(path) if os.path.isfile(os.path.join(path, f))]

        for file_name in file_names:
            taskqueue.add(url='/admin/team_games',
             params={'file_name': file_name})


class AdminTeamGamesHandler(webapp2.RequestHandler):
    """
    Controller to load the given team's home games into the data store
    """

    def post(self):
        """
        Read the schedule file for the given team and create/update
        all of the home games for the team to the datastore.
        """
        file_name = self.request.get('file_name')

        with open(file_name, 'rb') as schedule:
            next(schedule) # skip header line
            reader = csv.reader(schedule)

            home_team = self.__get_home_team(file_name)

            for row in reader:
                if home_team.stadium_name == row[LOCATION_INDEX]:
                    away_team = self.__get_away_team(row[TEAMS_INDEX])
                    game_time = self.__get_game_time(
                     row[GAME_DATE_INDEX], row[GAME_TIME_INDEX])

                    query = game.Game.gql(
                     'WHERE home_team = :1 AND '
                     'away_team = :2 AND '
                     'game_time = :3',
                     home_team.key, away_team.key, game_time)

                    a_game = query.get() or game.Game()
                    a_game.home_team = home_team.key
                    a_game.away_team = away_team.key
                    a_game.game_time = game_time
                    a_game.put()


    def __get_home_team(self, file_name):
        """
        Fetch the team who's schedule file we're processing
        """
        match = re.search('[a-z]{2,3}\.csv\Z', file_name)
        home_team_abbr = match.group(0)[:-4]
        return team.Team.query(team.Team.name_abbr == home_team_abbr).get()


    def __get_away_team(self, game_info_str):
        """
        Fetch the away team based on the game info string:
            format: 'Phillies at Braves'

        Schedule file abbreivates 'Diamondbacks' as 'D-backs'
        """
        away_team_name = re.search('^.* at', game_info_str).group(0)[:-3]
        if away_team_name == 'D-backs':
            away_team_name = 'Diamondbacks'

        return team.Team.query(team.Team.name == away_team_name).get()


    def __get_game_time(self, date_str, time_str):
        """
        Creates and returns a datetime object from the give date/time strings
        from the mlb schedule files:
         date/time format is %m/%d/%y %I:%M %p

        All times are read in as Eastern and converted to UTC
        """
        datetime_str = '%s %s' %(date_str, time_str)
        game_time = time.strptime(datetime_str, '%m/%d/%y %I:%M %p')
        return datetime.datetime.fromtimestamp(time.mktime(game_time))


app = webapp2.WSGIApplication([('/admin/games', AdminGameHandler),
                               ('/admin/team_games', AdminTeamGamesHandler)],
                               debug=True)
