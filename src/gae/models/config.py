#!/usr/bin/env python
# encoding: utf-8

"""
A class to provide configuration values from the data store
"""

from google.appengine.ext import ndb

class Config(ndb.Model):
    """
    Class to hold api keys and other configuration items
    """
    google_maps_key = ndb.StringProperty(default='')

    @classmethod
    def get_master_db(cls):
        """
        Create/return a singleton instance of the class
        """
        return cls.get_or_insert('master')
