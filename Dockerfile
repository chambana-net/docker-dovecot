FROM chambana/base:latest

MAINTAINER Josh King <jking@chambana.net>

RUN apt-get -qq update && \
    apt-get install -y --no-install-recommends dovecot-core \
                                               dovecot-ldap \
                                               dovecot-imapd \
                                               dovecot-lmtpd \
                                               dovecot-sieve \
                                               dovecot-managesieved \
                                               spamassassin \
                                               dovecot-antispam \
                                               cron \
                                               supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV DOVECOT_LDAP_HOSTS ldap:389

RUN useradd -r -u 993 -U -G mail -M -d /var/mail -s /usr/sbin/nologin vmail

RUN mkdir -p /etc/dovecot/conf.d
ADD files/dovecot/dovecot-ldap.conf.ext /etc/dovecot/dovecot-ldap.conf.ext
ADD files/dovecot/sieve/spam.sieve /var/lib/dovecot/sieve/before.d/spam.sieve
COPY files/dovecot/conf.d/* /etc/dovecot/conf.d/

ADD files/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 24 143 10143

## Add startup script.
ADD bin/init.sh /opt/chambana/bin/init.sh
RUN chmod 0755 /opt/chambana/bin/init.sh

CMD ["/opt/chambana/bin/init.sh"]
