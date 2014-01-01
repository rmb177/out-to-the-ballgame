#!/usr/bin/env python
#

"""
Controller to handle displaying the home page of the application.
"""
#pylint: disable=E1101,C0103

import webapp2

class MainHandler(webapp2.RequestHandler):
    """
    Class for handling the main page of the application
    """

    def get(self):
        """
        Display the main page of the application
        """
        self.response.write('Hello world!')


app = webapp2.WSGIApplication([('/', MainHandler)], debug=True)

