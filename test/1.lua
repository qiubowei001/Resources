	--[[
	Cardnum = 2
	e = 5
	
	t = {1,3,4,2,7}
	
	local eNear = 0
		--�ҳ���������ӽ�e�Ľ�
		--for Cardnum = 1,#t do
			for index,ecard in pairs(t) do
				local plus1 = ecard
				local plus1index = index
				for	i = Cardnum-1,1,-1 do
					t[]
				end			
			end
		--end
		
		--]]

--���� 1�������� 2���Ʊ� , �������п��ܴ����
function digui(e,t)

	local treturn = {}
		--[[
	if e <= 0 then
		return {}
	end]]
	if t ==nil then
		return nil
	end
		
	if #t == 0 then	
		return {}
	end
	
	if #t == 1 then
		return {t[1],999}
	end
	
	
	for i,v in pairs(t) do
		
		--ȡ����һ��ֵ��Ϊ����
		local eplus = t[i]
		
		local tleft = {}
		--����t
		for i=2,#t do
			table.insert(tleft,t[i])
		end

		local tAllPosible = digui(e-eplus,tleft)
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
	
	return treturn
end

e = 7
--t = {1,3,4,2,7}
t = {9,5,4,1}
Cardnum = 2
--�ҳ�2���������ӽ�7
--ȡ�����п��ܵ��������
local tAll = {}
local test = digui(e,t)

for i,v in pairs(test) do
	local s = ""
	for j,e in pairs(v)do
		s = s.." "..e
	end
	print(i.." "..s)
end


