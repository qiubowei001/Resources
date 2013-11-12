--被动技能
PassiveSkill = {};
local p = PassiveSkill;

--被动技能实体
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
	tPassiveSkillTable.Radar["name"] = "怪物雷达"
	tPassiveSkillTable.Radar["func"] = passive01
	
	tPassiveSkillTable.RadarBuff = {}
	tPassiveSkillTable.RadarBuff["name"] = "加速按钮BUFF"
	tPassiveSkillTable.RadarBuff["func"] = passive02
	


--初始化被动技能
function p.Initial()
	p.Entity=
	{
		Radar = 0;--默认关闭雷达
		RadarBuff = 0;--默认关闭雷达BUFF
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
