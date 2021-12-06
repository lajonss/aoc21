using Gee;

void main () {
    var numbers = read_numbers ();

    stdin.read_line ();
    var boards = new ArrayList<Board>();
    while (!stdin.eof ())
        boards.add (new Board ());

    foreach (var number in numbers)
        for (var i = boards.size - 1; i >= 0; i--) {
            var board = boards[i];
            board. mark(number);
            if (board.is_winning ()) {
                if (boards.size == 1) {
                    stdout.printf ("%d\n", number * board.get_unmarked_score ());
                    return;
                } else
                    boards.remove_at (i);
            }
        }

    stdout.printf ("No board won\n");
}
