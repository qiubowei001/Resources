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

		--类型{1武器 2铠甲 3项链 4戒指 5斗篷 6法珠} |
					--id 	|	名字 	|	类型	|	攻击力 | 血量增加| killBUFF| CRIT_Chance |Dodge_Chance	|PICTURE | GOLD_NEED | EnergyRecover
	tEquipType[1001]={1001   ,	"Lv1 ",		1,		  1 ,		0,			0,		0,				0	,		1001,		30	,		0,}
	tEquipType[1002]={1002   ,	"Lv2 ",		1,		  2 ,		0,			0,		0,				0	,		1001,		60	,		0,}
	tEquipType[1003]={1003   ,	"Lv3 ",		1,		  3 ,		0,			0,		0,				0	,		1001,		90	,		0,}
	tEquipType[1004]={1004   ,	"Lv4 ",		1,		  4 ,		0,			0,		0,				0	,		1001,		110	,		0,}
	tEquipType[1005]={1005   ,	"Lv5 ",		1,		  5 ,		0,			0,		0,				0	,		1001,		130	,		0,}
	tEquipType[1006]={1006   ,	"Lv6 ",		1,		  6 ,		0,			0,		0,				0	,		1001,		150	,		0,}
	tEquipType[1007]={1007   ,	"Lv7 ",		1,		  7 ,		0,			0,		0,				0	,		1001,		170	,		0,}
	tEquipType[1008]={1008   ,	"Lv8 ",		1,		  8 ,		0,			0,		0,				0	,		1001,		190	,		0,}
	tEquipType[1009]={1009   ,	"Lv9 ",		1,		  9 ,		0,			0,		0,				0	,		1001,		200	,		0,}
	tEquipType[1010]={1010   ,	"Lv10",		1,		  10,		0,			0,		0,				0	,		1001,		210	,		0,}
	tEquipType[1011]={1011   ,	"Lv11",		1,		  11,		0,			0,		0,				0	,		1001,		220	,		0,}
	tEquipType[1012]={1012   ,	"Lv12",		1,		  12,		0,			0,		0,				0	,		1001,		220	,		0,}
	tEquipType[1013]={1013   ,	"Lv13",		1,		  13,		0,			0,		0,				0	,		1001,		220	,		0,}
	tEquipType[1014]={1014   ,	"Lv14",		1,		  14,		0,			0,		0,				0	,		1001,		220	,		0,}
	tEquipType[1015]={1015   ,	"Lv15",		1,		  15,		0,			0,		0,				0	,		1001,		220	,		0,}
	tEquipType[1016]={1016   ,	"Lv16",		1,		  16,		0,			0,		0,				0	,		1001,		220	,		0,}
	tEquipType[1017]={1017   ,	"Lv17",		1,		  17,		0,			0,		0,				0	,		1001,		220	,		0,}
	tEquipType[1018]={1018   ,	"Lv18",		1,		  18,		0,			0,		0,				0	,		1001,		220	,		0,}
	tEquipType[1019]={1019   ,	"Lv19",		1,		  19,		0,			0,		0,				0	,		1001,		220	,		0,}
	tEquipType[1020]={1020   ,	"Lv20",		1,		  20,		0,			0,		0,				0	,		1001,		220	,		0,}
                                                     


	tEquipType[2001]={2001   ,	"Lv1 ",		2,		  0,		20,			0,		0,				0	,		2001,		30	,		0,}
	tEquipType[2002]={2002   ,	"Lv2 ",		2,		  0,		40,			0,		0,				0	,		2001,		60	,		0,}
	tEquipType[2003]={2003   ,	"Lv3 ",		2,		  0,		60,			0,		0,				0	,		2001,		90	,		0,}
	tEquipType[2004]={2004   ,	"Lv4 ",		2,		  0,		90,			0,		0,				0	,		2001,		110	,		0,}
	tEquipType[2005]={2005   ,	"Lv5 ",		2,		  0,		120,		0,		0,				0	,		2001,		130	,		0,}
	tEquipType[2006]={2006   ,	"Lv6 ",		2,		  0,		150,		0,		0,				0	,		2001,		150	,		0,}
	tEquipType[2007]={2007   ,	"Lv7 ",		2,		  0,		200,		0,		0,				0	,		2001,		170	,		0,}
	tEquipType[2008]={2008   ,	"Lv8 ",		2,		  0,		250,		0,		0,				0	,		2001,		190	,		0,}
	tEquipType[2009]={2009   ,	"Lv9 ",		2,		  0,		300,		0,		0,				0	,		2001,		200	,		0,}
	tEquipType[2010]={2010   ,	"Lv10",		2,		  0,		350,		0,		0,				0	,		2001,		210	,		0,}
	tEquipType[2011]={2011   ,	"Lv11",		2,		  0,		400,		0,		0,				0	,		2001,		220	,		0,}
	tEquipType[2012]={2012   ,	"Lv12",		2,		  0,		450,		0,		0,				0	,		2001,		220	,		0,}
	tEquipType[2013]={2013   ,	"Lv13",		2,		  0,		500,		0,		0,				0	,		2001,		220	,		0,}
	tEquipType[2014]={2014   ,	"Lv14",		2,		  0,		550,		0,		0,				0	,		2001,		220	,		0,}
	tEquipType[2015]={2015   ,	"Lv15",		2,		  0,		560,		0,		0,				0	,		2001,		220	,		0,}
	tEquipType[2016]={2016   ,	"Lv16",		2,		  0,		570,		0,		0,				0	,		2001,		220	,		0,}
	tEquipType[2017]={2017   ,	"Lv17",		2,		  0,		580,		0,		0,				0	,		2001,		220	,		0,}
	tEquipType[2018]={2018   ,	"Lv18",		2,		  0,		590,		0,		0,				0	,		2001,		220	,		0,}
	tEquipType[2019]={2019   ,	"Lv19",		2,		  0,		600,		0,		0,				0	,		2001,		220	,		0,}
	tEquipType[2020]={2020   ,	"Lv20",		2,		  0,		610,		0,		0,				0	,		2001,		220	,		0,}
                                  


	tEquipType[3001]={3001   ,	"Lv1",		3,		  0,		0,			0.1,	0,				0	,			3001,		30	,		0,}
	tEquipType[3002]={3002   ,	"Lv2",		3,		  0,		0,			0.2,	0,				0	,			3001,		60	,		0,}
	tEquipType[3003]={3003   ,	"Lv3",		3,		  0,		0,			0.3,	0,				0	,			3001,		90	,		0,}
	tEquipType[3004]={3004   ,	"Lv4",		3,		  0,		0,			0.4,	0,				0	,			3001,		110	,		0,}
    tEquipType[3005]={3005   ,	"Lv5",		3,		  0,		0,			0.5,	0,				0	,			3001,		120 ,		0,}
                                                                                                
                                                                                                 
                                                                                                 
	tEquipType[4001]={4001   ,	"Lv1 ",		4,		  0,		0,			0,		1 ,			0	,			4001,		30	,		0,}
	tEquipType[4002]={4002   ,	"Lv2 ",		4,		  0,		0,			0,		2 ,			0	,			4001,		60	,		0,}
	tEquipType[4003]={4003   ,	"Lv3 ",		4,		  0,		0,			0,		3 ,			0	,			4001,		90	,		0,}
	tEquipType[4004]={4004   ,	"Lv4 ",		4,		  0,		0,			0,		4 ,			0	,			4001,		110	,		0,}
	tEquipType[4005]={4005   ,	"Lv5 ",		4,		  0,		0,			0,		5 ,			0	,			4001,		130	,		0,}
	tEquipType[4006]={4006   ,	"Lv6 ",		4,		  0,		0,			0,		6 ,			0	,			4001,		150	,		0,}
	tEquipType[4007]={4007   ,	"Lv7 ",		4,		  0,		0,			0,		7 ,			0	,			4001,		170	,		0,}
	tEquipType[4008]={4008   ,	"Lv8 ",		4,		  0,		0,			0,		8 ,			0	,			4001,		190	,		0,}
	tEquipType[4009]={4009   ,	"Lv9 ",		4,		  0,		0,			0,		9 ,			0	,			4001,		200	,		0,}
	tEquipType[4010]={4010   ,	"Lv10",		4,		  0,		0,			0,		10,			0	,			4001,		210	,		0,}
	tEquipType[4011]={4011   ,	"Lv11",		4,		  0,		0,			0,		11,			0	,			4001,		220	,		0,}
	tEquipType[4012]={4012   ,	"Lv12",		4,		  0,		0,			0,		12,			0	,			4001,		220	,		0,}
	tEquipType[4013]={4013   ,	"Lv13",		4,		  0,		0,			0,		13,			0	,			4001,		220	,		0,}
	tEquipType[4014]={4014   ,	"Lv14",		4,		  0,		0,			0,		14,			0	,			4001,		220	,		0,}
	tEquipType[4015]={4015   ,	"Lv15",		4,		  0,		0,			0,		15,			0	,			4001,		220	,		0,}
	tEquipType[4016]={4016   ,	"Lv16",		4,		  0,		0,			0,		16,			0	,			4001,		220	,		0,}
	tEquipType[4017]={4017   ,	"Lv17",		4,		  0,		0,			0,		17,			0	,			4001,		220	,		0,}
	tEquipType[4018]={4018   ,	"Lv18",		4,		  0,		0,			0,		18,			0	,			4001,		220	,		0,}
	tEquipType[4019]={4019   ,	"Lv19",		4,		  0,		0,			0,		19,			0	,			4001,		220	,		0,}
	tEquipType[4020]={4020   ,	"Lv20",		4,		  0,		0,			0,		20,			0	,			4001,		220	,		0,}
                                                                                


	tEquipType[5001]={5001   ,	"Lv1 ",		5,		  0,		0,			0,		0,			1 	,			5001,		30	,		0,}
	tEquipType[5002]={5002   ,	"Lv2 ",		5,		  0,		0,			0,		0,			2 	,			5001,		60	,		0,}
	tEquipType[5003]={5003   ,	"Lv3 ",		5,		  0,		0,			0,		0,			4 	,			5001,		90	,		0,}
	tEquipType[5004]={5004   ,	"Lv4 ",		5,		  0,		0,			0,		0,			6 	,			5001,		110	,		0,}
	tEquipType[5005]={5005   ,	"Lv5 ",		5,		  0,		0,			0,		0,			8 	,			5001,		130	,		0,}
	tEquipType[5006]={5006   ,	"Lv6 ",		5,		  0,		0,			0,		0,			10 	,			5001,		150	,		0,}
	tEquipType[5007]={5007   ,	"Lv7 ",		5,		  0,		0,			0,		0,			12 	,			5001,		170	,		0,}
	tEquipType[5008]={5008   ,	"Lv8 ",		5,		  0,		0,			0,		0,			14 	,			5001,		190	,		0,}
	tEquipType[5009]={5009   ,	"Lv9 ",		5,		  0,		0,			0,		0,			16 	,			5001,		200	,		0,}
	tEquipType[5010]={5010   ,	"Lv10",		5,		  0,		0,			0,		0,			18	,			5001,		210	,		0,}
	tEquipType[5011]={5011   ,	"Lv11",		5,		  0,		0,			0,		0,			20	,			5001,		220	,		0,}
	tEquipType[5012]={5012   ,	"Lv12",		5,		  0,		0,			0,		0,			22	,			5001,		220	,		0,}
	tEquipType[5013]={5013   ,	"Lv13",		5,		  0,		0,			0,		0,			24	,			5001,		220	,		0,}
	tEquipType[5014]={5014   ,	"Lv14",		5,		  0,		0,			0,		0,			26	,			5001,		220	,		0,}
	tEquipType[5015]={5015   ,	"Lv15",		5,		  0,		0,			0,		0,			28	,			5001,		220	,		0,}
	tEquipType[5016]={5016   ,	"Lv16",		5,		  0,		0,			0,		0,			30	,			5001,		220	,		0,}
	tEquipType[5017]={5017   ,	"Lv17",		5,		  0,		0,			0,		0,			32	,			5001,		220	,		0,}
	tEquipType[5018]={5018   ,	"Lv18",		5,		  0,		0,			0,		0,			34	,			5001,		220	,		0,}
	tEquipType[5019]={5019   ,	"Lv19",		5,		  0,		0,			0,		0,			36	,			5001,		220	,		0,}
	tEquipType[5020]={5020   ,	"Lv20",		5,		  0,		0,			0,		0,			38	,			5001,		220	,		0,}
                                                                                           
	tEquipType[6001]={6001   ,	"Lv1 ",		6,		  0,		0,			0,		0,			0	,			6001,		30	,		0.1,}
	tEquipType[6002]={6002   ,	"Lv2 ",		6,		  0,		0,			0,		0,			0	,			6001,		60	,		0.2,}
	tEquipType[6003]={6003   ,	"Lv3 ",		6,		  0,		0,			0,		0,			0	,			6001,		90	,		0.3,}
	tEquipType[6004]={6004   ,	"Lv4 ",		6,		  0,		0,			0,		0,			0	,			6001,		110	,		0.4,}
	tEquipType[6005]={6005   ,	"Lv5 ",		6,		  0,		0,			0,		0,			0	,			6001,		130	,		0.5,}
	tEquipType[6006]={6006   ,	"Lv6 ",		6,		  0,		0,			0,		0,			0 	,			6001,		150	,		0.6,}
	tEquipType[6007]={6007   ,	"Lv7 ",		6,		  0,		0,			0,		0,			0 	,			6001,		170	,		0.7,}
	tEquipType[6008]={6008   ,	"Lv8 ",		6,		  0,		0,			0,		0,			0 	,			6001,		190	,		0.8,}
	tEquipType[6009]={6009   ,	"Lv9 ",		6,		  0,		0,			0,		0,			0 	,			6001,		200	,		0.9,}
	tEquipType[6010]={6010   ,	"Lv10",		6,		  0,		0,			0,		0,			0	,			6001,		210	,		1.0,}
	tEquipType[6011]={6011   ,	"Lv11",		6,		  0,		0,			0,		0,			0	,			6001,		220	,		1.1,}
	tEquipType[6012]={6012   ,	"Lv12",		6,		  0,		0,			0,		0,			0	,			6001,		220	,		2,}
	tEquipType[6013]={6013   ,	"Lv13",		6,		  0,		0,			0,		0,			0	,			6001,		220	,		2,}
	tEquipType[6014]={6014   ,	"Lv14",		6,		  0,		0,			0,		0,			0	,			6001,		220	,		2,}
	tEquipType[6015]={6015   ,	"Lv15",		6,		  0,		0,			0,		0,			0	,			6001,		220	,		2,}
	tEquipType[6016]={6016   ,	"Lv16",		6,		  0,		0,			0,		0,			0	,			6001,		220	,		2,}
	tEquipType[6017]={6017   ,	"Lv17",		6,		  0,		0,			0,		0,			0	,			6001,		220	,		2,}
	tEquipType[6018]={6018   ,	"Lv18",		6,		  0,		0,			0,		0,			0	,			6001,		220	,		2,}
	tEquipType[6019]={6019   ,	"Lv19",		6,		  0,		0,			0,		0,			0	,			6001,		220	,		2,}
	tEquipType[6020]={6020   ,	"Lv20",		6,		  0,		0,			0,		0,			0	,			6001,		220	,		2,}






 
