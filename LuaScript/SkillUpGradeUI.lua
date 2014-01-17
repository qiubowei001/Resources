SkillUpGradeUI = {}

local p = SkillUpGradeUI;

local g_tRandom = {}
local grandomskill1,grandomskill2,grandomskill3 = 0,0,0;

function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.SkillUpGradeUI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end

function p.LearnSkillCallback(tag,sender)
	local skillRoot,Skillid = g_tRandom[tag][1],g_tRandom[tag][2]
	
	player.AddNewSkill(skillRoot,Skillid);

	--关闭界面 
	local layer = p.GetParent()
	local scene = Main.GetGameScene();
	scene:removeChild(layer, true)
	
	--显示技能
	SkillBar.refreshSkill()
	
	--恢复
	if CCDirector:sharedDirector():isPaused() then
		CCDirector:sharedDirector():resume()
    end	  --]] 
end



function p.LoadUI()
		g_tRandom = SkillUpgrade.GetRandomSkillId()
		
		if table.getn(g_tRandom)==0 then
			return
		end
		
		bglayer = CCLayer:create()
		local menu = CCMenu:create()
		
		for i,v in pairs(g_tRandom) do
			local picpath = SkillUpgrade.GetPicPath(v[2])
			local item1 = CCMenuItemImage:create(picpath, picpath)
			item1:registerScriptTapHandler(p.LearnSkillCallback)
			menu:addChild(item1,1,i)
			item1:setPosition(-160+80*i,0)
		end
		
		menu:setPosition(CCPointMake(0, 0))
		bglayer:addChild(menu, 2,1)
		--]]
		
		
		--增加背景
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
		bglayer:addChild(bgSprite,1)
		
		
		local scene = Main.GetGameScene();
		scene:addChild(bglayer,999,UIdefine.SkillUpGradeUI)	
		
		--增加標題
		local titleSprite = CCSprite:create("UI/font/chooseSkill.png")
		titleSprite:setPosition(CCPointMake(5, 210))
		bglayer:addChild(titleSprite,2)
		
	
	-->>>>>>>>>>>>>>>动画效果	
	function pause()
		Main.EnableTouch(true)--打开触摸
		CCDirector:sharedDirector():pause()
	end	
	--向下飘入
	local arr = CCArray:create()	
	bglayer:setPosition(480 , winSize.height+300)
	local moveby = CCMoveBy:create(1, ccp(0,-winSize.height))
	local actiontoease =  CCEaseBounceOut:create(moveby)	
	
	local actionremove = CCCallFuncN:create(pause)
	arr:addObject(actiontoease)
	arr:addObject(actionremove)
	
	local  seq = CCSequence:create(arr)	
	bglayer:runAction(seq)	

	Main.EnableTouch(false)--阻断触摸
	--<<<<<<<<<<<<<<<--
end






