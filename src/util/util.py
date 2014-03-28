#!/usr/bin/env python
# encoding: utf-8

"""
Module to provide some utility functions
"""


import sys

def print_progress_dot():
    """
    Print a dot to the terminal
    """
    sys.stdout.write(".")
    sys.stdout.flush()

