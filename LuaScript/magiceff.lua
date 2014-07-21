magiceff = {}
local p = magiceff;

--������Ч�����
MAGIC_EFF_DEF_TABLE = {
	ID =1,
	DESCPTION = 2,
	EFF_PIC = 3,
	EFF_FUNC =4,
	CLEAR_EFF_FUNC =5,
	LAST_ROUNDS =6,
	TPARAM=7,
	B_IF_TRIGER_AFTER_PLAYER_ACT = 8,--�������Ϊ�󴥷�  ���ǹ�����Ϊ�󴥷�
}




--============================�������EFFFUNC============================---
--��ǿBRICK������
function p.eff01(pobj,Tparam1)
			cclog("add atk to player")
				--==��ʾ�������==--
			player[playerInfo.BUFFATT] =  player[playerInfo.Entity_ATT]*0.3 --Tparam1.addAttack;		
			player.UpdateEntityData();
end

function p.effclr01()
			cclog("remove atk from player")
			player[playerInfo.BUFFATT] = 0;
				--==��ʾ�������==--
			player.UpdateEntityData();
			Hint.ShowHint(Hint.tHintType.powerdown)	
end



--��MON��ɶ��˺�
function p.eff02(pobj,Tparam1)
	if pobj == nil then
		return
	end
	local param1 = Tparam1.damage;
	if pobj.nType == tbrickType.MONSTER then
		--ÿ�ο�Ѫ80%
		local monsterhpmax = pobj.moninfo[monsterInfo.HPMAX]
		local ndamage = monsterhpmax*0.8
		monster.damage(pobj,ndamage)
	end
end

function p.effclr02(pobj)
	--ȥ����Ч
	Particle.RemoveParticleEffFromBrick(pobj,"poison");
end


--brick(p1)ת��Ϊbrick(p2)
function p.eff03(pbrick,Tparam1)
	local brickTo = nil;
	local fromType = Tparam1.fromType;
	local nToType  = Tparam1.nToType;
	
	
	if pbrick.nType ~= fromType or pbrick.nType == nToType then
		return;
	end
	
	local tileX = pbrick.TileX
	local tileY = pbrick.TileY
	if nToType == tbrickType.MONSTER then
		Particle.AddParticleEffToWorld(pbrick,"shineSporn")
		brickTo = brick.creatMonster(nToType,pbrick.pBrickSpellLev)
	elseif nToType == tbrickType.GOLD then
		--���Ź�Ч
		Particle.AddParticleEffToWorld(pbrick,"shine")
		brickTo = brick.creatGoldBrick(nToType)
	else
		--���Ź�Ч
		Particle.AddParticleEffToWorld(pbrick,"shineRed")
		brickTo = brick.creatBrick(nToType)
	end
	
			


	
	Main.brickSetXY(brickTo,tileX,tileY)
	--Board[tileX][tileY] = brickTo;
	pbrick:removeFromParentAndCleanup(true);
		
end


--��pbrickΪ����������ΧBRICK   nR= �뾶(���ĵ㵽�߽��TILE���� ��0���ʾ���ĵ�  1Ϊ3X3����)
function p.eff04(pbrick,tparam1)
	local nR = tparam1.R

	local tileX = pbrick.TileX
	local tileY = pbrick.TileY
	
	function getFromTo(cord,Limit)
		local from = cord - nR
		local To = cord + nR
		if from <= 1 then
			from = 1
		end
		if To >= Limit then
			To = Limit
		end
		return from,To
	end
	
	local fromx,tox = getFromTo(tileX,brickInfo.brick_num_X)
	local fromy,toy = getFromTo(tileY,brickInfo.brick_num_Y)
	
	--��λ���ϲ��ű�ը��Ч
	Particle.AddParticleEffToWorld(pbrick,"explode")
				
	for X = fromx,tox,1 do
		for Y = fromy ,toy,1 do
			if Board[X][Y]~= nil then
				
				--����ǹ���������˺�
				if Board[X][Y].nType == tbrickType.MONSTER then
					monster.damage(Board[X][Y],999)
				else
					Main.destroyBrick(X,Y)
				end
			end
		end
	end	
