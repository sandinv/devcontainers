const std = @import("std");
const yazap = @import("yazap");
const App = yazap.App;
const Arg = yazap.Arg;

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() != .ok) @panic("leak");

    const allocator = gpa.allocator();

    var app = App.init(allocator, "tasks", "a to-do helper");
    defer app.deinit();

    const out = std.io.getStdOut();
    var wr = out.writer();

    // Root command
    var rootCommand = app.rootCommand();
    rootCommand.setProperty(.help_on_empty_args);
    try rootCommand.addArg(Arg.booleanOption("test", 't', "this is a test"));

    // Parse Options
    const matches = try app.parseProcess();

    if (matches.containsArg("test")) {
        try wr.print("test option selected\n", .{});
    }
}
