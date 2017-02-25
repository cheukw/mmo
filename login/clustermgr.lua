local skynet = require "skynet"
local cluster = require "cluster"

local CMD = {} -- 内部调用
local REMOTE = {} -- game调用

local gate
local game_proxy 


function CMD.start()
	cluster.register("logind", skynet.self())
	cluster.open(skynet.getenv("nodename") or "login")
end

function CMD.kick()
	-- return skynet.call(game_proxy, "lua", "remote", "kick_user")
end



function register_login()
	local gamed = cluster.query("game", "gamed")
	game_proxy = cluster.proxy("game", gamed)

	return skynet.call(game_proxy, "lua", "remote", "register_login")
end

function REMOTE.register_gate(address, port)
	print("REMOTE.register_gate", address, port)
	gate = {address, port}
	return register_login()
end

function REMOTE.unregister()
	
end

local count = 1
function REMOTE.ping()
	print("ping by game", count)
	count = count + 1
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

