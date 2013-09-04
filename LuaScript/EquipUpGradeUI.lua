EquipUpGradeUI = {}


--[[
��� ���2ѡ1

Ѫ������ ����
������ ����
TIMEBUFF ����
���� ��ָ
���� ����
]]


local p = EquipUpGradeUI;

local tEquipTableInfo = 
{
	

}

tEquipType = 
{
--����{1���� 2���� 3���� 4��ָ 5����} |
		--id 	|	���� 	|	����	|	������ | Ѫ������| TIMEBUFF| CRIT_Chance |Dodge_Chance	|PICTURE
[1001]={1001   ,	"Lv1",		1,		  1,		0,			0,		0,			0	,1001},
[1002]={1002   ,	"Lv2",		1,		  2,		0,			0,		0,			0	,1001},
[1003]={1003   ,	"Lv3",		1,		  3,		0,			0,		0,			0	,1001},
[1004]={1004   ,	"Lv4",		1,		  4,		0,			0,		0,			0	,1001},



[2001]={2001   ,	"Lv1",		2,		  0,		10,			0,		0,			0	,2001},
[2002]={2002   ,	"Lv2",		2,		  0,		20,			0,		0,			0	,2001},
[2003]={2003   ,	"Lv3",		2,		  0,		30,			0,		0,			0	,2001},
[2004]={2004   ,	"Lv4",		2,		  0,		40,			0,		0,			0	,2001},



[3001]={3001   ,	"Lv1",		3,		  0,		0,			1,		0,			0	,3001},
[3002]={3002   ,	"Lv2",		3,		  0,		0,			2,		0,			0	,3001},
[3003]={3003   ,	"Lv3",		3,		  0,		0,			3,		0,			0	,3001},
[3004]={3004   ,	"Lv4",		3,		  0,		0,			4,		0,			0	,3001},



[4001]={4001   ,	"Lv1",		4,		  0,		0,			0,		5,			0	,4001},
[4002]={4002   ,	"Lv2",		4,		  0,		0,			0,		10,			0	,4001},
[4003]={4003   ,	"Lv3",		4,		  0,		0,			0,		15,			0	,4001},
[4004]={4004   ,	"Lv4",		4,		  0,		0,			0,		20,			0	,4001},



[5001]={5001   ,	"Lv1",		5,		  0,		0,			0,		0,			5 	,5001},
[5002]={5002   ,	"Lv2",		5,		  0,		0,			0,		0,			10	,5001},
[5003]={5003   ,	"Lv3",		5,		  0,		0,			0,		0,			15	,5001},
[5004]={5004   ,	"Lv4",		5,		  0,		0,			0,		0,			20	,5001},
}

--��ʼװ��ID
local tEquipInitialId = 
{
	1001,2001,3001,4001,5001
}

local g_tNext = {}




function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.EquipUpGradeUI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end

function p.LearnEquipCallback(tag,sender)
	local learningEquipid = 0
	learningEquipid = g_tNext[tag]
	player.UpGradeEquip(learningEquipid);

	--�رս��� 
	local layer = p.GetParent()
	local scene = Main.GetGameScene();
	scene:removeChild(layer, true)
	
	
	
end



--��ȡ����װ��ID 
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
		tNext[i] = v + 1;
	end
	
			
	return tNext
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
			
			
			--���ӵȼ���ʾ
			local LvLabel = CCLabelTTF:create(""..tEquipType[v][2], "Arial", 15)
			LvLabel:setColor(ccc3(0,0,0))
			LvLabel:setPosition(10, -10)
			item:addChild(LvLabel,1,1)
			
			menu:addChild(item,1,i)
			item:setPosition(80*i - 250  ,0)
		end
		
		
		
		menu:setPosition(CCPointMake(0, 0))
		bglayer:addChild(menu, 2,1)
		--]]
		
		
		bglayer:setTag(UIdefine.EquipUpGradeUI);
		bglayer:setPosition(CCPointMake(0, 0))
		
		
		--���ӱ���
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
		bgSprite:setScale(1.5);
        bglayer:addChild(bgSprite,1)
		bglayer:setPosition(CCPointMake(230, 200))
		
		
		local scene = Main.GetGameScene();
		
		scene:addChild(bglayer)	
end






