#!/usr/bin/env python
# encoding: utf-8

"""
Module for game class
"""

from google.appengine.ext import ndb

class Game(ndb.Model):
    """
    Game model to represent an MLB game
    """
    game_time = ndb.DateTimeProperty()
    home_team = ndb.KeyProperty(kind='Team')
    away_team = ndb.KeyProperty(kind='Team')
