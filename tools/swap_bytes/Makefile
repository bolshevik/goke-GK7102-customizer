FILENAME=swap_bytes
LDFLAGS=-ldflags="-s -w"
BFLAGS=-trimpath

.PHONY: all
all: $(FILENAME).arm $(FILENAME) $(FILENAME).exe

$(FILENAME): *.go
	go build $(BFLAGS) $(LDFLAGS) -o $(FILENAME) $<

$(FILENAME).arm: *.go
	GOOS=linux GOARCH=arm GOARM=6 go build $(BFLAGS) $(LDFLAGS) -o $(FILENAME).arm $<

$(FILENAME).exe: *.go
	GOOS=windows GOARCH=amd64 go build $(BFLAGS) $(LDFLAGS) -o $(FILENAME).exe $<

.PHONY: linux
linux: export GOOS=linux
linux: export GOARCH=amd64
linux: $(FILENAME)

.PHONY: clean
clean:
	rm -f $(FILENAME) $(FILENAME).arm $(FILENAME).exe
