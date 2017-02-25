local skynet = require "skynet"
local redis = require "redis"

local CMD = {}

local db

function CMD.start()
	db = redis.connect{
		host = "127.0.0.1",
		port = 6379,
		auth = "123456",
	}
	if db then
		-- db:flushdb()
		skynet.error("redis connect success.")
	else
		skynet.error("redis connect error.")
	end
end

function CMD.set(key, value, ...)
	return db:set(key, value, ...)
end

function CMD.get(key)
	return db:get(key)
end

function CMD.ttl(key)
	return db:ttl(key)
end

function CMD.ping()
	return db:ping()
end

function CMD.hset(key, filed, value)
	return db:hset(key, filed, value)
end

function CMD.hget(key, filed)
	return db:hget(key, filed)
end

function CMD.hmset(key, tb)
	local data = {}
	for k, v in pairs(tb) do
		table.insert(data, k)
		table.insert(data, v)
	end
	return db:hmset(key, table.unpack(data))
end

function CMD.hmget(key, ...)
	if not key then return end
	return db:hmget(key, ...)
end


function CMD.hgetall(key)
	return db:hgetall(key)
end

skynet.init(function()
	print("redisd service init.")
end)

skynet.start(function()
	print("redisd service start.")
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
		
end)