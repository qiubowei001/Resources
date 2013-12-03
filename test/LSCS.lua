--����ע�����������Ҫ�Ӹ�
math.randomseed(os.time())

--ƽ���غ���
local bIfFirst = true --����true ����false
local g_nRound = 12
local g_Skille = 2 --��Ҽ��ܺĵ�
local g_Att = 0
local g_Energy = 0
--������ϲ�������
local g_tcardLeft = {}


local tCardGroup = {}
local tCardRandom = {}



function InitCardGroup()
	--����ģ��
	local tCardGroup = 
	{
		--[[	--�ѵ� ����
		[1] ={1		,2},
		[2] ={2		,9},
		[3] ={3		,5},
		[4] ={4		,7},
		[5] ={5		,4},
		[6] ={6		,0},
		[7] ={7		,3},
		--]]
		--
		[1] ={1		,8},
		[2] ={2		,7},
		[3] ={3		,5},
		[4] ={4		,3},
		[5] ={5		,3},
		[6] ={6		,3},
		[7] ={7		,1},
		--]]	
	}
	tCardRandom = {}
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
	--[[
	local s = "���ֿ���:"
	for i,v in pairs(tCardRandom) do
		s = s..v
	end
	print(s)--]]
end

function PlayerSpell()
	g_Energy = g_Energy - g_Skille
	g_Att = g_Att + g_Skille
	print(printAllCard().." ���ʩ�ż��� �ĵ�:"..g_Skille)
end


--���� 1�������� 2���Ʊ� , �������п��ܴ����
function digui(e,t)
	local treturn = {}
	if t ==nil then
		return nil
	end
		
	if #t == 0 then	
		return {999}
	end
	
	if #t == 1 then
		return {{t[1]},999}
	end
	
	for i,v in pairs(t) do
		
		--ȡ����һ��ֵ��Ϊ����
		local eplus = t[i]
		
		local tleft = {}
		--����ʣ��t
		for j=i+1,#t do
			table.insert(tleft,t[j])
		end

		local tAllPosible = digui(e,tleft)
		if tAllPosible ~= nil then --{}	
			for i,v in pairs(tAllPosible) do
				if 999 == v then
					table.insert(treturn,{eplus})
				else					
					local tmp = v
					--��eplus���¼������
					table.insert(tmp,eplus)				
					table.insert(treturn,tmp)
				end
			end
		end
	end
	--ƨ�ɺ���Ӹ�999
	table.insert(treturn,999)
	return treturn
end


--��ӡ���г��п���
function printAllCard()
	--local s = "e:"..g_Energy.." ���п���:"
	local s = string.format("e:%d ���п���:",g_Energy)
	if #g_tcardLeft == 0 then
		return "���п���:��"
	end
	for i,v in pairs(g_tcardLeft) do
		s = s.." "..v
	end
	return s
end

--����
function TakeOneCard()
	if #tCardRandom <= 0 then
		print(printAllCard().." û����!!")
		return
	end
	
	local ecard  = tCardRandom[1];
	table.insert(g_tcardLeft,ecard);
	table.remove(tCardRandom,1);
	
	print(printAllCard().." �鵽"..ecard.."�ǿ�")
end


--ʹ�ÿ�Ƭ
function UseCard(tuseCards)
	if tuseCards == nil then
		return
	end	
	local s = ""
	local sum = 0
	for i = #g_tcardLeft,1,-1 do
		for j,E in pairs(tuseCards) do
			if E == g_tcardLeft[i] then
				s = s.." "..E
				sum = sum + E
				table.remove(g_tcardLeft,i)
				table.remove(tuseCards,j)
			end
		end
	end
	g_Energy = g_Energy - sum
	print(printAllCard().." ���ʹ�ÿ���:"..s)
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
	
	local sum = 0
	for i,v in pairs(g_tcardLeft) do
		sum = v + sum
	end
	
	--������
	local ecardtotal = sum--��Ƭ�������
	--��������ȫ����������
	if ecardtotal <= e then
		return ecardtotal,tabletmp
	else
	
	
		--��Ƭ�����ܺͳ�Խʩ������
		--�ҳ���������ӽ�e�Ľ�
		local test = digui(e,g_tcardLeft)
		--test = { {1,3,4},{2,2,3}, 999}
		--�����б�ֵУ��
		local EmaxSpell = 0
		local tCards = {}
		for i=#test ,1,-1 do
			if test[i] ~= 999 then
				local sum = 0
				for j,k in pairs(test[i])do
					sum = sum + k
				end
				if sum == e then
					return sum,test[i]
				elseif sum < e then
					if EmaxSpell == 0 then
						EmaxSpell = sum
						tCards = test[i]
					end
					
					if EmaxSpell < sum then
						EmaxSpell = sum
						tCards = test[i]
					end
				end		
			end
		end			
	end
	return EmaxSpell,tCards
		
end


function mainloop()
--��ʼ��	
g_Att = 0
g_Energy = 0
	
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
	
	
	--���غϻ�ȡ����
	local eround = round
	if eround > 10 then
		eround = 10
	end
	g_Energy = eround
	print(printAllCard().." ��"..round.."�غ� ")
	--�鿨һ��
	TakeOneCard();

	--����ѡ��
	local EA , EB = nil , nil
	local tcardUseA,tcardUseB = nil
	
	
	--�����ְҵ�����俨���� EA
	if eround < g_Skille then
		EA = nil
	else
		local e_left = eround - g_Skille
		
		--������������,���Ŀ��Ʊ�
		local e_card = 0
		e_card,tcardUseA = Stragy(e_left)
		if e_card == nil then
			e_card = 0
		end
		EA =  g_Skille + e_card
	end
	
	--������������� EB
	EB,tcardUseB = Stragy(eround)
	if EA == nil and EB== nil then
		
	elseif EA == nil and EB~= nil then
		UseCard(tcardUseB)
		g_Att = g_Att + EB	
	elseif EB == nil and EA~= nil then
		PlayerSpell()
		UseCard(tcardUseA)	
		g_Att = g_Att + EA	
	--��EA >= EB�� ѡ1 ����ѡ2
	elseif EA >= EB then
		PlayerSpell()
		UseCard(tcardUseA)
		g_Att = g_Att + EA	
	else
		UseCard(tcardUseB)
		g_Att = g_Att + EB		
	end
end
end

for i=1,1 do
	InitCardGroup()
	mainloop();
	print("��"..i.."�ֹ��������:"..g_Att)
end

--]]

--print("���ֹ��������:"..g_Att)






