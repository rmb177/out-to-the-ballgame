# !/usr/bin/env python
#

"""
Controllers for adding/updating game data in the
datastore
"""

#import json
import csv
import re
import webapp2

from os import listdir
from os.path import isfile, join, split

from models.team import Team

#from google.appengine.ext import ndb

GAME_DATA_PATH = '../../data/schedules/2014/'

#TEAM_DATA_PATH = '../../data/team_data.json'
#TEAMS_KEY = 'teams'
#MLBID_KEY = 'mlbId'
#NAME_KEY = 'name'
#LEAGUE_KEY = 'league'
#DIVISION_KEY = 'division'
#STADIUM_KEY = 'stadiumName'
#LAT_KEY = 'lat'
#LON_KEY = 'lon'


class AdminGameHandler(webapp2.RequestHandler):
    """
    Contorller to add/update game info.
    """

    def post(self):
        """
        Read game data files and add/update to the datastore.
        """        
        path = join(split(__file__)[0], GAME_DATA_PATH)
        file_names = [join(path, f) for f in listdir(path) if isfile(join(path, f))]
        
        
        for file_name in file_names:
            with open(file_name, 'rb') as f:
                next(f)
                reader = csv.reader(f)
                
                # Pull out the team name abbreviation from the file name and
                # get the team record
                m = re.search('[a-z]{2,3}\.csv\Z', file_name)
                team_abbr = m.group(0)[:-4]
                team = Team.query(Team.name_abbr == team_abbr).get()
                print team.name

                x = 0
                for row in reader:
                    
                    x += 1
                print x
            
        
        #path = os.path.join(os.path.split(__file__)[0], TEAM_DATA_PATH)
        #teams_json = json.loads(open(path).read())
        #for team_data in teams_json[TEAMS_KEY]:
        #    team = Team.query(Team.mlbId == team_data[MLBID_KEY]).get() or Team()
        #    team.mlbId = team_data[MLBID_KEY]
        #    team.name = team_data[NAME_KEY]
        #    team.league = team_data[LEAGUE_KEY]
        #    team.division = team_data[DIVISION_KEY]
        #    team.stadium_name = team_data[STADIUM_KEY]
        #    team.location = ndb.GeoPt(team_data[LAT_KEY], team_data[LON_KEY])
        #    team.put()


app = webapp2.WSGIApplication([('/admin/games', AdminGameHandler)], debug=True)
