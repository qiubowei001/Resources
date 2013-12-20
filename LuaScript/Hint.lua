--文字提示
Hint = {}

local p=Hint;

p.tHintType = 
{	
	--图片路径
	noEnergy = { "UI/font/noEnergy.png"};		--没有能量
	LowHp = { "UI/font/LowHp.png"};				--没有血
	LowEnergy = { "UI/font/lowEnergy.png"};		--能量太低
	
	criticalUp = { "UI/font/criticalUp.png"};		--暴击增加
	criticalDown = { "UI/font/criticalDown.png"};	--暴击减少
	dodgeUp = { "UI/font/dodgeUp.png"};				--闪避增加
	dodgedown = { "UI/font/dodgedown.png"};			--闪避减少
	
	powerup = { "UI/font/powerup.png"};				--攻击增加
	powerdown = {"UI/font/powerdown.png"};			--攻击减少
	

	
}


local winSize = CCDirector:sharedDirector():getWinSize()


local tHintTable = {} --输出队列
local g_hinttimerid = nil
local g_tick	= 0;

--改成队列式显示
function p.TimerShowHint()
	--如果还在播放上一个 则返回
	if g_tick > 0 then
		g_tick = g_tick - 1
		return
	end	
	
	if #tHintTable == 0 then
		return
	end
	
	local tHintType = tHintTable[1]
	table.remove(tHintTable,1)
	g_tick = 8
	
	local path = tHintType[1]	
	local sprite = CCSprite:create(path)
	
	sprite:setPosition(CCPointMake(winSize.width *0.5 , winSize.height *0.6))
	
	local scene = Main.GetGameScene();
	scene:addChild(sprite,100)	
	
	--动画效果
	--删除
	function delete(sender)
		sender:removeFromParentAndCleanup(true);
	end
		
	local arr = CCArray:create()
	
	local scaleact = CCScaleTo:create(0.1, 2.5)
	local scaleact2 = CCScaleTo:create(0.2, 1)
	arr:addObject(scaleact)
	arr:addObject(scaleact2)

	--渐渐消失
	local opacity = CCFadeOut:create(1.5)
	local actionremove = CCCallFuncN:create(delete)

	arr:addObject(opacity)
	arr:addObject(actionremove)
	local  seq = CCSequence:create(arr)	
	sprite:runAction(seq)
end


function p.ShowHint(tHintType)
	table.insert(tHintTable,tHintType)
end

function p.Init()
	local tHintTable = {} --输出队列
	g_tick = 0
	g_hinttimerid = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(p.TimerShowHint, 0.2, false)		
end

function p.GetTimerId()
	return g_hinttimerid	
end














