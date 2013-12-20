--����

Combo = {};
local p = Combo;

local ComboLabelTag =9999;
local g_Combo = 0;
local gTimeLeft = 0;
local m_ComboTimeReset = 40 --COMBOά��ʱ�� /0.1��

local TimerId = nil;


local tGrade = 
{
--	  --buff, RATIO
[1] = {3	,1	},
[2] = {8	,1.1},
[3] = {15	,1.2},
[4] = {25	,1.3},
[5] = {35	,1.4},
[6] = {55	,1.6},
[7] = {70	,1.8},
[8] = {9999	,2	}
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
	for i=1,#tGrade do
		if g_Combo < tGrade[i][1] then
			return tGrade[i][2],i
		end
	end
	
end

local winSize = CCDirector:sharedDirector():getWinSize()
function p.AddCombo()
	g_Combo = g_Combo + 1
	gTimeLeft =  m_ComboTimeReset
	local scene = Main.GetGameScene();
	
	--��ʾ
	local sprite,tSingle = NumberToPic.GetPicByNumBer(g_Combo)
	sprite:setPosition(CCPointMake(winSize.width *0.45 , winSize.height *0.8))
	scene:addChild(sprite,99)
	
	--ɾ��
	function delete(sender)
		sender:removeFromParentAndCleanup(true);
	end

	--�ȴ�3����Զ�ɾ��
	local delay = CCDelayTime:create(3)
	local actionremove = CCCallFuncN:create(delete)	
	
	local arr = CCArray:create()
		
	arr:addObject(delay)
	arr:addObject(actionremove)
	local  seq = CCSequence:create(arr)	
	sprite:runAction(seq)

	for i,figureSprite in pairs(tSingle)do
		local arr = CCArray:create()
		
		if i ~= #tSingle then
			--��������Ч�� ��ĸHIT����Ҫ����
			local scaleact = CCScaleTo:create(0.1, 2)
			local scaleact2 = CCScaleTo:create(0.3, 1)
			arr:addObject(scaleact)
			arr:addObject(scaleact2)
		else	
			--local delay = CCDelayTime:create(0.4)
			--arr:addObject(delay)
			
			local scaleact = CCScaleTo:create(0.1, 1.2)
			local scaleact2 = CCScaleTo:create(0.3, 1)
			arr:addObject(scaleact)
			arr:addObject(scaleact2)			
		end
		--������ʧ
		local opacity = CCFadeOut:create(2)
		local actionremove = CCCallFuncN:create(delete)

		arr:addObject(opacity)
		arr:addObject(actionremove)
		local  seq = CCSequence:create(arr)	
		figureSprite:runAction(seq)
	end
end

function p.ComboTick()
	local step = 0;
	gTimeLeft = gTimeLeft - 1
	if gTimeLeft < 0 then
		gTimeLeft = 0
		g_Combo = 0
		gGrade = 1
	end
	--���¼���
	gRatio,gGrade = p.doCalculate()
	--TimeBuffBarLabel:setString("combo:"..g_Combo.."TimeLeft:"..gTimeLeft)			
end

function p.LoadUI()
	local bglayer = CCLayer:create()
	
	--��ʼ��
	gRatio,gGrade = 1,1
	g_Combo = 0;
	
	if TimerId ~= nil then
		CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(TimerId)
		TimerId = nil;
	end
	
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


