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
}




--============================所有玩家EFFFUNC============================---
--增强BRICK攻击力
function p.eff01(pobj,Tparam1)
			cclog("add atk to player")
				--==显示玩家数据==--		
			player[playerInfo.BUFFATT] = Tparam1.addAttack;		
			local ATTlabel = layerMain:getChildByTag(2)		
			tolua.cast(ATTlabel, "CCLabelTTF")
			ATTlabel:setString("ATT:"..player.GetAttack())
end

function p.effclr01()
			cclog("remove atk from player")
			player[playerInfo.BUFFATT] = 0;
				--==显示玩家数据==--
			local ATTlabel = layerMain:getChildByTag(2)
			tolua.cast(ATTlabel, "CCLabelTTF")
			ATTlabel:setString("ATT:"..player.GetAttack())	
end



--对MON造成伤害
function p.eff02(pobj,Tparam1)
	if pobj == nil then
		return
	end
	local param1 = Tparam1.damage;
	if pobj.nType == tbrickType.MONSTER then
		monster.damage(pobj,param1)
	end
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
		 brickTo = brick.creatMonster(nToType)
	else
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
	
	
	for X = fromx,tox,1 do
		for Y = fromy ,toy,1 do
			if Board[X][Y]~= nil then
				Main.destroyBrick(X,Y)
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
				--Main.destroyBrick(X,Y)
				
				if Board[X][Y].nType == tbrickType.MONSTER then
					monster.AddAttAdjFunc(pbrick,
											function(nAtt)
												return false;--不攻击
											end
											,5)
				end
			end
		end
	end	
end


function p.effclr05(pObj)
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
	local power = 5
	for i,pmonster in pairs(monsterlistSpelled) do
		monster.AddHp(pmonster,-(power-i+1)) 
	end
end


function p.eff13(player,tparam1)
	local rate = tparam1.rate
	
	 player.AddAttAdjFunc(function(tAttAction)
								tAttAction.criticalchance = tAttAction.criticalchance + rate
						  end
							,13)
end

function p.effclr13(pObj)
	player.RemoveAdjFunc(13)
end

function p.eff14(player,tparam1)
	local rate = tparam1.rate
	
	 player.AddDamageAdjFunc(
							function(tDamageAction)
								tDamageAction.dodgechance = 100;
							end
							,14)
end

function p.effclr14(pObj)
	player.RemoveDamageAdjFunc(14)
end


---===========================所有怪物技能EFFFUNC=================================--
--增强所有MON攻击力
function p.eff1005(pobj,Tparam1)
			pobj.moninfo[monsterInfo.BUFFATT] = Tparam1.addAttack;			
			local Attlabel = pobj:getChildByTag(101)
			tolua.cast(Attlabel, "CCLabelTTF")
			Attlabel:setString(monster.GetMonsterAtt(pobj) )

end

function p.effclr1005(pobj)
			pobj.moninfo[monsterInfo.BUFFATT] = 0;			
			local Attlabel = pobj:getChildByTag(101)
			tolua.cast(Attlabel, "CCLabelTTF")
			Attlabel:setString(monster.GetMonsterAtt(pobj) )
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
	Main.brickSetXY(brickTo,tileX,tileY)
	--Board[tileX][tileY] = brickTo;
	pbrick:removeFromParentAndCleanup(true);
end

--冰冻brick(p1) 
function p.eff1007(pbrick,Tparam1)
	pbrick.IsAbleLink = false;
end

function p.effclr1007(pobj)
	pobj.IsAbleLink = true;
end



--火盾
function p.eff1008(pbrick,Tparam1)
	monster.AddDamageAdjFunc(pbrick,
							function(tDamageAction)
								player.AddHp(-10)
								
							end
							,1008)
end

function p.effclr1008(pObj)
	monster.RemoveDamageAdjFunc(pObj,1008)
end

--吸血
function p.eff1009(pbrick,Tparam1)
	local rate = Tparam1.rate
	monster.AddAttAdjFunc(pbrick,
							function(tAttAction)
								local nRecovery = tAttAction.damage*rate
								monster.AddHp(pbrick,nRecovery)
							end
							,1009)
end

function p.effclr1009(pObj)
	monster.RemoveAdjFunc(pObj,1009)
end

--加血
function p.eff1012(pbrick,Tparam1)
	if pbrick.nType == tbrickType.MONSTER then
		local nrecovery = Tparam1.recovery;
		monster.AddHp(pbrick,nrecovery)
	end
end


