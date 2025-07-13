package main

import (
	"fmt"
	"github.com/rymdport/portal/filechooser"
	"log"
	"os"
	"strings"
	"time"
)

func main() {
	var home_dir = os.Getenv("HOME")
	var rules []filechooser.Rule
	var timestamp = time.Now().Format("2006-01-02-15-04-05")
	rules = append(rules, filechooser.Rule{Type: filechooser.GlobPattern, Pattern: "*.mp4"})
	options := filechooser.SaveFileOptions{
		CurrentFilter: &filechooser.Filter{
			Name:  "Videos",
			Rules: rules,
		},
		CurrentFolder: fmt.Sprintf("%s/Videos/Recordings/", home_dir),
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
