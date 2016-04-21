FROM chambana/base:latest

MAINTAINER Josh King <jking@chambana.net>

RUN apt-get -qq update

RUN apt-get install -y --no-install-recommends dovecot-core \
                                               dovecot-ldap \
                                               dovecot-imapd \
                                               dovecot-lmtpd \
                                               dovecot-sieve \
                                               dovecot-managesieved \
                                               spamassassin \
                                               dovecot-antispam \
                                               supervisor

RUN mkdir -p /etc/dovecot/conf.d
ADD files/dovecot/dovecot-ldap.conf.ext /etc/dovecot/dovecot-ldap.conf.ext
COPY files/dovecot/conf.d/* /etc/dovecot/conf.d/

ADD files/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 24 143 10143

## Add startup script.
ADD bin/init.sh /opt/chambana/bin/init.sh
RUN chmod 0755 /opt/chambana/bin/init.sh

CMD ["/opt/chambana/bin/init.sh"]
