package main

import (
	"fmt"
	"log"
	"strings"
	"time"

	"github.com/rymdport/portal/filechooser"
)

func main() {
	var rules []filechooser.Rule
	var timestamp = time.Now().Format("2006-01-02-15-04-05")
	rules = append(rules, filechooser.Rule{Type: filechooser.GlobPattern, Pattern: "*.mp4"})
	options := filechooser.SaveFileOptions{
		CurrentFilter: &filechooser.Filter{
			Name:  "Videos",
			Rules: rules,
		},
		CurrentFolder: "/home/max/Videos/Recordings/",
		CurrentName:   fmt.Sprintf("recording-%s.mp4", timestamp),
	}

	files, err := filechooser.SaveFile("", "Select files", &options)

	if err != nil {
		log.Fatalln(err)
	}
	if len(files) == 0 {
		log.Fatalln("No File were selected")
	}

	var file = strings.Split(files[0], "file://")[1]
	fmt.Println(file)
}
