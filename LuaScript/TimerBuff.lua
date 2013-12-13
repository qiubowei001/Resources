--�ؿ�����

TimerBuff = {};
local p = TimerBuff;

local TimeBuffBarLabeltag =9999;
local g_TimerBuff = 0;


local TimerId = nil;


local tGrade = 
{
--	  --buff, RATIO
[1] = {100	,1	},
[2] = {200	,1.5},
[3] = {300	,3	},
[4] = {999	,5	}
--]]
--[[
[1] = {50	,1	},
[2] = {100	,1.5},
[3] = {150	,3	},
[4] = {999	,5	}
--]]

}


local gRatio,gGrade = 1,1


--���� ratio
function p.GetRatio()
	return gRatio
end

--���� gGrade
function p.GetGrade()
	return gGrade
end

--���� ratio,grade
function p.doCalculate()
	for grade,v in pairs(tGrade) do
		if g_TimerBuff < v[1] then
			return v[2],grade
		end
	end
end

function p.SetTimerBuff(nBuff)
	if nBuff >= 400 then
		g_TimerBuff = 400
	else
		g_TimerBuff = nBuff;
	end
	
end

function p.GetTimerBuff()
	return g_TimerBuff;
end

function p.TimerBuffTick()
	local step = 0;
	g_TimerBuff = g_TimerBuff - gRatio
	if g_TimerBuff < 0 then
		g_TimerBuff = 0
	end
	--���¼���
	gRatio,gGrade = p.doCalculate()
	TimeBuffBarLabel:setString("Buff:"..math.floor(g_TimerBuff).."Ratio:"..gRatio)			
end

function p.LoadUI()
	local bglayer = CCLayer:create()
	
	--��ʼ��
	gRatio,gGrade = 1,1

	
	TimeBuffBarLabel = CCLabelTTF:create("", "Arial", 20)
	bglayer:addChild(TimeBuffBarLabel,2)
	TimeBuffBarLabel:setColor(ccc3(255,0,0))
	TimeBuffBarLabel:setPosition(30, 30)
	TimeBuffBarLabel:setTag(TimeBuffBarLabeltag);		

	
    bglayer:setPosition(CCPointMake(700, 50))
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,2,UIdefine.TimeBuffBarUI)
	
	
	--��ʼ����ʱ��
	TimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(p.TimerBuffTick, 0.1, false)	
end

function p.RemoveTimer()
	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(TimerId)
end


