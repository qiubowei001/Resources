--MonsterHandBook 怪物图鉴

MonsterHandBook = {}
local  p = MonsterHandBook;

local winSize = CCDirector:sharedDirector():getWinSize()


local tHandBookInfo = {}

local tHandBookInfoCache = {} --存放信息 --游戏结束后储存回文件中
--[[
	--read
	local  MyTable = {}
	data("1.xml", MyTable)
	cclog("finish")
	
	
	--write
	local	Anim = {1,3,5,6,7,8}--{}
			Anim[1] = {}
			Anim[1].Texture = "data\\Anim3.png"
			Anim[1].Time = 1
			Anim[2] = {}
			Anim[2].Texture = "data\\Anim4.png"
			Anim[2].Time = 2
			Anim.Mode = "aLOOP"
			Anim.AutoStart = true
			data(Anim, "1.xml")	
	--]]

local savepath = "save\\monsterHandbook.xml"
--初始化
function p.Init()
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
		
	--local sDesc = MONSTER_TYPE[nMonsterType]["desc"]
	return nAttIndicator,nHPIndicator,nSpeedIndicator--,sDesc
end

--根据怪物类型显示怪物图鉴
function p.ShowMonsterHandBook(nMonsterType)
	local tmoninfo = p.SearchBookInfoT(nMonsterType)
	
	--已经显示过则跳过
	if tmoninfo ~= nil and tmoninfo.IFSHOWN then
		return
	end
	
	
	--显示
	p.LoadUI(nMonsterType)
	
	
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
	
	--
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

--显示界面
function p.LoadUI(nMonsterType)
	local nAttIndicator,nHPIndicator,nSpeedIndicator  = p.GetHandBookInfo(nMonsterType)
	
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
	bglayer:setPosition(CCPointMake(340, 220))
	bglayer:setScale(0.65);
	
	
	--怪物sprite
	local pmon =  SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(nMonsterType))
	pmon:setScale(4);
	pmon:setPosition(CCPointMake(0, 220))
	bglayer:addChild(pmon,2)	
	
	
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,4)	
	
	CCDirector:sharedDirector():pause()
	
end


function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.MONSTER_HANDBOOK_UI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end

