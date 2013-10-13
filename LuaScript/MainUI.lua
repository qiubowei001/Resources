--������UI
MainUI = {};
local p = MainUI;

local g_HPlabeltag =1;
local g_ATlabeltag= 2;
local g_goldlabeltag= 3;
local g_Tiplabeltag = 4;
local g_EXPlabeltag = 5;
local g_LEVlabeltag =6;
local g_missionlabeltag =7;
local g_progressbartag = 8;
local g_wavetimertag = 9;
local g_SpeedBtntag = 10;
local g_UpgradeBtntag = 11;

local bglayer = nil;
local gprogressbar = nil;
local waveCounter = nil;

function p.LoadUI()
	bglayer = CCLayer:create()


		--��ʾ���Ѫ��
		local hpLabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(hpLabel)
			hpLabel:setColor(ccc3(255,0,0))
			hpLabel:setPosition(0, 220)
			hpLabel:setTag(g_HPlabeltag);
		
		--��ʾ��ҹ���
		local ATlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(ATlabel)
			ATlabel:setColor(ccc3(255,0,0))
			ATlabel:setPosition(0, 180)
			ATlabel:setTag(g_ATlabeltag);
					
			
		--��ʾ��ҽ��
		local GOLDlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(GOLDlabel)
			GOLDlabel:setColor(ccc3(255,0,0))
			GOLDlabel:setPosition(0, 150)
			GOLDlabel:setTag(g_goldlabeltag);		

		--��ʾ������ʾ
		local Tiplabel = CCLabelTTF:create("Nor","Arial", 20)
			bglayer:addChild(Tiplabel)
			Tiplabel:setColor(ccc3(255,0,0))
			Tiplabel:setPosition(0, 110)
			Tiplabel:setTag(g_Tiplabeltag);		--]]

		--��ʾ��Ҿ���
		local EXPlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(EXPlabel)
			EXPlabel:setColor(ccc3(255,0,0))
			EXPlabel:setPosition(0, 80)
			EXPlabel:setTag(g_EXPlabeltag);		

		--��ʾ��ҵȼ�
		local LEVlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(LEVlabel)
			LEVlabel:setColor(ccc3(255,0,0))
			LEVlabel:setPosition(0, 270)
			LEVlabel:setTag(g_LEVlabeltag);		
	
	
		--��ʾMISSION
		local missionLabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(missionLabel)
			missionLabel:setColor(ccc3(255,0,0))
			missionLabel:setPosition(0, 420)
			missionLabel:setTag(g_missionlabeltag);
			
		--��ʾMISSION����
		gprogressbar = ProgressBar:Create()
		gprogressbar:setPosition(CCPointMake(80, 320))
		gprogressbar:SetProgress(0)
		bglayer:addChild(gprogressbar)
		gprogressbar:setTag(g_progressbartag);
			
		
		--���ٰ�ť
		-- menu
		local item1 = CCMenuItemImage:create("UI/Bar/CircleTimerBg.png", "UI/Bar/CircleTimerBg.png")
    	item1:registerScriptTapHandler(p.menuCallbackSpeedBtn)
		local menu = CCMenu:create()
		menu:addChild(item1,1,1)	
		menu:setPosition(CCPointMake(10, 500))
		item1:setPosition(0,0)
		menu:setTag(g_SpeedBtntag);
		bglayer:addChild(menu)
		
		waveCounter = CCProgressTimer:create(CCSprite:create("UI/Bar/CircleTimer.png"))
		waveCounter:setType(kCCProgressTimerTypeRadial)
		waveCounter:setPosition(CCPointMake(10, 500))
		waveCounter:setTag(g_wavetimertag);
		bglayer:addChild(waveCounter)
		
		-- ������ť
		local item1 = CCMenuItemImage:create("UI/Bar/CircleTimerBg.png", "UI/Bar/CircleTimerBg.png")
    	item1:registerScriptTapHandler(p.menuCallbackUpgradeBtn)
		local menu = CCMenu:create()
		menu:addChild(item1,1,1)	
		menu:setPosition(CCPointMake(10, 580))
		item1:setPosition(0,0)
		menu:setTag(g_UpgradeBtntag);
		bglayer:addChild(menu)		
		
			
    bglayer:setPosition(CCPointMake(800, 50))
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,3)
	bglayer:setTag(UIdefine.MainUI);
	
	
	p.SetMainUIMission(mission.GetMissionDesc())
	
	p.SetProgress(10)
end

function p.setWaveTimer(nPersent)
	waveCounter:setPercentage(nPersent);
end

function p.menuCallbackUpgradeBtn(tag,sender)
	--CCDirector:sharedDirector():pause()
   --     if CCDirector:sharedDirector():isPaused() then
     --       CCDirector:sharedDirector():resume()
       -- else
            CCDirector:sharedDirector():pause()
     --������������ 
	 EquipUpGradeUI.LoadUI();
end


function p.menuCallbackSpeedBtn(tag,sender)
	Main.SpeedUpWave()
end


function p.SetProgress(nProgress)
	gprogressbar:SetProgress(nProgress)	         
end


function p.SetMainUILEV(nLEV)
	local label = bglayer:getChildByTag(g_LEVlabeltag)
	tolua.cast(label, "CCLabelTTF")
	label:setString("LEV:"..nLEV)	         
end


function p.SetMainUIHP(nHP,nHPMAX)
	local label = bglayer:getChildByTag(g_HPlabeltag)
	tolua.cast(label, "CCLabelTTF")
	label:setString("HP:"..nHP.."/"..nHPMAX)	         
end

function p.SetMainUIATK(nATK)
	local label = bglayer:getChildByTag(g_ATlabeltag)
	tolua.cast(label, "CCLabelTTF")
	label:setString("AT:"..nATK)	
end

function p.SetMainUIEXP(nEXP)
	local GOLDlabel = bglayer:getChildByTag(g_EXPlabeltag)
	tolua.cast(GOLDlabel, "CCLabelTTF")
	GOLDlabel:setString("exp:"..nEXP)	
end

function p.SetMainUIGOLD(nGOLD)
	local GOLDlabel = bglayer:getChildByTag(g_goldlabeltag)
	tolua.cast(GOLDlabel, "CCLabelTTF")
	GOLDlabel:setString("G:"..nGOLD) 	
end

function p.SetMainUITip(sTip)
	local tiplabel = bglayer:getChildByTag(g_Tiplabeltag)
	tolua.cast(tiplabel, "CCLabelTTF")
	tiplabel:setString(sTip) 	
end

function p.SetMainUIMission(sMission)
	local tiplabel = bglayer:getChildByTag(g_missionlabeltag)
	tolua.cast(tiplabel, "CCLabelTTF")
	tiplabel:setString(sMission.."") 
end