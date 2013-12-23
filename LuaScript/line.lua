local Line = {}
LineFunc ={}
local p = LineFunc;


function p.ResetLine()
	Line = {}
end

function p.GetLineLength()
	return #Line;
end

function p.GetLastBrick()
	return Line[#Line]
end

function p.InsertLine(pbrick)
	Line[#Line+1] = pbrick;
end

function p.SetHead(pbrick)
	Line = {};
	Line[1] = pbrick;
end

function p.GetLineType()
	return Line[1].nType;
end

--�����Ƿ�ɹ�ִ��һ�β���
function p.OnTouchEnd()
			if LineFunc.GetLineLength() > 2 then
				local actiontype = false;
				local nLineNum = #Line;
				
				
				--��ͨ��Ϊ��������1 ���û������ �򷵻�				
				if 	player[playerInfo.ENERGY] <1 then				
					--�������� ��ʾ
					Hint.ShowHint(Hint.tHintType.noEnergy)
					LineFunc.CancelLine();
					LineFunc.ResetLine()
					return false;
				end	
				
				
				
				if LineFunc.GetLineType() == tbrickType.MONSTER or LineFunc.GetLineType() == tbrickType.SWORD then--SWORD
					---��������
					local nDamage = LineFunc.getPlayerAttDamgeFromLine();						
					
					for i,v in pairs(Line) do

						if v.nType == tbrickType.SWORD then
							Main.destroyBrick(v.TileX,v.TileY)
							Line[i] = nil
						elseif v.nType == tbrickType.MONSTER then
							local xtmp = v.TileX 
							local ytmp = v.TileY
							
							local tAttaction = player.InitAttAction(nDamage,v)
							 player.Attack(tAttaction)
							 
							 if Board[xtmp][ytmp] == nil then
								Line[i] = nil
							 end
						end
					end	
					actiontype = tbrickType.MONSTER;
					LineFunc.CancelLine();
					tParamEvn.playerAttDamageThisRound = nDamage;
					
				else
					if LineFunc.GetLineType() == tbrickType.BLOOD then
						actiontype = tbrickType.BLOOD;
					elseif 	LineFunc.GetLineType() == tbrickType.GOLD then
						actiontype = tbrickType.GOLD;
					elseif	LineFunc.GetLineType() == tbrickType.ENERGY then
						actiontype = tbrickType.ENERGY;
					end
					
					if actiontype == tbrickType.GOLD then
						nLineNum = 0;
						for i,v in pairs(Line) do
							nLineNum = nLineNum + v.GOLD;							
							Main.BrickMoveToBar(v,1);							
						end
					elseif actiontype == tbrickType.BLOOD then
						for i,v in pairs(Line) do
							Main.BrickMoveToBar(v,2);
						end						
					elseif actiontype == tbrickType.ENERGY then	
						for i,v in pairs(Line) do
							Main.BrickMoveToBar(v,3);		
						end			
					end
					
				end
				LineFunc.ResetLine()
				LineFunc.CancelLine();
			
				return actiontype,nLineNum;
			end
			
			LineFunc.CancelLine();
			return false;
end

--��ѡһ��brick
function p.OnHitABrick(pbrick)
		--���������һ��Brick���򷵻�
		if LineFunc.GetLastBrick() == pbrick then
			return;
		end
		
		if pbrick.IsAbleLink == false then
			return;
		end
		
		--���û�������ȥ��
		if Line[1] ==nil then
			LineFunc.CancelLine();
			return;
		end
		
		--����Ƕ�������ȥ��ѡ��֮��ѡ�е� ������
		for i,v in pairs(Line) do  
			if pbrick == v then
				LineFunc.CancelLineFromBrick(pbrick);
				return;
			end
		end
		
		--�������ɱ����Ϊ ���� ��ͬ����ȥ��ѡ��
		if Line[1].nType == tbrickType.MONSTER or Line[1].nType == tbrickType.SWORD then--SWORD
			if pbrick.nType  == tbrickType.MONSTER  or pbrick.nType == tbrickType.SWORD then
				--������Ϊ
					
				bifatt = true;
			else
				return;
			end
		
		elseif	Line[1].nType ~= pbrick.nType then
			return;
		end

		
		--���δ������ȥ��
		local pbricklast = LineFunc.GetLastBrick();
		cclog("BRICKLAST "..pbricklast.TileX..pbricklast.TileY.." BRICKNOW "..pbrick.TileX..pbrick.TileY)
		if math.abs(pbricklast.TileX - pbrick.TileX )>= 2 or math.abs(pbricklast.TileY - pbrick.TileY) >= 2 then
			--CancelLine();
			return;
		end
		
		
		
		if	pbrick.chosed == false then
			LineFunc.InsertLine(pbrick)
			brick.setChosed(pbrick);	
		end
		
		--������Ϊ
		if bifatt == true and LineFunc.GetLineLength() >=3 then
			cclog("ATT1");
			local damage = LineFunc.getPlayerAttDamgeFromLine()
			cclog("ATT2 damage:"..damage);
			for i,v in pairs(Line) do
				if v.nType ==  tbrickType.MONSTER then
					if v.moninfo[monsterInfo.HP] - damage <= 0 then
						cclog("ATT3 seteffect");
						brick.setdeatheffect(v)
					else
						brick.removedeatheff(v)
					end
				end	
			end						
		end
end

--��BRICK֮���ȫɾ��
function p.CancelLineFromBrick(pbrick)
			local indextmp = 1;
			for i,v in pairs(Line) do
				if v== pbrick then
					indextmp = i+1;
				end				
				--brick.setUnChosed(v)
			end
			
			
			for i=#Line,indextmp,-1 do
				brick.setUnChosed(Line[i])
				brick.removedeatheff(Line[i])
				table.remove(Line, i)
			end		
end

function p.CancelLine()
	for i,v in pairs(Line) do
		--cclog("CancelLine2")
		if v ~= nil then
			brick.setUnChosed(v)
			brick.removedeatheff(v)
		end
	end
	--cclog("CancelLine3")
	Line = {}
end


function p.getPlayerAttDamgeFromLine()
	local nDamage = player.GetAttack();
	for i,v in pairs(Line) do
		if v.nType == tbrickType.SWORD then
			nDamage = nDamage + 3;							
		end
	end
	
	return nDamage*(Combo.GetRatio())
end






















				