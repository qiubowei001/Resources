--MonsterHandBook ����ͼ��

MonsterHandBook = {}
local  p = MonsterHandBook;

local winSize = CCDirector:sharedDirector():getWinSize()


local tHandBookInfo = {}

local tHandBookInfoCache = {} --�����Ϣ --��Ϸ�����󴢴���ļ���
local savepath = "save\\monsterHandbook.xml"
--��ʼ��
function p.Init()
	--tHandBookInfoCache[1] = {MONID = XX IFSHOWN = true}
	tHandBookInfoCache = {}
	--��ȡ����ͼ����Ϣ
	data(savepath, tHandBookInfoCache)
end	

--�������ͻ�ȡ����ͼ����Ϣ
--����tRet = {����ָ��,Ѫ��ָ��,�ٶ�ָ��,�������� }
--ָ��: 1 weak 2normal 3strong
function p.GetAttIndicator(nAttGrow)
	if nAttGrow <= 0.5	then
		return 1
	elseif 	nAttGrow <= 0.9 then
		return 2
	else
		return 3
	end
end

function p.GetHPIndicator(nHPGrow)
	if nHPGrow <= 1 then
		return 1
	elseif 	nHPGrow <= 1.9 then
		return 2
	else
		return 3
	end	
end

function p.GetSpeedIndicator(nCDGrow)
	if nCDGrow <= -1.5 then
		return 3
	elseif 	nCDGrow <= -1.1 then
		return 2
	else
		return 1
	end
end

function p.GetHandBookInfo(nMonsterType)
	
	local nAttIndicator = p.GetAttIndicator(MONSTER_TYPE[nMonsterType]["ATTGrow"])
	local nHPIndicator = p.GetHPIndicator(MONSTER_TYPE[nMonsterType]["HPGrow"])
	local nSpeedIndicator = p.GetSpeedIndicator(MONSTER_TYPE[nMonsterType]["CDGrow"])
		
	--local sDesc = MONSTER_TYPE[nMonsterType]["desc"]
	return nAttIndicator,nHPIndicator,nSpeedIndicator--,sDesc
end

--���ݹ���������ʾ����ͼ��
function p.ShowMonsterHandBook(nMonsterType)
	local tmoninfo = p.SearchBookInfoT(nMonsterType)
	
	--�Ѿ���ʾ��������
	if tmoninfo ~= nil and tmoninfo.IFSHOWN then
		return
	end
	
	
	--��ʾ
	p.LoadUI(nMonsterType)
	
	
	if tmoninfo == nil then
		--��ֵ�����
		tmoninfo = {MONID = nMonsterType ,IFSHOWN = true}
		table.insert(tHandBookInfoCache,tmoninfo);
	else	
		--��ֵ���޸�����
		tmoninfo.IFSHOWN = true;
	end
	
	
	
	--����д��
	--data(tHandBookInfoCache, savepath)
end


function p.SearchBookInfoT(nMonsterType)
	for i,v in pairs(tHandBookInfoCache)do
		if nMonsterType == v.MONID then
			return v;
		end
	end
	
	--��δ��ʾ
	return nil
end	

function p.closeUICallback(tag,sender)
	--�رս��� 
	local layer = p.GetParent()
	local scene = Main.GetGameScene();
	scene:removeChild(layer, true)
	
	--
	if CCDirector:sharedDirector():isPaused() then
		CCDirector:sharedDirector():resume()
    end	  --]] 
end

--����������
local tPositionAttribute = {}
							--position���
	tPositionAttribute[1] = {{-100,-180},"UI/Handbook/sword.png"}
	tPositionAttribute[2] = {{-100,-290},"UI/Handbook/heart.png"}
	tPositionAttribute[3] = {{-100,-400},"UI/Handbook/shoe.png"}

	
local tJiangeStep = 100 --ÿ��ͼ��������

--��ʾ����
function p.LoadUI(nMonsterType)
	local nAttIndicator,nHPIndicator,nSpeedIndicator  = p.GetHandBookInfo(nMonsterType)
	
	--��ͣ��Ϸ

	bglayer = CCLayer:create()

	local menu = CCMenu:create()


	local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
		closeBtn:registerScriptTapHandler(p.closeUICallback)
		closeBtn:setPosition(300,400)
		
	menu:addChild(closeBtn)
	menu:setPosition(CCPointMake(0, 0))
	bglayer:addChild(menu, 2,99)


	bglayer:setTag(UIdefine.MONSTER_HANDBOOK_UI);
	
	local t = {nAttIndicator,nHPIndicator,nSpeedIndicator}
	
	for i,indicator in pairs(t) do
		local tPosInfo = tPositionAttribute[i]
	
		for j=1,indicator do
			local tpos = tPosInfo[1]
			local posx = tpos[1] + tJiangeStep*(j-1)
			local posy = tpos[2]
			local pICON = CCSprite:create(tPosInfo[2])
			pICON:setPosition(CCPointMake(posx,posy))
			bglayer:addChild(pICON, 2)
		end
	end		
	
	--���ӱ��� 
	local bgSprite = CCSprite:create("UI/Handbook/monsterhandbook.png")
	--bgSprite:setScale(1.5);
    bglayer:addChild(bgSprite,1)
	bglayer:setScale(0.65);
	
	
	--����sprite
	local pmon =  SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(nMonsterType))
	pmon:setScale(4);
	pmon:setPosition(CCPointMake(0, 220))
	bglayer:addChild(pmon,2)	
	
	
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,4)	
	
	
	-->>>>>>>>>>>>>>>����Ч��	
	function pause()
		Main.EnableTouch(true)--�򿪴���
		CCDirector:sharedDirector():pause()
	end	
	--����Ʈ��
	local arr = CCArray:create()	
	bglayer:setPosition(340 , winSize.height+220)
	local moveby = CCMoveBy:create(1, ccp(0,-winSize.height))
	local actiontoease =  CCEaseBounceOut:create(moveby)	
	
	local actionremove = CCCallFuncN:create(pause)
	arr:addObject(actiontoease)
	arr:addObject(actionremove)
	
	local  seq = CCSequence:create(arr)	
	bglayer:runAction(seq)	

	Main.EnableTouch(false)--��ϴ���
	--<<<<<<<<<<<<<<<--	
end


function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.MONSTER_HANDBOOK_UI);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end

