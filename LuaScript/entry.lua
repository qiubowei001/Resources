cclog = function(...)
       CCLuaLog(string.format(...))
		end


function __G__TRACKBACK__(msg)
    CCLuaLog("----------------------------------------")
    CCLuaLog("LUA ERROR: " .. tostring(msg) .. "\n")
    CCLuaLog(debug.traceback())
    CCLuaLog("----------------------------------------")
end

		
--math.randomseed(os.time())


g_sceneGame = CCScene:create();
CCDirector:sharedDirector():runWithScene(g_sceneGame)

dofile("LuaScript/brickInfo.lua")

dofile("LuaScript/extern.lua")



dofile("LuaScript/PassiveSkill.lua")

dofile("LuaScript/UI/ProgressBar.lua")

dofile("LuaScript/MissionSelectUI.lua")

dofile("LuaScript/UIdefine.lua")

dofile("LuaScript/monster.lua")

dofile("LuaScript/brick.lua")

dofile("LuaScript/Particle.lua")

dofile("LuaScript/player.lua")

dofile("LuaScript/Line.lua")

dofile("LuaScript/magic.lua")

dofile("LuaScript/magiceff.lua")

dofile("LuaScript/mission.lua")

dofile("LuaScript/Goldbrick.lua")

dofile("LuaScript/SkillBar.lua")

dofile("LuaScript/SkillUpGradeUI.lua")

dofile("LuaScript/SkillUpgrade.lua")

dofile("LuaScript/TimerBuff.lua")

dofile("LuaScript/EquipUpGradeUI.lua")

dofile("LuaScript/SpriteConfig.lua")

dofile("LuaScript/SpriteManager.lua")

dofile("LuaScript/SpeedUpBuff.lua")

dofile("LuaScript/GameOverUI.lua")

dofile("LuaScript/MainUI.lua")

dofile("LuaScript/Main.lua")

--xpcall(Main.main, __G__TRACKBACK__)
xpcall(MissionSelectUI.LoadUI, __G__TRACKBACK__)