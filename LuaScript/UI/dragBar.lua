--�������ؼ�
dragBar = class("dragBar", function()
										return CCSprite:create();
								   end
					)
		
dragBar.__index = dragBar

local cordLabel = nil

local bartag = 99;
local pointertag = 98;

local barheight = 13;
local barwidth = 209;

local testpointer = nil
function dragBar:Create()
	local dragBar = dragBar.new()
	
	--��������
	local layerBg = CCLayer:create()
	
	--����BAR
	local bar = CCSprite:create("UI/Bar/dragbar.png")
	bar:setPosition(CCPointMake(0, barheight/2))
	
	--����BARָ�� �Ǹ���ť
	local pointer = CCSprite:create("UI/Bar/dragpointer.png")
	pointer:setPosition(CCPointMake(0,0))
	
	dragBar:addChild(bar,1,bartag)
	dragBar:addChild(pointer,1,pointertag)
	
	layerBg:addChild(dragBar,1)
	layerBg:registerScriptTouchHandler(onTouch)
    layerBg:setTouchEnabled(true)	

	--����
	cordLabel = CCLabelTTF:create("", "Arial", 25)
	layerBg:addChild(cordLabel)
	cordLabel:setColor(ccc3(0,0,0))
	cordLabel:setPosition(300, 100)
	
	
	cordLabel:setString("?,?  barpos:")

	testpointer = pointer
	return layerBg;
end

function onTouch(eventType, x, y)
	local nx = math.ceil(x)
	local ny = math.ceil(y)
	
    if eventType == "began" then   
        return onTouchBegan(nx, ny)
    elseif eventType == "moved" then
        return onTouchMoved(nx, ny)
    else
        return onTouchEnded(nx, ny)
    end
	return true;
end


local recordx,recordy = 0,0
local choosedBar = nil;
function onTouchBegan(x,y)
	--������ת��Ϊ������������ 
	p1 = testpointer:convertToNodeSpaceAR(ccp(x, y))
	--�ж��Ƿ��������� ��������
	if p1.x >= -10 and p1.x <= 10 and p1.y >= -10 and p1.y <= 10 then
		recordx,recordy = p1.x,p1.y
		choosedBar = testpointer
	else
		choosedBar = nil
	end 
	
	
	
	return true;
end


function onTouchMoved(x,y)
	if choosedBar == nil  then
		return
	end
		
	p1 = testpointer:convertToNodeSpaceAR(ccp(x, y))
	
	--λ��
	local adjx = p1.x - recordx
	--local adjy = p1.y - recordy
	local orix,oriy = testpointer:getPosition();
	
	testpointer:setPosition(CCPointMake(orix+adjx, oriy))
	
	cordLabel:setString(p1.x..","..p1.y)
	return true;
end
		
function onTouchEnded()
	return true;
	
end
		























