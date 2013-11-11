SkillBar = {}

local p = SkillBar;
local glayerMenu = nil;


local  cdlabeltag = 9999;

local g_tMagic = {}




function p.Init(menuCallbackOpenPopup)
		g_tMagic = {}


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
	if #g_tMagic >= nTag then
		return g_tMagic[nTag]
	end
end

function p.refreshSkill()
	local tPlayerSkill = player.Skill

	local menu = glayerMenu:getChildByTag(1)
	tolua.cast(menu, "CCMenu")
	
	local tPic = {}
	g_tMagic = {}
	
	for i,v in pairs(tPlayerSkill) do
		local skillid = v[#v]
		local magicid = SkillUpgrade.GetMagicIdBySkillId(skillid)
		if magicid ~= nil then
				table.insert(g_tMagic,magicid)
				local picpath = SkillUpgrade.GetPicPath(skillid)
				table.insert(tPic,picpath)
		end
	end
	
	for i,v in pairs(tPic) do
		local textureSkill = CCTextureCache:sharedTextureCache():addImage(v)	
		local rect = CCRectMake(0, 0, 50, 59)
		local frame0 = CCSpriteFrame:createWithTexture(textureSkill, rect)
		
		local item = menu:getChildByTag(i)
		tolua.cast(item, "CCMenuItemImage")
		item:setNormalSpriteFrame(frame0)
		item:setSelectedSpriteFrame(frame0)
	
		local label = item:getChildByTag(cdlabeltag)
		tolua.cast(label, "CCLabelTTF")
		label:setString("CD:"..player.MagicCD[g_tMagic[i]].."/"..magictable[g_tMagic[i]][MAGIC_DEF_TABLE.CDROUND])			
	end
end








