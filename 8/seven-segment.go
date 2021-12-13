package main

import(
	"bufio"
	"container/list"
	"fmt"
	"os"
	"strings"
)

func extractNumbers(input string) ([]string) {
	trimmed := strings.TrimSpace(input)
	return strings.Split(trimmed, " ")
}

func containsAllRunes(tested string, runes string) (bool) {
	for _, r := range runes {
		if !strings.ContainsRune(tested, r) {
			return false
		}
	}
	return true;
}

func findContaining(items *list.List, wanted string) (string) {
	for e := items.Front(); e != nil; e = e.Next() {
		v := e.Value
		if containsAllRunes(v.(string), wanted) {
			items.Remove(e)
			return v.(string)
		}
	}
	panic("string not found")
}

func filteredBy(original string, filter string) (string) {
	for _, r := range filter {
		original = strings.Replace(original, string(r), "", -1)
	}
	return original
}

func transliterable(a string, b string) (bool) {
	if len(a) != len(b) {
		return false
	}

	for _, r := range a {
		if !strings.ContainsRune(b, r) {
			return false
		}
	}

	return true
}

func getNumberMapping(input []string) (map[string]int) {
	numbers := make(map[string]int)
	count5 := list.New()
	count6 := list.New()
	var (
		one string
		four string
	)
	for _, v := range input {
		switch len(v) {
			case 2:
				numbers[v] = 1
				one = v
			case 3: numbers[v] = 7
			case 4:
				numbers[v] = 4
				four = v
			case 5: count5.PushFront(v)
			case 6: count6.PushFront(v)
			case 7: numbers[v] = 8
			default: panic("unknown number")
		}
	}

	numbers[findContaining(count6, four)] = 9
	numbers[findContaining(count5, one)] = 3

	fourWithoutOne := filteredBy(four, one)
	five := findContaining(count5, fourWithoutOne)
	numbers[five] = 5

	numbers[count5.Front().Value.(string)] = 2
	numbers[findContaining(count6, five)] = 6
	numbers[count6.Front().Value.(string)] = 0

	return numbers
}

func findTransliterable(mapping map[string]int, wanted string) (int) {
	for k, v := range mapping {
		if transliterable(k, wanted) {
			return v
		}
	}
	panic("no transliteration found for " + wanted + " in " + fmt.Sprint(mapping))
}

func computeNumbersFromString(input string) ([4]int) {
	inputs := strings.Split(input, "|")

	digitSignals := extractNumbers(inputs[0])
	digits := getNumberMapping(digitSignals)

	value := extractNumbers(inputs[1])
	var output [4]int
	for i, v := range value {
		output[i] = findTransliterable(digits, v)
	}
	return output
}

func main() {
	reader := bufio.NewReader(os.Stdin)
	sum1478 := 0
	for {
		input, err := reader.ReadString('\n')
		if (len(input) == 0) {
			break
		}
		if (err != nil) {
			panic(err)
		}
		for _, v := range computeNumbersFromString(input) {
			switch v {
				case 1, 4, 7, 8: sum1478 += 1
			}
		}
	}
	fmt.Println(sum1478)
}
