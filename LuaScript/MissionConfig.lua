--�ؿ����ñ༭��
MissionConfig = {}

local p = MissionConfig;

local g_tRandom = {}
local grandomskill1,grandomskill2,grandomskill3 = 0,0,0;

local savepath = "data\\missionConfig\\mission1.xml"


function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.MissionConfig);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end



function p.LoadUI()
		local bglayer = CCLayer:create()
		--���ӱ���
		local bgSprite = CCSprite:create("UI/Bg/BG1.png")
		bgSprite:setScale(1.5);
		bglayer:addChild(bgSprite,1)
		
		
		local scene = Main.GetGameScene();
		scene:addChild(bglayer,999,UIdefine.MissionConfig)	
	
	
		local menu = CCMenu:create()
		menu:setPosition(CCPointMake(370, 270))
		
		--�洢��ť
		local SavaBtn = CCMenuItemImage:create("UI/missionConfig/SavaBtn.png","UI/missionConfig/SavaBtn.png")
		SavaBtn:registerScriptTapHandler(p.SaveData)
		menu:addChild(SavaBtn)
		bglayer:addChild(menu,3)
		--SavaBtn:setPosition(350,200)	
		
	p.ShowTable()
	
	--���Կؼ�
	local test = dragBar:Create()
	bglayer:addChild(test,3)
	test:setPosition(CCPointMake(20, -200))
		
	
	-->>>>>>>>>>>>>>>����Ч��	
	--����Ʈ��
	local arr = CCArray:create()	
	bglayer:setPosition(480 , winSize.height+300)
	local moveby = CCMoveBy:create(1, ccp(0,-winSize.height))
	local actiontoease =  CCEaseBounceOut:create(moveby)	
	
	arr:addObject(actiontoease)
	
	local  seq = CCSequence:create(arr)	
	bglayer:runAction(seq)

end


--��������
local tMissionData = 
{
{1000	,	{11,1,3},		{50,25,25}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=16,     [tbrickType.SWORD]=21,     [tbrickType.BLOOD]=21,     [tbrickType.GOLD]=21}},
{1		,	{9},		{100}		,10		, 1			,{6}	,{[tbrickType.MONSTER]=100,    [tbrickType.SWORD]=0,     [tbrickType.BLOOD]=0,     [tbrickType.GOLD]=0}},
{10		,	{1},		{100}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=16,     [tbrickType.SWORD]=21,     [tbrickType.BLOOD]=21,     [tbrickType.GOLD]=21}},
{300	,	{1},		{100}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=16,     [tbrickType.SWORD]=21,     [tbrickType.BLOOD]=21,     [tbrickType.GOLD]=21}},
--{9999	,	{1},		{100}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=0,      [tbrickType.SWORD]=30,     [tbrickType.BLOOD]=30,     [tbrickType.GOLD]=40}},
}

local taglabel = 9999

local nTagAddMonType = 9997
local nTaground = 9998
local nTagMonType = 10000--10000����Ϊ��������
local nTagMonRate = 20000--20000����Ϊ�������
local nTagMenu = 1000

