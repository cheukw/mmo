local skynet = require "skynet"
local protobuf = require "protobuf"
local socket = require "socket"

require "msgcode"

local logind

local CMD = {}
local handler = {}

local gate

local error_fn = function(fd, msg)
	skynet.call(logind, "lua", "kick", fd, msg)
end

function send_message(fd, id, name, msg)
	local data = protobuf.encode(name, msg)
	-- print("data length", #data)
	local netmsg = {id=id, data=data}
	local pk_buffer = protobuf.encode("base.netmsg", netmsg)
	local pk_buffer_size = #pk_buffer
	-- print("pk_buffer_size", pk_buffer_size)
	local send_buffer = string.pack(">I2", pk_buffer_size)..pk_buffer
	-- print("send_buffer_size", #send_buffer)

	socket.write(fd, send_buffer)
end


function CMD.message(fd, msg, sz)
	local netmsg = protobuf.decode("base.netmsg", netpack.tostring(msg, sz))
	if not netmsg then
		error_fn(fd, "[netmsg] message unpack error.")
		return
	end
	local id = netmsg.id
	local data = netmsg.data
	print("recv msg id", id, data)
	if handler[id] then
		local msg = protobuf.decode(handler[id].proto, data)
		if msg then
			handler[id].fn(fd, msg)
		else
			error_fn(fd, string.format("[%s] unpack error.", handler[id].proto))
		end
	else
		--skynet.error(string.format("msg id %d not exit.", id))
		error_fn(fd, string.format("msg id %d not exit.", id))
	end
end

local ping = function(fd, msg)
	print("[auth:ping]", msg.hello)
	send_message(fd, msgcode_SC.MC_SC_PONG, "login.pong", {hello="ping succ."})
end

local signin = function(fd, msg)
	print("[auth:signin]", msg.id, msg.name, msg.passwd, msg.sdkid, msg.token)
	
end

local signup = function(fd, msg)
	print("[auth:signup]", msg)

end

-- 
local auth_success = function(fd, token, username, server, role_list)
	
end

local auth_failure = function(fd)
	
end


skynet.init(function()
	protobuf.register_file("./protocol/pb/base.pb")
	protobuf.register_file("./protocol/pb/login.pb")

	print("msg code ", msgcode_CS.MC_CS_PING, handler)
	handler[msgcode_CS.MC_CS_PING]   = {fn = ping,   proto = "login.ping"}
	handler[msgcode_CS.MC_CS_SIGNIN] = {fn = signin, proto = "login.signin"}
	handler[msgcode_CS.MC_CS_SIGNUP] = {fn = signup, proto = "login.signup"}
	
	logind = skynet.uniqueservice("logind")
	--skynet.call(logind, "lua", "test")
end)

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd])
		f(...)
	end)

end)
