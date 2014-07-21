magiceff = {}
local p = magiceff;

--技能特效定义表
MAGIC_EFF_DEF_TABLE = {
	ID =1,
	DESCPTION = 2,
	EFF_PIC = 3,
	EFF_FUNC =4,
	CLEAR_EFF_FUNC =5,
	LAST_ROUNDS =6,
	TPARAM=7,
	B_IF_TRIGER_AFTER_PLAYER_ACT = 8,--是玩家行为后触发  还是怪物行为后触发
}




--============================所有玩家EFFFUNC============================---
--增强BRICK攻击力
function p.eff01(pobj,Tparam1)
			cclog("add atk to player")
				--==显示玩家数据==--
			player[playerInfo.BUFFATT] =  player[playerInfo.Entity_ATT]*0.3 --Tparam1.addAttack;		
			player.UpdateEntityData();
end

function p.effclr01()
			cclog("remove atk from player")
			player[playerInfo.BUFFATT] = 0;
				--==显示玩家数据==--
			player.UpdateEntityData();
			Hint.ShowHint(Hint.tHintType.powerdown)	
end



--对MON造成毒伤害
function p.eff02(pobj,Tparam1)
	if pobj == nil then
		return
	end
	local param1 = Tparam1.damage;
	if pobj.nType == tbrickType.MONSTER then
		--每次扣血80%
		local monsterhpmax = pobj.moninfo[monsterInfo.HPMAX]
		local ndamage = monsterhpmax*0.8
		monster.damage(pobj,ndamage)
	end
end

function p.effclr02(pobj)
	--去除特效
	Particle.RemoveParticleEffFromBrick(pobj,"poison");
end


--brick(p1)转换为brick(p2)
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
		--播放光效
		Particle.AddParticleEffToWorld(pbrick,"shine")
		brickTo = brick.creatGoldBrick(nToType)
	else
		--播放光效
		Particle.AddParticleEffToWorld(pbrick,"shineRed")
		brickTo = brick.creatBrick(nToType)
	end
	
			


	
	Main.brickSetXY(brickTo,tileX,tileY)
	--Board[tileX][tileY] = brickTo;
	pbrick:removeFromParentAndCleanup(true);
		
end


--以pbrick为中心消灭周围BRICK   nR= 半径(中心点到边界的TILE数量 如0则表示中心点  1为3X3矩阵)
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
	
	--在位置上播放爆炸光效
	Particle.AddParticleEffToWorld(pbrick,"explode")
				
	for X = fromx,tox,1 do
		for Y = fromy ,toy,1 do
			if Board[X][Y]~= nil then
				
				--如果是怪物则造成伤害
				if Board[X][Y].nType == tbrickType.MONSTER then
					monster.damage(Board[X][Y],999)
				else
					Main.destroyBrick(X,Y)
				end
			end
		end
	end	
end


--对选择怪物造成眩晕
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
					--光效
					pbrick.IfBeStunned = true;
					monster.AddAttAdjFunc(pbrick,
										function(tAttAction)
												return false;--不攻击
											end
											,5)
				end
			end
		end
	end	
end


function p.effclr05(pObj)
	--光效
	Particle.RemoveParticleEffFromBrick(pObj,"star")
	pObj.IfBeStunned = true;										
	monster.RemoveAdjFunc(pObj,5)
end



--玩家吸血
function p.eff06(player,tparam1)
	local nAttDamage = tParamEvn.playerAttDamageThisRound;
	local rate = tparam1.rate
	local recovery = math.floor(nAttDamage*rate)
	player.AddHp(recovery)
end


--玩家反伤
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


--闪电链
function p.eff08(pbrick,tparam1)
	local nLinkNum = tparam1.LinkNum
	
	--获取所有怪物
	local monsterlist = Main.GetMonsterList()
	
	for i,v in pairs(monsterlist) do
		if pbrick == v then
			table.remove(monsterlist,i)
			break
		end
	end
	
	
	local monsterlistSpelled = {[1] = pbrick}
	
	--随机抽取N个
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
	
	---对列表monsterlistSpelled中所有怪物施放闪电
	
	
	--撞击函数
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
	

	--增加粒子效果
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

--降低游戏速度
function p.eff15(pobj,Tparam1)
	CCDirector:sharedDirector():getScheduler():setTimeScale(0.5);
end

function p.effclr15()
	CCDirector:sharedDirector():getScheduler():setTimeScale(1);
end




--单排杀
function p.eff16(pobj)
	--对整排brick执行消除
	local Y = pobj.TileY
	for i=1,brickInfo.brick_num_X do
		--(Board[i][Y]):removeFromParentAndCleanup(true);
		Main.destroyBrick(i,Y,true)
	end
end

--十字杀
function p.eff17(pobj)
	--对整排brick执行消除
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

