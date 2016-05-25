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
                                               sudo \
                                               supervisor && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV DOVECOT_LDAP_HOSTS ldap:389

VOLUME ["/var/mail"]

RUN useradd -r -u 993 -U -G mail -M -d /var/mail -s /usr/sbin/nologin vmail

RUN mkdir -p /etc/dovecot/conf.d
ADD files/dovecot/dovecot-ldap.conf.ext /etc/dovecot/dovecot-ldap.conf.ext
ADD files/dovecot/sieve/spam.sieve /var/lib/dovecot/sieve/before.d/spam.sieve
COPY files/dovecot/conf.d/* /etc/dovecot/conf.d/

ADD files/spamassassin/local.cf /etc/spamassassin/local.cf

ADD files/supervisor/supervisord.conf /etc/supervisor/supervisord.conf

EXPOSE 24 143 10143

## Add sa-learn wrapper script.
ADD bin/sa-learn-wrapper.sh /usr/bin/sa-learn-wrapper.sh
RUN chown root:root /usr/bin/sa-learn-wrapper.sh
RUN chmod 0700 /usr/bin/sa-learn-wrapper.sh

## Add startup script.
ADD bin/init.sh /app/bin/init.sh
RUN chmod 0755 /app/bin/init.sh

CMD ["/app/bin/init.sh"]
