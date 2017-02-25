local skynet = require "skynet"

local CMD = {}

local mysqld
local redisd

function CMD.start()
	mysqld = skynet.newservice "mysqld"
	-- print("mysqld service ", mysqld)

	skynet.call(mysqld, "lua", "start")
	--skynet.call(mysqld, "lua", "server_ver")

	redisd = skynet.newservice "redisd"
	skynet.call(redisd, "lua", "start")
end

function CMD.test()
	-- local result = skynet.call(mysqld, "lua", "query", "select * from departments;")
	-- -- print("result", result)
	-- print("dept_no\t\tdept_name")
	-- for i, row in ipairs(result) do
	-- 	print(string.format("%s\t\t%s", row["dept_no"], row["dept_name"]))
	-- end

	-- local result = skynet.call(mysqld, "lua", "query", "select * from employees where emp_no < 10010")
	-- for i, row in ipairs(result) do
	-- 	print(string.format("%s\t%s\t%s\t\t\t\t%s\t\t\t%s\t%s", 
	-- 		row["emp_no"], row["birth_date"], row["first_name"], row["last_name"], row["gender"], row["hire_date"]))
	-- end

	-- local start_time = os.time()
	-- local row_count_ret = skynet.call(mysqld, "lua", "query", "select COUNT(*) from employees")
	-- local row_count = row_count_ret[1]["COUNT(*)"]
	-- print("employees row_count:", row_count, type(row_count))
	-- local counter = 0
	-- local step = 1000
	-- for i = 1, 10000, step do
	-- 	counter = counter + 1
	-- 	local sql = "select * from employees order by emp_no limit "..i..","..i+step-1
	-- 	--print(sql)
	-- 	local result = skynet.call(mysqld, "lua", "query", sql)
	-- 	for i, row in ipairs(result) do
	-- 		local key = "emps:"..row["emp_no"]
	-- 		-- for filed, value in pairs(row) do
	-- 		-- 	skynet.call(redisd, "lua", "hset", key, filed, value)
	-- 		-- end
	-- 		skynet.call(redisd, "lua", "hmset", key, row)
	-- 	end
	-- end
	-- local end_time = os.time()
	-- print(counter, "diff time:", end_time - start_time)
	
	-- local name = skynet.call(redisd, "lua", "get", "name")
	-- print("name: ", name)
	-- print(skynet.call(redisd, "lua", "ping"))

	-- skynet.call(redisd, "lua", "set", "foo", "bar", "EX", 60)
	-- print(skynet.call(redisd, "lua", "get", "foo"))
	-- print(skynet.call(redisd, "lua", "ttl", "foo"))

	-- for i, row in ipairs(result) do
	-- 	local key = "users:"..row["emp_no"]
	-- 	for filed, value in pairs(row) do
	-- 		skynet.call(redisd, "lua", "hset", key, filed, value)
	-- 	end
	-- end

	local data1 = {login_id = 1, plat_user_name="uc", ditch_name=2, 
					role_id_1=1001, role_id_2=2001, role_id_3=1987,
					last_login_time=1483203661, create_time=1451581261,forbid_time=0,
					is_anti_wallow = 0
				}
	local data2 = {login_id = 2, plat_user_name="37wan", ditch_name=5, 
					role_id_1=1002, role_id_2=2021, role_id_3=1937,
					last_login_time=1485203661, create_time=1451541261,forbid_time=0,
					is_anti_wallow = 0
				}

	local key = "login:"..data1.login_id
	for filed, value in pairs(data1) do
		print(filed, value)
		skynet.call(redisd, "lua", "hset", key, filed, value)
	end

	local key = "login:"..data2.login_id
	for filed, value in pairs(data2) do
		print(filed, value)
		skynet.call(redisd, "lua", "hset", key, filed, value)
	end

	local lret = skynet.call(redisd, "lua", "hgetall", "login:1")
	print(lret, #lret)
	
	for k,v in pairs(lret) do
		print(k, v, type(v))
	end

	local create_time = math.tointeger(lret[10])
	print(create_time, type(create_time))
end

function CMD.close()
	skynet.call(mysqld, "lua", "close")
end

skynet.start(function()
	skynet.dispatch("lua", function(session, source, cmd, ...)
		local f = assert(CMD[cmd], cmd .. "not found")
		skynet.retpack(f(...))
	end)
		
end)