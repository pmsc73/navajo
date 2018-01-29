-- log.lua

log = {}
logger = {}

function init_log(name)
	local l = log
	if log[name] == nil then
		log[name] = {}
	else
		return
	end

	log[name]["damage"] = 0
	log[name]["kills"] = 0

end

function logger.logDamage(name, d) 
	init_log(name)
	gfx.create_text_entity(name.. ", damage: " .. d,5, 10)
	log[name]["damage"] = log[name]["damage"] + d

end

function logger.logDeath(name) 
	init_log(name)
	log[name]["kills"] = log[name]["kills"] + 1
end

function logger.log() 
	return log
end