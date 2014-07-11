--进度条控件
dragBar = class("dragBar", function()
										return CCLayer:create();
								   end
					)
		
dragBar.__index = dragBar

local cordLabel = nil

local bartag = 99;
local pointertag = 98;

local barheight = 7;
local barwidth = 200;

local tPointerList = {}
local g_choosedPointer =nil

local bLock = false


function DragBarInit()
	tPointerList = {}
	bLock = false
	g_choosedPointer =nil
end	

function GetDragBarLock()
	return bLock
end	



local recordx,recordy = 0,0

local function onTouchBegan(x,y)	
	--选定bar
	
	--将触摸转换为拉条本地坐标 
	p1 = g_choosedPointer:convertToNodeSpaceAR(ccp(x, y))
	recordx,recordy = p1.x,p1.y

	bLock = false
	return true;
end


local function onTouchMoved(x,y)
	if g_choosedPointer == nil  then
		return true;
	end
	
	local bar = g_choosedPointer:getParent()
	
	
	--获取移动限制
	local Lastpointer = nil 
	local nextpointer = nil
	local index = 0
	local pointerlist = bar.PointerList
	
	
	for i,pointer in pairs(pointerlist)do
		if pointer == g_choosedPointer then
			index = i
			break
		end
	end
	
	if index  > 1 then
		Lastpointer = pointerlist[index-1]
	end
	
	if index < #pointerlist then
		nextpointer = pointerlist[index+1]
	end
	
	local xmin = - barwidth/2;
	local xmax =   barwidth/2;
	
	if Lastpointer ~= nil then
		xmin = Lastpointer:getPosition();
	end
	
	if nextpointer ~= nil then
		xmax = nextpointer:getPosition();
	end	
	
	p1 = g_choosedPointer:convertToNodeSpaceAR(ccp(x, y))
	
	--鼠标位移
	local adjx = p1.x - recordx
	local orix,oriy = g_choosedPointer:getPosition();
	
	local posx = orix+adjx
	if posx > xmax then
		posx = xmax		
	end

	if posx < xmin then
		posx = xmin	
	end
	
	g_choosedPointer:setPosition(CCPointMake(posx, oriy))
	
	bLock = false
	return true;
end
		
local function onTouchEnded()
	--如果修改了 则设置为未储存
	if g_choosedPointer ~= nil then
		MissionConfig.SetSaved(false) 
	end
	
	bLock = false
	return true;
end



local function onTouch(eventType, x, y)
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
		
		if choosedPointer == nil then
			bLock = false
			return true
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


function dragBar:Create()
	local dragBar = dragBar.new()

	--创建BAR
	local bar = CCSprite:create("UI/Bar/dragbar.png")
	bar:setPosition(CCPointMake(0, barheight/2))
	
	--创建BAR指针
	--local pointer = CCSprite:create("UI/Bar/dragpointer.png")
	--pointer:setPosition(CCPointMake(0,0))
	
	dragBar:addChild(bar,1,bartag)
	--dragBar:addChild(pointer,1,pointertag)
	
	dragBar:registerScriptTouchHandler(onTouch)
    dragBar:setTouchEnabled(true)	


	--将指针加入私有列表
	dragBar.PointerList = {}	
	return dragBar;
end

--新增指针
function dragBar:AddPointer(nParam,nrate,sprite)
	--创建BAR指针
	local pointer  = nil
	if sprite == nil then
		pointer = CCSprite:create("UI/Bar/dragpointer.png")
	else
		pointer = sprite
	end
	
	self:addChild(pointer,99)
	pointer.nParam = nParam
	
	local tdataPercent = self:getData()
	local nTotalPercent = 0
	for i,v in pairs(tdataPercent)do
		nTotalPercent = nTotalPercent + v
	end

	
	--如果没有输入概率 则默认为剩下所有概率
	if nrate == nil then
		nrate = 100 - nTotalPercent
	end	
	
	--如果概率超100 则取剩余部分
	if nTotalPercent + nrate >= 100 then
		nrate = 100 - nTotalPercent
	end
	
	
	--根据概率设置位置
	local posx = (nTotalPercent+nrate)/100*barwidth - barwidth/2
	pointer:setPosition(CCPointMake(posx,0))
	
	--将指针加入到列表
	table.insert(tPointerList,pointer);
	table.insert(self.PointerList,pointer);
end

--删除指针
function dragBar:DelPointer(nParam)
	local tmp = nil
	for i,pointer in pairs(self.PointerList)do
		local test = pointer.nParam
		if pointer.nParam == nParam then
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
function dragBar:getData()
	local tret = {}
	local lastpercent = 0
	for i,pointer in pairs(self.PointerList)do
		local x,y = pointer:getPosition();
		--cordLabel:setString("x:"..x)
		local percent = x + barwidth/2
		percent = percent/barwidth
		percent = math.ceil(percent*100)
		
		percent  = percent - lastpercent
		lastpercent = lastpercent + percent
		table.insert(tret,percent)
	end
	
	return tret
end	

--根据索引切换显示拉条SPRITE
function dragBar:switchBtnSprite(Sprite,index,param)
	if param == nil then
		param = 0 
	end
	
	self:addChild(Sprite,1)
	
	local pointer = self.PointerList[index]
	local posx,posy = pointer:getPosition();
	
	Sprite:setPosition(CCPointMake(posx,posy))
	Sprite.nParam = param
	--替换掉原来的
	self.PointerList[index] = Sprite
	
	--替换掉原来的
	for i,v in pairs(tPointerList)do
		if v == pointer then
			tPointerList[i] = Sprite;
			break
		end
	end
	
	--删除原来的
	pointer:removeFromParentAndCleanup(true);
end



























