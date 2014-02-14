--�ؿ����ñ༭��
MissionConfig = {}

local p = MissionConfig;

local g_tRandom = {}
local grandomskill1,grandomskill2,grandomskill3 = 0,0,0;

local savepath = "data\\missionConfig\\mission1.xml"

local tbrickTypeInfo = {}
										--SPRITE ID
	tbrickTypeInfo[tbrickType.MONSTER] 	=  1
	tbrickTypeInfo[tbrickType.SWORD] 	=  3
	tbrickTypeInfo[tbrickType.BLOOD] 	=  7
	tbrickTypeInfo[tbrickType.GOLD] 	=  4
	tbrickTypeInfo[tbrickType.ENERGY] 	=  20
	
	
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
{1000	,	{11,1,3},	{50,25,25}	,10		, 1			,{0}	,{ 	[tbrickType.MONSTER]=16,     [tbrickType.SWORD]=21,     [tbrickType.BLOOD]=21,     [tbrickType.GOLD]=21,[tbrickType.ENERGY]=21} },
--{1		,	{9},		{100}		,10		, 1			,{6}	,{[tbrickType.MONSTER]=100,    [tbrickType.SWORD]=0,     [tbrickType.BLOOD]=0,     [tbrickType.GOLD]=0}},
--{10		,	{1},		{100}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=16,     [tbrickType.SWORD]=21,     [tbrickType.BLOOD]=21,     [tbrickType.GOLD]=21}},
--{300	,	{1},		{100}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=16,     [tbrickType.SWORD]=21,     [tbrickType.BLOOD]=21,     [tbrickType.GOLD]=21}},
--{9999	,	{1},		{100}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=0,      [tbrickType.SWORD]=30,     [tbrickType.BLOOD]=30,     [tbrickType.GOLD]=40}},
}

local taglabel = 9999

local nTaground = 9998
local nTagAddMonType = 9997
local nTagLev	= 9996

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


		--��������bar
		local MonDragbar = dragBar:Create()
		itembgSprite:addChild(MonDragbar,3)
		MonDragbar:setPosition(CCPointMake(320, 0))
		menu.MonRateBar = MonDragbar
		
		--�������Ͱ�ť 		--�������͸���label
		for j,m in pairs(v[2])do
			--���Ͱ�ť
			local itemMonType = CCMenuItemImage:create("UI/missionConfig/itemSpriteSmall.png", "UI/missionConfig/itemSpriteSmall.png")
			itemMonType:registerScriptTapHandler(p.clickMontype)
			itemMonType:setPosition(120+40*(j-1),0)
			menu:addChild(itemMonType,2,nTagMonType+j)
			table.insert(menu.MontypebtnList,itemMonType)

			--������ﶯ��
			local spriteBrick = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(m))
			spriteBrick:setPosition(CCPointMake(17, 20))
			spriteBrick:setScale(0.4);
			itemMonType:addChild(spriteBrick)
			spriteBrick:setTag(99)
			
			--ɾ����ť
			local removeMonType = CCMenuItemImage:create("UI/missionConfig/removeMontype.png", "UI/missionConfig/removeMontype.png")
			removeMonType:registerScriptTapHandler(p.RemoveMontype)
			removeMonType:setPosition(120+40*(j-1),-40)
			removeMonType.monbtn = itemMonType;
			table.insert(menu.RemoveBtnList,removeMonType)
			menu:addChild(removeMonType,3)			
			
			
			--�����������
			local pointerbg = CCSprite:create("UI/missionConfig/spriteSmall.png")
			local spriteMon = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(m)) 
			spriteMon:setScale(0.4);
			spriteMon:setPosition(CCPointMake(17, 20))
			pointerbg:addChild(spriteMon)
			
			MonDragbar:AddPointer(m,v[3][j],pointerbg)					
		end

	
		
		--�ӹְ�ť
		local addMonItem = CCMenuItemImage:create("UI/missionConfig/addMontype.png", "UI/missionConfig/addMontype.png")
		addMonItem:registerScriptTapHandler(p.AddMonType)
		addMonItem:setPosition(450,0)
		menu:addChild(addMonItem,2,nTagAddMonType)
		
		tMissionData[i].MENU = menu
		itembgSprite:addChild(menu,2,nTagMenu)
		bglayer:addChild(itembgSprite,2,i)	
		
		
		--ש���������
		local BrickDragbar = dragBar:Create()
		itembgSprite:addChild(BrickDragbar,3)
		BrickDragbar:setPosition(CCPointMake(620, 0))
		menu.BrickRateBar = BrickDragbar		
		local tbrickRate = v[7]
		for i=1,#tbrickRate do	
			
			local pointerbg = CCSprite:create("UI/missionConfig/spriteSmall.png")
			local spriteBrick = SpriteManager.creatBrickSprite(tbrickTypeInfo[i])
			spriteBrick:setScale(0.4);
			spriteBrick:setPosition(CCPointMake(17, 20))
			pointerbg:addChild(spriteBrick)

			BrickDragbar:AddPointer(1,tbrickRate[i],pointerbg)		
		end			
		
		
		--�ȼ������
		local Levlabel = CCTextFieldTTF:textFieldWithPlaceHolder("level", "Arial", 20)
		Levlabel:setPosition(CCPointMake(25, 20))
		Levlabel:setColor(ccc3(0,0,0))
		Levlabel:setString(v[6][1])
		local itemLev = CCMenuItemImage:create("UI/missionConfig/itemSpriteSmall.png", "UI/missionConfig/itemSpriteSmall.png")
		itemLev:registerScriptTapHandler(p.clickText)
		itemLev:setPosition(500,0)
		itemLev:addChild(Levlabel,2,taglabel)
		menu:addChild(itemLev,2,nTagLev)
				
		
		--�����а�ť
		local itemInsert = CCMenuItemImage:create("UI/missionConfig/itemSpriteInsert.png", "UI/missionConfig/itemSpriteInsert.png")
		itemInsert:registerScriptTapHandler(p.InsertLine)
		itemInsert:setPosition(50,-20)
		menu:addChild(itemInsert,2,nTagInsertLine)			
	end
