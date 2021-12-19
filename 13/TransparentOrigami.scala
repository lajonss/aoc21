import scala.io.Source

sealed trait Axis
case object X extends Axis
case object Y extends Axis

class Dot(val x: Int, val y: Int) {
    override def equals(other: Any) : Boolean = other match {
        case other: Dot => this.x == other.x && this.y == other.y
        case _ => false
    }
    override def hashCode: Int = x + 2048 * y
}

class Fold(val axis: Axis, val index: Int)

object TransparentOrigami {
    def main(args: Array[String]) = {
        val lines = Source.stdin.getLines()
        var dots = parseDots(lines).toSet
        for (fold <- parseFolds(lines))
            dots = dots.map((d) => foldAlong(d, fold)).toSet
        printDots(dots)
    }

    private def parseDots(lines: Iterator[String]) = getInputBlock(lines).map(parseDot)
    private def parseFolds(lines: Iterator[String]) = getInputBlock(lines).map(parseFold)
    private def getInputBlock(lines: Iterator[String]) = lines.takeWhile((l) => l.length() > 0)

    private def parseDot(line: String) : Dot = {
        val split = line.split(",")
        new Dot(split(0).toInt, split(1).toInt)
    }

    private def parseFold(line: String) : Fold = {
        val split = line.substring(11).split("=")
        new Fold(
            if ("x" == split(0)) X else Y,
            split(1).toInt
        )
    }

    private def foldAlong(dot: Dot, fold: Fold) : Dot = fold.axis match {
        case X => new Dot(foldAlong(dot.x, fold.index), dot.y)
        case Y => new Dot(dot.x, foldAlong(dot.y, fold.index))
    }

    private def foldAlong(value: Int, index: Int) =
        if (value < index) value
        else index - value + index

    private def printDots(dots: Set[Dot]) = {
        val width = dots.map((d) => d.x).max
        val height = dots.map((d) => d.y).max
        for (y <- 0 to height) {
            for (x <- 0 to width)
                print(if (dots contains new Dot(x, y)) "#" else ".")
            println("")
        }
    }
}
