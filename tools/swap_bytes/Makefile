FILENAME=swap_bytes
LDFLAGS=-ldflags="-s -w"
BFLAGS=-trimpath

all: $(FILENAME) $(FILENAME).arm

$(FILENAME): *.go
	go build $(BFLAGS) $(LDFLAGS) -o $(FILENAME) swap_bytes.go

$(FILENAME).arm: *.go
	GOOS=linux GOARCH=arm GOARM=6 go build $(BFLAGS) $(LDFLAGS) -o $(FILENAME).arm swap_bytes.go

linux: export GOOS=linux
linux: export GOARCH=amd64
linux: $(FILENAME)

windows: export GOOS=windows
windows: export GOARCH=amd64
windows: $(FILENAME)
	cp $(FILENAME) $(FILENAME).exe

clean:
	rm $(FILENAME) $(FILENAME).arm $(FILENAME).exe
