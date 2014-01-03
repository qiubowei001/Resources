--lesson 教程

lesson = {}
local  p = lesson;

local winSize = CCDirector:sharedDirector():getWinSize()

local savepath = "save\\player1.xml"
local tSequence = {1,2,3,4,5,10,6,7,8,9,11}--课程顺序
local g_Lesson_Process = 1; --教程进度 即tSequence索引
local gTimerId = nil;--定时检测



local tQuestCache = {}

local tLesson = {}
	tLesson[1]={}
	tLesson[1].desc = "please link 3 times"
	tLesson[1].condition_func = nil		
	tLesson[1].AcceptQuestFunc = function()   --接受任务	
									function lesson1()
										tQuestCache[1] = tQuestCache[1] + 1
										if tQuestCache[1] >= 3 then
											GlobalEvent.unRegisterEvent(GLOBAL_EVENT.LINK_SUCC,lesson1) --完成课程
											g_Lesson_Process = g_Lesson_Process + 1
											Hint.ShowHint(Hint.tHintType.jobdone)
											
										end
									end
									GlobalEvent.RegisterEvent(GLOBAL_EVENT.LINK_SUCC,lesson1)	--链接+1
								 end
	
	tLesson[2]={}
	tLesson[2].desc = "Kill Mon With Sword X3"
	tLesson[2].condition_func = function()	--触发条件
									local count = 0
									--棋盘上有1只怪物就可以触发
									for i = 1,brickInfo.brick_num_X do
										for j = 1,brickInfo.brick_num_Y do
											if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then
												--计数加1
												count = count + 1
											end
										end
									end
									if count >= 1 then
										return true
									else
										return false
									end
								end
								
								
	tLesson[2].AcceptQuestFunc = function()   --接受任务								
									function lesson2()		
										tQuestCache[2] = tQuestCache[2] + 1
										if tQuestCache[2] >= 3 then
											GlobalEvent.unRegisterEvent(GLOBAL_EVENT.KILL_MONSTER,lesson2) --完成课程
											g_Lesson_Process = g_Lesson_Process + 1
											Hint.ShowHint(Hint.tHintType.jobdone)
										end
									end
									GlobalEvent.RegisterEvent(GLOBAL_EVENT.KILL_MONSTER,lesson2)	--链接+1
								 end
								
								
	tLesson[3]={}
	tLesson[3].desc = "Monster will attack if the green bar is CD"
	tLesson[3].condition_func = function()	--触发条件
									local count = 0
									--棋盘上有4只怪物就可以触发
									for i = 1,brickInfo.brick_num_X do
										for j = 1,brickInfo.brick_num_Y do
											if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then
												--计数加1
												count = count + 1
											end
										end
									end
									if count >= 4 then
										return true
									else
										return false
									end
								end
	tLesson[3].AcceptQuestFunc = function()
									g_Lesson_Process = g_Lesson_Process + 1
								end
								
		
		
		
	tLesson[4]={}
	tLesson[4].desc = "the red ball is your life"
	tLesson[4].condition_func = function()	--触发条件	
									--玩家生命值减少至99%
									local percent =100*player[playerInfo.HP]/player[playerInfo.Entity_HPMAX]
									if percent <= 99 then
										return true
									else
										return false
									end
								end

	tLesson[4].AcceptQuestFunc = function()
									
									player.EnergyRecovery(5)--给玩家一些能量
									
									g_Lesson_Process = g_Lesson_Process + 1
								end
								
								
	tLesson[5]={}
	tLesson[5].desc = "link the red bottle to recover life X3"
	tLesson[5].condition_func = function()	--触发条件
									--玩家生命值减少至90%		
									local percent =100*player[playerInfo.HP]/player[playerInfo.Entity_HPMAX]
									if percent <= 90 then
										return true
									else
										return false
									end
								end
	tLesson[5].AcceptQuestFunc = function()   --接受任务								
									function lesson5()
										tQuestCache[5] = tQuestCache[5] + 1
										if tQuestCache[5] >= 3 then
											GlobalEvent.unRegisterEvent(GLOBAL_EVENT.TAKE_BLOOD,lesson5) --完成课程
											g_Lesson_Process = g_Lesson_Process + 1
											Hint.ShowHint(Hint.tHintType.jobdone)
										end
									end
									player.EnergyRecovery(5)--给玩家一些能量
									GlobalEvent.RegisterEvent(GLOBAL_EVENT.TAKE_BLOOD,lesson5)	--链接+1
								 end





	tLesson[6]={}
	tLesson[6].desc = "the blue ball is your energy,your will spend energy everytime you link or use skill"
	tLesson[6].condition_func = function()	--触发条件
									--玩家能量值减少至50%		
									local percent =100*player[playerInfo.ENERGY]/player[playerInfo.Entity_ENERGYMAX]
									if percent <= 50 then
										return true
									else
										return false
									end
								end								
	tLesson[6].AcceptQuestFunc = function()
									g_Lesson_Process = g_Lesson_Process + 1
								end
								
								
	tLesson[7]={}
	tLesson[7].desc = "link the blue bottle to recover energy"
	tLesson[7].condition_func = function()	--触发条件
									--玩家能量值减少至10%		
									local percent =100*player[playerInfo.ENERGY]/player[playerInfo.Entity_ENERGYMAX]
									if percent <= 40 then
										return true
									else
										return false
									end
								end	
	tLesson[7].AcceptQuestFunc = function()   --接受任务								
									function lesson7()
										tQuestCache[7] = tQuestCache[7] + 1
										if tQuestCache[7] >= 3 then
											GlobalEvent.unRegisterEvent(GLOBAL_EVENT.TAKE_ENERGY,lesson7) --完成课程
											g_Lesson_Process = g_Lesson_Process + 1
											Hint.ShowHint(Hint.tHintType.jobdone)
										end
									end
									GlobalEvent.RegisterEvent(GLOBAL_EVENT.TAKE_ENERGY,lesson7)	--链接+1
								 end							

	tLesson[8]={}
	tLesson[8].desc = "link the coin to gain them X3"
	tLesson[8].condition_func = function()	--触发条件
									--棋盘上有1个金币就可以触发
									local count = 0
									for i = 1,brickInfo.brick_num_X do
										for j = 1,brickInfo.brick_num_Y do
											if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.GOLD then
												--计数加1
												count = count + 1
											end
										end
									end
									if count >= 1 then
										return true
									else
										return false
									end
								end					
	tLesson[8].AcceptQuestFunc = function()   --接受任务								
									function lesson8()
										tQuestCache[8] = tQuestCache[8] + 1
										if tQuestCache[8] >= 2 then
											GlobalEvent.unRegisterEvent(GLOBAL_EVENT.TAKE_GOLD,lesson8) --完成课程
											g_Lesson_Process = g_Lesson_Process + 1
											Hint.ShowHint(Hint.tHintType.jobdone)
										end
									end
									
									SkillUpgrade.UnlockSkill(7)--解锁一个点杀技能 眩晕

									GlobalEvent.RegisterEvent(GLOBAL_EVENT.TAKE_GOLD,lesson8)	--链接+1
								 end
																						
	tLesson[9]={}
	tLesson[9].desc = "how to upgrade equipment	"
	tLesson[9].condition_func = function()	--触发条件
									--玩家金币>=100
									if player[playerInfo.GOLD] >= 100 then
										return true
									else
										return false
									end
								end									
	tLesson[9].AcceptQuestFunc = function()   --接受任务								
									function lesson9()
										tQuestCache[9] = tQuestCache[9] + 1
										if tQuestCache[9] >= 1 then
											GlobalEvent.unRegisterEvent(GLOBAL_EVENT.UPGRADE_EQUIP,lesson9) --完成课程
											g_Lesson_Process = g_Lesson_Process + 1
										end
									end
									GlobalEvent.RegisterEvent(GLOBAL_EVENT.UPGRADE_EQUIP,lesson9)	--链接+1
								 end
								
	tLesson[10]={}
	tLesson[10].desc = "how to use buff skill"
	tLesson[10].condition_func = function()	--触发条件
									--玩家有buff技能
									for magicId,v in pairs(player.MagicCD) do
										
										if 	magictable[magicId][MAGIC_DEF_TABLE.TARGET_TYPE] == TARGET_TYPE.PLAYER then --BUFF技能
											return true
										end
									end
									return false
								end
	tLesson[10].AcceptQuestFunc = function()   --接受任务					
									--[[
									function lesson10()		--玩家使用1次技能 则解锁新技能
										
										tQuestCache[10] = tQuestCache[10] + 1
										if tQuestCache[10] >= 1 then
											GlobalEvent.unRegisterEvent(GLOBAL_EVENT.USE_BUFF_SKILL,lesson10) --完成课程
											g_Lesson_Process = g_Lesson_Process + 1
											
										end
									end
									GlobalEvent.RegisterEvent(GLOBAL_EVENT.USE_BUFF_SKILL,lesson10)	--链接+1
									--]]
									
									g_Lesson_Process = g_Lesson_Process + 1
								 end

	tLesson[11]={}
	tLesson[11].desc = "how to use active skill"
	tLesson[11].condition_func = function()	--触发条件
									--玩家有点杀技能
									for magicId,v in pairs(player.MagicCD) do
										if 	magictable[magicId][MAGIC_DEF_TABLE.TARGET_TYPE] ~= TARGET_TYPE.PLAYER then --点杀技能
											return true
										end
									end
									return false
								end
	tLesson[11].AcceptQuestFunc = function()   --接受任务
									--[[
									function lesson11()		--玩家使用1次技能 则解锁新技能
										tQuestCache[11] = tQuestCache[11] + 1
										if tQuestCache[11] >= 1 then
											GlobalEvent.unRegisterEvent(GLOBAL_EVENT.USE_ACTIVE_SKILL,lesson11) --完成课程
											g_Lesson_Process = g_Lesson_Process + 1
											--
										end
									end
									GlobalEvent.RegisterEvent(GLOBAL_EVENT.USE_ACTIVE_SKILL,lesson11)	--链接+1
									--]]
									
									g_Lesson_Process = g_Lesson_Process + 1
								 end



