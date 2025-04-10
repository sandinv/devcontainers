const std = @import("std");
const DB = @import("db/db.zig").DB;
const print = std.debug.print;
const yazap = @import("yazap");
const App = yazap.App;
const Arg = yazap.Arg;

const DB_PATH = "tasks.db";
pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer if (gpa.deinit() != .ok) @panic("leak");

    const allocator = gpa.allocator();

    var app = App.init(allocator, "tasks", "a to-do helper");
    defer app.deinit();

     // Root command
    var rootCommand = app.rootCommand();
    rootCommand.setProperty(.help_on_empty_args);
    try rootCommand.addArg(Arg.booleanOption("test", 't', "this is a test"));

    const initCommand = app.createCommand("init", "Init the task database");

    try rootCommand.addSubcommand(initCommand);

    // Parse Options
    const matches = try app.parseProcess();

    if (matches.subcommandMatches("init")) |_| {
        const db = try DB.init(DB_PATH);
        try db.create_schema();
        defer db.deinit();
    }

}