--初始装备ID
local tEquipInitialId = 
{
	1001,2001,3001,4001,5001,6001
}

local g_tNext = {}

local gMenuTag = 1;


function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.EquipUpGradeUI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end



function p.LearnEquipCallback(tag,sender)
	local learningEquipid = 0
	learningEquipid = g_tNext[tag]
	
			
	if player.UpGradeEquip(learningEquipid) == true then
		--全局事件
		GlobalEvent.OnEvent(GLOBAL_EVENT.UPGRADE_EQUIP)
			
		--刷新显示
		p.RefreshMenu()	
	end
end



--获取升级装备ID 
function p.GetNextEquipId()
	
	local tPlayerEquip = player.GetPlayerEquip()
	--[[{
		player[playerInfo.WEAPON] 	,
		player[playerInfo.ARMOR] 	,
		player[playerInfo.NECKLACE] ,
		player[playerInfo.RING] 	,
		player[playerInfo.CAPE] 	,
	}--]]
	
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
		LvLabel:setString(tEquipType[v-1][2])
		
		local needLabel = item:getChildByTag(9998)
		needLabel = tolua.cast(needLabel, "CCLabelTTF")
		needLabel:setString(tEquipType[v][10])
		--增加需求金币显示
		if  player[playerInfo.GOLD]  >= tEquipType[v][10]  then
			LvLabel:setColor(ccc3(255,255,255))
			needLabel:setColor(ccc3(255,255,255))
		else
			needLabel:setColor(ccc3(255,0,0))
			LvLabel:setColor(ccc3(255,0,0))
		end
		
	end
