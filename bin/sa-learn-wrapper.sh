#!/bin/bash - 

chmod 0777 /var/lib/amavis/.spamassassin/*

sudo -u vmail -g vmail /usr/bin/sa-learn $@
