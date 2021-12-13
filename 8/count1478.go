package main

import (
	"fmt"
)

func add1478(numbers [4]int, acc int) (int) {
	for _, v := range numbers {
		switch v {
			case 1, 4, 7, 8: acc += 1
		}
	}
	return acc
}

func main() {
	fmt.Println(readStdin(add1478))
}
