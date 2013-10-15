GameOverUI = {}

local p = GameOverUI;
local glayer = nil;



function p.LoadUI()
        --[[
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
		glayerMenu:setPosition(10, 230)
	--]]
		
		glayer = CCLayer:create()
		
		--‘›Õ£”Œœ∑
		
        return glayerMenu
end






