skynetroot = "./skynet/"

thread = 4

logger = nil
logpath = "."

harbor = 0

start = "main"	-- main script
bootstrap = "snlua bootstrap"	-- The service for bootstrap

login_addr = "127.0.0.1"
login_port = 8886
debug_port = 8002

cluster = "./cluster/clustername.lua"
nodename = "login"

log_dirname = "log"
log_basename = "login"

loginservice = "./login/?.lua;"

luaservice = skynetroot .. "service/?.lua;" .. loginservice
snax = loginservice

lualoader = skynetroot .. "lualib/loader.lua"
-- preload = "./login/preload.lua"

cpath = skynetroot .. "cservice/?.so"

lua_path = skynetroot .. "lualib/?.lua;" .. 
			"./lualib/?.lua;" .. 
			"./common/?.lua"

lua_cpath = skynetroot .. "luaclib/?.so;" .. "./luaclib/?.so"

--daemon = "./game.pid"