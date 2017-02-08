#!/bin/bash

DHPARAM=/etc/ssl/certs/dhparam.pem
BASE=/srv/letsencrypt
OPTS="--config $BASE/config"

# Aggregate domains per root domain
python $BASE/aggregate_domains.py < $BASE/domains.list > $BASE/domains.txt
if [ $(cat $BASE/domains.txt | wc -l) -lt 1 ]; then
    echo "No domains to renew"
    exit 1
fi

# Run renewal command
/srv/.selfhost/letsencrypt.sh --cron $OPTS

cat $BASE/domains.txt | while read line; do
    DOMAINS=($line)
    ROOT=${DOMAINS[0]}

    # Create aggregate of {privkey,cert,chain,dhparam}
    cat $BASE/certs/$ROOT/{privkey,cert,chain}.pem $DHPARAM > $BASE/certs/$ROOT/aggregate.pem

    # Create symlinks to the root domain cert and aggregate copy for each domain
    [ ! -e $BASE/domains/$ROOT ] && ln -s $BASE/certs/$ROOT $BASE/domains/$ROOT
    for SUB in ${DOMAINS[@]:1}; do
        [ ! -e $BASE/domains/$SUB ] && ln -s $BASE/certs/$ROOT $BASE/domains/$SUB
        cp $BASE/certs/$ROOT/aggregate.pem $BASE/aggregates/$SUB.pem
    done
done
