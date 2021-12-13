import * as readline from 'readline';

let rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
});

const directions = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1]
];

var board:number[][] = [];

rl.on('line', (line) => {
    let lineArray = Array.from(line).map((c) => Number(c));
    board.push(lineArray);
});

rl.on('close', () => {
    let height = board.length;
    let width = board[0].length;
    let factorSum = 0;
    for (var y = 0; y < height; y++)
    for (var x = 0; x < width; x++) {
        let isLocalMinimum = true;
        let value = board[y][x];
        directions.forEach((dir) => {
            let yy = y + dir[0];
            let xx = x + dir[1];
            let row = board[yy];
            if (row === undefined)
                return;
            let v = row[xx];
            if (v === undefined)
                return;
            if (v <= value)
                isLocalMinimum = false;
        });
        if (isLocalMinimum)
            factorSum += value + 1;
    }
    console.log(factorSum);
});
