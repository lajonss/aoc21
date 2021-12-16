#!/usr/bin/env ruby

$levels = []
$blinks = 0

STDIN.each do |line|
    current_line = []
    line.chomp.each_char do |char|
        current_line.push(char.to_i)
    end
    $levels.push(current_line)
end

$width = $levels[0].length
$height = $levels.length

def power_up(x, y)
    if x < 0 || x >= $width || y < 0 || y >= $height
        return
    end

    value = $levels[y][x] + 1
    $levels[y][x] = value
    if value != 10
        return
    end

    $blinks += 1
    (-1..1).each do |yy|
        (-1..1).each do |xx|
            if xx != 0 || yy != 0
                power_up(x + xx, y + yy)
            end
        end
    end
end

def clean_up(x, y)
    if $levels[y][x] > 9
        $levels[y][x] = 0
    end
end

def for_each_level(func)
    (0...$height).each do |y|
        (0...$width).each do |x|
            method(func).call(x, y)
        end
    end
end

def update_all
    for_each_level(:power_up)
    for_each_level(:clean_up)
end

def blink_100_times
    100.times do
        update_all
    end
    print $blinks
    print "\n"
end

def find_simultaneous_blink
    simultaneous_blink_count = $width * $height
    previous_blinks = 0
    iteration = 0
    until $blinks - previous_blinks == simultaneous_blink_count do
        iteration += 1
        previous_blinks = $blinks
        update_all
    end
    print iteration
    print "\n"
end

# blink_100_times
find_simultaneous_blink
