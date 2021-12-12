import java.util.HashMap;

public class PositionCounter {
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

    public int getTransitionCost(int to, CostComputer cc) {
        var cost = 0;
        for (var entry : positions.entrySet()) {
            var singleCost = cc.compute(entry.getKey(), to);
            cost += singleCost * entry.getValue();
        }
        return cost;
    }

    private void updateMinMax(int number) {
        minPosition = Integer.min(minPosition, number);
        maxPosition = Integer.max(maxPosition, number);
    }

    public interface CostComputer {
        public int compute(int from, int to);
    }
}
