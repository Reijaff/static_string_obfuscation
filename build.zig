const std = @import("std");

pub fn build(b: *std.build.Builder) !void {
    const exe = b.addExecutable("main", "src/main.zig");
    exe.strip = true;
    exe.setTarget(try std.zig.CrossTarget.parse(.{ .arch_os_abi = "x86_64-windows" }));
    exe.setBuildMode(std.builtin.Mode.ReleaseSmall);
    exe.single_threaded = true;

    var rb: [32]u8 = undefined;
    var rb_b64: [64]u8 = undefined;

    try std.os.getrandom(&rb);
    _ = std.base64.standard.Encoder.encode(&rb_b64, &rb);

    // exe.defineCMacro("RANDOM_INT_16", std.os.getenvZ("RANDOM"));

    var buf: [34]u8 = undefined;
    exe.defineCMacro("RANDOM_STRING_32", try std.fmt.bufPrint(&buf, "\"{s}\"", .{rb_b64[0..32]})); // random seed
    // exe.defineCMacro("RANDOM_STRING_32", try std.fmt.bufPrint(&buf, "\"{s}\"", .{"lnURS1DjkWx8cswjexuUJyUv4C/eFkAj"})); // predefined seed

    exe.install();
}
