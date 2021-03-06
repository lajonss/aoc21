using Gee;

void main () {
    var numbers = read_numbers ();

    stdin.read_line ();
    var boards = new ArrayList<Board>();
    while (!stdin.eof ())
        boards.add (new Board ());

    foreach (var number in numbers)
        foreach (var board in boards) {
            board. mark(number);
            if (board.is_winning ()) {
                stdout.printf ("%d\n", number * board.get_unmarked_score ());
                return;
            }
        }

    stdout.printf ("No board won\n");
}
