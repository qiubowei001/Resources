--GameBg 游戏背景

GameBg = {}
local  p = GameBg;

local winSize = CCDirector:sharedDirector():getWinSize()

--cclog("winSize: %0.2f, %0.2f", winSize.width, winSize.height)
       
--背景初始化函数
function p.InitFuncmap1(resoursepath,bglayer)
	--生成3朵随机放置
	--重复
	function replay(sender)
			local nscale = math.random(4,15)*0.1
			sender:setScale(nscale);
		
			sender:setPosition( -100 ,winSize.height*2/3+math.random(1,winSize.height/3) )
			local moveby = CCMoveBy:create(nscale*12, ccp(winSize.width+200,0))
			local actionreplay = CCCallFuncN:create(replay)
			local arr = CCArray:create()
			arr:addObject(moveby)
			arr:addObject(actionreplay)
			local  seq = CCSequence:create(arr)	
			sender:runAction(seq)
	end
		
	for i=1,3 do
		local cloud =  CCSprite:create(resoursepath.."cloud.png")
		
		local nscale = math.random(4,15)*0.1
		cloud:setScale(nscale);
			
		local xAdj = math.random(1,winSize.width)
		cloud:setPosition( xAdj ,winSize.height*2/3+math.random(1,winSize.height/3) )
		bglayer:addChild(cloud)
		
		
		--设置移动效果
		local moveby = CCMoveBy:create(nscale*12, ccp(winSize.width - xAdj+100,0))
			
		local actionreplay = CCCallFuncN:create(replay)
		local arr = CCArray:create()
		arr:addObject(moveby)
		arr:addObject(actionreplay)
	
		local  seq = CCSequence:create(arr)	
		cloud:runAction(seq)							
	end
end	









local  tNest = 
{
--X,Y,是否已占
{200,500,nil},
{300,300,nil},
{350,510,nil},
{780,220,nil},
{800,400,nil},
}

local map2posHole = {450 ,250} --洞内
local map2posOut ={900 ,900}--洞外
local tMap2PosType = 
{
InHole 		= 1;
Inposition 	= 2;
OutSide 	= 3;
}

