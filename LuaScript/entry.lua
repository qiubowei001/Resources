cclog = function(...)
       CCLuaLog(string.format(...))
		end
	
math.randomseed(os.time())


dofile("LuaScript/UIdefine.lua")

dofile("LuaScript/brickInfo.lua")

dofile("LuaScript/monster.lua")

dofile("LuaScript/brick.lua")

dofile("LuaScript/player.lua")

dofile("LuaScript/Line.lua")

dofile("LuaScript/magic.lua")

dofile("LuaScript/magiceff.lua")

dofile("LuaScript/mission.lua")

dofile("LuaScript/Goldbrick.lua")

dofile("LuaScript/SkillBar.lua")

dofile("LuaScript/SkillUpGradeUI.lua")


dofile("LuaScript/Main.lua")
