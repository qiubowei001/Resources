--============玩家施放法术功能=============--

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
	TOTARGET_EFFECT_FUNCPHASE_0 = 10,	--已无用
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
	CDROUND = 31,
	ENERGYNEED = 32,
}

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>释放时触发函数集合======================================--
--返回true则表示技能施放成功
--群体毒
function magicfunction03()
	local bcast = false
	--增加毒光效
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then						
				Particle.AddParticleEffToBrick(Board[i][j],"poison")
				bcast = true
			end	
		end
	end
	return bcast;
end

--单体晕
function magicfunction07(pbrick)
	
	if pbrick.nType == tbrickType.MONSTER then								
		Particle.AddParticleEffToBrick(pbrick,"star")
		return true;
	end
	return false;
end



--==============================释放时触发函数集合<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--



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
	magictable[1][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function()
															Hint.ShowHint(Hint.tHintType.powerup)	
															return 
														end
	magictable[1][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1
	magictable[1][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[1][MAGIC_DEF_TABLE.DESCPTION] = "增强玩家攻击力5回合"
	magictable[1][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1][MAGIC_DEF_TABLE.CDROUND] =  7
	magictable[1][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1][MAGIC_DEF_TABLE.ENERGYNEED] = 1
	
	
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
	magictable[2][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[2][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[2][MAGIC_DEF_TABLE.ENERGYNEED] = 1

	magictable[3]={}
	magictable[3][MAGIC_DEF_TABLE.ID] = 3
	magictable[3][MAGIC_DEF_TABLE.NAME] = "群体毒"
	magictable[3][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[3][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = magicfunction03
	magictable[3][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[3][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 3
	magictable[3][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[3][MAGIC_DEF_TABLE.DESCPTION] = "毒所有怪物"
	magictable[3][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[3][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[3][MAGIC_DEF_TABLE.CDROUND] =  7
	magictable[3][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[3][MAGIC_DEF_TABLE.ENERGYNEED] = 1

	
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
	magictable[4][MAGIC_DEF_TABLE.CDROUND] =  7
	magictable[4][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[4][MAGIC_DEF_TABLE.ENERGYNEED] = 3

	
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
	magictable[5][MAGIC_DEF_TABLE.CDROUND] =  7
	magictable[5][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[5][MAGIC_DEF_TABLE.ENERGYNEED] = 3

	
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
	magictable[6][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[6][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[6][MAGIC_DEF_TABLE.ENERGYNEED] = 1

	--玩家 眩晕单个怪物效果
	magictable[7]={}
	magictable[7][MAGIC_DEF_TABLE.ID] = 7
	magictable[7][MAGIC_DEF_TABLE.NAME] = "单体眩晕"
	magictable[7][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[7][MAGIC_DEF_TABLE.SPELL_FUNC_ID]  = magicfunction07
	magictable[7][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[7][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 7
	magictable[7][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[7][MAGIC_DEF_TABLE.DESCPTION] = "玩家点击后使怪物无法攻击3回合"
	magictable[7][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[7][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[7][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[7][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[7][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[7][MAGIC_DEF_TABLE.ENERGYNEED] = 1

--玩家 眩晕多个敌人
	magictable[8]={}
	magictable[8][MAGIC_DEF_TABLE.ID] = 8
	magictable[8][MAGIC_DEF_TABLE.NAME] = "群体眩晕"
	magictable[8][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[8][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = magicfunction07
	magictable[8][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[8][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 8
	magictable[8][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[8][MAGIC_DEF_TABLE.DESCPTION] = "玩家点击后使一群怪物无法攻击3回合"
	magictable[8][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}
	magictable[8][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[8][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[8][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[8][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[8][MAGIC_DEF_TABLE.ENERGYNEED] = 1
	
	
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
	magictable[9][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[9][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[9][MAGIC_DEF_TABLE.ENERGYNEED] = 1

	
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
	magictable[10][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[10][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[10][MAGIC_DEF_TABLE.ENERGYNEED] = 1

	
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
	magictable[11][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[11][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[11][MAGIC_DEF_TABLE.ENERGYNEED] = 1


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
	magictable[12][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[12][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[12][MAGIC_DEF_TABLE.ENERGYNEED] = 1

--暴击概率
	magictable[13]={}
	magictable[13][MAGIC_DEF_TABLE.ID] = 13
	magictable[13][MAGIC_DEF_TABLE.NAME] = "提升玩家暴击率100"
	magictable[13][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[13][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function()
															Hint.ShowHint(Hint.tHintType.criticalUp)	
															return 
														end
	magictable[13][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[13][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 13
	magictable[13][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[13][MAGIC_DEF_TABLE.DESCPTION] = "提升玩家暴击率100"
	magictable[13][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[13][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[13][MAGIC_DEF_TABLE.ENERGYNEED] = 1


--闪避概率
	magictable[14]={}
	magictable[14][MAGIC_DEF_TABLE.ID] = 14
	magictable[14][MAGIC_DEF_TABLE.NAME] = "提升玩家闪避率100"
	magictable[14][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[14][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function()
															Hint.ShowHint(Hint.tHintType.dodgeUp)		
															return 
														end
	magictable[14][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[14][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 14
	magictable[14][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[14][MAGIC_DEF_TABLE.DESCPTION] = "提升玩家闪避率100"
	magictable[14][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[14][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[14][MAGIC_DEF_TABLE.ENERGYNEED] = 1

--子弹时间
	magictable[15]={}
	magictable[15][MAGIC_DEF_TABLE.ID] = 15
	magictable[15][MAGIC_DEF_TABLE.NAME] = "子弹时间"
	magictable[15][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[15][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[15][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[15][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 15
	magictable[15][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[15][MAGIC_DEF_TABLE.DESCPTION] = "降低游戏速度"
	magictable[15][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[15][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[15][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[15][MAGIC_DEF_TABLE.ENERGYNEED] = 1


--单排杀
	magictable[16]={}
	magictable[16][MAGIC_DEF_TABLE.ID] = 16
	magictable[16][MAGIC_DEF_TABLE.NAME] = "单排杀"
	magictable[16][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[16][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[16][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[16][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 16
	magictable[16][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[16][MAGIC_DEF_TABLE.DESCPTION] = "消除单排"
	magictable[16][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[16][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[16][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[16][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[16][MAGIC_DEF_TABLE.ENERGYNEED] = 1

--十字杀
	magictable[17]={}
	magictable[17][MAGIC_DEF_TABLE.ID] = 17
	magictable[17][MAGIC_DEF_TABLE.NAME] = "十字杀"
	magictable[17][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[17][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[17][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[17][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 17
	magictable[17][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[17][MAGIC_DEF_TABLE.DESCPTION] = "消除十字"
	magictable[17][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[17][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[17][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[17][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[17][MAGIC_DEF_TABLE.ENERGYNEED] = 1


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
	magictable[1007][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true	
	magictable[1007][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1007][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--随机将一把刀变成Slime	
	magictable[1008]={}
	magictable[1008][MAGIC_DEF_TABLE.ID] = 1008
	magictable[1008][MAGIC_DEF_TABLE.NAME] = "刀变蜘蛛"
	magictable[1008][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1008][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = 	function(pBrickSpell,pbrickTarget)
															pbrickTarget.pBrickSpellLev = pBrickSpell.moninfo[monsterInfo.LEV]
															return 
														end
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

--吐出墨水
	magictable[1013]={}
	magictable[1013][MAGIC_DEF_TABLE.ID] = 1013
	magictable[1013][MAGIC_DEF_TABLE.NAME] = "便便"
	magictable[1013][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1013][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function(pBrickSpell)
															--噴射一塊便便
															
															
															local  poop = CCSprite:create("brick/SHIT.png")
															layerMain:addChild(poop,888,500);
															poop:setScale(0.5);
																
															--亂飛
															local Xr = math.random(2,brickInfo.brick_num_X-1)
															local Yr = math.random(2,brickInfo.brick_num_Y-1)
															CCMoveTo:create(1, ccp(Xr*brickInfo.brickWidth+brickInfo.brickWidth/2+math.random(-100,100), Yr*brickInfo.brickHeight-brickInfo.brickHeight/2+math.random(-100,100)))
															
															local moveby = CCMoveBy:create(1, ccp(math.random(-100,100),math.random(-100,100)))
															local delay = CCDelayTime:create(3)
															local scale = CCScaleTo:create(1, 2)
															local X = pBrickSpell.TileX
															local Y = pBrickSpell.TileY
															poop:setPosition(X*brickInfo.brickWidth+brickInfo.brickWidth/2, Y*brickInfo.brickHeight-brickInfo.brickHeight/2)
															
															poop:runAction(scale)
														
															
															function delete(sender)
																sender:removeFromParentAndCleanup(true);
															end
															local actiondelete = CCCallFuncN:create(delete)
															local arr = CCArray:create()
															arr:addObject(moveby)
															arr:addObject(delay)
															arr:addObject(actiondelete)
															local  seq = CCSequence:create(arr)	
															poop:runAction(seq)													
															return
														end
	magictable[1013][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1013][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = nil
	magictable[1013][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1013][MAGIC_DEF_TABLE.DESCPTION] = "向屏幕噴便便"
	magictable[1013][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1013][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1013][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1013][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}


--为周围怪物吸收傷害
--給玩家增加一個EFF 攻擊時判定是否有嘲諷怪
	magictable[1014]={}
	magictable[1014][MAGIC_DEF_TABLE.ID] = 1014
	magictable[1014][MAGIC_DEF_TABLE.NAME] = "嘲諷"
	magictable[1014][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1014][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1014][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1014][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1014
	magictable[1014][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1014][MAGIC_DEF_TABLE.DESCPTION] = "嘲諷"
	magictable[1014][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1014][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1014][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1014][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}

	--偷金幣
	magictable[1015]={}
	magictable[1015][MAGIC_DEF_TABLE.ID] = 1015
	magictable[1015][MAGIC_DEF_TABLE.NAME] = "偷金幣"
	magictable[1015][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1015][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function(self)
															--玩家扣掉金币
															player.LoseGold(1)
															
															--金币飞入怪物动画
															local spriteBrick = SpriteManager.creatBrickSprite(4)
															local posx,posy = 400,555
															spriteBrick:setPosition(posx,posy);		
															--poop:setPosition(X*brickInfo.brickWidth+brickInfo.brickWidth/2, Y*brickInfo.brickHeight-brickInfo.brickHeight/2)
																									
															local X,Y = self.TileX,self.TileY
															
															--缩小
															spriteBrick:setScale(0.5);
															--飘入
															local actionto = CCMoveTo:create(0.8, ccp(X*brickInfo.brickWidth+brickInfo.brickWidth/2, Y*brickInfo.brickHeight-brickInfo.brickHeight/2))
															
															--删除
															function delete(sender)
																sender:removeFromParentAndCleanup(true);
															end
															
															local actionremove = CCCallFuncN:create(delete)
															
															local arr = CCArray:create()		
															arr:addObject(actionto)
															arr:addObject(actionremove)
															
															local  seq = CCSequence:create(arr)
															spriteBrick:runAction(seq)	
															layerMain:addChild(spriteBrick,60)
														end
	magictable[1015][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1015][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = nil
	magictable[1015][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1015][MAGIC_DEF_TABLE.DESCPTION] = "偷金币1个"
	magictable[1015][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1015][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1015][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1015][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}



	--如果没满血 则攻击变猛
	magictable[1016]={}
	magictable[1016][MAGIC_DEF_TABLE.ID] = 1016
	magictable[1016][MAGIC_DEF_TABLE.NAME] = "愤怒"
	magictable[1016][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1016][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1016][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1016][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1016
	magictable[1016][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1016][MAGIC_DEF_TABLE.DESCPTION] = "愤怒"
	magictable[1016][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1016][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1016][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1016][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}


	--如果掉落最下层则爆炸
	magictable[1017]={}
	magictable[1017][MAGIC_DEF_TABLE.ID] = 1017
	magictable[1017][MAGIC_DEF_TABLE.NAME] = "自爆"
	magictable[1017][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1017][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1017][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1017][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1017
	magictable[1017][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1017][MAGIC_DEF_TABLE.DESCPTION] = "愤怒"
	magictable[1017][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1017][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1017][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1017][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
		

	--消耗玩家能量
	magictable[1018]={}
	magictable[1018][MAGIC_DEF_TABLE.ID] = 1018
	magictable[1018][MAGIC_DEF_TABLE.NAME] = "燃烧能量"
	magictable[1018][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1018][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1018][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1018][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1018
	magictable[1018][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1018][MAGIC_DEF_TABLE.DESCPTION] = "攻击时吸取玩家能量"
	magictable[1018][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1018][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1018][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1018][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
			

	--攻击使玩家装备扣级别
	magictable[1019]={}
	magictable[1019][MAGIC_DEF_TABLE.ID] = 1019
	magictable[1019][MAGIC_DEF_TABLE.NAME] = "损毁装备"
	magictable[1019][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1019][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1019][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1019][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1019
	magictable[1019][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1019][MAGIC_DEF_TABLE.DESCPTION] = "攻击时吸取玩家能量"
	magictable[1019][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1019][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1019][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1019][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
		
		
--随机与一个BRICK调换位置
	magictable[1020]={}
	magictable[1020][MAGIC_DEF_TABLE.ID] = 1020
	magictable[1020][MAGIC_DEF_TABLE.NAME] = "冰冻"
	magictable[1020][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1020][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1020][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1020][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1020
	magictable[1020][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1020][MAGIC_DEF_TABLE.DESCPTION] = "随机调换位置"
	magictable[1020][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncRandom
	magictable[1020][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1020][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1020][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
					
--相同怪物组合成新怪物



--玩家施放技能 失败返回FALSE 成功返回中招对象列表,以及 EFF实例列表
--pBrickSingle:中招对象
--pLine:预留
function p.PlayerSpellMagic(nMagicId,pBrickSingle,pLine)
	local tTargetList = {}
	local tEffList = {}

	local bTargetIsPlayer = false
	local bCast = false
	
	local magicinfo = magictable[nMagicId];
	
	if magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.PLAYER then
		
		--===对玩家施放技能===-
		--触发 施放FUNC
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
			end
		end
		
		--对TARGET增加特效
		if magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] ~= nil then
			tEffList = magiceff.AddPlayerMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]);
		else
			cclog("增加TARGET特效失败 nMagicId:"..nMagicId);
		end	
		bTargetIsPlayer = true;
		
	elseif 	magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.ALLMONSTER then
		--===对所有MON施放技能===-
		
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
			end
		end	
		
		--对all MON增加特效
		if magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] ~= nil  then
				for i = 1,brickInfo.brick_num_X do
					for j = 1,brickInfo.brick_num_Y do
						if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then						
							local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],Board[i][j],nMagicId);
							if effT ~= nil then
								table.insert(tTargetList,Board[i][j])
								table.insert(tEffList,effT)	
							end	
						end		
					end
				end	
		end	
		
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

					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],Board[X][Y],nMagicId);	
					if effT ~= nil then
					--effT不为空则施放成功
							if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
								if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](Board[X][Y]) then
									bCast = true
								end
							end
												
							table.insert(tTargetList,Board[X][Y])
							table.insert(tEffList,effT)
					end	
				end
			end
		end			
		

		
	elseif 	magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.AI_MONSTER then
		--使用AI获取施法对象
		if magicinfo[MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] ~= nil then
			local pbricklist = magicinfo[MAGIC_DEF_TABLE.AI_CHOOSE_FUNC](pBrickSingle,magicinfo[MAGIC_DEF_TABLE.CHOOSE_PARAM]);
			
			for i,pbrick in pairs(pbricklist) do
				if pbrick ~= nil then
					
					if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
						if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle,pbrick) then
							bCast = true
						end
					end
					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],pbrick);	
					table.insert(tTargetList,pbrick)
					table.insert(tEffList,effT)	
				end
			end
		end	
	end
	
	--无特效技能施放则bcast=true 
	--特效技能技能施放则 tTargetList~=nil
	if bCast or tTargetList~= nil then
		player.UseMagic(nMagicId)
	end
	
	if bTargetIsPlayer then
		return player,tEffList
	else
		return tTargetList,tEffList;	
	end	
end



--怪物施放技能 失败返回FALSE 成功返回中招对象列表,以及 EFF实例列表
--pBrickSingle:施法怪物
function p.monsterSpellMagic(nMagicId,pBrickSingle,pLine)
	local tTargetList = {}
	local tEffList = {}

	local bCast = false
	
	if magictable[nMagicId] == nil then
		return false;
	end

	local magicinfo = magictable[nMagicId];

	if magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.PLAYER then
		cclog("SpellMagic PLAYER")
		--===对玩家施放技能===-
		--触发 施放FUNC
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
				
			end
		end
		
		--对TARGET增加特效
		if magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] ~= nil  then
			local  effT = magiceff.AddPlayerMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]);
			if effT ~= nil then
				tEffList = effT
			end	
		else
			cclog("增加TARGET特效失败 nMagicId:"..nMagicId);
		end
		
		tTargetList = player
	elseif 	magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.ALLMONSTER then
		--===对所有MON施放技能===-
		
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
			end
		end		
		
		--对all MON增加特效
		if magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] ~= nil  then
				for i = 1,brickInfo.brick_num_X do
					for j = 1,brickInfo.brick_num_Y do
						if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then						
							local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],Board[i][j],nMagicId);
							if effT ~= nil then
								table.insert(tTargetList,Board[i][j])
								table.insert(tEffList,effT)	
							end
						end		
					end
				end	
		end	
		
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

					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],Board[X][Y],nMagicId);	
					if effT ~= nil then
					--effT不为空则施放成功
							if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
								if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](Board[X][Y]) then
									bCast = true
								end
							end
												
							table.insert(tTargetList,Board[X][Y])
							table.insert(tEffList,effT)
					end	
				end
			end
		end				
	elseif 	magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.AI_MONSTER then
		--使用AI获取施法对象
		if magicinfo[MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] ~= nil then
			local pbricklist = magicinfo[MAGIC_DEF_TABLE.AI_CHOOSE_FUNC](pBrickSingle,magicinfo[MAGIC_DEF_TABLE.CHOOSE_PARAM]);
			
			for i,pbrick in pairs(pbricklist) do
				if pbrick ~= nil then
					
					if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
						if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle,pbrick) then
							bCast = true
						end
					end
					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],pbrick);	
					table.insert(tTargetList,pbrick)
					table.insert(tEffList,effT)	
				end
			end
		end	
	end
	
	--无特效技能施放则bcast=true 
	--特效技能技能施放则 tTargetList~=nil
	if bCast or tTargetList~= nil then
		--怪物施放技能成功
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














