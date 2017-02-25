local skynet = require "skynet"

local CMD = {}

function CMD.start()
	skynet.sleep(100)
end



skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
end)