function p.Init()
	--检测是否已经结束教程
	--读取怪物图鉴信息
	local tPlayersave = {}
	tQuestCache	= {}
	
	data(savepath, tPlayersave)
	
	if tPlayersave.lesson== false then
		--初始化任务数据
		for i,v in pairs(tLesson) do
			tQuestCache[i] = nil
		end
		
		--开启检测定时器
		gTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(p.CheckLesson, 3, false)
		g_Lesson_Process = 1;		
	end
end

--检测条件触发教程
function p.CheckLesson()
	
	--教程结束
	if g_Lesson_Process > #tSequence then
		if gTimerId ~= nil then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(gTimerId)
			gTimerId = nil
			local tPlayersave = {}
			data(savepath, tPlayersave)
			tPlayersave.lesson = true;
			data(tPlayersave,savepath )
		end
		return
	end
	
	
	local  lessonid = tSequence[g_Lesson_Process]
	if tQuestCache[lessonid] == nil then	--未接受任务
		if tLesson[lessonid].condition_func == nil or tLesson[lessonid].condition_func() then--接受课程
			--显示界面
			p.LoadUI(lessonid)
			tQuestCache[lessonid] = 0
			tLesson[lessonid].AcceptQuestFunc();		
		end	
	end	
end	

function p.closeUICallback(tag,sender)
	--关闭界面 
	local layer = p.GetParent()
	local scene = Main.GetGameScene();
	scene:removeChild(layer, true)
	
	--
	if CCDirector:sharedDirector():isPaused() then
		CCDirector:sharedDirector():resume()
    end	  --]] 
end


function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.LESSON);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end


--显示界面
function p.LoadUI(lessonid)
	
			
			
	bglayer = CCLayer:create()
	bglayer:setTag(UIdefine.LESSON);
	
	local menu = CCMenu:create()


	local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
		closeBtn:registerScriptTapHandler(p.closeUICallback)
		closeBtn:setPosition(300,400)
		
	menu:addChild(closeBtn)
	menu:setPosition(CCPointMake(0, 0))
	bglayer:addChild(menu, 2,99)

	
	--显示描述
	local sdesc = tLesson[lessonid].desc
	
	local desclabel = CCLabelTTF:create(sdesc, "Arial", 25)
			bglayer:addChild(desclabel,2)
			desclabel:setColor(ccc3(255,0,0))
			desclabel:setPosition(0, 150)

	
	--增加背景 
	local bgSprite = CCSprite:create("UI/lesson/lesson.png")
	--bgSprite:setScale(1.5);
    bglayer:addChild(bgSprite,1)
	bglayer:setPosition(CCPointMake(340, 220))
	bglayer:setScale(0.65);
	
	
	
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,4)	
	
	CCDirector:sharedDirector():pause()
end

