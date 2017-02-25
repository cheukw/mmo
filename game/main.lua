local skynet = require "skynet"

skynet.start(function()
	skynet.error("Server start")

	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	
	skynet.newservice("debug_console", skynet.getenv("debug_port") or 8001)
	
	-- local clustermgr = skynet.uniqueservice "clustermgr"
	-- print("clustermgr start.")
	-- skynet.call(clustermgr, "lua", "start")
	-- print("clustermgr start. end")
	-- if not skynet.call(clustermgr, "lua", "register_gate") then
	-- 	skynet.error("cluster register gate to login error.")
	-- end
	skynet.uniqueservice "protocode"

	local watchdog = skynet.newservice("watchdog")
	skynet.call(watchdog, "lua", "start", {
		address = (skynet.getenv("login_addr") or "0.0.0.0"),
		port = (skynet.getenv("game_port") or 8888),
		maxclient = 64,
		nodelay = true,
	})
	skynet.error("Watchdog listen on", 8888)
	
	-- local a = skynet.newservice "agent"

	

	-- local agents = {}
	-- for i=1,10 do
	-- 	agents[i] = skynet.newservice("agent")
	-- 	print("agent ", i, agents[i])
	-- end

	-- -- skynet.sleep(100)
	-- for i=1,10 do
	-- 	skynet.send(agents[i], "lua", "disconnect")
	-- end
	--skynet.exit()
end)



