local skynet = require "skynet"
local basehandler = require "msg.basehandler"
require "msgcode"

local handler = {}

function handler.init(agent)
	handler.agent = agent
	basehandler.init(agent)
	-- print(msgcode_CS, msgcode_CS.MC_CS_GAME_PING, msgcode_CS.MC_CS_GAME_LOGIN)
	handler[msgcode_CS.MC_CS_GAME_PING]   = {fn = basehandler.ping,   proto = "game.ping_c2g"}
	handler[msgcode_CS.MC_CS_GAME_LOGIN]   = {fn = basehandler.login,   proto = "game.login_c2g"}


end



return handler


