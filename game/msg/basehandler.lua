-- basehandler.lua
local skynet = require "skynet"

local basehandler = {}

local agent
function basehandler.init(at)
	agent = at
end

local tb2str = function(tb)
	m = ""
	for k,v in pairs(tb) do
		m = m .. k..":"..v.." "
	end
	return m
end

function basehandler.ping(msg)

	-- print("basehandler.ping ".. msg.msg)
	skynet.send(agent, "lua", "send", 2001, "game.pong_g2c", {msg = "pong->ping success."})
end

function basehandler.login(msg)
	print("basehandler.login", msg.token, msg.role_id)
end

return basehandler