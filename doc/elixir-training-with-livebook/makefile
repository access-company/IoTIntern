UID := $(shell id -u)
GID := $(shell id -g)
PWD := $(shell pwd)

.PHONY: run
run:
	docker run -p 8888:8888 -p 8889:8889 --pull always -u $(UID):$(GID) -v $(PWD)/notebooks:/data -e LIVEBOOK_PORT="8888" -e LIVEBOOK_IFRAME_PORT="8889" ghcr.io/livebook-dev/livebook:0.9.2