function p.ShowTable()
	local bglayer = p.GetParent()
	for i,v in pairs(tMissionData)do
		local itembgSprite = CCSprite:create("UI/missionConfig/itembgSprite.png")
		itembgSprite:setPosition(CCPointMake(5, 360-i*100))
		
		
		local menu = CCMenu:create()
		menu:setPosition(CCPointMake(0, 27))
		
		--�غ��������
		local Roundlabel = CCTextFieldTTF:textFieldWithPlaceHolder("round"..i, "Arial", 20)
		Roundlabel:setPosition(CCPointMake(25, 20))
		Roundlabel:setColor(ccc3(0,0,0))
		Roundlabel:setString(v[1])
		local itemRound = CCMenuItemImage:create("UI/missionConfig/itemSprite.png", "UI/missionConfig/itemSprite.png")
		itemRound:registerScriptTapHandler(p.clickText)
		itemRound:setPosition(55,0)
		itemRound:addChild(Roundlabel,2,taglabel)
		menu:addChild(itemRound,2,nTaground)
		
		menu.MontypebtnList = {}
		menu.MonRateList = {}
		menu.RemoveBtnList = {}

		--�������Ͱ�ť 		--�������͸���label
		for j,m in pairs(v[2])do
			--���Ͱ�ť
			local itemMonType = CCMenuItemImage:create("UI/missionConfig/itemSpriteSmall.png", "UI/missionConfig/itemSpriteSmall.png")
			itemMonType:registerScriptTapHandler(p.clickMontype)
			itemMonType:setPosition(120+80*(j-1),0)
			menu:addChild(itemMonType,2,nTagMonType+j)
			table.insert(menu.MontypebtnList,itemMonType)

			--������ﶯ��
			local spriteBrick = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(m))
			spriteBrick:setPosition(CCPointMake(17, 20))
			spriteBrick:setScale(0.4);
			itemMonType:addChild(spriteBrick)
			
			
			--ɾ����ť
			local removeMonType = CCMenuItemImage:create("UI/missionConfig/removeMontype.png", "UI/missionConfig/removeMontype.png")
			removeMonType:registerScriptTapHandler(p.RemoveMontype)
			removeMonType:setPosition(120+80*(j-1),-40)
			removeMonType.monbtn = itemMonType;
			table.insert(menu.RemoveBtnList,removeMonType)
			menu:addChild(removeMonType,3)			
			
			
			--���������
			local itemMonRate = CCMenuItemImage:create("UI/missionConfig/itemSpriteSmall.png", "UI/missionConfig/itemSpriteSmall.png")
			itemMonRate:registerScriptTapHandler(p.clickText)
			itemMonRate:setPosition(CCPointMake(160+80*(j-1), 0))
			menu:addChild(itemMonRate,2,nTagMonRate+j)
			table.insert(menu.MonRateList,itemMonRate)

			local MonRatelabel = CCTextFieldTTF:textFieldWithPlaceHolder("", "Arial", 20)
			MonRatelabel:setColor(ccc3(0,0,0))
			MonRatelabel:setPosition(CCPointMake(20,25))
			MonRatelabel:setString(v[3][j])
			itemMonRate:addChild(MonRatelabel,2,taglabel)
			

		end
		
		--�ӹְ�ť
		local addMonItem = CCMenuItemImage:create("UI/missionConfig/addMontype.png", "UI/missionConfig/addMontype.png")
		addMonItem:registerScriptTapHandler(p.AddMonType)
		addMonItem:setPosition(450,0)
		menu:addChild(addMonItem,2,nTagAddMonType)	
		
		tMissionData[i].MENU = menu
		itembgSprite:addChild(menu,2,nTagMenu)
		bglayer:addChild(itembgSprite,2,i)	
	end
end

--ɾ����������
function p.RemoveMontype(tag,sender)
	local Monbtn = sender.monbtn
	local menu = sender:getParent()	

	local tMontypebtnList =	 menu.MontypebtnList
	local tRemoveBtnList = menu.RemoveBtnList
	local tMonRateList =  menu.MonRateList	
	
	local index = 0
	for i,v in pairs(tMontypebtnList)do
		if Monbtn == v then
			Monbtn:removeFromParentAndCleanup(true);
			index = i
			break
		end
	end

	
	local btn = tMonRateList[index]
	btn:removeFromParentAndCleanup(true);
	table.remove(tMontypebtnList,index)
	table.remove(tMonRateList,index)

	--ɾ���Ƴ���ť
	table.remove(tRemoveBtnList,index)
	sender:removeFromParentAndCleanup(true);
	
	--����
	for i,v in pairs(tMontypebtnList)do
		v:setPosition(120+80*(i-1),0)
	end
	for i,v in pairs(tMonRateList)do
		v:setPosition(160+80*(i-1),0)
	end	
	for i,v in pairs(tRemoveBtnList)do
		v:setPosition(120+80*(i-1),-40)
	end
	
	--ɾ������
	local Dataindex = p.GetIndexByMenu(menu)
	local tMontype = tMissionData[Dataindex][2]
	local tMonrate = tMissionData[Dataindex][3]	
	table.remove(tMontype,index)
	table.remove(tMonrate,index)		
