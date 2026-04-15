const std = @import("std");
const stdout = std.Io.File.stdout();
const debug = std.debug;
const Io = std.Io;
const Init = std.process.Init;

const Option = struct {
    name: []const u8,
    short: []const u8,
    long: []const u8,
    description: []const u8,
};

const usage_header =
    \\discloner: A simple CLI tool for clonning disks
    \\
    \\Usage:
    \\  discloner -i [input_file] -o [output_file]
    \\
    \\Full command list:
    \\
;

const options = [_]Option{
    Option{ .name = "help", .short = "-h", .long = "--help", .description = "Prints this help." },
    Option{ .name = "input", .short = "-i", .long = "--input", .description = "The path for the input file/disk." },
    Option{ .name = "output", .short = "-o", .long = "--output", .description = "The path for the output file/disk." },
    Option{ .name = "block size", .short = "-bs", .long = "--block-size", .description = "The size of each block that the program will read and write." },
    Option{ .name = "resume transference metadata", .short = "-r", .long = "--resume-file", .description = "The path for the operation metadata. It allows the discloner to resume an incomplete operation using a custom metadata file. " },
};

pub const Config = struct {
    local_io: Io,

    pub fn init(initData: Init) Config {
        return Config{
            .local_io = initData.io,
        };
    }

    pub fn printCLIOptions(self: *const Config) void {
        stdout.writeStreamingAll(self.local_io, usage_header) catch |err| {
            debug.print("Could not write to the STDIO: {s}\n", .{
                @errorName(err),
            });
        };

        var str_buffer: [1024]u8 = undefined;
        for (options) |option| {
            const result = std.fmt.bufPrint(&str_buffer, "\n[{s}]:\n  {s}  {s:<20} {s}\n", .{
                option.name,
                option.short,
                option.long,
                option.description,
            }) catch unreachable;

            stdout.writeStreamingAll(self.local_io, result) catch |err| {
                debug.print("Could not write to the STDIO: {s}\n", .{
                    @errorName(err),
                });
            };
        }
    }
};
