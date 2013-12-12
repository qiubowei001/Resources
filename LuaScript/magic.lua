--============���ʩ�ŷ�������=============--

magic = {}
local p = magic;

--ѡ������
TARGET_TYPE =
{
	PLAYER = 0,
	ALL_BRICK = 1,
	SINGLE_BRICK = 2,
	LINE = 3,
	AI_MONSTER=4,
	ALLMONSTER =5,
}




--���ܶ����
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
	CDROUND = 31,
}

-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>�ͷ�ʱ������������======================================--
--����true���ʾ����ʩ�ųɹ�
--Ⱥ�嶾
function magicfunction03()
	local bcast = false
	--���Ӷ���Ч
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

--������
function magicfunction07(pbrick)
	
	if pbrick.nType == tbrickType.MONSTER then								
		Particle.AddParticleEffToBrick(pbrick,"star")
		return true;
	end
	return false;
end



--==============================�ͷ�ʱ������������<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--



--==AIѡȡ����FUNC==--
--���ѡȡһ����BRICK
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

--���ѡȡһ��BRICK
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


--ѡȡ�Լ���ΧR�뾶
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





--�������ñ�
--=============��Ҽ���==============---
magictable = {}
	magictable[1]={}
	magictable[1][MAGIC_DEF_TABLE.ID] = 1
	magictable[1][MAGIC_DEF_TABLE.NAME] = "�߻���"
	magictable[1][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1
	magictable[1][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[1][MAGIC_DEF_TABLE.DESCPTION] = "��ǿ��ҹ�����5�غ�"
	magictable[1][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1][MAGIC_DEF_TABLE.CDROUND] =  5
	

	magictable[2]={}
	magictable[2][MAGIC_DEF_TABLE.ID] = 2
	magictable[2][MAGIC_DEF_TABLE.NAME] = "Ⱥ���˺�"
	magictable[2][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[2][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[2][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[2][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 2
	magictable[2][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[2][MAGIC_DEF_TABLE.DESCPTION] = "�˺����й���"
	magictable[2][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[2][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[2][MAGIC_DEF_TABLE.CDROUND] =  5
	
	magictable[3]={}
	magictable[3][MAGIC_DEF_TABLE.ID] = 3
	magictable[3][MAGIC_DEF_TABLE.NAME] = "Ⱥ�嶾"
	magictable[3][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[3][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = magicfunction03
	magictable[3][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[3][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 3
	magictable[3][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[3][MAGIC_DEF_TABLE.DESCPTION] = "�����й���"
	magictable[3][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[3][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[3][MAGIC_DEF_TABLE.CDROUND] =  5
	
	
	magictable[4]={}
	magictable[4][MAGIC_DEF_TABLE.ID] = 4
	magictable[4][MAGIC_DEF_TABLE.NAME] = "��Ǯ��"
	magictable[4][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[4][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[4][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[4][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 4
	magictable[4][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[4][MAGIC_DEF_TABLE.DESCPTION] = "Ⱥ��������"
	magictable[4][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[4][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[4][MAGIC_DEF_TABLE.CDROUND] =  5
	
	
	magictable[5]={}
	magictable[5][MAGIC_DEF_TABLE.ID] = 5
	magictable[5][MAGIC_DEF_TABLE.NAME] = "�ö�ѪƿŶ"
	magictable[5][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[5][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[5][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[5][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 5
	magictable[5][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[5][MAGIC_DEF_TABLE.DESCPTION] = "Ⱥ������Ѫƿ"
	magictable[5][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[5][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[5][MAGIC_DEF_TABLE.CDROUND] =  5
	
	
	--��ҵ�������ը������ ��ըN*N��brick
	magictable[6]={}
	magictable[6][MAGIC_DEF_TABLE.ID] = 6
	magictable[6][MAGIC_DEF_TABLE.NAME] = "��ը"
	magictable[6][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[6][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[6][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[6][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 6
	magictable[6][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[6][MAGIC_DEF_TABLE.DESCPTION] = "��ҵ�������ը������ ��ըN*N��brick"
	magictable[6][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[6][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[6][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[6][MAGIC_DEF_TABLE.CDROUND] =  5
	
	--��� ѣ�ε�������Ч��
	magictable[7]={}
	magictable[7][MAGIC_DEF_TABLE.ID] = 7
	magictable[7][MAGIC_DEF_TABLE.NAME] = "����ѣ��"
	magictable[7][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[7][MAGIC_DEF_TABLE.SPELL_FUNC_ID]  = magicfunction07
	magictable[7][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[7][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 7
	magictable[7][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[7][MAGIC_DEF_TABLE.DESCPTION] = "��ҵ����ʹ�����޷�����3�غ�"
	magictable[7][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[7][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[7][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[7][MAGIC_DEF_TABLE.CDROUND] =  5
	
--��� ѣ�ζ������
	magictable[8]={}
	magictable[8][MAGIC_DEF_TABLE.ID] = 8
	magictable[8][MAGIC_DEF_TABLE.NAME] = "Ⱥ��ѣ��"
	magictable[8][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[8][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = magicfunction07
	magictable[8][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[8][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 8
	magictable[8][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[8][MAGIC_DEF_TABLE.DESCPTION] = "��ҵ����ʹһȺ�����޷�����3�غ�"
	magictable[8][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}
	magictable[8][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[8][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[8][MAGIC_DEF_TABLE.CDROUND] =  5
	
	
--��Ѫ
	magictable[9]={}
	magictable[9][MAGIC_DEF_TABLE.ID] = 9
	magictable[9][MAGIC_DEF_TABLE.NAME] = "��Ѫ"
	magictable[9][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[9][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[9][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[9][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 9
	magictable[9][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[9][MAGIC_DEF_TABLE.DESCPTION] = "��ҹ���ʱ����50%���� 3�غ�"
	--magictable[9][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}
	--magictable[9][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[9][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[9][MAGIC_DEF_TABLE.CDROUND] =  5
	
--�����˺�N�غ�	
	magictable[10]={}
	magictable[10][MAGIC_DEF_TABLE.ID] = 10
	magictable[10][MAGIC_DEF_TABLE.NAME] = "��ҷ���"
	magictable[10][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[10][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[10][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[10][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 10
	magictable[10][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[10][MAGIC_DEF_TABLE.DESCPTION] = "��ұ�����ʱ,������ʧ50%���� 3�غ�"
	magictable[10][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[10][MAGIC_DEF_TABLE.CDROUND] =  5
	
	
--��� ������
	magictable[11]={}
	magictable[11][MAGIC_DEF_TABLE.ID] = 11
	magictable[11][MAGIC_DEF_TABLE.NAME] = "������"
	magictable[11][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[11][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[11][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[11][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 11
	magictable[11][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[11][MAGIC_DEF_TABLE.DESCPTION] = "��һֻ�������磬���������˺�N��"
	magictable[11][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[11][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[11][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[11][MAGIC_DEF_TABLE.CDROUND] =  5


--��� NXN��
	magictable[12]={}
	magictable[12][MAGIC_DEF_TABLE.ID] = 12
	magictable[12][MAGIC_DEF_TABLE.NAME] = "Ⱥ�嶾"
	magictable[12][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[12][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[12][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[12][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 3
	magictable[12][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[12][MAGIC_DEF_TABLE.DESCPTION] = "��4x4����"
	magictable[12][MAGIC_DEF_TABLE.SPELL_TYPE] = tbrickType.MONSTER
	magictable[12][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[12][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}
	magictable[12][MAGIC_DEF_TABLE.CDROUND] =  5
	
--��������
	magictable[13]={}
	magictable[13][MAGIC_DEF_TABLE.ID] = 13
	magictable[13][MAGIC_DEF_TABLE.NAME] = "������ұ�����100"
	magictable[13][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[13][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[13][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[13][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 13
	magictable[13][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[13][MAGIC_DEF_TABLE.DESCPTION] = "������ұ�����100"
	magictable[13][MAGIC_DEF_TABLE.CDROUND] =  5


--���ܸ���
	magictable[14]={}
	magictable[14][MAGIC_DEF_TABLE.ID] = 14
	magictable[14][MAGIC_DEF_TABLE.NAME] = "�������������100"
	magictable[14][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[14][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[14][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[14][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 14
	magictable[14][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[14][MAGIC_DEF_TABLE.DESCPTION] = "�������������100"
	magictable[14][MAGIC_DEF_TABLE.CDROUND] =  5
	
--�ӵ�ʱ��
	magictable[15]={}
	magictable[15][MAGIC_DEF_TABLE.ID] = 15
	magictable[15][MAGIC_DEF_TABLE.NAME] = "�ӵ�ʱ��"
	magictable[15][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[15][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[15][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[15][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 15
	magictable[15][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[15][MAGIC_DEF_TABLE.DESCPTION] = "������Ϸ�ٶ�"
	magictable[15][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[15][MAGIC_DEF_TABLE.CDROUND] =  5
	

--Ѫ����ԽС ����Խǿ




--ɱ��һֻ���﹥������N,����»غ���ɱ������ �����0



	

--=============���＼��==============---
--����Χ���й������ӹ���
	magictable[1007]={}
	magictable[1007][MAGIC_DEF_TABLE.ID] = 1007
	magictable[1007][MAGIC_DEF_TABLE.NAME] = "��ħ�⻷"
	magictable[1007][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1007][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1007][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.ALLMONSTER
	magictable[1007][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1007
	magictable[1007][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1007][MAGIC_DEF_TABLE.DESCPTION] = "����Χ���й������ӹ���3"
	magictable[1007][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true	
	magictable[1007][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1007][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--�����һ�ѵ����Slime	
	magictable[1008]={}
	magictable[1008][MAGIC_DEF_TABLE.ID] = 1008
	magictable[1008][MAGIC_DEF_TABLE.NAME] = "����֩��"
	magictable[1008][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1008][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = 	function(pBrickSpell,pbrickTarget)
															pbrickTarget.pBrickSpellLev = pBrickSpell.moninfo[monsterInfo.LEV]
															return 
														end
	magictable[1008][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1008][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1008
	magictable[1008][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1008][MAGIC_DEF_TABLE.DESCPTION] = "�����һ�ѵ����С֩��"
	magictable[1008][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncRandomSword
	magictable[1008][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1008][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1008][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--�����һ��BRICK��Ϊ���� ��������
	magictable[1009]={}
	magictable[1009][MAGIC_DEF_TABLE.ID] = 1009
	magictable[1009][MAGIC_DEF_TABLE.NAME] = "����"
	magictable[1009][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1009][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1009][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1009][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1009
	magictable[1009][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1009][MAGIC_DEF_TABLE.DESCPTION] = "�������һ������"
	magictable[1009][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncRandom
	magictable[1009][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1009][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1009][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--������ʱ���ն���
	magictable[1010]={}
	magictable[1010][MAGIC_DEF_TABLE.ID] = 1010
	magictable[1010][MAGIC_DEF_TABLE.NAME] = "���"
	magictable[1010][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1010][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1010][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1010][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1010
	magictable[1010][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1010][MAGIC_DEF_TABLE.DESCPTION] = "������ʱ���ն���"
	magictable[1010][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1010][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1010][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1010][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--������Ѫ
	magictable[1011]={}
	magictable[1011][MAGIC_DEF_TABLE.ID] = 1011
	magictable[1011][MAGIC_DEF_TABLE.NAME] = "��Ѫ"
	magictable[1011][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1011][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1011][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1011][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1011
	magictable[1011][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1011][MAGIC_DEF_TABLE.DESCPTION] = "����ʱ��ȡ�������"
	magictable[1011][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1011][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1011][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1011][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--Ϊ��Χ���ﲹѪ
	magictable[1012]={}
	magictable[1012][MAGIC_DEF_TABLE.ID] = 1012
	magictable[1012][MAGIC_DEF_TABLE.NAME] = "Ⱥ������"
	magictable[1012][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1012][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1012][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1012][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1012
	magictable[1012][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1012][MAGIC_DEF_TABLE.DESCPTION] = "Ⱥ������nxn"
	magictable[1012][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1012][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1012][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1012][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}

--��ͬ������ϳ��¹���



--���ʩ�ż��� ʧ�ܷ���FALSE �ɹ��������ж����б�,�Լ� EFFʵ���б�
--pBrickSingle:���ж���
--pLine:Ԥ��
function p.PlayerSpellMagic(nMagicId,pBrickSingle,pLine)
	local tTargetList = {}
	local tEffList = {}

	local bCast = false
	
	if magictable[nMagicId] == nil then
		return false;
	end

	--���¼���CD
	if player.IfCanUseMagic(nMagicId) == false then
		return;
	end

	local magicinfo = magictable[nMagicId];
	
	if magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.PLAYER then
		cclog("SpellMagic PLAYER")
		--===�����ʩ�ż���===-
		--���� ʩ��FUNC
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
			end
		end
		
		--��TARGET������Ч
		if magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] ~= nil and magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] ~= nil then
			magiceff.AddPlayerMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0]);
		else
			cclog("����TARGET��Чʧ�� nMagicId:"..nMagicId);
		end
		
	elseif 	magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.ALLMONSTER then
		--===������MONʩ�ż���===-
		
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
			end
		end	
		
		--��all MON������Ч
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
		
	elseif magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.SINGLE_BRICK then
		--��ĳһ��BRICK�ͷż���	
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
					--effT��Ϊ����ʩ�ųɹ�
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
		--ʹ��AI��ȡʩ������
		if magicinfo[MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] ~= nil then
			local pbricklist = magicinfo[MAGIC_DEF_TABLE.AI_CHOOSE_FUNC](pBrickSingle,magicinfo[MAGIC_DEF_TABLE.CHOOSE_PARAM]);
			
			for i,pbrick in pairs(pbricklist) do
				if pbrick ~= nil then
					
					if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
						if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle,pbrick) then
							bCast = true
						end
					end
					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0],pbrick);	
					table.insert(tTargetList,pbrick)
					table.insert(tEffList,effT)	
				end
			end
		end	
	end
	
	--����Ч����ʩ����bcast=true 
	--��Ч���ܼ���ʩ���� tTargetList~=nil
	--1000�ڼ���������Ҽ���
	if bCast and tTargetList~= nil and nMagicId <1000 then
		player.UseMagic(nMagicId)
	end
	
	return tTargetList,tEffList;
end



--����ʩ�ż��� ʧ�ܷ���FALSE �ɹ��������ж����б�,�Լ� EFFʵ���б�
--pBrickSingle:ʩ������
function p.monsterSpellMagic(nMagicId,pBrickSingle,pLine)
	local tTargetList = {}
	local tEffList = {}

	local bCast = false
	
	if magictable[nMagicId] == nil then
		return false;
	end

	--���ʹ�ü��� �����¼���CD
	if nMagicId <1000 then
		
		if player.IfCanUseMagic(nMagicId) == false then
			return;
		end
	end
	
	local magicinfo = magictable[nMagicId];

	--NEXT_MAGIC
	
	if magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.PLAYER then
		cclog("SpellMagic PLAYER")
		--===�����ʩ�ż���===-
		--���� ʩ��FUNC
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
			end
		end
		
		--��TARGET������Ч
		if magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] ~= nil and magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] ~= nil then
			magiceff.AddPlayerMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0]);
		else
			cclog("����TARGET��Чʧ�� nMagicId:"..nMagicId);
		end
		
	elseif 	magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.ALLMONSTER then
		--===������MONʩ�ż���===-
		
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
			end
		end		
		
		--��all MON������Ч
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
		
	elseif magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.SINGLE_BRICK then
		--��ĳһ��BRICK�ͷż���	
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
					--effT��Ϊ����ʩ�ųɹ�
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
		--ʹ��AI��ȡʩ������
		if magicinfo[MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] ~= nil then
			local pbricklist = magicinfo[MAGIC_DEF_TABLE.AI_CHOOSE_FUNC](pBrickSingle,magicinfo[MAGIC_DEF_TABLE.CHOOSE_PARAM]);
			
			for i,pbrick in pairs(pbricklist) do
				if pbrick ~= nil then
					
					if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
						if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle,pbrick) then
							bCast = true
						end
					end
					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0],pbrick);	
					table.insert(tTargetList,pbrick)
					table.insert(tEffList,effT)	
				end
			end
		end	
	end
	
	--����Ч����ʩ����bcast=true 
	--��Ч���ܼ���ʩ���� tTargetList~=nil
	--1000�ڼ���������Ҽ���
	if bCast and tTargetList~= nil and nMagicId <1000 then
		player.UseMagic(nMagicId)
	end
	
	return tTargetList,tEffList;
end

--��ȡ���ܵĶ�������
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














