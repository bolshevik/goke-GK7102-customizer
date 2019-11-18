package main

import (
	"bytes"
	"encoding/binary"
	"flag"
	"fmt"
	"io"
	"log"
	"os"
)

func usage() {
	fmt.Fprintf(flag.NewFlagSet(os.Args[0], flag.ExitOnError).Output(), "Usage of %s:\n", os.Args[0])
	flag.PrintDefaults()
}

func main() {
	var inFile = flag.String("inFile", "", "Input file")
	var outFile = flag.String("outFile", "", "Input file")
	var bufferSize = flag.Int("bufferSize", 64, "Buffer size in KB")
	flag.Parse()

	if *inFile == "" && *outFile == "" {
		usage()
		return
	}

	fmt.Println("Reading: " + *inFile)
	fmt.Println("Writing: " + *outFile)

	in, err := os.Open(*inFile)
	if err != nil {
		log.Fatal(err)
		return
	}
	defer in.Close()

	out, err := os.OpenFile(*outFile, os.O_CREATE|os.O_TRUNC|os.O_WRONLY, 0600)
	if err != nil {
		log.Fatal(err)
		return
	}
	defer out.Close()

	*bufferSize = *bufferSize * 1024
	buffer := make([]byte, *bufferSize)
	for err == nil {
		var bytesread int
		bytesread, err = in.Read(buffer)

		reader := bytes.NewReader(buffer[:bytesread])
		bufferInt := make([]int32, bytesread/4)
		err := binary.Read(reader, binary.LittleEndian, bufferInt)
		if err != nil {
			fmt.Println("binary.Read failed:", err)
		}
		binary.Write(out, binary.BigEndian, bufferInt)
	}
	if err != io.EOF {
		fmt.Println(err)
	}
	fmt.Println("Done")
}
