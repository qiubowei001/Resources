SkillUpGradeUI = {}

local p = SkillUpGradeUI;


local grandomskill1,grandomskill2,grandomskill3 = 0,0,0;

function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.SkillUpGradeUI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end

function p.LearnSkillCallback(tag,sender)
	local learningskillid = 0
	if tag == 1 then
		learningskillid = grandomskill1
	elseif tag == 2 then
		learningskillid = grandomskill2
	else
		learningskillid = grandomskill3
	end
	
	player[playerInfo.SKILLID1] = learningskillid;
	
	--关闭界面 
	local layer = p.GetParent()
	local scene = Main.GetGameScene();
	scene:removeChild(layer, true)
	
	--显示技能
	SkillBar.refreshSkill()
	
end



--随机获取3个玩家可学习技能
function p.GetRandomSkillId()
	local tPlayerSkill = 
	{
	player[playerInfo.SKILLID1],
	player[playerInfo.SKILLID2],
	player[playerInfo.SKILLID3],
	player[playerInfo.SKILLID4],
	}
	
	local tPlayerSkillFilt = {}
	
	for i,v in pairs(tPlayerSkill) do
		if v ~= 0 then
			table.insert(tPlayerSkillFilt,v)
		end
	end

	--排序(从小到大)
	table.sort(tPlayerSkillFilt,function(a,b) return a>b end)
	
	local tTmp = {}
	for i=1,14 do
		tTmp[i] = i 
	end
	
	--删除已学技能
	for i,v in pairs(tPlayerSkillFilt) do
		table.remove(tTmp,v)
	end
	
	
	local randomSkillInd1 = math.random(1,#tTmp)
	local randomSkill1 = tTmp[randomSkillInd1]
	table.remove(tTmp,randomSkillInd1)
	
	local randomSkillInd2 = math.random(1,#tTmp)
	local randomSkill2 = tTmp[randomSkillInd2]
	table.remove(tTmp,randomSkillInd2)
	
	local randomSkillInd3 = math.random(1,#tTmp)
	local randomSkill3 = tTmp[randomSkillInd3]
	table.remove(tTmp,randomSkillInd3)
	
	return randomSkill1,randomSkill2,randomSkill3
end




function p.LoadUI()
		
		grandomskill1,grandomskill2,grandomskill3 = p.GetRandomSkillId()
		
        bglayer = CCLayer:create()
		
		
		-- menu
		local item1 = CCMenuItemImage:create("skill/skill"..grandomskill1..".png", "skill/skill"..grandomskill1..".png")
		local item2 = CCMenuItemImage:create("skill/skill"..grandomskill2..".png", "skill/skill"..grandomskill2..".png")
    	local item3 = CCMenuItemImage:create("skill/skill"..grandomskill3..".png", "skill/skill"..grandomskill3..".png")
		--local item4 = CCMenuItemImage:create("skill/skillNone.png", "skill/skillNone.png")
    	
    	item1:registerScriptTapHandler(p.LearnSkillCallback)
    	item2:registerScriptTapHandler(p.LearnSkillCallback)
    	item3:registerScriptTapHandler(p.LearnSkillCallback)
		--item4:registerScriptTapHandler(p.LearnSkillCallback)

		local menu = CCMenu:create()
		menu:addChild(item1,1,1)
		menu:addChild(item2,1,2)
		menu:addChild(item3,1,3)
		--menu:addChild(item4,1,4)
		
		menu:setPosition(CCPointMake(0, 0))
		item1:setPosition(-80,0)
		item2:setPosition(0,0)
		item3:setPosition(80,0)
		--item4:setPosition(240,0)
	
		bglayer:addChild(menu, 2,1)
		--]]
		bglayer:setTag(UIdefine.SkillUpGradeUI);
		bglayer:setPosition(CCPointMake(0, 0))
		
		
		--增加背景
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
		--bgSprite:setPosition(CCPointMake(230, 200))
        bglayer:addChild(bgSprite,1)
		bglayer:setPosition(CCPointMake(230, 200))
		
		
		local scene = Main.GetGameScene();
		
		scene:addChild(bglayer)	
end






