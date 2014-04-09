# !/usr/bin/env python
#

"""
Controllers for adding/updating trip data to the
datastore
"""

#pylint: disable=C0103, E1101, R0201

import json
import urllib2
import webapp2

from google.appengine.api import taskqueue

import models.config as config
import models.team as team
import models.trip as trip

DISTANCE_MATRIX_URL = (
 'https://maps.googleapis.com/maps/api/distancematrix/json'
 '?origins=%s&destinations=%s&sensor=false&key=%s&units=imperial')



class AdminTripHandler(webapp2.RequestHandler):
    """
    Contorller to add/update trip info. This controller
    is used to kick off a task for each team to call
    Google's map matrix API to get the distances
    between each stadium. Need to use a task
    queue to stay within GAE request time limits.
    """

    def post(self):
        """
        Kick off a task for each team
        """
        task_num = 0
        retry_options = taskqueue.TaskRetryOptions(task_retry_limit=0)

        for a_team in team.Team.query():
            task = taskqueue.Task(url='/admin/team_trips',
                                  params={'team_id': a_team.key.id()},
                                  countdown=15 * task_num,
                                  retry_options=retry_options)

            task.add()
            task_num += 1


class AdminTeamTripsHandler(webapp2.RequestHandler):
    """
    Controller to call the Google Maps matrix API
    for a single team
    """

    def post(self):
        """
        Store the data returned from the Google Map matrix api
        so we have the distance from the given team's stadium
        to all of the other stadiums
        """
        origin_team = team.Team.get_by_id(int(self.request.get('team_id')))
        origin_team_coords = '|'.join(
         ['%f,%f' %(origin_team.location.lat, origin_team.location.lon)])

        dest_coords = []
        dest_teams = []
        for dest_team in team.Team.query():
            if origin_team != dest_team:
                dest_teams.append(dest_team)
                dest_coords.append(
                 '%f,%f' %(dest_team.location.lat, dest_team.location.lon))

        url = DISTANCE_MATRIX_URL %(origin_team_coords,
         '|'.join(dest_coords),
         config.Config.get_master_db().google_maps_key)

        req = urllib2.Request(url)
        req.add_header('Referer', 'https://out-to-the-ballgame.appspot.com/')
        response = urllib2.urlopen(req)
        trips_matrix = json.loads(response.read())

        idx = 0
        for dest_team in dest_teams:
            query = trip.Trip.gql(
            'WHERE orig_team = :1 AND '
                 'dest_team = :2',
                 origin_team.key, dest_team.key)

            a_trip = query.get() or trip.Trip()
            a_trip.orig_team = origin_team.key
            a_trip.dest_team = dest_team.key
            trip_element = trips_matrix['rows'][0]['elements'][idx]
            a_trip.distance = trip_element['distance']['value']
            a_trip.distance_desc = trip_element['distance']['text']
            a_trip.duration = trip_element['duration']['value']
            a_trip.duration_desc = trip_element['duration']['text']
            a_trip.put()
            idx += 1


app = webapp2.WSGIApplication([('/admin/trips', AdminTripHandler),
                               ('/admin/team_trips', AdminTeamTripsHandler)],
                               debug=True)
