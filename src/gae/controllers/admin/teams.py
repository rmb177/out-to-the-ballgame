# !/usr/bin/env python
#

"""
Controllers for adding/updating team data in the
datastore
"""

#pylint: disable=C0103

import json
import os
import webapp2

from google.appengine.ext import ndb

TEAM_DATA_PATH = '../../data/team_data.json'
TEAMS_KEY = 'teams'
MLBID_KEY = 'mlbId'
NAME_KEY = 'name'
LEAGUE_KEY = 'league'
DIVISION_KEY = 'division'
STADIUM_KEY = 'stadiumName'
LAT_KEY = 'lat'
LON_KEY = 'lon'

from models.team import Team


class AdminTeamHandler(webapp2.RequestHandler):
    """
    Contorller to add/update team info.
    """

    def post(self):
        """
        Read team data file and add/update to the datastore.
        """
        path = os.path.join(os.path.split(__file__)[0], TEAM_DATA_PATH)
        teams_json = json.loads(open(path).read())
        for team_data in teams_json[TEAMS_KEY]:
            team = Team.query(Team.mlbId == team_data[MLBID_KEY]).get() or Team()
            team.mlbId = team_data[MLBID_KEY]
            team.name = team_data[NAME_KEY]
            team.league = team_data[LEAGUE_KEY]
            team.division = team_data[DIVISION_KEY]
            team.stadium_name = team_data[STADIUM_KEY]
            team.location = ndb.GeoPt(team_data[LAT_KEY], team_data[LON_KEY])
            team.put()


app = webapp2.WSGIApplication([('/admin/teams', AdminTeamHandler)], debug=True)
