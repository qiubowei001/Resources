




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




function p.PortalOnClick(tag,sender)
	Main.main(tag);
	bglayer:removeFromParentAndCleanup(true);
end


function p.LoadUI()
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
		local scene = Main.GetGameScene();
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
	
end



