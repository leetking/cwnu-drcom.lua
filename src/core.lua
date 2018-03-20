local http = require("socket.http")
local config = require("cwnu-drcom.config")
local ltn12  = require("ltn12")
local syscfg = config.sys
local user = config.user

-- 加密密码
local encryt_pwd = function(pwd)
    local md5  = require("md5")
    local pid = syscfg.pid
    local calg = syscfg.calg
    return md5.sumhexa(pid..pwd..calg)..calg..pid
end
-- 把table转换为key=value形式的string，并由sep隔开
local table2string = function(tb, sep)
    local ret = ""
    local isfirst = true
    for k, v in pairs(tb) do
        if not isfirst then
            ret = ret..sep
        end
        isfirst = false
        ret = ret..tostring(k).."="..tostring(v)
    end
    return ret
end

-- 获取本机 IP
local get_localip = function()
    local socket = require("socket")
    local skt = socket.udp()
    skt:setpeername("8.8.8.8", 53)  -- 随便填写
    local ip, _ = skt:getsockname()
    skt:close()
    return ip
end

-- 侦测认证服务器地址
local get_serverip = function()
    local res, code, reshd = http.request({
        url = "http://baidu.com",
        method = "GET",
        --[[
        headers = {
            ["User-Agent"] = "Mozilla/5.0 (X11; Linux x86_64) "..
                             "AppleWebKit/537.36 (KHTML, like Gecko) "..
                             "Ubuntu Chromium/61.0.3163.100 "..
                             "Chrome/61.0.3163.100 Safari/537.36",
        },
        --]]
    })
    if res == 1 and code == 200 and reshd["location"] then
        print("server: ", reshd["location"]:match("%d+%.%d+%.%d+%.%d+"))
        return reshd["location"]:match("%d+%.%d+%.%d+%.%d+")
    end
    return syscfg.ser
end

local body = {
    ["DDDDD"]  = (user.net == "SNET") and user.usr or user.usr.."@tel",
    ["upass"]  = user.pwd,
    ["R1"]     = 0,
    ["R2"]     = "",
    -- 0: personal computer; 1: mobile phone
    ["R6"]     = (user.ispc == "true") and "0" or "1",
    ["para"]   = "00",
    ["0MKKey"] = "123456",
    ["buttonClicked"] = "",
    ["redirect_url"]  = "",
    ["err_flag"]      = "",
    ["username"]      = "",
    ["password"]      = "",
    ["user"]          = "",
    ["cmd"]           = "",
    ["Login"]         = "",
}
local cookies = {
    ["program"]     = "XHSFDX",
    ["vlan"]        = 0,
    ["ip"]          = get_localip(),
    ["md5_login2"]  = body["DDDDD"].."%7C"..body["upass"],   -- %7C == |
}
local strbody    = table2string(body, "&")
local strcookies = table2string(cookies, "; ")
local resbody    = {}

print("strbody :", strbody)
print("strcookies :", strcookies)
print("localip: ", get_localip())
print("serverip: ", get_serverip())

-- 开始请求
local function login()
    local serip = get_serverip()
    print(("User(%s) Logining..."):format(body["DDDDD"]))
    local res, code, reshd = http.request({
        url = "http://"..serip..syscfg.path,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
            ["Content-Length"] = #strbody,
            ["Cookie"]     = strcookies,
            ["Referer"]    = "http://"..serip..syscfg.path,
        },
        source = ltn12.source.string(strbody),
        sink = ltn12.sink.table(resbody),
    })

    -- TODO 处理反馈信息
    if 200 == code and 1 == res then
        return true
    else
        return false
    end
end

local function relogin()
end

local function logoff()
end

-- 导出的接口
return {
    login   = login,
    relogin = relogin,
    logoff  = logoff,
}

