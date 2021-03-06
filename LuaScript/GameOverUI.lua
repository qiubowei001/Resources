GameOverUI = {}

local p = GameOverUI;
local glayer = nil;
local winSize = CCDirector:sharedDirector():getWinSize()
local gh = winSize.height
local gw = winSize.width

local tFailTypePic = {} 
	tFailTypePic[1] = "UI/Bg/fail.png"
	tFailTypePic[2] = "UI/Bg/fail2.png"
	tFailTypePic[3] = "UI/Bg/win.png"


function p.LoadUI(ntype)
		--暂停计时器
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(Main.GetBrickFallTimerId())
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(Main.GetMonsterCDTimerId())
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(player.GetEnergyRecoveryTimer())
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(Hint.GetTimerId())
		
		Combo.RemoveTimer();
		
		glayer = CCLayer:create()

		cclog(" gh"..gh.." gw "..gw)
		
		--通关处理
		if ntype == 3 then
			MissionSelectUI.PassMission()
		end
		
		--增加背景
		local path = tFailTypePic[ntype]
		local bgSprite = CCSprite:create(path)
        glayer:addChild(bgSprite,1)
		bgSprite:setPosition(CCPointMake(gw/2,gh/2))
		
		--返回菜单按钮
		-- menu
		local BackBtn = CCMenuItemImage:create("UI/Button/BACK.png", "UI/Button/BACK.png")
		BackBtn:registerScriptTapHandler(p.BackToMission)
    	local menu = CCMenu:create()
		menu:addChild(BackBtn,1,1)
		
		glayer:addChild(menu,99,2)
		
		
		local scene = CCScene:create()
        
        scene:addChild(glayer)
		scene = CCTransitionFlipY:create(1, scene, kCCTransitionOrientationUpOver)
		
        CCDirector:sharedDirector():replaceScene( scene )
	    --CCDirector:sharedDirector():replaceScene(scene)
		--scene = Main.GetGameScene();
end

function p.BackToMission(tag,sender)
	local gamescene = MissionSelectUI.LoadUI();
	gamescene =CCTransitionFlipY:create(1, gamescene, kCCTransitionOrientationUpOver)
	CCDirector:sharedDirector():replaceScene(gamescene)
end



























