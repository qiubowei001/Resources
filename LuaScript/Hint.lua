--������ʾ
Hint = {}

local p=Hint;

p.tHintType = 
{	
	--ͼƬ·��
	noEnergy = { "UI/font/noEnergy.png"};		--û������
	LowHp = { "UI/font/LowHp.png"};				--û��Ѫ
	LowEnergy = { "UI/font/lowEnergy.png"};		--����̫��
	
	criticalUp = { "UI/font/criticalUp.png"};		--��������
	criticalDown = { "UI/font/criticalDown.png"};	--��������
	dodgeUp = { "UI/font/dodgeUp.png"};				--��������
	dodgedown = { "UI/font/dodgedown.png"};			--���ܼ���
	
	powerup = { "UI/font/powerup.png"};				--��������
	powerdown = {"UI/font/powerdown.png"};			--��������
	

	
}


local winSize = CCDirector:sharedDirector():getWinSize()


local tHintTable = {} --�������
local g_hinttimerid = nil
local g_tick	= 0;

--�ĳɶ���ʽ��ʾ
function p.TimerShowHint()
	--������ڲ�����һ�� �򷵻�
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
	
	--����Ч��
	--ɾ��
	function delete(sender)
		sender:removeFromParentAndCleanup(true);
	end
		
	local arr = CCArray:create()
	
	local scaleact = CCScaleTo:create(0.1, 2.5)
	local scaleact2 = CCScaleTo:create(0.2, 1)
	arr:addObject(scaleact)
	arr:addObject(scaleact2)

	--������ʧ
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
	local tHintTable = {} --�������
	g_tick = 0
	g_hinttimerid = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(p.TimerShowHint, 0.2, false)		
end

function p.GetTimerId()
	return g_hinttimerid	
end