---===========================所有怪物技能EFFFUNC=================================--
--增强所有MON攻击力
function p.eff1005(pobj,Tparam1)
			--只加一次
			local test = pobj.moninfo[monsterInfo.BUFFATT]
			if pobj.moninfo[monsterInfo.BUFFATT] >= Tparam1.addAttack then
				return
			end
			
			pobj.moninfo[monsterInfo.BUFFATT] = Tparam1.addAttack;
			monster.SetAtt(pobj);
			
			--播放光效
			Particle.AddParticleEffToBrick(pobj,"buff")
end

function p.effclr1005(pobj)
			pobj.moninfo[monsterInfo.BUFFATT] = 0;
			monster.SetAtt(pobj);			
			--local Attlabel = pobj:getChildByTag(101)
			--tolua.cast(Attlabel, "CCLabelTTF")
			--Attlabel:setString(monster.GetMonsterAtt(pobj) )
end



--brick(p1)转换为怪物
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

--冰冻brick(p1) 
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



--火盾
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

--吸血
function p.eff1009(pbrick,Tparam1)
	local rate = Tparam1.rate
	monster.AddAttAdjFunc(pbrick,
							function(tAttAction)
								--增加特效
								Particle.AddParticleEffToBrick(tAttAction.attacker,"suckblood")									
								local nRecovery = tAttAction.damage*rate
								monster.AddHp(tAttAction.attacker,nRecovery)
							end
							,1009)
end

function p.effclr1009(pObj)
	monster.RemoveAdjFunc(pObj,1009)
end

--加血
function p.eff1012(pbrick,Tparam1)
	Particle.AddParticleEffToBrick(pbrick,"recovery")									
	if pbrick.nType == tbrickType.MONSTER then
		local nrecovery = Tparam1.recovery;
		monster.AddHp(pbrick,nrecovery)
	end
end


--嘲諷
function p.eff1014(player,tParam,self)
	if self == nil then
		return 
	end	
	
	player.TauntedByMon = self  --改變玩家嘲諷對象
	
	
	function removeTaunedMon()
		player.TauntedByMon = nil;
	end
	monster.AddDeathFunc(self,removeTaunedMon,1014) --怪物死亡後清除玩家嘲諷對象
end	

--愤怒
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
		--回复原状
		local CDMAX = MONSTER_TYPE[typeid]["CD"] + level*MONSTER_TYPE[typeid]["CDGrow"]
		self.moninfo[monsterInfo.CDMAX] = CDMAX
		spriteBrick = SpriteManager.creatBrickSprite(28)
	else
		--发狂
		local CDMAX =  MONSTER_TYPE[typeid]["CD"] + level*MONSTER_TYPE[typeid]["CDGrow"]
		CDMAX = CDMAX/3
		self.moninfo[monsterInfo.CDMAX] = CDMAX
		spriteBrick = SpriteManager.creatBrickSprite(29)
	end
	
	self:addChild(spriteBrick)
	spriteBrick:setTag(MainSpritetag)
	spriteBrick:setPosition(CCPointMake(brickWidth/2 , brickHeight/2))
end


--自爆
function p.eff1017(self,tParam)
	if self==nil then
		return
	end

	--在位置上播放爆炸光效
	Particle.AddParticleEffToWorld(self,"explode")
	
	--{ dmgPerLevel = 5 ,dmgBase = 10} 
	local level = self.moninfo[monsterInfo.LEV];
	local dmg = tParam.dmgBase  + tParam.dmgPerLevel*level
	player.takedamage(dmg,self);	
	
	monster.damage( self,9999,false)
end

--吸魔
function p.eff1018(pbrick,Tparam1)
	local rate = Tparam1.rate
	monster.AddAttAdjFunc(pbrick,
							function(tAttAction)
								--增加特效
								Particle.AddParticleEffToBrick(tAttAction.attacker,"suckenergy")									
								local nRecovery = tAttAction.damage*rate
								--消耗能量
								player.SpendEnergy(nRecovery);	
							end
							,1018)
end

--破坏
function p.eff1019(pbrick,Tparam1)
	--破坏概率
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
									
									--UI更新
									EquipUpGradeUI.RefreshMenu()
									--增加特效
									local  emitter = Particle.AddParticleEffToWorld(pbrick,"fog")
									Particle.MoveParticleTo(emitter,nil)

								end
								
							end
							,1019)
end



--调换位置  pbrick
function p.eff1020(pbrick,Tparam1)
	
	if pbrick.IsAbleLink == false then
		return
	end
	Particle.AddParticleEffToBrick(pbrick,"ice")
	pbrick.IsAbleLink = false;
end


