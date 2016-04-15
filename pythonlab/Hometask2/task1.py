#!/usr/bin/python


# uncomment appropriate lines, then try to run

l1 = [1, 2, 3, 4]
l2 = ['a','b','c']

#l1 = [1, 2, 3]
#l2 = ['a','b','c','d']


#l1 = list(input("enter keys "))
#l2 = list(input("enter values "))

print "l1 = ", l1[:]
print "l2 = ", l2[:]

def merge(list1, list2):
    dict = {}
    for i in range(len(list1)):
        if i >= len(list2):
            dict[list1[i]] = None
        else:
            dict[list1[i]] = list2[i]
    return dict


print "dict0 = ", merge(l1, l2)