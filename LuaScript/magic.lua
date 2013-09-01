magic = {}
local p = magic;

--选择类型
TARGET_TYPE =
{
	PLAYER = 0,
	ALL_BRICK = 1,
	SINGLE_BRICK = 2,
	LINE = 3,
	AI_MONSTER=4,
	ALLMONSTER =5,
}




--技能定义表
MAGIC_DEF_TABLE = {
	ID =1,
	NAME =2,
	PICICON = 3,
	SPELL_FUNC_ID =4,
	AFTER_PLAER_ATTACK_FUNC_ID =5,
	CD_ROUNDS =6,
	TARGET_TYPE =7,
	AFTER_MON_ATTACK_FUNC_ID = 8,
	TOTARGET_EFFECT_FUNCID_0 = 9,
	TOTARGET_EFFECT_FUNCPHASE_0 = 10,	
	TOTARGET_EFFECT_FUNCID_1 = 11,
	TOTARGET_EFFECT_FUNCPHASE_1 = 12,
	TOTARGET_EFFECT_FUNCID_2 = 13,
	TOTARGET_EFFECT_FUNCPHASE_2 = 14,
	TOTARGET_EFFECT_FUNCID_3 = 15,
	TOTARGET_EFFECT_FUNCPHASE_3 = 16,
	TOTARGET_EFFECT_FUNCID_4 = 17,
	TOTARGET_EFFECT_FUNCPHASE_4 = 18,
	TOTARGET_EFFECT_FUNCID_5 = 19,
	TOTARGET_EFFECT_FUNCPHASE_5 = 20,
	TOTARGET_EFFECT_FUNCID_6 = 21,
	TOTARGET_EFFECT_FUNCPHASE_6 = 22,
	TOTARGET_EFFECT_FUNCID_7 = 23,
	TOTARGET_EFFECT_FUNCPHASE_7 = 24,
	DESCPTION = 25,
	AI_CHOOSE_FUNC = 26,
	AI_DOEFF_AFTERSPELL =27,
	CHOOSE_PARAM = 28,
	SPELL_TYPE = 29,
	NEXT_MAGIC = 30,
}



