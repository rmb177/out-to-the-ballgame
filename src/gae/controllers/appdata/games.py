# !/usr/bin/env python
#

"""
Controller to return game information
"""

#pylint: disable=C0103, E1101

import datetime
import webapp2

from google.appengine.ext import ndb

import models.game as game
import models.team as team


class GamesHandler(webapp2.RequestHandler):
    """
    Handler for retrieving game data for a given date
    """

    def get(self):
        """
        Return all games along with team/stadium info for
        the given date
        """
        date = datetime.datetime.strptime(self.request.get('date'), '%Y-%m-%d')

        games = game.Game.query(ndb.AND(
            game.Game.game_time >= date,
            game.Game.game_time < date + datetime.timedelta(days=1)))

        games_data = []
        for a_game in games:
            home_team = team.Team.get_by_id(a_game.home_team.id())
            away_team = team.Team.get_by_id(a_game.away_team.id())
            game_info = ('{"game_time":"%s",'
                        ' "home_team":"%s",'
                        ' "home_team_abbr":"%s",'
                        ' "away_team":"%s",'
                        ' "away_team_abbr":"%s",'
                        ' "lat":"%f",'
                        ' "lon":"%f"}') % (
                a_game.game_time.strftime('%I:%M %p EDT').lstrip("0"),
                home_team.name,
                home_team.name_abbr,
                away_team.name,
                away_team.name_abbr,
                home_team.location.lat,
                home_team.location.lon)

            games_data.append(game_info)

        self.response.headers['Content-Type'] = 'application/json'
        self.response.out.write(
         ''.join(['[', ','.join([game_json for game_json in games_data]), ']']))


app = webapp2.WSGIApplication([('/appdata/games', GamesHandler)], debug=True)
