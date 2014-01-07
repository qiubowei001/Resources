




MissionSelectUI = {}
local p = MissionSelectUI;

local g_bglayer=nil;--背景层
local g_MissionUI = nil;--UI层


local tMissionPortalInfo = 
{
	[1] = {POSITION={50, 500}},
	[2] = {POSITION={150,500}},
	[3] = {POSITION={250,500}},
	[4] = {POSITION={350,500}},
	[5] = {POSITION={450,500}},
}

local g_Chapter = 1;--当前章节

local NextChapterBtn = nil;
local LastChapterBtn = nil;
function p.PortalOnClick(tag,sender)
	
			
	Main.main(tag);
	local winSize = CCDirector:sharedDirector():getWinSize()
	
	
	--删除MISSION select UI
	g_MissionUI:removeFromParentAndCleanup(true);
	
	--[[
	local moveby = CCMoveBy:create(1, ccp(0,-winSize.height))
	
	--渐渐隐藏 删除
	function delete(sender)
		sender:removeFromParentAndCleanup(true);
	end
		
	local actionremove = CCCallFuncN:create(delete)
	local arr = CCArray:create()
	arr:addObject(moveby)
	arr:addObject(actionremove)
	
	local  seq = CCSequence:create(arr)	
	g_bglayer:runAction(seq)--]]
end

function p.RunScene()
	CCDirector:sharedDirector():runWithScene(g_sceneGame)
end


function p.LoadUI()
		g_sceneGame = CCScene:create();
		local scene = g_sceneGame;
		
		-->>>>>>>>>>游戏数据初始化 --这个到时候要放到主界面
		dataInit.InitPlayerSave()
		SkillUpgrade.Init()
		GlobalEvent.InitEventTable();
		---<<<<<<<<<<

		--背景层  --和UI层是分开的
		g_bglayer = p.GetChapterUI(g_Chapter)
		scene:addChild(g_bglayer,UIdefine.BG_LAYER)

		
		--加载UI层
		g_MissionUI = CCLayer:create()
		scene:addChild(g_MissionUI,UIdefine.MissionSelectUI)

		local menuMain = CCMenu:create()
		--menuMain:setPosition(CCPointMake(300, 300))
		g_MissionUI:addChild(menuMain,3)
		--技能解锁界面入口
		local SkilllockBtn = CCMenuItemImage:create("UI/MissionSelect/SkilllockBtn.png","UI/MissionSelect/SkilllockBtn.png")
		SkilllockBtn:registerScriptTapHandler(SkillLockUI.LoadUI)
		menuMain:addChild(SkilllockBtn)
		SkilllockBtn:setPosition(350,200)
		--]]
				
		--上一章节				
		LastChapterBtn = CCMenuItemImage:create("UI/MissionSelect/LastChapterBtn.png","UI/MissionSelect/LastChapterBtn.png")
		LastChapterBtn:registerScriptTapHandler(p.LastChapterBtn)
		menuMain:addChild(LastChapterBtn)
		LastChapterBtn:setPosition(-350,0)
		
		--下一章节
		NextChapterBtn = CCMenuItemImage:create("UI/MissionSelect/NextChapterBtn.png","UI/MissionSelect/NextChapterBtn.png")
		NextChapterBtn:registerScriptTapHandler(p.NextChapterBtn)
		menuMain:addChild(NextChapterBtn)
		NextChapterBtn:setPosition(350,0)
		

		
		--刷新翻页按钮
		p.RefreshBtn();

	
--[[
		local tAttType = 
{
	[1] = ccc3(255,255,255),--白色
[2] = ccc3(0,255,0),--绿色
[3] = ccc3(0,0,255),--蓝色
[4] = ccc3(160,32,240),--紫色
[5] = ccc3(255,255,0),--橙色
[6] = ccc3(255,0,0),--红色

[7] = ccc3(0,0,0),--黑色
--色
--色
--色
}

		--local numbersprite = NumberToPic.GetPicByNumBer(1234567890)
		--numbersprite:setPosition(CCPointMake(200, 120))
		--scene:addChild(numbersprite,99)
		
		
		for i,v in pairs(tAttType) do
		local sprite = CCSprite:create("UI/AttGrade/att.png")
		
        sprite:setPosition(CCPointMake(80*i, 220))
		bglayer:addChild(sprite,5)
		sprite:setColor(v)			
		end
--]]
	return g_sceneGame
end

