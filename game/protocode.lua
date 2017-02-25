local skynet = require "skynet"
local protobuf = require "protobuf"

local proto = {}
local CMD = {}
function CMD.encode(id, name, msg)
	if not msg then
		error("msg is nil")
		return false
	end

	local data = protobuf.encode(name, msg)
	if not data then
		error("pb_encode error")
		return false
	end

	local netmsg = {id=id, data=data}
	data = protobuf.encode("base.netmsg", data)
	if not data then
		return false
	end
	return data
end

function CMD.decode(data)
	print("protocol decode")
	local netmsg = protobuf.decode("base.netmsg", data)
	if not netmsg then
		error("pb_decode error")
		return false
	end
	if not proto[netmsg.id] then
		return false
	end

	local msg = protobuf.decode(proto[netmsg.id], netmsg.data)
	if not msg then
		return false
	end

	print("protocol decode")
	return netmsg.id, msg
end

skynet.init(function()
	protobuf.register_file("./protocol/pb/base.pb")
	protobuf.register_file("./protocol/pb/game.pb")

	proto[2001] = "game.ping_c2g"
	proto[2002] = "game.login_c2g"

end)

skynet.start(function()
	skynet.dispatch("lua", function(_, _, cmd, ...)
		print("cmd cmd ", cmd)
		local f = assert(CMD[cmd])
		skynet.ret(skynet.pack(f(...)))
	end)
end)

