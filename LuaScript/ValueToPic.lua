--��ֵתͼƬ
ValueToPic = {}

local p=ValueToPic;


local nStepVal = 5; --����ֵ
local nTypeStep = 3; --���͵�λ��

--��������
local tAttType = 
{
	[1] = "��ͷ",
	[1] = "���ͷ",
	
	[2] = "ľ��",
	[2] = "��ľ��",
	[3] = "ذ��",
	[3] = "����",
	
	[3] = "ǹ",
	[3] = "��ǹ",
	
	[4] = "��",
	[5] = "��",
	
	[5] = "��ͷ",
	[5] = "��ͷ",
	
	
	[6] = "",
	[7] = "",
}

function p.Format(val)
	local stepCount = math.floor(val/nStepVal) --��������
	
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



