Main = {}
local p = Main;
-- for CCLuaEngine traceback




layerMain = {};

local ntest = 0;
local testbossid = 5;
Board = {};

--======游戏环境变量=======--
tParamEvn = {};
tParamEvn.playerAttDamageThisRound = 0
--==========================--





Main.gamephase = GameLogicPhase.BEFORE_PLAYER_ACT;



Main.selectMode = SELECTMODE.NORMAL;
Main.ChosedMagic = 0;

local gBrickFallTimerId = nil;
local gWaveTimerId = nil;
local gMonsterCdTimerId = nil;

local g_HPlabeltag =1;
local g_ATlabeltag= 2;
local g_goldlabeltag= 3;
local g_Tiplabeltag = 4;
local g_EXPlabeltag = 5;
local g_LEVlabeltag =6;

local glayerMenu = nil;



--生成一波砖块
local gWaveCount = 0; --掉落砖块剩余数量


function Main.CloseAllUI()
	for i,v in pairs(UIdefine) do 
		g_sceneGame:removeChildByTag(v, true)
	end
end


function Main.IfBoardFull()
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			
			if Board[i][j] == nil then
				return false;
			end
		end
	end
	return true;
end

--怪物攻击冷却计时器
function Main.MonsterAttackTimer()
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			
			if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then
				--计数加1
				monster.AttackCDPlusOne(Board[i][j]);
			end
		end
	end
end


local WaveTick = 0
function Main.CreatebrickWave()
	
	gWaveCount = gWaveCount + mission.GetWaveCount()		
end

function Main.SpeedUpWave()
	WaveTick = mission.GetWaveDelay();
	SpeedUpBuff.GetPrize(mission.GetWaveCount());
end


function Main.WaveTimer()
		
	local delay = mission.GetWaveDelay()

	WaveTick = WaveTick + 1;
	if WaveTick>= delay then
		WaveTick = delay
	end
	
	MainUI.setWaveTimer(WaveTick*100/delay);
	
	if WaveTick >= delay then
		WaveTick = 0
		--回合数加1
		mission.RoundPlusOne();
		Main.CreatebrickWave()
	end	
end

function Main.GetMonsterCDTimerId()
	return gMonsterCdTimerId
end

function Main.GetWaveTimerId()
	return gWaveTimerId
end

function Main.GetBrickFallTimerId()
	return gBrickFallTimerId
end

--是否清除了所有怪物
function Main.IfMonsterCleared()
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then
				if Board[i][j].nType == tbrickType.MONSTER then
					return false
				end
			end
		end
	end	
	return true
end

