




MissionSelectUI = {}
local p = MissionSelectUI;

local bglayer=nil;

local tMissionPortalInfo = 
{
	[1] = {POSITION={50, 500}},
	[2] = {POSITION={150,500}},
	[3] = {POSITION={250,500}},
	[4] = {POSITION={350,500}},
	[5] = {POSITION={450,500}},
}


function test()
	-- set default value
    CCUserDefault:sharedUserDefault():setStringForKey("string", "value1")
    CCUserDefault:sharedUserDefault():setIntegerForKey("integer", 10)
    CCUserDefault:sharedUserDefault():setFloatForKey("float", 2.3)
    CCUserDefault:sharedUserDefault():setDoubleForKey("double", 2.4)
    CCUserDefault:sharedUserDefault():setBoolForKey("bool", true)
	--CCUserDefault:sharedUserDefault():setBoolForKey("QBW", true)

    -- print value

    local ret = CCUserDefault:sharedUserDefault():getStringForKey("string")
    cclog("string is %s", ret)

    local d = CCUserDefault:sharedUserDefault():getDoubleForKey("double")
    cclog("double is %f", d)

    local i = CCUserDefault:sharedUserDefault():getIntegerForKey("integer")
    cclog("integer is %d", i)

    local f = CCUserDefault:sharedUserDefault():getFloatForKey("float")
    cclog("float is %f", f)

    local b = CCUserDefault:sharedUserDefault():getBoolForKey("bool")
	
	local qbw = CCUserDefault:sharedUserDefault():getIntegerForKey("QBW22")
	
	
    if b == true then
        cclog("bool is true")
    else
        cclog("bool is false")
    end

    --CCUserDefault:sharedUserDefault():flush()

    cclog("********************** after change value ***********************")

    -- change the value

    CCUserDefault:sharedUserDefault():setStringForKey("string", "value2")
    CCUserDefault:sharedUserDefault():setIntegerForKey("integer", 11)
    CCUserDefault:sharedUserDefault():setFloatForKey("float", 2.5)
    CCUserDefault:sharedUserDefault():setDoubleForKey("double", 2.6)
    CCUserDefault:sharedUserDefault():setBoolForKey("bool", false)

    CCUserDefault:sharedUserDefault():flush()

    -- print value

    ret = CCUserDefault:sharedUserDefault():getStringForKey("string")
    cclog("string is %s", ret)

    d = CCUserDefault:sharedUserDefault():getDoubleForKey("double")
    cclog("double is %f", d)

    i = CCUserDefault:sharedUserDefault():getIntegerForKey("integer")
    cclog("integer is %d", i)

    f = CCUserDefault:sharedUserDefault():getFloatForKey("float")
    cclog("float is %f", f)

    b = CCUserDefault:sharedUserDefault():getBoolForKey("bool")
    if b == true then
        cclog("bool is true")
    else
        cclog("bool is false")
    end
end

function UserDefaultTestMain()
    local s = CCDirector:sharedDirector():getWinSize()
    local  label = CCLabelTTF:create("CCUserDefault test see log", "Arial", 28)
    g_sceneGame:addChild(label, 0)
    label:setPosition( ccp(s.width/2, s.height-50) )
    test()
    return g_sceneGame
end

function p.PortalOnClick(tag,sender)
	
			
	Main.main(tag);
	local winSize = CCDirector:sharedDirector():getWinSize()
	local moveby = CCMoveBy:create(1, ccp(0,-winSize.height))
	
	--渐渐隐藏 删除
	function delete(sender)
		sender:removeFromParentAndCleanup(true);
	end
		
	local actionremove = CCCallFuncN:create(delete)
	local arr = CCArray:create()
	arr:addObject(moveby)
	arr:addObject(actionremove)
	
	local  seq = CCSequence:create(arr)	
	bglayer:runAction(seq)	
	--bglayer:removeFromParentAndCleanup(true);
	--]]
end

function p.RunScene()
	CCDirector:sharedDirector():runWithScene(g_sceneGame)
end


function p.LoadUI()
		g_sceneGame = CCScene:create();
		
		
		
		bglayer = CCLayer:create()

		local menu = CCMenu:create()
		menu:setPosition(CCPointMake(0, 0))

		for nMission,v in pairs(tMissionPortalInfo) do
			local Portal = CCMenuItemImage:create("UI/MissionSelect/portal.png","UI/MissionSelect/portal.png")
			Portal:registerScriptTapHandler(p.PortalOnClick)
			menu:addChild(Portal,1,nMission)
			Portal:setPosition(v.POSITION[1],v.POSITION[2])
		end
		
		
		bglayer:addChild(menu, 2,1)
		bglayer:setTag(UIdefine.MissionSelectUI);
			
		--增加背景
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
	    bglayer:addChild(bgSprite,1)
		bgSprite:setPosition(CCPointMake(480, 320))
		bgSprite:setScale(5);
		local scene = g_sceneGame;
		scene:addChild(bglayer)
		
		--local numbersprite = NumberToPic.GetPicByNumBer(1234567890)
		--numbersprite:setPosition(CCPointMake(200, 120))
		--scene:addChild(numbersprite,99)
		
		local tAttType = 
{
	[1] = ccc3(255,255,255),--白色
[2] = ccc3(0,255,0),--绿色
[3] = ccc3(0,0,255),--蓝色
[4] = ccc3(160,32,240),--紫色
[5] = ccc3(255,255,0),--橙色
[6] = ccc3(255,0,0),--红色

[7] = ccc3(0,0,0),--黑色
--色
--色
--色
}
		for i,v in pairs(tAttType) do
		local sprite = CCSprite:create("UI/AttGrade/att.png")
		
        sprite:setPosition(CCPointMake(80*i, 220))
		bglayer:addChild(sprite,5)
		sprite:setColor(v)			
		end

	return g_sceneGame
end