end


--��ѡ��������ѣ��
function p.eff05(pbrick,tparam1)
	local nR = tparam1.R
	local tileX = pbrick.TileX
	local tileY = pbrick.TileY
	
	function getFromTo(cord,Limit)
		local from = cord - nR
		local To = cord + nR
		if from <= 1 then
			from = 1
		end
		if To >= Limit then
			To = Limit
		end
		return from,To
	end
	
	local fromx,tox = getFromTo(tileX,brickInfo.brick_num_X)
	local fromy,toy = getFromTo(tileY,brickInfo.brick_num_Y)
	
	
	for X = fromx,tox,1 do
		for Y = fromy ,toy,1 do
			if Board[X][Y]~= nil then
				
				if Board[X][Y].nType == tbrickType.MONSTER then
					--��Ч
					pbrick.IfBeStunned = true;
					monster.AddAttAdjFunc(pbrick,
										function(tAttAction)
												return false;--������
											end
											,5)
				end
			end
		end
	end	
end


function p.effclr05(pObj)
	--��Ч
	Particle.RemoveParticleEffFromBrick(pObj,"star")
	pObj.IfBeStunned = true;										
	monster.RemoveAdjFunc(pObj,5)
end



--�����Ѫ
function p.eff06(player,tparam1)
	local nAttDamage = tParamEvn.playerAttDamageThisRound;
	local rate = tparam1.rate
	local recovery = math.floor(nAttDamage*rate)
	player.AddHp(recovery)
end


--��ҷ���
function p.eff07(player,tparam1)
	local rate = tparam1.rate
	
	player.AddDamageAdjFunc(function(tDamageAction)
								local ndamage = tDamageAction.damage;
								
								local pmonster = tDamageAction.attacker;
									  
								monster.AddHp(pmonster,-rate*ndamage);
							end
							,7)
end

function p.effclr07(pObj)
	player.RemoveDamageAdjFunc(7)
end