--技能特效配置表
MAGIC_EFFtable = {}
	MAGIC_EFFtable[1]={}
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.ID] = 1
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.DESCPTION] = "增强BRICK攻击力%30 6回合"
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff01
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr01
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 6
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.TPARAM] = {addAttack = 5}
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	
	
	MAGIC_EFFtable[2]={}
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.ID] = 1
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.DESCPTION] = "对BRICK造成3点伤害"
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff02
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 0
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.TPARAM] ={ damage = 3}
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[3]={}
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.ID] = 3
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.DESCPTION] = "每回合对BRICK造成2点伤害 共5回合"
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff02
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr02
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 5
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.TPARAM] = { damage = 2}
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[4]={}
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.ID] = 4
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.DESCPTION] = "怪物转换brick为金币"
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff03
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.TPARAM] ={ fromType = tbrickType.MONSTER,nToType = tbrickType.GOLD}
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
		
	MAGIC_EFFtable[5]={}
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.ID] = 5
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.DESCPTION] = "怪物转换brick为血瓶"
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff03
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.TPARAM] ={ fromType = tbrickType.MONSTER,nToType =tbrickType.BLOOD} 
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[6]={}
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.ID] = 6
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.DESCPTION] = "爆炸"
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff04
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.TPARAM] ={R = 1}
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[7]={}
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.ID] = 7
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.DESCPTION] = "眩晕"
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff05
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr05
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.TPARAM] ={R = 0}
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[8]={}
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.ID] = 8
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.DESCPTION] = "眩晕"
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff05
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr05
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.TPARAM] ={R = 1}
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[9]={}
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.ID] = 9
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.DESCPTION] = "吸血"
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff06
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 5}
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[10]={}
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.ID] = 10
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.DESCPTION] = "玩家反伤"
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff07
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr07
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 2}
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[11]={}
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.ID] = 11
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.DESCPTION] = "连锁闪电"
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff08
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.TPARAM] ={LinkNum = 5}
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[13]={}
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.ID] = 13
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.DESCPTION] = "翻倍提升暴击率"
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff13
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr13
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 5
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 100}
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[14]={}
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.ID] = 14
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.DESCPTION] = "翻倍提升闪避率"
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff14
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr14
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 5
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 100}
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
		
	MAGIC_EFFtable[15]={}
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.ID] = 15
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.DESCPTION] = "降低游戏速度5回合"
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff15
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr15
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 5
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.TPARAM] = {addAttack = 5}
	MAGIC_EFFtable[15][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[16]={}
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.ID] = 16
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.DESCPTION] = "单排杀"
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff16
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr16
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.TPARAM] = {addAttack = 5}
	MAGIC_EFFtable[16][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	MAGIC_EFFtable[17]={}
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.ID] = 17
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.DESCPTION] = "十字杀"
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff17
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr17
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.TPARAM] = {addAttack = 5}
	MAGIC_EFFtable[17][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = true
	
	
	
	
	
	
	
	
	--==怪物技能==--
	MAGIC_EFFtable[1007]={}
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.ID] = 1007
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.DESCPTION] = "增加怪物攻击3回合"
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1005
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr1005	
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 6
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.TPARAM] ={addAttack = 3}
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[1008]={}
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.ID] = 1008
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.DESCPTION] = "刀转换怪物"
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 4
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1006
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.TPARAM] ={ fromType = tbrickType.SWORD,nMonsterid = 6} 
 	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
                 
	MAGIC_EFFtable[1009]={}
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.ID] = 1009
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.DESCPTION] = "方块转换冰块"
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 2
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1007
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr1007		
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 2
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.TPARAM] =nil--{ fromType = tbrickType.SWORD,nMonsterid = 6} 
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[1010]={}
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.ID] = 1010
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.DESCPTION] = "火盾"
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1008	
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 999
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.TPARAM] =nil--{ fromType = tbrickType.SWORD,nMonsterid = 6} 
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[1011]={}
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.ID] = 1011
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.DESCPTION] = "吸血"
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1009	
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 999
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.TPARAM] ={ rate = 1} 
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false

	MAGIC_EFFtable[1012]={}
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.ID] = 1012
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.DESCPTION] = "加血"
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1012	
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.TPARAM] ={ recovery = 5} 
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false

	MAGIC_EFFtable[1014]={}
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.ID] = 1014
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.DESCPTION] = "讓玩家強行攻擊你"
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1014
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 9999
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.TPARAM] ={} 
	MAGIC_EFFtable[1014][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false

	MAGIC_EFFtable[1016]={}
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.ID] = 1016
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.DESCPTION] = "损血则变强"
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1016
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 9999
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.TPARAM] ={} 
	MAGIC_EFFtable[1016][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[1017]={}
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.ID] = 1017
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.DESCPTION] = "自爆"
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1017
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 9999
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.TPARAM] ={ dmgPerLevel = 5 ,dmgBase = 10} 
	MAGIC_EFFtable[1017][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
	MAGIC_EFFtable[1018]={}
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.ID] = 1018
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.DESCPTION] = "吸魔"
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1018
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 999
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.TPARAM] ={ rate = 1} 
	MAGIC_EFFtable[1018][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false

	MAGIC_EFFtable[1019]={}
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.ID] = 1019
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.DESCPTION] = "破坏装备"
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1019
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 999
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.TPARAM] ={ rate = 1} 
	MAGIC_EFFtable[1019][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false
	
                 
	MAGIC_EFFtable[1020]={}
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.ID] = 1020
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.DESCPTION] = "随机调换位置"
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 2
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1020
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 2
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.TPARAM] =nil
	MAGIC_EFFtable[1020][MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT] = false		
