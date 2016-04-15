#!/usr/bin/python

a = [1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89]
b = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
s1 = set(a)
s2 = set(b)
print "s1 = ", s1
print "s2 = ", s2
c = list(s1 & s2)
print c