local skynet = require "skynet"


local CMD = {}

function CMD.start()
	
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd])
		f(...)
	end)
end)