end

	
--ɾ����������
function p.RemoveMontype(tag,sender)
	local Monbtn = sender.monbtn
	local menu = sender:getParent()	
	local ratebar = menu.MonRateBar
	local tMontypebtnList =	 menu.MontypebtnList
	local tRemoveBtnList = menu.RemoveBtnList
	
	local index = 0
	for i,v in pairs(tMontypebtnList)do
		if Monbtn == v then
			Monbtn:removeFromParentAndCleanup(true);
			index = i
			break
		end
	end
	
	table.remove(tMontypebtnList,index)
	
	--ɾ���Ƴ���ť
	table.remove(tRemoveBtnList,index)
	sender:removeFromParentAndCleanup(true);
	
	
	
	--����
	for i,v in pairs(tMontypebtnList)do
		v:setPosition(120+40*(i-1),0)
	end

	for i,v in pairs(tRemoveBtnList)do
		v:setPosition(120+40*(i-1),-40)
	end
	
	--ɾ������
	local Dataindex = p.GetIndexByMenu(menu)
	
	--ɾ��BAR
	ratebar:DelPointer(tMissionData[Dataindex][2][index])
		
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


--����һ������
function p.InsertLine(tag,sender)
	local menu = sender:getParent()
	menu = tolua.cast(menu, "CCMenu")
	local nindex = p.GetIndexByMenu(menu)
	
	--��������1��step
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
	itemMonType:setPosition(120+40*(#tMontype-1),0)
	menu:addChild(itemMonType,2,nTagMonType+#tMontype)	
	table.insert(menu.MontypebtnList,itemMonType)
	
	--������ﶯ��
	local spriteBrick = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(nmontype))
	spriteBrick:setPosition(CCPointMake(17, 20))
	spriteBrick:setScale(0.4);
	itemMonType:addChild(spriteBrick)
	spriteBrick:setTag(99)
	
	--ɾ����ť
	local removeMonType = CCMenuItemImage:create("UI/missionConfig/removeMontype.png", "UI/missionConfig/removeMontype.png")
	removeMonType:registerScriptTapHandler(p.RemoveMontype)
	removeMonType:setPosition(120+40*(#tMonrate-1),-40)
	removeMonType.monbtn = itemMonType;
	table.insert(menu.RemoveBtnList,removeMonType)
	menu:addChild(removeMonType,3)
	


	local pointerbg = CCSprite:create("UI/missionConfig/spriteSmall.png")
	local spriteMon = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(nmontype)) 
	spriteMon:setScale(0.4);
	spriteMon:setPosition(CCPointMake(17, 20))
	pointerbg:addChild(spriteMon)
				
	local MonDragbar = menu.MonRateBar
	MonDragbar:AddPointer(nmontype,nrate,pointerbg)
	
		
			
			
end		

function p.clickText(tag,sender)
	if tag == nTaground then--�غ���
		p.clickTextRound(sender)
	elseif tag == nTagLev then	--����ȼ�
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
		
		
		local MonrateBar = menu.MonRateBar
		local tdata = MonrateBar:getData() 
		v[3] = tdata
		
		local nLev = p.GetLabelData(menu,nTagLev);
		v[6][1] = nLev
		
		local brickrateBar = menu.BrickRateBar	
		local tdata = brickrateBar:getData() 
		v[7] = tdata
		
	end--]]
	
	--
	--montype
	
	
	data(tMissionData, savepath)
end	



local gX_Step = 100;
local gY_Step = 100;
local gX_Num = 5;
local MonTypeLayer = nil
local g_Chosed_MontypeItem = nil  --ѡ�й��������л���ť
--����������� �л���������
function p.clickMontype(tag,sender)
	g_Chosed_MontypeItem = sender
	
	local bglayer = CCLayer:create()
	MonTypeLayer = bglayer
	local menu = CCMenu:create()	
	for i,v in pairs(MONSTER_TYPE) do
		local  spriteNormal = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(i))
		local  spriteSelected = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(i))
		local  spriteDisabled = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(i))
		
		local  item1 = CCMenuItemSprite:create(spriteNormal, spriteSelected, spriteDisabled)
		
		item1:registerScriptTapHandler(p.switchType)
		menu:addChild(item1,1,i)
		local X = i%gX_Num
		if X == 0 then
			X = gX_Num
		end
		local Y = math.ceil(i/gX_Num)
		item1:setPosition(-250+gX_Step*X,200-gY_Step*Y)
	end
	
	menu:setPosition(CCPointMake(0, 0))
	bglayer:addChild(menu, 2,1)
	bglayer:setPosition(CCPointMake(480, 320))
	--]]
	
	
	--���ӱ���
	local bgSprite = CCSprite:create("UI/Bg/BG1.png")
	bglayer:addChild(bgSprite,1)
	
	
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,999,UIdefine.SkillUpGradeUI)	
	
	local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
	closeBtn:registerScriptTapHandler(p.closeMonType)
	closeBtn:setPosition(CCPointMake(400, 20))
	menu:addChild(closeBtn)	
