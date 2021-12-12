import java.util.Scanner;

public class CrabAlignment {
    static class ConstCostComputer implements PositionCounter.CostComputer {
        @Override
        public int compute(int from, int to) {
            return Math.abs(to - from);
        }
    }

    static class IncrementalCostComputer extends ConstCostComputer {
        @Override
        public int compute(int from, int to) {
            var distance = super.compute(from, to);
            return (distance + 1) * distance / 2;
        }
    }

    public static void main(String[] args) {
        var counter = new PositionCounter();
        var sc = new Scanner(System.in);
        for (var position : sc.nextLine().split(","))
            counter.add(position);

        int cost = Integer.MAX_VALUE;
        var costComputer = new IncrementalCostComputer();
        for (var i = counter.getPositionMin(); i <= counter.getPositionMax(); i++) {
            var iCost = counter.getTransitionCost(i, costComputer);
            if (iCost < cost)
                cost = iCost;
        }
        System.out.println(cost);
    }
}
