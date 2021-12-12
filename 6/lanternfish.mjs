import * as readline from 'node:readline/promises';
import { stdin, stdout } from 'process';

const DAYS = 80;

const rl = readline.createInterface({
    input: stdin,
    output: stdout,
    terminal: false
});

function Lanternfish(age) {
    this.age = Number(age);
    this.update = () => {
        if (this.age == 0) {
            this.age = 6;
            return new Lanternfish(8);
        } else
            this.age -= 1;
    };
}

rl.on('line', (line) => {
    const fish = line.split(",").map((age) => new Lanternfish(age));

    for (var i = 0; i < DAYS; i++)
        fish.map((f) => f.update()).forEach((f) => {
            if (f)
                fish.push(f);
        });
    console.log(fish.length);
});
