Main = {}
local p = Main;
-- for CCLuaEngine traceback




layerMain = {};

local ntest = 0;
local testbossid = 5;
Board = {};

--======��Ϸ��������=======--
tParamEvn = {};
tParamEvn.playerAttDamageThisRound = 0
--==========================--




Main.selectMode = SELECTMODE.NORMAL;
Main.ChosedMagic = 0;

local gBrickFallTimerId = nil;
local gMonsterCdTimerId = nil;

local g_HPlabeltag =1;
local g_ATlabeltag= 2;
local g_goldlabeltag= 3;
local g_Tiplabeltag = 4;
local g_EXPlabeltag = 5;
local g_LEVlabeltag =6;

local glayerMenu = nil;
local g_TouchEnable = true;

function Main.getTileXY(x,y)
	--brickInfo.brickRespondArea
	local w = brickInfo.brickWidth;
	local h = brickInfo.brickHeight;
	local X =	(x-w/2)/w;
	local Y = (y+h/2)/h;
	local bIfWrapIn= false; --�Ƿ��ڿ������ĵ�

	if (X%1 < brickInfo.brickRespondArea/2 or X%1 >1- brickInfo.brickRespondArea/2) and( Y%1 < brickInfo.brickRespondArea/2 or Y%1 >1- brickInfo.brickRespondArea/2 ) then							
		bIfWrapIn = true;	
	end
	
		X = (X*10+5)/10
		Y = (Y*10+5)/10

		X = math.floor(X)
		Y = math.floor(Y)

	return X,Y,bIfWrapIn
end
		
		
function Main.CloseAllUI()
	for i,v in pairs(UIdefine) do 
		g_sceneGame:removeChildByTag(v, true)
	end
end

--�����������ǹر�
function Main.EnableTouch(bOpen)
	g_TouchEnable = bOpen;
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

--���﹥����ȴ��ʱ��
function Main.MonsterAttackTimer()
	--����
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			
			if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then
				--������1
				monster.AttackCDPlusOne(Board[i][j]);
			end
		end
	end
	
	--[[����
	local petlist = pet.GetPetList()
	for i,pet in pairs(petlist) do
		monster.AttackCDPlusOne(pet);
	end]]
end


local WaveTick = 0

function Main.GetMonsterCDTimerId()
	return gMonsterCdTimerId
end


function Main.GetBrickFallTimerId()
	return gBrickFallTimerId
end

--�Ƿ���������й���
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

--����һ��ש��
function Main.brickfallLogic()
		--�ȴ���Ч����
		if 	Particle.IfIsPlayingEff() then
			return
		end
		
		if Main.IfBoardFull() then
			return;
		end
		
		
		--���з������µ���
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
					--����JUMP��Ч				
				else
					break;
				end	
			end
		end

		
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
		
		--Ѱ����͵��ͷ�
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
		

		--���9999�غ� ���޹��� ��ʤ��
		if bEnd and  Main.IfMonsterCleared() then
			--��Ϸʤ��
			GameOverUI.LoadUI(3)
			cclog("win!!!")
			return
		end
		
		if nbricktype == nil then
			return
		end
		
		if nbricktype == tbrickType.MONSTER then
			--��������
			local monsterid,lev = mission.GenerateMonsterId();
			
			local progress = mission.GetProgress()
			MainUI.SetProgress(progress)
			pbrick = brick.creatMonster(monsterid,lev);
			
			--��ʾͼ��
			MonsterHandBook.ShowMonsterHandBook(monsterid)
			
			--Particle.AddParticleEffToBrick(pbrick,"ThunderChain")
			--
			
		elseif nbricktype == tbrickType.GOLD then
			pbrick = brick.creatGoldBrick(nbricktype)
		else
			pbrick = brick.creatBrick(nbricktype);
		end	
		
		--�غ�����1
		mission.RoundPlusOne();
						
		local timetick = brickInfo.brick_num_Y+1 - Ymin;
		local timeinterval = 0.3;
		if timetick >0 then
			timeinterval = timetick / pbrick.brickSpeed  *0.3;
		end
		pbrick.movetoTime = timeinterval;

		p.brickSetXY(pbrick,X,Ymin)	
		p.brickFlashIn(pbrick);
		
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
            --ʹ�ü���
			local nMagicId = SkillBar.GetMagicIdFromTag(tag);
			
			
			if nMagicId == 0 then
				return
			end
			
			Main.ChosedMagic = nMagicId;
			if magic.GetMagicTargetType(nMagicId) ==TARGET_TYPE.SINGLE_BRICK then
				--��ѡһ��BRICK
				Main.selectMode = SELECTMODE.SINGLE_BRICK;

				--ѡ��һ��LINE 	
				MainUI.SetMainUITip("Sin")


			else
				--�������ֱ���ͷ�
				player.SpellMagic(nMagicId);	
			end