--������
function p.eff08(pbrick,tparam1)
	local nLinkNum = tparam1.LinkNum
	
	--��ȡ���й���
	local monsterlist = Main.GetMonsterList()
	
	for i,v in pairs(monsterlist) do
		if pbrick == v then
			table.remove(monsterlist,i)
			break
		end
	end
	
	
	local monsterlistSpelled = {[1] = pbrick}
	
	--�����ȡN��
	if nLinkNum > #monsterlist then
		nLinkNum = #monsterlist	
	end
	
	if nLinkNum > 0 then
		for i=1,nLinkNum do

			
			local nindex = math.random(1,#monsterlist)
			local pTmpMonster = monsterlist[nindex]
			
			table.insert(monsterlistSpelled,pTmpMonster)
			table.remove(monsterlist,nindex)		
		end
	end	
	
	---���б�monsterlistSpelled�����й���ʩ������
	
	
	--ײ������
	function gethit(sender)
		local x,y = sender:getPosition();
		local X,Y = Main.getTileXY(x,y)
		local pbrick = Board[X][Y]
		
		if pbrick ~= nil then
			if pbrick.nType == tbrickType.MONSTER then
				monster.damage(pbrick,math.random(5,100),false)
			end
		end	
	end
	

	--��������Ч��
	Particle.AddParticleEffToLine(monsterlistSpelled,"ThunderChain",gethit)
end


function p.eff13(player,tparam1)
	local rate = tparam1.rate
			
	 player.AddAttAdjFunc(function(tAttAction)
								tAttAction.criticalchance = 3*tAttAction.criticalchance
						  end
							,13)
end

function p.effclr13(pObj)
	Hint.ShowHint(Hint.tHintType.criticalDown)
	
	player.RemoveAdjFunc(13)
end

function p.eff14(player,tparam1)
	local rate = tparam1.rate
	
	 player.AddDamageAdjFunc(
							function(tDamageAction)
								tDamageAction.dodgechance = tDamageAction.dodgechance*3;
							end
							,14)
end

function p.effclr14(pObj)
	Hint.ShowHint(Hint.tHintType.dodgedown)
	
	player.RemoveDamageAdjFunc(14)
end

--������Ϸ�ٶ�
function p.eff15(pobj,Tparam1)
	CCDirector:sharedDirector():getScheduler():setTimeScale(0.5);
end

function p.effclr15()
	CCDirector:sharedDirector():getScheduler():setTimeScale(1);
end




--����ɱ
function p.eff16(pobj)
	--������brickִ������
	local Y = pobj.TileY
	for i=1,brickInfo.brick_num_X do
		--(Board[i][Y]):removeFromParentAndCleanup(true);
		Main.destroyBrick(i,Y,true)
	end
end

--ʮ��ɱ
function p.eff17(pobj)
	--������brickִ������
	local Y = pobj.TileY
	local X = pobj.TileX
	for i=1,brickInfo.brick_num_X do
		--(Board[i][Y]):removeFromParentAndCleanup(true);
		Main.destroyBrick(i,Y,true)
	end
	
	for i=1,brickInfo.brick_num_Y do
		--(Board[i][Y]):removeFromParentAndCleanup(true);
		if i ~= Y then
			Main.destroyBrick(X,i,true)
		end
	end	
	
end

---===========================���й��＼��EFFFUNC=================================--
--��ǿ����MON������
function p.eff1005(pobj,Tparam1)
			--ֻ��һ��
			local test = pobj.moninfo[monsterInfo.BUFFATT]
			if pobj.moninfo[monsterInfo.BUFFATT] >= Tparam1.addAttack then
				return
			end
			
			pobj.moninfo[monsterInfo.BUFFATT] = Tparam1.addAttack;
			monster.SetAtt(pobj);
			
			--���Ź�Ч
			Particle.AddParticleEffToBrick(pobj,"buff")
end

function p.effclr1005(pobj)
			pobj.moninfo[monsterInfo.BUFFATT] = 0;
			monster.SetAtt(pobj);			
			--local Attlabel = pobj:getChildByTag(101)
			--tolua.cast(Attlabel, "CCLabelTTF")
			--Attlabel:setString(monster.GetMonsterAtt(pobj) )
end



--brick(p1)ת��Ϊ����
function p.eff1006(pbrick,Tparam1)
	local brickTo = nil;
	local fromType = Tparam1.fromType;
	local nMonsterid  = Tparam1.nMonsterid;
	
	
	if pbrick.nType ~= fromType or pbrick.nType == tbrickType.MONSTER then
		return;
	end
	
	local tileX = pbrick.TileX
	local tileY = pbrick.TileY
	 brickTo = brick.creatMonster(nMonsterid)
	Particle.AddParticleEffToBrick(brickTo,"shineSporn")
	
	Main.brickSetXY(brickTo,tileX,tileY)
	--Board[tileX][tileY] = brickTo;
	pbrick:removeFromParentAndCleanup(true);
end

--����brick(p1) 
function p.eff1007(pbrick,Tparam1)
	if pbrick.IsAbleLink == false then
		return
	end
	Particle.AddParticleEffToBrick(pbrick,"ice")
	pbrick.IsAbleLink = false;
end

function p.effclr1007(pobj)
	pobj.IsAbleLink = true;
end



--���
function p.eff1008(pbrick,Tparam1)
	Particle.AddParticleEffToBrick(pbrick,"firewall")	
	monster.AddDamageAdjFunc(pbrick,
							function(tDamageAction)
								player.AddHp(-10)
								
							end
							,1008)
end

function p.effclr1008(pObj)
	Particle.RemoveParticleEffFromBrick(pObj,"firewall");
	monster.RemoveDamageAdjFunc(pObj,1008)
end

--��Ѫ
function p.eff1009(pbrick,Tparam1)
	local rate = Tparam1.rate
	monster.AddAttAdjFunc(pbrick,
							function(tAttAction)
								--������Ч
								Particle.AddParticleEffToBrick(tAttAction.attacker,"suckblood")									
								local nRecovery = tAttAction.damage*rate
								monster.AddHp(tAttAction.attacker,nRecovery)
							end
							,1009)
end

function p.effclr1009(pObj)
	monster.RemoveAdjFunc(pObj,1009)
end

--��Ѫ
function p.eff1012(pbrick,Tparam1)
	Particle.AddParticleEffToBrick(pbrick,"recovery")									
	if pbrick.nType == tbrickType.MONSTER then
		local nrecovery = Tparam1.recovery;
		monster.AddHp(pbrick,nrecovery)
	end
end


--���S
function p.eff1014(player,tParam,self)
	if self == nil then
		return 
	end	
	
	player.TauntedByMon = self  --��׃��ҳ��S����
	
	
	function removeTaunedMon()
		player.TauntedByMon = nil;
	end
	monster.AddDeathFunc(self,removeTaunedMon,1014) --���������������ҳ��S����
end	

--��ŭ
function p.eff1016(self)
	if self==nil then
		return
	end
	
	local typeid = self.monsterId;
	local level = self.moninfo[monsterInfo.LEV];
	
	local brickWidth = brickInfo.brickWidth ;
	local brickHeight = brickInfo.brickHeight;
	local MainSpritetag = 3003;
	self:removeChildByTag(MainSpritetag, true)
	local spriteBrick = nil;
				
	if self.moninfo[monsterInfo.HP] >= self.moninfo[monsterInfo.HPMAX] then
		--�ظ�ԭ״
		local CDMAX = MONSTER_TYPE[typeid]["CD"] + level*MONSTER_TYPE[typeid]["CDGrow"]
		self.moninfo[monsterInfo.CDMAX] = CDMAX
		spriteBrick = SpriteManager.creatBrickSprite(28)
	else
		--����
		local CDMAX =  MONSTER_TYPE[typeid]["CD"] + level*MONSTER_TYPE[typeid]["CDGrow"]
		CDMAX = CDMAX/3
		self.moninfo[monsterInfo.CDMAX] = CDMAX
		spriteBrick = SpriteManager.creatBrickSprite(29)
	end
	
	self:addChild(spriteBrick)
	spriteBrick:setTag(MainSpritetag)
	spriteBrick:setPosition(CCPointMake(brickWidth/2 , brickHeight/2))
end


--�Ա�
function p.eff1017(self,tParam)
	if self==nil then
		return
	end

	--��λ���ϲ��ű�ը��Ч
	Particle.AddParticleEffToWorld(self,"explode")
	
	--{ dmgPerLevel = 5 ,dmgBase = 10} 
	local level = self.moninfo[monsterInfo.LEV];
	local dmg = tParam.dmgBase  + tParam.dmgPerLevel*level
	player.takedamage(dmg,self);	
	
	monster.damage( self,9999,false)
end

--��ħ
function p.eff1018(pbrick,Tparam1)
	local rate = Tparam1.rate
	monster.AddAttAdjFunc(pbrick,
							function(tAttAction)
								--������Ч
								Particle.AddParticleEffToBrick(tAttAction.attacker,"suckenergy")									
								local nRecovery = tAttAction.damage*rate
								--��������
								player.SpendEnergy(nRecovery);	
							end
							,1018)
end

--�ƻ�
function p.eff1019(pbrick,Tparam1)
	--�ƻ�����
	local rate = Tparam1.rate
	
	monster.AddAttAdjFunc(pbrick,
							function(tAttAction)
								
								--Particle.AddParticleEffToBrick(tAttAction.attacker,"suckblood")	
								local t = player.GetPlayerEquip()								
								local nEquipId = t[math.random(1,#t)]
								
								local lastequipid = 0
								if (nEquipId )%1000 - 1 > 0 then
									lastequipid =  nEquipId  - 1
									local equiptype = tEquipType[lastequipid][3]
									local tTmp = {
										playerInfo.WEAPON 	,
										playerInfo.ARMOR 	,
										playerInfo.NECKLACE ,
										playerInfo.RING,
										playerInfo.CAPE,
										playerInfo.MAGICBALL,
									}
									
									local index = tTmp[equiptype];
									player[index] = lastequipid;	
									player.UpdateEntityData();
									
									--UI����
									EquipUpGradeUI.RefreshMenu()
									--������Ч
									local  emitter = Particle.AddParticleEffToWorld(pbrick,"fog")
									Particle.MoveParticleTo(emitter,nil)

								end
								
							end
							,1019)
end



--����λ��  pbrick
function p.eff1020(pbrick,Tparam1)
	
	if pbrick.IsAbleLink == false then
		return
	end
	Particle.AddParticleEffToBrick(pbrick,"ice")
	pbrick.IsAbleLink = false;
end


--������Ч���ñ�
MAGIC_EFFtable = {}
	MAGIC_EFFtable[1]={}
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.ID] = 1
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��ǿBRICK������%30 6�غ�"
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff01
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr01
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 6
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.TPARAM] = {addAttack = 5}
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	
	
	MAGIC_EFFtable[2]={}
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.ID] = 1
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��BRICK���3���˺�"
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff02
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 0
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.TPARAM] ={ damage = 3}
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[3]={}
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.ID] = 3
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.DESCPTION] = "ÿ�غ϶�BRICK���2���˺� ��5�غ�"
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff02
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr02
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 5
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.TPARAM] = { damage = 2}
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[4]={}
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.ID] = 4
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.DESCPTION] = "����ת��brickΪ���"
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff03
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.TPARAM] ={ fromType = tbrickType.MONSTER,nToType = tbrickType.GOLD}
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
		
	MAGIC_EFFtable[5]={}
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.ID] = 5
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.DESCPTION] = "����ת��brickΪѪƿ"
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff03
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.TPARAM] ={ fromType = tbrickType.MONSTER,nToType =tbrickType.BLOOD} 
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[6]={}
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.ID] = 6
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��ը"
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff04
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.TPARAM] ={R = 1}
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[7]={}
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.ID] = 7
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.DESCPTION] = "ѣ��"
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff05
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr05
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.TPARAM] ={R = 0}
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[8]={}
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.ID] = 8
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.DESCPTION] = "ѣ��"
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff05
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr05
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.TPARAM] ={R = 1}
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[9]={}
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.ID] = 9
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��Ѫ"
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff06
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 5}
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[10]={}
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.ID] = 10
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��ҷ���"
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff07
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr07
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 2}
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[11]={}
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.ID] = 11
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��������"
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff08
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.TPARAM] ={LinkNum = 5}
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[13]={}
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.ID] = 13
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��������������"
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff13
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr13
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 5
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 100}
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[14]={}
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.ID] = 14
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��������������"
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff14
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr14
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 5
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 100}
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
		
	MAGIC_EFFtable[15]={}
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.ID] = 15
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.DESCPTION] = "������Ϸ�ٶ�5�غ�"
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff15
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr15
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 5
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.TPARAM] = {addAttack = 5}
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[16]={}
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.ID] = 16
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.DESCPTION] = "����ɱ"
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff16
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr16
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.TPARAM] = {addAttack = 5}
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[17]={}
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.ID] = 17
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.DESCPTION] = "ʮ��ɱ"
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff17
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr17
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.TPARAM] = {addAttack = 5}
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	
	
	
	
	
	
	
	--==���＼��==--
	MAGIC_EFFtable[1007]={}
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.ID] = 1007
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.DESCPTION] = "���ӹ��﹥��3�غ�"
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1005
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr1005	
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 6
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.TPARAM] ={addAttack = 3}
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[1008]={}
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.ID] = 1008
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��ת������"
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 4
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1006
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.TPARAM] ={ fromType = tbrickType.SWORD,nMonsterid = 6} 
 	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
                 
	MAGIC_EFFtable[1009]={}
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.ID] = 1009
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.DESCPTION] = "����ת������"
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 2
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1007
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr1007		
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 2
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.TPARAM] =nil--{ fromType = tbrickType.SWORD,nMonsterid = 6} 
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[1010]={}
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.ID] = 1010
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.DESCPTION] = "���"
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1008	
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 999
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.TPARAM] =nil--{ fromType = tbrickType.SWORD,nMonsterid = 6} 
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[1011]={}
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.ID] = 1011
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��Ѫ"
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1009	
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 999
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.TPARAM] ={ rate = 1} 
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false

	MAGIC_EFFtable[1012]={}
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.ID] = 1012
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��Ѫ"
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1012	
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.TPARAM] ={ recovery = 5} 
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false

	MAGIC_EFFtable[1014]={}
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.ID] = 1014
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.DESCPTION] = "׌��ҏ��й�����"
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1014
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 9999
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.TPARAM] ={} 
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false

	MAGIC_EFFtable[1016]={}
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.ID] = 1016
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��Ѫ���ǿ"
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1016
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 9999
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.TPARAM] ={} 
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[1017]={}
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.ID] = 1017
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.DESCPTION] = "�Ա�"
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1017
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 9999
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.TPARAM] ={ dmgPerLevel = 5 ,dmgBase = 10} 
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[1018]={}
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.ID] = 1018
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.DESCPTION] = "��ħ"
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1018
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 999
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.TPARAM] ={ rate = 1} 
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false

	MAGIC_EFFtable[1019]={}
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.ID] = 1019
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.DESCPTION] = "�ƻ�װ��"
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1019
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 999
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.TPARAM] ={ rate = 1} 
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
                 
	MAGIC_EFFtable[1020]={}
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.ID] = 1020
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.DESCPTION] = "�������λ��"
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 2
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1020
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 2
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.TPARAM] =nil
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false		
--���� A B C D����ͬʱ��������Ļ��ϳ�Ϊһ������	
	
	
	
	

	
--Ϊ�������������Ч
function p.AddPlayerMagicEff(efffuncid)
	local effinfoT = p.createMagicEff(efffuncid);
	player.AddMagicEff(effinfoT);
	
	return effinfoT;
