--数值转图片
ValueToPic = {}

local p=ValueToPic;


local nStepVal = 5; --量化值
local nTypeStep = 3; --类型单位数

--武器类型
local tAttType = 
{
[0] = ccc3(255,255,255),--白色
[1] = ccc3(0,255,0),--绿色
[2] = ccc3(0,0,255),--蓝色
[3] = ccc3(160,32,240),--紫色
[4] = ccc3(255,255,0),--橙色
[5] = ccc3(255,0,0),--红色
[6] = ccc3(0,0,0),--黑色

}

function p.Format(val)
	local stepCount = math.ceil(val/nStepVal) --量化总数
	
	local nNum = stepCount%nTypeStep;
	local nType = math.floor(stepCount/nTypeStep);
	
	if nNum == 0 and nType >0 then
		nType = nType-1
		nNum  = nTypeStep
	end
	
	if nType > #tAttType then
		nNum  = (nType - #tAttType)*nTypeStep
		nType = #tAttType
	end
	
	
	return nType,nNum
end

--local ntype,num = p.Format(300)
--print("ntype:"..ntype.." num:"..num)


function p.GetPicByAttack(nAttack)
	local ntype,num = p.Format(nAttack)
	local spriteMain = CCSprite:create();
	local color = tAttType[ntype]	
	for i=1,num do 
		local sprite = CCSprite:create("UI/AttGrade/att.png")
		sprite:setPosition(CCPointMake(20*(i-1), 0))
		spriteMain:addChild(sprite)
		sprite:setColor(color)
	end

	return spriteMain;
end



