const std = @import("std");
/// Zig version. When writing code that supports multiple versions of Zig, prefer
/// feature detection (i.e. with `@hasDecl` or `@hasField`) over version checks.
pub const zig_version = std.SemanticVersion.parse("0.11.0-dev.1465+d64dd75e3") catch unreachable;
pub const zig_backend = std.builtin.CompilerBackend.stage2_llvm;

pub const output_mode = std.builtin.OutputMode.Exe;
pub const link_mode = std.builtin.LinkMode.Static;
pub const is_test = false;
pub const single_threaded = true;
pub const abi = std.Target.Abi.gnu;
pub const cpu: std.Target.Cpu = .{
    .arch = .x86_64,
    .model = &std.Target.x86.cpu.x86_64,
    .features = std.Target.x86.featureSet(&[_]std.Target.x86.Feature{
        .@"64bit",
        .cmov,
        .cx8,
        .fxsr,
        .idivq_to_divl,
        .macrofusion,
        .mmx,
        .nopl,
        .slow_3ops_lea,
        .slow_incdec,
        .sse,
        .sse2,
        .vzeroupper,
        .x87,
    }),
};
pub const os = std.Target.Os{
    .tag = .windows,
    .version_range = .{ .windows = .{
        .min = .win8_1,
        .max = .win10_fe,
    }},
};
pub const target = std.Target{
    .cpu = cpu,
    .os = os,
    .abi = abi,
    .ofmt = object_format,
};
pub const object_format = std.Target.ObjectFormat.coff;
pub const mode = std.builtin.Mode.ReleaseSmall;
pub const link_libc = false;
pub const link_libcpp = false;
pub const have_error_return_tracing = false;
pub const valgrind_support = false;
pub const sanitize_thread = false;
pub const position_independent_code = true;
pub const position_independent_executable = false;
pub const strip_debug_info = true;
pub const code_model = std.builtin.CodeModel.default;
