--进度条控件
dragBar = class("dragBar", function()
										return CCLayer:create();
								   end
					)
		
dragBar.__index = dragBar

local cordLabel = nil

local bartag = 99;
local pointertag = 98;

local barheight = 13;
local barwidth = 209;

local tPointerList = {}
local g_choosedPointer =nil

local bLock = false
function dragBar:Create()
	local dragBar = dragBar.new()

	--创建BAR
	local bar = CCSprite:create("UI/Bar/dragbar.png")
	bar:setPosition(CCPointMake(0, barheight/2))
	
	--创建BAR指针
	local pointer = CCSprite:create("UI/Bar/dragpointer.png")
	pointer:setPosition(CCPointMake(0,0))
	
	dragBar:addChild(bar,1,bartag)
	dragBar:addChild(pointer,1,pointertag)
	
	dragBar:registerScriptTouchHandler(onTouch)
    dragBar:setTouchEnabled(true)	

	--坐标
	cordLabel = CCLabelTTF:create("", "Arial", 25)
	dragBar:addChild(cordLabel)
	cordLabel:setColor(ccc3(0,0,0))
	cordLabel:setPosition(300, 100)
	
	
	cordLabel:setString("?,?  barpos:")

	--将指针加入到列表
	table.insert(tPointerList,pointer);
	
	--将指针加入私有列表
	dragBar.PointerList = {}
	table.insert(dragBar.PointerList,pointer);
	
	return dragBar;
end

--新增指针
function dragBar:AddPointer(nMontype)
	--创建BAR指针
	local pointer = CCSprite:create("UI/Bar/dragpointer.png")
	pointer:setPosition(CCPointMake(30,0))
	self:addChild(pointer,1,pointertag)
	pointer.nMontype = nMontype
	--将指针加入到列表
	table.insert(tPointerList,pointer);
	table.insert(self.PointerList,pointer);
end

--删除指针
function dragBar:DelPointer(nMontype)
	local tmp = nil
	for i,pointer in pairs(self.PointerList)do
		if pointer.nMontype == nMontype then
			tmp = pointer
		end
	end
	
	for i,v in pairs(tPointerList) do
		if v == tmp then
			table.remove(tPointerList,i)
			break
		end
	end
	
	for i,v in pairs(self.PointerList) do
		if v == tmp then
			table.remove(self.PointerList,i)
			break
		end
	end	
	tmp:removeFromParentAndCleanup(true);
end

--读取指针数据 返回表

--



function onTouch(eventType, x, y)
	if bLock == false then
		bLock = true
	else
		return true
	end
	
	local nx = math.ceil(x)
	local ny = math.ceil(y)


		
    if eventType == "began" then   
		--遍历指针列表 选定指针
		local choosedPointer = nil
	
		for i,pointer in pairs (tPointerList) do 
			local p1 = pointer:convertToNodeSpaceAR(ccp(x, y))
			if p1.x >= -10 and p1.x <= 10 and p1.y >= -10 and p1.y <= 10 then
				choosedPointer =  pointer
				break
			end
		end
			
		g_choosedPointer = choosedPointer
        return onTouchBegan(nx, ny)
    elseif eventType == "moved" then
		if g_choosedPointer ~= nil then
			return onTouchMoved(nx, ny)
		end
    else
		if g_choosedPointer ~= nil then
			return onTouchEnded(nx, ny)
		end	
    end
	bLock = false
	return true;
end


local recordx,recordy = 0,0

function onTouchBegan(x,y)	
	--选定bar
	
	--将触摸转换为拉条本地坐标 
	p1 = g_choosedPointer:convertToNodeSpaceAR(ccp(x, y))
	recordx,recordy = p1.x,p1.y

	bLock = false
	return true;
end


function onTouchMoved(x,y)
	if g_choosedPointer == nil  then
		return true;
	end
		
	p1 = g_choosedPointer:convertToNodeSpaceAR(ccp(x, y))
	
	--位移
	local adjx = p1.x - recordx
	--local adjy = p1.y - recordy
	local orix,oriy = g_choosedPointer:getPosition();
	
	g_choosedPointer:setPosition(CCPointMake(orix+adjx, oriy))
	
	cordLabel:setString(p1.x..","..p1.y)
	bLock = false
	return true;
end
		
function onTouchEnded()
	bLock = false
	return true;
end
























