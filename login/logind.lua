local skynet = require "skynet"
local gateserver = require "snax.gateserver"

local connection = {}	-- fd -> connection : { fd , client, agent , ip, mode }

local handler = {}
local auth

function handler.open(source, conf)
	auth = skynet.uniqueservice("auth")
	--skynet.call(auth, "lua", "start")
end

function handler.message(fd, msg, sz)
	skynet.send(auth, "lua", "message", fd, msg, sz)
end

function handler.connect(fd, addr)
	local c = {
		fd = fd,
		ip = addr,
	}
	connection[fd] = c

	gateserver.openclient(fd)
end

local function close_fd(fd)
	local c = connection[fd]
	if c then
		connection[fd] = nil
	end
end

function handler.disconnect(fd)
	close_fd(fd)
	
end

function handler.error(fd, msg)
	close_fd(fd)
end

function handler.warning(fd, size)
	
end

local CMD = {}

function CMD.accept(source, fd)
	local c = assert(connection[fd])
	gateserver.openclient(fd)
end

function CMD.kick(source, fd)
	gateserver.closeclient(fd)
	close_fd(fd)
end

function CMD.test(source)
	print("logind CMD.test", source)
end

function handler.command(cmd, source, ...)
	local f = assert(CMD[cmd])
	return f(source, ...)
end

gateserver.start(handler)