--技能特效配置表
MAGIC_EFFtable = {}
	MAGIC_EFFtable[1]={}
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.ID] = 1
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.DESCPTION] = "增强BRICK攻击力3回合"
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff01
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr01
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[1][MAGIC_EFF_DEF_TABLE.TPARAM] = {addAttack = 5}
	
	MAGIC_EFFtable[2]={}
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.ID] = 1
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.DESCPTION] = "对BRICK造成3点伤害"
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff02
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 0
	MAGIC_EFFtable[2][MAGIC_EFF_DEF_TABLE.TPARAM] ={ damage = 3}
	
	MAGIC_EFFtable[3]={}
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.ID] = 3
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.DESCPTION] = "每回合对BRICK造成2点伤害 共5回合"
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 3
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff02
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 5
	MAGIC_EFFtable[3][MAGIC_EFF_DEF_TABLE.TPARAM] = { damage = 2}
	
	MAGIC_EFFtable[4]={}
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.ID] = 4
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.DESCPTION] = "怪物转换brick为金币"
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff03
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 0
	MAGIC_EFFtable[4][MAGIC_EFF_DEF_TABLE.TPARAM] ={ fromType = tbrickType.MONSTER,nToType = tbrickType.GOLD}
		
	MAGIC_EFFtable[5]={}
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.ID] = 5
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.DESCPTION] = "怪物转换brick为血瓶"
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff03
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 0
	MAGIC_EFFtable[5][MAGIC_EFF_DEF_TABLE.TPARAM] ={ fromType = tbrickType.MONSTER,nToType =tbrickType.BLOOD} 

	MAGIC_EFFtable[6]={}
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.ID] = 6
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.DESCPTION] = "爆炸"
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff04
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 0
	MAGIC_EFFtable[6][MAGIC_EFF_DEF_TABLE.TPARAM] ={R = 1}

	MAGIC_EFFtable[7]={}
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.ID] = 7
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.DESCPTION] = "眩晕"
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 5
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff05
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr05
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[7][MAGIC_EFF_DEF_TABLE.TPARAM] ={R = 0}

	MAGIC_EFFtable[8]={}
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.ID] = 8
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.DESCPTION] = "眩晕"
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 5
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff05
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr05
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[8][MAGIC_EFF_DEF_TABLE.TPARAM] ={R = 1}
	
	MAGIC_EFFtable[9]={}
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.ID] = 9
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.DESCPTION] = "吸血"
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff06
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[9][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 5}

	MAGIC_EFFtable[10]={}
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.ID] = 10
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.DESCPTION] = "玩家反伤"
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff07
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr07
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[10][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 2}

	MAGIC_EFFtable[11]={}
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.ID] = 11
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.DESCPTION] = "连锁闪电"
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff08
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[11][MAGIC_EFF_DEF_TABLE.TPARAM] ={LinkNum = 3}

	MAGIC_EFFtable[13]={}
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.ID] = 13
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.DESCPTION] = "提升暴击率100"
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff13
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr13
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[13][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 100}

	MAGIC_EFFtable[14]={}
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.ID] = 14
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.DESCPTION] = "提升闪避率100"
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff14
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr14
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 3
	MAGIC_EFFtable[14][MAGIC_EFF_DEF_TABLE.TPARAM] ={rate = 100}
	
	
	
	--==怪物技能==--
	MAGIC_EFFtable[1007]={}
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.ID] = 1007
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.DESCPTION] = "增加怪物攻击5回合"
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1005
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr1005	
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 6
	MAGIC_EFFtable[1007][MAGIC_EFF_DEF_TABLE.TPARAM] ={addAttack = 5}
	
	MAGIC_EFFtable[1008]={}
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.ID] = 1008
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.DESCPTION] = "刀转换怪物"
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 4
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1006
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = nil
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[1008][MAGIC_EFF_DEF_TABLE.TPARAM] ={ fromType = tbrickType.SWORD,nMonsterid = 6} 
                  
	MAGIC_EFFtable[1009]={}
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.ID] = 1009
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.DESCPTION] = "方块转换冰块"
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 2
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1007
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.CLEAR_EFF_FUNC] = p.effclr1007		
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 2
	MAGIC_EFFtable[1009][MAGIC_EFF_DEF_TABLE.TPARAM] =nil--{ fromType = tbrickType.SWORD,nMonsterid = 6} 
	
	MAGIC_EFFtable[1010]={}
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.ID] = 1010
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.DESCPTION] = "火盾"
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.EFF_PIC] = 1
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1008	
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 999
	MAGIC_EFFtable[1010][MAGIC_EFF_DEF_TABLE.TPARAM] =nil--{ fromType = tbrickType.SWORD,nMonsterid = 6} 
	
	MAGIC_EFFtable[1011]={}
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.ID] = 1011
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.DESCPTION] = "吸血"
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1009	
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 999
	MAGIC_EFFtable[1011][MAGIC_EFF_DEF_TABLE.TPARAM] ={ rate = 1} 

	MAGIC_EFFtable[1012]={}
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.ID] = 1012
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.DESCPTION] = "加血"
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.EFF_PIC] = nil
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.EFF_FUNC] = p.eff1012	
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = 1
	MAGIC_EFFtable[1012][MAGIC_EFF_DEF_TABLE.TPARAM] ={ recovery = 5} 

	
