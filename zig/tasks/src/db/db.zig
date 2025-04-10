const std = @import("std");
const print = std.debug.print;
const c = @cImport({
	@cInclude("sqlite3.h");
	@cInclude("stdlib.h");
});


pub const DB = struct {

	pub fn init(path: [:0]const u8) !DB {
		var c_db: ?*c.sqlite3 = undefined;

		if (c.sqlite3_open(path, &c_db) != c.SQLITE_OK) {
			print("cannot open db at {s}: {s}\n", .{path, c.sqlite3_errmsg(c_db)});
			return error.OpenDB;	
		}
		return .{
			.db = c_db.?,
		};
	}

	fn execute(self: DB, query: [:0]const u8) !void {
		var errmsg : [*c]u8 = undefined;
		if( c.SQLITE_OK != c.sqlite3_exec(
			self.db,
			query,
			null,
			null,
			&errmsg,
		)) {
			defer c.sqlite3_free(errmsg);
			print("error executing {s}: {s}\n", .{query, errmsg});
			return error.Exec;
		}
		return;
	}

	pub fn create_schema(self: DB) !void {
		try self.execute(
		\\ create table if not exists task (
		\\   id integer primary key,
		\\   title text not null unique
		\\ ); 
		);
	}

	pub fn deinit(self: DB) void {
		_ = c.sqlite3_close(self.db);
	}

	db: *c.sqlite3,
};