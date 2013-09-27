




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
			
		--Ôö¼Ó±³¾°
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
	    bglayer:addChild(bgSprite,1)
		bgSprite:setPosition(CCPointMake(480, 320))
		bgSprite:setScale(5);
		local scene = Main.GetGameScene();
		scene:addChild(bglayer)
	
		

		--[[
		emitter = CCParticleSystemQuad:new()
		emitter:autorelease()
		local filename = "Particle/LavaFlow.plist"
		emitter:initWithFile(filename)
		bglayer:addChild(emitter, 10)
		--]]
end



