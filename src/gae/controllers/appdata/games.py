# !/usr/bin/env python
#

"""
Controller to return game information
"""

#pylint: disable=C0103, E1101

import datetime
import webapp2

from google.appengine.api import memcache
from google.appengine.ext import ndb

import models.game as game
import models.team as team


class GamesHandler(webapp2.RequestHandler):
    """
    Handler for retrieving all game data for a given date
    """

    def get(self):
        """
        Return all games along with team/stadium info for
        the given date
        """
        date_key = self.request.get('date')
        data = memcache.get(date_key)
        if data is None:
            date = datetime.datetime.strptime(date_key, '%Y-%m-%d')
        
            games = game.Game.query(ndb.AND(
                game.Game.game_time >= date,
                game.Game.game_time < date + datetime.timedelta(days=1)))

            games_data = []
            for a_game in games:
                home_team = team.Team.get_by_id(a_game.home_team.id())
                away_team = team.Team.get_by_id(a_game.away_team.id())
                game_info = ('{"id":"%s",'
                             ' "game_day":"%s",'
                             ' "game_time":"%s",'
                             ' "home_team_id":"%d",'
                             ' "home_team_name":"%s",'
                             ' "home_team_abbr":"%s",'
                             ' "away_team_id":"%d",'
                             ' "away_team_name":"%s",'
                             ' "away_team_abbr":"%s",'
                             ' "lat":"%f",'
                             ' "lon":"%f"}') % (
                    a_game.key.id(),
                    self.request.get('date'),
                    a_game.game_time.strftime('%I:%M %p EDT').lstrip("0"),
                    a_game.home_team.id(),
                    home_team.name,
                    home_team.name_abbr,
                    a_game.away_team.id(),
                    away_team.name,
                    away_team.name_abbr,
                    home_team.location.lat,
                    home_team.location.lon)
                games_data.append(game_info)
                
            data = ''.join(['[', ','.join([game_json for game_json in games_data]), ']'])
            memcache.add(date_key, data)

        self.response.headers['Content-Type'] = 'application/json'
        self.response.out.write(data)

app = webapp2.WSGIApplication([('/appdata/games', GamesHandler)], debug=True)