end


--ש������
function p.brickFlashIn(pbrick)
	local arr = CCArray:create()
	
	local scaleact = CCScaleTo:create(0.1, 1.5)
	local scaleact2 = CCScaleTo:create(0.2, 1)
	arr:addObject(scaleact)
	arr:addObject(scaleact2)
	
	local  seq = CCSequence:create(arr)	
	pbrick:runAction(seq)
end

function p.brickSetBGXY(pbrick,X,Y)
		pbrick:setPosition(X*brickInfo.brickWidth+brickInfo.brickWidth/2, Y*brickInfo.brickHeight-brickInfo.brickHeight/2)
		layerMain:addChild(pbrick,1);
end	
function p.brickSetXY(pbrick,X,Y)
		pbrick:setPosition(X*brickInfo.brickWidth+brickInfo.brickWidth/2, Y*brickInfo.brickHeight-brickInfo.brickHeight/2)
		layerMain:addChild(pbrick,2);
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

local tBarPosition = 
{
	[1] 	= {400,555}, --�����
	[2] 	= {15,55}, --Ѫ��
	[3] 	= {700,55}, --������
}
--nType��������
function p.BrickMoveToBar(pbrick,nType)
	brick.setUnChosed(pbrick)
	
	local posx= tBarPosition[nType][1]
	local posy= tBarPosition[nType][2]
	
	local X,Y = pbrick.TileX,pbrick.TileY
	Board[X][Y] = nil;
	
	--��С
	pbrick:setScale(0.5);
	
	--Ʈ��
	local actionto = CCMoveTo:create(0.8, ccp(posx, posy))
	
	--ɾ��
	function delete(sender)
		sender:removeFromParentAndCleanup(true);
	end
		
	local actionremove = CCCallFuncN:create(delete)
	
	local arr = CCArray:create()		
	arr:addObject(actionto)
	arr:addObject(actionremove)
	
	local  seq = CCSequence:create(arr)
	pbrick:runAction(seq)	
end

