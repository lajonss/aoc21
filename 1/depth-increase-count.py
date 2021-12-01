import sys

previous_depth = None
increases = 0

for line in sys.stdin:
    depth = int(line)
    if previous_depth and previous_depth < depth:
        increases += 1
    previous_depth = depth

print(increases)
