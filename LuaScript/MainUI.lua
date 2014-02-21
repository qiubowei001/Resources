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


local g_HPBartag = 12;
local g_ExpBartag = 13;
local g_GoldBartag = 14;
local g_EnergyBartag = 15;
		
local bglayer = nil;
local gprogressbar = nil;
local waveCounter = nil;

local gHPBar = nil; 
local gExpBar = nil;
local gGoldBar = nil;
local gEnergyBar = nil;

local gHPBarBg = nil;
function p.LoadUI()
	bglayer = CCLayer:create()
	
	
		--������
		gEnergyBar = CCProgressTimer:create(CCSprite:create("UI/Bar/Energybar.png"))
		gEnergyBar:setType(kCCProgressTimerTypeBar)
		gEnergyBar:setMidpoint(CCPointMake(0, 0))
		gEnergyBar:setBarChangeRate(CCPointMake(0, 1))
		gEnergyBar:setPosition(CCPointMake(20, 10))
		bglayer:addChild(gEnergyBar,1,g_EnergyBartag)	
		--gEnergyBar:setPercentage(100);
		local gEnergyBarBg = CCMenuItemImage:create("UI/Bar/HPbarBG.png", "UI/Bar/HPbarBG.png")
		gEnergyBarBg:setPosition(20, 10)
		bglayer:addChild(gEnergyBarBg,2)
		local to2 = CCProgressTo:create(1, 100)
		gEnergyBar:runAction(to2)
		
		
		--Ѫ��
		HPBar = CCProgressTimer:create(CCSprite:create("UI/Bar/HPbar.png"))
		HPBar:setType(kCCProgressTimerTypeBar)
		HPBar:setMidpoint(CCPointMake(0, 0))
		HPBar:setBarChangeRate(CCPointMake(0, 1))
		HPBar:setPosition(CCPointMake(-700, 10))
		bglayer:addChild(HPBar,1,g_HPBartag)	
		gHPBar = HPBar
		HPBar:setPercentage(100);
		gHPBarBg = CCMenuItemImage:create("UI/Bar/HPbarBG.png", "UI/Bar/HPbarBG.png")
		gHPBarBg:setPosition(-700, 10)
		bglayer:addChild(gHPBarBg,2)
		
		

		--������
		ExpBar = CCProgressTimer:create(CCSprite:create("UI/Bar/Expbar.png"))
		ExpBar:setType(kCCProgressTimerTypeBar)
		ExpBar:setMidpoint(CCPointMake(0, 0))
		ExpBar:setBarChangeRate(CCPointMake(1, 0))
		ExpBar:setPosition(CCPointMake(-320, 570))
		bglayer:addChild(ExpBar,1,g_ExpBartag)	
		gExpBar = ExpBar
		ExpBar:setPercentage(0);
		local ExpBarBg = CCMenuItemImage:create("UI/Bar/goldbarbg.png", "UI/Bar/goldbarbg.png")
		ExpBarBg:setPosition(-320, 570)
		bglayer:addChild(ExpBarBg,2)
		
		

		--�����
		GoldBar = CCProgressTimer:create(CCSprite:create("UI/Bar/Goldbar.png"))
		GoldBar:setType(kCCProgressTimerTypeBar)
		GoldBar:setMidpoint(CCPointMake(0, 0))
		GoldBar:setBarChangeRate(CCPointMake(1, 0))
		GoldBar:setPosition(CCPointMake(-320, 540))
		bglayer:addChild(GoldBar,1,g_GoldBartag)	
		gGoldBar = GoldBar
		GoldBar:setPercentage(0);
		local GoldBarBg = CCMenuItemImage:create("UI/Bar/goldbarbg.png", "UI/Bar/goldbarbg.png")
		GoldBarBg:setPosition(-320, 540)
		bglayer:addChild(GoldBarBg,2)
		
			
	


		--��ʾ���Ѫ��
		local hpLabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(hpLabel)
			hpLabel:setColor(ccc3(255,255,255))
			hpLabel:setPosition(-20, 220)
			hpLabel:setTag(g_HPlabeltag);
		
		--��ʾ��ҹ���
		local ATlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(ATlabel)
			ATlabel:setColor(ccc3(255,0,0))
			ATlabel:setPosition(-20, 180)
			ATlabel:setTag(g_ATlabeltag);
					
			
		--��ʾ��ҽ��
		local GOLDlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(GOLDlabel)
			GOLDlabel:setColor(ccc3(255,0,0))
			GOLDlabel:setPosition(-20, 150)
			GOLDlabel:setTag(g_goldlabeltag);		

		--��ʾ������ʾ
		local Tiplabel = CCLabelTTF:create("Nor","Arial", 20)
			bglayer:addChild(Tiplabel)
			Tiplabel:setColor(ccc3(255,0,0))
			Tiplabel:setPosition(-20, 110)
			Tiplabel:setTag(g_Tiplabeltag);		--]]

		--��ʾ��Ҿ���
		local EXPlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(EXPlabel)
			EXPlabel:setColor(ccc3(255,0,0))
			EXPlabel:setPosition(-20, 80)
			EXPlabel:setTag(g_EXPlabeltag);		

		--��ʾ��ҵȼ�
		local LEVlabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(LEVlabel)
			LEVlabel:setColor(ccc3(255,0,0))
			LEVlabel:setPosition(-20, 270)
			LEVlabel:setTag(g_LEVlabeltag);		
	
	
		--��ʾMISSION
		local missionLabel = CCLabelTTF:create("", "Arial", 20)
			bglayer:addChild(missionLabel)
			missionLabel:setColor(ccc3(255,0,0))
			missionLabel:setPosition(-20, 420)
			missionLabel:setTag(g_missionlabeltag);
			
		--��ʾMISSION����
		gprogressbar = ProgressBar:Create()
		gprogressbar:setPosition(CCPointMake(85, 320))
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
		if PassiveSkill.Entity.Radar == 0 then
			p.HideSpeedBtn()
		else
			p.ShowSpeedBtn()
		end
		
		-- ������ť
		local item1 = CCMenuItemImage:create("UI/Button/upgradearrow.png", "UI/Button/upgradearrow.png")
    	item1:registerScriptTapHandler(p.menuCallbackUpgradeBtn)
		local menuUpGrade = CCMenu:create()
		menuUpGrade:addChild(item1,1,1)	
		menuUpGrade:setPosition(CCPointMake(0, 310))
		item1:setPosition(0,0)
		menuUpGrade:setTag(g_UpgradeBtntag);
		bglayer:addChild(menuUpGrade)		
		menuUpGrade:setVisible(true)
		
		
		--���ذ�ť		
		local itemBack = CCMenuItemImage:create("UI/Button/BACK.png", "UI/Button/BACK.png")
    	itemBack:registerScriptTapHandler(p.menuCallbackBack)
		itemBack:setScale(0.5);
		local menuBack = CCMenu:create()
		menuBack:addChild(itemBack,1,1)	
		menuBack:setPosition(CCPointMake(0, 485))
		itemBack:setPosition(0,0)
		--menuBack:setTag(g_UpgradeBtntag);
		bglayer:addChild(menuBack)		
		
   -- bglayer:setPosition(CCPointMake(800, 50))
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,3)
	bglayer:setTag(UIdefine.MainUI);
	
	p.SetMainUIMission(mission.GetMissionDesc())
	
	p.SetProgress(10)
	
	--[[Ʈ��
	local winSize = CCDirector:sharedDirector():getWinSize()
	bglayer:setPosition(CCPointMake(800, 50+winSize.height))
	local moveby = CCMoveBy:create(1, ccp(0,-winSize.height))
	bglayer:runAction(moveby)	--]]
	
	bglayer:setPosition(CCPointMake(800, 50))

	--���пؼ����뵭��Ч��
	local tUIAll = {}
