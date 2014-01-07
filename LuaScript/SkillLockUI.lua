--���ܽ�������
SkillLockUI = {}
local p = SkillLockUI;

local bglayer=nil;
local g_StartPosx = 140;
local g_StartPosy = 500;
local gX_Step = 70;
local gY_Step = 60;
local gX_Num = 9;
function p.LoadUI()
		local scene =Main.GetGameScene();
		bglayer = CCLayer:create()

		local menu = CCMenu:create()
		menu:setPosition(CCPointMake(g_StartPosx, g_StartPosy))

		local tSkillLock = {}--δ��������
		local tSkillLockUnlock = {}--��������
		
		for nNodeid,v in pairs(SkillUpgrade.tSkillNode) do
			if  SkillUpgrade.IfUnLocked(nNodeid) then --�ѽ���
				table.insert(tSkillLockUnlock,nNodeid)
			else--δ����
				table.insert(tSkillLock,nNodeid)
			end				
		end
		
		
		--�ϲ���һ���±�
		for i,nNodeid in pairs(tSkillLock)do
			table.insert(tSkillLockUnlock,nNodeid)
		end
		
		--��ʾ
		for index,nNodeid in pairs(tSkillLockUnlock)do
			local X = index%gX_Num
			if X == 0 then
				X = gX_Num
			end
			local Y = math.ceil(index/gX_Num)
			local picpath = SkillUpgrade.GetPicPath(nNodeid)
			local item1 = CCMenuItemImage:create(picpath, picpath)
			--item1:registerScriptTapHandler(p.LearnSkillCallback)
			item1:setPosition(gX_Step*X,-gY_Step*Y)
			menu:addChild(item1)
			
			if  SkillUpgrade.IfUnLocked(nNodeid) == false then --δ����
				--local lockedSprite = CCSprite:create("skill/skillLocked.png");
				local lockedSprite = CCMenuItemImage:create("skill/skillLocked.png", "skill/skillLocked.png")
				lockedSprite:setPosition(gX_Step*X,-gY_Step*Y)
				menu:addChild(lockedSprite)
			end
		end
		
		
		local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
			closeBtn:registerScriptTapHandler(p.closeUICallback)
			closeBtn:setPosition(CCPointMake(680, 20))
		menu:addChild(closeBtn)
		
				
		bglayer:addChild(menu, 2,1)
		bglayer:setTag(UIdefine.SkillLockUI);
			
		--���ӱ���
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
	    bglayer:addChild(bgSprite,1)
		bgSprite:setPosition(CCPointMake(480, 320))
		bgSprite:setScale(5);
		
		scene:addChild(bglayer,3)
end



function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.SkillLockUI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end

function p.closeUICallback(tag,sender)
	--�رս��� 
	local layer = p.GetParent()
	local scene = Main.GetGameScene();
	scene:removeChild(layer, true) 
end
