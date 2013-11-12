--��������
PassiveSkill = {};
local p = PassiveSkill;

--��������ʵ��
p.Entity=	
{
	Radar = 0;
	RadarBuff = 0;
}



function passive01()
	p.Entity.Radar = 1;
	MainUI.ShowSpeedBtn();
end

function passive02()
	p.Entity.RadarBuff = 1;
end

local tPassiveSkillTable = {}
	
	tPassiveSkillTable.Radar = {}
	tPassiveSkillTable.Radar["name"] = "�����״�"
	tPassiveSkillTable.Radar["func"] = passive01
	
	tPassiveSkillTable.RadarBuff = {}
	tPassiveSkillTable.RadarBuff["name"] = "���ٰ�ťBUFF"
	tPassiveSkillTable.RadarBuff["func"] = passive02
	


--��ʼ����������
function p.Initial()
	p.Entity=
	{
		Radar = 0;--Ĭ�Ϲر��״�
		RadarBuff = 0;--Ĭ�Ϲر��״�BUFF
	}
	
	for sIndex,v in pairs(p.Entity) do
		if v ~= 0 then
			local tskillInfo = tPassiveSkillTable[sIndex]
			tskillInfo["func"]();
		end
	end
end

function p.LearnSkillCallBack(sSkill)
	tPassiveSkillTable[sSkill]["func"]()
end
