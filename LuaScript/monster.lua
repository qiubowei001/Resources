monster = {}

monsterInfo = {
	HP =1,
	ATT =2,	
	BUFFATT = 4,
	MAGIC = 5,
	MAGIC_ROUND =6,
	CD = 7,
	CDMAX = 8,
	LEV = 9,
	HPMAX = 10,
}
local g_hplabeltag =100;
local g_attlabeltag = 101;
local g_CDbar = 102;
local g_attspritetag = 103;

local gblinkactionTag = 90000;

--ȫ��
MONSTER_TYPE = {}

	MONSTER_TYPE[1] = {}
	MONSTER_TYPE[1]["name"] = "Slimegreen"
	MONSTER_TYPE[1]["MAgic"] = nil--{7} --�����б�
	MONSTER_TYPE[1]["HP"] = 8
	MONSTER_TYPE[1]["HPGrow"] = 1
	MONSTER_TYPE[1]["HPadj"] = 3
	MONSTER_TYPE[1]["ATT"] = 2
	--MONSTER_TYPE[1]["ATT"] = 60
	MONSTER_TYPE[1]["ATTGrow"] = 1
	MONSTER_TYPE[1]["ATTadj"] = 3
	MONSTER_TYPE[1]["CD"] = 30
	MONSTER_TYPE[1]["CDGrow"] = -1
	MONSTER_TYPE[1]["PICID"] = 1
	MONSTER_TYPE[1]["ScarePICID"] = 8
	MONSTER_TYPE[1]["desc"]	= ""
	
	MONSTER_TYPE[2] = {}
	MONSTER_TYPE[2]["name"] = "Slimered"
	MONSTER_TYPE[2]["MAgic"] = nil--{7} --�����б�
	MONSTER_TYPE[2]["HP"] = 13
	MONSTER_TYPE[2]["HPGrow"] = 2
	MONSTER_TYPE[2]["HPadj"] = 3
	MONSTER_TYPE[2]["ATT"] = 2
	MONSTER_TYPE[2]["ATTGrow"] = 0.5
	MONSTER_TYPE[2]["ATTadj"] = 3
	MONSTER_TYPE[2]["CD"] = 30
	MONSTER_TYPE[2]["CDGrow"] = -1
	MONSTER_TYPE[2]["PICID"] = 2
	MONSTER_TYPE[2]["ScarePICID"] = 17
	MONSTER_TYPE[2]["desc"]	= ""
	
	MONSTER_TYPE[3] = {}
	MONSTER_TYPE[3]["name"] = "Slimeblue"
	MONSTER_TYPE[3]["MAgic"] = nil--{7} --�����б�
	MONSTER_TYPE[3]["HP"] = 10
	MONSTER_TYPE[3]["HPGrow"] = 1
	MONSTER_TYPE[3]["HPadj"] = 3
	MONSTER_TYPE[3]["ATT"] = 1
	MONSTER_TYPE[3]["ATTGrow"] = 0.7
	MONSTER_TYPE[3]["ATTadj"] = 3
	MONSTER_TYPE[3]["CD"] = 20
	MONSTER_TYPE[3]["CDGrow"] = -1.5
	MONSTER_TYPE[3]["PICID"] = 18
	MONSTER_TYPE[3]["ScarePICID"] = 19
	MONSTER_TYPE[3]["desc"]	= ""
	
	MONSTER_TYPE[4] = {}
	MONSTER_TYPE[4]["name"] = "SlimeKing"
	MONSTER_TYPE[4]["MAgic"] = {1007} --�����б�
	MONSTER_TYPE[4]["MAgicRound"] = {1} 
	MONSTER_TYPE[4]["HP"] = 10
	MONSTER_TYPE[4]["HPGrow"] = 2
	MONSTER_TYPE[4]["HPadj"] = 3
	MONSTER_TYPE[4]["ATT"] = 1
	MONSTER_TYPE[4]["ATTGrow"] = 1
	MONSTER_TYPE[4]["ATTadj"] = 3
	MONSTER_TYPE[4]["CD"] = 30
	MONSTER_TYPE[4]["CDGrow"] = -1
	MONSTER_TYPE[4]["PICID"] = 9
	MONSTER_TYPE[4]["ScarePICID"] = 10
	MONSTER_TYPE[4]["desc"]	= ""
	
	MONSTER_TYPE[5] = {}
	MONSTER_TYPE[5]["name"] = "FireSpider"
	MONSTER_TYPE[5]["MAgic"] = {1008} --�����б�
	MONSTER_TYPE[5]["MAgicRound"] = {999} --����
	MONSTER_TYPE[5]["HP"] = 10
	MONSTER_TYPE[5]["HPGrow"] = 4
	MONSTER_TYPE[5]["HPadj"] = 3
	MONSTER_TYPE[5]["ATT"] = 1
	MONSTER_TYPE[5]["ATTGrow"] = 1
	MONSTER_TYPE[5]["ATTadj"] = 3
	MONSTER_TYPE[5]["CD"] = 20
	MONSTER_TYPE[5]["CDGrow"] = -1
	MONSTER_TYPE[5]["PICID"] = 11
	MONSTER_TYPE[5]["ScarePICID"] = 12
	MONSTER_TYPE[5]["desc"]	= ""
	
	MONSTER_TYPE[6] = {}
	MONSTER_TYPE[6]["name"] = "littleFireSpider"
	MONSTER_TYPE[6]["MAgic"] = nil
	MONSTER_TYPE[6]["HP"] = 10
	MONSTER_TYPE[6]["HPGrow"] = 4
	MONSTER_TYPE[6]["HPadj"] = 3
	MONSTER_TYPE[6]["ATT"] = 1
	MONSTER_TYPE[6]["ATTGrow"] = 1
	MONSTER_TYPE[6]["ATTadj"] = 3
	MONSTER_TYPE[6]["CD"] = 20
	MONSTER_TYPE[6]["CDGrow"] = -1
	MONSTER_TYPE[6]["PICID"] = 13
	MONSTER_TYPE[6]["ScarePICID"] = 14
	MONSTER_TYPE[6]["desc"]	= ""
	
	MONSTER_TYPE[7] = {}
	MONSTER_TYPE[7]["name"] = "FrozenEye"
	MONSTER_TYPE[7]["MAgic"] = {1009} --�����б�
	MONSTER_TYPE[7]["MAgicRound"] = {999} --����
	MONSTER_TYPE[7]["HP"] = 10
	MONSTER_TYPE[7]["HPGrow"] = 4
	MONSTER_TYPE[7]["HPadj"] = 3
	MONSTER_TYPE[7]["ATT"] = 1
	MONSTER_TYPE[7]["ATTGrow"] = 1
	MONSTER_TYPE[7]["ATTadj"] = 3
	MONSTER_TYPE[7]["CD"] = 20
	MONSTER_TYPE[7]["CDGrow"] = -1
	MONSTER_TYPE[7]["PICID"] = 1
	MONSTER_TYPE[7]["ScarePICID"] = 8
	MONSTER_TYPE[7]["desc"]	= ""
	
	MONSTER_TYPE[8] = {}
	MONSTER_TYPE[8]["name"] = "FireEye"
	MONSTER_TYPE[8]["MAgic"] = {1010} --�����б�
	MONSTER_TYPE[8]["MAgicRound"] = {1} --����
	MONSTER_TYPE[8]["HP"] = 10
	MONSTER_TYPE[8]["HPGrow"] = 4
	MONSTER_TYPE[8]["HPadj"] = 3
	MONSTER_TYPE[8]["ATT"] = 1
	MONSTER_TYPE[8]["ATTGrow"] = 1
	MONSTER_TYPE[8]["ATTadj"] = 3
	MONSTER_TYPE[8]["CD"] = 20
	MONSTER_TYPE[8]["CDGrow"] = -1
	MONSTER_TYPE[8]["PICID"] = 1
	MONSTER_TYPE[8]["ScarePICID"] = 8
	MONSTER_TYPE[8]["desc"]	= ""
	
	
	MONSTER_TYPE[9] = {}
	MONSTER_TYPE[9]["name"] = "Bat"
	MONSTER_TYPE[9]["MAgic"] = {1011} --�����б�
	MONSTER_TYPE[9]["MAgicRound"] = {1} --����
	MONSTER_TYPE[9]["HP"] = 10
	MONSTER_TYPE[9]["HPGrow"] = 4
	MONSTER_TYPE[9]["HPadj"] = 3
	MONSTER_TYPE[9]["ATT"] = 1
	MONSTER_TYPE[9]["ATTGrow"] = 1
	MONSTER_TYPE[9]["ATTadj"] = 3
	MONSTER_TYPE[9]["CD"] = 20
	MONSTER_TYPE[9]["CDGrow"] = -1
	MONSTER_TYPE[9]["PICID"] = 15
	MONSTER_TYPE[9]["ScarePICID"] = 16
	MONSTER_TYPE[9]["desc"]	= ""
	
	MONSTER_TYPE[10] = {}
	MONSTER_TYPE[10]["name"] = "wizard"
	MONSTER_TYPE[10]["MAgic"] = {1012} --�����б�
	MONSTER_TYPE[10]["MAgicRound"] = {999} --����
	MONSTER_TYPE[10]["HP"] = 10
	MONSTER_TYPE[10]["HPGrow"] = 4
	MONSTER_TYPE[10]["HPadj"] = 3
	MONSTER_TYPE[10]["ATT"] = 1
	MONSTER_TYPE[10]["ATTGrow"] = 1
	MONSTER_TYPE[10]["ATTadj"] = 3
	MONSTER_TYPE[10]["CD"] = 20
	MONSTER_TYPE[10]["CDGrow"] = -1
	MONSTER_TYPE[10]["PICID"] = 1
	MONSTER_TYPE[10]["ScarePICID"] = 8
	MONSTER_TYPE[10]["desc"]	= ""
	
	--ƨ������
	MONSTER_TYPE[11] = {}
	MONSTER_TYPE[11]["name"] = "Octopus"
	MONSTER_TYPE[11]["MAgic"] = {1013} --�����б�
	MONSTER_TYPE[11]["MAgicRound"] = {999} --����
	MONSTER_TYPE[11]["HP"] = 10
	MONSTER_TYPE[11]["HPGrow"] = 4
	MONSTER_TYPE[11]["HPadj"] = 3
	MONSTER_TYPE[11]["ATT"] = 1
	MONSTER_TYPE[11]["ATTGrow"] = 1
	MONSTER_TYPE[11]["ATTadj"] = 3
	MONSTER_TYPE[11]["CD"] = 20
	MONSTER_TYPE[11]["CDGrow"] = -1
	MONSTER_TYPE[11]["PICID"] = 22
	MONSTER_TYPE[11]["ScarePICID"] = 23
	MONSTER_TYPE[11]["desc"]	= "Er..It's Ass Man.\nBe careful of its poop"

	--���S��
	MONSTER_TYPE[12] = {}
	MONSTER_TYPE[12]["name"] = "shield"
	MONSTER_TYPE[12]["MAgic"] = {1014} --�����б�
	MONSTER_TYPE[12]["MAgicRound"] = {1} --����
	MONSTER_TYPE[12]["HP"] = 50
	MONSTER_TYPE[12]["HPGrow"] = 4
	MONSTER_TYPE[12]["HPadj"] = 3
	MONSTER_TYPE[12]["ATT"] = 1
	MONSTER_TYPE[12]["ATTGrow"] = 1
	MONSTER_TYPE[12]["ATTadj"] = 3
	MONSTER_TYPE[12]["CD"] = 20
	MONSTER_TYPE[12]["CDGrow"] = -1
	MONSTER_TYPE[12]["PICID"] = 22
	MONSTER_TYPE[12]["ScarePICID"] = 23
	MONSTER_TYPE[12]["desc"]	= "Er..It's Ass Man.\nBe careful of its poop"