--合体 A B C D类型同时出现在屏幕则合成为一个怪物	
	
	
	
	
	
	
--为玩家新增技能特效
function p.AddPlayerMagicEff(efffuncid,nPhase)
	local effinfoT = p.createMagicEff(efffuncid);
	player.AddMagicEff(effinfoT,nPhase);
end

--为brick新增技能特效
function p.AddBrickMagicEff(efffuncid,nPhase,pbrick,nMagicId)
	if nMagicId ~= nil then
		if magictable[nMagicId][MAGIC_DEF_TABLE.SPELL_TYPE] ~= nil and magictable[nMagicId][MAGIC_DEF_TABLE.SPELL_TYPE] ~= pbrick.nType then
			return nil;
		end
	end
	
	local effinfoT = p.createMagicEff(efffuncid);
	brick.AddMagicEff(effinfoT,nPhase,pbrick);
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


function p.DoMagicEff(tParam) 
	
	--玩家技能特效
	local playereffT = player.GetMagicEffTable(Main.gamephase)
	for i,v in pairs(playereffT) do
		v[MAGIC_EFF_DEF_TABLE.EFF_FUNC](player,v[MAGIC_EFF_DEF_TABLE.TPARAM]  )--MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM1],MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM2])
		v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
	end
	
	
	
	
	--=====================================================================--
	--===========      因为对所有BEFOREACT不会round自动-1      ============--
	--===========      所以回合结束时，即Main.gamephase ==     ============-- 
	--===========      GameLogicPhase.After_Mon_ACT 时,对所有  ============--
	--===========	   BEFOREACT LAST ROUND自动减一			   ============--
	--=====================================================================--
	if Main.gamephase == GameLogicPhase.AFTER_MONSTER_ATT then
		local playereffT = player.GetMagicEffTable(GameLogicPhase.BEFORE_PLAYER_ACT)
		for i,v in pairs(playereffT) do
			--v[MAGIC_EFF_DEF_TABLE.EFF_FUNC](player,v[MAGIC_EFF_DEF_TABLE.TPARAM]  )--MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM1],MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM2])
			v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
		end
	end
	
	
	--对所有BRICK执行特效
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then	
			
				--同上面大片注释
				if Main.gamephase == GameLogicPhase.AFTER_MONSTER_ATT then
					local brickeffTBeforeact = brick.GetMagicEffTable(GameLogicPhase.BEFORE_PLAYER_ACT,Board[i][j])
					for k,v in pairs(brickeffTBeforeact) do
						--v[MAGIC_EFF_DEF_TABLE.EFF_FUNC](player,v[MAGIC_EFF_DEF_TABLE.TPARAM]  )--MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM1],MAGIC_EFFtable[v[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM2])
						v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
					end						
				end
				
				local brickeffT = brick.GetMagicEffTable(Main.gamephase,Board[i][j])
				if #brickeffT > 0 then
					for k,m in pairs(brickeffT) do
							if m[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] > 0 then
								m[MAGIC_EFF_DEF_TABLE.EFF_FUNC](Board[i][j],m[MAGIC_EFF_DEF_TABLE.TPARAM])--MAGIC_EFFtable[m[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM1],MAGIC_EFFtable[m[MAGIC_EFF_DEF_TABLE.ID]][MAGIC_EFF_DEF_TABLE.PARAM2])
								m[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = m[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
							end
					end	
					
					

					
				end
			end
		end
	end	
end

function p.ClearMagicEff(tParamEvn)
	--玩家技能特效
	for k,phase in pairs(GameLogicPhase) do
			local tRemoveTmpT = {}
			local playereffT = player.GetMagicEffTable(phase)
			
			--回合数减一
			for i,v in pairs(playereffT) do
				--v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
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
	end	

	--去除怪物技能特效
	for k,phase in pairs(GameLogicPhase) do
		for i = 1,brickInfo.brick_num_X do
			for j = 1,brickInfo.brick_num_Y do
				if Board[i][j] ~= nil then	
					local pbrick = Board[i][j];
					local tRemoveTmpT = {}
					
					local brickeffT = brick.GetMagicEffTable(phase,pbrick)
					--回合数减一
					for h,v in pairs(brickeffT) do
						--v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
						cclog("removemonster eff v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS]:"..v[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS])
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
end




























