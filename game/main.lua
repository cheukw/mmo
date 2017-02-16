local skynet = require "skynet"

skynet.start(function()
	skynet.error("Server start")

	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	
	skynet.newservice("debug_console",8000)
	
	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		port = 8888,
		maxclient = 64,
		nodelay = true,
	})
	skynet.error("Watchdog listen on", 8888)
	
	skynet.exit()
end)



