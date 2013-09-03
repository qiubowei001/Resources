--关卡配置

TimerBuff = {};
local p = TimerBuff;

local TimeBuffBarLabeltag =9999;
local g_TimerBuff = 0;


local TimerId = nil;





function p.GetRatio()
	if g_TimerBuff <100 then
		return 1
	elseif g_TimerBuff <200 then
		return 1.5
	elseif g_TimerBuff <300 then
		return 3
	else 
		return 5
	end
end

function p.SetTimerBuff(nBuff)
	g_TimerBuff = nBuff;
end

function p.GetTimerBuff()
	return g_TimerBuff;
end

function p.TimerBuffTick()
	g_TimerBuff = g_TimerBuff - 1
	if g_TimerBuff < 0 then
		g_TimerBuff = 0
	end
	
	TimeBuffBarLabel:setString("Buff:"..g_TimerBuff.."Ratio:"..p.GetRatio())			
end

function p.LoadUI()
	bglayer = CCLayer:create()
		
	TimeBuffBarLabel = CCLabelTTF:create("", "Arial", 20)
	bglayer:addChild(TimeBuffBarLabel,2)
	TimeBuffBarLabel:setColor(ccc3(255,0,0))
	TimeBuffBarLabel:setPosition(30, 30)
	TimeBuffBarLabel:setTag(TimeBuffBarLabeltag);		

	
    bglayer:setPosition(CCPointMake(380, 25))
	local scene = Main.GetGameScene();
	scene:addChild(bglayer)
	bglayer:setTag(UIdefine.TimeBuffBarUI);
	
	
	--初始化计时器
	TimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(p.TimerBuffTick, 0.1, false)	
end