function p.brickMoveTo(pbrick,X,Y)
	
		--���ԭλ
		for i,v in pairs(Board)do
			for j=0,#v do
				if pbrick == v[j]  then
					v[j] = nil;
				end
			end
		end
		
		pbrick:stopAllActions()
		
		pbrick:setScale(1);
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
	
	
	
	
--��ʼ������
function p.InitBoard()
	for i = 1,brickInfo.brick_num_X do
		Board[i]={}
		for j = 1,brickInfo.brick_num_Y do
			Board[i][j] = nil;
			--��ʼ������
			local pbrickbg =SpriteManager.creatBrickSprite(21)
			
			p.brickSetBGXY(pbrickbg,i,j)
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

	if nMission == 1 then
		lesson.Init()
	end
	
	--��ȡBOARD��ӦX���ᣬ����Y��λ �Լ�����Yλ��


	
	
    -- create farm
    local function createlayerMain()
		Main.EnableTouch(true);
        layerMain = CCLayer:create()
		
		
		p.InitBoard()
		LineFunc.ResetLine();
		
		
        -- add in farm background
        --local bg = CCSprite:create("Map.png")
		local nmission = mission.GetMission()
		local bg =  GameBg.GetBgLayer(MISSION_TABLE[nmission]["BgId"]) 
		
		--layerMain:addChild(bg)
		g_sceneGame:addChild(bg)
		cclog("winSize: %0.2f, %0.2f", winSize.width, winSize.height)
       
		

		

				
        local function onTouchBegan(x, y)
			if Main.selectMode == SELECTMODE.NORMAL then			
				--������ͨ����ģʽ
				--���õ����Ч
				Particle.SetMainHitEff(x,y)
				
				LineFunc.CancelLine();				
				local X,Y = Main.getTileXY(x,y)
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
				--����ѡ�е���ģʽ
								
			end
			
            return true
        end

        local function onTouchMoved(x, y)
				if Main.selectMode == SELECTMODE.NORMAL then			
					--������ͨ����ģʽ
					
					--���õ����Ч
					Particle.SetMainHitEff(x,y)
                    
					local X,Y,bIfWrapIn = Main.getTileXY(x,y)
					 
						if X<=0 or Y <=0 or X > brickInfo.brick_num_X or Y> brickInfo.brick_num_Y then
							return true
						end
				
					 local bifatt = false
					 if bIfWrapIn == false then
						return true;
					 end
					 
						if Board[X][Y] ~= nil then
							local pbrick = Board[X][Y];				
							LineFunc.OnHitABrick(pbrick);					
						end
				elseif Main.selectMode == SELECTMODE.SINGLE_BRICK then
					--����ѡ�е���ģʽ
				
				end
				return true;
			end
		
        local function onTouchEnded(x, y)
			--ɾ�������Ч
			Particle.DelMainHitEff()
				
				
			if Main.selectMode == SELECTMODE.NORMAL then		
				--====================������ͨ����ģʽ=======================--
				--========line��������====--
				local nAction,nNum = LineFunc.OnTouchEnd()
				--========line��������====--
				

				if nAction == false then
					return true;
				end
				
				--ȫ���¼�
				GlobalEvent.OnEvent(GLOBAL_EVENT.LINK_SUCC)
		
			
				--����������
				player.SpendEnergy(1);				
				--tbrickType.MONSTER
				if nAction == tbrickType.BLOOD then
					player.drinkBlood(nNum);			
				elseif 	nAction == tbrickType.GOLD then
					player.takeGold(nNum);
				elseif	nAction == tbrickType.ENERGY then
					player.EnergyRecovery(nNum);
					--ȫ���¼�
					GlobalEvent.OnEvent(GLOBAL_EVENT.TAKE_ENERGY)
				end
				

				
				--����ʱBUFF
				Combo.AddCombo()
				
				--����Ч��ִ��
				magiceff.DoMagicEff(tParamEvn);

				--���ڷ���Ч��ȥ��
				magiceff.ClearPlayerTriggerMagicEff(tParamEvn);	
				
				--���м�����ȴ+1
				player.SkillCoolDown();
				
				
			elseif Main.selectMode == SELECTMODE.SINGLE_BRICK then
				--=====================�����ͷ�ħ����ѡ�е���ģʽ========================--
				local X,Y = Main.getTileXY(x,y)
				if X<=0 or Y <=0 or X > brickInfo.brick_num_X or Y> brickInfo.brick_num_Y then
					return true
				end
						
				if Board[X][Y] ~= nil then
						local pbrick = Board[X][Y];	
						player.SpellMagic(Main.ChosedMagic,pbrick);						
				end
				Main.selectMode = SELECTMODE.NORMAL
				MainUI.SetMainUITip("Nor")
			end
			return true;
        end

        local function onTouch(eventType, x, y)
			if g_TouchEnable == false then
				return true
			end
				
			x = x - brickInfo.layerMainAdjX
            if eventType == "began" then   
                return onTouchBegan(x, y)
            elseif eventType == "moved" then
                return onTouchMoved(x, y)
            else
                return onTouchEnded(x, y)
            end
			return true;
        end

		-- ע�ᴥ���¼�  
		layerMain:registerScriptTouchHandler(onTouch)
        layerMain:setTouchEnabled(true)
		--layerMain:setPosition(300 ,0)
		--�������ʼ��
		MainUI.LoadUI()
		
		--�������ܳ�ʼ��
		PassiveSkill.Initial()
		
		--��ʼ���������
		player.Initplayer();	

			
		gBrickFallTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(Main.brickfallLogic, 0.05, false)	
		
		gMonsterCdTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(Main.MonsterAttackTimer, 0.3, false)	
			
			
		CCDirector:sharedDirector():getScheduler():setTimeScale(1);
		
		
		--�ƶ�����  bg:setPosition(winSize.width / 2 , winSize.height / 2)
		
		bg:setPosition(winSize.width / 2 , winSize.height*3/2)
		local moveby = CCMoveBy:create(1, ccp(0,-winSize.height))
		bg:runAction(moveby)	
		
		layerMain:setPosition(brickInfo.layerMainAdjX , winSize.height)
		local moveby = CCMoveBy:create(1, ccp(0,-winSize.height))
		layerMain:runAction(moveby)
		
        return layerMain
    end

   

   
    g_sceneGame:addChild(createlayerMain(),0,UIdefine.Board)
    g_sceneGame:addChild(SkillBar.Init(Main.menuCallbackOpenPopup),1,UIdefine.SkillBar)
	
	Particle.Init()
	
	Hint.Init()
	
	MonsterHandBook.Init()
	Combo.LoadUI()
end


