#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct DiagnosticValue {
    char *value;
    bool mostCommonTestFailed;
    bool leastCommonTestFailed;
    struct DiagnosticValue *next;
} DiagnosticValue;

DiagnosticValue* newDiagnosticValue(char *buffer, long length) {
    DiagnosticValue *self = (DiagnosticValue *)calloc(1, sizeof(DiagnosticValue));

    size_t size = (length + 1) * sizeof(char);
    self->value = (char*)malloc(size);
    memcpy(self->value, buffer, size);
    
    return self;
}

DiagnosticValue* append(DiagnosticValue *self, char *buffer, long length) {
    self->next = newDiagnosticValue(buffer, length);
    return self->next;
}

char getMostCommonAtPosition(DiagnosticValue *self, long position) {
    int oneCount = 0;
    int zeroCount = 0;
    while(self) {
        if (!self->mostCommonTestFailed) {
            if (self->value[position] == '0')
                zeroCount += 1;
            else
                oneCount += 1;
        }
        self = self->next;
    }
    return oneCount >= zeroCount ? '1' : '0';
}

char getLeastCommonAtPosition(DiagnosticValue *self, long position) {
    int oneCount = 0;
    int zeroCount = 0;
    while(self) {
        if (!self->leastCommonTestFailed) {
            if (self->value[position] == '0')
                zeroCount += 1;
            else
                oneCount += 1;
        }
        self = self->next;
    }
    return zeroCount <= oneCount ? '0' : '1';
}

typedef struct SearchResults {
    int mostCommonCount;
    int leastCommonCount;
    char *mostCommonFound;
    char *leastCommonFound;
} SearchResults;

SearchResults findMostCommon(DiagnosticValue *self, long position) {
    char mostCommon = getMostCommonAtPosition(self, position);
    char leastCommon = getLeastCommonAtPosition(self, position);
    SearchResults results;
    results.mostCommonCount = 0;
    results.leastCommonCount = 0;
    while(self) {
        if (!self->mostCommonTestFailed) {
            if (self->value[position] == mostCommon) {
                results.mostCommonCount += 1;
                results.mostCommonFound = self->value;
            } else
                self->mostCommonTestFailed = true;
        }
        if (!self->leastCommonTestFailed) {
            if (self->value[position] == leastCommon) {
                results.leastCommonCount += 1;
                results.leastCommonFound = self->value;
            } else
                self->leastCommonTestFailed = true;
        }
        self = self->next;
    }
    return results;
}

int binaryStringToInt(char *self, long length) {
    int number = 0;
    for(long i = 0; i < length; i++)
        if(self[i] == '1')
            number = number | (1 << (length - i - 1));
    return number;
}

int tryToReadNumber(char* buffer) {
    return (scanf("%99[01]\n", buffer) != EOF);
}

int main() {
    char buffer[100];

    if (!tryToReadNumber(buffer))
        return 0;

    long positionCount = strlen(buffer);
    DiagnosticValue *list = newDiagnosticValue(buffer, positionCount);
    DiagnosticValue *listTail = list;

    while (tryToReadNumber(buffer))
        listTail = append(listTail, buffer, positionCount);

    char *oxygenGeneratorRating = 0;
    char *co2ScrubberRating = 0;
    for(long position = 0; position < positionCount; position++) {
        SearchResults sr = findMostCommon(list, position);
        if(!oxygenGeneratorRating)
            if(sr.mostCommonCount == 1)
                oxygenGeneratorRating = sr.mostCommonFound;
        if(!co2ScrubberRating)
            if(sr.leastCommonCount == 1)
                co2ScrubberRating = sr.leastCommonFound;
        if(oxygenGeneratorRating && co2ScrubberRating)
            break;
    }

    int oxygen = binaryStringToInt(oxygenGeneratorRating, positionCount);
    int co2 = binaryStringToInt(co2ScrubberRating, positionCount);
    printf("%d\n", oxygen * co2);

    return 0;
}
