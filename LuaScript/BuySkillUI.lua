--技能解锁界面
BuySkillUI = {}
local p = BuySkillUI;

local bglayer=nil;
local g_StartPosx = 140;
local g_StartPosy = 500;
local gX_Step = 70;
local gY_Step = 60;
local gX_Num = 9;

function p.LoadUI()
		local scene =Main.GetGameScene();
		bglayer = CCLayer:create()

		local menu = CCMenu:create()
		menu:setPosition(CCPointMake(g_StartPosx, g_StartPosy))
		
		local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
			closeBtn:registerScriptTapHandler(p.closeUICallback)
			closeBtn:setPosition(CCPointMake(680, 100))
		menu:addChild(closeBtn)
		
		local UnlockBtn = CCMenuItemImage:create("UI/Button/Unlock.png", "UI/Button/Unlock.png")
			UnlockBtn:registerScriptTapHandler(p.UnlockUICallback)
			UnlockBtn:setPosition(CCPointMake(680, 20))
		menu:addChild(UnlockBtn)
				
		
		bglayer:addChild(menu, 2,1)
		bglayer:setTag(UIdefine.BuySkillUI);
			
		--增加背景
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
	    bglayer:addChild(bgSprite,1)
		bgSprite:setPosition(CCPointMake(480, 320))
		bgSprite:setScale(5);
		
		scene:addChild(bglayer,3)
end



function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.BuySkillUI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end

function p.closeUICallback(tag,sender)
	--关闭界面 
	local layer = p.GetParent()
	local scene = Main.GetGameScene();
	scene:removeChild(layer, true) 
end

--解锁新技能界面
function p.UnlockUICallback(tag,sender)
	
end

