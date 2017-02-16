local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"


local WATCHDOG
local CMD = {}
local client_fd


function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog
	
	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)
end

function CMD.disconnect()
	-- todo: do something before exit
	skynet.exit()
end

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)
