#!/usr/bin/env python

"""
Takes a list of domains from the input and turns it into a letsencrypt-readable
domain.txt file.

Eg.
    a.foo.com
    b.foo.com
    c.bar.com
becomes
    foo.com a.foo.com b.foo.com
    bar.com c.bar.com
"""

import re
import sys


def aggregate_domains(domains):
    agg = {}
    for d in domains:
        m = re.search(r'([^.]+\.[^.]+)$', d)
        if m:
            root = m.group(1)
            if root not in agg:
                agg[root] = []
            if root != d:
                agg[root].append(d)
    return agg


if __name__ == '__main__':
    for base, domains in aggregate_domains([l.strip() for l in sys.stdin]).items():
        sys.stdout.write('%s %s\n' % (base, ' '.join(domains)))
