--数值转图片
NumberToPic = {}

local p=NumberToPic;


local nStepVal = 5; --量化值
local nTypeStep = 3; --类型单位数



--获取0-9的frame
function p.GetFigure(figure)
	local index = figure
	
    local frameWidth = 30
    local frameHeight = 92
    local textureNum = CCTextureCache:sharedTextureCache():addImage("UI/font/number.png")
    local rect = CCRectMake(0,index*frameHeight,frameWidth, frameHeight)


	local frame0 = CCSpriteFrame:createWithTexture(textureNum, rect)	
	local sprite = CCSprite:createWithSpriteFrame(frame0)

	return sprite;
end

--获取sprite,和单个数字spri的表
function p.GetPicByNumBer(nInput)
	local number = nInput
	local t = {}
	while(1)do
		if number/10 > 1 then
			local figure = number%10
			table.insert(t,1,figure)
			number = math.floor(number/10)
		else
			table.insert(t,1,number)
			break
		end
	end
	
	
	local spriteMain = CCSprite:create();
	local tSingle = {}
	
	for i,figure in pairs(t) do 
		local sprite = p.GetFigure(figure)
		sprite:setPosition(CCPointMake(50*(i-1), 0))
		spriteMain:addChild(sprite)
		table.insert(tSingle,sprite)
	end
	
	
	spriteMain:setScale(1.5);
	--尾部加个HIT
	local HITSprite = CCSprite:create("UI/font/hit.png")
	HITSprite:setPosition(CCPointMake(50*(#t)+20, 0))
	spriteMain:addChild(HITSprite)
	table.insert(tSingle,HITSprite)
	return spriteMain,tSingle;
end



