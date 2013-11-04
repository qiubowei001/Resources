--技能升级树
SkillUpgrade = {};
local p = SkillUpgrade;


--技能树节点 MAGICID:主动技能id  PassiveID:被动技能ID
p.tSkillNode = 
{
[1] = {MAGICID = 1,PassiveID = nil},
[2] = {MAGICID = 2,PassiveID = nil},
[3] = {MAGICID = 3,PassiveID = nil},
[4] = {MAGICID = 4,PassiveID = nil},
[5] = {MAGICID = 5,PassiveID = nil},
[6] = {MAGICID = 6,PassiveID = nil},
[7] = {MAGICID = 7,PassiveID = nil},
[8] = {MAGICID = 8,PassiveID = nil},
[9] = {MAGICID = 9,PassiveID = nil},
[10] = {MAGICID = 10,PassiveID = nil},
[11] = {MAGICID = 11,PassiveID = nil},
[12] = {MAGICID = 12,PassiveID = nil},
[13] = {MAGICID = 13,PassiveID = nil},
[14] = {MAGICID = 14,PassiveID = nil},
}


--技能树
--规则:
--1.每个表为一个技能枝干,只能有主动技能 或者只能有被动技能
--2.所有树节点不可重复(tSkillNode)
p.tSkillTree = 
{
[1] = {1,4,5,6,7},
[2] = {2,8,9,10},
[3] = {3},
[4] = {11},
[5] = {12},
[6] = {13}
}



function p.GetRandomSkillId()

	local tPlayerSkill = 
	{
	[1]={1,4,5,6,7},--player[playerInfo.SKILLID1],
	[2]={2,8,9},--player[playerInfo.SKILLID2],
	[3]=nil,
	[4]={11},	--player[playerInfo.SKILLID3],
				--player[playerInfo.SKILLID4],
	[5]=nil,
	[6]=nil,		
	}

	local tRandom = {}
	
	--遍历技能树，如果玩家没学习枝干的根技能 则插入根技能
	--如果玩家有学习,则插入属于此枝干的最顶部技能
	for i,v in pairs(p.tSkillTree) do
		if tPlayerSkill[i]== nil then
			tRandom[i] = p.tSkillTree[i][1]
		else
			--获取最新技能INDEX
			local nSkillIndex = #tPlayerSkill[i]
			if nSkillIndex < #v then
				tRandom[i] = p.tSkillTree[i][nSkillIndex+1]
			end
		end
	end
	
	
	--获取主动技能数量
	local nNum = 0
	for i,v in pairs(tPlayerSkill) do
		if v ~= nil then
			print(table.getn(v))
			if p.tSkillNode[v[1]].MAGICID ~= nil then
				nNum = nNum +1
			end
		end
	end
	
	--如果主角主动技能已满 则去除主动技能
	if nNum >= 4 then--brickInfo.PlayerSkillCount then
		for i,v in pairs(tRandom) do
			if p.tSkillNode[v].MAGICID ~= nil then
				tRandom[i] = nil
			end		
		end
	end
	
	
	--[[print("tRandom:")
	for i,v in pairs(tRandom) do
		print("root:"..i.." val:"..v)
	end
	--]]
	
	--随机取出3个技能节点ID
	
	--返回技能枝干ID 和节点ID
	
end


p.GetRandomSkillId()









