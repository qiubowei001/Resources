




MissionSelectUI = {}
local p = MissionSelectUI;

local g_bglayer=nil;--������
local g_MissionUI = nil;--UI��


local tMissionPortalInfo = 
{
	[1] = {POSITION={50, 500}},
	[2] = {POSITION={150,500}},
	[3] = {POSITION={250,500}},
	[4] = {POSITION={350,500}},
	[5] = {POSITION={450,500}},
}

local g_Chapter = 1;--��ǰ�½�

local NextChapterBtn = nil;
local LastChapterBtn = nil;
function p.PortalOnClick(tag,sender)
	
			
	Main.main(tag);
	local winSize = CCDirector:sharedDirector():getWinSize()
	
	
	--ɾ��MISSION select UI
	g_MissionUI:removeFromParentAndCleanup(true);
	
	--[[
	local moveby = CCMoveBy:create(1, ccp(0,-winSize.height))
	
	--�������� ɾ��
	function delete(sender)
		sender:removeFromParentAndCleanup(true);
	end
		
	local actionremove = CCCallFuncN:create(delete)
	local arr = CCArray:create()
	arr:addObject(moveby)
	arr:addObject(actionremove)
	
	local  seq = CCSequence:create(arr)	
	g_bglayer:runAction(seq)--]]
end

function p.RunScene()
	CCDirector:sharedDirector():runWithScene(g_sceneGame)
end


function p.LoadUI()
		g_sceneGame = CCScene:create();
		local scene = g_sceneGame;
		
		-->>>>>>>>>>��Ϸ���ݳ�ʼ�� --�����ʱ��Ҫ�ŵ�������
		dataInit.InitPlayerSave()
		SkillUpgrade.Init()
		GlobalEvent.InitEventTable();
		---<<<<<<<<<<

		--������  --��UI���Ƿֿ���
		g_bglayer = p.GetChapterUI(g_Chapter)
		scene:addChild(g_bglayer,UIdefine.BG_LAYER)

		
		--����UI��
		g_MissionUI = CCLayer:create()
		scene:addChild(g_MissionUI,UIdefine.MissionSelectUI)

		local menuMain = CCMenu:create()
		--menuMain:setPosition(CCPointMake(300, 300))
		g_MissionUI:addChild(menuMain,3)
		--���ܽ����������
		local SkilllockBtn = CCMenuItemImage:create("UI/MissionSelect/SkilllockBtn.png","UI/MissionSelect/SkilllockBtn.png")
		SkilllockBtn:registerScriptTapHandler(SkillLockUI.LoadUI)
		menuMain:addChild(SkilllockBtn)
		SkilllockBtn:setPosition(350,200)
		--]]
				
		--��һ�½�				
		LastChapterBtn = CCMenuItemImage:create("UI/MissionSelect/LastChapterBtn.png","UI/MissionSelect/LastChapterBtn.png")
		LastChapterBtn:registerScriptTapHandler(p.LastChapterBtn)
		menuMain:addChild(LastChapterBtn)
		LastChapterBtn:setPosition(-350,0)
		
		--��һ�½�
		NextChapterBtn = CCMenuItemImage:create("UI/MissionSelect/NextChapterBtn.png","UI/MissionSelect/NextChapterBtn.png")
		NextChapterBtn:registerScriptTapHandler(p.NextChapterBtn)
		menuMain:addChild(NextChapterBtn)
		NextChapterBtn:setPosition(350,0)
		

		
		--ˢ�·�ҳ��ť
		p.RefreshBtn();

	
--[[
		local tAttType = 
{
	[1] = ccc3(255,255,255),--��ɫ
[2] = ccc3(0,255,0),--��ɫ
[3] = ccc3(0,0,255),--��ɫ
[4] = ccc3(160,32,240),--��ɫ
[5] = ccc3(255,255,0),--��ɫ
[6] = ccc3(255,0,0),--��ɫ

[7] = ccc3(0,0,0),--��ɫ
--ɫ
--ɫ
--ɫ
}

		--local numbersprite = NumberToPic.GetPicByNumBer(1234567890)
		--numbersprite:setPosition(CCPointMake(200, 120))
		--scene:addChild(numbersprite,99)
		
		
		for i,v in pairs(tAttType) do
		local sprite = CCSprite:create("UI/AttGrade/att.png")
		
        sprite:setPosition(CCPointMake(80*i, 220))
		bglayer:addChild(sprite,5)
		sprite:setColor(v)			
		end
--]]
	return g_sceneGame
end

