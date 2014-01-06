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


local tBgInfo = {}
	tBgInfo[1] = {}
	tBgInfo[1]["InitFunc"] = p.InitFuncmap1
	
	tBgInfo[2] = {}
	tBgInfo[2]["InitFunc"] = p.InitFuncmap1

--根据bgid获取背景层
function p.GetBgLayer(nBgId)
	local resoursepath = "scene/map"..nBgId.."/"
	local  bglayer = CCSprite:create(resoursepath.."map.png")
	
	if tBgInfo[1]["InitFunc"] ~= nil then
		tBgInfo[1]["InitFunc"](resoursepath,bglayer)
	end
	
	return bglayer
end