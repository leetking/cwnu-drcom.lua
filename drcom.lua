#!/usr/bin/env lua

local drcom  = require("cwnu-drcom.core")
local config = require("cwnu-drcom.config")

local function help()
    print([[Usage: drcom [OPTIONS]
`cwnu-drcom` implement in lua and it provids a way to authenticate in command line.
OPTIONS:
       -l: logoff.
       -r: relogin.
       -u: user name.
       -p: password.
       -n: the type of network, SNET(school net) or INET(internet)
       -t: the type of logining, PC(personal computer) or MB(mobile phone)
       -v: verbose
       -h: show this page.]])
end

local function logoff()
end

local function relogin()
end

local login = drcom.login

local user = config.user

for i = 1, #arg do
    if "-u" == arg[i] and i+1 <= #arg then
        user.usr = arg[i+1]
    elseif "-p" == arg[i] and i+1 <= #arg then
        user.pwd = arg[i+1]
    elseif "-n" == arg[i] and i+1 <= #arg then
        user.net = arg[i+1]
    elseif "-t" == arg[i] and i+1 <= #arg then
        user.ispc = ("PC" == arg[i+1]) and "true" or "false"
    elseif "-v" == arg[i] then
        drcom.set_debug(true)
    end

    if "-h" == arg[i] then
        help()
        return 0
    end
    if "-l" == arg[i] then
        logoff()
        return 0
    end
    if "-r" == arg[i] then
        relogin()
        return 0
    end
end

-- Login, START
if login(user) then
    print("Login success!")
else
    print("Login fail!")
end
