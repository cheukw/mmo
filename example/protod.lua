local skynet = require "skynet"
local protobuf = require "protobuf"

local CMD = {}

function CMD.decode(data)
	local netmsg = protobuf.decode("base.netmsg", data)
	if not netmsg then
		error("unpack msg error.")
	end

	local msg
	if netmsg.id == 2001 then
		msg = protobuf.decode("game.ping", data)
	elseif netmsg.id == 2002 then
		 
	end

	return msg
end

function CMD.encode(id, name, msg)
	local data = protobuf.encode(name, msg)
	if not data then return end
	
	local netmsg = {id=id, data=data}
	local pk_buffer = protobuf.encode("base.netmsg", netmsg)
	local pk_buffer_size = #pk_buffer
	local send_buffer = string.pack(">I2", pk_buffer_size)..pk_buffer
	return send_buffer
end


function CMD.exit()
	skynet.exit()
end

skynet.init(function()
	protobuf.register_file("./protocol/pb/base.pb")
	protobuf.register_file("./protocol/pb/game.pb")
end)

skynet.start(function()
	skynet.error("protod start.")
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
end)