--πÿø®≈‰÷√

TimerBuff = {};
local p = TimerBuff;

local TimeBuffBarLabeltag =9999;

function p.LoadUI()
	bglayer = CCLayer:create()
		
	local TimeBuffBarLabel = CCLabelTTF:create("", "Arial", 20)
	bglayer:addChild(TimeBuffBarLabel,2)
	TimeBuffBarLabel:setColor(ccc3(255,0,0))
	TimeBuffBarLabel:setPosition(30, 30)
	TimeBuffBarLabel:setTag(TimeBuffBarLabeltag);		

	
    bglayer:setPosition(CCPointMake(230, 200))
	local scene = Main.GetGameScene();
	scene:addChild(bglayer)
	bglayer:setTag(TimeBuffBarUI);		
end



