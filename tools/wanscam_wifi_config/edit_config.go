package main

import (
	"encoding/binary"
	"flag"
	"fmt"
	"log"
	"os"
	"strings"
	"unsafe"
)

type WifiConfig struct { // 101 byte
	Index    byte
	Flags    [4]byte //first byte must be 4
	Password [44]byte
	Padding1 [20]byte
	Ssid     [32]byte
}

type Config struct {
	ConfigIndex byte
	Configs     [5]WifiConfig
	Zero        byte
}

func string2bytes(s string, b []byte) {
	tmp := []byte(s + "\x00")
	for i := range tmp {
		b[i] = tmp[i]
	}
}

func (config *WifiConfig) SetConfig(index byte, ssid string, password string) {
	config.ResetConfig()
	config.Index = index
	config.Flags[0] = 4
	string2bytes(ssid, config.Ssid[:])
	string2bytes(password, config.Password[:])
}

func (config *WifiConfig) ResetConfig() {
	config.Index = 1
	for i := range config.Flags {
		config.Flags[i] = 0
	}
	for i := range config.Password {
		config.Password[i] = 0
	}
	for i := range config.Padding1 {
		config.Padding1[i] = 0
	}
	for i := range config.Ssid {
		config.Ssid[i] = 0
	}
}

func usage() {
	fmt.Fprintf(flag.NewFlagSet(os.Args[0], flag.ExitOnError).Output(), "Usage of %s:\n", os.Args[0])
	flag.PrintDefaults()
}

func printConfig(config *Config) {
	fmt.Println("Current Index: ", (*config).ConfigIndex)
	for i := 0; i < 5; i++ {
		wifiConfig := (*config).Configs[i]
		fmt.Println("---------------")
		fmt.Println("Index: ", wifiConfig.Index)

		data := binary.LittleEndian.Uint32(wifiConfig.Flags[:])
		fmt.Println("Flags: ", data)

		ssid := string(wifiConfig.Ssid[:])
		nullIndex := strings.Index(ssid, "\x00")
		fmt.Println("SSID: ", ssid[:nullIndex])

		password := string(wifiConfig.Password[:])
		nullIndex = strings.Index(password, "\x00")
		fmt.Println("Password: ", password[:nullIndex])
	}
}

func main() {
	var configFile = flag.String("config", "", "Config file")
	var reset = flag.Int("reset", -1, "Reset entry")
	var index = flag.Int("index", -1, "Change index")
	var ssid = flag.String("ssid", "", "SSID to set")
	var password = flag.String("password", "", "Password to set")
	var current = flag.Int("current", -1, "Set current entry")
	flag.Parse()

	if *configFile == "" {
		usage()
		return
	}

	configFd, err := os.OpenFile(*configFile, os.O_RDWR|os.O_CREATE, 0600)
	if err != nil {
		log.Fatal(err)
		return
	}
	defer configFd.Close()

	var configuration Config
	writeOut := false

	err = binary.Read(configFd, binary.LittleEndian, &configuration)

	if *reset != -1 {
		if *reset >= 0 && *reset <= 5 {
			configuration.Configs[*reset].ResetConfig()
			writeOut = true
		} else {
			fmt.Println("reset should be >= 0 and <=5")
		}
	}

	if *current != -1 {
		if *current >= 0 && *current <= 5 {
			configuration.ConfigIndex = byte(*current)
			writeOut = true
		} else {
			fmt.Println("current should be >= 0 and <=5")
		}
	}

	if *index != -1 {
		if *index >= 0 && *index <= 5 {
			if *ssid == "" || *password == "" {
				fmt.Println("ssid and password must not be empty")
			} else {
				configuration.Configs[*index].SetConfig(byte(*index), *ssid, *password)
				writeOut = true
			}
		} else {
			fmt.Println("index should be >= 0 and <=5")
		}
	}

	printConfig(&configuration)

	if writeOut {
		configFd.Seek(0, 0)
		configFd.Truncate(int64(unsafe.Sizeof(configuration)))
		err = binary.Write(configFd, binary.LittleEndian, &configuration)
	}
}
