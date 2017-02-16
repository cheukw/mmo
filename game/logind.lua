local skynet = require "skynet"
local protobuf = require "protobuf"

local AUTH = {}
local CMD = {}

local auth_users = {}

local handler = {}

function AUTH.open(fd, addr)
	print("logind auth open ", fd, addr)
	-- check the client addr
	local addr_valid = function(addr)
		return true
	end 
	if addr_valid(addr) then
		auth_users[fd] = addr
	end

end

function signin(fd, msg)
	skynet.error(string.format("logind signin fd:%d\n", fd))
	print(msg.id, msg.name, msg.passwd, msg.sdkid, msg.token)
end

function signup(fd, msg)
	skynet.error(string.format("logind signup fd:%d\n", fd))
	print(msg)
end

function ping(fd, msg)
	skynet.error(string.format("logind ping fd:%d\n", fd))
	print("logind ping",msg.hello)
end

function AUTH.data(fd, msg)
	-- print("logind auth data ", fd, msg)
	if auth_users[fd] == nil then
		return
	end

	local netmsg = protobuf.decode("base.netmsg", msg)
	if not netmsg then
		skynet.error("netmsg unpack error")
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
			skynet.error(string.format("parse %s error.", handler[id].proto))
		end
	else
		skynet.error(string.format("msg id %d not exit.", id))
	end
end

function CMD.start(conf)
	skynet.error("logind start.")

	protobuf.register_file("./protocol/pb/base.pb")
	protobuf.register_file("./protocol/pb/login.pb")

	handler[1000] = {fn = signin, proto = "login.signin"}
	handler[1001] = {fn = signup, proto = "login.signup"}
	handler[1010] = {fn = ping, proto = "login.ping"}

end

function CMD.close()
	
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, subcmd, ...)
		if cmd == "auth" then
			local f = AUTH[subcmd]
			f(...)
		else
			print("logind entry function ", cmd)
			local f = assert(CMD[cmd])
			skynet.ret(skynet.pack(f(subcmd, ...)))
		end
	end)

end)