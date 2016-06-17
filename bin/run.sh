#!/bin/bash -

. /app/lib/common.sh

CHECK_BIN sed
CHECK_VAR DOVECOT_LDAP_HOSTS
CHECK_VAR DOVECOT_LDAP_BASE
CHECK_VAR DOVECOT_LDAP_AUTH_BIND_USERDN

MSG "Configuring Dovecot LDAP settings..."

sed -i -e "s/^auth_bind_userdn\ *=.*/auth_bind_userdn\ =\ ${DOVECOT_LDAP_AUTH_BIND_USERDN}/" \
	-e "s/^hosts\ *=.*/hosts\ =\ ${DOVECOT_LDAP_HOSTS}/" \
	-e "s/^base\ *=.*/base\ =\ ${DOVECOT_LDAP_BASE}/" \
	/etc/dovecot/dovecot-ldap.conf.ext

chown -R vmail:vmail /var/mail

MSG "Compiling filters..."
if [[ -e /var/lib/dovecot/sieve/before.d/spam.sieve ]]; then
	sievec /var/lib/dovecot/sieve/before.d/spam.sieve
fi

MSG "Updating CA certificates..."
if [[ "$(ls -A /usr/local/share/ca-certificates)" ]]; then
	update-ca-certificates
fi

MSG "Setting Spamassassin DB permissions..."
chmod -R 777 /var/lib/amavis/.spamassassin

MSG "Starting Dovecot..."

exec "$@"
