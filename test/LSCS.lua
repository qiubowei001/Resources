--ƽ���غ���
local bIfFirst = true --����true ����false
local g_nRound = 12
local g_Skille = 2 --��Ҽ��ܺĵ�

--������ϲ�������
local g_tcardLeft = {}


					--[[function() 
						if bIfFirst then
							return 3
						else
							return 4
						end
					end --]]

					

					
--����ģ��
local tCardGroup = 
{
	--�ѵ� ����
[1] ={1		,2},
[2] ={2		,9},
[3] ={3		,5},
[4] ={4		,7},
[5] ={5		,4},
[6] ={6		,0},
[7] ={7		,3},
}

--����ע�����������Ҫ�Ӹ�
local tCardRandom = {}

--��ȥ���յ�λ
for i=#tCardGroup ,1,-1  do
	if tCardGroup[i][2] == 0 then
		table.remove(tCardGroup,i)
	end	
end


--����˳��
for i=30 ,1,-1  do
	local index = math.random(1,#tCardGroup)
	local info = tCardGroup[index]
	
	info[2] = info[2] - 1
	local e = info[1]
	table.insert(tCardRandom,e) 
	
	if info[2] <= 0 then
		table.remove(tCardGroup,index)
	end
end



--����
function TakeOneCard()
	if #tCardRandom <= 0 then
		print("û����!!")
		return
	end
	
	local ecard  = tCardRandom[1];
	table.insert(g_tcardLeft,ecard);
end

--�ÿ�����	�������� �������������Ϳ�Ƭ��(�������������Ϊ׼��)
function Stragy(e)
	--���Ʊ�
	local tabletmp = {}
	for i,v in pairs(g_tcardLeft) do
		table.insert(tabletmp,v)
	end
	
	--һ���õ�
	for i,v in pairs(g_tcardLeft) do
		if v == e then
			return e,{e}
		end
	end
	
	
	--������
	local ecardtotal = --��Ƭ�������
	--��������ȫ����������
	if ecardtotal <= e then
		return ecardtotal,tabletmp
	else
	--��Ƭ�����ܺͳ�Խʩ������
		e = 5
		t = {1,3,4,2,7}
		--�ҳ���������ӽ�e�Ľ�
		--for Cardnum = 1,#t do
			for index,ecard in pairs(t) do
				plus1 = ecard
				for	i = Cardnum,1,-1 do
					t[]
				end			
			end
		--end
		
	end
	
	
end

--��3����
TakeOneCard();
TakeOneCard();
TakeOneCard();

--��ұ������������������0�Ŀ�����ʱ�����㣩
local E_Fire = 0
for round = 1,12 do
	--****************************************************--
	--========����������ÿ�غ��ҿ������������========----
	--========׼���� �������������,�Է��˷�������======----
	--****************************************************--
	
	--�鿨һ��
	TakeOneCard();

	--���غϻ�ȡ����
	local eround = round
	if eround > 10 then
		eround = 10
	end

	--����ѡ��
	local EA , EB = nil , nil
	local tcardUseA,tcardUseB = nil
	--�����ְҵ�����俨���� EA
	if eround < EA then
		EA = nil
	else
		local e_left = eround - EA
		
		--������������,���Ŀ��Ʊ�
		local e_card = 0
		e_card,tcardUseA = Stragy(e_left)
		
		EA =  g_Skille + e_card
	end
	
	
	--������������� EB
	EB,tcardUseB = Stragy(eround)
	
	
	--��EA >= EB�� ѡ1 ����ѡ2
	if EA >= EB then
		PlayerSpell()
		UseCard(tcardUseA)
	else
		UseCard(tcardUseB)
	end
end

--]]






