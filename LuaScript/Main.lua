Main = {}
local p = Main;
-- for CCLuaEngine traceback
function __G__TRACKBACK__(msg)
    CCLuaLog("----------------------------------------")
    CCLuaLog("LUA ERROR: " .. tostring(msg) .. "\n")
    CCLuaLog(debug.traceback())
    CCLuaLog("----------------------------------------")
end



layerMain = {};

local ntest = 0;
local testbossid = 5;
Board = {};

--======��Ϸ��������=======--
tParamEvn = {};
tParamEvn.playerAttDamageThisRound = 0
--==========================--





Main.gamephase = GameLogicPhase.BEFORE_PLAYER_ACT;



Main.selectMode = SELECTMODE.NORMAL;
Main.ChosedMagic = 0;

local BrickFallTimerId = nil;



local g_HPlabeltag =1;
local g_ATlabeltag= 2;
local g_goldlabeltag= 3;
local g_Tiplabeltag = 4;
local g_EXPlabeltag = 5;
local g_LEVlabeltag =6;

local glayerMenu = nil;

local g_sceneGame = nil;

function Main.GetGameScene()
	return g_sceneGame;
end

function Main.destroyBrick(X,Y)
	if Board[X][Y] ~= nil then
				
		layerMain:removeChild(Board[X][Y], true)
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
			Main.gamephase = GameLogicPhase.BEFORE_PLAYER_ACT
			local nMagicId = SkillBar.GetMagicIdFromTag(tag);
			
			
			if nMagicId == 0 then
				return
			end
			
			Main.ChosedMagic = nMagicId;
			if magic.GetMagicTargetType(nMagicId) ==TARGET_TYPE.SINGLE_BRICK then
				--��ѡһ��BRICK
				Main.selectMode = SELECTMODE.SINGLE_BRICK;

				--ѡ��һ��LINE 	
				local tiplabel = layerMain:getChildByTag(g_Tiplabeltag)
				tolua.cast(tiplabel, "CCLabelTTF")
				tiplabel:setString("Sin") 
			else
				--�������ֱ���ͷ�
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
	
--��ʼ������
for i = 1,brickInfo.brick_num_X do
	Board[i]={}
	for j = 1,brickInfo.brick_num_Y do
		Board[i][j] = nil;
	end
end



