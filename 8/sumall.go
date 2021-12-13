package main

import (
	"fmt"
)

func sum(numbers [4]int, acc int) (int) {
	return acc + 1000 * numbers[0] + 100 * numbers[1] + 10 * numbers[2] + numbers[3]
}

func main() {
	fmt.Println(readStdin(sum))
}
