"""
This package contains customisations specific to the Girl Effect project.
The technical background can be found here:
https://mozilla-django-oidc.readthedocs.io/en/stable/installation.html#additional-optional-configuration
"""
import logging
from mozilla_django_oidc.auth import OIDCAuthenticationBackend

USERNAME_FIELD = "username"
EMAIL_FIELD = "email"

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
        uuid = claims["sub"]
        try:
            kwargs = {USERNAME_FIELD: uuid}
            return [self.UserModel.objects.get(**kwargs)]
        except self.UserModel.DoesNotExist:
            LOGGER.debug("Lookup failed based on {}".format(kwargs))

        # The code below is an example of how we can perform a secondary check
        # on the email address.
        # email = claims.get("email")
        # if email:
        #     try:
        #         kwargs = {EMAIL_FIELD: email}
        #         return [self.UserModel.objects.get(**kwargs)]
        #     except self.UserModel.DoesNotExist:
        #         LOGGER.debug("Lookup failed based on {}".format(kwargs))

        return self.UserModel.objects.none()

    def create_user(self, claims):
        """Return object for a newly created user account.
        The default OIDC client create_user() function expects an email address
        to be available. This is not the case for Girl Effect accounts, where
        the email field is optional.
        We use the user id (called the subscriber identity in OIDC) as the
        username, since it is always available and guaranteed to be unique.
        """
        username = claims["sub"]  # The sub field _must_ be in the claims.
        email = claims.get("email")  # Email is optional

        return self.UserModel.objects.create_user(username, email)

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
