#!/usr/bin/env python
# encoding: utf-8

"""
Module for team class
"""

from google.appengine.ext import ndb

class Team(ndb.Model):
    """
    Team model to represent all of the MLB teams
    """
    mlbId = ndb.IntegerProperty()
    name = ndb.StringProperty()
    league = ndb.StringProperty()
    division = ndb.StringProperty()
    stadium_name = ndb.StringProperty()
    location = ndb.GeoPtProperty()