end


function p.ShowAllUI()
	if CCDirector:sharedDirector():isPaused() then
		CCDirector:sharedDirector():resume()
    end	   
	local bglayer = p.GetParent() 
	-->>>>>>>>>>>>>>>动画效果	
	function pause()
		Main.EnableTouch(true)--打开触摸
		CCDirector:sharedDirector():pause()
	end	
	--向左飘入
	local arr = CCArray:create()	
	local moveby = CCMoveBy:create(1, ccp(-0.8*winSize.width,0))
	local actiontoease =  CCEaseBounceOut:create(moveby)	
	
	local actionremove = CCCallFuncN:create(pause)
	arr:addObject(actiontoease)
	arr:addObject(actionremove)
	
	local  seq = CCSequence:create(arr)	
	bglayer:runAction(seq)	

	Main.EnableTouch(false)--阻断触摸
	--<<<<<<<<<<<<<<<--	
end	

function p.closeUICallback(tag,sender)
	--关闭界面 
	local bglayer = p.GetParent()
	--function resume()
		if CCDirector:sharedDirector():isPaused() then
			CCDirector:sharedDirector():resume()
		end	
	--end	
	
	--向右飘出
	local arr = CCArray:create()	
	local moveby = CCMoveBy:create(0.5, ccp(0.8*winSize.width,0))
	arr:addObject(moveby)
	
	
	--local actionreresume = CCCallFuncN:create(resume)
	--arr:addObject(actionreresume)

	local  seq = CCSequence:create(arr)	
	bglayer:runAction(seq)	
