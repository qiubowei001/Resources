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
	TOTARGET_EFFECT_FUNCPHASE_0 = 10,	--������
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


function getFromTo(cord,Limit,nR)
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
--���ѡȡһ��Monster(���Լ�)
function p.AIChooseFuncRandomMonster(pmonster)
	local tmon = {}
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then
				if	Board[i][j].nType == tbrickType.MONSTER then
					if pmonster ~= Board[i][j] then 
						table.insert(tmon,Board[i][j])
					end
				end
			end
		end
	end
	
	if #tmon > 0 then
		return {tmon[math.random(1,#tmon)]};
	end
	return {};	
end	

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
function p.AIChooseFuncRandom(pmonster,tparam)
	local nR= 0
	if tparam == nil then
		nR = 0
	else
		nR = tparam.R;
	end

	
		
	local tList = {}
	local pmonsterlist = {}
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
		local target = tList[math.random(1,#tList)];  --{tList[math.random(1,#tList)]};
		local tileX = target.TileX
		local tileY = target.TileY
		local fromx,tox = getFromTo(tileX,brickInfo.brick_num_X,nR)
		local fromy,toy = getFromTo(tileY,brickInfo.brick_num_Y,nR)
		for X = fromx,tox,1 do
			for Y = fromy ,toy,1 do
				if Board[X][Y]~= nil then
					table.insert(pmonsterlist,Board[X][Y])
					
				end
			end
		end
		return pmonsterlist
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
	
		local fromx,tox = getFromTo(tileX,brickInfo.brick_num_X,nR)
		local fromy,toy = getFromTo(tileY,brickInfo.brick_num_Y,nR)
		for X = fromx,tox,1 do
			for Y = fromy ,toy,1 do
				if Board[X][Y]~= nil then
					table.insert(pmonsterlist,Board[X][Y])
				end
			end
		end			
		
	return pmonsterlist;
end


--���ѡȡһ��ѪBRICK
function p.AIChooseFuncRandomBlood(pmonster)
	local tswordList = {}
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then
				if	Board[i][j].nType == tbrickType.BLOOD then
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

--���ѡȡһ�����BRICK
function p.AIChooseFuncRandomGOLD(pmonster)
	local tswordList = {}
	for i = 1,brickInfo.brick_num_X do
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then
				if	Board[i][j].nType == tbrickType.GOLD then
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



--�������ñ�
--=============��Ҽ���==============---
magictable = {}
	magictable[1]={}
	magictable[1][MAGIC_DEF_TABLE.ID] = 1
	magictable[1][MAGIC_DEF_TABLE.NAME] = "�߻���"
	magictable[1][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function()
															Hint.ShowHint(Hint.tHintType.powerup)	
															return 
														end
	magictable[1][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1
	magictable[1][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[1][MAGIC_DEF_TABLE.DESCPTION] = "��ǿ��ҹ�����5�غ�"
	magictable[1][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1][MAGIC_DEF_TABLE.CDROUND] =  7
	magictable[1][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1][MAGIC_DEF_TABLE.ENERGYNEED] = 1
	
	
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
	magictable[2][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[2][MAGIC_DEF_TABLE.ENERGYNEED] = 1

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
	magictable[3][MAGIC_DEF_TABLE.CDROUND] =  7
	magictable[3][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[3][MAGIC_DEF_TABLE.ENERGYNEED] = 1

	
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
	magictable[4][MAGIC_DEF_TABLE.CDROUND] =  7
	magictable[4][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[4][MAGIC_DEF_TABLE.ENERGYNEED] = 3

	
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
	magictable[5][MAGIC_DEF_TABLE.CDROUND] =  7
	magictable[5][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[5][MAGIC_DEF_TABLE.ENERGYNEED] = 3

	
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
	magictable[6][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[6][MAGIC_DEF_TABLE.ENERGYNEED] = 1

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
	magictable[7][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[7][MAGIC_DEF_TABLE.ENERGYNEED] = 1

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
	magictable[8][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[8][MAGIC_DEF_TABLE.ENERGYNEED] = 1
	
	
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
	magictable[9][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[9][MAGIC_DEF_TABLE.ENERGYNEED] = 1

	
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
	magictable[10][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[10][MAGIC_DEF_TABLE.ENERGYNEED] = 1

	
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
	magictable[11][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[11][MAGIC_DEF_TABLE.ENERGYNEED] = 1


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
	magictable[12][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[12][MAGIC_DEF_TABLE.ENERGYNEED] = 1

--��������
	magictable[13]={}
	magictable[13][MAGIC_DEF_TABLE.ID] = 13
	magictable[13][MAGIC_DEF_TABLE.NAME] = "������ұ�����100"
	magictable[13][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[13][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function()
															Hint.ShowHint(Hint.tHintType.criticalUp)	
															return 
														end
	magictable[13][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[13][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 13
	magictable[13][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[13][MAGIC_DEF_TABLE.DESCPTION] = "������ұ�����100"
	magictable[13][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[13][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[13][MAGIC_DEF_TABLE.ENERGYNEED] = 1


--���ܸ���
	magictable[14]={}
	magictable[14][MAGIC_DEF_TABLE.ID] = 14
	magictable[14][MAGIC_DEF_TABLE.NAME] = "�������������100"
	magictable[14][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[14][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function()
															Hint.ShowHint(Hint.tHintType.dodgeUp)		
															return 
														end
	magictable[14][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[14][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 14
	magictable[14][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[14][MAGIC_DEF_TABLE.DESCPTION] = "�������������100"
	magictable[14][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[14][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[14][MAGIC_DEF_TABLE.ENERGYNEED] = 1

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
	magictable[15][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[15][MAGIC_DEF_TABLE.ENERGYNEED] = 1


--����ɱ
	magictable[16]={}
	magictable[16][MAGIC_DEF_TABLE.ID] = 16
	magictable[16][MAGIC_DEF_TABLE.NAME] = "����ɱ"
	magictable[16][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[16][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[16][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[16][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 16
	magictable[16][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[16][MAGIC_DEF_TABLE.DESCPTION] = "��������"
	magictable[16][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[16][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[16][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[16][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[16][MAGIC_DEF_TABLE.ENERGYNEED] = 1

--ʮ��ɱ
	magictable[17]={}
	magictable[17][MAGIC_DEF_TABLE.ID] = 17
	magictable[17][MAGIC_DEF_TABLE.NAME] = "ʮ��ɱ"
	magictable[17][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[17][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[17][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.SINGLE_BRICK
	magictable[17][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 17
	magictable[17][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.BEFORE_PLAYER_ACT
	magictable[17][MAGIC_DEF_TABLE.DESCPTION] = "����ʮ��"
	magictable[17][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[17][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
	magictable[17][MAGIC_DEF_TABLE.CDROUND] =  5
	magictable[17][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[17][MAGIC_DEF_TABLE.ENERGYNEED] = 1


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

--�³�īˮ
	magictable[1013]={}
	magictable[1013][MAGIC_DEF_TABLE.ID] = 1013
	magictable[1013][MAGIC_DEF_TABLE.NAME] = "���"
	magictable[1013][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1013][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function(pBrickSpell)
															--����һ�K���
															
															
															local  poop = CCSprite:create("brick/SHIT.png")
															layerMain:addChild(poop,888,500);
															poop:setScale(0.5);
																
															--�y�w
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
	magictable[1013][MAGIC_DEF_TABLE.DESCPTION] = "����Ļ�����"
	magictable[1013][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1013][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1013][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1013][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}


--Ϊ��Χ�������Ղ���
--�o�������һ��EFF �����r�ж��Ƿ��г��S��
	magictable[1014]={}
	magictable[1014][MAGIC_DEF_TABLE.ID] = 1014
	magictable[1014][MAGIC_DEF_TABLE.NAME] = "���S"
	magictable[1014][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1014][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1014][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1014][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1014
	magictable[1014][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1014][MAGIC_DEF_TABLE.DESCPTION] = "���S"
	magictable[1014][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1014][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1014][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1014][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}

	--͵����
	magictable[1015]={}
	magictable[1015][MAGIC_DEF_TABLE.ID] = 1015
	magictable[1015][MAGIC_DEF_TABLE.NAME] = "͵����"
	magictable[1015][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1015][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function(self)
															--��ҿ۵����
															player.LoseGold(1)
															
															--��ҷ�����ﶯ��
															local spriteBrick = SpriteManager.creatBrickSprite(4)
															local posx,posy = 400,555
															spriteBrick:setPosition(posx,posy);		
															--poop:setPosition(X*brickInfo.brickWidth+brickInfo.brickWidth/2, Y*brickInfo.brickHeight-brickInfo.brickHeight/2)
																									
															local X,Y = self.TileX,self.TileY
															
															--��С
															spriteBrick:setScale(0.5);
															--Ʈ��
															local actionto = CCMoveTo:create(0.8, ccp(X*brickInfo.brickWidth+brickInfo.brickWidth/2, Y*brickInfo.brickHeight-brickInfo.brickHeight/2))
															
															--ɾ��
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
	magictable[1015][MAGIC_DEF_TABLE.DESCPTION] = "͵���1��"
	magictable[1015][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1015][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1015][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1015][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}



	--���û��Ѫ �򹥻�����
	magictable[1016]={}
	magictable[1016][MAGIC_DEF_TABLE.ID] = 1016
	magictable[1016][MAGIC_DEF_TABLE.NAME] = "��ŭ"
	magictable[1016][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1016][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1016][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1016][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1016
	magictable[1016][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1016][MAGIC_DEF_TABLE.DESCPTION] = "��ŭ"
	magictable[1016][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1016][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1016][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1016][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}


	--����������²���ը
	magictable[1017]={}
	magictable[1017][MAGIC_DEF_TABLE.ID] = 1017
	magictable[1017][MAGIC_DEF_TABLE.NAME] = "�Ա�"
	magictable[1017][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1017][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1017][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1017][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1017
	magictable[1017][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1017][MAGIC_DEF_TABLE.DESCPTION] = "��ŭ"
	magictable[1017][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1017][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1017][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1017][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 0}
		

	--�����������
	magictable[1018]={}
	magictable[1018][MAGIC_DEF_TABLE.ID] = 1018
	magictable[1018][MAGIC_DEF_TABLE.NAME] = "ȼ������"
	magictable[1018][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1018][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1018][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1018][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1018
	magictable[1018][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1018][MAGIC_DEF_TABLE.DESCPTION] = "����ʱ��ȡ�������"
	magictable[1018][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1018][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1018][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1018][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
			

	--����ʹ���װ���ۼ���
	magictable[1019]={}
	magictable[1019][MAGIC_DEF_TABLE.ID] = 1019
	magictable[1019][MAGIC_DEF_TABLE.NAME] = "���װ��"
	magictable[1019][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1019][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1019][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1019][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1019
	magictable[1019][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1019][MAGIC_DEF_TABLE.DESCPTION] = "����ʱ��ȡ�������"
	magictable[1019][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1019][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1019][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1019][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
		
		
--�����һ��BRICK����λ��
	magictable[1020]={}
	magictable[1020][MAGIC_DEF_TABLE.ID] = 1020
	magictable[1020][MAGIC_DEF_TABLE.NAME] = "����"
	magictable[1020][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1020][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1020][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1020][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1020
	magictable[1020][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1020][MAGIC_DEF_TABLE.DESCPTION] = "�������λ��"
	magictable[1020][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncRandom
	magictable[1020][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1020][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1020][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
	
	magictable[1021]={}
	magictable[1021][MAGIC_DEF_TABLE.ID] = 1021
	magictable[1021][MAGIC_DEF_TABLE.NAME] = "������ж�"
	magictable[1021][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1021][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1021][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1021][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1021
	magictable[1021][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[1021][MAGIC_DEF_TABLE.DESCPTION] = "����ж�"
	magictable[1021][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1021][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1021][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1021][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
	magictable[1022]={}
	magictable[1022][MAGIC_DEF_TABLE.ID] = 1022
	magictable[1022][MAGIC_DEF_TABLE.NAME] = "�������Ŀ�ڵ�����"
	magictable[1022][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1022][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function(self)
															local scene = Main.GetGameScene();
															local ShineSprite = scene:getChildByTag(UIdefine.ShineSkill);		
															if ShineSprite ~= nil then
																ShineSprite:removeFromParentAndCleanup(true);
															end	
															
															local posx,posy = 500,400
															
															
															local w,h = 1200,800
															local textureShine = CCTextureCache:sharedTextureCache():addImage("UI/shine_effect.png")
															local rect = CCRectMake(0, 0, w, h)
															local frame0 = CCSpriteFrame:createWithTexture(textureShine, rect)
															local ShineSprite = CCSprite:createWithSpriteFrame(frame0)
															ShineSprite:setPosition(w/2, h/2);		
															scene:addChild(ShineSprite,99,UIdefine.ShineSkill)
											
															ShineSprite:setOpacity(0)
															
															local opacityShine = CCFadeTo:create(0.5 , 255)
															local opacityFade = CCFadeTo:create(5 , 0)
															--ShineSprite:runAction(opacity)
														
															--ɾ��
															function delete(sender)
																sender:removeFromParentAndCleanup(true);
															end
															
															local actionremove = CCCallFuncN:create(delete)
															
															local arr = CCArray:create()	
															arr:addObject(opacityShine)	
															arr:addObject(opacityFade)
															arr:addObject(actionremove)
															
															local  seq = CCSequence:create(arr)
															ShineSprite:runAction(seq)	
															
														end
	magictable[1022][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1022][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = nil
	magictable[1022][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1022][MAGIC_DEF_TABLE.DESCPTION] = "��Ŀ"
	magictable[1022][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1022][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1022][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1022][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
	magictable[1023]={}
	magictable[1023][MAGIC_DEF_TABLE.ID] = 1023
	magictable[1023][MAGIC_DEF_TABLE.NAME] = "����ҹ�������"
	magictable[1023][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1023][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1023][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1023][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1023
	magictable[1023][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[1023][MAGIC_DEF_TABLE.DESCPTION] = "�������"
	magictable[1023][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1023][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1023][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1023][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil							
	
	
	--�Ե�����brick
	magictable[1024]={}
	magictable[1024][MAGIC_DEF_TABLE.ID] = 1024
	magictable[1024][MAGIC_DEF_TABLE.NAME] = "͵����"
	magictable[1024][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1024][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = function(self,spriteBrick)
															Main.destroyBrick(spriteBrick.TileX,spriteBrick.TileY,false)
															
															--��ҷ�����ﶯ��
															local X,Y = self.TileX,self.TileY
															
															--��С
															spriteBrick:setScale(0.5);
															--Ʈ��
															local actionto = CCMoveTo:create(1.5, ccp(X*brickInfo.brickWidth+brickInfo.brickWidth/2, Y*brickInfo.brickHeight-brickInfo.brickHeight/2))
															
															--ɾ��
															function delete(sender)
																sender:removeFromParentAndCleanup(true);
															end
															
															local actionremove = CCCallFuncN:create(delete)
															
															local arr = CCArray:create()		
															arr:addObject(actionto)
															arr:addObject(actionremove)
															
															local  seq = CCSequence:create(arr)
															spriteBrick:runAction(seq)	
														end
	magictable[1024][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1024][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = nil
	magictable[1024][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1024][MAGIC_DEF_TABLE.DESCPTION] = "͵���1��"
	magictable[1024][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncRandomGOLD
	magictable[1024][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1024][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1024][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}


--ʱ�����
	magictable[1025]={}
	magictable[1025][MAGIC_DEF_TABLE.ID] = 1025
	magictable[1025][MAGIC_DEF_TABLE.NAME] = "��ʱ�����"
	magictable[1025][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1025][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1025][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1025][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1025
	magictable[1025][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[1025][MAGIC_DEF_TABLE.DESCPTION] = "��ʱ�����"
	magictable[1025][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1025][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1025][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1025][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
	
--�����һƿѪ��ɶ�ҩ
	magictable[1026]={}
	magictable[1026][MAGIC_DEF_TABLE.ID] = 1026
	magictable[1026][MAGIC_DEF_TABLE.NAME] = "Ѫ�䶾ҩ"
	magictable[1026][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1026][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = 	nil
	magictable[1026][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1026][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1026
	magictable[1026][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1026][MAGIC_DEF_TABLE.DESCPTION] = "�����һƿѪ�䶾ҩ"
	magictable[1026][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncRandomBlood
	magictable[1026][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1026][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1026][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--ʹ�������﹥���ٶ�����
	magictable[1027]={}
	magictable[1027][MAGIC_DEF_TABLE.ID] = 1027
	magictable[1027][MAGIC_DEF_TABLE.NAME] = "���й������"
	magictable[1027][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1027][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = 	nil
	magictable[1027][MAGIC_DEF_TABLE.TARGET_TYPE] =  TARGET_TYPE.ALLMONSTER
	magictable[1027][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1027
	magictable[1027][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1027][MAGIC_DEF_TABLE.DESCPTION] = "����"
	magictable[1027][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = nil
	magictable[1027][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1027][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1027][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil

--����
	magictable[1028]={}
	magictable[1028][MAGIC_DEF_TABLE.ID] = 1028
	magictable[1028][MAGIC_DEF_TABLE.NAME] = "����"
	magictable[1028][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1028][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = 	function(self,spriteBrick)
															self.HideRound = 3
														end
	magictable[1028][MAGIC_DEF_TABLE.TARGET_TYPE] =  TARGET_TYPE.AI_MONSTER
	magictable[1028][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1028
	magictable[1028][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1028][MAGIC_DEF_TABLE.DESCPTION] = "����"
	magictable[1028][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1028][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1028][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1028][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil



--����Ե���һ������ ��ǿ��
	magictable[1029]={}
	magictable[1029][MAGIC_DEF_TABLE.ID] = 1029
	magictable[1029][MAGIC_DEF_TABLE.NAME] = "�Թֱ�ǿ"
	magictable[1029][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1029][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = 	nil
	magictable[1029][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1029][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1029
	magictable[1029][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1029][MAGIC_DEF_TABLE.DESCPTION] = "�Թֱ�ǿ"
	magictable[1029][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncRandomMonster
	magictable[1029][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1029][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1029][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
	
--����
	magictable[1030]={}
	magictable[1030][MAGIC_DEF_TABLE.ID] = 1030
	magictable[1030][MAGIC_DEF_TABLE.NAME] = "����"
	magictable[1030][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1030][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = 	nil
	magictable[1030][MAGIC_DEF_TABLE.TARGET_TYPE] =  TARGET_TYPE.AI_MONSTER
	magictable[1030][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1030
	magictable[1030][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1030][MAGIC_DEF_TABLE.DESCPTION] = "����"
	magictable[1030][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1030][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1030][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1030][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
	
--������ ����
	magictable[1031]={}
	magictable[1031][MAGIC_DEF_TABLE.ID] = 1031
	magictable[1031][MAGIC_DEF_TABLE.NAME] = "����"
	magictable[1031][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1031][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = 	nil
	magictable[1031][MAGIC_DEF_TABLE.TARGET_TYPE] =  TARGET_TYPE.AI_MONSTER
	magictable[1031][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1031
	magictable[1031][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1031][MAGIC_DEF_TABLE.DESCPTION] = "����"
	magictable[1031][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1031][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1031][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1031][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
--�����3X3�����Slime	
	magictable[1032]={}
	magictable[1032][MAGIC_DEF_TABLE.ID] = 1032
	magictable[1032][MAGIC_DEF_TABLE.NAME] = "Ⱥ��֩��"
	magictable[1032][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1032][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = 	function(pBrickSpell,pbrickTarget)
															pbrickTarget.pBrickSpellLev = pBrickSpell.moninfo[monsterInfo.LEV]
															return 
														end
	magictable[1032][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1032][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1032
	magictable[1032][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_MONSTER_SPELL
	magictable[1032][MAGIC_DEF_TABLE.DESCPTION] = "�����3X3���С֩��"
	magictable[1032][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncRandom
	magictable[1032][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1032][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1032][MAGIC_DEF_TABLE.CHOOSE_PARAM] = {R = 1}
	
	
	magictable[1033]={}
	magictable[1033][MAGIC_DEF_TABLE.ID] = 1033
	magictable[1033][MAGIC_DEF_TABLE.NAME] = "����ҳ�Ĭ"
	magictable[1033][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1033][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1033][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1033][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1033
	magictable[1033][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[1033][MAGIC_DEF_TABLE.DESCPTION] = "��ҳ�Ĭ"
	magictable[1033][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1033][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = true
	magictable[1033][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1033][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil	
	
	magictable[1034]={}
	magictable[1034][MAGIC_DEF_TABLE.ID] = 1034
	magictable[1034][MAGIC_DEF_TABLE.NAME] = "�Խ�Һ�������"
	magictable[1034][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1034][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1034][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1034][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1034
	magictable[1034][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[1034][MAGIC_DEF_TABLE.DESCPTION] = "�Խ�Һ���"
	magictable[1034][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1034][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1034][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1034][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
	
	magictable[1035]={}
	magictable[1035][MAGIC_DEF_TABLE.ID] = 1035
	magictable[1035][MAGIC_DEF_TABLE.NAME] = "��Ѫ��������"
	magictable[1035][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1035][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1035][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1035][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1035
	magictable[1035][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[1035][MAGIC_DEF_TABLE.DESCPTION] = "��Ѫ��������"
	magictable[1035][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1035][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1035][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1035][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil

	magictable[1036]={}
	magictable[1036][MAGIC_DEF_TABLE.ID] = 1036
	magictable[1036][MAGIC_DEF_TABLE.NAME] = "�Թֺ�������"
	magictable[1036][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1036][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1036][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.PLAYER
	magictable[1036][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1036
	magictable[1036][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[1036][MAGIC_DEF_TABLE.DESCPTION] = "�Թֺ�������"
	magictable[1036][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1036][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1036][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1036][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil
			
	magictable[1037]={}
	magictable[1037][MAGIC_DEF_TABLE.ID] = 1037
	magictable[1037][MAGIC_DEF_TABLE.NAME] = "��ҳԽ�� �����BUFF"
	magictable[1037][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1037][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1037][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1037][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1037
	magictable[1037][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[1037][MAGIC_DEF_TABLE.DESCPTION] = "�Թֺ�������"
	magictable[1037][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1037][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1037][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1037][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil	
	
	
	magictable[1038]={}
	magictable[1038][MAGIC_DEF_TABLE.ID] = 1038
	magictable[1038][MAGIC_DEF_TABLE.NAME] = "��ҳ�Ѫ �����BUFF"
	magictable[1038][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1038][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1038][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1038][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1038
	magictable[1038][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[1038][MAGIC_DEF_TABLE.DESCPTION] = "�Թֺ�������"
	magictable[1038][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1038][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1038][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1038][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil	
	
	magictable[1039]={}
	magictable[1039][MAGIC_DEF_TABLE.ID] = 1039
	magictable[1039][MAGIC_DEF_TABLE.NAME] = "��ҳԽ� �����BUFF"
	magictable[1039][MAGIC_DEF_TABLE.PICICON] = ""
	magictable[1039][MAGIC_DEF_TABLE.SPELL_FUNC_ID] = nil
	magictable[1039][MAGIC_DEF_TABLE.TARGET_TYPE] = TARGET_TYPE.AI_MONSTER
	magictable[1039][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] = 1039
	magictable[1039][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCPHASE_0] = GameLogicPhase.AFTER_PLAYER_ACT
	magictable[1039][MAGIC_DEF_TABLE.DESCPTION] = "�Թֺ�������"
	magictable[1039][MAGIC_DEF_TABLE.AI_CHOOSE_FUNC] = p.AIChooseFuncSelf
	magictable[1039][MAGIC_DEF_TABLE.AI_DOEFF_AFTERSPELL] = false
	magictable[1039][MAGIC_DEF_TABLE.NEXT_MAGIC] =  nil
	magictable[1039][MAGIC_DEF_TABLE.CHOOSE_PARAM] = nil	
	
		
				

--���ʩ�ż��� ʧ�ܷ���FALSE �ɹ��������ж����б�,�Լ� EFFʵ���б�
--pBrickSingle:���ж���
--pLine:Ԥ��
function p.PlayerSpellMagic(nMagicId,pBrickSingle,pLine)
	local tTargetList = {}
	local tEffList = {}

	local bTargetIsPlayer = false
	local bCast = false
	
	local magicinfo = magictable[nMagicId];
	
	if magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.PLAYER then
		
		--===�����ʩ�ż���===-
		--���� ʩ��FUNC
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
			end
		end
		
		--��TARGET������Ч
		if magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] ~= nil then
			tEffList = magiceff.AddPlayerMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]);
		else
			cclog("����TARGET��Чʧ�� nMagicId:"..nMagicId);
		end	
		bTargetIsPlayer = true;
		
	elseif 	magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.ALLMONSTER then
		--===������MONʩ�ż���===-
		
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
			end
		end	
		
		--��all MON������Ч
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

					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],Board[X][Y],nMagicId);	
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
					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],pbrick);	
					table.insert(tTargetList,pbrick)
					table.insert(tEffList,effT)	
				end
			end
		end	
	end
	
	--����Ч����ʩ����bcast=true 
	--��Ч���ܼ���ʩ���� tTargetList~=nil
	if bCast or tTargetList~= nil then
		player.UseMagic(nMagicId)
	end
	
	if bTargetIsPlayer then
		return player,tEffList
	else
		return tTargetList,tEffList;	
	end	
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
		if magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0] ~= nil  then
			local  effT = magiceff.AddPlayerMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]);
			if effT ~= nil then
				tEffList = effT
			end	
		else
			cclog("����TARGET��Чʧ�� nMagicId:"..nMagicId);
		end
		
		tTargetList = player
	elseif 	magicinfo[MAGIC_DEF_TABLE.TARGET_TYPE] ==  TARGET_TYPE.ALLMONSTER then
		--===������MONʩ�ż���===-
		
		if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID] ~= nil then
			if magicinfo[MAGIC_DEF_TABLE.SPELL_FUNC_ID](pBrickSingle) then
				bCast = true
			end
		end		
		
		--��all MON������Ч
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

					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],Board[X][Y],nMagicId);	
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
					
					local effT = magiceff.AddBrickMagicEff(magicinfo[MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0],pbrick);	
					table.insert(tTargetList,pbrick)
					table.insert(tEffList,effT)	
				end
			end
		end	
	end
	
	--����Ч����ʩ����bcast=true 
	--��Ч���ܼ���ʩ���� tTargetList~=nil
	if bCast or tTargetList~= nil then
		--����ʩ�ż��ܳɹ�
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














