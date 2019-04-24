#! /usr/bin/env python3

class RC4:
    def __init__(self, key):
        self.key = key
        self.__init_state()

    def __init_state(self):
        self.S = [i for i in range(256)]
        self.i = 0
        self.j = 0

        j = 0
        for i in range(256):
            j = j + self.S[i] + ord(key[i % len(key)])
            j = j % 256
            tmp = self.S[i]
            self.S[i] = self.S[j]
            self.S[j] = tmp

    def reset(self):
        self.__init_state()

    def next_byte(self):
        self.i = (self.i + 1) % 256
        self.j = (self.j + self.S[self.i]) % 256

        tmp = self.S[self.i]
        self.S[self.i] = self.S[self.j]
        self.S[self.j] = tmp

        return self.S[(self.S[self.i] + self.S[self.j]) % 256]

    def next_byte_stream(self):
        yield self.next_byte()

    def first_bytes(self, n):
        for _ in range(n):
            yield self.next_byte()

    def encode(self, str):
        ret = ''
        for c in str:
            a = ord(c)
            b = self.next_byte()
            ret += chr(a ^ b)
        return ret

    def decode(self, str):
        return self.encode(str)


def string_to_hexa(str):
    return ''.join(format(ord(c), '02x') for c in str)

key = "Key"
msg = "Plaintext"

print("Key: ", key)
print("Message:", msg)

rc4 = RC4(key)
stream_str = [chr(x) for x in rc4.first_bytes(20)]
print("First 20 bytes of stream (hex):", string_to_hexa(stream_str))

rc4.reset()
ciphertext = rc4.encode(msg)
print("Ciphertext (hex):", string_to_hexa(ciphertext))

rc4.reset()
plaintext = rc4.decode(ciphertext)
print("Restrored plaintext:", plaintext)