end


function p.LoadUI()
	--[[
	if CCDirector:sharedDirector():isPaused() then
		CCDirector:sharedDirector():resume()
    end	   
	--]]
		
		local tPlayerEquip = player.GetPlayerEquip()
		--[[
		 {
			player[playerInfo.WEAPON] 	,
			player[playerInfo.ARMOR] 	,
			player[playerInfo.NECKLACE] ,
			player[playerInfo.RING] 	,
			player[playerInfo.CAPE] 	,
			player[playerInfo.CAPE] 	,
			
			}
		--]]
		
		g_tNext = p.GetNextEquipId()
		
        bglayer = CCLayer:create()
		
		
		local tItem = {}
		local menu = CCMenu:create()
		
		--[[等级
		local LvLabel = CCLabelTTF:create("level", "Arial", 17)
		LvLabel:setColor(ccc3(0,0,0))
		LvLabel:setPosition(-350, 250)
		bglayer:addChild(LvLabel,2,10000)--, 2)--:addChild(LvLabel,1,9999)
		--]]	
		
		--金币
		local needLabel = CCLabelTTF:create("Gold", "Arial", 17)
		needLabel:setColor(ccc3(0,0,0))
		needLabel:setPosition(-350, 250)
		bglayer:addChild(needLabel,2,10000)--, 2)--:addChild(LvLabel,1,9999)
			
		
			
		for i,v in pairs(g_tNext) do
			
			local item = CCMenuItemImage:create("Equip/"..tEquipType[v][9]..".png", "Equip/"..tEquipType[v][9]..".png")
			item:registerScriptTapHandler(p.LearnEquipCallback)
			
			
			--增加等级显示
			local equipLV = tEquipType[v-1][2]
			local LvLabel = CCLabelTTF:create(""..equipLV, "Arial", 21)
			LvLabel:setColor(ccc3(0,0,0))
			LvLabel:setPosition(30, 30)
			item:addChild(LvLabel,1,9999)
			
			--增加需求金币显示
			local needLabel = CCLabelTTF:create(""..tEquipType[v][10], "Arial", 21)
			if  player[playerInfo.GOLD]  >= tEquipType[v][10]  then
				needLabel:setColor(ccc3(255,255,255))
				LvLabel:setColor(ccc3(255,255,255))
			else
				needLabel:setColor(ccc3(255,0,0))
				LvLabel:setColor(ccc3(255,0,0))
			end
			
			needLabel:setPosition(100, 30)


			item:addChild(needLabel,1,9998)
			
			item:setPosition(-400,80*i - 300 )
			menu:addChild(item,1,i)
			
			
		end
		

		
		
		local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
			closeBtn:registerScriptTapHandler(p.closeUICallback)
			closeBtn:setPosition(300,100)
			
			
		menu:addChild(closeBtn)
		
		
		menu:setPosition(CCPointMake(0, 0))
		bglayer:addChild(menu, 2,gMenuTag)
		--]]
		
		
		bglayer:setTag(UIdefine.EquipUpGradeUI);
		
		--增加背景
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
		bgSprite:setScaleX(1.4);
		--bgSprite:setScaleY(1.0);
        bglayer:addChild(bgSprite,1)
		
		local scene = Main.GetGameScene();
		
		scene:addChild(bglayer,5)	
	
		bglayer:setPosition(350 + winSize.width , 300)
end






