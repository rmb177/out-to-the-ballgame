# !/usr/bin/env python
#

"""
Controllers for adding/updating route data to the datastore
"""

#pylint: disable=C0103, E1101, R0201

import json
import urllib2
import webapp2

from google.appengine.api import taskqueue

import models.config as config
import models.team as team
import models.trip as trip

DIRECTIONS_URL = (
'https://maps.googleapis.com/maps/api/directions/json'
'?origin=%f,%f&destination=%f,%f&sensor=false&key=%s')



class AdminRouteHandler(webapp2.RequestHandler):
    """
    Contorller to add/update route info. This controller
    is used to kick off a task for each team to call
    Google's routes API to get the routes
    between each stadium. Need to use a task
    queue to stay within GAE request time limits.
    """

    def post(self):
        """
        Kick off a task for each team
        """
        retry_options = taskqueue.TaskRetryOptions(task_retry_limit=0)
        
        team_ids = []
        for a_team in team.Team.query():
            team_ids.append(a_team.key.id())
        
        request = 0
        for orig_team_id in team_ids:
            for dest_team_id in team_ids:
                if orig_team_id != dest_team_id:
                    request += 1
                    task = taskqueue.Task(url='/admin/team_routes',
                                          params={'orig_team_id': orig_team_id,
                                                  'dest_team_id': dest_team_id},  
                                          retry_options=retry_options)
                    task.add()


class AdminTeamRoutesHandler(webapp2.RequestHandler):
    """
    Controller to call the Google Routes API
    for a single team
    """

    def post(self):
        """
        Store the data returned from the Google Map matrix api
        so we have the distance from the given team's stadium
        to all of the other stadiums
        """
        origin_team = team.Team.get_by_id(int(self.request.get('orig_team_id')))
        destination_team = team.Team.get_by_id(int(self.request.get('dest_team_id')))
        
        url = DIRECTIONS_URL %(origin_team.location.lat,
                               origin_team.location.lon,
                               destination_team.location.lat,
                               destination_team.location.lon,
                               config.Config.get_master_db().google_maps_key)
        
        req = urllib2.Request(url)
        req.add_header('Referer', 'https://out-to-the-ballgame.appspot.com/')
        response = urllib2.urlopen(req)
        json_response = json.loads(response.read())
        polyline = json_response['routes'][0]['overview_polyline']['points']
        
        query = trip.Trip.gql(
            'WHERE orig_team = :1 AND '
            'dest_team = :2',
            origin_team.key, destination_team.key)
        
        a_trip = query.get()
        a_trip.route = polyline
        a_trip.put()


app = webapp2.WSGIApplication([('/admin/routes', AdminRouteHandler),
                               ('/admin/team_routes', AdminTeamRoutesHandler)],
                               debug=True)
