--������UI
MainUI = {};
local p = MainUI;

local g_HPlabeltag =1;
local g_ATlabeltag= 2;
local g_goldlabeltag= 3;
local g_Tiplabeltag = 4;
local g_EXPlabeltag = 5;
local g_LEVlabeltag =6;
local bglayer = nil;

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
	
	
    bglayer:setPosition(CCPointMake(800, 50))
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,3)
	bglayer:setTag(UIdefine.MainUI);
	
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