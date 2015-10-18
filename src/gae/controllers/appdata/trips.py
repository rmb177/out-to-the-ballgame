# !/usr/bin/env python
#

"""
Controller to return distance information between each city
"""

import datetime
import webapp2

from google.appengine.ext import ndb

import models.trip as trip


class TripsHandler(webapp2.RequestHandler):
    """
    Handler for retrieving information about distances/time between each city
    """

    def get(self):
        """
        Return all trip pairs between each stadium, giving the time and distance
        to travel
        """
        trips = trip.Trip.query()
        trips_data = []
        
        for a_trip in trips:
            trip_info = ('{"orig_team_id":"%s",'
                         ' "dest_team_id":"%s",'
                         ' "distance":"%d",'
                         ' "distance_desc":"%s",'
                         ' "duration":"%d",' 
                         ' "duration_desc":"%s"}') % (
                a_trip.orig_team.id(),
                a_trip.dest_team.id(),
                a_trip.distance,
                a_trip.distance_desc,
                a_trip.duration,
                a_trip.duration_desc)
        
            trips_data.append(trip_info)

        self.response.headers['Content-Type'] = 'application/json'
        self.response.out.write(
         ''.join(['[', ','.join([trip_json for trip_json in trips_data]), ']']))

app = webapp2.WSGIApplication([('/appdata/trips', TripsHandler)], debug=True)
