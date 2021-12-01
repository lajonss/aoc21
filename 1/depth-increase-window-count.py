import sys

class SlidingWindow:
    def __init__(self, capacity):
        self.values = []
        self.capacity = capacity

    def append(self, element):
        self.values.append(element)
        self.values = self.values[-self.capacity:]

    @property
    def value(self):
        if len(self.values) == self.capacity:
            return sum(self.values)
        return None

window = SlidingWindow(3)
increases = 0
previous_value = None

for line in sys.stdin:
    window.append(int(line))
    value = window.value
    if previous_value and value and previous_value < value:
        increases += 1
    previous_value = value

print(increases)
