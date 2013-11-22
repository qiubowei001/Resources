--数值转图片
ValueToPic = {}

local p=ValueToPic;


local nStepVal = 5; --量化值
local nTypeStep = 3; --类型单位数

--武器类型
local tAttType = 
{
	[1] = "骨头",
	[1] = "大骨头",
	
	[2] = "木棒",
	[2] = "大木棒",
	[3] = "匕首",
	[3] = "利刃",
	
	[3] = "枪",
	[3] = "长枪",
	
	[4] = "剑",
	[5] = "大剑",
	
	[5] = "斧头",
	[5] = "大斧头",
	
	
	[6] = "",
	[7] = "",
}

function p.Format(val)
	local stepCount = math.floor(val/nStepVal) --量化总数
	
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

end