table.insert(tUIAll,gEnergyBar)
table.insert(tUIAll,HPBar)
table.insert(tUIAll,ExpBar)
table.insert(tUIAll,GoldBar)
table.insert(tUIAll,gHPBarBg)
table.insert(tUIAll,ExpBarBg)
table.insert(tUIAll,GoldBarBg)
table.insert(tUIAll,hpLabel)
table.insert(tUIAll,ATlabel)
table.insert(tUIAll,GOLDlabel)
table.insert(tUIAll,Tiplabel)
table.insert(tUIAll,EXPlabel)
table.insert(tUIAll,LEVlabel)
table.insert(tUIAll,missionLabel)
table.insert(tUIAll,gprogressbar)
table.insert(tUIAll,menuUpGrade)
	for i,pUI in pairs(tUIAll)do
		local fadein = CCFadeIn:create(1)
		pUI:runAction(fadein)
	end
	
end


--����ѡ�ؽ���
function p.menuCallbackBack()
	GameOverUI.LoadUI(1)
end	

--��ʾSPEED��ť
function p.ShowSpeedBtn()
	local menu = bglayer:getChildByTag(g_SpeedBtntag)
	tolua.cast(menu, "CCMenu")
	menu:setVisible(true)
	waveCounter:setVisible(true)
