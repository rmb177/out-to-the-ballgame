# !/usr/bin/env python
#

"""
Controllers for adding/updating team data in the
datastore
"""

#pylint: disable=C0103, R0201

import json
import os
import webapp2

from google.appengine.ext import ndb

TEAM_DATA_PATH = '../../data/team_data.json'
TEAMS_KEY = 'teams'
MLBID_KEY = 'mlbId'
NAME_KEY = 'name'
NAME_ABBR_KEY = 'nameAbbr'
LEAGUE_KEY = 'league'
DIVISION_KEY = 'division'
STADIUM_KEY = 'stadiumName'
LAT_KEY = 'lat'
LON_KEY = 'lon'
ET_TIME_OFFSET = "etTimeOffset"

import models.team as team


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
            t = team.Team.query(
             team.Team.mlbId == team_data[MLBID_KEY]).get() or team.Team()
            t.mlbId = team_data[MLBID_KEY]
            t.name = team_data[NAME_KEY]
            t.name_abbr = team_data[NAME_ABBR_KEY]
            t.league = team_data[LEAGUE_KEY]
            t.division = team_data[DIVISION_KEY]
            t.stadium_name = team_data[STADIUM_KEY]
            t.location = ndb.GeoPt(team_data[LAT_KEY], team_data[LON_KEY])
            t.etTimeOffset = team_data[ET_TIME_OFFSET]
            t.put()


app = webapp2.WSGIApplication([('/admin/teams', AdminTeamHandler)], debug=True)
