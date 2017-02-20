local skynet = require "skynet"
local mysql = require "mysql"

local CMD = {}
local db

function CMD.start()
	-- print("CMD.start start connect.")
	db = mysql.connect{
		host = "127.0.0.1",
		port = 3306,
		database = "employees",
		user = "root",
		password = "sa12345",
		max_packet_size = 1024 * 1024
	}

	-- print("CMD.start start connect end.")
	if db then
		-- print("connect to mysql success.")
		db:query("set charset utf8")
	else
		skynet.error("mysql connect error.")
	end
end

function CMD.server_ver()
	print("server_ver", mysql.server_ver(db))
end


function CMD.close()
	mysql.disconnect(db)
end

function CMD.query(sql)
	return mysql.query(db, sql)
end

skynet.init(function()
	print("mysqld service init.")
end)

skynet.start(function()
	print("mysqld service start.")
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
		
end)
