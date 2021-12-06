class Board : Object {
    const int LINES_NUM = 5;

    private bool[,] marks;
    private int[,] values;

    public Board () {
        marks = new bool[LINES_NUM,LINES_NUM];
        values = new int[LINES_NUM,LINES_NUM];
        for (var i = 0; i < LINES_NUM; i++)
            read_line (i);
        stdin.read_line();
    }

    public void mark (int number) {
        for (var x = 0; x < LINES_NUM; x++)
            for (var y = 0; y < LINES_NUM; y++)
                try_to_mark (x, y, number);
    }

    public bool is_winning () {
        for (var x = 0; x < LINES_NUM; x++) {
            var marked = 0;
            for (var y = 0; y < LINES_NUM; y++)
                if (marks[x, y])
                    marked += 1;
            if (marked == LINES_NUM)
                return true;
        }

        for (var y = 0; y < LINES_NUM; y++) {
            var marked = 0;
            for (var x = 0; x < LINES_NUM; x++)
                if (marks[x, y])
                    marked += 1;
            if (marked == LINES_NUM)
                return true;
        }

        return false;
    }

    public int get_unmarked_score () {
        var unmarked_sum = 0;
        for (var x = 0; x < LINES_NUM; x++)
            for (var y = 0; y < LINES_NUM; y++)
                if (!marks[x, y])
                    unmarked_sum += values[x, y];
        return unmarked_sum;
    }

    public void print () {
        for (var x = 0; x < LINES_NUM; x++) {
            for (var y = 0; y < LINES_NUM; y++) {
                var format = marks[x, y] ? "x%.2d" : " %.2d";
                stdout.printf (format, values[x, y]);
            }
            stdout.printf ("\n");
        }
        stdout.printf ("\n");
    }

    private void read_line (int index) {
        int i = 0;
        foreach (var str_number in stdin.read_line ().split_set (" "))
            if (str_number.length > 0) {
                values[index, i] = int.parse (str_number);
                i++;
            }
    }

    private void try_to_mark (int x, int y, int number) {
        if (values[x, y] == number)
            marks[x, y] = true;
    }
}

int[] read_numbers () {
    var str_numbers = stdin.read_line (). split (",");
    var numbers = new int[str_numbers.length];
    for (var i = 0; i < str_numbers.length; i++)
        numbers[i] = int.parse (str_numbers[i]);
    return numbers;
}
