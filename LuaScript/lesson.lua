--lesson �̳�

lesson = {}
local  p = lesson;

local winSize = CCDirector:sharedDirector():getWinSize()

local savepath = "save\\plaer1.xml"
local g_Lesson_Process = 1; --�̳̽���
local gTimerId = nil;--��ʱ���

local tLesson = {}
	tLesson[1]={}
	tLesson[1].desc = "How To link"
	tLesson[1].condition_func = nil
	
	
	tLesson[2]={}
	tLesson[2].desc = "Kill Mon With Sword"
	tLesson[2].condition_func = function()	--��������
									local count = 0
									--��������1ֻ����Ϳ��Դ���
									for i = 1,brickInfo.brick_num_X do
										for j = 1,brickInfo.brick_num_Y do
											if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then
												--������1
												count = count + 1
											end
										end
									end
									if count >= 1 then
										return true
									else
										return false
									end
								end

	tLesson[3]={}
	tLesson[3].desc = "Monster will attack if the green bar is CD"
	tLesson[3].condition_func = function()	--��������
									local count = 0
									--��������5ֻ����Ϳ��Դ���
									for i = 1,brickInfo.brick_num_X do
										for j = 1,brickInfo.brick_num_Y do
											if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.MONSTER then
												--������1
												count = count + 1
											end
										end
									end
									if count >= 5 then
										return true
									else
										return false
									end
								end

	tLesson[4]={}
	tLesson[4].desc = "the red ball is your life"
	tLesson[4].condition_func = function()	--��������	
									--�������ֵ������99%
									local percent =100*player[playerInfo.HP]/player[playerInfo.Entity_HPMAX]
									if percent <= 99 then
										return true
									else
										return false
									end
								end


	tLesson[5]={}
	tLesson[5].desc = "link the red bottle to recover life"
	tLesson[5].condition_func = function()	--��������
									--�������ֵ������50%		
									local percent =100*player[playerInfo.HP]/player[playerInfo.Entity_HPMAX]
									if percent <= 50 then
										return true
									else
										return false
									end
								end
								
	tLesson[6]={}
	tLesson[6].desc = "the blue ball is your energy,your will spend energy everytime you link or use skill"
	tLesson[6].condition_func = function()	--��������
									--�������ֵ������50%		
									local percent =100*player[playerInfo.ENERGY]/player[playerInfo.Entity_ENERGYMAX]
									if percent <= 50 then
										return true
									else
										return false
									end
								end								

	tLesson[7]={}
	tLesson[7].desc = "link the blue bottle to recover energy"
	tLesson[7].condition_func = function()	--��������
									--�������ֵ������10%		
									local percent =100*player[playerInfo.ENERGY]/player[playerInfo.Entity_ENERGYMAX]
									if percent <= 10 then
										return true
									else
										return false
									end
								end	

	tLesson[8]={}
	tLesson[8].desc = "link the coin to gain them"
	tLesson[8].condition_func = function()	--��������
									--��������5����ҾͿ��Դ���
									local count = 0
									for i = 1,brickInfo.brick_num_X do
										for j = 1,brickInfo.brick_num_Y do
											if Board[i][j] ~= nil and Board[i][j].nType == tbrickType.GOLD then
												--������1
												count = count + 1
											end
										end
									end
									if count >= 5 then
										return true
									else
										return false
									end
								end					
														
	tLesson[9]={}
	tLesson[9].desc = "how to upgrade equipment	"
	tLesson[9].condition_func = function()	--��������
									--��ҽ��>=100
									if player[playerInfo.GOLD] >= 100 then
										return true
									else
										return false
									end
								end

	tLesson[10]={}
	tLesson[10].desc = "how to use buff skill"
	tLesson[10].condition_func = function()	--��������
									--�����buff����
									for magicId,v in pairs(player.MagicCD) do
										--player.MagicCD[magicId] = magictable[magicId][MAGIC_DEF_TABLE.CDROUND]
										if 	magictable[magicId][MAGIC_DEF_TABLE.TARGET_TYPE] == TARGET_TYPE.PLAYER then --BUFF����
											return true
										end
									end
									return false
								end


	tLesson[11]={}
	tLesson[11].desc = "how to use active skill"
	tLesson[11].condition_func = function()	--��������
									--����е�ɱ����
									for magicId,v in pairs(player.MagicCD) do
										if 	magictable[magicId][MAGIC_DEF_TABLE.TARGET_TYPE] ~= TARGET_TYPE.PLAYER then --��ɱ����
											return true
										end
									end
									return false
								end


function p.Init()
	--����Ƿ��Ѿ������̳�
	--��ȡ����ͼ����Ϣ
	local tPlayersave = {}
	data(savepath, tPlayersave)
	
	if tPlayersave.lesson== false then
		--������ⶨʱ��
		gTimerId = CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(p.CheckLesson, 3, false)
		g_Lesson_Process = 1;		
	end
end

--������������̳�
function p.CheckLesson()
	
	--�̳̽���
	if g_Lesson_Process > #tLesson then
		if gTimerId ~= nil then
			CCDirector:sharedDirector():getScheduler():unscheduleScriptEntry(gTimerId)
			gTimerId = nil
			local tPlayersave = {}
			data(savepath, tPlayersave)
			tPlayersave.lesson = true;
			data(tPlayersave,savepath )
		end
		return
	end
	
	
	if tLesson[g_Lesson_Process].condition_func == nil then  --���败����ֱ����ʾ
		--��ʾ����
		p.LoadUI(g_Lesson_Process)
		g_Lesson_Process = g_Lesson_Process + 1
	elseif tLesson[g_Lesson_Process].condition_func() then	--�����������ʾ
		p.LoadUI(g_Lesson_Process)
		g_Lesson_Process = g_Lesson_Process + 1
	end
	
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


function p.GetParent()
	local scene = Main.GetGameScene();
	local layer = scene:getChildByTag(UIdefine.LESSON);
	local layer = tolua.cast(layer, "CCLayer")
	return layer
end


--��ʾ����
function p.LoadUI(g_Lesson_Process)
	
			
			
	bglayer = CCLayer:create()
	bglayer:setTag(UIdefine.LESSON);
	
	local menu = CCMenu:create()


	local closeBtn = CCMenuItemImage:create("UI/Button/CLOSE.png", "UI/Button/CLOSE.png")
		closeBtn:registerScriptTapHandler(p.closeUICallback)
		closeBtn:setPosition(300,400)
		
	menu:addChild(closeBtn)
	menu:setPosition(CCPointMake(0, 0))
	bglayer:addChild(menu, 2,99)

	
	--��ʾ����
	local sdesc = tLesson[g_Lesson_Process].desc
	
	local desclabel = CCLabelTTF:create(sdesc, "Arial", 25)
			bglayer:addChild(desclabel,2)
			desclabel:setColor(ccc3(255,0,0))
			desclabel:setPosition(0, 150)

	
	--���ӱ��� 
	local bgSprite = CCSprite:create("UI/lesson/lesson.png")
	--bgSprite:setScale(1.5);
    bglayer:addChild(bgSprite,1)
	bglayer:setPosition(CCPointMake(340, 220))
	bglayer:setScale(0.65);
	
	
	
	local scene = Main.GetGameScene();
	scene:addChild(bglayer,4)	
	
	CCDirector:sharedDirector():pause()
end

