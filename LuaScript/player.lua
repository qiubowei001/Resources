player = {}
local p = player;
playerInfo = {
	HP =1,
	ATT = 2,
	GOLD = 3,
	BUFFATT = 4,
	EXP = 5,
	LEVEL = 6,
	HPMAX = 7,
	SKILLID1 = 8,
	SKILLID2 = 9,
	SKILLID3 = 10,
	SKILLID4 = 11,
	SKILLCD1 = 12,
	SKILLCD2 = 13,
	SKILLCD3 = 14,
	SKILLCD4 = 15,
	
	WEAPON 	 = 16,
	ARMOR	 = 17,
	NECKLACE = 18,
	RING	 = 19,
	CAPE 	 = 20,
	
	Entity_HP    =21,
	Entity_HPMAX =22,
	Entity_ATT   =23,
	Entity_CRITICALRATE   =24,
	Entity_CRITICALCHANCE   =25,
	Entity_DODGECHANCE 	= 26,
}


--玩家经验配置表
local tPlayerExp = 
{
	[1] = 10,
	[2] = 10,
	[3] = 10,
	[4] = 10,
	[5] = 20,
	[6] = 20,
	[7] = 200,
	[8] = 200,
}
--[[
{
	[1] = 100,
	[2] = 105,
	[3] = 105,
	[4] = 105,
	[5] = 200,
	[6] = 200,
	[7] = 200,
	[8] = 200,
}--]]

local magic_effect_beforeplayeract = {}
local magic_effect_afterplayeract = {}
local magic_effect_aftermonatt = {}
local magic_effect_aftermonspell = {}



--初始化玩家数据
function p.Initplayer()
	magic_effect_beforeplayeract = {}
	magic_effect_afterplayeract = {}
	magic_effect_aftermonatt = {}
 
	player[playerInfo.HP] = 100;
	player[playerInfo.HPMAX] = 100;
	
	player[playerInfo.ATT] = 3;
	player[playerInfo.GOLD] = 0;
	player[playerInfo.BUFFATT] = 0;
	player[playerInfo.EXP] = 0;
	player[playerInfo.LEVEL] = 1;
	
	
	
	player[playerInfo.WEAPON] 	= 1001;
	player[playerInfo.ARMOR] 	= 2001;
	player[playerInfo.NECKLACE] = 3001;
	player[playerInfo.RING] 	= 4001;
	player[playerInfo.CAPE] 	= 5001;
						  
	
	
	player[playerInfo.Entity_HP] 	= 0;
	player[playerInfo.Entity_HPMAX] 	= 0;
	player[playerInfo.Entity_ATT] 	= 0;

	player[playerInfo.Entity_CRITICALRATE] 	= 0;
	player[playerInfo.Entity_CRITICALCHANCE] 	= 0;
	player[playerInfo.Entity_DODGECHANCE] 	= 0;

	player.Skill = SkillUpgrade.InitPlayerSkill();
	player.MagicCD = {}
	
	
	player.AttAdjFuncT = {};
	player.DamageAdjFuncT = {};
	
	player.CriticalChance = 0 --暴击概率
	player.CriticalRate = 2    --暴击比率

	player.Dodgechance = 0;
	
	player.UpdateEntityData();
	
end

--这个是属性操作
function p.AddHp(nRecovery)
	player[playerInfo.HP] = player[playerInfo.HP] + nRecovery
	
	if player[playerInfo.HP] >= player[playerInfo.Entity_HPMAX] then
		player[playerInfo.HP] = player[playerInfo.Entity_HPMAX]
	end
end




function p.InitDamageAction(ndamage,pmonster)
	local tDamageAction={
						damage = ndamage,
						attacker = pmonster,
						dodgechance = player[playerInfo.Entity_DODGECHANCE];
					}
	return tDamageAction
end

function p.AddAttAdjFunc(fAttAdjFunc,id)
	player.AttAdjFuncT[id] = fAttAdjFunc
end

function p.RemoveAdjFunc(id)
    player.AttAdjFuncT[id] = nil
end
	
	
function p.AddDamageAdjFunc(fDamageAdjFunc,id)
	player.DamageAdjFuncT[id] = fDamageAdjFunc
end

function p.RemoveDamageAdjFunc(id)
    player.DamageAdjFuncT[id] = nil
end	
	
	
	
