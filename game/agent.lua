local skynet = require "skynet"
local netpack = require "netpack"
local socket = require "socket"
local queue = require "skynet.queue"

local cs = queue()
local msghandler = {}
local proto

local WATCHDOG
local CMD = {}
local client_fd

local disconnect = function()
	skynet.call(WATCHDOG, "lua", "close", client_fd)
end

local send_message= function(id, name, msg)
	local data = skynet.call(proto, "lua", "encode", id, name, msg)
	if not data then return end
	local pk_buffer_size = #data
	local send_buffer = string.pack(">I2", pk_buffer_size)..data
	socket.write(client_fd, send_buffer)
end


local ping = function(msg)
	send_message(2001, "game.pong_g2c", {msg = "pong->ping success."})
end

local login = function(msg)
	print("basehandler.login", msg.token, msg.role_id)
end


local msg_unpack = function(msg, sz)
print("msg_unpack")
	local id, msg = skynet.call(proto, "lua", "decode", skynet.tostring(msg, sz))
	if id == false then
		disconnect()
		return
	end	
	return id, msg
end

local msg_dispatch = function(id, msg)
	if not msg then return end
	msghandler[id].fn(msg)
end


skynet.register_protocol {
	name = "client",
	id = skynet.PTYPE_CLIENT,
	unpack = function (msg, sz)
		return msg_unpack(msg, sz)
	end,

	dispatch = function(source, session, id, msg)
		msg_dispatch(id, msg)
	end,
}

function CMD.start(conf)
	local fd = conf.client
	local gate = conf.gate
	WATCHDOG = conf.watchdog
	-- print("hello client accept", fd)
	client_fd = fd
	skynet.call(gate, "lua", "forward", fd)

	-- send_message(2001, "game.pong_g2c", {msg = "pong->ping success."})
end

local disconnect_count = 0
function CMD.disconnect()
	skynet.exit()
	print("agent disconnect")
end

function CMD.send(id, name, msg)
	cs(function() send_message(id, name, msg) end)
end

skynet.init(function()
	msghandler[msgcode_CS.MC_CS_GAME_PING]   = {fn = ping,   proto = "game.ping_c2g"}
	msghandler[msgcode_CS.MC_CS_GAME_LOGIN]   = {fn = login,   proto = "game.login_c2g"}
	proto = skynet.uniqueservice "protocode"
end)

skynet.start(function()
	skynet.dispatch("lua", function(_,_, command, ...)
		local f = CMD[command]
		skynet.ret(skynet.pack(f(...)))
	end)
end)


