import java.util.HashMap;
import java.util.Scanner;

public class CrabAlignment {
    static class PositionCounter {
        private HashMap<Integer, Integer> positions = new HashMap<>();
        private int minPosition = Integer.MAX_VALUE;
        private int maxPosition = Integer.MIN_VALUE;

        public void add(String value) {
            var number = Integer.parseInt(value);
            var current = positions.putIfAbsent(number, 1);
            if (current != null)
                positions.put(number, current + 1);
            updateMinMax(number);
        }

        public int getPositionMin() {
            return minPosition;
        }

        public int getPositionMax() {
            return maxPosition;
        }

        public int getTransitionCost(int to) {
            var cost = 0;
            for (var entry : positions.entrySet()) {
                var singleCost = Math.abs(to - entry.getKey());
                cost += singleCost * entry.getValue();
            }
            return cost;
        }

        private void updateMinMax(int number) {
            minPosition = Integer.min(minPosition, number);
            maxPosition = Integer.max(maxPosition, number);
        }
    }

    public static void main(String[] args) {
        var counter = new PositionCounter();
        var sc = new Scanner(System.in);
        for (var position : sc.nextLine().split(","))
            counter.add(position);

        int cost = Integer.MAX_VALUE;
        for (var i = counter.getPositionMin(); i <= counter.getPositionMax(); i++) {
            var iCost = counter.getTransitionCost(i);
            if (iCost < cost)
                cost = iCost;
        }
        System.out.println(cost);
    }
}
