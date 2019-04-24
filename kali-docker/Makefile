IMAGE_NAME:=cripto-kali

image:
	docker build -t $(IMAGE_NAME) .
.PHONY: image

run: image
	docker run --rm -it --net=host --privileged $(IMAGE_NAME) /bin/bash
.PHONY: run
