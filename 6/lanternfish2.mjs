import * as readline from 'node:readline/promises';
import { stdin, stdout } from 'process';

const DAYS = 256;

const rl = readline.createInterface({
    input: stdin,
    output: stdout,
    terminal: false
});

function AgeCounter() {
    this.ages = {};
    this.add = (ageStr) => {
        const age = Number(ageStr);
        if (this.ages[age])
            this.ages[age] = this.ages[age] + 1;
        else
            this.ages[age] = 1;
    };
    this.update = () => {
        const newAges = {};
        const oldAges = this.ages;
        [8,7,6,5,4,3,2,1].forEach((age) => newAges[age - 1] = oldAges[age] || 0);
        newAges[8] = oldAges[0] || 0;
        newAges[6] = newAges[6] + (oldAges[0] || 0);
        this.ages = newAges;
    }
    this.count = () => Object.values(this.ages).reduce((a, b) => a + b);
}

rl.on('line', (line) => {
    const counter = new AgeCounter();
    line.split(",").forEach(counter.add);

    for (var i = 0; i < DAYS; i++)
      counter.update();
    console.log(counter.count());
});