local bMap2Funclock = false;
function p.InitFuncmap2(resoursepath,bglayer)
	bMap2Funclock = false;
	
	tNest = 
	{
	--X,Y,是否已占
	{200,500,nil},
	{300,300,nil},
	{350,510,nil},
	{780,220,nil},
	{800,400,nil},
	}

	
	
	
	
	--加几个蝙蝠
	for i=1,5 do
		local batspr = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(9))		
		local random = math.random(1,100);
		
		







	--蝙蝠行为策略
	local function batsprThink(sender)
		--[[if bMap2Funclock then
			--被调用中
		else
			bMap2Funclock = true;
		end--]]
		
		local arr = CCArray:create()
		local nrandom = math.random(1,100);
		cclog("RANDOM:"..nrandom)
		local selfindex = nil

				
		local tPositionBegin = sender.pos 
		
		for i,v in pairs(tNest)do
			if 	v[3]== sender then
				selfindex = i;
			end
		end		
		
		if nrandom <= 25 then
		--飞到其他空点
			--随机取位置
			sender.pos = tMap2PosType.Inposition
			sender:setVisible(true)
			
			--飞走要转0度
			local rotate = CCRotateTo:create(0.2, 0)
			arr:addObject(rotate)
			
			local tRandomPos = {};
			for i,v in pairs(tNest)do
				if v[3]== nil then
					table.insert(tRandomPos,v)
				end
			end
			local tPos = tRandomPos[math.random(1,#tRandomPos)] 
			tPos[3] = sender;
			local actionto = CCMoveTo:create(math.random(70,100)*0.03, ccp(tPos[1]+math.random(-10,10), tPos[2]+math.random(-10,10)))
			local move_ease = CCEaseExponentialInOut:create(actionto)
    
			
			arr:addObject(move_ease)
					
			--飞走要清空标志
			if selfindex ~= nil then
				tNest[selfindex][3] = nil
			end
			
		elseif nrandom <= 50 then
			--飞进洞里
			sender.pos = tMap2PosType.InHole
			--飞走要转0度
			local rotate = CCRotateTo:create(0.2, 0)
			arr:addObject(rotate)
			
			local actionto = CCMoveTo:create(math.random(50,100)*0.02, ccp(map2posHole[1]+math.random(-10,10) ,map2posHole[2]+math.random(-10,10)))
			arr:addObject(actionto)
			
			function hide(sender)
				sender:setVisible(false)
			end

			--飞走要清空标志
			if selfindex ~= nil then
				tNest[selfindex][3] = nil
			end
			
			--进洞FADEOUT 淡出
			if tPositionBegin ~= tMap2PosType.InHole then
				local fadeout = CCFadeOut:create(1)
				arr:addObject(fadeout)
			end
								
			local actionHide = CCCallFuncN:create(hide)
			arr:addObject(actionHide)
		elseif nrandom <= 75 then
		--飞出洞外
			sender.pos = tMap2PosType.OutSide
			--飞走要转0度
			local rotate = CCRotateTo:create(0.2, 0)
			arr:addObject(rotate)
			
			local posx = 0
			local posy = math.random(1,640)
			
-->>>>>>>>>>>获取坐标点			
	local boardW = 960
	local boardH = 640
	local x = 0
	local y = 0
	--local originx,originy = pBrick:getPosition();
	
	local nrandomBoard = math.random(1,4)
	if nrandomBoard ==1 then
		--左边界
		x =  -200
		y =  math.random(1,boardH-1)
	elseif nrandomBoard ==2 then
		--右边
		x =  boardW+200
		y =  math.random(1,boardH-1)		
		
	elseif nrandomBoard ==3 then
		--上
		x =  math.random(1,boardW-1)	
		y =  boardH	+200
		
	else
		--下
		x =  math.random(1,boardW-1)	
		y =  -200		
	end
			
			
--<<<<<<<<<<<<<			
			sender:setVisible(true)
			local actionto = CCMoveTo:create(math.random(50,100)*0.02, ccp(x ,y))
			arr:addObject(actionto)
			
			--飞走要清空标志
			if selfindex ~= nil then
				tNest[selfindex][3] = nil
			end
			
	
		else
			--休息一会
			local actiondelay1 = CCDelayTime:create(math.random(1,2))
			arr:addObject(actiondelay1)	
		end

		--做些效果处理
		--local tPositionBegin = sender.pos 
		local tPositionAfter = sender.pos 
		
		--栖息要倒转 其他情况转回来
		if tPositionAfter == tMap2PosType.Inposition then
			local rotate = CCRotateTo:create(0.2, 180)
			arr:addObject(rotate)
		end
		
		--稍等一会
		local actiondelay = CCDelayTime:create(math.random(2,5))
		arr:addObject(actiondelay)	
		
		local actionreThink = CCCallFuncN:create(batsprThink)
		arr:addObject(actionreThink)		
		local  seq = CCSequence:create(arr)	
		sender:runAction(seq)
		
	
		--出洞FADEIN 淡入
		if tPositionBegin == tMap2PosType.InHole and tPositionAfter ~= tMap2PosType.InHole then
			local fadein = CCFadeIn:create(1)
			sender:runAction(fadein);	
		end		
		
		--OUT 变大
		if tPositionAfter == tMap2PosType.OutSide then
			local scale = CCScaleTo:create(1, 2.5)
			sender:runAction(scale);
		else
			local scale = CCScaleTo:create(1, 1)
			sender:runAction(scale);
		end						
	end			
		
		
		
		
		
	
		
		
		if random <=33 then
		--洞外
			batspr:setPosition(map2posOut[1] ,map2posOut[2] )
			batspr.pos = tMap2PosType.OutSide
		elseif random <= 66 then	
		--洞内
			batspr:setVisible(false)
			batspr:setPosition( map2posHole[1]+math.random(-10,10) ,map2posHole[2]+math.random(-10,10))
			batspr.pos = tMap2PosType.InHole
		else
		--栖息 
			--随机取位置
			local tRandomPos = {};
			for i,v in pairs(tNest)do
				if v[3]== nil then
					table.insert(tRandomPos,v)
				end
			end
			local tPos = tRandomPos[math.random(1,#tRandomPos)]
			batspr:setPosition( tPos[1] ,tPos[2])
			tPos[3] = batspr
			batspr.pos = tMap2PosType.Inposition

			local rotate = CCRotateTo:create(0.2, 180)
			batspr:runAction(rotate)
			
		end
		--local actionreThink = CCCallFuncN:create(batsprThink)
		--batspr:runAction(actionreThink)	
		batsprThink(batspr)
		
		bglayer:addChild(batspr)
	end
		
end	


local tBgInfo = {}
	tBgInfo[1] = {}
	tBgInfo[1]["InitFunc"] = p.InitFuncmap1
	
	tBgInfo[2] = {}
	tBgInfo[2]["InitFunc"] = p.InitFuncmap2

--根据bgid获取背景层
function p.GetBgLayer(nBgId)
	local resoursepath = "scene/map"..nBgId.."/"
	local  bglayer = CCSprite:create(resoursepath.."map.png")
	
	if tBgInfo[nBgId]["InitFunc"] ~= nil then
		tBgInfo[nBgId]["InitFunc"](resoursepath,bglayer)
	end
	
	return bglayer
end