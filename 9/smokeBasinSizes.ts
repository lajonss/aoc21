import { directions, readBoard } from './util';

function explore(board, x, y) {
    let row = board[y];
    if (row === undefined)
        return 0;
    let value = row[x];
    if (value === undefined)
        return 0;
    if (value == 9)
        return 0;
    board[y][x] = 9;
    return 1 + directions
        .map((dir) => explore(board, x + dir[1], y + dir[0]))
        .reduce((a, b) => a + b);
}

async function main() {
    let board = await readBoard();
    let height = board.length;
    let width = board[0].length;
    let largestBasins = [];
    for(var y = 0; y < height; y++)
    for(var x = 0; x < width; x++) {
        let size = explore(board, x, y);
        largestBasins.push(size);
        largestBasins.sort((a, b) => b - a);
        largestBasins.splice(3);
    }
    console.log(largestBasins.reduce((a, b) => a * b, 1))
}

main();
