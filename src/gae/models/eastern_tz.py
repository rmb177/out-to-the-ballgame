#!/usr/bin/env python
# encoding: utf-8

"""
A utility class for providing all date/times in Eastern time zone.

See GAE documentation at:
    https://developers.google.com/appengine/docs/python/datastore/typesandpropertyclasses#datetime
"""

#pylint: disable=R0201

import datetime


class EasternTzInfo(datetime.tzinfo):
    """
    Implementation of the Eastern timezone.
    """

    def utcoffset(self, a_time):
        """Offset by the appropriate amount"""
        return datetime.timedelta(hours=-5) + self.dst(a_time)

    def __first_sunday(self, a_time):
        """First Sunday on or after dt."""
        return a_time + datetime.timedelta(days=(6 - a_time.weekday()))

    def dst(self, a_time):
        """Return the appropriate time for Eastern time zone"""

        # 2 am on the second Sunday in March
        dst_start = self.__first_sunday(datetime.datetime(a_time.year, 3, 8, 2))
        # 1 am on the first Sunday in November
        dst_end = self.__first_sunday(datetime.datetime(a_time.year, 11, 1, 1))

        if dst_start <= a_time.replace(tzinfo=None) < dst_end:
            return datetime.timedelta(hours=1)
        else:
            return datetime.timedelta(hours=0)

    def tzname(self, a_time):
        """Return the appropriate string for daylight savings or not"""
        if self.dst(a_time) == datetime.timedelta(hours=0):
            return "EST"
        else:
            return "EDT"
