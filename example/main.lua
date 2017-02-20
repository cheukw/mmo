local skynet = require "skynet"

skynet.start(function()
	skynet.error("Server start")

	if not skynet.getenv "daemon" then
		local console = skynet.newservice("console")
	end
	
	local mysqld = skynet.newservice "mysqld"
	-- print("mysqld service ", mysqld)

	skynet.call(mysqld, "lua", "start")
	skynet.call(mysqld, "lua", "server_ver")

	local result = skynet.call(mysqld, "lua", "query", "select * from departments;")
	-- print("result", result)
	print("dept_no\t\tdept_name")
	for i, row in ipairs(result) do
		print(string.format("%s\t\t%s", row["dept_no"], row["dept_name"]))
	end

	skynet.call(mysqld, "lua", "close")
end)



