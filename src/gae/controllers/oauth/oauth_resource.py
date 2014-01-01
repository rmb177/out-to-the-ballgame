#!/usr/bin/env python
#

"""
Simple handler for an OAuth feature.

The process for creating an OAuth provider for GAE is here:
  http://ikaisays.com/2011/05/26/setting-up-an-oauth-provider-on-google-app-engine/
"""

# pylint: disable=C0103


from google.appengine.api import oauth

UNAUTHORIZED_MSG = "You are not authorized to access this page."

def requires_oauth_admin(fn):
    """
    Decorator to make sure user accessing url is authorized
    """
    def wrapped(self):
        """
        Wrapper method to do the authentication check
        """
        if oauth.is_current_user_admin():
            fn(self)
        else:
            self.response.out.write(UNAUTHORIZED_MSG)
            self.response.set_status(404)

    return wrapped
