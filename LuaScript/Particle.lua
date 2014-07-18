--粒子系统
Particle = {};
local p = Particle;

local brickWidth = brickInfo.brickWidth ;
local brickHeight = brickInfo.brickHeight;

local gPlayEffNum = 0;
local gMainHitEff  = nil;
local gMainHitGrade = nil;

local tParticleType = 
{
	poison = 1;
	star = 2;
	buff = 3;
	ice = 4;
	firewall = 5;
	shineSporn = 6;
	suckblood = 7;
	recovery = 8;
	suckenergy = 9;
	fog		= 10;
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
	if gMainHitEff ~= nil then
		--gMainHitEff:removeFromParentAndCleanup(true);
		gMainHitEff  = nil;
	end
	
	gMainHitGrade = Combo.GetRatio();
end
--制造一个emiter
function p.BuildParticle(sEffName)
	emitter = CCParticleSystemQuad:new()
	emitter:autorelease()
	local filename = "Particle/"..sEffName..".plist"
	emitter:initWithFile(filename)
	emitter:setAutoRemoveOnFinish(true)
	return emitter
end

--在BRICK上增加特效
function p.AddParticleEffToBrick(pBrick,sEffName)
	--如果已经有此特效 返回
	local id = brick.ParticleTag + tParticleType[sEffName]
	
	local emitter = pBrick:getChildByTag(id); 
	if emitter ~= nil then
		return
	end
	
	emitter = p.BuildParticle(sEffName);
	emitter:setPositionType(kCCPositionTypeGrouped)
	emitter:setPosition(brickWidth/2, brickHeight/2);
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
	layerMain:addChild(emitter, 9001)
	return emitter
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




--移动粒子
function p.MoveParticleTo(emitter,func)
	
	local arr = CCArray:create()	

	if func ~= nil then
		local actionHit = CCCallFuncN:create(func)
		arr:addObject(actionHit)
	end
	
	local tox,toy = 500,300 --brick.GetPosByBrick(pbrick)

	local posx,posy = emitter:getPosition();

	local l = (posx-tox)*(posx-tox) + (posy-toy)*(posy-toy)
	local t = math.sqrt(l) / 800;

			
	local actionto = CCMoveTo:create(t, ccp(tox, toy))
	arr:addObject(actionto)
			
	if func ~= nil then
		local actionHit = CCCallFuncN:create(func)
		arr:addObject(actionHit)
	end

	function calltest(sender)
		sender:removeFromParentAndCleanup(true);
	end
		
	local actionremove = CCCallFuncN:create(calltest)
	arr:addObject(actionremove)
	
	local  seq = CCSequence:create(arr)	
	emitter:runAction(seq)
	--layerMain:addChild(emitter)
end



local tHitEffColor = 
{
	[1] = ccc4f( 1, 1, 1,1),
	[2] = ccc4f( 1, 1, 1,1),
	[3] = ccc4f( 1, 1, 1,1),
	[4] = ccc4f( 0, 1, 0,1),
	[5] = ccc4f( 0, 1, 0,1),
	[6] = ccc4f( 0, 0.5, 1,1),
	[7] = ccc4f( 0, 0.5, 1,1),
	[8] = ccc4f( 1, 1, 0,1),
	
}

--鼠标点击光效 1~4种光效
function p.BuildHitParticle(grade)
	if grade>=1 and grade <= 8 then
		local eff = p.BuildParticle("HitEff1")
		eff:setStartColor(tHitEffColor[grade])
		eff:setEndColor(tHitEffColor[grade])
		return eff
	end
end

function p.setHitEffGrade(grade)
	
	if grade>=1 and grade <= 8 then
		gMainHitEff:setStartColor(tHitEffColor[grade])
		gMainHitEff:setEndColor(tHitEffColor[grade])
	end
end

function p.SetMainHitEff(posx,posy)
	local effGrade = Combo.GetGrade()
	--光效不存在
	if gMainHitEff == nil then
		local hitEff = Particle.BuildHitParticle(effGrade)
		hitEff:setPosition(posx, posy);
		layerMain:addChild(hitEff, 9000,UIdefine.HitEffect)
		gMainHitGrade = effGrade;
		gMainHitEff = hitEff;
		return;
	end	
	
	gMainHitGrade = effGrade;
	--光效等级相同,则改变位置
	Particle.setHitEffGrade(effGrade)
	gMainHitEff:setPosition(posx, posy);
end



--删除点击光效
function p.DelMainHitEff()

	if gMainHitEff ~= nil then
		gMainHitEff:setStartColor(ccc4f(0, 0, 0, 0))
		gMainHitEff:setEndColor(ccc4f(0, 0, 0, 0))
	end--]]
end



