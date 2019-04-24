# Hide message in images

This tool provides basic functionality to hide a message in a image. Base image
can be in jpeg or png format, while output image is allways png.

## Usage

Run `./stegano.py -h` for help message.

### Encoding

`./stegano.py encode -s <source-image> -m <message> -d <output-image>`

### Decoding

`./stegano.py decode -s <source-image>`

### Creating a blank image

`./stegano.py create` creates an empty image to quickly test the tool.
