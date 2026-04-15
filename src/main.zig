const std = @import("std");
const Config = @import("config.zig").Config;

pub fn main(init: std.process.Init) void {
    const config = Config.init(init);

    config.printCLIOptions();
}