--这个是动作
function p.takedamage(ndamage,pmonster)
	if  player[playerInfo.HP] <= 0 then
		return
	end
	
	local tDamageAction = p.InitDamageAction(ndamage,pmonster)
	for i,func	in pairs(player.DamageAdjFuncT) do
		func(tDamageAction);
	end
	
	
	if tDamageAction.dodgechance ~= 0 then
		if math.random(1,100) <=tDamageAction.dodgechance then
			--被闪避
			return player[playerInfo.HP];
		end
	end
	
	
	player[playerInfo.HP] = player[playerInfo.HP] - tDamageAction.damage;
	
	if  player[playerInfo.HP] <= 0 then
		GameOverUI.LoadUI(1)
		return 
	end
	
	
	return player[playerInfo.HP];
end

function p.drinkBlood(nNum)
	local nRecovery = nNum*2*(TimerBuff.GetRatio());
	p.AddHp(nRecovery)
	return player[playerInfo.HP];
end

function player.takeGold(nNum)
	player[playerInfo.GOLD] = player[playerInfo.GOLD] + nNum*(TimerBuff.GetRatio());
	player[playerInfo.GOLD] = math.floor(player[playerInfo.GOLD])
	if player[playerInfo.GOLD] >= 100 then
		MainUI.ShowUpgradeBtn();
	end
	
	MainUI.SetMainUIGOLD(player[playerInfo.GOLD])
	return player[playerInfo.GOLD];
	
	--
end


function player.GainEXP(nExp)
	player[playerInfo.EXP] = player[playerInfo.EXP] + nExp;

	if player[playerInfo.EXP] >= tPlayerExp[player[playerInfo.LEVEL]] then
		--升级
		player[playerInfo.EXP] = player[playerInfo.EXP] - tPlayerExp[player[playerInfo.LEVEL]]
		player[playerInfo.LEVEL] = player[playerInfo.LEVEL]+1
		
		
		--回血
		player[playerInfo.HP] = player[playerInfo.Entity_HPMAX];
		MainUI.SetMainUIHP(player[playerInfo.HP],player[playerInfo.Entity_HPMAX])
	
		
		
		MainUI.SetMainUILEV(player[playerInfo.LEVEL])
		
		SkillUpGradeUI.LoadUI();
		
	end
	

	MainUI.SetMainUIEXP(player[playerInfo.EXP])	
	return player[playerInfo.EXP];
end


function player.GetAttack()
	local att = player[playerInfo.Entity_ATT];
	return  att;
end

