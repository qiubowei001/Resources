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
	
	ENERGY = 27,
	Entity_ENERGY 		= 28,
	ENERGYMAX			= 29,
	Entity_ENERGYMAX 	= 30,
	
}


--玩家经验配置表
local tPlayerExp = 
--
{
	[1] = 15,
	[2] = 15,
	[3] = 15,
	[4] = 15,
	[5] = 20,
	[6] = 20,
	[7] = 20,
	[8] = 20,
	[9] = 20,
	[10] = 20,
	[11] = 20,
	[12] = 20,
	[13] = 20,
	[14] = 20,
	[15] = 20,
	[16] = 20,
	
	
}--]]
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


local magic_effect_afterplayeract = {}
local magic_effect_aftermonact = {}
local gEnergy_Recovery_TimerId = nil;
local gEnergyRecoveryTime = 4;


function player.GetEnergyRecoveryTimer()
	return gEnergy_Recovery_TimerId
end

--初始化玩家数据
function p.Initplayer()
	magic_effect_aftermonact = {}
	magic_effect_afterplayeract = {}

	
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

	
	player[playerInfo.ENERGY] 				= 15;
	player[playerInfo.Entity_ENERGY] 		= 15;
	player[playerInfo.ENERGYMAX] 			= 15;
	player[playerInfo.Entity_ENERGYMAX] 	= 15;
	
	player.Skill = SkillUpgrade.InitPlayerSkill();
	player.MagicCD = {}
	
	player.AttAdjFuncT = {};
	player.DamageAdjFuncT = {};
	
	player.CriticalChance = 0 --暴击概率
	player.CriticalRate = 2    --暴击比率

	player.Dodgechance = 0;
	
	player.TauntedByMon = nil;--被誰嘲諷
	
	--能量回复定时器		
	gEnergy_Recovery_TimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(p.EnergyRecoveryAuto, gEnergyRecoveryTime, false)	
	
	player.UpdateEntityData();
	
	player.AddNewSkill(14,17)
	--player.AddNewSkill(7,16)

	--[[
	player.AddNewSkill(3,3)
	
	


	player.AddNewSkill(1,1)
	player.AddNewSkill(8,6)	
	player.AddNewSkill(9,4)		
	--]]
	
	
	
end

--这个是属性操作
function p.AddHp(nRecovery)
	player[playerInfo.HP] = player[playerInfo.HP] + nRecovery
	
	if player[playerInfo.HP] >= player[playerInfo.Entity_HPMAX] then
		player[playerInfo.HP] = player[playerInfo.Entity_HPMAX]
	end
	
	----==显示玩家数据==--
	MainUI.SetMainUIHP(player[playerInfo.HP],player[playerInfo.Entity_HPMAX])			
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
	
	local test =  player[playerInfo.HP]
	if  player[playerInfo.HP] <= 0 then
		GameOverUI.LoadUI(1)
		return 
	end
		
	MainUI.SetPlayDamageEff(tDamageAction.damage)		
	MainUI.SetMainUIHP(player[playerInfo.HP],player[playerInfo.Entity_HPMAX])
				
	return player[playerInfo.HP];
end

function p.drinkBlood(nNum)
	--每个血瓶回复5%
	local bottleHp = player[playerInfo.Entity_HPMAX]*0.05
	
	local nRecovery = nNum*bottleHp*(Combo.GetRatio());
	p.AddHp(nRecovery)
	--全局事件
	GlobalEvent.OnEvent(GLOBAL_EVENT.TAKE_BLOOD)
			
	return player[playerInfo.HP];
end

function player.takeGold(nNum)
	player[playerInfo.GOLD] = player[playerInfo.GOLD] + nNum*(Combo.GetRatio());
	player[playerInfo.GOLD] = math.floor(player[playerInfo.GOLD])
	if player[playerInfo.GOLD] >= 100 then
		MainUI.ShowUpgradeBtn();
	end

	----==显示玩家数据==--
	MainUI.SetMainUIGOLD(player[playerInfo.GOLD])

	--全局事件
	GlobalEvent.OnEvent(GLOBAL_EVENT.TAKE_GOLD)
	
	return player[playerInfo.GOLD];
