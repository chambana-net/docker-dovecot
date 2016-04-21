#!/bin/bash -

. /opt/chambana/lib/common.sh

CHECK_BIN sed
CHECK_VAR DOVECOT_LDAP_URIS
CHECK_VAR DOVECOT_LDAP_BASE
CHECK_VAR DOVECOT_LDAP_AUTH_BIND_USERDN

MSG "Configuring Dovecot LDAP settings..."

sed -i -e "s/^auth_bind_userdn\ =\ .*/auth_bind_userdn\ =\ ${DOVECOT_LDAP_AUTH_BIND_USERDN}/" \
	-e "s/^uris\ =\ .*/uris\ =\ ${DOVECOT_LDAP_URIS}/" \
	-e "s/^base\ =\ .*/base\ =\ ${DOVECOT_LDAP_AUTH_BIND_USERDN}/" \
	/etc/dovecot/dovecot-ldap.conf.ext

supervisord -c /etc/supervisor/supervisord.conf 