function player.AddMagicEff(effinfoT,nPhase)
	if nPhase == GameLogicPhase.BEFORE_PLAYER_ACT then
		magic_effect_beforeplayeract[#magic_effect_beforeplayeract+1] = effinfoT;
	elseif nPhase == GameLogicPhase.AFTER_PLAYER_ACT then
		magic_effect_afterplayeract[#magic_effect_beforeplayeract+1] = effinfoT;
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_ATT then
		magic_effect_aftermonatt[#magic_effect_aftermonatt+1] = effinfoT;
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_SPELL then
		magic_effect_aftermonspell[#magic_effect_aftermonspell+1] = effinfoT;
	end
end

function player.GetMagicEffTable(nPhase)
	if nPhase == GameLogicPhase.BEFORE_PLAYER_ACT then
		return magic_effect_beforeplayeract
	elseif nPhase == GameLogicPhase.AFTER_PLAYER_ACT then
		return magic_effect_afterplayeract
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_ATT then
		return magic_effect_aftermonatt
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_SPELL then
		return magic_effect_aftermonspell
	end
end


--玩家攻击
--tAttAction{damage攻击力 target对象}
function player.Attack(tAttAction)
	local nDamage = tAttAction.damage
	local target = tAttAction.target
	
	--local tAttAction = player.InitAttAction(nDamage,target)
					
	--遍历攻击调整函数
	for k,func in pairs(player.AttAdjFuncT) do
		func(tAttAction)
	end
					
	
	local bcritical = false
	--计算暴击伤害
	if tAttAction.criticalchance >= math.random(0,100) then
		nDamage = nDamage*(tAttAction.criticalrate)
		bcritical=true
	end
	
	monster.damage(target,nDamage,bcritical)
	return tAttAction
end

function player.InitAttAction(ndamage,pmonster)
	local tAttAction={
						damage = ndamage,
						target = pmonster,
						criticalrate = player.CriticalRate,
						criticalchance = player[playerInfo.Entity_CRITICALCHANCE],
					}
	return tAttAction
end



function player.AddNewSkill(nRootId,nSkillId)
	if player.Skill[nRootId] ~= nil then
		table.insert(player.Skill[nRootId],nSkillId)
	else
		player.Skill[nRootId] = {nSkillId}
	end

	--如果是主动技能 新增CD
	if SkillUpgrade.IfisActSkill(nSkillId) then
		local magicId = SkillUpgrade.GetMagicIdBySkillId(nSkillId)
		player.MagicCD[magicId] = magictable[magicId][MAGIC_DEF_TABLE.CDROUND]
	end
	
	--如果是被动技能
	
end


function player.GetMagicCDById(nMagicId)
	return player.MagicCD[nMagicId]
end

function player.SetMagicCD(magicId,nCD)
	player.MagicCD[magicId] = nCD
	SkillBar.refreshSkill()
end


--成功使用技能则返回TRUE 否则FALSE
function player.UseMagic(nMagicId)
	
	local cd = player.GetMagicCDById(nMagicId)
	if cd >= magictable[nMagicId][MAGIC_DEF_TABLE.CDROUND] then
		player.SetMagicCD(nMagicId,0)
		
		return true
	else
		return false
	end
	
	
	
end

function player.SkillCoolDown()
	
	for i,v in pairs(player.MagicCD) do
			player.MagicCD[i] = player.MagicCD[i] + 1
			if player.MagicCD[i]  > magictable[i][MAGIC_DEF_TABLE.CDROUND] then
				player.MagicCD[i] = magictable[i][MAGIC_DEF_TABLE.CDROUND]
			end
		
	end	
	
	SkillBar.refreshSkill()
end

function player.UpGradeEquip(nEquipId)
	if player[playerInfo.GOLD]  - 100 < 0 then
		return false
	end
	
	local ntype = tEquipType[nEquipId][3]
	
	local tTmp = {
		playerInfo.WEAPON 	,
		playerInfo.ARMOR 	,
		playerInfo.NECKLACE ,
		playerInfo.RING,
		playerInfo.CAPE,
	}
	
	local index = tTmp[ntype];
	player[index] = nEquipId;	
	

	
	player[playerInfo.GOLD] = player[playerInfo.GOLD]  - 100
	
	--刷新金币显示
	MainUI.SetMainUIGOLD(player[playerInfo.GOLD])
	--更新实体数据
	player.UpdateEntityData();
	
	
	if player[playerInfo.GOLD] < 100 then
		MainUI.HideUpgradeBtn();
	end
	
	return true;
end

--更新玩家实体数据
function player.UpdateEntityData()
	player[playerInfo.Entity_HPMAX] = player[playerInfo.HPMAX]
	player[playerInfo.Entity_ATT] = player[playerInfo.ATT]
	player[playerInfo.Entity_CRITICALRATE]   =	player.CriticalRate
	player[playerInfo.Entity_CRITICALCHANCE]   =player.CriticalChance 
	player[playerInfo.Entity_DODGECHANCE] 	= player.Dodgechance;

	
	
	--装备数据叠加
	local tEquipId = {
	player[playerInfo.WEAPON] 	,
	player[playerInfo.ARMOR] 	,
	player[playerInfo.NECKLACE] ,
	player[playerInfo.RING] 	,
	player[playerInfo.CAPE] 	,
	}
	
	for i,v in pairs(tEquipId) do
		if v ~= 0 then
			player[playerInfo.Entity_ATT] = player[playerInfo.Entity_ATT] + tEquipType[v][4]
			player[playerInfo.Entity_HPMAX] = player[playerInfo.Entity_HPMAX] + tEquipType[v][5]
			player[playerInfo.Entity_CRITICALCHANCE]   = player[playerInfo.Entity_CRITICALCHANCE] +  tEquipType[v][7]
			player[playerInfo.Entity_DODGECHANCE]  = player[playerInfo.Entity_DODGECHANCE]  + tEquipType[v][8]
		end	
	end
	
	--技能BUFF叠加
	player[playerInfo.Entity_ATT] = player[playerInfo.Entity_ATT] + player[playerInfo.BUFFATT]
	MainUI.SetMainUIHP(player[playerInfo.HP],player[playerInfo.Entity_HPMAX])
	MainUI.SetMainUIATK(player[playerInfo.Entity_ATT])

	
	
	MainUI.SetMainUILEV(player[playerInfo.LEVEL])
	MainUI.SetMainUIEXP(player[playerInfo.EXP])
	MainUI.SetMainUIGOLD(player[playerInfo.GOLD])
	
end


