#!/usr/bin/env python
# encoding: utf-8

"""
Download all of the schedules from the individual team sites
"""

import os
import urllib2

import sys
sys.path.append(r'..')
import util.util as util

# Website ids for all of the MLB teams to download their schedule
BASE_URL = "http://mlb.mlb.com/soa/ical/schedule.csv?"
SEASON = 2015
TEAM_IDS = {
    'bal': 110,
    'bos': 111,
    'nyy': 147,
    'tb':  139,
    'tor': 141,
    'cws': 145,
    'cle': 114,
    'det': 116,
    'kc':  118,
    'min': 142,
    'hou': 117,
    'ana': 108,
    'oak': 133,
    'sea': 136,
    'tex': 140,
    'atl': 144,
    'mia': 146,
    'nym': 121,
    'phi': 143,
    'was': 120,
    'chc': 112,
    'cin': 113,
    'mil': 158,
    'pit': 134,
    'stl': 138,
    'ari': 109,
    'col': 115,
    'la':  119,
    'sd':  135,
    'sf':  137
}

def main():
    """
    Creates a schedules directory and downloads all schedules to disk
    """
    for key, value in TEAM_IDS.iteritems():
        util.print_progress_dot()
        url = "%steam_id=%d&season=%d&game_type='R'" % (BASE_URL, value, SEASON)
        page = urllib2.urlopen(url)

        if not os.path.isdir('schedules/%s/' % (SEASON)):
            os.makedirs('schedules/%s' %(SEASON))

        open('schedules/%s/%s.csv' % (SEASON, key), "w").write(page.read())

    print ''
    print ''


if __name__ == '__main__':
    main()