function monster.GetPicIdFromMonsterId(nMonsterId)
	cclog("GetPicIdFromMonsterId:"..nMonsterId)
	return MONSTER_TYPE[nMonsterId]["PICID"]
end
	
function monster.GetScarePicIdFromMonsterId(nMonsterId)
	return MONSTER_TYPE[nMonsterId]["ScarePICID"]	
end
	
	
	
	
function monster.AttackCDPlusOne(pbrick)
	pbrick.moninfo[monsterInfo.CD] = pbrick.moninfo[monsterInfo.CD] + 1
	
	--�趨������
	local nPersent = 100*pbrick.moninfo[monsterInfo.CD]/pbrick.moninfo[monsterInfo.CDMAX]
	BARbg = pbrick.CDBARBG
	
	local BAR = pbrick.CDBAR
	
	if nPersent>100 then
		nPersent = 100
	end	
	
	
	BAR:setPercentage(nPersent);
	
	local mainsprite = brick.GetMainSprite(pbrick)		
	
	--mainsprite:stopActionByTag(gblinkactionTag)
	mainsprite:setVisible(true)
	 
	--90%ʱ��˸
	if nPersent>= 100 then
		local sprite = pbrick.attackready 
		sprite:setVisible(true)
		BAR:setVisible(false)
		

		--ִ���ͷż��� �͹���
		if pbrick.IfBeStunned == false then
			monster.SpellMagic(pbrick,false)	
		end
		monster.attack(pbrick);
		
		--ִ��MAGIC��Ч
		magiceff.DoMagicEffAfterMonsterAct(pbrick);
		
		--���������Ч
		magiceff.ClearMonTriggerMagicEff(pbrick)
		
		
	elseif nPersent>=80 then
		if pbrick.IfScaled == false then
			local array = CCArray:create()
			array:addObject(CCScaleTo:create(0.5, 2.5))
			array:addObject(CCScaleTo:create(0.5, 1))
			
			local action = CCSequence:create(array)
			BARbg:runAction(action)
			pbrick.IfScaled = true
		end
	elseif nPersent < 80 then
		BAR:setVisible(true)
		
		local sprite = pbrick.attackready 
		sprite:setVisible(false)
		
		if pbrick.IfScaled == true then
			pbrick.IfScaled = false
		end
	end
	
	--]]
    
