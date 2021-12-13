import { directions, readBoard } from './util';

async function main() {
    let board = await readBoard();
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
}

main();
