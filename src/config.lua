-- 用户信息
local user = {
    usr = "201413640731",   -- 在这里输入用户名
    pwd = "yourpasswd",     -- 在这里输入密码
    net = "SNET",           -- 网络类型,SNET: 校园网(school net)，INET: 互联网(internet),默认为SNET
}

-- 软件设置
local sys = {
    ser  = "10.255.0.204",
    path = "/a70.htm",
}

return {
    user = user,
    sys = sys,
}
