--MonsterHandBook 怪物图鉴

MonsterHandBook = {}
local  p = MonsterHandBook;

local winSize = CCDirector:sharedDirector():getWinSize()


local tHandBookInfo = {}

local tHandBookInfoCache = {} --存放信息 --游戏结束后储存回文件中
local savepath = "save\\monsterHandbook.xml"

local gTimerId = nil;--定时检测
local tShowUIArray = {}
local g_bIfshowUI = false;--是否正在顯示UI

--初始化
function p.Init()
	g_bIfshowUI = false;
	tShowUIArray = {}
	--开启检测定时器
	gTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(p.LoadUI, 1, false)	
	
	--tHandBookInfoCache[1] = {MONID = XX IFSHOWN = true}
	tHandBookInfoCache = {}	
	
	--读取怪物图鉴信息
	data(savepath, tHandBookInfoCache)
end	

--根据类型获取怪物图鉴信息
--返回tRet = {攻击指数,血量指数,速度指数,怪物描述 }
--指数: 1 weak 2normal 3strong
function p.GetAttIndicator(nAttGrow)
	if nAttGrow <= 0.5	then
		return 1
	elseif 	nAttGrow <= 0.9 then
		return 2
	else
		return 3
	end
end

function p.GetHPIndicator(nHPGrow)
	if nHPGrow <= 1 then
		return 1
	elseif 	nHPGrow <= 1.9 then
		return 2
	else
		return 3
	end	
end

function p.GetSpeedIndicator(nCDGrow)
	if nCDGrow <= -1.5 then
		return 3
	elseif 	nCDGrow <= -1.1 then
		return 2
	else
		return 1
	end
end

function p.GetHandBookInfo(nMonsterType)
	
	local nAttIndicator = p.GetAttIndicator(MONSTER_TYPE[nMonsterType]["ATTGrow"])
	local nHPIndicator = p.GetHPIndicator(MONSTER_TYPE[nMonsterType]["HPGrow"])
	local nSpeedIndicator = p.GetSpeedIndicator(MONSTER_TYPE[nMonsterType]["CDGrow"])
		
	local sDesc = MONSTER_TYPE[nMonsterType]["desc"]
	return nAttIndicator,nHPIndicator,nSpeedIndicator,sDesc
end

--根据怪物类型显示怪物图鉴
function p.ShowMonsterHandBook(nMonsterType)
	local tmoninfo = p.SearchBookInfoT(nMonsterType)
	
	--已经显示过则跳过
	if tmoninfo ~= nil and tmoninfo.IFSHOWN then
		return
	end
	
	
	--显示 插入隊列中
	--p.LoadUI(nMonsterType)
	p.InsertArrayShow(nMonsterType)
	
	if tmoninfo == nil then
		--无值则插入
		tmoninfo = {MONID = nMonsterType ,IFSHOWN = true}
		table.insert(tHandBookInfoCache,tmoninfo);
	else	
		--有值则修改属性
		tmoninfo.IFSHOWN = true;
	end
	
	
	
	--重新写入
	--data(tHandBookInfoCache, savepath)
end


function p.SearchBookInfoT(nMonsterType)
	for i,v in pairs(tHandBookInfoCache)do
		if nMonsterType == v.MONID then
			return v;
		end
	end
	
	--从未显示
	return nil
end	

function p.closeUICallback(tag,sender)
	
	--关闭界面 
	local layer = p.GetParent()
	local scene = Main.GetGameScene();
	scene:removeChild(layer, true)
	
	g_bIfshowUI = false;
	
	if CCDirector:sharedDirector():isPaused() then
		CCDirector:sharedDirector():resume()
    end	  --]] 
	
end

--各属性坐标
local tPositionAttribute = {}
							--position起点
	tPositionAttribute[1] = {{-100,-180},"UI/Handbook/sword.png"}
	tPositionAttribute[2] = {{-100,-290},"UI/Handbook/heart.png"}
	tPositionAttribute[3] = {{-100,-400},"UI/Handbook/shoe.png"}

	
local tJiangeStep = 100 --每个图标间隔距离
local test = true
--显示界面
function p.LoadUI()
	--測試
	if test then
		return
	end	
		
	--隊列為空返回
	if #tShowUIArray <= 0 then
		return
	end
	
	--正在顯示 返回
	if g_bIfshowUI then
		return 
	end
	
	--取出第一個TYPE來顯示 然後刪除
	local nMonsterType = tShowUIArray[1]
	table.remove(tShowUIArray,1);
	g_bIfshowUI = true;
	
	local nAttIndicator,nHPIndicator,nSpeedIndicator,sDesc  = p.GetHandBookInfo(nMonsterType)
	
	--暂停游戏

	bglayer = CCLayer:create()

	local menu = CCMenu:create()


	local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
		closeBtn:registerScriptTapHandler(p.closeUICallback)
		closeBtn:setPosition(300,400)
		
	menu:addChild(closeBtn)
	menu:setPosition(CCPointMake(0, 0))
	bglayer:addChild(menu, 2,99)



	bglayer:setTag(UIdefine.MONSTER_HANDBOOK_UI);
	
	local t = {nAttIndicator,nHPIndicator,nSpeedIndicator}
	
	for i,indicator in pairs(t) do
		local tPosInfo = tPositionAttribute[i]
	
		for j=1,indicator do
			local tpos = tPosInfo[1]
			local posx = tpos[1] + tJiangeStep*(j-1)
			local posy = tpos[2]
			local pICON = CCSprite:create(tPosInfo[2])
			pICON:setPosition(CCPointMake(posx,posy))
			bglayer:addChild(pICON, 2)
		end
	end		
	
	--增加背景 
	local bgSprite = CCSprite:create("UI/Handbook/monsterhandbook.png")
	--bgSprite:setScale(1.5);
    bglayer:addChild(bgSprite,1)
	bglayer:setScale(0.65);
	
	
	--怪物sprite
	local pmon =  SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(nMonsterType))
	pmon:setScale(4);
	pmon:setPosition(CCPointMake(0, 220))
	bglayer:addChild(pmon,2)	
	
	
	--怪物描述
	local descLabel = CCLabelTTF:create(sDesc, "Arial", 35)
	bglayer:addChild(descLabel,5)
	descLabel:setColor(ccc3(255,255,255))
	descLabel:setPosition(CCPointMake(10, -40))
		
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,4)	
	
	
	-->>>>>>>>>>>>>>>动画效果	
	function pause()
		Main.EnableTouch(true)--打开触摸
		CCDirector:sharedDirector():pause()
	end	
	--向下飘入
	local arr = CCArray:create()	
	bglayer:setPosition(340 , winSize.height+220)
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


function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.MONSTER_HANDBOOK_UI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end


--插入顯示隊列
function p.InsertArrayShow(nMonsterType)
	table.insert(tShowUIArray,nMonsterType)	
end


















