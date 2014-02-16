# !/usr/bin/env python
#

"""
Page to display buttons to initiate data loading functionality.
"""

#pylint: disable=E1101,C0103

import os
import jinja2
import webapp2

JINJA_ENV = jinja2.Environment(
 loader=jinja2.FileSystemLoader(os.path.dirname(__file__)),
 extensions=['jinja2.ext.autoescape'],
 autoescape=True)


class AdminHander(webapp2.RequestHandler):
    """
    Controller to display admin page
    """

    def get(self):
        """
        Display the admin page.
        """
        template = JINJA_ENV.get_template('admin.html')
        self.response.write(template.render())

app = webapp2.WSGIApplication([('/admin', AdminHander)], debug=True)
