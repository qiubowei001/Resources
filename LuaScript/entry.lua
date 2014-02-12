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

--��Ϸ��ʼ������
dofile("LuaScript/brickInfo.lua")--�궨��
dofile("LuaScript/extern.lua")--�̳��ඨ��
dofile("LuaScript/dataInit.lua")--���ݳ�ʼ��
dofile("LuaScript/GlobalEvent.lua")--ȫ���¼�����


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
