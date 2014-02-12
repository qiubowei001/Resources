cclog = function(...)
       CCLuaLog(string.format(...))
		end


function __G__TRACKBACK__(msg)
    CCLuaLog("----------------------------------------")
    CCLuaLog("LUA ERROR: " .. tostring(msg) .. "\n")
    CCLuaLog(debug.traceback())
    CCLuaLog("----------------------------------------")
end

		
math.randomseed(os.time())

g_sceneGame = nil

--游戏初始化工作
dofile("LuaScript/brickInfo.lua")--宏定义
dofile("LuaScript/extern.lua")--继承类定义
dofile("LuaScript/dataInit.lua")--数据初始化
dofile("LuaScript/GlobalEvent.lua")--全局事件触发


dofile("LuaScript/MissionConfig.lua")

dofile("LuaScript/SkillLockUI.lua")

dofile("LuaScript/lesson.lua")

dofile("LuaScript/MonsterHandBook.lua")

dofile("LuaScript/GameBg.lua")

dofile("LuaScript/Hint.lua")

dofile("LuaScript/ValueToPic.lua")

dofile("LuaScript/PassiveSkill.lua")

dofile("LuaScript/UI/NumberToPic.lua")
dofile("LuaScript/UI/ProgressBar.lua")
dofile("LuaScript/UI/dragBar.lua")

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

dofile("LuaScript/Combo.lua")

dofile("LuaScript/EquipUpGradeUI.lua")

dofile("LuaScript/SpriteConfig.lua")

dofile("LuaScript/SpriteManager.lua")

dofile("LuaScript/SpeedUpBuff.lua")

dofile("LuaScript/GameOverUI.lua")

dofile("LuaScript/MainUI.lua")

dofile("LuaScript/Main.lua")

--xpcall(Main.main, __G__TRACKBACK__)
xpcall(MissionSelectUI.LoadUI, __G__TRACKBACK__)
xpcall(MissionSelectUI.RunScene, __G__TRACKBACK__)
