--主界面UI
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
local g_HPBartag = 12;
local g_ExpBartag = 13;
local g_GoldBartag = 14;
		
local bglayer = nil;
local gprogressbar = nil;
local waveCounter = nil;
local gHPBar = nil; 
local gExpBar = nil;
local gGoldBar = nil;

function p.LoadUI()
	bglayer = CCLayer:create()
		
		--
		--血条
		HPBar = CCProgressTimer:create(CCSprite:create("UI/Bar/HPbar.png"))
		HPBar:setType(kCCProgressTimerTypeBar)
		HPBar:setMidpoint(CCPointMake(0, 0))
		HPBar:setBarChangeRate(CCPointMake(0, 1))
		HPBar:setPosition(CCPointMake(130, 130))
		bglayer:addChild(HPBar,1,g_HPBartag)	
		gHPBar = HPBar
		HPBar:setPercentage(100);
		local HPBarBg = CCMenuItemImage:create("UI/Bar/HPbarBg.png", "UI/Bar/HPbarBg.png")
		HPBarBg:setPosition(130, 130)
		bglayer:addChild(HPBarBg,2)
		
		

		--经验条
		ExpBar = CCProgressTimer:create(CCSprite:create("UI/Bar/Expbar.png"))
		ExpBar:setType(kCCProgressTimerTypeBar)
		ExpBar:setMidpoint(CCPointMake(0, 0))
		ExpBar:setBarChangeRate(CCPointMake(0, 1))
		ExpBar:setPosition(CCPointMake(100, 130))
		bglayer:addChild(ExpBar,1,g_ExpBartag)	
		gExpBar = ExpBar
		ExpBar:setPercentage(0);
		local ExpBarBg = CCMenuItemImage:create("UI/Bar/HPbarBg.png", "UI/Bar/HPbarBg.png")
		ExpBarBg:setPosition(100, 130)
		bglayer:addChild(ExpBarBg,2)
		
		

		--金币条
		GoldBar = CCProgressTimer:create(CCSprite:create("UI/Bar/Goldbar.png"))
		GoldBar:setType(kCCProgressTimerTypeBar)
		GoldBar:setMidpoint(CCPointMake(0, 0))
		GoldBar:setBarChangeRate(CCPointMake(0, 1))
		GoldBar:setPosition(CCPointMake(70, 130))
		bglayer:addChild(GoldBar,1,g_GoldBartag)	
		gGoldBar = GoldBar
		GoldBar:setPercentage(0);
		local GoldBarBg = CCMenuItemImage:create("UI/Bar/HPbarBg.png", "UI/Bar/HPbarBg.png")
		GoldBarBg:setPosition(70, 130)
		bglayer:addChild(GoldBarBg,2)
		
		
	
	

		--显示玩家血量
		local hpLabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(hpLabel)
			hpLabel:setColor(ccc3(255,255,255))
			hpLabel:setPosition(0, 220)
			hpLabel:setTag(g_HPlabeltag);
		
		--显示玩家攻击
		local ATlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(ATlabel)
			ATlabel:setColor(ccc3(255,0,0))
			ATlabel:setPosition(0, 180)
			ATlabel:setTag(g_ATlabeltag);
					
			
		--显示玩家金币
		local GOLDlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(GOLDlabel)
			GOLDlabel:setColor(ccc3(255,0,0))
			GOLDlabel:setPosition(0, 150)
			GOLDlabel:setTag(g_goldlabeltag);		

		--显示动作提示
		local Tiplabel = CCLabelTTF:create("Nor","Arial", 20)
			bglayer:addChild(Tiplabel)
			Tiplabel:setColor(ccc3(255,0,0))
			Tiplabel:setPosition(0, 110)
			Tiplabel:setTag(g_Tiplabeltag);		--]]

		--显示玩家经验
		local EXPlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(EXPlabel)
			EXPlabel:setColor(ccc3(255,0,0))
			EXPlabel:setPosition(0, 80)
			EXPlabel:setTag(g_EXPlabeltag);		

		--显示玩家等级
		local LEVlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(LEVlabel)
			LEVlabel:setColor(ccc3(255,0,0))
			LEVlabel:setPosition(0, 270)
			LEVlabel:setTag(g_LEVlabeltag);		
	
	
		--显示MISSION
		local missionLabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(missionLabel)
			missionLabel:setColor(ccc3(255,0,0))
			missionLabel:setPosition(0, 420)
			missionLabel:setTag(g_missionlabeltag);
			
		--显示MISSION进度
		gprogressbar = ProgressBar:Create()
		gprogressbar:setPosition(CCPointMake(80, 320))
		gprogressbar:SetProgress(0)
		bglayer:addChild(gprogressbar)
		gprogressbar:setTag(g_progressbartag);
			
		
		--加速按钮
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
		if PassiveSkill.Entity.Radar == 0 then
			p.HideSpeedBtn()
		else
			p.ShowSpeedBtn()
		end
		
		-- 升级按钮
		local item1 = CCMenuItemImage:create("UI/Button/upgradearrow.png", "UI/Button/upgradearrow.png")
    	item1:registerScriptTapHandler(p.menuCallbackUpgradeBtn)
		local menu = CCMenu:create()
		menu:addChild(item1,1,1)	
		menu:setPosition(CCPointMake(0, 310))
		item1:setPosition(0,0)
		menu:setTag(g_UpgradeBtntag);
		bglayer:addChild(menu)		
		menu:setVisible(true)
			
    bglayer:setPosition(CCPointMake(800, 50))
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,3)
	bglayer:setTag(UIdefine.MainUI);
	
	p.SetMainUIMission(mission.GetMissionDesc())
	
	p.SetProgress(10)
end

--显示SPEED按钮
function p.ShowSpeedBtn()
	local menu = bglayer:getChildByTag(g_SpeedBtntag)
	tolua.cast(menu, "CCMenu")
	menu:setVisible(true)
	waveCounter:setVisible(true)
end

--隐藏SPEED按钮
function p.HideSpeedBtn()
	local menu = bglayer:getChildByTag(g_SpeedBtntag)
	tolua.cast(menu, "CCMenu")
	menu:setVisible(false)
	waveCounter:setVisible(false)
end

--显示升级按钮
function p.ShowUpgradeBtn()
	local menu = bglayer:getChildByTag(g_UpgradeBtntag)
	tolua.cast(menu, "CCMenu")
	menu:setVisible(true)
end

--隐藏升级按钮
function p.HideUpgradeBtn()
	local menu = bglayer:getChildByTag(g_UpgradeBtntag)
	tolua.cast(menu, "CCMenu")
	menu:setVisible(false)
end

function p.setWaveTimer(nPersent)
	waveCounter:setPercentage(nPersent);
end

function p.menuCallbackUpgradeBtn(tag,sender)
     CCDirector:sharedDirector():pause()
     --加载升级界面 
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
	
	gHPBar:setPercentage(100*nHP/nHPMAX);
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
	gExpBar:setPercentage(100*nEXP/player.GetExpNeed());
end

function p.SetMainUIGOLD(nGOLD)
	local GOLDlabel = bglayer:getChildByTag(g_goldlabeltag)
	tolua.cast(GOLDlabel, "CCLabelTTF")
	GOLDlabel:setString("G:"..nGOLD) 	
	
	gGoldBar:setPercentage(nGOLD%100);
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