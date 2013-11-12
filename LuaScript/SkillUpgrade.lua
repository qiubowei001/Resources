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
[15] = {MAGICID = nil,PassiveID = "Radar"},
[16] = {MAGICID = nil,PassiveID = "RadarBuff"},

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
[6] = {13},
[7] = {15,16}
}

--��ȡ����ͼƬ·��
function p.GetPicPath(nskillId)
	local skillnode = p.tSkillNode[nskillId]
	if  skillnode.MAGICID ~= nil then
		return "skill/skill"..skillnode.MAGICID..".png"
	else
		return "skill/PASS"..skillnode.PassiveID..".png"
	end
end

--�Ƿ�Ϊ��������
function p.IfisActSkill(nSkillId)
	if p.tSkillNode[nSkillId].MAGICID ~= nil then
		return true
	else 
		return false
	end
end

function p.GetMagicIdBySkillId(nSkillId)
	if p.IfisActSkill(nSkillId) then
		local magicid = p.tSkillNode[nSkillId].MAGICID
		return magicid
	else
		return nil
	end
end

function p.GetPassIdBySkillId(nSkillId)
	if p.IfisActSkill(nSkillId) then
		return nil
	else
		local spassid = p.tSkillNode[nSkillId].PassiveID
		return spassid
	end
end


--��ʼ����Ҽ��ܱ�
function p.InitPlayerSkill()
	local tPlayerSkill = {}
	for i,v in pairs(p.tSkillTree) do
		tPlayerSkill[i] = nil
	end		
	return tPlayerSkill
end


function p.GetRandomSkillId()
	local tPlayerSkill = player.Skill
	--[[local tPlayerSkill = 
	{
	[1]={1,4,5,6,7},--player[playerInfo.SKILLID1],
	[2]={2,8,9},--player[playerInfo.SKILLID2],
	[3]={3},
	[4]=nil,	--player[playerInfo.SKILLID3],
				--player[playerInfo.SKILLID4],
	[5]=nil,
	[6]=nil,		
	}
	--]]

	local tRandomAll = {}
	
	--������������������ûѧϰ֦�ɵĸ����� ����������
	--��������ѧϰ,��������ڴ�֦�ɵ��������
	for i,v in pairs(p.tSkillTree) do
		if tPlayerSkill[i]== nil then
			table.insert(tRandomAll,{i,p.tSkillTree[i][1]})
		else
			--��ȡ���¼���INDEX
			local nSkillIndex = #tPlayerSkill[i]
			if nSkillIndex < #v then
				table.insert(tRandomAll,{i,p.tSkillTree[i][nSkillIndex+1]})
			end
		end
	end
	
	
	--��ȡ������������
	local nNum = 0
	for i,v in pairs(tPlayerSkill) do
		if v ~= nil then
			if p.tSkillNode[v[1]].MAGICID ~= nil then
				nNum = nNum +1
			end
		end
	end
	

	--������������������� ��ȥ����һ����������
	if nNum >= 4 then--brickInfo.PlayerSkillCount then
		for i,v in pairs(tRandomAll) do
			if p.tSkillNode[v[2]].MAGICID ~= nil and  #(p.tSkillTree[v[1]]) then
				tRandomAll[i] = nil
			end		
		end
	end
	

	--�޼�������
	if #tRandomAll == 0 then
		return {}
	end
	
	local tRandomRet = {}
	for i=1,3 do
		j = math.random(1,#tRandomAll)
		table.insert(tRandomRet,tRandomAll[j])
		table.remove(tRandomAll,j);
	end
	
	--print("tRandomRet:"..#tRandomRet)
	for i,v in pairs(tRandomRet) do
		--print("tRandomRet I:"..i)
		for j,k in pairs(v) do
			--print("v:"..k)
		end
	end

	
	--���ؼ���֦��ID �ͽڵ�ID
	return tRandomRet
end







