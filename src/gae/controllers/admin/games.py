# !/usr/bin/env python
#

"""
Controllers for adding/updating game data in the
datastore
"""

import csv
import datetime
import os
import re
import time
import webapp2

import models.eastern_tz as eastern_tz
import models.game as game
import models.team as team


GAME_DATA_PATH = '../../data/schedules/2014/'

GAME_DATE_INDEX = 0
GAME_TIME_INDEX = 2
TEAMS_INDEX = 3
LOCATION_INDEX = 4


class AdminGameHandler(webapp2.RequestHandler):
    """
    Contorller to add/update game info.
    """

    def post(self):
        """
        Read game data files and add/update to the datastore.
        """        
        path = os.path.join(os.path.split(__file__)[0], GAME_DATA_PATH)
        file_names = [os.path.join(path, f) for f in os.listdir(path) if os.path.isfile(os.path.join(path, f))]
        
        num_games = 0
        for file_name in file_names:
            with open(file_name, 'rb') as f:
                next(f) # skip header line
                reader = csv.reader(f)
                
                home_team = self.__get_home_team(file_name)
                
                for row in reader:
                    if home_team.stadium_name == row[LOCATION_INDEX]:
                        num_games += 1
                        away_team = self.__get_away_team(row[TEAMS_INDEX])
                        game_time = self.__get_game_time(row[GAME_DATE_INDEX], row[GAME_TIME_INDEX])
                        
                        query = game.Game.gql('WHERE home_team = :1 AND away_team = :2 AND game_time = :3',
                         home_team.key, away_team.key, game_time)
                        
                        g = query.get() or game.Game()
                        g.home_team = home_team.key
                        g.away_team = away_team.key
                        g.game_time = game_time
                        g.put()                
    
    def __get_home_team(self, file_name):
        """
        Fetch the team who's schedule file we're processing
        """
        m = re.search('[a-z]{2,3}\.csv\Z', file_name)
        home_team_abbr = m.group(0)[:-4]
        return team.Team.query(team.Team.name_abbr == home_team_abbr).get()
    
    
    def __get_away_team(self, game_info_str):
        """
        Fetch the away team based on the game info string:
            format: 'Phillies at Braves'
        
        Schedule file abbreivates 'Diamondbacks' as 'D-backs'
        """
        away_team_name = re.search('^.* at', game_info_str).group(0)[:-3]
        away_team_name = 'Diamondbacks' if away_team_name == 'D-backs' else away_team_name
        return team.Team.query(team.Team.name == away_team_name).get()
        
        
    def __get_game_time(self, date_str, time_str):
        """
        Creates and returns a datetime object from the give date/time strings
        from the mlb schedule files:
         date/time format is %m/%d/%y %I:%M %p
         
        All times are read in as Eastern and converted to UTC
        """
        datetime_str = '%s %s' %(date_str, time_str)
        game_time = time.strptime(datetime_str,'%m/%d/%y %I:%M %p')
        est_time = datetime.datetime.fromtimestamp(time.mktime(game_time))
        tz_info = eastern_tz.EasternTzInfo()
        utc_time = est_time - tz_info.utcoffset(est_time)
        return utc_time

app = webapp2.WSGIApplication([('/admin/games', AdminGameHandler)], debug=True)
