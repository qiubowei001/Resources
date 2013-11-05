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
end



function p.LoadUI()
		g_tRandom = SkillUpgrade.GetRandomSkillId()
		
		if table.getn(g_tRandom)==0 then
			return
		end
		
		bglayer = CCLayer:create()
		local menu = CCMenu:create()
		
		for i,v in pairs(g_tRandom) do
			local item1 = CCMenuItemImage:create("skill/skill"..v[2]..".png", "skill/skill"..v[2]..".png")
			item1:registerScriptTapHandler(p.LearnSkillCallback)
			menu:addChild(item1,1,i)
			item1:setPosition(-160+80*i,0)
		end
		
		menu:setPosition(CCPointMake(0, 0))
		bglayer:addChild(menu, 2,1)
		--]]
		bglayer:setTag(UIdefine.SkillUpGradeUI);
		bglayer:setPosition(CCPointMake(0, 0))
		
		
		--���ӱ���
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
		--bgSprite:setPosition(CCPointMake(230, 200))
        bglayer:addChild(bgSprite,1)
		bglayer:setPosition(CCPointMake(230, 200))
		
		
		local scene = Main.GetGameScene();
		scene:addChild(bglayer)	
end






