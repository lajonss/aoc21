import sys

class Location:
    def __init__(self):
        self.depth = 0
        self.position = 0

    def execute(self, line):
        line_split = line.split()
        operation = line_split[0]
        amount = int(line_split[1])
        if operation == "down":
            self.depth += amount
        elif operation == "up":
            self.depth -= amount
        elif operation == "forward":
            self.position += amount
        else:
            raise Exception("unknown operation")

location = Location()

for line in sys.stdin:
    location.execute(line)

print(location.depth * location.position)