end

--����SPEED��ť
function p.HideSpeedBtn()
	local menu = bglayer:getChildByTag(g_SpeedBtntag)
	tolua.cast(menu, "CCMenu")
	menu:setVisible(false)
	waveCounter:setVisible(false)
end

--��ʾ������ť
function p.ShowUpgradeBtn()
	local menu = bglayer:getChildByTag(g_UpgradeBtntag)
	tolua.cast(menu, "CCMenu")
	menu:setVisible(true)
end

--����������ť
function p.HideUpgradeBtn()
	local menu = bglayer:getChildByTag(g_UpgradeBtntag)
	tolua.cast(menu, "CCMenu")
	menu:setVisible(false)
end

function p.setWaveTimer(nPersent)
	waveCounter:setPercentage(nPersent);
end

function p.menuCallbackUpgradeBtn(tag,sender)
     --CCDirector:sharedDirector():pause()
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

--
function p.SetMainUIEnergy(energy,energymax)
	--gEnergyBar:setPercentage(100*energy/energymax);
	local  nPersent = 100*energy/energymax
	--[[
	if nPersent == 100 then
		nPersent = 99
	end	

	if gEnergyBar:getPercentage() == nPersent then
		return
	end	
		--]]
	gEnergyBar:stopAllActions() 
	local to2 = CCProgressFromTo:create(1, gEnergyBar:getPercentage(),nPersent)
	gEnergyBar:runAction(to2)
end--]]

function p.SetMainUIHP(nHP,nHPMAX)
	local label = bglayer:getChildByTag(g_HPlabeltag)
	tolua.cast(label, "CCLabelTTF")
	label:setString("HP:"..nHP.."/"..nHPMAX)
	
	--gHPBar:setPercentage(100*nHP/nHPMAX);
	
	local  nPersent = 100*nHP/nHPMAX
	
	gHPBar:stopAllActions() 
	--local to2 = CCProgressTo:create(1, nPersent)
	local to2 = CCProgressFromTo:create(1, gHPBar:getPercentage(),nPersent)
	gHPBar:runAction(to2)
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
	
	local  nPersent = 100*nEXP/player.GetExpNeed()
	
	gExpBar:stopAllActions() 
	if nPersent <= 0 then
		gExpBar:setPercentage(0)
	else
		local to2 = CCProgressFromTo:create(1, gExpBar:getPercentage(), nPersent)
		gExpBar:runAction(to2)
	end

end

function p.SetMainUIGOLD(nGOLD)
	local GOLDlabel = bglayer:getChildByTag(g_goldlabeltag)
	tolua.cast(GOLDlabel, "CCLabelTTF")
	GOLDlabel:setString("G:"..nGOLD) 	
	
	--gGoldBar:setPercentage(nGOLD%100);
	
	gGoldBar:stopAllActions() 
	if nGOLD >= 100 then
		gGoldBar:setPercentage(0);	
	end
	
	local  nPersent = nGOLD%100	
	local to2 = CCProgressFromTo:create(1, gGoldBar:getPercentage(), nPersent)
	gGoldBar:runAction(to2)	
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

function p.SetPlayDamageEff(nDamage)
	local damageSpri =  CCSprite:create("UI/damage.png")
	
	nDamage = math.ceil(nDamage)
	damageSpri:setPosition(110+math.random(-35,35), 80+math.random(-35,35));
	local arr = CCArray:create()
	local ZOrder = 100
	gHPBarBg:addChild(damageSpri,ZOrder)

	--����
	local Label = CCLabelTTF:create("- "..nDamage, "Arial", 65)
	Label:setPosition(110,80)
	damageSpri:addChild(Label)
	Label:setColor(ccc3(255,255,255))
	
		
	--��С������F
	damageSpri:setScale(0.2)
	local scaleact = CCScaleTo:create(0.15, 0.8)
	
	
	--�u�u�[��
	local fadeoutac  = CCFadeOut:create(1) 
	--ɾ��
	function delete(sender)
		sender:removeFromParentAndCleanup(true);
	end
	local actionremove = CCCallFuncN:create(delete)	
	
	arr:addObject(scaleact)
	arr:addObject(fadeoutac)	
	arr:addObject(actionremove)	
	local  seq = CCSequence:create(arr)		
	damageSpri:runAction(seq)
	
	
	local fadeoutac2  = CCFadeOut:create(1) 
	Label:runAction(fadeoutac2)
	
	--�o���S�C�Ƕ�
	damageSpri:setRotation(math.random(-25,25))			
end