OpenID Connect
==============

A brief look at OpenID Connect. For more information, see the source list.

What is OpenID Connect?
-----------------------

OpenID Connect (OIDC) is a simple mechanism based on the OAuth 2.0
specification, to allow a client application to contact an identity
provider (IP) in order verify the identities of end-users through
authentication by the Authentication Server, and obtain details of
authenticated sessions and end-users (Connect2id.com, 2018).

OIDC has a lot of the same details that OAuth has, such as the *client_id*, *client_secret*, and *redirect_uri*,
that is stored by the IP to ensure that the information is sent back to the correct client application. This
prevents someone from stealing the *client_id* and using it to have information sent to their own URI (Offenhartz, 2017).


How does OIDC work?
-------------------
An example of a web-based OIDC flow (Auth0, 2018):

1. A client app (Relying Party) sends and authorization request to the Identity Provider (e.g. Google, Facebook, GE Authentication Service).
2. The Identity Provider authenticates the credentials or provides a login screen to the end-user, and asks for authorization (or consent).
3. Once authorized, the Identity Provider sends an access token and an ID token back to the Relying Party.
4. The Relying Party can then use the access token to invoke the services of the Identity Provider.

.. figure:: first_time_authentication.png
    :align: center

    OIDC web-based flow.

Access Tokens
-------------
Access Tokens are used to communicate to the API that the bearer of the
token have been authorized to access the API and perform actions that
are permitted by the custom scope of the API (Auth0, 2018).

ID Tokens
---------
An ID token contains identity data such as the user's name and email. The data is consumed
by the client application and is typically used for UI display. These tokens conform to the RFC 7519
standard for JSON Web Tokens and must contain 3 parts: a header, a body and a signature (Auth0, 2018).

JSON Web Token (JWT)
--------------------
JSON Web Tokens allows for secure transmission of information between parties as a JSON object. The
information is digitally signed, using either a secret or a public/private key pair. Therefor
the information can be trusted and verified (Jwt.io, 2018).

**An encoded JWT:** - in the form *x.y.z*

.. code-block:: python

    eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibm
    FtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.XbPfbIHMI6arZ3Y922BhjWg
    QzWXcXNrz0ogtVhfEd2o

can be decoded into three parts:

**Header (x)** - Algorithm & Token Type

.. code-block:: JSON

    {
        "alg": "HS256",
        "typ": "JWT"
    }

**Body (y)** - Data

.. code-block:: JSON

    {
        "sub": "1234567890",
        "name": "John Doe",
        "iat": 1516239022
    }

**Signature (z)** - Gets verified by doing

.. code-block:: python

    HMACSHA256(
        base64UrlEncode(header) + "." +
        base64UrlEncode(payload),
        secret
    )

OIDC in Girl Effect
-------------------

**Django OIDC Provider:**

    The Girl Effect Authentication Service uses the Django OIDC Provider library to perform all OIDC related tasks and makes use
    of the Django OIDC Provider models to create clients, etc. The Django OIDC Provider can be found here: https://github.com/juanifioren/django-oidc-provider

**Mozilla Django OIDC:**

    Mozilla Django OIDC is used by other Django apps to integrate with the OIDC enabled Authentication Service on Girl Effect. Other
    libraries can/should be used for other types of apps. Mozilla Django OIDC can be found here: https://github.com/mozilla/mozilla-django-oidc

**Wagtail implementation:**

    An example of a wagtail app using OIDC and the Girl Effect Authentication service can be found here:
    https://github.com/girleffect/core-integration-demo/tree/develop/girleffect_oidc_integration

Sources
-------
Auth0. (2018). OpenID Connect. [online] Available at: https://auth0.com/docs/protocols/oidc [Accessed 22 Mar. 2018].

Offenhartz, J. (2017). OpenID Connect explained in plain English.
[Blog] Available at: https://www.onelogin.com/blog/openid-connect-explained-in-plain-english [Accessed 22 Mar. 2018].

Connect2id.com. (2018). OpenID Connect explained | Connect2id. [online] Available at: https://connect2id.com/learn/openid-connect [Accessed 23 Mar. 2018].

Jwt.io. (2018). JWT.IO - JSON Web Tokens Introduction. [online] Available at: https://jwt.io/introduction/ [Accessed 26 Mar. 2018].