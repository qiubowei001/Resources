--lesson 教程

lesson = {}
local  p = lesson;

local winSize = CCDirector:sharedDirector():getWinSize()

local savepath = "save\\lesson.xml"
local g_Lesson_Process = 1; --教程进度
local gTimerId = nil;--定时检测

local tLesson = {}
	tLesson[1]={}
	tLesson[1].desc = "如何连接消除"
	tLesson[1].condition_func = nil
	
	
	tLesson[2]={}
	tLesson[2].desc = "消剑杀怪"
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

	tLesson[3]={}
	tLesson[3].desc = "怪物攻击CD介绍"
	tLesson[3].condition_func = function()	--触发条件
									local count = 0
									--棋盘上有5只怪物就可以触发
									for i = 1,brickInfo.brick_num_X do
										for j = 1,brickInfo.brick_num_Y do
											if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then
												--计数加1
												count = count + 1
											end
										end
									end
									if count >= 5 then
										return true
									else
										return false
									end
								end

	tLesson[4]={}
	tLesson[4].desc = "血球介绍"
	tLesson[4].condition_func = function()	--触发条件	
									--玩家生命值减少至99%
									local percent =100*player[playerInfo.HP]/player[playerInfo.Entity_HPMAX]
									if percent <= 99 then
										return true
									else
										return false
									end
								end


	tLesson[5]={}
	tLesson[5].desc = "消血回血"
	tLesson[5].condition_func = function()	--触发条件
									--玩家生命值减少至50%		
									local percent =100*player[playerInfo.HP]/player[playerInfo.Entity_HPMAX]
									if percent <= 50 then
										return true
									else
										return false
									end
								end
								
	tLesson[6]={}
	tLesson[6].desc = "介绍每次行为消耗能量"
	tLesson[6].condition_func = function()	--触发条件
									--玩家能量值减少至50%		
									local percent =100*player[playerInfo.ENERGY]/player[playerInfo.Entity_ENERGYMAX]
									if percent <= 50 then
										return true
									else
										return false
									end
								end								

	tLesson[7]={}
	tLesson[7].desc = "消蓝回复能量"
	tLesson[7].condition_func = function()	--触发条件
									--玩家能量值减少至10%		
									local percent =100*player[playerInfo.ENERGY]/player[playerInfo.Entity_ENERGYMAX]
									if percent <= 10 then
										return true
									else
										return false
									end
								end	

	tLesson[8]={}
	tLesson[8].desc = "消金币"
	tLesson[8].condition_func = function()	--触发条件
									--棋盘上有5个金币就可以触发
									local count = 0
									for i = 1,brickInfo.brick_num_X do
										for j = 1,brickInfo.brick_num_Y do
											if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.GOLD then
												--计数加1
												count = count + 1
											end
										end
									end
									if count >= 5 then
										return true
									else
										return false
									end
								end					
														
	tLesson[9]={}
	tLesson[9].desc = "如何升级装备	"
	tLesson[9].condition_func = function()	--触发条件
									--玩家金币>=100
									if player[playerInfo.GOLD] >= 100 then
										return true
									else
										return false
									end
								end

	tLesson[10]={}
	tLesson[10].desc = "如何使用buff技能"
	tLesson[10].condition_func = function()	--触发条件
									--玩家有buff技能
									for magicId,v in pairs(player.MagicCD) do
										--player.MagicCD[magicId] = magictable[magicId][MAGIC_DEF_TABLE.CDROUND]
										if 	magictable[magicId][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER then --BUFF技能
											return true
										end
									end
									return false
								end


	tLesson[11]={}
	tLesson[11].desc = "如何使用点杀技能"
	tLesson[11].condition_func = function()	--触发条件
									--玩家有点杀技能
									for magicId,v in pairs(player.MagicCD) do
										if 	magictable[magicId][MAGIC_DEF_TABLE.TARGET_TYPE] ~= TARGET_TYPE.PLAYER then --点杀技能
											return true
										end
									end
									return false
								end


function p.Init()
	--开启检测定时器
	gTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(p.CheckLesson, 3, false)
	g_Lesson_Process = 1;
end

--检测条件触发教程
function p.CheckLesson()
	
	--教程结束
	if g_Lesson_Process > #tLesson then
		if gTimerId ~= nil then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(gTimerId)
			gTimerId = nil
		end
		return
	end
	
	
	if tLesson[g_Lesson_Process].condition_func == nil then  --无需触发则直接显示
		--显示界面
		p.LoadUI(g_Lesson_Process)
		g_Lesson_Process = g_Lesson_Process + 1
	elseif tLesson[g_Lesson_Process].condition_func() then	--达成条件则显示
		p.LoadUI(g_Lesson_Process)
		g_Lesson_Process = g_Lesson_Process + 1
	end
	
end	


--显示界面
function p.LoadUI(nMonsterType)
	local nAttIndicator,nHPIndicator,nSpeedIndicator  = p.GetHandBookInfo(nMonsterType)
	
	--暂停游戏

	bglayer = CCLayer:create()

	local menu = CCMenu:create()


	local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
		closeBtn:registerScriptTapHandler(p.closeUICallback)
		closeBtn:setPosition(300,400)
		
	menu:addChild(closeBtn)
	menu:setPosition(CCPointMake(0, 0))
	bglayer:addChild(menu, 2,99)


	bglayer:setTag(UIdefine.MONSTER_HANDBOOK_UI);
	
	local t = {nAttIndicator,nHPIndicator,nSpeedIndicator}
	
	for i,indicator in pairs(t) do
		local tPosInfo = tPositionAttribute[i]
	
		for j=1,indicator do
			local tpos = tPosInfo[1]
			local posx = tpos[1] + tJiangeStep*(j-1)
			local posy = tpos[2]
			local pICON = CCSprite:create(tPosInfo[2])
			pICON:setPosition(CCPointMake(posx,posy))
			bglayer:addChild(pICON, 2)
		end
	end		
	
	--增加背景 
	local bgSprite = CCSprite:create("UI/Handbook/lesson.png")
	--bgSprite:setScale(1.5);
    bglayer:addChild(bgSprite,1)
	bglayer:setPosition(CCPointMake(340, 220))
	bglayer:setScale(0.65);
	
	
	--怪物sprite
	local pmon =  SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(nMonsterType))
	pmon:setScale(4);
	pmon:setPosition(CCPointMake(0, 220))
	bglayer:addChild(pmon,2)	
	
	
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,4)	
	
	CCDirector:sharedDirector():pause()
	
end


function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.MONSTER_HANDBOOK_UI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end

