#!/usr/bin/env python
# encoding: utf-8

"""
Module for a trip class that represents the travel
distance/time beteween teams
"""

from google.appengine.ext import ndb

class Trip(ndb.Model):
    """
    Game model to represent an MLB game
    """
    orig_team = ndb.KeyProperty(kind='Team')
    dest_team = ndb.KeyProperty(kind='Team')
    distance = ndb.IntegerProperty()    # in meters
    distance_desc = ndb.TextProperty()  # text representation in miles
    duration = ndb.IntegerProperty      # in seconds
    duration_desc = ndb.TextProperty()  # text representation in hours
