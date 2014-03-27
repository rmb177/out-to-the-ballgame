#!/usr/bin/env python
# encoding: utf-8

"""
A utility class for providing all date/times in Eastern time zone.

See GAE documentation at:
    https://developers.google.com/appengine/docs/python/datastore/typesandpropertyclasses#datetime
"""

import datetime
import time

class EasternTzInfo(datetime.tzinfo):
    """
    Implementation of the Eastern timezone.
    """
    
    def utcoffset(self, dt):
        """Offset by the appropriate amount"""
        return datetime.timedelta(hours=-5) + self.dst(dt)

    def _FirstSunday(self, dt):
        """First Sunday on or after dt."""
        return dt + datetime.timedelta(days=(6-dt.weekday()))

    def dst(self, dt):
        """Return the appropriate time for Eastern time zone"""
        
        # 2 am on the second Sunday in March
        dst_start = self._FirstSunday(datetime.datetime(dt.year, 3, 8, 2))
        # 1 am on the first Sunday in November
        dst_end = self._FirstSunday(datetime.datetime(dt.year, 11, 1, 1))

        if dst_start <= dt.replace(tzinfo=None) < dst_end:
            return datetime.timedelta(hours=1)
        else:
            return datetime.timedelta(hours=0)
            
    def tzname(self, dt):
        """Return the appropriate string for daylight savings or not"""
        if self.dst(dt) == datetime.timedelta(hours=0):
            return "EST"
        else:
            return "EDT"