end	

function p.closeMonType()
	if MonTypeLayer ~= nil then
		MonTypeLayer:removeFromParentAndCleanup(true);
		MonTypeLayer = nil;
	end
end

--�л���������
function p.switchType(tag,sender)
	local montype = tag
	--ɾ������
	g_Chosed_MontypeItem:removeChildByTag(99, true)
	local spriteBrick = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(montype))
	spriteBrick:setPosition(CCPointMake(17, 20))
	spriteBrick:setScale(0.4);
	g_Chosed_MontypeItem:addChild(spriteBrick)
	spriteBrick:setTag(99)
	
	local menu = g_Chosed_MontypeItem:getParent()	
	local Dataindex = p.GetIndexByMenu(menu)
	local tMontype = tMissionData[Dataindex][2]

	local btnindex = 0 
	for i,v in pairs(menu.MontypebtnList)do
		if g_Chosed_MontypeItem == v then
			btnindex = i
			break
		end
	end
	
	tMontype[btnindex] = montype
	
	local MonrateBar = menu.MonRateBar
	
	local pointerbg = CCSprite:create("UI/missionConfig/spriteSmall.png")
	local spriteMon = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(montype)) 
	spriteMon:setScale(0.4);
	spriteMon:setPosition(CCPointMake(17, 20))
	pointerbg:addChild(spriteMon)	
	
	MonrateBar:switchBtnSprite(pointerbg,btnindex)
	p.closeMonType()
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

	

