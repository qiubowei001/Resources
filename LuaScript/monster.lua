monster = {}

monsterInfo = {
	HP =1,
	ATT =2,	
	BUFFATT = 4,
	MAGIC = 5,
	MAGIC_ROUND =6,
}
local g_hplabeltag =100;
local g_attlabeltag = 101;

local MONSTER_TYPE = {}

	MONSTER_TYPE[1] = {}
	MONSTER_TYPE[1]["name"] = "Slimegreen"
	MONSTER_TYPE[1]["MAgic"] = nil--{7} --�����б�
	MONSTER_TYPE[1]["HP"] = 10
	MONSTER_TYPE[1]["HPadj"] = 3
	MONSTER_TYPE[1]["PICID"] = 1
	MONSTER_TYPE[1]["ScarePICID"] = 8
	
	
	MONSTER_TYPE[2] = {}
	MONSTER_TYPE[2]["name"] = "Slimered"
	MONSTER_TYPE[2]["MAgic"] = nil--{7} --�����б�
	MONSTER_TYPE[2]["HP"] = 10
	MONSTER_TYPE[2]["HPadj"] = 3
	MONSTER_TYPE[2]["PICID"] = 1
	MONSTER_TYPE[2]["ScarePICID"] = 8
	
	MONSTER_TYPE[3] = {}
	MONSTER_TYPE[3]["name"] = "Slimeblue"
	MONSTER_TYPE[3]["MAgic"] = nil--{7} --�����б�
	MONSTER_TYPE[3]["HP"] = 10
	MONSTER_TYPE[3]["HPadj"] = 3
	MONSTER_TYPE[3]["PICID"] = 1
	MONSTER_TYPE[3]["ScarePICID"] = 8
	
	MONSTER_TYPE[4] = {}
	MONSTER_TYPE[4]["name"] = "SlimeKing"
	MONSTER_TYPE[4]["MAgic"] = {1007} --�����б�
	MONSTER_TYPE[4]["MAgicRound"] = {1} 
	MONSTER_TYPE[4]["HP"] = 10
	MONSTER_TYPE[4]["HPadj"] = 3
	MONSTER_TYPE[4]["PICID"] = 9
	MONSTER_TYPE[4]["ScarePICID"] = 10
	
	MONSTER_TYPE[5] = {}
	MONSTER_TYPE[5]["name"] = "FireSpider"
	MONSTER_TYPE[5]["MAgic"] = {1008} --�����б�
	MONSTER_TYPE[5]["MAgicRound"] = {999} --����
	MONSTER_TYPE[5]["HP"] = 10
	MONSTER_TYPE[5]["HPadj"] = 3
	MONSTER_TYPE[5]["PICID"] = 11
	MONSTER_TYPE[5]["ScarePICID"] = 12
	
	MONSTER_TYPE[6] = {}
	MONSTER_TYPE[6]["name"] = "littleFireSpider"
	MONSTER_TYPE[6]["MAgic"] = nil
	MONSTER_TYPE[6]["HP"] = 10
	MONSTER_TYPE[6]["HPadj"] = 3
	MONSTER_TYPE[6]["PICID"] = 13
	MONSTER_TYPE[6]["ScarePICID"] = 14
	
	MONSTER_TYPE[7] = {}
	MONSTER_TYPE[7]["name"] = "FrozenEye"
	MONSTER_TYPE[7]["MAgic"] = {1009} --�����б�
	MONSTER_TYPE[7]["MAgicRound"] = {999} --����
	MONSTER_TYPE[7]["HP"] = 10
	MONSTER_TYPE[7]["HPadj"] = 3
	MONSTER_TYPE[7]["PICID"] = 1
	MONSTER_TYPE[7]["ScarePICID"] = 8
	
	MONSTER_TYPE[8] = {}
	MONSTER_TYPE[8]["name"] = "FireEye"
	MONSTER_TYPE[8]["MAgic"] = {1010} --�����б�
	MONSTER_TYPE[8]["MAgicRound"] = {1} --����
	MONSTER_TYPE[8]["HP"] = 10
	MONSTER_TYPE[8]["HPadj"] = 3
	MONSTER_TYPE[8]["PICID"] = 1
	MONSTER_TYPE[8]["ScarePICID"] = 8
	
	MONSTER_TYPE[9] = {}
	MONSTER_TYPE[9]["name"] = "Bat"
	MONSTER_TYPE[9]["MAgic"] = {1011} --�����б�
	MONSTER_TYPE[9]["MAgicRound"] = {1} --����
	MONSTER_TYPE[9]["HP"] = 10
	MONSTER_TYPE[9]["HPadj"] = 3
	MONSTER_TYPE[9]["PICID"] = 15
	MONSTER_TYPE[9]["ScarePICID"] = 16
	
	MONSTER_TYPE[10] = {}
	MONSTER_TYPE[10]["name"] = "wizard"
	MONSTER_TYPE[10]["MAgic"] = {1012} --�����б�
	MONSTER_TYPE[10]["MAgicRound"] = {999} --����
	MONSTER_TYPE[10]["HP"] = 10
	MONSTER_TYPE[10]["HPadj"] = 3
	MONSTER_TYPE[10]["PICID"] = 1
	MONSTER_TYPE[10]["ScarePICID"] = 8
	
	
