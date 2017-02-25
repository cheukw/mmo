local skynet = require "skynet"
local crypt = require "crypt"

local CMD = {}
local st2
function CMD.test_crypt()
	local key = crypt.randomkey()
	print("randomkey", key, type(key), string.len(key))
	local buf = crypt.hexencode(key)
	print("hex:", buf, string.len(buf))
	local buf = crypt.base64encode(key)
	print("base64:", buf, string.len(buf))
	local key2 = crypt.base64decode(buf)
	print(crypt.hexencode(key2))
end

local thread_id
function CMD.test_sleep()
	print("test_sleep....starting.")
	-- thread_id = coroutine.running()
	-- skynet.wait()
	-- skynet.yield()
	skynet.call(st2, "lua", "start")
	print("test_sleep....end.")
end

function CMD.test_sleep2()
	print("test_sleep2.....")
	-- skynet.wakeup(thread_id)
	-- thread_id = nil
end

function CMD.exit()
	print("cmd exit")
	skynet.exit()
end

function set_timeout(ti, f)
	local function t()
		if f then
			f()
		end
	end
	skynet.timeout(ti, t)
	return function() f=nil end
end

function CMD.test_timer()
	print("test_timer")
	set_timeout(100, function()
		print("create timer.")
	end)
end

function CMD.test_canceltimer()
	print("test_canceltimer")
	set_timeout(100, nil)
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)

	st2 = skynet.newservice "sometest2"
end)