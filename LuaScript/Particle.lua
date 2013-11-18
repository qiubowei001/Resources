--粒子系统
Particle = {};
local p = Particle;

local brickWidth = brickInfo.brickWidth ;
local brickHeight = brickInfo.brickHeight;

local gPlayEffNum = 0;

local tParticleType = 
{
	poison = 1;
	star = 2;
}


--设置
function p.SetPlayEff(bPlay)
	if bPlay then
		gPlayEffNum = gPlayEffNum +1
	elseif gPlayEffNum > 0 then
		gPlayEffNum = gPlayEffNum -1
	end	
end


function p.IfIsPlayingEff()
	if  gPlayEffNum >0 then
		return true
	else
		return false
	end
end

function p.Init()
	gPlayEffNum = 0;
end
--制造一个emiter
function p.BuildParticle(sEffName)
	emitter = CCParticleSystemQuad:new()
	emitter:autorelease()
	local filename = "Particle/"..sEffName..".plist"
	emitter:initWithFile(filename)
	return emitter
end

--在BRICK上增加特效
function p.AddParticleEffToBrick(pBrick,sEffName)
	local emitter = p.BuildParticle(sEffName);
	emitter:setPositionType(kCCPositionTypeGrouped)
	emitter:setPosition(brickWidth/2, brickHeight/2);
	local id = brick.ParticleTag + tParticleType[sEffName]
	pBrick:addChild(emitter, 10,id)
end

--删除Brick上特效
function p.RemoveParticleEffFromBrick(pBrick,sEffName)
	local id = brick.ParticleTag + tParticleType[sEffName]
	local emitter = pBrick:getChildByTag(id);  
	if emitter ~= nil then
		emitter:removeFromParentAndCleanup(true);
	end
end

--在BRICK所在世界坐标上增加特效
function p.AddParticleEffToWorld(pBrick,sEffName)
	local emitter = p.BuildParticle(sEffName);
	local posx,posy = brick.GetPosByBrick(pBrick)
			
	emitter:setPosition(posx, posy);		
	layerMain:addChild(emitter, 9000)
end


--特效链  输入: 1 brick列表  2 效果名  3 碰撞函数
function p.AddParticleEffToLine(tBrick,sEffName,func)
	
	Particle.SetPlayEff(true)
	
	
	local emitter = p.BuildParticle(sEffName);
	local pbrick = tBrick[1]
	local posx,posy = brick.GetPosByBrick(pbrick)
	emitter:setPosition(posx, posy);		
	
	local arr = CCArray:create()	
	if func ~= nil then
		local actionHit = CCCallFuncN:create(func)
		arr:addObject(actionHit)
	end
	
	local lastx,lasty = brick.GetPosByBrick(pbrick)
	for i,pbrick in pairs(tBrick) do
		if i ~= 1 then
			local posx,posy = brick.GetPosByBrick(pbrick)
			--
			local l = (posx-lastx)*(posx-lastx) + (posy-lasty)*(posy-lasty)
			local t = math.sqrt(l) / 800;
			--]]
			
			local actionto = CCMoveTo:create(t, ccp(posx, posy))
			arr:addObject(actionto)
			
			if func ~= nil then
				local actionHit = CCCallFuncN:create(func)
				arr:addObject(actionHit)
			end
			
			local lastPosx,lastPosY = posx,posy
		end
	end
	
	function calltest(sender)
		sender:removeFromParentAndCleanup(true);
		Particle.SetPlayEff(false)
	end
		
	local actionremove = CCCallFuncN:create(calltest)
	arr:addObject(actionremove)		
	
	local  seq = CCSequence:create(arr)	
	emitter:runAction(seq)
	layerMain:addChild(emitter, 10)
	
	
end










