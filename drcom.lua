#!/usr/bin/env lua

local drcom = require("cwnu-drcom.core")

local function help()
    print([[
`cwnu-drcom` implement in lua.
Usage: drcom [-l|-r|-h]
       -l: logoff.
       -r: relogin.
       -h: show this page.
    ]])
end

if #arg < 1 then
    if drcom.login() then
        print("Login success!")
    else
        print("Login fail!")
    end
    return 0
end

local function logoff()
end

local function relogin()
end

for i = 1, #arg do
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