end	
	
--��ʼ����������
function monster.InitMonster( pBrick,nid,nLev)
		if nLev == nil then
			nLev = 0;
		end
		
		pBrick.monsterId = nid
		
		
		local hp = MONSTER_TYPE[nid]["HP"] + nLev*MONSTER_TYPE[nid]["HPGrow"] + math.random(-MONSTER_TYPE[nid]["HPadj"],MONSTER_TYPE[nid]["HPadj"])
		local att = MONSTER_TYPE[nid]["ATT"] + nLev*MONSTER_TYPE[nid]["ATTGrow"] + math.random(-MONSTER_TYPE[nid]["ATTadj"],MONSTER_TYPE[nid]["ATTadj"])
		local CDMAX = MONSTER_TYPE[nid]["CD"] + nLev*MONSTER_TYPE[nid]["CDGrow"]
		if  hp <= 0 then
			hp = 1
		end
	
		if  att  <= 0 then
			att  = 1
		end
		
		if CDMAX < 5 then
			CDMAX = 5
		end
		
		pBrick.moninfo = 
		{
		
		[monsterInfo.LEV] = nLev,
		
		
		[monsterInfo.HP] = hp,
		[monsterInfo.HPMAX] = hp,
		
		[monsterInfo.ATT] = att,
		[monsterInfo.BUFFATT] = 0,
		[monsterInfo.MAGIC] = MONSTER_TYPE[nid]["MAgic"],
		[monsterInfo.CD] = 0,
		[monsterInfo.CDMAX] = CDMAX,
		
		}
		
		
		
		--����CD�Ƿ���˸
		pBrick.IfScaled  = false;
		
		
		--ѣ��
		pBrick.IfBeStunned =false;
		
		if pBrick.moninfo[monsterInfo.MAGIC]~= nil then
			pBrick.moninfo[monsterInfo.MAGIC_ROUND] = {}
			for i,v in pairs(MONSTER_TYPE[nid]["MAgicRound"])do
				pBrick.moninfo[monsterInfo.MAGIC_ROUND][i] = v;
			end
		end
		
		
		--��ȴ������
		local CDBarBg = CCMenuItemImage:create("UI/Bar/brickbarbg.png", "UI/Bar/brickbarbg.png")
		CDBarBg:setPosition(brickInfo.brickWidth/2, brickInfo.brickWidth*4/5)
		pBrick:addChild(CDBarBg)
		CDBarBg:setTag(g_CDbar);
		
		
		--����׼��
		attackready = CCSprite:create("UI/Bar/attackready.png")
		attackready:setPosition(CCPointMake(30, 7))
		CDBarBg:addChild(attackready,1,2)
		attackready:setVisible(false)
		
		CDBar = CCProgressTimer:create(CCSprite:create("UI/Bar/attackcdbar.png"))
		CDBar:setType(kCCProgressTimerTypeBar)
		CDBar:setMidpoint(CCPointMake(0, 0))
		CDBar:setBarChangeRate(CCPointMake(1, 0))
		
		CDBar:setPosition(CCPointMake(30, 7))
		--CDBar:setTag(g_CDbar);
		CDBarBg:addChild(CDBar,1,1)		
		pBrick.CDBARBG = CDBarBg
		pBrick.CDBAR = CDBar
		pBrick.attackready = attackready
		
		
		
		--Ѫ��
		local HPBarBg = CCMenuItemImage:create("UI/Bar/brickbarbg.png", "UI/Bar/brickbarbg.png")
		HPBarBg:setPosition(brickInfo.brickWidth/2, brickInfo.brickWidth*7/10)
		pBrick:addChild(HPBarBg)
		HPBarBg:setTag(g_hplabeltag);
		HPBar = CCProgressTimer:create(CCSprite:create("UI/Bar/monsterhpbar.png"))
		HPBar:setType(kCCProgressTimerTypeBar)
		HPBar:setMidpoint(CCPointMake(0, 0))
		HPBar:setBarChangeRate(CCPointMake(1, 0))
		HPBar:setPosition(CCPointMake(30, 7))
		HPBarBg:addChild(HPBar,1,1)		
		pBrick.HPBar = HPBar
		HPBar:setPercentage(100);
		--]]
		
		--[[
		local AttLabel = CCLabelTTF:create(pBrick.moninfo[monsterInfo.ATT], "Arial", 35)
		pBrick:addChild(AttLabel)
		AttLabel:setColor(ccc3(0,0,0))
		AttLabel:setPosition(brickInfo.brickWidth/3, brickInfo.brickWidth*2/3)
		AttLabel:setTag(g_attlabeltag);
		--]]
		
		--��������ʾ
		local Attsprite = ValueToPic.GetPicByAttack(pBrick.moninfo[monsterInfo.ATT])
		pBrick:addChild(Attsprite)
		Attsprite:setTag(g_attspritetag);
		
		
		--[[
		local LevLabel = CCLabelTTF:create("LV:"..pBrick.moninfo[monsterInfo.LEV], "Arial", 20)
		pBrick:addChild(LevLabel)
		LevLabel:setColor(ccc3(0,255,0))
		LevLabel:setPosition(brickInfo.brickWidth/3, brickInfo.brickWidth)
		--]]
		
		
		pBrick.AttAdjFuncT = {};
		pBrick.DamageAdjFuncT = {};
		pBrick.DeathActionFuncT = {};
			
			
