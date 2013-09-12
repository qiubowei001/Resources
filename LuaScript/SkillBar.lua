SkillBar = {}

local p = SkillBar;
local glayerMenu = nil;


local  cdlabeltag = 9999;

local tSkillCD = 
{
5,
5,
5,
5,
}



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

		--初始化技能信息显示
		local tTmp = 
		{
		item1,
		item2,
		item3,
		item4,
		}
		
		for i,v in pairs(tTmp) do
			local cdLabel = CCLabelTTF:create("", "Arial", 20)
			v:addChild(cdLabel,2)
			cdLabel:setColor(ccc3(255,0,0))
			cdLabel:setPosition(30, 30)
			cdLabel:setTag(cdlabeltag);			
		end
		
		p.refreshSkill();
		glayerMenu:setPosition(10, 230)
		
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


function p.GetTagFromId(nSkillId)
	local t = {
	player[playerInfo.SKILLID1],
	player[playerInfo.SKILLID2],
	player[playerInfo.SKILLID3],
	player[playerInfo.SKILLID4],
	}
	
	for i,v in pairs() do
		if v == nSkillId then
			return i;
		end
	end
	
end


function p.refreshSkill()
	local t = {
	player[playerInfo.SKILLID1],
	player[playerInfo.SKILLID2],
	player[playerInfo.SKILLID3],
	player[playerInfo.SKILLID4],
	}
	
	local t2 = {
	player[playerInfo.SKILLCD1],
	player[playerInfo.SKILLCD2],
	player[playerInfo.SKILLCD3],
	player[playerInfo.SKILLCD4],
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
	
		local label = item:getChildByTag(cdlabeltag)
		tolua.cast(label, "CCLabelTTF")
		if t[i] ~= 0 then
			label:setString("CD:"..t2[i].."/"..magictable[t[i]][MAGIC_DEF_TABLE.CDROUND])			
		end
	end
end








