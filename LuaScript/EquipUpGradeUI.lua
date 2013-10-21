EquipUpGradeUI = {}


--[[
金币 随机2选1

血量上限 铠甲
攻击力 武器
TIMEBUFF 项链
暴击 戒指
闪避 斗篷
]]


local p = EquipUpGradeUI;

local tEquipTableInfo = 
{
	

}

tEquipType = {}
for i= 1,10000 do
	tEquipType[i] = nil;
end

		--类型{1武器 2铠甲 3项链 4戒指 5斗篷} |
					--id 	|	名字 	|	类型	|	攻击力 | 血量增加| TIMEBUFF| CRIT_Chance |Dodge_Chance	|PICTURE
	tEquipType[1001]={1001   ,	"Lv1",		1,		  1,		0,			0,		0,				0	,		1001}
	tEquipType[1002]={1002   ,	"Lv2",		1,		  2,		0,			0,		0,				0	,		1001}
	tEquipType[1003]={1003   ,	"Lv3",		1,		  3,		0,			0,		0,				0	,		1001}
	tEquipType[1004]={1004   ,	"Lv4",		1,		  4,		0,			0,		0,				0	,		1001}



	tEquipType[2001]={2001   ,	"Lv1",		2,		  0,		10,			0,		0,				0	,		2001}
	tEquipType[2002]={2002   ,	"Lv2",		2,		  0,		20,			0,		0,				0	,		2001}
	tEquipType[2003]={2003   ,	"Lv3",		2,		  0,		30,			0,		0,				0	,		2001}
	tEquipType[2004]={2004   ,	"Lv4",		2,		  0,		40,			0,		0,				0	,		2001}



	tEquipType[3001]={3001   ,	"Lv1",		3,		  0,		0,			1,		0,			0	,			3001}
	tEquipType[3002]={3002   ,	"Lv2",		3,		  0,		0,			2,		0,			0	,			3001}
	tEquipType[3003]={3003   ,	"Lv3",		3,		  0,		0,			3,		0,			0	,			3001}
	tEquipType[3004]={3004   ,	"Lv4",		3,		  0,		0,			4,		0,			0	,			3001}
                                                                                                 
                                                                                                 
                                                                                                 
	tEquipType[4001]={4001   ,	"Lv1",		4,		  0,		0,			0,		5,			0	,			4001}
	tEquipType[4002]={4002   ,	"Lv2",		4,		  0,		0,			0,		10,			0	,			4001}
	tEquipType[4003]={4003   ,	"Lv3",		4,		  0,		0,			0,		15,			0	,			4001}
	tEquipType[4004]={4004   ,	"Lv4",		4,		  0,		0,			0,		20,			0	,			4001}



	tEquipType[5001]={5001   ,	"Lv1",		5,		  0,		0,			0,		0,			5 	,			5001}
	tEquipType[5002]={5002   ,	"Lv2",		5,		  0,		0,			0,		0,			10	,			5001}
	tEquipType[5003]={5003   ,	"Lv3",		5,		  0,		0,			0,		0,			15	,			5001}
	tEquipType[5004]={5004   ,	"Lv4",		5,		  0,		0,			0,		0,			20	,			5001}


--初始装备ID
local tEquipInitialId = 
{
	1001,2001,3001,4001,5001
}

local g_tNext = {}

local gMenuTag = 1;


function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.EquipUpGradeUI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end

function p.closeUICallback(tag,sender)
	--关闭界面 
	local layer = p.GetParent()
	local scene = Main.GetGameScene();
	scene:removeChild(layer, true)
	
	if CCDirector:sharedDirector():isPaused() then
		CCDirector:sharedDirector():resume()
    end	   
end

function p.LearnEquipCallback(tag,sender)
	local learningEquipid = 0
	learningEquipid = g_tNext[tag]
	if player.UpGradeEquip(learningEquipid) == true then
		--刷新显示
		p.RefreshMenu()	
	end
end



--获取升级装备ID 
function p.GetNextEquipId()
	
	local tPlayerEquip = {
		player[playerInfo.WEAPON] 	,
		player[playerInfo.ARMOR] 	,
		player[playerInfo.NECKLACE] ,
		player[playerInfo.RING] 	,
		player[playerInfo.CAPE] 	,
	}
	
	local tNext = {}
	
	for i,v in pairs(tPlayerEquip) do
		if tEquipType[v + 1] ~= nil then
			tNext[i] = v + 1;
		else
			tNext[i] = v;
		end	
	end
	
			
	return tNext
end

--刷新显示
function p.RefreshMenu()
	g_tNext = p.GetNextEquipId()
	local bglayer = p.GetParent()
	
	local menu = bglayer:getChildByTag(gMenuTag);
	local menu = tolua.cast(menu, "CCMenu")
	
	
	local tItem = {}		
	for i,v in pairs(g_tNext) do
		
		local item = menu:getChildByTag(i);    
		item = tolua.cast(item, "CCMenuItemImage")
		local LvLabel = item:getChildByTag(9999)
		LvLabel = tolua.cast(LvLabel, "CCLabelTTF")
		LvLabel:setString(tEquipType[v][2])
	end
end


function p.LoadUI()
	
		local tPlayerEquip = {
			player[playerInfo.WEAPON] 	,
			player[playerInfo.ARMOR] 	,
			player[playerInfo.NECKLACE] ,
			player[playerInfo.RING] 	,
			player[playerInfo.CAPE] 	,
			}
		
		
		g_tNext = p.GetNextEquipId()
		
        bglayer = CCLayer:create()
		
		
		local tItem = {}
		local menu = CCMenu:create()
		
		 
		for i,v in pairs(g_tNext) do
			
			local item = CCMenuItemImage:create("Equip/"..tEquipType[v][9]..".png", "Equip/"..tEquipType[v][9]..".png")
			item:registerScriptTapHandler(p.LearnEquipCallback)
			
			
			--增加等级显示
			local LvLabel = CCLabelTTF:create(""..tEquipType[v][2], "Arial", 15)
			LvLabel:setColor(ccc3(0,0,0))
			LvLabel:setPosition(10, -10)
			item:addChild(LvLabel,1,9999)
			
			menu:addChild(item,1,i)
			
			item:setPosition(80*i - 250  ,0)
		end
		

		
		
		local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
			closeBtn:registerScriptTapHandler(p.closeUICallback)
			closeBtn:setPosition(300,100)
			
			
		menu:addChild(closeBtn)
		
		
		menu:setPosition(CCPointMake(0, 0))
		bglayer:addChild(menu, 2,gMenuTag)
		--]]
		
		
		bglayer:setTag(UIdefine.EquipUpGradeUI);
		bglayer:setPosition(CCPointMake(0, 0))
		
		
		--增加背景
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
		bgSprite:setScale(1.5);
        bglayer:addChild(bgSprite,1)
		bglayer:setPosition(CCPointMake(230, 200))
		
		
		local scene = Main.GetGameScene();
		
		scene:addChild(bglayer)	
end






