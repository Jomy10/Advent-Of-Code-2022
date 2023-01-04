package main

import (
	"fmt"
	"os"
)

func main() {
	data, err := os.ReadFile("./input.txt")
	if err != nil {
		panic(err)
	}
	rootDir := parseInput(string(data))

	dirs := collectSubDirectories(&rootDir)
	dirs = append(dirs, &rootDir)
	dirSizes := []int{}
	for _, dir := range dirs {
		dirSizes = append(dirSizes, calcDirSize(dir))
	}

	// Part 1
	maxSize := 100000
	totalPart1 := 0
	for _, size := range dirSizes {
		if size < maxSize {
			totalPart1 += size
		}
	}

	fmt.Printf("Part 1: %d\n", totalPart1)

	// Part 2
	totalDisk := 70000000
	neededSpace := 30000000
	totalSpaceUsed := calcDirSize(&rootDir)
	currentUnusedSpace := totalDisk - totalSpaceUsed

	requiredToBeFreed := neededSpace - currentUnusedSpace

	currentSmallestSize := totalSpaceUsed
	for _, size := range dirSizes {
		if size >= requiredToBeFreed {
			if size < currentSmallestSize {
				currentSmallestSize = size
			}
		}
	}

	fmt.Printf("Part 2: %d\n", currentSmallestSize)
}

type TreeElement struct {
	name string
	ty   uint8
	elem TreeElementUnion
}

type TreeElementUnion struct {
	size     int
	contents []TreeElement
}

func findElemInDir(dir *TreeElement, name string) *TreeElement {
	for idx, item := range dir.elem.contents {
		if item.name == name {
			return &dir.elem.contents[idx]
		}
	}

	return nil
}

// Returns an array containing all directories inside of this directory and all
// directorries inside of its subdirectories
func collectSubDirectories(dir *TreeElement) []*TreeElement {
	dirs := []*TreeElement{}
	for idx, elem := range dir.elem.contents {
		if elem.ty == 0 {
			dirs = append(dirs, &dir.elem.contents[idx])
			dirs = append(dirs, collectSubDirectories(&elem)...)
		}
	}
	return dirs
}

// Calculates the total size of a directory
func calcDirSize(dir *TreeElement) int {
	totalSize := 0
	for _, elem := range dir.elem.contents {
		if elem.ty == 0 {
			totalSize += calcDirSize(&elem)
		} else {
			// File
			totalSize += elem.elem.size
		}
	}
	return totalSize
}
