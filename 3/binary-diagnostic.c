#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct BitCounter {
    int zeroCount;
    int oneCount;
};

void add(struct BitCounter *counter, char digit) {
    if (digit == '0')
        counter->zeroCount = counter->zeroCount + 1;
    else
        counter->oneCount = counter->oneCount + 1;
}

int getDominantValue(struct BitCounter counter) {
    return counter.zeroCount > counter.oneCount ? 0 : 1;
}

uint getMask(struct BitCounter counter, int order) {
    int value = getDominantValue(counter);
    uint mask = (1 << order) * value;
    return mask;
}

uint parseGammaRate(struct BitCounter *counters, long positionCount) {
    uint gammaRate = 0;
    for (long i = positionCount - 1; i >= 0; i--)
        gammaRate = gammaRate | getMask(counters[i], positionCount - i - 1);
    return gammaRate;
}


int tryToReadNumber(char* buffer) {
    return scanf("%99[01]\n", buffer) != EOF;
}

uint negate(uint original, long order) {
    return ~original & ((1 << order) - 1);
}

int main() {
    char buffer[100];

    if (!tryToReadNumber(buffer))
        return 0;

    long positionCount = strlen(buffer);
    struct BitCounter* counters = (struct BitCounter*)
        calloc(positionCount, sizeof(struct BitCounter));

    do {
        for (long i = 0; i < positionCount; i++)
            add(&(counters[i]), buffer[i]);
    } while (tryToReadNumber(buffer));

    uint gammaRate = parseGammaRate(counters, positionCount);
    free(counters);

    uint epsilonRate = negate(gammaRate, positionCount);
    printf("%d\n", gammaRate * epsilonRate);

    return 0;
}
