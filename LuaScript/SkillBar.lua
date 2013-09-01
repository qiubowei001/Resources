SkillBar = {}

local p = SkillBar;
local glayerMenu = nil;







function p.Init(menuCallbackOpenPopup)
        glayerMenu = CCLayer:create()
		
		
		-- menu
		local item1 = CCMenuItemImage:create("skill/skillNone.png", "skill/skillNone.png")
		local item2 = CCMenuItemImage:create("skill/skillNone.png", "skill/skillNone.png")
    	local item3 = CCMenuItemImage:create("skill/skillNone.png", "skill/skillNone.png")
		local item4 = CCMenuItemImage:create("skill/skillNone.png", "skill/skillNone.png")
    	
    	item1:registerScriptTapHandler(menuCallbackOpenPopup)
    	item2:registerScriptTapHandler(menuCallbackOpenPopup)
    	item3:registerScriptTapHandler(menuCallbackOpenPopup)
		item4:registerScriptTapHandler(menuCallbackOpenPopup)

		local menu = CCMenu:create()
		menu:addChild(item1,1,1)
		menu:addChild(item2,1,2)
		menu:addChild(item3,1,3)
		menu:addChild(item4,1,4)
		
		menu:setPosition(CCPointMake(30, 0))
		item1:setPosition(0,240)
		item2:setPosition(0,180)
		item3:setPosition(0,120)
		item4:setPosition(0,60)

		
		glayerMenu:addChild(menu, 1,1)
		--]]

		p.refreshSkill();
		
        return glayerMenu
end



function p.GetMagicIdFromTag(nTag)
	local t = {
	player[playerInfo.SKILLID1],
	player[playerInfo.SKILLID2],
	player[playerInfo.SKILLID3],
	player[playerInfo.SKILLID4],
	}
	
	return t[nTag];
end

function p.refreshSkill()
	local t = {
	player[playerInfo.SKILLID1],
	player[playerInfo.SKILLID2],
	player[playerInfo.SKILLID3],
	player[playerInfo.SKILLID4],
	}
	
	local menu = glayerMenu:getChildByTag(1)
	tolua.cast(menu, "CCMenu")
	
	local tPic = {}
	
	for i,v in pairs(t) do
		if v == 0 then
			tPic[i] = "skill/skillNone.png"
		else
			tPic[i] = "skill/skill"..v..".png"
		end
	end
	
	for i=1,4 do
		local textureSkill = CCTextureCache:sharedTextureCache():addImage(tPic[i])	
		local rect = CCRectMake(0, 0, 50, 59)
		local frame0 = CCSpriteFrame:createWithTexture(textureSkill, rect)
		
		local item = menu:getChildByTag(i)
		tolua.cast(item, "CCMenuItemImage")
	
		item:setNormalSpriteFrame(frame0)
		item:setSelectedSpriteFrame(frame0)	
	end

end






