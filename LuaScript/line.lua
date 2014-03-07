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

--返回是否成功执行一次操作
function p.OnTouchEnd()
			--取消tip
			if #Line >=1 then
				local pbricklast = Line[#Line]
				LineFunc.setUnTip(pbricklast);				
			end	
						 
			
			if LineFunc.GetLineLength() > 2 then
				local actiontype = false;
				local nLineNum = #Line;
				
				
				--普通行为消耗能量1 如果没有能量 则返回				
				if 	player[playerInfo.ENERGY] <1 then				
					--能量不足 提示
					Hint.ShowHint(Hint.tHintType.noEnergy)
					LineFunc.CancelLine();
					LineFunc.ResetLine()
					return false;
				end	
				
				
				
				if LineFunc.GetLineType() == tbrickType.MONSTER or LineFunc.GetLineType() == tbrickType.SWORD then--SWORD
					---攻击操作
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

--点选一个brick
function p.OnHitABrick(pbrick)
		--如果处于上一次Brick中则返回
		if LineFunc.GetLastBrick() == pbrick then
			return;
		end
		
		if pbrick.IsAbleLink == false then
			return;
		end
		
		--如果没有起点则去除
		if Line[1] ==nil then
			LineFunc.CancelLine();
			return;
		end
		
		--如果是队列内则去除选择之后选中的 并返回
		for i,v in pairs(Line) do  
			if pbrick == v then
				LineFunc.CancelLineFromBrick(pbrick);
				return;
			end
		end
		
		--如果不是杀怪行为 或者 不同类则去除选中
		if Line[1].nType == tbrickType.MONSTER or Line[1].nType == tbrickType.SWORD then--SWORD
			if pbrick.nType  == tbrickType.MONSTER  or pbrick.nType == tbrickType.SWORD then
				--攻击行为
					
				bifatt = true;
			else
				return;
			end
		
		elseif	Line[1].nType ~= pbrick.nType then
			return;
		end

		
		--如果未相邻则去除
		local pbricklast = LineFunc.GetLastBrick();
		cclog("BRICKLAST "..pbricklast.TileX..pbricklast.TileY.." BRICKNOW "..pbrick.TileX..pbrick.TileY)
		if math.abs(pbricklast.TileX - pbrick.TileX )>= 2 or math.abs(pbricklast.TileY - pbrick.TileY) >= 2 then
			--CancelLine();
			return;
		end
		
		
		
		if	pbrick.chosed == false then
			--取消提示
			if #Line >=1 then
				local bricklast = Line[#Line]
				LineFunc.setUnTip(bricklast)
			end	
					
			LineFunc.InsertLine(pbrick)
			brick.setChosed(pbrick);


			
			--提示
			LineFunc.setTip(pbrick)
		end
		
		--攻击行为
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

--将BRICK之后的全删除
function p.CancelLineFromBrick(pbrick)
	if #Line>=1 then
		local pbricklast = Line[#Line]
		LineFunc.setUnTip(pbricklast)
	end
	
	
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
	LineFunc.setTip(pbrick)	
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
			nDamage = nDamage + 4;							
		end
	end
	
	return nDamage*(Combo.GetRatio())
end


function LineFunc.setTip(pbrick)
	--获取周围8个BRICK
	local X = pbrick.TileX
	local Y = pbrick.TileY
	local tBrick = {}
	for i=X-1,X+1 do
		for j=Y-1,Y+1 do
			if i~=X or j~=Y then
				if i>= 1 and i<=  brickInfo.brick_num_X and j<=  brickInfo.brick_num_Y and j>= 1 then
					table.insert(tBrick,Board[i][j])
				else
					table.insert(tBrick,999)
				end
			end
		end
	end
	
	--[[
	358
	2 7
	146	
	--]]
	for i,tmpbrick in pairs(tBrick)do
		if 999 ~= tmpbrick then
			local bIfTip = false  --是否加TIP
			--如果类型和pbrick一致
			if tmpbrick.nType == tbrickType.MONSTER or tmpbrick.nType == tbrickType.SWORD then--SWORD
				if pbrick.nType  == tbrickType.MONSTER  or pbrick.nType == tbrickType.SWORD then
					bIfTip  = true				
				end
			elseif tmpbrick.nType == pbrick.nType  then
				bIfTip  = true	
			end
		
			--不在line中才显示
			for j,v in pairs(Line)do
				if v == tmpbrick then
					bIfTip = false
					break
				end
			end
		
			--则显示提示
			if bIfTip then		
				brick.setTip(tmpbrick,i)
			end
		end	
	end
end

function LineFunc.setUnTip(pbrick)
	--获取周围8个BRICK
	local X = pbrick.TileX
	local Y = pbrick.TileY
	local tBrick = {}
	for i=X-1,X+1 do
		for j=Y-1,Y+1 do
			if i~=X or y~=Y then
				if i>= 1 and i<=  brickInfo.brick_num_X and j<=  brickInfo.brick_num_Y and j>= 1 then
					table.insert(tBrick,Board[i][j])
				else
					table.insert(tBrick,999)
				end
			end
		end
	end
	
	for i,tmpbrick in pairs(tBrick)do
		if 999 ~= tmpbrick then	
			brick.setUnTip(tmpbrick)	
		end	
	end	
end

















				