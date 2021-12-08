struct Direction {
    public int x;
    public int y;

    public bool IsNotCardinal()
        => x != 0 && y != 0;
}

struct Location : IEquatable<Location>{
    int x;
    int y;

    public Location(string raw) {
        var numbers = raw.Split(",");
        x = int.Parse(numbers[0]);
        y = int.Parse(numbers[1]);
    }

    public Location NextIn(Direction direction)
        => new Location {
            x = x + direction.x,
            y = y + direction.y
        };

    public Direction GetDirection(Location to)
        => new Direction {
            x = to.x > x ? 1 : to.x == x ? 0 : -1,
            y = to.y > y ? 1 : to.y == y ? 0 : -1
        };

    public override bool Equals(object? other) {
        if (other is Location otherLocation)
            return otherLocation == this;
        return false;
    }
    public bool Equals(Location other)
        => x == other.x && y == other.y;

    public override int GetHashCode() => x * y;
    public override string ToString() => $"({x}, {y})";

    public static bool operator ==(Location a, Location b)
        => a.Equals(b);
    public static bool operator !=(Location a, Location b)
        => !a.Equals(b);
}

struct Board {
    Dictionary<Location, int> density = new Dictionary<Location, int>();

    public bool ignoreNotCardinal;

    public void AddLine(string line) {
        var ends = line.Split(" -> ");
        var start = new Location(ends[0]);
        var end = new Location(ends[1]);
        var direction = start.GetDirection(end);
        if (ignoreNotCardinal && direction.IsNotCardinal())
            return;

        AddLocation(start);

        var point = start;
        while (point != end) {
            point = point.NextIn(direction);
            AddLocation(point);
        }
    }

    public int GetLocationsCount(int minDensity) {
        var count = 0;
        foreach (var value in density.Values) {
            if (value >= minDensity)
                count += 1;
        }
        return count;
    }

    void AddLocation(Location location) {
        if (density.TryGetValue(location, out var count))
            count += 1;
        else
            count = 1;
        density[location] = count;
    }
}

class Program {
    public static void Main(string[] args) {
        var line = string.Empty;
        var board = new Board();
        board.ignoreNotCardinal = false;
        while(!string.IsNullOrEmpty(line = Console.ReadLine()))
            board.AddLine(line);
        Console.WriteLine(board.GetLocationsCount(2));
    }
}
