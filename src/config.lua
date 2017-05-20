-- 用户信息
local user = {
    usr = "201413640731",   -- 在这里输入用户名
    pwd = "yourpasswd",     -- 在这里输入密码
    net = 1,                -- 网络类型,0: 校园网，1: 互联网
}

-- 软件设置
local sys = {
    url  = "http://10.255.0.204/0.htm",
    pid  = "2",
    calg = "12345678",
}

return {
    user = user,
    sys = sys,
}
