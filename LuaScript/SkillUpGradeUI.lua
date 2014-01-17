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

	--�رս��� 
	local layer = p.GetParent()
	local scene = Main.GetGameScene();
	scene:removeChild(layer, true)
	
	--��ʾ����
	SkillBar.refreshSkill()
	
	--�ָ�
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
		
		
		--���ӱ���
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
		bglayer:addChild(bgSprite,1)
		
		
		local scene = Main.GetGameScene();
		scene:addChild(bglayer,999,UIdefine.SkillUpGradeUI)	
		
		--���Ә��}
		local titleSprite = CCSprite:create("UI/font/chooseSkill.png")
		titleSprite:setPosition(CCPointMake(5, 210))
		bglayer:addChild(titleSprite,2)
		
	
	-->>>>>>>>>>>>>>>����Ч��	
	function pause()
		Main.EnableTouch(true)--�򿪴���
		CCDirector:sharedDirector():pause()
	end	
	--����Ʈ��
	local arr = CCArray:create()	
	bglayer:setPosition(480 , winSize.height+300)
	local moveby = CCMoveBy:create(1, ccp(0,-winSize.height))
	local actiontoease =  CCEaseBounceOut:create(moveby)	
	
	local actionremove = CCCallFuncN:create(pause)
	arr:addObject(actiontoease)
	arr:addObject(actionremove)
	
	local  seq = CCSequence:create(arr)	
	bglayer:runAction(seq)	

	Main.EnableTouch(false)--��ϴ���
	--<<<<<<<<<<<<<<<--
end