--==AI选取类型FUNC==--
--随机选取一个刀BRICK
function p.AIChooseFuncRandomSword(pmonster)
	local tswordList = {}
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then
				if	Board[i][j].nType == tbrickType.SWORD then
					table.insert(tswordList,Board[i][j])
				end
			end
		end
	end
	
	if #tswordList > 0 then
		return {tswordList[math.random(1,#tswordList)]};
	end
	return {};
end

--随机选取一个BRICK
function p.AIChooseFuncRandom(pmonster)
	local tList = {}
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then
				if	Board[i][j] ~= pmonster then
					table.insert(tList,Board[i][j])
				end
			end
		end
	end
	if #tList > 0 then
		return {tList[math.random(1,#tList)]};
	end
	return {};
end


--选取自己周围R半径
function p.AIChooseFuncSelf(pmonster,tparam)
	if tparam == nil then
		return {pmonster};
	end
	
	local pmonsterlist = {}
	local nR = tparam.R;
		
		local tileX = pmonster.TileX
		local tileY = pmonster.TileY
		
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
					table.insert(pmonsterlist,Board[X][Y])
				end
			end
		end			
		
	return pmonsterlist;
end





--技能配置表
--=============玩家技能==============---
magictable = {}
	magictable[1]={}
	magictable[1][MAGIC_DEF_TABLE.ID] = 1
	magictable[1][MAGIC_DEF_TABLE.NAME] = "催化剂"
	magictable[1][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1
	magictable[1][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[1][MAGIC_DEF_TABLE.DESCPTION] = "增强玩家攻击力5回合"
	magictable[1][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil


	magictable[2]={}
	magictable[2][MAGIC_DEF_TABLE.ID] = 2
	magictable[2][MAGIC_DEF_TABLE.NAME] = "群体伤害"
	magictable[2][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[2][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[2][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[2][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 2
	magictable[2][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[2][MAGIC_DEF_TABLE.DESCPTION] = "伤害所有怪物"
	magictable[2][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[2][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	
	magictable[3]={}
	magictable[3][MAGIC_DEF_TABLE.ID] = 3
	magictable[3][MAGIC_DEF_TABLE.NAME] = "群体毒"
	magictable[3][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[3][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[3][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[3][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 3
	magictable[3][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[3][MAGIC_DEF_TABLE.DESCPTION] = "毒所有怪物"
	magictable[3][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[3][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	
	
	magictable[4]={}
	magictable[4][MAGIC_DEF_TABLE.ID] = 4
	magictable[4][MAGIC_DEF_TABLE.NAME] = "收钱啦"
	magictable[4][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[4][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[4][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[4][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 4
	magictable[4][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[4][MAGIC_DEF_TABLE.DESCPTION] = "群体怪物变金币"
	magictable[4][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[4][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	
	
	magictable[5]={}
	magictable[5][MAGIC_DEF_TABLE.ID] = 5
	magictable[5][MAGIC_DEF_TABLE.NAME] = "好多血瓶哦"
	magictable[5][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[5][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[5][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[5][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 5
	magictable[5][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[5][MAGIC_DEF_TABLE.DESCPTION] = "群体怪物变血瓶"
	magictable[5][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[5][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	
	
	--玩家点击后变身炸弹怪物 爆炸N*N个brick
	magictable[6]={}
	magictable[6][MAGIC_DEF_TABLE.ID] = 6
	magictable[6][MAGIC_DEF_TABLE.NAME] = "爆炸"
	magictable[6][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[6][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[6][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[6][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 6
	magictable[6][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[6][MAGIC_DEF_TABLE.DESCPTION] = "玩家点击后变身炸弹怪物 爆炸N*N个brick"
	magictable[6][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[6][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[6][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	
	
	--玩家 眩晕单个怪物效果
	magictable[7]={}
	magictable[7][MAGIC_DEF_TABLE.ID] = 7
	magictable[7][MAGIC_DEF_TABLE.NAME] = "单体眩晕"
	magictable[7][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[7][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[7][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[7][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 7
	magictable[7][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[7][MAGIC_DEF_TABLE.DESCPTION] = "玩家点击后使怪物无法攻击3回合"
	magictable[7][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[7][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[7][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	
--玩家 眩晕多个敌人
	magictable[8]={}
	magictable[8][MAGIC_DEF_TABLE.ID] = 8
	magictable[8][MAGIC_DEF_TABLE.NAME] = "群体眩晕"
	magictable[8][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[8][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[8][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[8][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 8
	magictable[8][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[8][MAGIC_DEF_TABLE.DESCPTION] = "玩家点击后使一群怪物无法攻击3回合"
	magictable[8][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}
	magictable[8][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[8][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	
	
--吸血
	magictable[9]={}
	magictable[9][MAGIC_DEF_TABLE.ID] = 9
	magictable[9][MAGIC_DEF_TABLE.NAME] = "吸血"
	magictable[9][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[9][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[9][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[9][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 9
	magictable[9][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[9][MAGIC_DEF_TABLE.DESCPTION] = "玩家攻击时吸收50%生命 3回合"
	--magictable[9][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}
	--magictable[9][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[9][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	
--反弹伤害N回合	
	magictable[10]={}
	magictable[10][MAGIC_DEF_TABLE.ID] = 10
	magictable[10][MAGIC_DEF_TABLE.NAME] = "玩家反伤"
	magictable[10][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[10][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[10][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[10][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 10
	magictable[10][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[10][MAGIC_DEF_TABLE.DESCPTION] = "玩家被攻击时,反击损失50%生命 3回合"
	magictable[10][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil

	
--玩家 闪电链
	magictable[11]={}
	magictable[11][MAGIC_DEF_TABLE.ID] = 11
	magictable[11][MAGIC_DEF_TABLE.NAME] = "闪电链"
	magictable[11][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[11][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[11][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[11][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 11
	magictable[11][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[11][MAGIC_DEF_TABLE.DESCPTION] = "对一只怪物闪电，连续弹射伤害N次"
	magictable[11][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[11][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[11][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER


--玩家 NXN毒
	magictable[12]={}
	magictable[12][MAGIC_DEF_TABLE.ID] = 12
	magictable[12][MAGIC_DEF_TABLE.NAME] = "群体毒"
	magictable[12][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[12][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[12][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[12][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 3
	magictable[12][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[12][MAGIC_DEF_TABLE.DESCPTION] = "毒4x4怪物"
	magictable[12][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[12][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[12][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}

--暴击概率
	magictable[13]={}
	magictable[13][MAGIC_DEF_TABLE.ID] = 13
	magictable[13][MAGIC_DEF_TABLE.NAME] = "提升玩家暴击率100"
	magictable[13][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[13][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[13][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[13][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 13
	magictable[13][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[13][MAGIC_DEF_TABLE.DESCPTION] = "提升玩家暴击率100"


--闪避概率
	magictable[14]={}
	magictable[14][MAGIC_DEF_TABLE.ID] = 14
	magictable[14][MAGIC_DEF_TABLE.NAME] = "提升玩家闪避率100"
	magictable[14][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[14][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[14][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[14][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 14
	magictable[14][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[14][MAGIC_DEF_TABLE.DESCPTION] = "提升玩家闪避率100"
	
	

--血比例越小 攻击越强




--杀死一只怪物攻击增加N,如果下回合仍杀死则保留 无则归0



	

--=============怪物技能==============---
--对周围所有怪物增加攻击
	magictable[1007]={}
	magictable[1007][MAGIC_DEF_TABLE.ID] = 1007
	magictable[1007][MAGIC_DEF_TABLE.NAME] = "恶魔光环"
	magictable[1007][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1007][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1007][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[1007][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1007
	magictable[1007][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1007][MAGIC_DEF_TABLE.DESCPTION] = "对周围所有怪物增加攻击3"
	magictable[1007][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false	
	magictable[1007][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1007][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--随机将一把刀变成Slime	
	magictable[1008]={}
	magictable[1008][MAGIC_DEF_TABLE.ID] = 1008
	magictable[1008][MAGIC_DEF_TABLE.NAME] = "刀变蜘蛛"
	magictable[1008][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1008][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1008][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1008][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1008
	magictable[1008][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1008][MAGIC_DEF_TABLE.DESCPTION] = "随机将一把刀变成小蜘蛛"
	magictable[1008][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncRandomSword
	magictable[1008][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1008][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1008][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--随机将一个BRICK变为冰块 不可链接
	magictable[1009]={}
	magictable[1009][MAGIC_DEF_TABLE.ID] = 1009
	magictable[1009][MAGIC_DEF_TABLE.NAME] = "冰冻"
	magictable[1009][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1009][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1009][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1009][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1009
	magictable[1009][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1009][MAGIC_DEF_TABLE.DESCPTION] = "随机冰冻一个方块"
	magictable[1009][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncRandom
	magictable[1009][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1009][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1009][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--被攻击时灼烧对象
	magictable[1010]={}
	magictable[1010][MAGIC_DEF_TABLE.ID] = 1010
	magictable[1010][MAGIC_DEF_TABLE.NAME] = "火盾"
	magictable[1010][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1010][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1010][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1010][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1010
	magictable[1010][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1010][MAGIC_DEF_TABLE.DESCPTION] = "被攻击时灼烧对象"
	magictable[1010][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1010][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1010][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1010][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--怪物吸血
	magictable[1011]={}
	magictable[1011][MAGIC_DEF_TABLE.ID] = 1011
	magictable[1011][MAGIC_DEF_TABLE.NAME] = "吸血"
	magictable[1011][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1011][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1011][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1011][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1011
	magictable[1011][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1011][MAGIC_DEF_TABLE.DESCPTION] = "攻击时吸取玩家生命"
	magictable[1011][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1011][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1011][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1011][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--为周围怪物补血
	magictable[1012]={}
	magictable[1012][MAGIC_DEF_TABLE.ID] = 1012
	magictable[1012][MAGIC_DEF_TABLE.NAME] = "群体治疗"
	magictable[1012][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1012][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1012][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1012][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1012
	magictable[1012][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1012][MAGIC_DEF_TABLE.DESCPTION] = "群体治疗nxn"
	magictable[1012][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1012][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1012][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1012][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}

--相同怪物组合成新怪物



--施放技能 失败返回FALSE 成功返回中招对象列表,以及 EFF实例列表
function p.SpellMagic(nMagicId,pBrickSingle,pLine)
	cclog("SpellMagic nMagicId:"..nMagicId)
	local tTargetList = {}
	local tEffList = {}
	if magictable[nMagicId] == nil then
		return false;
	end

	local magicinfo = magictable[nMagicId];

	--NEXT_MAGIC
	
	if magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.PLAYER then
		cclog("SpellMagic PLAYER")
		--===对玩家施放技能===-
		--触发 施放FUNC
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID]();
		end
		--对TARGET增加特效
		if magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] ~= nil and magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] ~= nil then
			magiceff.AddPlayerMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0]);
		else
			cclog("增加TARGET特效失败 nMagicId:"..nMagicId);
		end
		
	elseif 	magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.ALLMONSTER then
		--===对所有MON施放技能===-
		cclog("SpellMagic 2")
	
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID]();
		end		
		cclog("SpellMagic 3")
	
		--对all MON增加特效
		if magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] ~= nil and magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] ~= nil then
				for i = 1,brickInfo.brick_num_X do
					for j = 1,brickInfo.brick_num_Y do
						if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then						
							local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0],Board[i][j],nMagicId);
							if effT ~= nil then
								table.insert(tTargetList,Board[i][j])
								table.insert(tEffList,effT)	
							end	
						end		
					end
				end	
		end	
		cclog("SpellMagic 4")
	
	elseif magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.SINGLE_BRICK then
		--对某一个BRICK释放技能	
		local nR = magicinfo[MAGIC_DEF_TABLE.CHOOSE_PARAM].R;
		local tileX = pBrickSingle.TileX
		local tileY = pBrickSingle.TileY
		
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
					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0],Board[X][Y],nMagicId);	
					if effT ~= nil then
							table.insert(tTargetList,Board[X][Y])
							table.insert(tEffList,effT)
					end	
				end
			end
		end			
		

		
	elseif 	magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.AI_MONSTER then
		--使用AI获取施法对象
		cclog("SpellMagic 2")
		if magicinfo[MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] ~= nil then
			cclog("SpellMagic 3")
			local pbricklist = magicinfo[MAGIC_DEF_TABLE.AI_CHOOSE_FUNC](pBrickSingle,magicinfo[MAGIC_DEF_TABLE.CHOOSE_PARAM]);
			
			for i,pbrick in pairs(pbricklist) do
				if pbrick ~= nil then
					cclog("SpellMagic 4")
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0],pbrick);	
					table.insert(tTargetList,pbrick)
					table.insert(tEffList,effT)	
				end
			end
		end	
	end
	
	return tTargetList,tEffList;
end

--获取技能的对象类型
function p.GetMagicTargetType(nMagicId)
	if magictable[nMagicId] == nil then
		return nil;
	end
	
	if magictable[nMagicId][MAGIC_DEF_TABLE.TARGET_TYPE] == nil  then
		return nil;
	end
	
	return  magictable[nMagicId][MAGIC_DEF_TABLE.TARGET_TYPE];-- = TARGET_TYPE.SINGLE_BRICK;
end



function p.GetMagicDoeffAfterSpell(nMagicId)
	if magictable[nMagicId] == nil then
		return nil;
	end	
	
	if magictable[nMagicId][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] == nil  then
		return nil;
	end
	
	return magictable[nMagicId][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL];
end














