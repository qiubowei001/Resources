--����

Combo = {};
local p = Combo;

local ComboLabelTag =9999;
local g_Combo = 0;
local gTimeLeft = 0;
local m_ComboTimeReset = 30 --COMBOά��ʱ�� /0.1��

local TimerId = nil;


local tGrade = 
{
--	  --buff, RATIO
[1] = {3	,1	},
[2] = {5	,1.5},
[3] = {8	,3	},
[4] = {12	,5	}
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
		if g_Combo < v[1] then
			return v[2],grade
		end
	end
end


function p.AddCombo()
	g_Combo = g_Combo + 1
	gTimeLeft =  m_ComboTimeReset
end

function p.ComboTick()
	local step = 0;
	gTimeLeft = gTimeLeft - 1
	if gTimeLeft < 0 then
		gTimeLeft = 0
		g_Combo = 0
	end
	--���¼���
	gRatio,gGrade = p.doCalculate()
	TimeBuffBarLabel:setString("combo:"..g_Combo.."TimeLeft:"..gTimeLeft)			
end

function p.LoadUI()
	local bglayer = CCLayer:create()
	
	--��ʼ��
	gRatio,gGrade = 1,1

	
	TimeBuffBarLabel = CCLabelTTF:create("", "Arial", 20)
	bglayer:addChild(TimeBuffBarLabel,2)
	TimeBuffBarLabel:setColor(ccc3(255,0,0))
	TimeBuffBarLabel:setPosition(30, 30)
	TimeBuffBarLabel:setTag(ComboLabelTag);		

	
    bglayer:setPosition(CCPointMake(700, 50))
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,2,UIdefine.TimeBuffBarUI)
	
	
	--��ʼ����ʱ��
	TimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(p.ComboTick, 0.1, false)	
end

function p.RemoveTimer()
	CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(TimerId)
end