end


function monster.SetAtt(pmonster)
	local natt = monster.GetMonsterAtt(pmonster)
	--[[
	local Attlabel = pmonster:getChildByTag(g_attlabeltag)
	tolua.cast(Attlabel, "CCLabelTTF")
	Attlabel:setString(natt)
	--]]
	
	local Attsprite = pmonster:getChildByTag(g_attspritetag)
	Attsprite:removeFromParentAndCleanup(true);
	local Attsprite = ValueToPic.GetPicByAttack(natt)
	pmonster:addChild(Attsprite)
	Attsprite:setTag(g_attspritetag);
end

--�޸Ĺ�������
function monster.AddHp(pmonster,nRecovery)
	pmonster.moninfo[monsterInfo.HP]  = pmonster.moninfo[monsterInfo.HP]  + nRecovery
	
	if pmonster.moninfo[monsterInfo.HP] >= pmonster.moninfo[monsterInfo.HPMAX] then
		pmonster.moninfo[monsterInfo.HP] = pmonster.moninfo[monsterInfo.HPMAX] 
	end
	
	--
	local hpbar = pmonster.HPBar
	local percent = pmonster.moninfo[monsterInfo.HP]/ pmonster.moninfo[monsterInfo.HPMAX]
	hpbar:setPercentage(100*percent);
	--]]
	
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
function monster.damage( pBrick,nDamage,bcritical)
		local tDamageAction = monster.InitDamageAction( pBrick,nDamage);
		
		
		
		for i,func in pairs(pBrick.DamageAdjFuncT) do
			func(tDamageAction)
		end
		
		local ndamage =  tDamageAction.damage
		local defender = tDamageAction.defender
		
		if defender ~= nil then 
			defender.moninfo[monsterInfo.HP]  = defender.moninfo[monsterInfo.HP]  - ndamage
			
			
			local hpbar = defender.HPBar
			local percent = defender.moninfo[monsterInfo.HP]/ defender.moninfo[monsterInfo.HPMAX]
			hpbar:setPercentage(100*percent);
	
			--�����Ѫ ����͸��
			local mainsprite = brick.GetMainSprite(pBrick)
			mainsprite:setOpacity(50+200*percent)

	
			if defender.moninfo[monsterInfo.HP] <= 0 then
				--��������ACTION
				local tDeathAction = monster.InitDeathAction(defender);
				for i,func in pairs(defender.DeathActionFuncT) do
					func(tDeathAction)
				end
				
				--ֹͣ��˸
				local mainsprite = brick.GetMainSprite(pBrick)		
				mainsprite:stopActionByTag(gblinkactionTag)
	
				--��ҫ@ȡ���
				--local nexp =  (defender.moninfo[monsterInfo.LEV])+1
				local nexp =  1
				player.GainEXP(nexp);

				--ִ����������
				if bcritical == nil or bcritical == false then
					monster.PlayDeathAnimation(pBrick);
				else
					monster.PlayCriticalHitAnimation(pBrick);
				end
				
				
				Main.destroyBrick(defender.TileX,defender.TileY,false)
			end
		end	
