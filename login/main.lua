local skynet = require "skynet"


skynet.start(function()
	skynet.error("Login Server start")

	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	
	skynet.newservice("debug_console", skynet.getenv("debug_port") or 8002)
	
	local logind = skynet.uniqueservice("logind")
	skynet.call(logind, "lua", "open", {
		address = (skynet.getenv("login_addr") or "0.0.0.0"),
		port = (skynet.getenv("login_port") or 8886),
		maxclient = 64,
		nodelay = true,
	})
	
	-- cluster.register("logind", logind)
	-- cluster.open(skynet.getenv("nodename") or "login")
	local cluster = skynet.uniqueservice "clustermgr"
	skynet.call(cluster, "lua", "start")
	-- skynet.exit()

	-- skynet.timeout(300, function() print("Hello World 300") end)
	-- skynet.timeout(100, function() print("Hello World 100") end)
	-- skynet.timeout(200, function() print("Hello World 200") end)
end)