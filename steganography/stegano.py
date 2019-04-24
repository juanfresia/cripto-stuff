#! /usr/bin/env python3
"""
CLI tool to encode and decode messages into images.
It uses the last bit of the red channel to encode the message.
"""

import argparse
import os

# pip3 install Pillow
from PIL import Image

def create_white_image(destination):
    image = Image.new('RGB', (100, 100), (254, 255, 255))
    image.save(destination, "PNG")


class BitStream():
    def __init__(self, message):
        self.msg = message
        self.cur = 0
        self.next_bit = 0

    def next(self):
        if self.cur >= len(self.msg):
            return -1

        cur_char = ord(self.msg[self.cur])
        bit = ((cur_char >> self.next_bit) & 0x1)
        self.next_bit = (self.next_bit + 1) % 8
        if self.next_bit == 0:
            self.cur += 1

        return bit

    def get_length_bits(self):
        msg_len = len(self.msg)
        bits = []
        for i in range(32):
            bits += [(msg_len >> i) & 0x1]

        return bits

    def stream(self):
        for i in self.get_length_bits():
            yield i

        while True:
            bit = self.next()
            if bit == -1:
                break
            yield bit

def tuple_gen(h, w):
    for i in range(h):
        for j in range(w):
            yield(i, j)

def encode_in_pix(pix, b):
    r = (pix[0] & 0xfe) | b
    b = pix[1]
    g = pix[2]
    return (r, g, b)

def decode_in_pix(h, w, pix):
    for (i, j) in tuple_gen(h, w):
        yield pix[i, j][0] & 0x1

def encode(base_img_path, msg_str, target_img):
    image = Image.open(base_img_path)
    total_bytes = image.size[0] * image.size[1]

    # We account for one pixel per bit of message
    # plus 32 bits to encode size
    if total_bytes < (len(msg_str) * 8 + 32):
        image.close()
        print("The image is not large enough to hide message")
        return

    pix = image.load()
    msg = BitStream(msg_str)

    for b, (i, j) in zip(msg.stream(), tuple_gen(*image.size)):
        pix[i, j] = encode_in_pix(pix[i, j], b)

    image.save(target_img, "PNG")
    image.close()

def decode(base_img_path):
    image = Image.open(base_img_path)
    size = image.size
    pix = image.load()

    bits = decode_in_pix(*size, pix)
    length = 0
    for i in range(32):
        length += next(bits) << i
    print("Message length: ", length)

    msg = ''
    cur_char = 0
    for i in range(length * 8):
        cur_char += next(bits) << (i % 8)
        if (i % 8) == 7:
            msg += chr(cur_char)
            cur_char = 0

    image.close()
    return msg


class FullPaths(argparse.Action):
    """Expand user- and relative-paths"""
    def __call__(self, parser, namespace, values, option_string=None):
        setattr(namespace, self.dest,
                os.path.abspath(os.path.expanduser(values[0])))

if __name__ == "__main__":
    # Set arguments
    CURDIR = os.getcwd()
    DST_DEFAULT = CURDIR + "/image-secret.png"

    cli_parser = argparse.ArgumentParser(description='Hide and reveal hidden messages in images.')
    subparsers = cli_parser.add_subparsers(dest="subcommand")
    subparsers.required = True

    parser_encode = subparsers.add_parser('encode', help='encode message into image')
    parser_encode.add_argument('-d', '--destination', metavar='destination', nargs=1,
                               help='destination image', default=DST_DEFAULT, action=FullPaths)
    parser_encode.add_argument('-m', '--message', metavar='language', nargs=1,
                               help='message to hide', required=True)
    parser_encode.add_argument('-s', '--source', metavar='source', nargs=1,
                               help='source image', required=True, action=FullPaths)

    parser_decode = subparsers.add_parser('decode', help='decode message from image')
    parser_decode.add_argument('-s', '--source', metavar='source', nargs=1,
                               help='source image', required=True, action=FullPaths)

    parser_create = subparsers.add_parser('create', help='create an empty 100x100 image')
    parser_create.add_argument('-d', '--destination', metavar='destination', nargs=1,
                               help='destination image', default=DST_DEFAULT, action=FullPaths)

    # Parse and log captured arguments
    args = cli_parser.parse_args()

    if args.subcommand == "encode":
        encode(args.source, args.message[0], args.destination)
    elif args.subcommand == "decode":
        print(decode(args.source))
    else:
        create_white_image(args.destination)
