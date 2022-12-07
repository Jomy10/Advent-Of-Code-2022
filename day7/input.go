package main

import (
	"strconv"
	"strings"
)

func parseInput(input string) TreeElement {
	var output TreeElement = TreeElement{
		name: "/",
		// contents: []TreeElement{},
		ty: 0,
		elem: TreeElementUnion{
			size:     0,
			contents: []TreeElement{},
		},
	}
	var walk []*TreeElement = []*TreeElement{&output}
	for _, line := range strings.Split(input, "\n") {
		switch line[0] {
		case '$':
			// command
			switch line[2] {
			case 'c':
				// cd
				arg := line[5:]
				if arg == "/" {
					walk = walk[0:1]
				} else if arg == ".." {
					walk = walk[:len(walk)-1]
				} else {
					walk = append(walk, findElemInDir(walk[len(walk)-1], arg))
				}
			case 'l':
				// ls
			}
		case 'd':
			// Directory
			walk[len(walk)-1].elem.contents = append(walk[len(walk)-1].elem.contents, TreeElement{
				name: line[4:],
				ty:   0,
				elem: TreeElementUnion{
					size:     0,
					contents: []TreeElement{},
				},
			})
		default:
			// File
			inSplit := strings.Split(line, " ")
			size, err := strconv.Atoi(inSplit[0])
			if err != nil {
				panic("Invalid size for file")
			}
			walk[len(walk)-1].elem.contents = append(walk[len(walk)-1].elem.contents, TreeElement{
				name: inSplit[1],
				ty:   1,
				elem: TreeElementUnion{
					size:     size,
					contents: []TreeElement{},
				},
			})
		}
	}

	return output
}