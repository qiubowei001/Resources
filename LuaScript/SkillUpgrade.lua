--����������
SkillUpgrade = {};
local p = SkillUpgrade;


--�������ڵ� MAGICID:��������id  PassiveID:��������ID
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


--������
--����:
--1.ÿ����Ϊһ������֦��,ֻ������������ ����ֻ���б�������
--2.�������ڵ㲻���ظ�(tSkillNode)
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
	
	--������������������ûѧϰ֦�ɵĸ����� ����������
	--��������ѧϰ,��������ڴ�֦�ɵ��������
	for i,v in pairs(p.tSkillTree) do
		if tPlayerSkill[i]== nil then
			tRandom[i] = p.tSkillTree[i][1]
		else
			--��ȡ���¼���INDEX
			local nSkillIndex = #tPlayerSkill[i]
			if nSkillIndex < #v then
				tRandom[i] = p.tSkillTree[i][nSkillIndex+1]
			end
		end
	end
	
	
	--��ȡ������������
	local nNum = 0
	for i,v in pairs(tPlayerSkill) do
		if v ~= nil then
			print(table.getn(v))
			if p.tSkillNode[v[1]].MAGICID ~= nil then
				nNum = nNum +1
			end
		end
	end
	
	--������������������� ��ȥ����������
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
	
	--���ȡ��3�����ܽڵ�ID
	
	--���ؼ���֦��ID �ͽڵ�ID
	
end


p.GetRandomSkillId()