--掉落一块砖块
function Main.brickfallLogic()
		if Main.IfBoardFull() then
			--游戏结束
			GameOverUI.LoadUI(2)
			return;
		end
		
		
		
		--所有方块向下掉落
		local nNum = brickInfo.brick_num_X;
		for i=1,nNum do
			for j = 1, brickInfo.brick_num_Y do
				local Ytarget,Ysource = p.getBoardEmptyYFromX(i)
				
				if( Ytarget and Ysource ) then
					local pbrick = Board[i][Ysource];
					Board[i][Ysource] = nil;
					Board[i][Ytarget] = pbrick;
					
					local timetick = Ysource - Ytarget;
					if timetick >0 then
						timeinterval = timetick / pbrick.brickSpeed  *0.3;
					end
					pbrick.movetoTime = timeinterval;					
					p.brickMoveTo(pbrick,i,Ytarget);			
					--加入JUMP特效				
				else
					break;
				end	
			end
		end

		
		--砖块计数
		if gWaveCount <= 0 then
			return
		end
		gWaveCount = gWaveCount - 1

		
		local nwidth = brickInfo.brickWidth;

		local tTypeId ={}
		local j =1;
		for i,v in pairs(tbrickType)do
			tTypeId[j] = v
			j = j+1;
		end		
		
		local tYempty = {}
		for i=1,nNum do
			local Yempty = p.getBoardEmptyYFromX(i)
			tYempty[i] = Yempty;
		end
		
		--寻找最低点释放
		local tTmp = {}
					--INDEX VAL
		tTmp[1] = {100,100}
		
		for i,v in pairs(tYempty) do
			if  v~= false then
				if v < tTmp[1][2] then
					tTmp = {}
					tTmp[1]={}
					tTmp[1][2] = v
					tTmp[1][1] = i
				elseif v == tTmp[1][2] then
					table.insert(tTmp,{i,v});
				end
			end
		end
		

		if tTmp[1][1]==100 then
			return;
		end
		
		local index = math.random(1,#tTmp);
		local X = tTmp[index][1]
		local Ymin = tTmp[index][2]

		local nbricktype,bEnd = mission.GenerateBrickType();
		local pbrick=nil;
		

		--如果9999回合 且无怪物 则胜利
		if bEnd and  Main.IfMonsterCleared() then
			--游戏胜利
			GameOverUI.LoadUI(3)
			cclog("win!!!")
			return
		end
		
		if nbricktype == tbrickType.MONSTER then
			--产生怪物
			local monsterid,lev = mission.GenerateMonsterId();
			
			local progress = mission.GetProgress()
			MainUI.SetProgress(progress)
			pbrick = brick.creatMonster(monsterid,lev);
		elseif nbricktype == tbrickType.GOLD then
			pbrick = brick.creatGoldBrick(nbricktype)
		else
			pbrick = brick.creatBrick(nbricktype);
		end	
						
		local timetick = brickInfo.brick_num_Y+1 - Ymin;
		local timeinterval = 0.3;
		if timetick >0 then
			timeinterval = timetick / pbrick.brickSpeed  *0.3;
		end
		pbrick.movetoTime = timeinterval;
		
		p.brickSetXY(pbrick,X,brickInfo.brick_num_Y+1)				
		p.brickMoveTo(pbrick,X,Ymin);
		Board[X][Ymin] = pbrick;
		
		if nbricktype == tbrickType.MONSTER then
			monster.SpellMagic(pbrick,true);
		end
		
		

		
end

function Main.GetGameScene()
	return g_sceneGame;
end

function Main.destroyBrick(X,Y,ifRemove)
	
	
	if Board[X][Y] ~= nil then
		if ifRemove == nil or ifRemove == true then
			layerMain:removeChild(Board[X][Y], true)
		end
		Board[X][Y] = nil;
		
	end
end
	
function Main.GetMonsterList()
	local monsterlist = {}
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then
				if Board[i][j].nType == tbrickType.MONSTER then
					table.insert(monsterlist,Board[i][j])
				end
			end	
		end
	end
	
	return monsterlist
end


function Main.menuCallbackOpenPopup(tag,sender)
            --使用技能
			Main.gamephase = GameLogicPhase.BEFORE_PLAYER_ACT
			local nMagicId = SkillBar.GetMagicIdFromTag(tag);
			
			
			if nMagicId == 0 then
				return
			end
			
			Main.ChosedMagic = nMagicId;
			if magic.GetMagicTargetType(nMagicId) ==TARGET_TYPE.SINGLE_BRICK then
				--单选一个BRICK
				Main.selectMode = SELECTMODE.SINGLE_BRICK;

				--选择一个LINE 	
				MainUI.SetMainUITip("Sin")


			else
				--其他情况直接释放
				magic.SpellMagic(nMagicId);
				magiceff.DoMagicEff(tParamEvn);					
			end
end


	
function p.brickSetXY(pbrick,X,Y)
		--cclog("setPosition: %0.2f, %0.2f", X*brickInfo.brickWidth+brickInfo.brickWidth/2, Y*brickInfo.brickHeight+brickInfo.brickHeight/2)
		pbrick:setPosition(X*brickInfo.brickWidth+brickInfo.brickWidth/2, Y*brickInfo.brickHeight-brickInfo.brickHeight/2)
		layerMain:addChild(pbrick);
		if X>=1 and X <=brickInfo.brick_num_X and Y>=1 and Y<=brickInfo.brick_num_Y then
			Board[X][Y] = pbrick;
			pbrick.TileX = X;
			pbrick.TileY = Y;
		end
end



function p.getBoardEmptyYFromX(X)
		local ret = 1;
		local retXuanKong = false;
		for i=1,#Board[X]  do
			if Board[X][i] ~= nil then
				ret = i+1;
			else
				break; 
			end
		end
		
	
		
		 
		if ret >  brickInfo.brick_num_Y then
			return false,false;
		end
		
		if ret == brickInfo.brick_num_Y then
			return ret,false;
		end 
		
		for i=ret+1,brickInfo.brick_num_Y  do
			if Board[X][i] ~= nil then
				retXuanKong = i;
				cclog("getBoardEmptyYFromX:X:"..X.."  Y:"..ret..", XuankongY:"..retXuanKong)
				break;
			end
		end
		
		return ret,retXuanKong;	
end
	
function p.brickMoveTo(pbrick,X,Y)
	
		--清空原位
		for i,v in pairs(Board)do
			for j=0,#v do
				if pbrick == v[j]  then
					v[j] = nil;
				end
			end
		end
		
		pbrick:stopAllActions()
		
		local positionx = X*brickInfo.brickWidth+brickInfo.brickWidth/2;
		local positiony = Y*brickInfo.brickHeight-brickInfo.brickHeight/2;
		
	 
		local actionto = CCMoveTo:create(pbrick.movetoTime, ccp(positionx, positiony))
		
		local randombounce = math.random(80,110)
		local randomtime = randombounce/1000
		local actionto2 = CCMoveTo:create(randomtime, ccp(positionx, positiony + randombounce))
		local actionto3 = CCMoveTo:create(randomtime*2, ccp(positionx, positiony))
		local actiontoease =  CCEaseBounceOut:create(actionto3)
		local arr = CCArray:create()		
		arr:addObject(actionto)
			arr:addObject(actionto2)
		
		   arr:addObject(actiontoease)
		  -- arr:addObject(actionto3)
		local  seq = CCSequence:create(arr)

		pbrick:runAction(seq)

		if X>=1 and X <=brickInfo.brick_num_X and Y>=1 and Y<=brickInfo.brick_num_Y then
			Board[X][Y] = pbrick;
			pbrick.TileX = X;
			pbrick.TileY = Y;
			
		end
end
	
	
	
	
--初始化棋盘
function p.InitBoard()
	for i = 1,brickInfo.brick_num_X do
		Board[i]={}
		for j = 1,brickInfo.brick_num_Y do
			Board[i][j] = nil;
		end
	end
end


function p.main(nMission)
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    local cclog = function(...)
        CCLuaLog(string.format(...))
    end

	cclog("demo start")

    ---------------

    local winSize = CCDirector:sharedDirector():getWinSize()

	mission.SetMission(nMission);
	

	
	--获取BOARD对应X横轴，纵轴Y空位 以及悬空Y位置


	
	
    -- create farm
    local function createlayerMain()
        layerMain = CCLayer:create()
		
		
		p.InitBoard()
		LineFunc.ResetLine();
		
		
        -- add in farm background
        local bg = CCSprite:create("Map.jpg")
        bg:setPosition(winSize.width / 2 , winSize.height / 2)
        --layerMain:setPosition(0 , winSize.height / 2)
		layerMain:addChild(bg)
		cclog("winSize: %0.2f, %0.2f", winSize.width, winSize.height)
       
		
		local function getTileXY(x,y)
			--brickInfo.brickRespondArea
			local w = brickInfo.brickWidth;
			local h = brickInfo.brickHeight;
			local X =	(x-w/2)/w;
			local Y = (y+h/2)/h;
			local bIfWrapIn= false; --是否处于靠近中心点

			if (X%1 < brickInfo.brickRespondArea/2 or X%1 >1- brickInfo.brickRespondArea/2) and( Y%1 < brickInfo.brickRespondArea/2 or Y%1 >1- brickInfo.brickRespondArea/2 ) then							
				bIfWrapIn = true;	
			end
			
				X = (X*10+5)/10
				Y = (Y*10+5)/10
		
				X = math.floor(X)
				Y = math.floor(Y)

			return X,Y,bIfWrapIn



		end
		

				
        local function onTouchBegan(x, y)
			if Main.selectMode == SELECTMODE.NORMAL then			
				--处于普通攻击模式
				LineFunc.CancelLine();				
				local X,Y = getTileXY(x,y)
				
				
				if X<=0 or Y <=0 or X > brickInfo.brick_num_X or Y> brickInfo.brick_num_Y then
					return true
				end
				
				if Board[X][Y] ~= nil then
						local pbrick = Board[X][Y];
						if	pbrick.chosed == false and pbrick.IsAbleLink == true then
							brick.setChosed(pbrick);
							LineFunc.SetHead(pbrick);
						end			
				end
			elseif Main.selectMode == SELECTMODE.SINGLE_BRICK then
				--处于选中单体模式
								
			end
			
            return true
        end

        local function onTouchMoved(x, y)
				if Main.selectMode == SELECTMODE.NORMAL then			
					--处于普通攻击模式
                     local X,Y,bIfWrapIn = getTileXY(x,y)
					 
						if X<=0 or Y <=0 or X > brickInfo.brick_num_X or Y> brickInfo.brick_num_Y then
							return true
						end
				
					 local bifatt = false
					 if bIfWrapIn == false then
						return;
					 end
					 
						if Board[X][Y] ~= nil then
							local pbrick = Board[X][Y];				
							LineFunc.OnHitABrick(pbrick);					
						end
				elseif Main.selectMode == SELECTMODE.SINGLE_BRICK then
					--处于选中单体模式
				
				end
			end
		
        local function onTouchEnded(x, y)
			if Main.selectMode == SELECTMODE.NORMAL then		
				--====================处于普通攻击模式=======================--
				--========line结束处理====--
				local nAction,nNum = LineFunc.OnTouchEnd()
				--========line结束处理====--
				
				if nAction == false then
					return;
				end
				
				--tbrickType.MONSTER
				if nAction == tbrickType.BLOOD then
					local hp = player.drinkBlood(nNum);			
				elseif 	nAction == tbrickType.GOLD then
					local gold = player.takeGold(nNum);	
				end
				
				--倒计时BUFF
				local buff = TimerBuff.GetTimerBuff()
				TimerBuff.SetTimerBuff(buff+nNum*10)
				
				
				
				Main.gamephase = GameLogicPhase.AFTER_PLAYER_ACT;
				magiceff.DoMagicEff(tParamEvn);
				
				--========怪物施放技能========--
				--回合结束则所有怪物释放技能 --所有怪物重置施放技能标识
				for i=1,brickInfo.brick_num_X do
					for j = 1, brickInfo.brick_num_Y do		
						if Board[i][j] ~= nil then
							if Board[i][j].nType == tbrickType.MONSTER then
								monster.SpellMagic(Board[i][j]);
								 Board[i][j].IsSpelled = false;
							end
						end
					end
				end
				--========怪物施放技能========--				
				Main.gamephase = GameLogicPhase.AFTER_MONSTER_SPELL;			
				magiceff.DoMagicEff(tParamEvn);
				
				--========怪物攻击========--	
				if nAction  ~= false then
					monster.attack();
				end
				--========怪物攻击========--	
				
				Main.gamephase = GameLogicPhase.AFTER_MONSTER_ATT;
				magiceff.DoMagicEff(tParamEvn);
				
				magiceff.ClearMagicEff(tParamEvn);	
				
				
				
				
				--所有技能冷却+1
				player.SkillCoolDown();
				
				
				--==显示玩家数据==--
				MainUI.SetMainUIGOLD(player[playerInfo.GOLD])
				MainUI.SetMainUIHP(player[playerInfo.HP],player[playerInfo.Entity_HPMAX])
				
	
			elseif Main.selectMode == SELECTMODE.SINGLE_BRICK then
				--=====================处于释放魔法并选中单体模式========================--
				local X,Y = getTileXY(x,y)
				if X<=0 or Y <=0 or X > brickInfo.brick_num_X or Y> brickInfo.brick_num_Y then
					return true
				end
						
				if Board[X][Y] ~= nil then
						local pbrick = Board[X][Y];	
						magic.SpellMagic(Main.ChosedMagic,pbrick);
						magiceff.DoMagicEff(tParamEvn);							
				end
				Main.selectMode = SELECTMODE.NORMAL
				MainUI.SetMainUITip("Nor")
			end
        end

        local function onTouch(eventType, x, y)
            if eventType == "began" then   
                return onTouchBegan(x, y)
            elseif eventType == "moved" then
                return onTouchMoved(x, y)
            else
                return onTouchEnded(x, y)
            end
        end

		-- 注册触摸事件  
		--layerMain.__CCTouchDelegate__:registerScriptTouchHandler(cocos2d.CCTOUCHBEGAN, "btnTouchBegin")  
		
        layerMain:registerScriptTouchHandler(onTouch)
        layerMain:setTouchEnabled(true)

		
		 
		
		--主界面初始化
		MainUI.LoadUI()
		
		Main.CreatebrickWave();
		gWaveTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(Main.WaveTimer, 0.1, false)
		
		gBrickFallTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(Main.brickfallLogic, 0.05, false)	
		
		gMonsterCdTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(Main.MonsterAttackTimer, 0.3, false)	
		
		
		player.Initplayer();		
        return layerMain
    end

   

   
    g_sceneGame:addChild(createlayerMain(),0,UIdefine.Board)
    g_sceneGame:addChild(SkillBar.Init(Main.menuCallbackOpenPopup),1,UIdefine.SkillBar)
	TimerBuff.LoadUI()
end