end

--Ϊbrick����������Ч
function p.AddBrickMagicEff(efffuncid,pbrick,nMagicId)
	if nMagicId ~= nil then
		if magictable[nMagicId][MAGIC_DEF_TABLE.SPELL_TYPE] ~= nil and magictable[nMagicId][MAGIC_DEF_TABLE.SPELL_TYPE] ~= pbrick.nType then
			return nil;
		end
	end
	
	local effinfoT = p.createMagicEff(efffuncid);
	brick.AddMagicEff(effinfoT,pbrick);
	return effinfoT;
end

--����һ��EFF���ݱ�
function p.createMagicEff(efffuncid)
	local effinfoTtmp = {}
	if MAGIC_EFFtable[efffuncid] == nil then
		return
	end
	effinfoT = MAGIC_EFFtable[efffuncid]
	for i,v in pairs(effinfoT) do
		effinfoTtmp[i] = v			
	end
	return effinfoTtmp;
end




--ִ�й�����Ϊ��ħ����Ч
function p.DoMagicEffAfterMonsterAct(pmonster)
	--��Ҽ�����Ч
	local playereffT = player.GetMagicEffTableAfterMonsterAct()
	for i,v in pairs(playereffT) do
		v[MAGIC_EFF_DEF_TABLE.EFF_FUNC](player,v[MAGIC_EFF_DEF_TABLE.TPARAM]  )--MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM1],MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM2])
		v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
	end
	--������BRICKִ����Ч
	if pmonster ~= nil then	
		local brickeffT = brick.GetMagicEffTableAfterMonsterAct(pmonster)
		if #brickeffT > 0 then
			for k,m in pairs(brickeffT) do
					if m[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] > 0 then
						m[MAGIC_EFF_DEF_TABLE.EFF_FUNC](pmonster,m[MAGIC_EFF_DEF_TABLE.TPARAM])
						m[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = m[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
					end
			end				
		end
	end
end

--ִ�������Ϊ��ħ����Ч
function p.DoMagicEff(tParam) 
	--��Ҽ�����Ч
	local playereffT = player.GetMagicEffTableAfterPlayerAct()
	for i,v in pairs(playereffT) do
		v[MAGIC_EFF_DEF_TABLE.EFF_FUNC](player,v[MAGIC_EFF_DEF_TABLE.TPARAM]  )--MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM1],MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM2])
		v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
	end

	--������BRICKִ����Ч
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then					
				local brickeffT = brick.GetMagicEffTableAfterPlayerAct(Board[i][j])
				if #brickeffT > 0 then
					for k,m in pairs(brickeffT) do
							if m[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] > 0 then
								m[MAGIC_EFF_DEF_TABLE.EFF_FUNC](Board[i][j],m[MAGIC_EFF_DEF_TABLE.TPARAM])
								m[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = m[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
							end
					end				
				end
			end
		end
	end	
end

--��������Ϊ�������Ч
function p.ClearPlayerTriggerMagicEff(tParamEvn)
	--��Ҽ�����Ч
	local tRemoveTmpT = {}
	local playereffT = player.GetMagicEffTableAfterPlayerAct()
	
	--�غ�����һ
	for i,v in pairs(playereffT) do
		if v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] <= 0 then 
			if v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] ~=nil then
				v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC](player)
			end
			
			table.insert(tRemoveTmpT,i)
		end
	end
	
	--ɾ����ʱ��Ч
	for i=#tRemoveTmpT,1 ,-1 do
		table.remove(playereffT,tRemoveTmpT[i])	
	end


	--ȥ�����＼����Ч
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then	
				local pbrick = Board[i][j];
				local tRemoveTmpT = {}
				
				local brickeffT = brick.GetMagicEffTableAfterPlayerAct(pbrick)
				--�غ�����һ
				for h,v in pairs(brickeffT) do
					if v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] <= 0 then 
						if v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] ~= nil then
							v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC](pbrick)
						end	
						table.insert(tRemoveTmpT,h)
						brick.removeMagiceff(Board[i][j],v[MAGIC_EFF_DEF_TABLE.EFF_PIC])
					end
				end					
		
	
				--ɾ����ʱ��Ч
				for i=#tRemoveTmpT,1 ,-1 do
					table.remove(brickeffT,tRemoveTmpT[i])	
				end
			end
		end
	end	