--合体 A B C D类型同时出现在屏幕则合成为一个怪物	
	
	
	
	

	
--为玩家新增技能特效
function p.AddPlayerMagicEff(efffuncid)
	local effinfoT = p.createMagicEff(efffuncid);
	player.AddMagicEff(effinfoT);
	
	return effinfoT;
end

--为brick新增技能特效
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

--创建一个EFF数据表
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




--执行怪物行为后魔法特效
function p.DoMagicEffAfterMonsterAct(pmonster)
	--玩家技能特效
	local playereffT = player.GetMagicEffTableAfterMonsterAct()
	for i,v in pairs(playereffT) do
		v[MAGIC_EFF_DEF_TABLE.EFF_FUNC](player,v[MAGIC_EFF_DEF_TABLE.TPARAM]  )--MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM1],MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM2])
		v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
	end
	--对所有BRICK执行特效
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

--执行玩家行为后魔法特效
function p.DoMagicEff(tParam) 
	--玩家技能特效
	local playereffT = player.GetMagicEffTableAfterPlayerAct()
	for i,v in pairs(playereffT) do
		v[MAGIC_EFF_DEF_TABLE.EFF_FUNC](player,v[MAGIC_EFF_DEF_TABLE.TPARAM]  )--MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM1],MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM2])
		v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
	end

	--对所有BRICK执行特效
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

--清除玩家行为后出发特效
function p.ClearPlayerTriggerMagicEff(tParamEvn)
	--玩家技能特效
	local tRemoveTmpT = {}
	local playereffT = player.GetMagicEffTableAfterPlayerAct()
	
	--回合数减一
	for i,v in pairs(playereffT) do
		if v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] <= 0 then 
			if v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] ~=nil then
				v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC](player)
			end
			
			table.insert(tRemoveTmpT,i)
		end
	end
	
	--删除超时特效
	for i=#tRemoveTmpT,1 ,-1 do
		table.remove(playereffT,tRemoveTmpT[i])	
	end


	--去除怪物技能特效
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then	
				local pbrick = Board[i][j];
				local tRemoveTmpT = {}
				
				local brickeffT = brick.GetMagicEffTableAfterPlayerAct(pbrick)
				--回合数减一
				for h,v in pairs(brickeffT) do
					if v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] <= 0 then 
						if v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] ~= nil then
							v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC](pbrick)
						end	
						table.insert(tRemoveTmpT,h)
						brick.removeMagiceff(Board[i][j],v[MAGIC_EFF_DEF_TABLE.EFF_PIC])
					end
				end					
		
	
				--删除超时特效
				for i=#tRemoveTmpT,1 ,-1 do
					table.remove(brickeffT,tRemoveTmpT[i])	
				end
			end
		end
	end	
end


--清除怪物行为后出发特效
function p.ClearMonTriggerMagicEff(pmonster)
	--玩家技能特效
	local tRemoveTmpT = {}
	local playereffT = player.GetMagicEffTableAfterMonsterAct()
	
	--回合数减一
	for i,v in pairs(playereffT) do
		if v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] <= 0 then 
			if v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] ~=nil then
				v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC](player)
			end
			
			table.insert(tRemoveTmpT,i)
		end
	end
	
	--删除超时特效
	for i=#tRemoveTmpT,1 ,-1 do
		table.remove(playereffT,tRemoveTmpT[i])	
	end

	--去除怪物技能特效
	local tRemoveTmpT = {}
	local brickeffT = brick.GetMagicEffTableAfterMonsterAct(pmonster)
	--回合数减一
	for h,v in pairs(brickeffT) do
		if v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] <= 0 then 
			if v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] ~= nil then
				v[MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC](pmonster)
			end	
			table.insert(tRemoveTmpT,h)
			brick.removeMagiceff(pmonster,v[MAGIC_EFF_DEF_TABLE.EFF_PIC])
		end
	end					
	
	--删除超时特效
	for i=#tRemoveTmpT,1 ,-1 do
		table.remove(brickeffT,tRemoveTmpT[i])	
	end
end

