function monster.GetPicIdFromMonsterId(nMonsterId)
	cclog("GetPicIdFromMonsterId:"..nMonsterId)
	return MONSTER_TYPE[nMonsterId]["PICID"]	
end
	
function monster.GetScarePicIdFromMonsterId(nMonsterId)
	return MONSTER_TYPE[nMonsterId]["ScarePICID"]	
end
	
--��ʼ����������
function monster.InitMonster( pBrick,nid)
		pBrick.monsterId = nid
		pBrick.moninfo = 
		{
		[monsterInfo.HP] = MONSTER_TYPE[nid]["HP"] + math.random(-MONSTER_TYPE[nid]["HPadj"],MONSTER_TYPE[nid]["HPadj"]),
		[monsterInfo.ATT] = 1,
		[monsterInfo.BUFFATT] = 0,
		[monsterInfo.MAGIC] = MONSTER_TYPE[nid]["MAgic"],

		}

		if pBrick.moninfo[monsterInfo.MAGIC]~= nil then
			pBrick.moninfo[monsterInfo.MAGIC_ROUND] = {}
			for i,v in pairs(MONSTER_TYPE[nid]["MAgicRound"])do
				pBrick.moninfo[monsterInfo.MAGIC_ROUND][i] = v;
			end
		end
		
		
		
		
		
		
			local hpLabel = CCLabelTTF:create(pBrick.moninfo[monsterInfo.HP], "Arial", 35)
			pBrick:addChild(hpLabel)
			hpLabel:setColor(ccc3(255,255,0))
			hpLabel:setPosition(brickInfo.brickWidth/3, brickInfo.brickWidth/3)
			hpLabel:setTag(g_hplabeltag);
			
			local AttLabel = CCLabelTTF:create(pBrick.moninfo[monsterInfo.ATT], "Arial", 35)
			pBrick:addChild(AttLabel)
			AttLabel:setColor(ccc3(0,0,0))
			AttLabel:setPosition(brickInfo.brickWidth/3, brickInfo.brickWidth*2/3)
			AttLabel:setTag(g_attlabeltag);
			
			
			pBrick.IsSpelled = false;
			
			pBrick.AttAdjFuncT = {};
			pBrick.DamageAdjFuncT = {};
			
			
end

--�޸Ĺ�������
function monster.AddHp(pmonster,nRecovery)
	pmonster.moninfo[monsterInfo.HP]  = pmonster.moninfo[monsterInfo.HP]  + nRecovery
	local hplabel = pmonster:getChildByTag(g_hplabeltag)
	tolua.cast(hplabel, "CCLabelTTF")
	hplabel:setString(pmonster.moninfo[monsterInfo.HP] )
	
	if pmonster.moninfo[monsterInfo.HP] <= 0 then
		Main.destroyBrick(pmonster.TileX,pmonster.TileY)
	end	
end


--�˺�ACTION��ʼ��
function monster.InitDamageAction( pTarget,ndamage)
	local tDamageAction = {
							defender = pTarget,
							damage = ndamage,
						
							}
	return tDamageAction;
end

--�˺�����
function monster.damage( pBrick,nDamage)
		local tDamageAction = monster.InitDamageAction( pBrick,nDamage);
		
		
		for i,func in pairs(pBrick.DamageAdjFuncT) do
			func(tDamageAction)
		end
		
		local ndamage =  tDamageAction.damage
		local defender = tDamageAction.defender
		
		if defender ~= nil then 
			defender.moninfo[monsterInfo.HP]  = defender.moninfo[monsterInfo.HP]  - ndamage
			local hplabel = defender:getChildByTag(g_hplabeltag)
			tolua.cast(hplabel, "CCLabelTTF")
			hplabel:setString(defender.moninfo[monsterInfo.HP] )
		
			if defender.moninfo[monsterInfo.HP] <= 0 then
				
				--ִ����������
				--monster.PlayDeathAnimation(pBrick);
				monster.PlayCriticalHitAnimation(pBrick);
				
				Main.destroyBrick(defender.TileX,defender.TileY,false)
				
				
				
				--��ҫ@ȡ���
				player.GainEXP(1);
			end
		end	
end



