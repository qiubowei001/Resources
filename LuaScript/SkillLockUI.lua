--技能解锁界面
SkillLockUI = {}
local p = SkillLockUI;

local bglayer=nil;
local g_StartPosx = 140;
local g_StartPosy = 500;
local gX_Step = 70;
local gY_Step = 60;
local gX_Num = 9;
local tMenuItem = nil
local tLockSpri = nil

local g_coinlabel = nil

function p.LoadUI()
		local scene =Main.GetGameScene();
		bglayer = CCLayer:create()
		tMenuItem = {}
		tLockSpri = {}
		local menu = CCMenu:create()
		menu:setPosition(CCPointMake(g_StartPosx, g_StartPosy))

		local tSkillLock = {}--未解锁技能
		local tSkillLockUnlock = {}--解锁技能
		
		for nNodeid,v in pairs(SkillUpgrade.tSkillNode) do
			table.insert(tSkillLockUnlock,nNodeid)
		end			
		
		--显示
		for index,nNodeid in pairs(tSkillLockUnlock)do
			local X = index%gX_Num
			if X == 0 then
				X = gX_Num
			end
			local Y = math.ceil(index/gX_Num)
			local picpath = SkillUpgrade.GetPicPath(nNodeid)
			local item1 = CCMenuItemImage:create(picpath, picpath)
			--item1:registerScriptTapHandler(p.LearnSkillCallback)
			item1:setPosition(gX_Step*X,-gY_Step*Y)
			menu:addChild(item1)
			tMenuItem[nNodeid] = item1
			if  SkillUpgrade.IfUnLocked(nNodeid) == false then --未解锁
				--local lockedSprite = CCSprite:create("skill/skillLocked.png");
				local lockedSprite = CCMenuItemImage:create("skill/skillLocked.png", "skill/skillLocked.png")
				lockedSprite:setPosition(gX_Step*X,-gY_Step*Y)
				menu:addChild(lockedSprite)
				tLockSpri[nNodeid] = lockedSprite
			end
		end
		
		
		local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
			closeBtn:registerScriptTapHandler(p.closeUICallback)
			closeBtn:setPosition(CCPointMake(680, 100))
		menu:addChild(closeBtn)
		
		local UnlockBtn = CCMenuItemImage:create("UI/Button/Unlock.png", "UI/Button/Unlock.png")
			UnlockBtn:registerScriptTapHandler(p.UnlockUICallback)
			UnlockBtn:setPosition(CCPointMake(680, 0))
		menu:addChild(UnlockBtn)
		
		
		local coinsprite = CCSprite:create("UI/coin.png")
		bglayer:addChild(coinsprite, 2)
		coinsprite:setPosition(40, 580)
		local coinlabel = CCLabelTTF:create("", "Arial", 25)
			coinsprite:addChild(coinlabel)
			coinlabel:setColor(ccc3(255,255,255))
			coinlabel:setPosition(80, 30)
			g_coinlabel = coinlabel
			local coin = dataInit.GetPlayerCoin();
			g_coinlabel:setString(":"..coin) 
							
		bglayer:addChild(menu, 2,1)
		bglayer:setTag(UIdefine.SkillLockUI);
			
		--增加背景
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
	    bglayer:addChild(bgSprite,1)
		bgSprite:setPosition(CCPointMake(480, 320))
		bgSprite:setScale(5);
		
		scene:addChild(bglayer,3)
end



function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.SkillLockUI);
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

	local tnewNodeid = SkillUpgrade.GetRandomSkillIdNotLearned()
	if tnewNodeid == nil then
		return
	end

	--检测水晶数量
	local coin = dataInit.GetPlayerCoin();
	if coin >= 1 then
		coin = coin - 1
		dataInit.SetPlayerCoin(coin)
		g_coinlabel:setString(":"..coin) 	
	else
		return
	end
	
	
	local newNodeid= tnewNodeid[2]
	local lockspr = tLockSpri[newNodeid]
	lockspr:removeFromParentAndCleanup(true);
	
	--储存
	SkillUpgrade.UnlockSkill(newNodeid)
end















