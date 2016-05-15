docker-dovecot
==============
Docker container for the Dovecot IMAP server.

Usage
-----
This container runs Dovecot with the dovecot-antispam plugin. It is designed to use an LDAP server for user lookup. *This container is designed to operate as part of a set in the Chambana.net email system, and supports limited configurability.* Consequently, it makes certain assumptions, such as the structure of the LDAP directory and the presence of LetsEncrypt certificates. For more detailed setup instructions, see https://github.com/chambana-net/docker-postfix

The container has the following environment variables for configuration:
* `DOVECOT_LDAP_URIS`: The ldap:// URIs where you can reach the LDAP directory(s).
* `DOVECOT_LDAP_BASE`: The base DN in which to do user lookups.
* `DOVECOT_LDAP_AUTH_BIND_USERDN`: The pattern that user accounts have in the directory. For example, `uid=%n,cn=users,cn=accounts,dc=example,dc=com`