end


--���������Ϊ�������Ч
function p.ClearMonTriggerMagicEff(pmonster)
	--��Ҽ�����Ч
	local tRemoveTmpT = {}
	local playereffT = player.GetMagicEffTableAfterMonsterAct()
	
	--�غ�����һ
	for i,v in pairs(playereffT) do
		if v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] <= 0 then 
			if v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] ~=nil then
				v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC](player)
			end
			
			table.insert(tRemoveTmpT,i)
		end
	end
	
	--ɾ����ʱ��Ч
	for i=#tRemoveTmpT,1 ,-1 do
		table.remove(playereffT,tRemoveTmpT[i])	
	end

	--ȥ�����＼����Ч
	local tRemoveTmpT = {}
	local brickeffT = brick.GetMagicEffTableAfterMonsterAct(pmonster)
	--�غ�����һ
	for h,v in pairs(brickeffT) do
		if v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] <= 0 then 
			if v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] ~= nil then
				v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC](pmonster)
			end	
			table.insert(tRemoveTmpT,h)
			brick.removeMagiceff(pmonster,v[MAGIC_EFF_DEF_TABLE.EFF_PIC])
		end
	end					
	
	--ɾ����ʱ��Ч
	for i=#tRemoveTmpT,1 ,-1 do
		table.remove(brickeffT,tRemoveTmpT[i])	
	end
end

























