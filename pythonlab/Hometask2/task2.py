#!/usr/bin/python

str1 = raw_input("enter word ")

def check_palindrome(str1):
    if str1 == str1[::-1]:
       return "is palindrome"
    else:
       return "not a palindrome"

print check_palindrome(str1)