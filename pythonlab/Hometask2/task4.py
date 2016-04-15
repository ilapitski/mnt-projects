#!/usr/bin/python

from collections import Counter
with open('apache_access.log') as inputfile:
    count = Counter(line.split('- -', 1)[0].rstrip() for line in inputfile)

for ip in count.most_common(10):
    print(ip)

