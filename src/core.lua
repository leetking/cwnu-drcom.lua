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
    return ip
end

local body = {
    ["DDDDD"]  = (user.net == "SNET") and user.usr or user.usr.."@tel",
    ["upass"]  = user.pwd,
    ["R1"]     = 0,
    ["R2"]     = "",
    ["R6"]     = 0,
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

-- 开始请求
local function login()
    print(("User(%s) Logining..."):format(body["DDDDD"]))
    local res, code, reshd = http.request({
        url = "http://"..syscfg.ser..syscfg.path,
        method = "POST",
        headers = {
            ["Content-Type"] = "application/x-www-form-urlencoded",
            ["Content-Length"] = #strbody,
            ["Cookie"]     = strcookies,
            ["Referer"]    = "http://"..syscfg.ser..syscfg.path,
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

-- $ curl -X POST --data "DDDDD=201413640731&upass=e63b77b435ec97b7c1bfeeb860128c9d123456782&R1=0&R2=1&para=00&0MKKey=123456&v6ip=" http://10.255.0.204/0.htm
