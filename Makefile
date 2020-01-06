VERSION := $(shell git describe --tags)

install-tools:
	go get -u -v github.com/golang/dep/cmd/dep
	go get -u -v github.com/mitchellh/gox

install-deps:
	dep ensure

update-deps:
	dep ensure -update

gox: clean
	gox -verbose \
	-os="linux" \
	-arch="amd64" \
	-output="dist/{{.OS}}-{{.Arch}}/{{.Dir}}" . && \
	cd dist && \
	find * -type d -exec cp ../LICENSE {} \; && \
	find * -type d -exec cp ../README.md {} \; && \
	find * -type d -not -name "*windows*" -exec tar -zcf slack-dump-${VERSION}-{}.tar.gz {} \; && \
	find * -type d -name "*windows*" -exec zip -r slack-dump-${VERSION}-{}.zip {} \; && \
	cd ..

clean:
	rm -rf ./dist