--��һ�½�
function p.LastChapterBtn()
	g_Chapter = g_Chapter - 1;
	
	--��������ʱ ���ذ�ť
	p.HideBtn()
	
	local lastlayer = p.GetChapterUI(g_Chapter);
	lastlayer:setPosition(-winSize.width , 0)
	
	-->>>>>>>>>>>>>>>����Ч��
	--ԭ���� �����ƶ�����,Ȼ��ɾ��
	function removeLast(sender)
		sender:removeFromParentAndCleanup(true);
	end	

	
	local arr = CCArray:create()	
	local moveby = CCMoveBy:create(1, ccp(winSize.width,0))
	local actionremove = CCCallFuncN:create(removeLast)
	arr:addObject(moveby)
	arr:addObject(actionremove)
	local  seq = CCSequence:create(arr)	
	g_bglayer:runAction(seq)	
	
	
	--�±��� �����ƶ�����,Ȼ������Ϊg_bglayer
	function resetGlayer(sender)
		g_bglayer = sender;	
		p.RefreshBtn()
	end
	local arr = CCArray:create()	
	local moveby = CCMoveBy:create(1, ccp(winSize.width,0))
	local actionreset = CCCallFuncN:create(resetGlayer)
	arr:addObject(moveby)
	arr:addObject(actionreset)
	local  seq = CCSequence:create(arr)	
	lastlayer:runAction(seq)
	
	g_sceneGame:addChild(lastlayer)
	--<<<<<<<<<<<<<<<--
end

--��һ�½�
function p.NextChapterBtn()
	g_Chapter = g_Chapter + 1;
	
	--��������ʱ ���ذ�ť
	p.HideBtn()
	
	local nextlayer = p.GetChapterUI(g_Chapter);
	nextlayer:setPosition(winSize.width , 0)
	
	-->>>>>>>>>>>>>>>����Ч��
	--ԭ���� �����ƶ�����,Ȼ��ɾ��
	function removeLast(sender)
		sender:removeFromParentAndCleanup(true);
	end	
	
	--�����ƶ�����
	local arr = CCArray:create()	
	local moveby = CCMoveBy:create(1, ccp(-winSize.width,0))
	
	local actionremove = CCCallFuncN:create(removeLast)
	arr:addObject(moveby)
	arr:addObject(actionremove)
	local  seq = CCSequence:create(arr)	
	g_bglayer:runAction(seq)	

	
	--�±��� �����ƶ�����,Ȼ������Ϊg_bglayer
	function resetGlayer(sender)
		g_bglayer = sender;	
		p.RefreshBtn()
	end
	local arr = CCArray:create()	
	local moveby = CCMoveBy:create(1, ccp(-winSize.width,0))
	local actionreset = CCCallFuncN:create(resetGlayer)
	arr:addObject(moveby)
	arr:addObject(actionreset)
	local  seq = CCSequence:create(arr)	
	nextlayer:runAction(seq)


	g_sceneGame:addChild(nextlayer)
	--<<<<<<<<<<<<<<<--		
end

--��ʾ�½ڱ����͹ؿ����
function p.GetChapterUI(nChapter)
	local tmission = mission.GeCHAPTER_TABLEMission(nChapter)
		
	local bg = GameBg.GetBgLayer(CHAPTER_TABLE[nChapter].BgId)
	bg:setPosition(winSize.width / 2 , winSize.height/2)
	
	--����portal
	nextlayer = CCLayer:create()

	local menu = CCMenu:create()
	menu:setPosition(CCPointMake(0, 0))

	for i,missionid in pairs(tmission) do
		local Portal = CCMenuItemImage:create("UI/MissionSelect/portal.png","UI/MissionSelect/portal.png")
		Portal:registerScriptTapHandler(p.PortalOnClick)
		menu:addChild(Portal,1,missionid)
		tpos = tMissionPortalInfo[i].POSITION
		Portal:setPosition(tpos[1],tpos[2])
	end
	nextlayer:addChild(menu, 2,1)
	nextlayer:addChild(bg)
	
	return nextlayer
end



--ˢ�·�ҳ��ť
function p.RefreshBtn()
	if g_Chapter <= 1 then
		LastChapterBtn:setVisible(false)
	else
		LastChapterBtn:setVisible(true)	
	end
	
	--������½����ذ�ť
	if g_Chapter >= #CHAPTER_TABLE then
		NextChapterBtn:setVisible(false)
	else
		NextChapterBtn:setVisible(true)
	end			
end

function p.HideBtn()
	LastChapterBtn:setVisible(false)
	NextChapterBtn:setVisible(false)
end



















