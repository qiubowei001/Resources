--����������
SkillUpgrade = {};
local p = SkillUpgrade;

local savepath = "save\\SkillLock.xml"	--�洢����������

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
[15] = {MAGICID = 15,PassiveID = nil},

}


--������
--����:
--1.ÿ����Ϊһ������֦��,ֻ������������ ����ֻ���б�������
--2.�������ڵ㲻���ظ�(tSkillNode)
p.tSkillTree = 
{
[1] = {1},
[2] = {2,9,10},
[3] = {3},
[4] = {11},
[5] = {12},
[6] = {13},
--[7] = {15,16},
[7] = {15},
[8] = {6},
[9] = {4},
[10] = {5},
[11] = {7},
[12] = {8},


}


local tSkillLockSave = {} --���ܽ�������

--tSkillLockSave[NODE_ID] = true --����
--tSkillLockSave[NODE_ID] = false --δ����

function p.UnlockSkill(nodeid)
	tSkillLockSave[nodeid] = true
	data(tSkillLockSave,savepath)
end	

function p.Init()
	tSkillLockSave = {}
	data(savepath, tSkillLockSave)
	
	if #tSkillLockSave == 0 then
		--��һ���������ʼ��
		for nNodeid,v in pairs(p.tSkillNode)do
			tSkillLockSave[nNodeid] = false
		end
		SkillUpgrade.UnlockSkill(1)--����BUFF����
		data(tSkillLockSave,savepath)
	end
end	

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

	local tRandomAll = {}
	
	--������������������ûѧϰ֦�ɵĸ����� ����������
	--��������ѧϰ,��������ڴ�֦�ɵ��������
	--tSkillLockSave[i] = true --����
	for i,v in pairs(p.tSkillTree) do
		if tPlayerSkill[i]== nil then
			local nodeid  = p.tSkillTree[i][1]
			if tSkillLockSave[nodeid] then
				table.insert(tRandomAll,{i,p.tSkillTree[i][1]})
			end	
		else
			--��ȡ���¼���INDEX
			local nSkillIndex = #tPlayerSkill[i]
			if nSkillIndex < #v then
				local nodeid  = p.tSkillTree[i][nSkillIndex+1]
				if tSkillLockSave[nodeid] then
				table.insert(tRandomAll,{i,nodeid})
				end
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
	--local test = 
	----�����ʣ3������ ֱ�ӷ���
	if #tRandomAll <= 3 then
		for i,v in pairs(tRandomAll) do
			table.insert(tRandomRet,v)
		end
		return tRandomRet
	end
			
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







