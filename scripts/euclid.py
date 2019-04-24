#! /usr/bin/env python3

def euclid(a, b):
    r0 = [a, 1, 0]
    r1 = [b, 0, 1]
    print(r0)
    print(r1)
    while r1[0] != 0:
        q = r0[0] // r1[0]
        rn = [x - q*y for x, y in zip(r0, r1)]

        r0 = r1
        r1 = rn
        print(r1)

    return r0

def gcd(a, b):
    return euclid(a, b)[0]

def inverse(a, n):
    r = euclid(a, n)
    if r[0] == 1:
        return r[1]
    return 0

print(euclid(1759, 550))
print(gcd(1759, 550))
print(inverse(1759, 550))




