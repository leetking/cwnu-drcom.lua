-- 用户信息
local user = {
    usr = "201413640731",   -- 在这里输入用户名
    pwd = "yourpasswd",     -- 在这里输入密码
    net = "SNET",           -- 网络类型,SNET: 校园网(school net)，INET: 互联网(internet),默认为SNET
    ispc = "true",          -- login as a PC if @ispc is true, else login as a mobile phone
}

-- 软件设置
local sys = {
    ser  = "10.255.0.204",    -- 服务器地址，不再必须填写
    path = "/a70.htm",
}

return {
    user = user,
    sys = sys,
}
