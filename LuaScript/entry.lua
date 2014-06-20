cclog = function(...)
       CCLuaLog(string.format(...))
		end

local Release = false --是否用真机调试
if Release then
	dofile = require
end

function __G__TRACKBACK__(msg)
    CCLuaLog("----------------------------------------")
    CCLuaLog("LUA ERROR: " .. tostring(msg) .. "\n")
    CCLuaLog(debug.traceback())
    CCLuaLog("----------------------------------------")
end

cclog("qbw99:1b")

--
math.randomseed(os.time())



g_sceneGame = nil
cclog("qbw99:12")
--游戏初始化工作
dofile("LuaScript/brickInfo.lua")--宏定义
cclog("qbw99:13")
dofile("LuaScript/extern.lua")--继承类定义
cclog("qbw99:14")
dofile("LuaScript/dataInit.lua")--数据初始化
cclog("qbw99:15")
dofile("LuaScript/GlobalEvent.lua")--全局事件触发

cclog("qbw99:2")

dofile("LuaScript/MissionConfig.lua")

dofile("LuaScript/SkillLockUI.lua")

dofile("LuaScript/lesson.lua")

dofile("LuaScript/MonsterHandBook.lua")

dofile("LuaScript/GameBg.lua")
cclog("qbw99:3")

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
cclog("qbw99:4")

dofile("LuaScript/Particle.lua")
cclog("qbw99:41")
dofile("LuaScript/player.lua")
cclog("qbw99:42")
dofile("LuaScript/line.lua")
cclog("qbw99:43")
dofile("LuaScript/magic.lua")
cclog("qbw99:44")
dofile("LuaScript/magiceff.lua")
cclog("qbw99:45")
dofile("LuaScript/mission.lua")
cclog("qbw99:5")

dofile("LuaScript/Goldbrick.lua")

dofile("LuaScript/SkillBar.lua")

dofile("LuaScript/SkillUpGradeUI.lua")

dofile("LuaScript/SkillUpgrade.lua")

dofile("LuaScript/Combo.lua")

dofile("LuaScript/EquipUpGradeUI.lua")

dofile("LuaScript/SpriteConfig.lua")
cclog("qbw99:6")

dofile("LuaScript/SpriteManager.lua")

dofile("LuaScript/SpeedUpBuff.lua")

dofile("LuaScript/GameOverUI.lua")

dofile("LuaScript/MainUI.lua")

dofile("LuaScript/Main.lua")
cclog("qbw99:7")

--xpcall(Main.main, __G__TRACKBACK__)
xpcall(MissionSelectUI.LoadUI, __G__TRACKBACK__)
xpcall(MissionSelectUI.RunScene, __G__TRACKBACK__)
