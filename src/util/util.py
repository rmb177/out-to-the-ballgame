#!/usr/bin/env python
# encoding: utf-8

"""
A module to provide some utility functions used in
multiple places.
"""

import sys

def print_progress_dot():
    """
    Print a dot to the terminal
    """
    sys.stdout.write(".")
    sys.stdout.flush()