local function main()
    -- avoid memory leak
    collectgarbage("setpause", 100)
    collectgarbage("setstepmul", 5000)

    local cclog = function(...)
        CCLuaLog(string.format(...))
    end

	cclog("demo start")

    ---------------

    local winSize = CCDirector:sharedDirector():getWinSize()

	
	
	local function IfBoardFull()
					for i = 1,brickInfo.brick_num_X do
						
						for j = 1,brickInfo.brick_num_Y do
							
							if Board[i][j] == nil then
								return false;
							end
						end
					end
					
					return true;
			end
	
	
	
	--��ȡBOARD��ӦX���ᣬ����Y��λ �Լ�����Yλ��
	local function getBoardEmptyYFromX(X)
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
	
	local function brickMoveTo(pbrick,X,Y)
	
		--���ԭλ
		for i,v in pairs(Board)do
			for j=0,#v do
				if pbrick == v[j]  then
					v[j] = nil;
				end
			end
		end
		
		local positionx = X*brickInfo.brickWidth+brickInfo.brickWidth/2;
		local positiony = Y*brickInfo.brickHeight-brickInfo.brickHeight/2;
		
	 
		local actionto = CCMoveTo:create(pbrick.movetoTime, ccp(positionx, positiony))
		pbrick:runAction(actionto)

		if X>=1 and X <=brickInfo.brick_num_X and Y>=1 and Y<=brickInfo.brick_num_Y then
			Board[X][Y] = pbrick;
			pbrick.TileX = X;
			pbrick.TileY = Y;
			
		end
	end
	
	--���������б�
	local tNewFallMonster = {}
	local function brickfallLogic()
		if IfBoardFull() then
			--��������ʩ�ż���
			--
			for i,v in pairs(tNewFallMonster) do
				monster.SpellMagic(v,true);
				
			end	
			
			
			tNewFallMonster = {}
			return;--CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(BrickFallTimerId)
		end
		
		--������������б�
		--tNewFallMonster = {}
		
		local nNum = brickInfo.brick_num_X;
		
		--���з������µ���
		for i=1,nNum do
			for j = 1, brickInfo.brick_num_Y do
				local Ytarget,Ysource = getBoardEmptyYFromX(i)
				
				
				if( Ytarget and Ysource ) then
					local pbrick = Board[i][Ysource];
					Board[i][Ysource] = nil;
					Board[i][Ytarget] = pbrick;
					
					local timetick = Ysource - Ytarget;
					if timetick >0 then
						timeinterval = timetick / pbrick.brickSpeed  *0.3;
					end
					pbrick.movetoTime = timeinterval;					
					brickMoveTo(pbrick,i,Ytarget);			
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
		
		for i=1,nNum do
			local Yempty = getBoardEmptyYFromX(i)
			if Yempty ~= false then
				
				

				local nbricktype = tTypeId[math.random(1,#tTypeId)];
				local pbrick=nil;
				
				ntest = ntest +1
					if ntest== 44 then
						--nbricktype = tbrickType.MONSTER
					end
					
				if nbricktype == tbrickType.MONSTER then
					--��������
					monsterid = mission.GenerateMonsterId();
				
					pbrick = brick.creatMonster(monsterid);
					table.insert(tNewFallMonster,pbrick)
					
				elseif nbricktype == tbrickType.GOLD then
					pbrick = brick.creatGoldBrick(nbricktype)
				else
					pbrick = brick.creatBrick(nbricktype);
					
				end	
						

				--layerMain:addChild(pbrick);
				
				local timetick = brickInfo.brick_num_Y+1 - Yempty;
				local timeinterval = 0.3;
		
				
				if timetick >0 then
					timeinterval = timetick / pbrick.brickSpeed  *0.3;
				end
				pbrick.movetoTime = timeinterval;
				
				
				p.brickSetXY(pbrick,i,brickInfo.brick_num_Y+1)				
				brickMoveTo(pbrick,i,Yempty);
				Board[i][Yempty] = pbrick;
			end	
		end	
	end
	
	
    -- create farm
    local function createlayerMain()
        layerMain = CCLayer:create()

        -- add in farm background
        local bg = CCSprite:create("map.jpg")
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
		

				
        local function onTouchBegan(x, y)
			if Main.selectMode == SELECTMODE.NORMAL then			
				--������ͨ����ģʽ
				LineFunc.CancelLine();				
				local X,Y = getTileXY(x,y)
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
                     local X,Y,bIfWrapIn = getTileXY(x,y)
					 local bifatt = false
					 if bIfWrapIn == false then
						return;
					 end
					 
						if Board[X][Y] ~= nil then
							local pbrick = Board[X][Y];				
							LineFunc.OnHitABrick(pbrick);					
						end
				elseif Main.selectMode == SELECTMODE.SINGLE_BRICK then
					--����ѡ�е���ģʽ
				
				end
			end
		
        local function onTouchEnded(x, y)
			if Main.selectMode == SELECTMODE.NORMAL then		
				--====================������ͨ����ģʽ=======================--
				--========line��������====--
				local nAction,nNum = LineFunc.OnTouchEnd()
				--========line��������====--
				
				if nAction == false then
					return;
				end
				
				--tbrickType.MONSTER
				if nAction == tbrickType.BLOOD then
					local hp = player.drinkBlood(nNum);			
				elseif 	nAction == tbrickType.GOLD then
					local gold = player.takeGold(nNum);	
				end
				
				
				
				Main.gamephase = GameLogicPhase.AFTER_PLAYER_ACT;
				magiceff.DoMagicEff(tParamEvn);
				
				--========����ʩ�ż���========--
				--�غϽ��������й����ͷż��� --���й�������ʩ�ż��ܱ�ʶ
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
				--========����ʩ�ż���========--				
				Main.gamephase = GameLogicPhase.AFTER_MONSTER_SPELL;			
				magiceff.DoMagicEff(tParamEvn);
				
				--========���﹥��========--	
				if nAction  ~= false then
					monster.attack();
				end
				--========���﹥��========--	
				
				Main.gamephase = GameLogicPhase.AFTER_MONSTER_ATT;
				magiceff.DoMagicEff(tParamEvn);
				
				magiceff.ClearMagicEff(tParamEvn);	
				
				
				
				
				--���м�����ȴ+1
				player.SkillCoolDown();
				
				
				--==��ʾ�������==--
				local hplabel = layerMain:getChildByTag(g_HPlabeltag)
				tolua.cast(hplabel, "CCLabelTTF")
				hplabel:setString("HP:"..player[playerInfo.HP].."/"..player[playerInfo.HPMAX])			
           
				local GOLDlabel = layerMain:getChildByTag(g_goldlabeltag)
				tolua.cast(GOLDlabel, "CCLabelTTF")
				GOLDlabel:setString("G:"..player[playerInfo.GOLD]) 
				
				
				
				
	
			elseif Main.selectMode == SELECTMODE.SINGLE_BRICK then
				--=====================�����ͷ�ħ����ѡ�е���ģʽ========================--
				local X,Y = getTileXY(x,y)
				if Board[X][Y] ~= nil then
						local pbrick = Board[X][Y];	
						magic.SpellMagic(Main.ChosedMagic,pbrick);
						magiceff.DoMagicEff(tParamEvn);							
				end
				Main.selectMode = SELECTMODE.NORMAL
				
				local tiplabel = layerMain:getChildByTag(g_Tiplabeltag)
				tolua.cast(tiplabel, "CCLabelTTF")
				tiplabel:setString("Nor") 
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

		-- ע�ᴥ���¼�  
		--layerMain.__CCTouchDelegate__:registerScriptTouchHandler(cocos2d.CCTOUCHBEGAN, "btnTouchBegin")  
		
        layerMain:registerScriptTouchHandler(onTouch)
        layerMain:setTouchEnabled(true)

		
		 BrickFallTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(brickfallLogic, 0.3, false)	

		player.Initplayer();
		
		
		--��ʾ���Ѫ��
		local hpLabel = CCLabelTTF:create("HP:"..player[playerInfo.HP].."/"..player[playerInfo.HPMAX], "Arial", 20)
			layerMain:addChild(hpLabel)
			hpLabel:setColor(ccc3(255,0,0))
			hpLabel:setPosition(410, 220)
			hpLabel:setTag(g_HPlabeltag);

			
		--��ʾ��ҹ���
		local ATlabel = CCLabelTTF:create("AT:"..player[playerInfo.ATT], "Arial", 20)
			layerMain:addChild(ATlabel)
			ATlabel:setColor(ccc3(255,0,0))
			ATlabel:setPosition(390, 180)
			ATlabel:setTag(g_ATlabeltag);

		--��ʾ��ҽ��
		local GOLDlabel = CCLabelTTF:create("G:"..player[playerInfo.GOLD], "Arial", 20)
			layerMain:addChild(GOLDlabel)
			GOLDlabel:setColor(ccc3(255,0,0))
			GOLDlabel:setPosition(390, 150)
			GOLDlabel:setTag(g_goldlabeltag);		


		--��ʾ������ʾ
		local Tiplabel = CCLabelTTF:create("Nor","Arial", 20)
			layerMain:addChild(Tiplabel)
			Tiplabel:setColor(ccc3(255,0,0))
			Tiplabel:setPosition(390, 110)
			Tiplabel:setTag(g_Tiplabeltag);		--]]

		--��ʾ��Ҿ���
		local EXPlabel = CCLabelTTF:create("exp:"..player[playerInfo.EXP], "Arial", 20)
			layerMain:addChild(EXPlabel)
			EXPlabel:setColor(ccc3(255,0,0))
			EXPlabel:setPosition(390, 80)
			EXPlabel:setTag(g_EXPlabeltag);		

		--��ʾ��ҵȼ�
		local LEVlabel = CCLabelTTF:create("LEV:"..player[playerInfo.LEVEL], "Arial", 20)
			layerMain:addChild(LEVlabel)
			LEVlabel:setColor(ccc3(255,0,0))
			LEVlabel:setPosition(390, 270)
			LEVlabel:setTag(g_LEVlabeltag);					
        return layerMain
    end

   

    g_sceneGame = CCScene:create()
    g_sceneGame:addChild(createlayerMain())
    --g_sceneGame:addChild(createlayerMenu())
	g_sceneGame:addChild(SkillBar.Init(Main.menuCallbackOpenPopup))
	
	--SkillUpGradeUI.LoadUI();
	
    CCDirector:sharedDirector():runWithScene(g_sceneGame)
end

xpcall(main, __G__TRACKBACK__)
