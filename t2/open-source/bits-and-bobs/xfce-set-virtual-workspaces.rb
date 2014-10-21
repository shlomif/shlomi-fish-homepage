#!/usr/bin/env ruby

# Set the virtual workspaces number and names.
# Usage:
#   $ xfce-set-virtual-desktops "Name 1" "Name 2" "Name 3"...
#
# Copyright by Shlomi Fish, 2009.
#
# Licensed under the MIT/X11 License:
#
# http://www.opensource.org/licenses/mit-license.php

names = ARGV

def xconf_workspace_query(op, args)
    command_line = [
        "xfconf-query", "-c", "xfwm4",
        "-p", "/general/workspace_#{op}",
    ] + args.map { |a| ["-s", a]}.inject([]) { |a,e| a+e}
    if not system(*(command_line)) then
        raise "xfconf-query #{command_line} failed. $?"
    end
end

xconf_workspace_query("count", [names.length.to_s])
xconf_workspace_query("names", names)

