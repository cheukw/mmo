local skynet = require "skynet"

skynet.start(function()
	skynet.error("Server start")

	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	
	skynet.newservice("debug_console",8000)

	-- local dc = skynet.newservice "datad"
	-- skynet.call(dc, "lua", "start")
	-- skynet.call(dc, "lua", "close")
	

	local st = skynet.newservice "sometest"
	print("address", st)
	
	-- skynet.call(st, "lua", "exit")

	skynet.call(st, "lua", "test_crypt")

	--skynet.call(st, "lua", "test_sleep")
	skynet.send(st, "lua", "test_sleep")
	print("hello world.")
	skynet.call(st, "lua", "test_sleep2")
	
	skynet.call(st, "lua", "exit")
	-- local protod = {}
	-- for i = 1,10 do
	-- 	protod[i] = skynet.newservice "protod"
	-- end

	-- for i=1,10 do
	-- 	local send_buffer = skynet.call(protod[i], "lua", "encode", 2001, "game.ping_c2g", {msg="hello world "..i})
	-- 	print("send_buffer size:", #send_buffer)
	-- 	local msg = skynet.call(protod[i], "lua", "decode", send_buffer)
	-- 	--print("msg ", msg)
	-- end

	-- for i = 1,10 do
	-- 	skynet.call(protod[i], "lua", "exit")
	-- end
end)

    

