local skynet = require "skynet"

skynet.start(function()
	skynet.error("Server start")

	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	
	skynet.newservice("debug_console", skynet.getenv("debug_port") or 8001)
	
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		address = (skynet.getenv("login_addr") or "0.0.0.0"),
		port = (skynet.getenv("game_port") or 8888),
		maxclient = 64,
		nodelay = true,
	})
	skynet.error("Watchdog listen on", 8888)
end)



