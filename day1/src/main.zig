const std = @import("std");

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    const allocator = arena.allocator();
    defer arena.deinit();

    // create an array list of integers
    var left = std.ArrayList(i32).init(allocator);
    var right = std.ArrayList(i32).init(allocator);
    defer {
        left.deinit();
        right.deinit();
    }

    const input_text = @embedFile("input.txt");
    var it = std.mem.tokenize(u8, input_text, "\n");
    // read each line
    while (it.next()) |line| {
        var iter = std.mem.split(u8, line, "   ");

        const left_num = try std.fmt.parseInt(i32, iter.next().?, 10);
        const right_num = try std.fmt.parseInt(i32, iter.next().?, 10);
        try left.append(left_num);
        try right.append(right_num);
    }

    std.mem.sort(i32, left.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, right.items, {}, std.sort.asc(i32));

    // timer start
    var start = std.time.milliTimestamp();
    std.debug.print("diff score: {}\n", .{calc_diff(left, right)});
    // timer end
    var end = std.time.microTimestamp();
    std.debug.print("time elapsed: {} us\n", .{end - start});
    start = std.time.microTimestamp();
    std.debug.print("similarity score: {}\n", .{calc_score(left, right)});
    end = std.time.microTimestamp();
    std.debug.print("time elapsed: {} us\n", .{end - start});
}

fn calc_diff(left: std.ArrayList(i32), right: std.ArrayList(i32)) u32 {
    var diff: u32 = 0;
    for (0..left.items.len) |i| {
        diff += @abs(left.items[i] - right.items[i]);
    }
    return diff;
}

fn calc_score(left: std.ArrayList(i32), right: std.ArrayList(i32)) i32 {
    var score: i32 = 0;
    for (0..left.items.len) |i| {
        var count: i32 = 0;
        for (0..right.items.len) |j| {
            if (left.items[i] == right.items[j]) {
                count += 1;
            } else {
                score += left.items[i] * count;
                count = 0;
            }
        }
    }
    return score;
}