end
	
--ͨ��menu��ȡINDEX
function p.GetIndexByMenu(menu)
	for i,v in pairs(tMissionData)do
		if menu == v.MENU then
			return i
		end
	end
end	

	
--���ӹ�������
function p.AddMonType(tag,sender)
	local menu = sender:getParent()
	menu = tolua.cast(menu, "CCMenu")


	local nindex = p.GetIndexByMenu(menu)
	local tMontype = tMissionData[nindex][2]
	local tMonrate = tMissionData[nindex][3]
	--�����������
	table.insert(tMontype,1) --�������
	table.insert(tMonrate,0) --�������

	local nmontype = tMontype[#tMontype]
	local nrate    = tMonrate[#tMonrate]
	
	local itemMonType = CCMenuItemImage:create("UI/missionConfig/itemSpriteSmall.png", "UI/missionConfig/itemSpriteSmall.png")
	itemMonType:registerScriptTapHandler(p.clickMontype)
	itemMonType:setPosition(120+80*(#tMontype-1),0)
	menu:addChild(itemMonType,2,nTagMonType+#tMontype)	
	table.insert(menu.MontypebtnList,itemMonType)
	
	--������ﶯ��
	local spriteBrick = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(nmontype))
	spriteBrick:setPosition(CCPointMake(17, 20))
	spriteBrick:setScale(0.4);
	itemMonType:addChild(spriteBrick)
	
	--���������
	local itemMonRate = CCMenuItemImage:create("UI/missionConfig/itemSpriteSmall.png", "UI/missionConfig/itemSpriteSmall.png")
	itemMonRate:registerScriptTapHandler(p.clickText)
	itemMonRate:setPosition(CCPointMake(160+80*(#tMonrate-1), 0))
	menu:addChild(itemMonRate,2,nTagMonRate+#tMonrate)
	table.insert(menu.MonRateList,itemMonRate)
	
	local MonRatelabel = CCTextFieldTTF:textFieldWithPlaceHolder("", "Arial", 20)
	MonRatelabel:setColor(ccc3(0,0,0))
	MonRatelabel:setPosition(CCPointMake(20,25))
	MonRatelabel:setString(tMonrate[#tMonrate])
	itemMonRate:addChild(MonRatelabel,2,taglabel)
				
	--ɾ����ť
	local removeMonType = CCMenuItemImage:create("UI/missionConfig/removeMontype.png", "UI/missionConfig/removeMontype.png")
	removeMonType:registerScriptTapHandler(p.RemoveMontype)
	removeMonType:setPosition(120+80*(#tMonrate-1),-40)
	removeMonType.monbtn = itemMonType;
	table.insert(menu.RemoveBtnList,removeMonType)
	menu:addChild(removeMonType,3)
			
			
end		

function p.clickText(tag,sender)
	if tag == nTaground then--�غ���
		p.clickTextRound(sender)
	elseif tag >= nTagMonRate  then --��������
		p.clickTextRound(sender)
	end
end

--��������
function p.SaveData()
	local bglayer =  p.GetParent()
	
	--��ȡ�����������
	for i,v in pairs(tMissionData)do
		local menu = v.MENU
		local  nRound = p.GetLabelData(menu,nTaground);
		v[1] = nRound
		
	end--]]
	
	--
	--montype
	
	
	data(tMissionData, savepath)
end	

--�����������
function p.clickMontype()
end	

--����غ��������
function p.clickTextRound(sender)
	local testlabel = sender:getChildByTag(taglabel);
	testlabel = tolua.cast(testlabel, "CCTextFieldTTF")
	testlabel:attachWithIME()	
end

--��ȡlable����	
function p.GetLabelData(menu,tag)
	local item =  menu:getChildByTag(tag);
	item = tolua.cast(item, "CCMenuItemImage")
	
	local label = item:getChildByTag(taglabel);
	label = tolua.cast(label, "CCTextFieldTTF")
	
	local data =  label:getString();
	return data
end
	

--�����ؼ�

	