end

--玩家损失金币
function player.LoseGold(nGold)
	player[playerInfo.GOLD] = player[playerInfo.GOLD] - nGold
	
	if player[playerInfo.GOLD] < 0 then
		player[playerInfo.GOLD] = 0
	end
		
	if player[playerInfo.GOLD] >= 100 then
		MainUI.ShowUpgradeBtn();
	else
		MainUI.HideUpgradeBtn();
	end
	----==显示玩家数据==--
	MainUI.SetMainUIGOLD(player[playerInfo.GOLD])
end	
	
	
--获取升级所需经验
function player.GetExpNeed()
	local level = player[playerInfo.LEVEL]
	return tPlayerExp[level]
end

function player.GainEXP(nExp)
	--全局事件
	GlobalEvent.OnEvent(GLOBAL_EVENT.KILL_MONSTER)

	player[playerInfo.EXP] = player[playerInfo.EXP] + nExp;

	if player[playerInfo.EXP] >= player.GetExpNeed() then
		--升级
		player[playerInfo.EXP] = player[playerInfo.EXP] - player.GetExpNeed()
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
	local att = player[playerInfo.Entity_ATT]+ player[playerInfo.BUFFATT];
	return  att;
end

function player.AddMagicEff(effinfoT,nPhase)
	local bIfPlayerAct = effinfoT[MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT]
	if bIfPlayerAct then
		magic_effect_afterplayeract[#magic_effect_afterplayeract+1] = effinfoT;
	else
		magic_effect_aftermonact[#magic_effect_aftermonact+1] = effinfoT;
	end
end

--获取玩家行为触发技能特效表
function player.GetMagicEffTableAfterPlayerAct()
	return magic_effect_afterplayeract	
end

--获取怪物行为触发技能特效表
function player.GetMagicEffTableAfterMonsterAct()
	return magic_effect_aftermonact 
end


--玩家攻击
--tAttAction{damage攻击力 target对象}
function player.Attack(tAttAction)
	local nDamage = tAttAction.damage
	local target = tAttAction.target
	
	--如果有嘲諷怪 且存活則改變對象
	if player.TauntedByMon ~= nil then
		target = player.TauntedByMon
	else
		player.TauntedByMon = nil
	end
	
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

	
	if SkillUpgrade.IfisActSkill(nSkillId) then
		--如果是主动技能 新增CD
		local magicId = SkillUpgrade.GetMagicIdBySkillId(nSkillId)
		player.MagicCD[magicId] = magictable[magicId][MAGIC_DEF_TABLE.CDROUND]
	else
		--如果是被动技能
		local sPassId = SkillUpgrade.GetPassIdBySkillId(nSkillId)
		PassiveSkill.LearnSkillCallBack(sPassId)
	end
end


function player.GetMagicCDById(nMagicId)
	return player.MagicCD[nMagicId]
end

function player.SetMagicCD(magicId,nCD)
	player.MagicCD[magicId] = nCD
	SkillBar.refreshSkill()
end

--判断技能是否CD
function player.IfCanUseMagic(nMagicId)
	--player[playerInfo.ENERGY] = player[playerInfo.ENERGY] - nEnergy
	local energy = player[playerInfo.ENERGY]
	if energy < magictable[nMagicId][MAGIC_DEF_TABLE.ENERGYNEED] then 
		--能量不足 提示
		Hint.ShowHint(Hint.tHintType.noEnergy)
		return false
	end	
	
	local cd = player.GetMagicCDById(nMagicId)
	if cd >= magictable[nMagicId][MAGIC_DEF_TABLE.CDROUND] then
		return true
	else
		return false
	end	
end

--成功使用技能则返回TRUE 否则FALSE
function player.UseMagic(nMagicId)
		player.SetMagicCD(nMagicId,0)
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
	player[playerInfo.Entity_CRITICALCHANCE]   =	player.CriticalChance 
	player[playerInfo.Entity_DODGECHANCE] 	= player.Dodgechance;

	player[playerInfo.Entity_ENERGYMAX] 	= player[playerInfo.ENERGYMAX];
	
	
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
	
	--entity att 指的是玩家穿了装备的攻击力 不包括BUFF
	--技能BUFF叠加
	--player[playerInfo.Entity_ATT] = player[playerInfo.Entity_ATT] + player[playerInfo.BUFFATT]
	MainUI.SetMainUIHP(player[playerInfo.HP],player[playerInfo.Entity_HPMAX])

	MainUI.SetMainUIATK( player.GetAttack())
	MainUI.SetMainUILEV(player[playerInfo.LEVEL])
	MainUI.SetMainUIEXP(player[playerInfo.EXP])
	MainUI.SetMainUIGOLD(player[playerInfo.GOLD])

	
end

--自动回复能量
function p.EnergyRecoveryAuto()
	p.EnergyRecovery(1)
end

function p.EnergyRecovery(nNum)
	player[playerInfo.ENERGY] = player[playerInfo.ENERGY] + nNum*0.7
	

	
	if player[playerInfo.ENERGY] >= player[playerInfo.Entity_ENERGYMAX] then
		player[playerInfo.ENERGY] = player[playerInfo.Entity_ENERGYMAX]
	end	
	
	----==显示玩家数据==--
	MainUI.SetMainUIEnergy(player[playerInfo.ENERGY],player[playerInfo.Entity_ENERGYMAX])	
	
end


function player.SpendEnergy(nEnergy)
	--操作后做个HP太少,energy太少的提示 优先提示HP
	if player[playerInfo.HP] < player[playerInfo.Entity_HPMAX]*0.4 then
		Hint.ShowHint(Hint.tHintType.LowHp)
	end
	if player[playerInfo.ENERGY] < player[playerInfo.Entity_ENERGYMAX]*0.3 then
		Hint.ShowHint(Hint.tHintType.LowEnergy)	
	end

	
	player[playerInfo.ENERGY] = player[playerInfo.ENERGY] - nEnergy
	----==显示玩家数据==--
	MainUI.SetMainUIEnergy(player[playerInfo.ENERGY],player[playerInfo.Entity_ENERGYMAX])
end

function player.SpellMagic(nMagicId,ptarget,pmonster,IfBorn)
	--技能ID错误
	if magictable[nMagicId] == nil then
		return false;
	end

	--技能未冷却
	if player.IfCanUseMagic(nMagicId) == false then
		return;
	end
	
	--消耗能量豆
	local nEnergy = magictable[nMagicId][MAGIC_DEF_TABLE.ENERGYNEED]
	player.SpendEnergy(nEnergy);
	
			
	local tTargetList,tEffList = magic.PlayerSpellMagic(nMagicId,ptarget);
	
	
	--全局事件
	if tTargetList == player then
		GlobalEvent.OnEvent(GLOBAL_EVENT.USE_BUFF_SKILL)	--BUFF
	else
		GlobalEvent.OnEvent(GLOBAL_EVENT.USE_ACTIVE_SKILL) --点杀技能
	end

	--COMBO +1
	Combo.AddCombo()
	
	--怪物技能特效是否需要马上触发
	if magic.GetMagicDoeffAfterSpell(nMagicId) ==true then
		--对玩家施法
		if tTargetList == player then
			local effid = magictable[nMagicId][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]			
			local efffunc = MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.EFF_FUNC]
			efffunc(player,MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.TPARAM])
 			
			--获取怪物EFFTABLE ROUND --
			tEffList[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = tEffList[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1   
			
		else	
			--对怪物施法
			for j,v in pairs(tTargetList) do
				local effT = tEffList[j];
				local effid = magictable[nMagicId][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]
				local efffunc = MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.EFF_FUNC]
				efffunc(v,MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.TPARAM])
        
				--获取怪物EFFTABLE ROUND --
				effT[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = effT[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
			end			
		end	
	end
end


