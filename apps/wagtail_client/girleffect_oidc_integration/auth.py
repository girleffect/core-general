"""
This package contains customisations specific to the Girl Effect project.
The technical background can be found here:
https://mozilla-django-oidc.readthedocs.io/en/stable/installation.html#additional-optional-configuration
"""
import logging
import unicodedata
from mozilla_django_oidc.auth import OIDCAuthenticationBackend

# Connecting OIDC user identities to Django users
# By default, mozilla-django-oidc looks up a Django user matching the email
# field to the email address returned in the user info data from the OIDC
# provider. This means that no two users in the Django user table can have the
# same email address. Since the email field is not unique, it’s possible that
# this can happen. Especially if you allow users to change their email address.
# If it ever happens, then the users in question won’t be able to authenticate.
#
# If you want different behavior, subclass the
# mozilla_django_oidc.auth.OIDCAuthenticationBackend class and override the
# filter_users_by_claims method.

UUID_FIELD = "username"
EMAIL_FIELD = "email"
MSISDN_FIELD = "msisdn"

LOGGER = logging.getLogger(__name__)


class GirlEffectOIDCBackend(OIDCAuthenticationBackend):

    def filter_users_by_claims(self, claims):
        """
        The default behaviour is to look up users based on their email
        address. However, in the Girl Effect ecosystem the email is optional,
        so we prefer to use the UUID associated with the user profile (
        subject identifier)
        :return: A user identified by the claims, else None
        """
        uuid = claims.get("sub")
        assert uuid
        try:
            kwargs = {UUID_FIELD: uuid}
            return [self.UserModel.objects.get(**kwargs)]
        except self.UserModel.DoesNotExist:
            print("Lookup failed based on {}".format(kwargs))
            LOGGER.debug("Lookup failed based on {}".format(kwargs))

        email = claims.get("email", None)
        if email:
            try:
                kwargs = {EMAIL_FIELD: email}
                return [self.UserModel.objects.get(**kwargs)]
            except self.UserModel.DoesNotExist:
                print("Lookup failed based on {}".format(kwargs))
                LOGGER.debug("Lookup failed based on {}".format(kwargs))

        return self.UserModel.objects.none()

    def create_user(self, claims):
        """
        In addition to the limited fields that are populated in the user
        profile, we can set some more in this function.
        """
        user = super(GirlEffectOIDCBackend, self).create_user(claims)

        user.username = claims.get("sub")
        user.first_name = claims.get("given_name", "")
        user.last_name = claims.get("family_name", "")

        return user

    def verify_claims(self, claims):
        """
        This function can be used to prevent authorisation of users based
        on claims information.
        """
        verified = super(GirlEffectOIDCBackend, self).verify_claims(claims)
        # Example of how to prevent users without a verified email from
        # logging in.
        # verified = verified and claims.get("email_verified")
        return verified

# If a user logs into your site and doesn’t already have an account,
# by default, mozilla-django-oidc will create a new Django user account. It will
# create the User instance filling in the username (hash of the email address)
# and email fields.
#
# If you want something different, set settings.OIDC_USERNAME_ALGO to a Python
# dotted path to the function you want to use.
#
# The function takes in an email address as a text (Python 2 unicode or Python
# 3 string) and returns a text (Python 2 unicode or Python 3 string).
#
# Here’s an example function for Python 3 and Django 1.11 that doesn’t convert
# the email address at all:


def generate_username(email):
    # Using Python 3 and Django 1.11, usernames can contain alphanumeric
    # (ascii and unicode), _, @, +, . and - characters. So we normalize
    # it and slice at 150 characters.
    return unicodedata.normalize('NFKC', email)[:150]

