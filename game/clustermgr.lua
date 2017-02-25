local skynet = require "skynet"
local cluster = require "cluster"

local CMD = {} -- 内部调用
local REMOTE = {} -- game调用

local proxy

function CMD.start()
	cluster.register("gamed", skynet.self())
	cluster.open(skynet.getenv("nodename") or "game")
end

-- 
function CMD.register_gate()
	print("register_gate", skynet.self())

	local logind = cluster.query("login", "logind")
	proxy = cluster.proxy("login", logind)

	local address = skynet.getenv "game_addr" or "127.0.0.1"
	local port = skynet.getenv "game_port" or 8888
	local ret = skynet.call(proxy, "lua", "remote", "register_gate", address, port)
	print("register_gate. wait", skynet.self())
	return ret
end

local count = 1
function timer_ping()
	
	skynet.timeout(300, function()
		print("ping login server", count)
		count = count + 1
		skynet.call(proxy, "lua", "remote", "ping")
		timer_ping()
	end)
end

function CMD.ping_login()
	--timer_ping()
end

function REMOTE.register_login()
	print("gamed cluster register_login", skynet.self())

	return true
end

function REMOTE.unregister()
	
end


skynet.start(function( ... )
	skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		if cmd == "remote" then
			local f = assert(REMOTE[subcmd])
			skynet.ret(skynet.pack(f(...)))
		else
			local f = assert(CMD[cmd])
			skynet.ret(skynet.pack(f(subcmd,...)))
		end
	end)
end)