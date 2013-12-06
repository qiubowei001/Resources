--����ע�����������Ҫ�Ӹ�
math.randomseed(os.time())

local bIfFirst = true --����true ����false
local g_TestTime = 200--���Ծ���
local bprintdetail = false; --�Ƿ�����ӡ�غ�ϸ��

--��С -- ���غ�������
--local minR = 5
--local maxR = 15

local minR = 10
local maxR = 0
maxR = minR

local g_Skille = 2 --��Ҽ��ܺĵ�
local g_Att = 0
local g_Energy = 0
--������ϲ�������
local g_tcardLeft = {}


local tCardGroup = {}
local tCardRandom = {}


--��ӡÿ�غ�ϸ��
function PRINTRoundDetail(S)
	if bprintdetail then
		print(S)
	end
end

function InitCardGroup()
	--[[����ģ��
	local tCardGroupCopy = 
	{
		--	--�ѵ� ����
		[1] ={1		,2},
		[2] ={2		,9},
		[3] ={3		,5},
		[4] ={4		,7},
		[5] ={5		,4},
		[6] ={6		,0},
		[7] ={7		,3},
	}
	--]]


	
	local tCardGroupCopy = {}
	--���ƿ���
	for i,v in pairs(tCardGroup)do
		local tmp = {}
		for j,k in pairs(v)do
			tmp[j] = k
			
		end
		
		tCardGroupCopy[i] = tmp
	end


	
	tCardRandom = {}
	--��ȥ���յ�λ
	for i=#tCardGroupCopy ,1,-1  do
		if tCardGroupCopy[i][2] == "0" then
			table.remove(tCardGroupCopy,i)
		end	
	end	
	--
	--����˳��
	for i=30 ,1,-1  do
		local index = math.random(1,#tCardGroupCopy)
		local info = tCardGroupCopy[index]
		
		info[2] = info[2] - 1
		local e = info[1]
		table.insert(tCardRandom,e) 
		
		if info[2] <= 0 then
			table.remove(tCardGroupCopy,index)
		end
	end	
	g_tcardLeft = {}
	--[[
	local s = "���ֿ���:"
	for i,v in pairs(tCardRandom) do
		s = s..v
	end
	print(s)--]]
end

--�û�����
function UserSetting()
	--���뿨������
	for i = 1,7 do
		while(1)do
			local cardgrouptmp = ""
			local cardnum = 0
			for j,v in pairs(tCardGroup)do
				cardnum = cardnum + v[2]
				cardgrouptmp = cardgrouptmp.." "..v[1].."��:"..v[2]
			end
			
			print("   ���п�Ƭ����:"..cardnum.." = ( "..cardgrouptmp.." ) \n����"..i.."�ǿ�����:")
			io.flush()
			nNum = io.read("*line")
			tCardGroup[i] = {i,nNum}
			
			cardnum = 0
			for j,v in pairs(tCardGroup)do
				cardnum = cardnum + v[2]
			end
			
			if cardnum > 30 then
				print("���������ܴ���30! cardnum:"..cardnum)
				tCardGroup[i] = {i,0}
			elseif 	i == 7 and cardnum <30 then
				print("����������С��30!")
				tCardGroup[i] = {i,0}
			elseif cardnum == 30 then
				return;
			else
				break
			end
			io.flush()
		end	
	end
end



function PlayerSpell()
	g_Energy = g_Energy - g_Skille
	g_Att = g_Att + g_Skille
	PRINTRoundDetail(printAllCard().." ���ʩ�ż��� �ĵ�:"..g_Skille)
end


--Replace �� t��[1]Ԫ���� tparam1��sum�Ƚ�,ȡֵ����滻t[1]
--���treturnΪ����ֱ�Ӳ���
function Replace(t,tparam1)
	if #t == 0 then
		t[1] = tparam1
		return
	end
	
	local sumt1 = 0
	local sumparam = 0
	for i,v in pairs(t[1]) do
		sumt1 = sumt1 + v
	end	

	for i,v in pairs(tparam1) do
		sumparam = sumparam + v
	end
		
	if sumt1 < sumparam then
		t[1] = tparam1
		return
	end	
end					
						
--���� 1�������� 2���Ʊ� , ����1����ӽ�E�Ĵ����
function digui(e,t)
	local treturn = {}
	--[[
	if t == nil then
		return nil
	end--]]
		
	if e == 0 then
		return {999}
	end
	
	if e < 0 then
		return nil
	end
	
	if #t == 0 then	
		return {999}
	end
	
	if #t == 1 and t[1] <= e then
		return {{t[1]},999}
	end	
	
	if #t == 1 and t[1] > e then
		return {999}
	end
	
	for i,v in pairs(t) do
		
		--ȡ����һ��ֵ��Ϊ����
		local eplus = t[i]
		
		local tleft = {}
		--����ʣ��t
		for j=i+1,#t do
			table.insert(tleft,t[j])
		end
		
		--һ�ſ��ʹﵽE
		if eplus == e then
			return {{eplus},999} 
		end
		
		local tAllPosible = digui(e-eplus,tleft)  --{{min1,min2,min3},999}  or {999}
		if tAllPosible ~= nil then --{}	
			for x,v in pairs(tAllPosible) do
				local summax = eplus;
				
				--�޷�ϸ��ʱ
				if 999 == v then				
					Replace(treturn,{eplus})
				else				
					--��Ϊ�ݹ�ֻ�������2��Ԫ�ر� min�� ��999 
					--������min��ʱ,������tRETURN��������Ԫ��
					--����treturn�������Ҳ�� min�� ��999 					
					local tmp = v
					
					--��eplus���¼������
					table.insert(tmp,eplus)				
					Replace(treturn,tmp)
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
	return s.." �������:"..g_Att
end

--����
function TakeOneCard()
	if #tCardRandom <= 0 then
		PRINTRoundDetail(printAllCard().." û����!!")
		return
	end
	
	local ecard  = tCardRandom[1];
	table.insert(g_tcardLeft,ecard);
	table.remove(tCardRandom,1);
	
	PRINTRoundDetail(printAllCard().." �鵽"..ecard.."�ǿ�")
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
	PRINTRoundDetail(printAllCard().." ���ʹ�ÿ���:"..s)
end

--�ÿ�����	�������� �������������Ϳ�Ƭ��(�������������Ϊ׼��)
function Stragy(e)
	if e <= 0 then
		return 0,nil
	end
	
	--���Ʊ�
	local tabletmp = {}
	for i,v in pairs(g_tcardLeft) do
		table.insert(tabletmp,v)
	end
	
	
	--�ҳ���������ӽ�e�Ľ�
	local test = digui(e,g_tcardLeft)
	--test = { {1,3,4},999}
	if test[1] == 999 then
		return 0,nil
	else
		local EmaxSpell = 0
		for i,v in pairs(test[1])do
			EmaxSpell = EmaxSpell + v
		end			
		return EmaxSpell,test[1]
	end	
end


function mainloop(nRound)
--��ʼ��	
g_Att = 0
g_Energy = 0
	
--��3����
TakeOneCard();
TakeOneCard();
TakeOneCard();

--��ұ������������������0�Ŀ�����ʱ�����㣩
local E_Fire = 0



for round = 1,nRound do
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
	PRINTRoundDetail(printAllCard().." ��"..round.."�غ� ")
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
		g_Att = g_Att + EA	-g_Skille
	--��EA >= EB�� ѡ1 ����ѡ2
	elseif EA >= EB then
		PlayerSpell()
		UseCard(tcardUseA)
		g_Att = g_Att + EA	-g_Skille
	else
		UseCard(tcardUseB)
		g_Att = g_Att + EB		
	end
end
end


local wucha = 0
local minShuchu = 999

while(1)do
	tCardGroup = {}
	UserSetting()

	for nRoundSet = minR,maxR do
		local sum = 0
		for i=1,g_TestTime do
			InitCardGroup()
			mainloop(nRoundSet);
			--print("��"..i.."�ֹ��������:"..g_Att)
			sum = sum + g_Att
			
			if g_Att < minShuchu  then
				minShuchu = g_Att
			end
		end
		PINGJUN = sum/g_TestTime
		print("���׿�����("..nRoundSet.."�غ�)����ƽ���������:"..PINGJUN.." ��С���:"..minShuchu)
	end	
end
--]]5691513








