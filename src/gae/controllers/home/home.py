#!/usr/bin/env python
#

"""
Controller to handle displaying the home page of the application.
"""
#pylint: disable=C0103, E1101

import os
import jinja2
import webapp2

JINJA_ENV = jinja2.Environment(
 loader=jinja2.FileSystemLoader(os.path.dirname(__file__)),
 extensions=['jinja2.ext.autoescape'],
 autoescape=True)

class HomeHandler(webapp2.RequestHandler):
    """
    Class for handling the main page of the application
    """

    def get(self):
        """
        Display the main page of the application
        """
        template = JINJA_ENV.get_template('home.html')
        self.response.write(template.render())

app = webapp2.WSGIApplication([('/', HomeHandler)], debug=True)

