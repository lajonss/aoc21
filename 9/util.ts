import * as readline from 'readline';

let rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: false
});

export const directions = [
    [-1, 0],
    [1, 0],
    [0, -1],
    [0, 1]
];

export function readBoard() {
    return new Promise<number[][]>((res, rej) => {
        try {
            let rl = readline.createInterface({
                input: process.stdin,
                output: process.stdout,
                terminal: false
            });
            let board:number[][] = [];
            rl.on('line', (line) => {
               board.push(Array.from(line).map((c) => Number(c))); 
            });
            rl.on('close', () => {
                res(board);
            });
        } catch (err) {
            rej(err);
        }
    });
}
