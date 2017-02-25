local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"


local WATCHDOG


local CMD = {}
local CLIENT = {}

local client_fd


local function send_package(pack)
	local package = string.pack(">s2", pack)
	socket.write(client_fd, package)
end

skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = skynet.tostring,
}

function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog

	skynet.fork(function()
		while true do
			send_package("heartbeat")
			skynet.sleep(500)
		end
	end)

	client_fd = fd
	print("agent start", gate)
	skynet.call(gate, "lua", "forward", fd)
end

function CMD.disconnect()
	-- todo: do something before exit
	
	skynet.exit()
end

local message = function(msg)
	print(client_fd .. " recv msg " .. msg )
end


skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)

	skynet.dispatch("client", function(_,_, msg)
		-- print("dispatch client")
		message(msg)
	end)

end)