--上一章节
function p.LastChapterBtn()
	g_Chapter = g_Chapter - 1;
	
	--动画表现时 隐藏按钮
	p.HideBtn()
	
	local lastlayer = p.GetChapterUI(g_Chapter);
	lastlayer:setPosition(-winSize.width , 0)
	
	-->>>>>>>>>>>>>>>动画效果
	--原背景 从右移动到左,然后删除
	function removeLast(sender)
		sender:removeFromParentAndCleanup(true);
	end	

	
	local arr = CCArray:create()	
	local moveby = CCMoveBy:create(1, ccp(winSize.width,0))
	local actionremove = CCCallFuncN:create(removeLast)
	arr:addObject(moveby)
	arr:addObject(actionremove)
	local  seq = CCSequence:create(arr)	
	g_bglayer:runAction(seq)	
	
	
	--新背景 从右移动到左,然后设置为g_bglayer
	function resetGlayer(sender)
		g_bglayer = sender;	
		p.RefreshBtn()
	end
	local arr = CCArray:create()	
	local moveby = CCMoveBy:create(1, ccp(winSize.width,0))
	local actionreset = CCCallFuncN:create(resetGlayer)
	arr:addObject(moveby)
	arr:addObject(actionreset)
	local  seq = CCSequence:create(arr)	
	lastlayer:runAction(seq)
	
	g_sceneGame:addChild(lastlayer)
	--<<<<<<<<<<<<<<<--
end

--下一章节
function p.NextChapterBtn()
	g_Chapter = g_Chapter + 1;
	
	--动画表现时 隐藏按钮
	p.HideBtn()
	
	local nextlayer = p.GetChapterUI(g_Chapter);
	nextlayer:setPosition(winSize.width , 0)
	
	-->>>>>>>>>>>>>>>动画效果
	--原背景 从右移动到左,然后删除
	function removeLast(sender)
		sender:removeFromParentAndCleanup(true);
	end	
	
	--从右移动到左
	local arr = CCArray:create()	
	local moveby = CCMoveBy:create(1, ccp(-winSize.width,0))
	
	local actionremove = CCCallFuncN:create(removeLast)
	arr:addObject(moveby)
	arr:addObject(actionremove)
	local  seq = CCSequence:create(arr)	
	g_bglayer:runAction(seq)	

	
	--新背景 从右移动到左,然后设置为g_bglayer
	function resetGlayer(sender)
		g_bglayer = sender;	
		p.RefreshBtn()
	end
	local arr = CCArray:create()	
	local moveby = CCMoveBy:create(1, ccp(-winSize.width,0))
	local actionreset = CCCallFuncN:create(resetGlayer)
	arr:addObject(moveby)
	arr:addObject(actionreset)
	local  seq = CCSequence:create(arr)	
	nextlayer:runAction(seq)


	g_sceneGame:addChild(nextlayer)
	--<<<<<<<<<<<<<<<--		
end

--显示章节背景和关卡入口
function p.GetChapterUI(nChapter)
	local tmission = mission.GeCHAPTER_TABLEMission(nChapter)
		
	local bg = GameBg.GetBgLayer(CHAPTER_TABLE[nChapter].BgId)
	bg:setPosition(winSize.width / 2 , winSize.height/2)
	
	--加入portal
	nextlayer = CCLayer:create()

	local menu = CCMenu:create()
	menu:setPosition(CCPointMake(0, 0))

	for i,missionid in pairs(tmission) do
		local Portal = CCMenuItemImage:create("UI/MissionSelect/portal.png","UI/MissionSelect/portal.png")
		Portal:registerScriptTapHandler(p.PortalOnClick)
		menu:addChild(Portal,1,missionid)
		tpos = tMissionPortalInfo[i].POSITION
		Portal:setPosition(tpos[1],tpos[2])
	end
	nextlayer:addChild(menu, 2,1)
	nextlayer:addChild(bg)
	
	return nextlayer
end



--刷新翻页按钮
function p.RefreshBtn()
	if g_Chapter <= 1 then
		LastChapterBtn:setVisible(false)
	else
		LastChapterBtn:setVisible(true)	
	end
	
	--是最大章节隐藏按钮
	if g_Chapter >= #CHAPTER_TABLE then
		NextChapterBtn:setVisible(false)
	else
		NextChapterBtn:setVisible(true)
	end			
end

function p.HideBtn()
	LastChapterBtn:setVisible(false)
	NextChapterBtn:setVisible(false)
end



















