import sys

class Submarine:
    def __init__(self):
        self.aim = 0
        self.position = 0
        self.depth = 0

    def execute(self, line):
        line_split = line.split()
        operation = line_split[0]
        amount = int(line_split[1])
        if operation == "down":
            self.aim += amount
        elif operation == "up":
            self.aim -= amount
        elif operation == "forward":
            self.position += amount
            self.depth += amount * self.aim

submarine = Submarine()
for line in sys.stdin:
    submarine.execute(line)

print(submarine.position * submarine.depth)