--���﹥��ACTION��ʼ��
function monster.InitAttAction( pTarget,ndamage,pmonster)
	local tAttAction = {
							defender = pTarget,
							damage = ndamage,
							attacker = pmonster,
						}
	return tAttAction;
end

--���﹥��
function monster.attack()
	local ndamage = 0;
	for i = 1,brickInfo.brick_num_X do
	
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then
				if Board[i][j].nType == tbrickType.MONSTER then
					
					
					local tAttAction = monster.InitAttAction( player,ndamage,Board[i][j])
					tAttAction.damage = monster.GetMonsterAtt(Board[i][j])--Board[i][j].moninfo[monsterInfo.ATT];
					
					--�������﹥����������
					for k,func in pairs(Board[i][j].AttAdjFuncT) do
						func(tAttAction)
					end
					
					player.takedamage(tAttAction.damage,Board[i][j]);
				end				
			end
		end
	end
	--cclog(" return ndamage:"..ndamage)
	return ndamage;
	
end



--ÿ�γ���ˢ�¹�������������ʩ�ż��ܡ����������� ʣ���ͷŴ�������0���ͷţ���-1, 
--������ڳ���ʱ ��ֱ��ִ��EFF
function monster.SpellMagic(pmonster,IfBorn)
	--�ڶ����������Կ��������ж� 
	--��ͬ������������ͬ���� 
	--����ֻ����SINGLE_BRICK����	
	if pmonster.moninfo[monsterInfo.MAGIC] ~= nil then	
		for i,nid in pairs(pmonster.moninfo[monsterInfo.MAGIC]) do
			local spelltime =  pmonster.moninfo[monsterInfo.MAGIC_ROUND][i];
			
			if spelltime > 0 then
				
				--if pmonster.IsSpelled == false then
					--���غϻ�δʩ�ż���
					local tTargetList,tEffList = magic.SpellMagic(nid,pmonster);
					pmonster.moninfo[monsterInfo.MAGIC_ROUND][i]= pmonster.moninfo[monsterInfo.MAGIC_ROUND][i]-1;
					pmonster.IsSpelled = true;
					
					--���＼����Ч�Ƿ���Ҫ���ϴ���
					if magic.GetMagicDoeffAfterSpell(nid) ==true and IfBorn== true then
						for j,v in pairs(tTargetList) do
							local effT = tEffList[j];
							local effid = magictable[nid][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]
							local efffunc = MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.EFF_FUNC]
							efffunc(v,MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.TPARAM])

							--��ȡ����EFFTABLE ROUND --
							effT[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = effT[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
						end
					end
				--end
			end
		end		
	end
end


--��ȡ���﹥����
function monster.GetMonsterAtt(pmonster)
	local att = pmonster.moninfo[monsterInfo.ATT] + pmonster.moninfo[monsterInfo.BUFFATT] ;
	
	--[[
	for i,func in pairs(pmonster.AttAdjFuncT) do
		att = func(att)
		
		--������Ч�򷵻�
		if att == false then
			att = 0;
			break
		end
	end--]]
	
	return  att;
end

function monster.AddAttAdjFunc(pmonster,fAttAdjFunc,id)
	pmonster.AttAdjFuncT[id] = fAttAdjFunc
end

function monster.RemoveAdjFunc(pmonster,id)
    pmonster.AttAdjFuncT[id] = nil
end
	
	
function monster.AddDamageAdjFunc(pmonster,fDamageAdjFunc,id)
	pmonster.DamageAdjFuncT[id] = fDamageAdjFunc
end

function monster.RemoveDamageAdjFunc(pmonster,id)
    pmonster.DamageAdjFuncT[id] = nil
end	
	

--��ȡ����ͼ��·��
function monster.GetMonsterIconPath(nMonsterId)
	
	return "brick/monster/monster"..nMonsterId..".png";
end

--��ͨ���� ��� ����
function monster.PlayDeathAnimation(pBrick)
	brick.setUnChosed(pBrick)
	brick.removedeatheff(pBrick)

	local parent = pBrick:getParent()
	--���õ�����
	parent:reorderChild(pBrick, 1000)
 	
	local mainsprite = brick.GetMainSprite(pBrick)
	pBrick:setOpacity(0)

	local array = CCArray:create()
	array:addObject(CCScaleBy:create(1, 1.5))
	array:addObject(CCCallFuncN:create(function(sender)  
											sender:removeFromParentAndCleanup(true);
											end ) )
    local action = CCSequence:create(array)

	local fadeaction  = CCFadeOut:create(1)
	
	
	pBrick:runAction(action)	
	mainsprite:runAction(fadeaction)	
end

function monster.PlayCriticalHitAnimation(pBrick)
	brick.setUnChosed(pBrick)
	brick.setdeatheffect(pBrick)
	
	local parent = pBrick:getParent()
	--���õ�����
	parent:reorderChild(pBrick, 1000)
 	
	--��ȡ����·��
	local tPosition = monster.GetFlyPositionBorder(pBrick)
	local arr = CCArray:create()
	local action = CCMoveBy:create(0.5, CCPointMake(0, 50));
	arr:addObject(action)		
		
	local lastx,lasty = 0, 0
	local velocity = 800;
	
	for i,v in pairs(tPosition) do
		if i ~=1 then		
			--�������
			local l = (v[1]-lastx)*(v[1]-lastx) + (v[2]-lasty)*(v[2]-lasty)
			local t = math.sqrt(l) / velocity;
			
			local action = CCMoveTo:create(t, CCPointMake(v[1]+100, v[2]));
			arr:addObject(action)
		end
		lastx = v[1];
		lasty = v[2];
	end
	arr:addObject(CCCallFuncN:create(function(sender)  
											sender:removeFromParentAndCleanup(true);
											end ) )
	local  seq = CCSequence:create(arr)
	pBrick:runAction(seq)
	
	local rotatedir = 0
	
	if math.random(1,2) == 1 then
		rotatedir = 360
	else
		rotatedir = -360
	end
	
	local rotate = CCRotateBy:create(0.2, rotatedir)
    local action = CCRepeatForever:create(rotate)
	pBrick:runAction(action)
	
end


local tRusheToFansheFunc = {}
			--��߽�
		  tRusheToFansheFunc[1] = function(RVec)
									local FVec = {-RVec[1],RVec[2]};
									return FVec;
								end
			--�ұ�					
		  tRusheToFansheFunc[2] = function(RVec)
									local FVec = {-RVec[1],RVec[2]};
									return FVec;
								end
			--�ϱ�					
		  tRusheToFansheFunc[3] = function(RVec)
									local FVec = {RVec[1],-RVec[2]};
									return FVec;
								end								
			--�±�					
		  tRusheToFansheFunc[4] = function(RVec)
									local FVec = {RVec[1],-RVec[2]};
									return FVec;
								end								

--��ȡ����·��
function monster.GetFlyPositionBorder(pBrick)
	--�����һ��ײ��
	local boardW = brickInfo.brick_num_X*brickInfo.brickWidth
	local boardH = brickInfo.brick_num_Y*brickInfo.brickHeight
	local x = 0
	local y = 0
	
	local originx,originy = pBrick:getPosition();
	
	local tPosition = {}
	local nrandomBoard = math.random(1,4)
	if nrandomBoard ==1 then
		--��߽�
		x =  0
		y =  math.random(1,boardH-1)
	elseif nrandomBoard ==2 then
		--�ұ�
		x =  boardW
		y =  math.random(1,boardH-1)		
		
	elseif nrandomBoard ==3 then
		--��
		x =  math.random(1,boardW-1)	
		y =  boardH	
		
	else
		--��
		x =  math.random(1,boardW-1)	
		y =  0		
	end
	
	table.insert(tPosition,{originx,originy,nil})
	table.insert(tPosition,{x,y,nrandomBoard})
			
	--���÷������
	local nCount = 3
	for i = 1,nCount do 
		local nHitBoard = tPosition[i+1][3]--ײ���߽�
		--�ó��������� 
		
		local tRusheVec = {tPosition[i+1][1] - tPosition[i][1],tPosition[i+1][2] - tPosition[i][2]}	
		--�ó���������
		local tFanSheVec = tRusheToFansheFunc[nHitBoard](tRusheVec)
		
		
		local PositionOri = tPosition[i+1]
		
		--���ݷ����ͷ�������*ϵ�� ȷ���·���㣨ϵ������0����С��
		--�����������ֱ��ˮƽ����
		--�������	
		K1 = - PositionOri[1]/tFanSheVec[1]
		--�ұ�
		K2 = (boardW - PositionOri[1])/tFanSheVec[1]
		--��
		K3= (boardH- PositionOri[2])/tFanSheVec[2]		
		--��
		
		K4 = - PositionOri[2]/tFanSheVec[2]
		local t = {}
		local K = nil;
		table.insert(t,K1);
		table.insert(t,K2);
		table.insert(t,K3);
		table.insert(t,K4);
		
		
		for i,KTmp in pairs(t) do
			if KTmp > 0  then
				if K == nil or KTmp < K then
					K = KTmp	
					nHitBoard = i
				end
			end
		end	
		
		--�ó���һ����ײ������
		if i==nCount then
			K = 1.2*K
		end
		
		xNext = PositionOri[1]+ tFanSheVec[1]*K
		yNext = PositionOri[2]+ tFanSheVec[2]*K
		table.insert(tPosition,{xNext,yNext,nHitBoard})
	end	
	
	
	return tPosition;
end

