end


--���������О��ʼ��
function monster.InitDeathAction(dyingMon)
	local tDeathAction = {	
							dyingMon = dyingMon,
						 }
	return tDeathAction
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
function monster.attack(pmonster)
	local ndamage = 0;		
	--�����Ƿ�CD
	if pmonster.moninfo[monsterInfo.CD]  >= pmonster.moninfo[monsterInfo.CDMAX] then
		
		local tAttAction = monster.InitAttAction( player,ndamage,pmonster)
		
		tAttAction.damage = monster.GetMonsterAtt(pmonster)
		
		local bSkip = false
		--�������﹥����������
		for k,func in pairs(pmonster.AttAdjFuncT) do
			if func(tAttAction) == false then
				--������
				bSkip = true
			end
		end
		
		if bSkip == false then
			--���﹥����Ծ
			local actionJump = CCJumpBy:create(1.0, ccp(0, 0), 40, 5)
			local mainsprite = brick.GetMainSprite(pmonster)
			mainsprite:runAction(actionJump);
			
			cclog("monsterid:"..pmonster.monsterId.."att:"..pmonster.moninfo[monsterInfo.ATT].." player damage:"..tAttAction.damage)
			player.takedamage(tAttAction.damage,pmonster);	
			pmonster.moninfo[monsterInfo.CD]	= 0;							
		end
	end
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
		
			--�����Ƿ�CD
			--if IfBorn ==true or pmonster.moninfo[monsterInfo.CD]  >= pmonster.moninfo[monsterInfo.CDMAX] then
			if   pmonster.moninfo[monsterInfo.CD]  >= pmonster.moninfo[monsterInfo.CDMAX] then
				local spelltime =  pmonster.moninfo[monsterInfo.MAGIC_ROUND][i];
				
				if spelltime > 0 then
					--���غϻ�δʩ�ż���
					local tTargetList,tEffList = magic.monsterSpellMagic(nid,pmonster);
					pmonster.moninfo[monsterInfo.MAGIC_ROUND][i]= pmonster.moninfo[monsterInfo.MAGIC_ROUND][i]-1;

					--���＼����Ч�Ƿ���Ҫ���ϴ���
					if magic.GetMagicDoeffAfterSpell(nid) ==true then
						--�����ʩ��
						if tTargetList == player then
							local effid = magictable[nid][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]			
							local efffunc = MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.EFF_FUNC]
							efffunc(player,MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.TPARAM],pmonster)
 		 					
							--��ȡ����EFFTABLE ROUND --
							tEffList[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = tEffList[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1   
						else
							for j,v in pairs(tTargetList) do
								local effT = tEffList[j];
								local effid = magictable[nid][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]
								local efffunc = MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.EFF_FUNC]
								efffunc(v,MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.TPARAM])
        
								--��ȡ����EFFTABLE ROUND --
								effT[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = effT[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
							end														
						end	
					end
				end
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

--������������l�����О�
function monster.AddDeathFunc(pmonster,fDeathFunc,id)
	pmonster.DeathActionFuncT[id] = fDeathFunc
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

















