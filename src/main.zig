const std = @import("std");

var runtime_rnd_init = std.rand.DefaultCsprng.init(@cImport({@cDefine("RANDOM_STRING_32", "");}).RANDOM_STRING_32.*);

fn comptime_rnd_init() *std.rand.Xoodoo{
	var rnd = comptime std.rand.DefaultCsprng.init(@cImport({@cDefine("RANDOM_STRING_32", "");}).RANDOM_STRING_32.*);
	return &rnd;
}

const hh = struct{

	fn _x(comptime string: []const u8) [string.len]u8 {

		@setEvalBranchQuota(100000);

    	var encrypted_string: [string.len]u8 = undefined;
    	var decrypted_string: [string.len]u8 = undefined;

    	inline for (string) |chr, idx| {
			var ki = comptime comptime_rnd_init().random().int(u8);
        	encrypted_string[idx] = chr ^ ki;
    	}

    	for (encrypted_string) |chr, idx| {
        	decrypted_string[idx] = chr ^ runtime_rnd_init.random().int(u8);
    	}

    	return decrypted_string;
	}

};

fn encrypt(comptime string: []const u8) []const u8{
    var new_string: [string.len]u8 = undefined;
	@setEvalBranchQuota(100000);

    for (string) |chr, idx|{
		var ki = comptime comptime_rnd_init().random().int(u8);
        new_string[idx] = chr ^ ki;
    } 

    return &new_string;
}

fn decrypt(comptime string: []const u8) []const u8{
    var new_string: [string.len]u8 = undefined;

    for (string) |chr, idx|{
        new_string[idx] = chr ^ runtime_rnd_init.random().int(u8);
    } 
    return &new_string;
}

fn _y(comptime string:[]const u8) []const u8{
    return decrypt(comptime encrypt(string));
}


extern "kernel32" fn LoadLibraryA([*:0]const u8) callconv(.C) void;

pub fn main() !void{
	const stdout = std.io.getStdOut().writer();
    try stdout.print("{s}\n", .{_y("hello, world!")});
    try stdout.print("{s}\n", .{_y("bravo")});

	LoadLibraryA(_y("extern.dll")[0..:0]);


}

