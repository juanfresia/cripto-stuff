#! /usr/bin/env python3

def euclid(a, b, show=False):
    r0 = [a, 1, 0]
    r1 = [b, 0, 1]
    if show: print(r0)
    if show: print(r1)
    while r1[0] != 0:
        q = r0[0] // r1[0]
        rn = [x - q*y for x, y in zip(r0, r1)]

        r0 = r1
        r1 = rn
        if show: print(r1)

    return r0

def gcd(a, b):
    return euclid(a, b)[0]

def inverse(a, n):
    r = euclid(a, n)
    if r[0] == 1:
        return r[1]
    return 0

print("euclid(1759, 550)")
print(euclid(1759, 550, show=True))

print()
print("gcd(1759, 550) = ", gcd(1759, 550))

print()
print("inverse_550(1759) =", inverse(1759, 550))

