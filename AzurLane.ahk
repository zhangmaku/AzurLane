;@Ahk2Exe-SetName AzurLane Helper
;@Ahk2Exe-SetDescription AzurLane Helper
;@Ahk2Exe-SetVersion 1.0.0.1
;@Ahk2Exe-SetMainIcon img\01.ico
/*
FileCreateDir, img 
FileInstall, img\01.ico, %A_WorkingDir%\img\01.ico, 1
FileInstall, img\boss.png, %A_WorkingDir%\img\boss.png, 1
FileInstall, img\bullet.png, %A_WorkingDir%\img\bullet.png, 1
FileInstall, img\quest.png, %A_WorkingDir%\img\quest.png, 1
FileInstall, img\target.png, %A_WorkingDir%\img\target.png, 1
FileInstall, img\target2.png, %A_WorkingDir%\img\target2.png, 1
FileInstall, img\target3.png, %A_WorkingDir%\img\target3.png, 1
FileInstall, img\target4.png, %A_WorkingDir%\img\target4.png, 1
FileInstall, img\target5.png, %A_WorkingDir%\img\target5.png, 1
FileInstall, img\target6.png, %A_WorkingDir%\img\target6.png, 1
FileInstall, img\test.png, %A_WorkingDir%\img\test.png, 1
FileInstall, img\WH.png, %A_ScriptDir%\img\WH.png, 1
*/
if not A_IsAdmin ;強制用管理員開啟
Run *RunAs "%A_ScriptFullPath%"
#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_WorkingDir%  ; Ensures a consistent starting directory.
#Persistent
DetectHiddenWindows, On
DetectHiddenText, On
Coordmode, pixel, window
Coordmode, mouse, window
;~ Menu, Tray, NoStandard
menu, tray, add, 顯示介面, Showsub
menu, tray, add,  , 
menu, tray, add, 結束, Exitsub
SetControlDelay, -1
SetBatchLines, 1000ms
SetTitleMatchMode, 3
#SingleInstance, force
Menu, Tray, Icon , img\01.ico,,, 1
gui, font, s11, 新細明體
RegRead, ldplayer, HKEY_CURRENT_USER, Software\Changzhi\dnplayer-tw, InstallDir
if (ldplayer="") {
	Logshow("未偵測到雷電模擬器已被安裝，請嘗試重新安裝。")
	Exitapp
}
Global ldplayer
Gui Add, Text,  x15 y20 w100 h20 , 模擬器標題：
IniRead, title, settings.ini, emulator, title, 
if (title="") or (title="ERROR") {
    InputBox, title, 設定精靈, `n`n　　　　　　　請輸入模擬器標題,, 400, 200,,,,, 雷電模擬器
    if ErrorLevel {
        Exitapp
    }
    else if  (title="") {
          Msgbox, 16, 設定精靈, 未輸入任何資訊。
          reload
    }
    else {
		InputBox, emulatoradb, 設定精靈, `n`n　　　　　　　請輸入模擬器編號,, 400, 200,,,,, 0
		if (emulatoradb>15 or emulatoradb<0) {
			msgbox, 請輸入介於0-15的數字
			exitapp
		}
		else {
			Iniwrite, %emulatoradb%, settings.ini, emulator, emulatoradb
			Iniwrite, %title%, settings.ini, emulator, title
			reload
		}
    }
}
Run, %comspec% /c powercfg /change /monitor-timeout-ac 0,, Hide ;關閉螢幕省電模式
Gui Add, Edit, x110 y17 w100 h21 vtitle ginisettings , %title%
Gui Add, Text,  x220 y20 w80 h20 , 代號：
IniRead, emulatoradb, settings.ini, emulator, emulatoradb, 0
Gui, Add, DropDownList, x270 y15 w40 h300 vemulatoradb ginisettings Choose%emulatoradb%, 1|2|3|4|5|6|7|8|9|10|11|12|13|14|15|0||
GuicontrolGet, emulatoradb
Gui Add, Text,  x330 y20 w80 h20 , 容許誤差：
IniRead, AllowanceValue, settings.ini, emulator, AllowanceValue, 2000
Gui Add, Edit, x410 y17 w50 h21 vAllowanceValue ginisettings  readonly Number Limit4, %AllowanceValue%
Gui, Add, Button, x20 y470 w100 h20 gstart vstart  , 開始
Gui, Add, Button, x140 y470 w100 h20 greload , 停止
Gui, Add, button, x780 y470 w100 h20 gexitsub, 結束 

Gui, Add, text, x480 y20 w400 h20 vstarttext  , 
Gui, Add, ListBox, x480 y45 w400 h415 ReadOnly vListBoxLog
;~ Gui, Add, Picture, x480 y450 0x4000000 ,img\WH.png

Gui,Add,Tab, x10 y50 w460 h405 gTabFunc, 出　擊|出擊２|學　院|後　宅|任　務|其　他|
;///////////////////     GUI Right Side  Start  ///////////////////

Gui, Tab, 出　擊
iniread, AnchorSub, settings.ini, Battle, AnchorSub
Gui, Add, CheckBox, x30 y90 w150 h20 gAnchorsettings vAnchorSub checked%AnchorSub% +c4400FF, 啟動自動出擊
Gui, Add, text, x30 y120 w80 h20  , 選擇地圖：
iniread, AnchorMode, settings.ini, Battle, AnchorMode, 普通
if AnchorMode=普通
	Gui, Add, DropDownList, x110 y115 w60 h100 vAnchorMode gAnchorsettings, 普通||困難|
else if AnchorMode=困難
	Gui, Add, DropDownList, x110 y115 w60 h100 vAnchorMode gAnchorsettings, 普通|困難||

iniread, AnchorChapter, settings.ini, Battle, AnchorChapter
iniread, AnchorChapter2, settings.ini, Battle, AnchorChapter2
Gui, Add, text, x180 y120 w20 h20  , 第
Gui, Add, DropDownList, x200 y115 w40 h300 vAnchorChapter gAnchorsettings Choose%AnchorChapter%, 1||2|3|4|5|6|7|8|9|10|11|12|13|
Gui, Add, text, x250 y120 w40 h20  , 章 第
Gui, Add, DropDownList, x290 y115 w40 h100 vAnchorChapter2 gAnchorsettings Choose%AnchorChapter2% , 1||2|3|4|
Gui, Add, text, x340 y120 w20 h20  , 節

Gui, Add, text, x30 y150 w140 h20  , 出擊時第一艦隊：
iniread, ChooseParty1, settings.ini, Battle, ChooseParty1, 第一艦隊
if ChooseParty1=第一艦隊
	Gui, Add, DropDownList, x155 y145 w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊||第二艦隊|第三艦隊|第四艦隊|第五艦隊|
else if ChooseParty1=第二艦隊
	Gui, Add, DropDownList, x155 y145 w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊|第二艦隊||第三艦隊|第四艦隊|第五艦隊|
else if ChooseParty1=第三艦隊
	Gui, Add, DropDownList, x155 y145 w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊||第四艦隊|第五艦隊|
else if ChooseParty1=第四艦隊
	Gui, Add, DropDownList, x155 y145 w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊||第五艦隊|
else if ChooseParty1=第五艦隊
	Gui, Add, DropDownList, x155 y145 w90 h150 vChooseParty1 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊|第五艦隊||
Gui, Add, text, x265 y150 w75 h20  , 第二艦隊：
iniread, ChooseParty2, settings.ini, Battle, ChooseParty2, 不使用
if ChooseParty2=不使用
	Gui, Add, DropDownList, x340 y145 w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊|第五艦隊|不使用||
else if ChooseParty2=第一艦隊
	Gui, Add, DropDownList, x340 y145 w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊||第二艦隊|第三艦隊|第四艦隊|第五艦隊|不使用|
else if ChooseParty2=第二艦隊
	Gui, Add, DropDownList, x340 y145 w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊||第三艦隊|第四艦隊|第五艦隊|不使用|
else if ChooseParty2=第三艦隊
	Gui, Add, DropDownList, x340 y145 w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊||第四艦隊|第五艦隊|不使用|
else if ChooseParty2=第四艦隊
	Gui, Add, DropDownList, x340 y145 w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊||第五艦隊|不使用|
else if ChooseParty2=第五艦隊
	Gui, Add, DropDownList, x340 y145 w90 h150 vChooseParty2 gAnchorsettings, 第一艦隊|第二艦隊|第三艦隊|第四艦隊|第五艦隊||不使用|

Gui, Add, text, x30 y180 w80 h20  , 受到伏擊：
iniread, Assault, settings.ini, Battle, Assault, 規避
if Assault=規避
	Gui, Add, DropDownList, x110 y175 w60 h100 vAssault gAnchorsettings, 規避||迎擊|
else if Assault=迎擊
	Gui, Add, DropDownList, x110 y175 w60 h100 vAssault gAnchorsettings, 規避|迎擊||

Gui, Add, text, x30 y210 w80 h20  , 自律模式：
iniread, Autobattle, settings.ini, Battle, Autobattle, 自動
if Autobattle=自動
	Gui, Add, DropDownList, x110 y205 w80 h100 vAutobattle gAnchorsettings, 自動||半自動|關閉|
else if Autobattle=半自動
	Gui, Add, DropDownList, x110 y205 w80 h100 vAutobattle gAnchorsettings, 自動|半自動||關閉|
else if Autobattle=關閉
	Gui, Add, DropDownList, x110 y205 w80 h100 vAutobattle gAnchorsettings, 自動|半自動|關閉||

Gui, Add, text, x30 y240 w80 h20  , 遇到BOSS：
iniread, BossAction, settings.ini, Battle, BossAction, 隨緣攻擊－當前隊伍
if BossAction=隨緣攻擊－當前隊伍
	Gui, Add, DropDownList, x110 y235 w150 h100 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍||隨緣攻擊－切換隊伍|優先攻擊－當前隊伍|優先攻擊－切換隊伍|能不攻擊就不攻擊
else if BossAction=隨緣攻擊－切換隊伍
	Gui, Add, DropDownList, x110 y235 w150 h100 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍|隨緣攻擊－切換隊伍||優先攻擊－當前隊伍|優先攻擊－切換隊伍|能不攻擊就不攻擊
else if BossAction=優先攻擊－當前隊伍
	Gui, Add, DropDownList, x110 y235 w150 h100 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍|隨緣攻擊－切換隊伍|優先攻擊－當前隊伍||優先攻擊－切換隊伍|能不攻擊就不攻擊
else if BossAction=優先攻擊－切換隊伍
	Gui, Add, DropDownList, x110 y235 w150 h100 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍|隨緣攻擊－切換隊伍|優先攻擊－當前隊伍|優先攻擊－切換隊伍||能不攻擊就不攻擊
else if BossAction=能不攻擊就不攻擊
	Gui, Add, DropDownList, x110 y235 w150 h100 vBossAction gAnchorsettings, 隨緣攻擊－當前隊伍|隨緣攻擊－切換隊伍|優先攻擊－當前隊伍|優先攻擊－切換隊伍|能不攻擊就不攻擊||

Gui, Add, text, x30 y270 w140 h20  , 心情低落：
iniread, mood, settings.ini, Battle, mood, 強制出戰
if mood=強制出戰
	Gui, Add, DropDownList, x110 y265  h150 vmood gAnchorsettings, 強制出戰||更換隊伍|休息1小時|休息2小時休息3小時|休息5小時|
else if mood=更換隊伍
	Gui, Add, DropDownList, x110 y265 w90 h150 vmood gAnchorsettings, 強制出戰|更換隊伍||休息1小時|休息2小時|休息3小時|休息5小時|
else if mood=休息1小時
	Gui, Add, DropDownList, x110 y265 w90 h150 vmood gAnchorsettings, 強制出戰|更換隊伍|休息1小時||休息2小時|休息3小時|休息5小時|
else if mood=休息2小時
	Gui, Add, DropDownList, x110 y265 w90 h150 vmood gAnchorsettings, 強制出戰|更換隊伍|休息1小時|休息2小時||休息3小時|休息5小時|
else if mood=休息3小時
	Gui, Add, DropDownList, x110 y265 w90 h150 vmood gAnchorsettings, 強制出戰|更換隊伍|休息1小時|休息2小時|休息3小時||休息5小時|
else if mood=休息5小時
	Gui, Add, DropDownList, x110 y265 w90 h150 vmood gAnchorsettings, 強制出戰|更換隊伍|休息1小時|休息2小時|休息3小時|休息5小時||


;~ Gui, Add, text, x50 y420 w140 h20  , 

Gui, Tab, 出擊２
Gui, Add, text, x30 y90 w360 h20  +cFF0088, 本頁為出擊頁面的詳細設定，需勾選自動出擊方有效果

Gui, Add, text, x30 y120 w150 h20  , 船䲧已滿：
iniread, Shipsfull, settings.ini, Battle, Shipsfull, 整理
if Shipsfull=整理
	Gui, Add, DropDownList, x110 y115 w100 h100 vShipsfull gAnchorsettings, 整理船䲧||停止出擊|關閉遊戲|
else if Shipsfull=停止出擊
	Gui, Add, DropDownList, x110 y115 w100 h100 vShipsfull gAnchorsettings, 整理船䲧|停止出擊||關閉遊戲|
else if Shipsfull=關閉遊戲
	Gui, Add, DropDownList, x110 y115 w100 h100 vShipsfull gAnchorsettings, 整理船䲧|停止出擊|關閉遊戲||
else
	Gui, Add, DropDownList, x110 y115 w100 h100 vShipsfull gAnchorsettings, 整理船䲧||停止出擊|關閉遊戲|

Gui, Add, text, x220 y120 w180 h20  , 如整理，要退役的角色：
iniread, IndexAll, settings.ini, Battle, IndexAll, 1 ;全部
iniread, Index1, settings.ini, Battle, Index1 ;前排先鋒
iniread, Index2, settings.ini, Battle, Index2 ;後排主力
iniread, Index3, settings.ini, Battle, Index3 ;驅逐
iniread, Index4, settings.ini, Battle, Index4 ;輕巡
iniread, Index5, settings.ini, Battle, Index5 ;重巡
iniread, Index6, settings.ini, Battle, Index6 ;戰列
iniread, Index7, settings.ini, Battle, Index7 ;航母
iniread, Index8, settings.ini, Battle, Index8 ;維修
iniread, Index9, settings.ini, Battle, Index9 ;其他
Gui, Add, text, x30 y150 w50 h20  , 索　引
Gui, Add, CheckBox, x80 y147 w50 h20 gAnchorsettings vIndexAll checked%IndexAll% , 全部
Guicontrol, disable, IndexAll
Gui, Add, CheckBox, x130 y147 w80 h20 gAnchorsettings vIndex1 checked%Index1% , 前排先鋒
Gui, Add, CheckBox, x210 y147 w80 h20 gAnchorsettings vIndex2 checked%Index2% , 後排主力
Gui, Add, CheckBox, x290 y147 w50 h20 gAnchorsettings vIndex3 checked%Index3% , 驅逐
Gui, Add, CheckBox, x340 y147 w50 h20 gAnchorsettings vIndex4 checked%Index4% , 輕巡
Gui, Add, CheckBox, x390 y147 w50 h20 gAnchorsettings vIndex5 checked%Index5% , 重巡
Gui, Add, CheckBox, x80 y177 w50 h20 gAnchorsettings vIndex6 checked%Index6% , 戰列
Gui, Add, CheckBox, x130 y177 w50 h20 gAnchorsettings vIndex7 checked%Index7% , 航母
Gui, Add, CheckBox, x180 y177 w50 h20 gAnchorsettings vIndex8 checked%Index8% , 維修
Gui, Add, CheckBox, x230 y177 w50 h20 gAnchorsettings vIndex9 checked%Index9% , 其他

iniread, CampAll, settings.ini, Battle, CampAll, 1 ;全部
iniread, Camp1, settings.ini, Battle, Camp1 ;白鷹
iniread, Camp2, settings.ini, Battle, Camp2 ;皇家
iniread, Camp3, settings.ini, Battle, Camp3 ;重櫻
iniread, Camp4, settings.ini, Battle, Camp4 ;鐵血
iniread, Camp5, settings.ini, Battle, Camp5 ;東煌
iniread, Camp6, settings.ini, Battle, Camp6 ;北方聯合
iniread, Camp7, settings.ini, Battle, Camp7 ;其他
Gui, Add, text, x30 y210 w50 h20  , 陣　營
Gui, Add, CheckBox, x80 y208 w50 h20 gAnchorsettings vCampAll checked%CampAll% , 全部
Guicontrol, disable, CampAll
Gui, Add, CheckBox, x130 y208 w50 h20 gAnchorsettings vCamp1 checked%Camp1% , 白鷹
Gui, Add, CheckBox, x180 y208 w50 h20 gAnchorsettings vCamp2 checked%Camp2% , 皇家
Gui, Add, CheckBox, x230 y208 w50 h20 gAnchorsettings vCamp3 checked%Camp3% , 重櫻
Gui, Add, CheckBox, x280 y208 w50 h20 gAnchorsettings vCamp4 checked%Camp4% , 鐵血
Gui, Add, CheckBox, x330 y208 w50 h20 gAnchorsettings vCamp5 checked%Camp5% , 東煌
Gui, Add, CheckBox, x80 y228 w80 h20 gAnchorsettings vCamp6 checked%Camp6% , 北方聯合
Gui, Add, CheckBox, x160 y228 w50 h20 gAnchorsettings vCamp7 checked%Camp7% , 其他

iniread, RarityAll, settings.ini, Battle, RarityAll, 1 ;全部
iniread, Rarity1, settings.ini, Battle, Rarity1 ;普通
iniread, Rarity2, settings.ini, Battle, Rarity2 ;稀有
iniread, Rarity3, settings.ini, Battle, Rarity3 ;精銳
iniread, Rarity4, settings.ini, Battle, Rarity4 ;超稀有
Gui, Add, text, x30 y260 w75 h20  , 稀有度：
Gui, Add, CheckBox, x80 y258 w50 h20 gAnchorsettings vRarityAll checked%RarityAll% , 全部
Guicontrol, disable, RarityAll
Gui, Add, CheckBox, x130 y258 w50 h20 gAnchorsettings vRarity1 checked%Rarity1% , 普通
Gui, Add, CheckBox, x180 y258 w50 h20 gAnchorsettings vRarity2 checked%Rarity2% , 稀有
Gui, Add, CheckBox, x230 y258 w50 h20 gAnchorsettings vRarity3 checked%Rarity3% , 精銳
Gui, Add, CheckBox, x280 y258 w75 h20 gAnchorsettings vRarity4 checked%Rarity4% , 超稀有

Gui, Tab, 學　院
iniread, AcademySub, settings.ini, Academy, AcademySub
Gui, Add, CheckBox, x30 y90 w150 h20 gAcademysettings vAcademySub checked%AcademySub% +c4400FF, 啟動自動學院
iniread, AcademyOil, settings.ini, Academy, AcademyOil, 1
Gui, Add, CheckBox, x30 y120 w150 h20 gAcademysettings vAcademyOil checked%AcademyOil%, 自動採集石油
iniread, AcademyCoin, settings.ini, Academy, AcademyCoin, 1
Gui, Add, CheckBox, x30 y150 w150 h20 gAcademysettings vAcademyCoin checked%AcademyCoin%, 自動蒐集金幣
iniread, AcademyTactics, settings.ini, Academy, AcademyTactics, 1
Gui, Add, CheckBox, x30 y180 w150 h20 gAcademysettings vAcademyTactics checked%AcademyTactics%, 自動學習技能
iniread, AcademyShop, settings.ini, Academy, AcademyShop, 1
Gui, Add, CheckBox, x30 y210 w200 h20 gAcademysettings vAcademyShop checked%AcademyShop%, 商店特價時進入但不購物

Gui, Tab, 後　宅
iniread, DormSub, settings.ini, Dorm, DormSub
Gui, Add, CheckBox, x30 y90 w150 h20 gDormsettings vDormSub checked%DormSub% +c4400FF, 啟動自動整理後宅
iniread, DormCoin, settings.ini, Dorm, DormCoin, 1
Gui, Add, CheckBox, x30 y120 w150 h20 gDormsettings vDormCoin checked%DormCoin%, 自動蒐集傢俱幣
iniread, Dormheart, settings.ini, Dorm, Dormheart, 1
Gui, Add, CheckBox, x30 y150 w150 h20 gDormsettings vDormheart checked%Dormheart%, 自動撈取海洋之心

iniread, DormFood, settings.ini, Dorm, DormFood
Gui, Add, CheckBox, x30 y180 w80 h20 gDormsettings vDormFood checked%DormFood%, 糧食低於
IniRead, DormFoodBar, settings.ini, Dorm, DormFoodBar, 80
Gui, Add, Slider, x110 y178 w100 h30 gDormsettings vDormFoodBar range10-80 +ToolTip , %DormFoodBar%
Gui, Add, Text, x215 y180 w20 h20 vDormFoodBarUpdate , %DormFoodBarUpdate% 
Gui, Add, Text, x240 y180 w100 h20 vTestbar1Percent, `%自動補給

Gui, Tab, 任　務
iniread, MissionSub, settings.ini, MissionSub, MissionSub
Gui, Add, CheckBox, x30 y90 w150 h20 gMissionsettings vMissionSub checked%MissionSub% +c4400FF, 啟動自動接收任務

Gui, Tab, 其　他
Gui, Add, button, x30 y90 w120 h20 gDebug2, 除錯
Gui, Add, button, x30 y120 w120 h20 gDailyGoalSub, 執行每日任務
Gui, Add, button, x30 y150 w120 h20 g演習SUB, 執行演習
Gui, Add, button, x30 y180 w120 h20 gstartemulatorsub, 啟動模擬器

;///////////////////     GUI Right Side  End ///////////////////
Gui Show, w900 h500 x0 y0 , Azur Lane 
#include Gdip.dll
pToken := Gdip_Startup()　
Winget, UniqueID,, %title%
Allowance = %AllowanceValue%
Global UniqueID
Global Allowance
LogShow("啟動完畢，等待開始")
Gosub, whitealbum
Settimer, whitealbum, 10000 ;很重要!
goto, TabFunc
return

Debug2:
text1 := GdiGetPixel(12, 24)
text2 := DwmGetPixel(12, 24)
text3 := GdiGetPixel(1300, 681)
text4 := DwmGetPixel(1300, 681)
text5 := GdiGetPixel(485, 21)
text6 := DwmGetPixel(485, 21)
text11 := Dwmcheckcolor(1300, 681, 16777215)
text22 := Dwmcheckcolor(12, 24, 16041247)
text33 := Dwmcheckcolor(1, 1, 2633790)
WinGet, UniqueID, ,Azur Lane
Global UniqueID 
gui, Color, FF0000
sleep 100
Red := DwmGetPixel(336, 456)
sleep 200
gui, Color, 00FF00
sleep 100
Green := DwmGetPixel(336, 456)
sleep 200
gui, Color, 0000FF
sleep 100
Blue :=  DwmGetPixel(336, 456)
sleep 200
gui, Color, FFFFFF
sleep 100
White := DwmGetPixel(336, 456)
sleep 200
gui, Color, 000000
sleep 100
Black := DwmGetPixel(336, 456)
sleep 200
gui, Color, Default
Msgbox, Red: %Red% `nGreen:%Green%`nBlue: %Blue%`nWhite: %White%`nBlack:%Black%`n`nGdiGetPixel(211, 17)：%text1% and 4294231327`nDwmGetPixel(211, 17)：%text2% and %text22%`nGdiGetPixel(1300, 681)：%text3% and 4294967295`nDwmGetPixel(1300, 681)：%text4% and %text11%`nGdiGetPixel(485, 21)：%text5% and 4280823870`nDwmGetPixel(485, 21)：%text6% and %text33%
Winget, UniqueID,, %title%
Global UniqueID
return

stop:
reload
return

TabFunc: ;切換分頁讀取GUI設定，否則可能導致選項失效
gosub, inisettings
gosub, Anchorsettings
gosub, Academysettings
gosub, Dormsettings
gosub, Missionsettings
gosub, Othersettings
return

inisettings: ;一般設定
Guicontrolget, title
Guicontrolget, emulatoradb
Guicontrolget, AllowanceValue
Iniwrite, %emulatoradb%, settings.ini, emulator, emulatoradb
Iniwrite, %title%, settings.ini, emulator, title
Iniwrite, %AllowanceValue%, settings.ini, emulator, AllowanceValue
return

Anchorsettings: ;出擊設定
Guicontrolget, AnchorSub
Guicontrolget, AnchorMode
Guicontrolget, AnchorChapter 
Guicontrolget, AnchorChapter2
Guicontrolget, Assault
Guicontrolget, mood
Guicontrolget, moodtime
Guicontrolget, Autobattle
Guicontrolget, BossAction
Guicontrolget, Shipsfull
Guicontrolget, ChooseParty1
Guicontrolget, ChooseParty2
Iniwrite, %AnchorSub%, settings.ini, Battle, AnchorSub
Iniwrite, %AnchorMode%, settings.ini, Battle, AnchorMode
Iniwrite, %AnchorChapter%, settings.ini, Battle, AnchorChapter
Iniwrite, %AnchorChapter2%, settings.ini, Battle, AnchorChapter2
Iniwrite, %Assault%, settings.ini, Battle, Assault
Iniwrite, %mood%, settings.ini, Battle, mood
Iniwrite, %moodtime%, settings.ini, Battle, moodtime
Iniwrite, %Autobattle%, settings.ini, Battle, Autobattle
Iniwrite, %BossAction%, settings.ini, Battle, BossAction
Iniwrite, %Shipsfull%, settings.ini, Battle, Shipsfull
Iniwrite, %ChooseParty1%, settings.ini, Battle, ChooseParty1
Iniwrite, %ChooseParty2%, settings.ini, Battle, ChooseParty2
Global Assault, Autobattle, shipsfull, ChooseParty1, ChooseParty2

;////出擊2///////
Guicontrolget, IndexAll
Guicontrolget, Index1
Guicontrolget, Index2
Guicontrolget, Index3
Guicontrolget, Index4
Guicontrolget, Index5
Guicontrolget, Index6
Guicontrolget, Index7
Guicontrolget, Index8
Guicontrolget, Index9
Guicontrolget, CampAll
Guicontrolget, Camp1
Guicontrolget, Camp2
Guicontrolget, Camp3
Guicontrolget, Camp4
Guicontrolget, Camp5
Guicontrolget, Camp6
Guicontrolget, Camp7
Guicontrolget, RarityAll
Guicontrolget, Rarity1
Guicontrolget, Rarity2
Guicontrolget, Rarity3
Guicontrolget, Rarity4
Iniwrite, %IndexAll%, settings.ini, Battle, IndexAll ;全部
Iniwrite, %Index1%, settings.ini, Battle, Index1 ;前排先鋒
Iniwrite, %Index2%, settings.ini, Battle, Index2 ;後排主力
Iniwrite, %Index3%, settings.ini, Battle, Index3 ;驅逐
Iniwrite, %Index4%, settings.ini, Battle, Index4 ;輕巡
Iniwrite, %Index5%, settings.ini, Battle, Index5 ;重巡
Iniwrite, %Index6%, settings.ini, Battle, Index6 ;戰列
Iniwrite, %Index7%, settings.ini, Battle, Index7 ;航母
Iniwrite, %Index8%, settings.ini, Battle, Index8 ;維修
Iniwrite, %Index9%, settings.ini, Battle, Index9 ;其他
Iniwrite, %CampAll%, settings.ini, Battle, CampAll ;全部
Iniwrite, %Camp1%, settings.ini, Battle, Camp1 ;白鷹
Iniwrite, %Camp2%, settings.ini, Battle, Camp2 ;皇家
Iniwrite, %Camp3%, settings.ini, Battle, Camp3 ;重櫻
Iniwrite, %Camp4%, settings.ini, Battle, Camp4 ;鐵血
Iniwrite, %Camp5%, settings.ini, Battle, Camp5 ;東煌
Iniwrite, %Camp6%, settings.ini, Battle, Camp6 ;北方聯合
Iniwrite, %Camp7%, settings.ini, Battle, Camp7 ;其他
Iniwrite, %RarityAll%, settings.ini, Battle, RarityAll ;全部
Iniwrite, %Rarity1%, settings.ini, Battle, Rarity1 ;普通
Iniwrite, %Rarity2%, settings.ini, Battle, Rarity2 ;稀有
Iniwrite, %Rarity3%, settings.ini, Battle, Rarity3 ;精銳
Iniwrite, %Rarity4%, settings.ini, Battle, Rarity4 ;超稀有
Global IndexAll, Index1, Index2, Index3, Index4, Index5, Index6, Index7, Index8, Index9, CampAll, Camp1,Camp2, Camp3, Camp4, Camp5, Camp6, Camp7, Camp8, Camp9, RarityAll, Rarity1, Rarity2, Rarity3, Rarity4
return

Academysettings: ;學院設定
Guicontrolget, AcademySub
Guicontrolget, AcademyOil
Guicontrolget, AcademyCoin
Guicontrolget, AcademyTactics
Guicontrolget, AcademyShop
Iniwrite, %AcademySub%, settings.ini, Academy, AcademySub
Iniwrite, %AcademyOil%, settings.ini, Academy, AcademyOil
Iniwrite, %AcademyCoin%, settings.ini, Academy, AcademyCoin
Iniwrite, %AcademyShop%, settings.ini, Academy, AcademyShop
Iniwrite, %AcademyTactics%, settings.ini, Academy, AcademyTactics
return

Dormsettings: ;後宅設定
Guicontrolget, DormSub
Guicontrolget, DormCoin
Guicontrolget, Dormheart
Guicontrolget, DormFood
Guicontrolget, DormFoodBar
Iniwrite, %DormSub%, settings.ini, Dorm, DormSub
Iniwrite, %DormCoin%, settings.ini, Dorm, DormCoin
Iniwrite, %Dormheart%, settings.ini, Dorm, Dormheart
Iniwrite, %DormFood%, settings.ini, Dorm, DormFood
Iniwrite, %DormFoodBar%, settings.ini, Dorm, DormFoodBar
Guicontrol, ,DormFoodBarUpdate, %DormFoodBar%
Global DormFood
return

Missionsettings: ;任務設定
Guicontrolget, MissionSub
Iniwrite, %MissionSub%, settings.ini, MissionSub, MissionSub
return

Othersettings: ;其他設定
return

exitsub:
exitapp
return

Showsub:
Gui, show
return

GuiClose:
ExitApp
return

guicontrols:
Guicontrol, disable, Start
Guicontrol, disable, title
Guicontrol, disable, emulatoradb
return

Start:
gosub, TabFunc
gosub, guicontrols
Winget, UniqueID,, %title%
Allowance = %AllowanceValue%
emulatoradb = %emulatoradb%
Global UniqueID
Global Allowance
Global emulatoradb
LogShow("開始！")
WinRestore,  %title%
WinMove,  %title%, , , , 1318, 758
WinSet, Transparent, off, %title%
Settimer, Mainsub, 2500
;~ Settimer, WinSub, 5000
return

Mainsub: ;優先檢查出擊以外的其他功能
WinGet, Wincheck, MinMax, %title%
if Wincheck=-1
{
	LogShow("視窗被縮小，等待自動恢復")
	WinSet, Transparent, 0, %title%
	sleep 200
	WinRestore, %title%
	sleep 200
	WinSet, Transparent, off, %title%
}
else if Wincheck=1
{
	WinRestore, %title%
	LogShow("視窗被放大，等待自動恢復")
}
else if Wincheck=0
{
	Formation := DwmCheckcolor(895, 415, 16777215) ;編隊BTN
	WeighAnchor := DwmCheckcolor(1035, 345, 16777215) ;出擊BTN
	MissionCheck := DwmCheckcolor(943, 711, 11883842)
	AcademyCheck := DwmCheckcolor(627, 712, 11882818) ;學院驚嘆號
	DormMissionCheck := DwmCheckcolor(784, 712, 11883842) ;後宅驚嘆號
	MainCheck := DwmCheckcolor(13, 201, 16777215) ;主選單圖示
	LDtitlebar := DwmCheckcolor(1, 1, 2633790) ;
	if (MissionSub and MissionCheck and MainCheck and Formation and WeighAnchor and LDtitlebar) ;任務
	{
		gosub, MissionSub
	}
	sleep 100
	if (AcademySub and AcademyCheck and MainCheck and Formation and WeighAnchor and LDtitlebar and AcademyDone<1) ;學院
	{
		gosub, AcademySub
	}
	sleep 100
	if (DormSub and DormMissionCheck and MainCheck and Formation and WeighAnchor and LDtitlebar and DormDone<1)  ;後宅
	{
		gosub, DormSub
	}
	sleep 100
	if ((AnchorSub and LDtitlebar) and (!AcademyCheck or AcademyDone=1 or !AcademySub) and (!DormMissionCheck or DormDone=1 or !DormSub))  ;出擊
	{
		gosub, AnchorSub
	}
}
return

clock:
StopAnchor := 0
return

AnchorSub: ;出擊
if (DwmCheckcolor(63, 173, 16774127) and DwmCheckcolor(1140, 335, 14577994)) ;在主選單偵測到軍事任務已完成
{
	LogShow("執行軍事委託")
	C_Click(20, 200)
	sleep 1000
	Loop
	{
		GetItem := GetItem()
		GetItem2 := GetItem2()
		if (DwmCheckcolor(495, 321, 15704642)) ;出現選單
		{
			C_Click(457, 313) ;點擊軍事委託完成
		}
		else if (DwmCheckcolor(1226, 74, 16777215) or DwmCheckcolor(1215, 76, 16777215)) ;委託成功
		{
			C_Click(639, 141) ;隨便點
		}
		else if GetItem or GetItem2
		{
		}
		else if (DwmCheckcolor(461, 316, 16777215) and DwmCheckcolor(432, 321, 16777215))
		{
			sleep 2500
			if (DwmCheckcolor(461, 316, 16777215) and DwmCheckcolor(432, 321, 16777215))
			{
				Rmenu := 1
				break
			}
		}
	}
	if (Rmenu=1)
	{
		C_Click(457, 313)
		sleep 1500
		DelegationMission()
		Loop, 5
		{
			if DwmCheckcolor(109, 172, 4876692)
			{
				C_Click(1246, 89)
				sleep 2000
			}
			sleep 300
		}
	}
	else
	{
		Loop, 5
		{
			if DwmCheckcolor(109, 172, 4876692)
			{
				C_Click(1246, 89)
				sleep 2000
			}
			sleep 300
		}
	}
}	
AnchorCheck := DwmCheckcolor(1036, 346, 16777215)
AnchorCheck2 := DwmCheckcolor(1096, 331, 16769924)
MainCheck := DwmCheckcolor(13, 201, 16777215) ;主選單圖示
if (AnchorCheck and AnchorCheck2 and MainCheck and StopAnchor!=1)
{
	C_Click(1066,404)
}
if (DwmCheckcolor(1234, 649, 16777215) and DwmCheckcolor(1109, 605, 3224625) and  DwmCheckcolor(31, 621, 16777215)) ;右下出擊
{
	sleep 300
    if (DwmCheckcolor(773, 155, 15695211) and Autobattle="自動") ;Auto Battle >> ON
    {
		LogShow("開啟自律模式")
        C_Click(819, 160)
    }
	else if (DwmCheckcolor(779, 153, 574331) and Autobattle="半自動")
	{
		LogShow("開啟半自動模式")
		C_Click(819, 160)
	}
	else if (DwmCheckcolor(779, 153, 574331) and Autobattle="關閉")
	{
		LogShow("關閉自律模式")
		C_Click(819, 160)
	}
		
	LogShow("出擊～！")
    C_Click(1210, 664)
	shipsfull(StopAnchor)
    TargetFailed := 0
    TargetFailed2 := 0
    TargetFailed3 := 0
    TargetFailed4 := 0
    TargetFailed5 := 0
    TargetFailed6 := 0
    BossFailed := 0
    BulletFailed := 0
    QuestFailed := 0
	SearchLoopcount := 0
	SearchLoopcountFailed2 := 0
    if (GdiGetPixel(743, 541)=4282544557) ;心情低落
    {
		if mood=強制出戰
		{
			LogShow("老婆心情低落：提督SAMA沒人性")
			C_Click(790, 546)
		}
		else if mood=更換隊伍
		{
			LogShow("老婆心情低落，但更換隊伍未完成，強制休息")
			takeabreak := 600
			C_Click(483, 544)
			sleep 2000
			C_Click(59, 88)
			sleep 3000
			C_Click(1227, 67)
			StopAnchor := 1
			settimer, clock, -3600000
			reload
		}
		else if mood=休息1小時
		{
			LogShow("老婆心情低落：休息1小時")
			takeabreak := 600
			C_Click(483, 544)
			sleep 2000
			C_Click(59, 88)
			sleep 3000
			C_Click(1227, 67)
			StopAnchor := 1
			settimer, clock,  -3600000
		}
		else if mood=休息2小時
		{
			LogShow("老婆心情低落：休息2小時")
			takeabreak := 600
			C_Click(483, 544)
			sleep 2000
			C_Click(59, 88)
			sleep 3000
			C_Click(1227, 67)
			StopAnchor := 1
			settimer, clock, -7200000
		}
		else if mood=休息3小時
		{
			LogShow("老婆心情低落：休息3小時")
			takeabreak := 600
			C_Click(483, 544)
			sleep 2000
			C_Click(59, 88)
			sleep 3000
			C_Click(1227, 67)
			StopAnchor := 1
			settimer, clock, -10800000
		}
		else if mood=休息5小時
		{
			LogShow("老婆心情低落：休息5小時")
			takeabreak := 600
			C_Click(483, 544)
			sleep 2000
			C_Click(59, 88)
			sleep 3000
			C_Click(1227, 67)
			StopAnchor := 1
			settimer, clock, -14400000
		}
		else
		{
			msgbox get sometihng bad
		}
    }
    else if (DwmGetPixel(543, 361)=15724527) ;石油不足
    {
        LogShow("石油不足，停止出擊到永遠！")
        C_Click(1230, 74)
		StopAnchor := 1
    }
    Loop, 15
    {
        sleep 1000
    } until GdiGetPixel(1226, 81)=4294439927 and GdiGetPixel(1242, 81)=4294439927 
    
}
gosub BtnCheck
if (Withdraw and Switchover )
{
    LogShow("偵查中。")
	sleep 2000
    Loop
    {
		MapX1 := 100, MapY1 := 100, MapX2 :=1270, MapY2 :=650 ; //////////檢查敵方艦隊的範圍////////// MapX1, MapY1 always be 0 or 100 
		Mainfleet := 4287894561 ; ARGB 主力艦隊
		FinalBoss := 4287895576 ; ARGB BOSS艦隊
        if (GdipImageSearch2(x, y, "img/bullet.png", 100, 8, MapX1, MapY1, MapX2, MapY2) and bulletFailed<1 and SearchLoopcount>=1) ;
        {
            LogShow("嗶嗶嚕嗶～發現：子彈補給！")
			xx := x
            yy := y + 80
            C_Click(xx, yy)
			C_Click(xx, yy)
            if (DwmCheckcolor(516, 357, 16250871))  
            {
                bulletFailed++
				return
            }
			bulletFailed++ ;只找一次 直到進入戰鬥 避免遇到空襲一直前往子彈點 (第一輪不找)
            sleep 3050
        }
		else if (GdipImageSearch2(x, y, "img/quest.png", 100, 8, MapX1, MapY1, MapX2, MapY2) and questFailed<1) ;
        {
            LogShow("嗶嗶嚕嗶～發現：神秘物資！")
            xx := x
            yy := y + 70
            C_Click(xx, yy)
			C_Click(xx, yy)
            if (DwmCheckcolor(516, 357, 16250871)) 
            {
                questFailed++
				return
            }
            sleep 3050
        }
		else if (Gdip_PixelSearch2( x,  y, MapX1, MapY1, MapX2, MapY2, FinalBoss, 0) and BossFailed<1) and (Bossaction="優先攻擊－當前隊伍" or Bossaction="優先攻擊－切換隊伍") ;ＢＯＳＳ
        {
			if Bossaction=優先攻擊－當前隊伍
			{
				LogShow("嗶嗶嚕嗶～優先攻擊最終BOSS！")
				xx := x 
				yy := y 
				TargetFailed := 1
				TargetFailed2 := 1
				TargetFailed3 := 1
				TargetFailed4 := 1
				C_Click(xx, yy)
				C_Click(xx, yy)
			}
			else if Bossaction=優先攻擊－切換隊伍
			{
				xx := x 
				yy := y 
				if (SwitchParty<1)
				{
				LogShow("嗶嗶嚕嗶～切換隊伍並重新搜尋最終BOSS！")
				SwitchParty := 1
				TargetFailed := 1
				TargetFailed2 := 1
				TargetFailed3 := 1
				TargetFailed4 := 1
				C_Click(1035, 706)
				}
				else
				{
				C_Click(xx, yy)
				C_Click(xx, yy)
				}
			}
			else
			{
				msgbox, 優先攻擊－當前隊伍 or 優先攻擊－切換隊伍 發生錯誤
			}
			if (DwmCheckcolor(516, 357, 16250871)) 
			{
				BossFailed++
				LogShow("哎呀哎呀，前往BOSS的路徑被擋住了！")
				TargetFailed := 0
				TargetFailed2 := 0
				TargetFailed3 := 0
				TargetFailed4 := 0
				return
			}
			sleep 3050
			BackAttack()
			if !(DwmCheckcolor(1234, 651,16777215) and DwmCheckcolor(1076, 653,16777215) and BossFailed<1) ; 如果沒有成功進入戰鬥，再試一次
            {
                C_Click(xx, yy)
				sleep 3000
            }
        }
		else if ((GdipImageSearch2(x, y, "img/target2_1.png", 100, 8, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target2_2.png", 100, 8, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target2_3.png", 100, 8, MapX1, MapY1, MapX2, MapY2)) and TargetFailed2<1) ;
        {
            LogShow("嗶嗶嚕嗶～發現：運輸艦隊！")
            xx := x 
            yy := y 
            C_Click(xx, yy)
			C_Click(xx, yy)
            if (DwmCheckcolor(516, 357, 16250871))  ;16250871
            {
                TargetFailed2++
				return
            }
            sleep 3050
			BackAttack()
			if !(DwmCheckcolor(1234, 651,16777215) and DwmCheckcolor(1076, 653,16777215) and TargetFailed2<1) ; 如果沒有成功進入戰鬥，再試一次
            {
                C_Click(xx, yy)
				sleep 3000
            }
        }
		else if ((GdipImageSearch2(x, y, "img/target_1.png", 100, 8, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target_2.png", 100, 8, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target_3.png", 100, 8, MapX1, MapY1, MapX2, MapY2)) and TargetFailed<1) ;
        {
            LogShow("嗶嗶嚕嗶～發現：航空艦隊！")
            xx := x 
            yy := y 
            C_Click(xx, yy)
			C_Click(xx, yy)
            if (DwmCheckcolor(516, 357, 16250871))  ;16250871
            {
                TargetFailed++
				return
            }
            sleep 3050
			BackAttack()
			if !(DwmCheckcolor(1234, 651,16777215) and DwmCheckcolor(1076, 653,16777215) and TargetFailed<1) ; 如果沒有成功進入戰鬥，再試一次
            {
                C_Click(xx, yy)
				sleep 3000
            }
        }
		else if (Gdip_PixelSearch2( x,  y, MapX1, MapY1, MapX2, MapY2, Mainfleet, 0) and TargetFailed3<1) 
        {
            LogShow("嗶嗶嚕嗶～發現：主力艦隊！")
            xx := x
            yy := y 
            C_Click(xx, yy)
			C_Click(xx, yy)
            if (DwmCheckcolor(516, 357, 16250871))  ;16250871
            {
                TargetFailed3++
				return
            }
            sleep 3050
			BackAttack()
			if !(DwmCheckcolor(1234, 651,16777215) and DwmCheckcolor(1076, 653,16777215) and TargetFailed3<1) ; 如果沒有成功進入戰鬥，再試一次
            {
                C_Click(xx, yy)
				sleep 3000
            }
        }
		else if ((GdipImageSearch2(x, y, "img/target4_1.png", 100, 8, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target4_2.png", 80, 8, MapX1, MapY1, MapX2, MapY2) or GdipImageSearch2(x, y, "img/target4_3.png", 100, 8, MapX1, MapY1, MapX2, MapY2)) and TargetFailed4<1) 
        {
            LogShow("嗶嗶嚕嗶～發現：偵查艦隊！")
            xx := x
            yy := y
            C_Click(xx, yy)
			C_Click(xx, yy)
            if (DwmCheckcolor(516, 357, 16250871))  ;16250871
            {
                TargetFailed4++
				return
            }
            sleep 3050
			BackAttack()
			if !(DwmCheckcolor(1234, 651,16777215) and DwmCheckcolor(1076, 653,16777215) and TargetFailed4<1) ; 如果沒有成功進入戰鬥，再試一次
            {
                C_Click(xx, yy)
				sleep 3000
            }
        }
		else if (Bossaction!="能不攻擊就不攻擊" or SearchLoopcount>4) and (Gdip_PixelSearch2( x,  y, MapX1, MapY1, MapX2, MapY2, FinalBoss, 0) and BossFailed<1 ) ;ＢＯＳＳ
        {
			if (SearchLoopcount>4 and ossaction="能不攻擊就不攻擊")
			{
				LogShow("已經偵查不到其他船艦，攻擊最終BOSS！")
			}
			else
			{
            LogShow("嗶嗶嚕嗶～發現最終BOSS！")
			}
            xx := x 
            yy := y 
			if (SwitchParty<1 and Bossaction="隨緣攻擊－切換隊伍")
			{
				LogShow("發現BOSS：隨緣攻擊－切換隊伍！")
				SwitchParty := 1
				C_Click(1035, 706)
			}
			else
			{
				C_Click(xx, yy)
				C_Click(xx, yy)
			}
            if (DwmCheckcolor(516, 357, 16250871)) 
            {
                BossFailed++
				return
            }
            sleep 3050
			BackAttack()
			if !(DwmCheckcolor(1234, 651,16777215) and DwmCheckcolor(1076, 653,16777215) and BossFailed<1) ; 如果沒有成功進入戰鬥，再試一次
            {
                C_Click(xx, yy)
				sleep 3000
            }
        }
		if (SearchLoopcount>1 and DwmCheckcolor(793, 711, 16777215))
        {
			LogShow("持續偵查失敗，嘗試拖曳畫面")
			if side<1
			{
				A_Swipe(652,166,652,610)  ;下
				side := 2
			}
			else if side=2
			{
				A_Swipe(652,610,652,166)  ;上
				side=3
			}
			else if side=3
			{
				A_Swipe(257,310,1040,310) ;右
				side=4
			}
			else if side=4
			{
				A_Swipe(1256,310,120,310) ;左
				side=5
			}
			else if side=5
			{
				A_Swipe(1256,310,120,310) ;左
				side=6
			}
			else if side=6
			{
				A_Swipe(200,310,1240,310) ;右
				side=0
			}
			SearchLoopcountFailed++
			SearchLoopcountFailed2++
			if (GdipImageSearch2(x, y, "img/None.png", 115, 8, MapX1, MapY1, MapX2, MapY2) and SearchLoopcountFailed>4) 
			{
				LogShow("未找到指定目標，嘗試隨機移動")
				C_Click(x, y)
				C_Click(x, y)
				SearchLoopcountFailed := 0
				sleep 2000
				if (DwmCheckcolor(793, 711, 16250871))
				{
					MoveFailed++
				}
			}
			if (SearchLoopcountFailed2>12)
			{
				LogShow("重複12次未能偵查到目標，撤退")
				SearchLoopcountFailed2 := VarSetCapacity
				C_Click(794, 714)
				sleep 500
				C_Click(781, 545)
			}
		}
	SearchLoopcount++
    gosub BtnCheck
    } until !Withdraw and !Switchover 
}
else if (Dailytask and Commission)
{
	if (DwmCheckcolor(1063, 684, 16774127)) ;委託任務已完成
	{
		LogShow("執行委託任務！")
		C_Click(1006, 712)
		DelegationMission()
		sleep 1000
		if (DwmCheckcolor(167, 64, 15201279))
		{
			C_Click(58, 92)
			sleep 1500
		}
	}
	;判斷現在位於第幾關 1 2 3 4 5 6 7 8 9 
	Chapter1 := DwmCheckcolor(202, 527, 16777215)  ;第一關
	Chapter2 := DwmCheckcolor(459, 618, 16777215) ;第二關
	Chapter3 := DwmCheckcolor(476, 292, 16777215) ;第三關
	Chapter4 := DwmCheckcolor(310, 378, 16777215) ;第四關
	Chapter5 := DwmCheckcolor(315, 438, 16777215) ;第五關
	Chapter6 := DwmCheckcolor(965, 573, 16777215) ;第六關
	Chapter7 := 0
	Chapter8 := 0
	Chapter9 := 0
	Chapter10 := 0
	Chapter11 := 0
	Chapter12 := 0
	Chapter13 := 0
	ChapterFailed := 1
	array := [Chapter1, Chapter2,Chapter3, Chapter4, Chapter5, Chapter6, Chapter7, Chapter8, Chapter9, Chapter10, Chapter11, Chapter12, Chapter13, ChapterFailed]
	Chapter := VarSetCapacity
	Loop % array.MaxIndex()
	{
		this_Chapter := array[A_Index]
		Chapter++
		if (this_Chapter=1)
		{
			break
		}
	}
	if (AnchorChapter=Chapter)
	{
		;~ LogShow("不做任何事")
	}
	else if (Chapter=14)
	{
		;~ LogShow("選擇章節時發生錯誤")
	}
	else
	{
		;~ LogShow("1111")
		ClickSide := (AnchorChapter-Chapter) ; 負數點右邊 正數點左邊
		ClickCount := abs(AnchorChapter-Chapter)
		if (ClickSide>0)
		{
			Loop, %ClickCount%
			{
			C_Click(1224,412)
			sleep 200
			}
		}
		else
		{
			Loop, %ClickCount%
			{
			C_Click(52,412)
			sleep 200
			}
		}
	}
	sleep 500
	if AnchorMode=普通
	{
		LogShow("選擇攻略地圖，難度：普通")
		if (DwmCheckcolor(58, 681, 16777215))
		{
			;不做任何事
		}
		else if (DwmCheckcolor(58, 681, 7047894))
		{
			C_Click(99,703)
			sleep 1000
			if !(DwmCheckcolor(58, 681, 16777215))
			{
				LogShow("難度選擇為普通時發生錯誤1")
			}
		}
		else 
		{
			LogShow("難度選擇為普通時發生錯誤2")
		}
	}
	else if AnchorMode=困難
	{
		LogShow("選擇攻略地圖，難度：困難")
		if (DwmCheckcolor(58, 681, 7047894))
		{
			;不做任何事
		}
		else if (DwmCheckcolor(58, 681, 16777215))
		{
			C_Click(99,703)
			sleep 1000
			if !(DwmCheckcolor(58, 681, 7047894))
			{
				Msgbox, 難度選擇為困難時發生錯誤1
				reload
			}
		}
		else 
		{
			Msgbox, 難度選擇為困難時發生錯誤2
			reload
		}
	}
	if (AnchorChapter=1 and AnchorChapter2=1) ; 選擇關卡 1-1
	{
		if (DwmCheckcolor(220, 527, 16777215))
		{
		LogShow("1-1")
		C_Click(221,526)
		}
	}
	else if (AnchorChapter=1 and AnchorChapter2=2) ; 選擇關卡 1-2
	{
		if (DwmCheckcolor(509, 341, 16777215))
		{
		LogShow("1-2")
		C_Click(510,342)
		}
	}
	else if (AnchorChapter=1 and AnchorChapter2=3) ; 選擇關卡 1-3
	{
		if (DwmCheckcolor(712, 599, 16777215))
		{
		LogShow("1-3")
		C_Click(713,600)
		}
	}
	else if (AnchorChapter=1 and AnchorChapter2=4) ; 選擇關卡 1-4
	{
		if (DwmCheckcolor(861, 246, 16777215))
		{
		LogShow("1-4")
		C_Click(862,247)
		}
	}
	else if (AnchorChapter=2 and AnchorChapter2=1) ; 選擇關卡 2-1
	{
		if (DwmCheckcolor(867, 531, 16777215))
		{
		LogShow("2-1")
		C_Click(868,530)
		}
	}
	else if (AnchorChapter=2 and AnchorChapter2=2) ; 選擇關卡 2-2
	{
		if (DwmCheckcolor(802, 261, 16777215))
		{
		LogShow("2-2")
		C_Click(803,262)
		}
	}
	else if (AnchorChapter=2 and AnchorChapter2=3) ; 選擇關卡 2-3
	{
		if (DwmCheckcolor(341, 345, 16777215))
		{
		LogShow("2-3")
		C_Click(341,346)
		}
	}
	else if (AnchorChapter=2 and AnchorChapter2=4) ; 選擇關卡 2-4
	{
		if (DwmCheckcolor(437, 619, 16777215))
		{
		LogShow("2-4")
		C_Click(438,620)
		}
	}
	else if (AnchorChapter=3 and AnchorChapter2=1) ; 選擇關卡3-1
	{
		if (DwmCheckcolor(476, 292, 16777215))
		{
		LogShow("3-1")
		C_Click(477,293)
		}
	}
	else if (AnchorChapter=3 and AnchorChapter2=2) ; 選擇關卡3-2
	{
		if (DwmCheckcolor(304, 572, 16777215))
		{
		LogShow("3-2")
		C_Click(305,573)
		}
	}
	else if (AnchorChapter=3 and AnchorChapter2=3) ; 選擇關卡3-3
	{
		if (DwmCheckcolor(866, 208, 16777215))
		{
		LogShow("3-3")
		C_Click(867,209)
		}
	}
	else if (AnchorChapter=3 and AnchorChapter2=4) ; 選擇關卡3-4
	{
		if (DwmCheckcolor(690, 432, 16777215))
		{
		LogShow("3-4")
		C_Click(691,433)
		}
	}
	else if (AnchorChapter=4 and AnchorChapter2=1) ; 選擇關卡4-1
	{
		if (DwmCheckcolor(311, 377, 16777215))
		{
		LogShow("4-1")
		C_Click(312,378)
		}
	}
	else if (AnchorChapter=4 and AnchorChapter2=2) ; 選擇關卡4-2
	{
		if (DwmCheckcolor(476, 540, 16777215))
		{
		LogShow("4-2")
		C_Click(477,541)
		}
	}
	else if (AnchorChapter=4 and AnchorChapter2=3) ; 選擇關卡4-3
	{
		if (DwmCheckcolor(878, 618, 16777215))
		{
		LogShow("4-3")
		C_Click(879,619)
		}
	}
	else if (AnchorChapter=4 and AnchorChapter2=4) ; 選擇關卡4-4
	{
		if (DwmCheckcolor(855, 360, 16777215))
		{
		LogShow("4-4")
		C_Click(856,361)
		}
	}
	else if (AnchorChapter=5 and AnchorChapter2=1) ; 選擇關卡5-1
	{
		if (DwmCheckcolor(315, 437, 16777215))
		{
		LogShow("5-1")
		C_Click(516,438)
		}
	}
	else if (AnchorChapter=5 and AnchorChapter2=2) ; 選擇關卡5-2
	{
		if (DwmCheckcolor(906, 607, 16777215))
		{
		LogShow("5-2")
		C_Click(907,608)
		}
	}
	else if (AnchorChapter=5 and AnchorChapter2=3) ; 選擇關卡5-3
	{
		if (DwmCheckcolor(788, 435, 16777215))
		{
		LogShow("5-3")
		C_Click(789,436)
		}
	}
	else if (AnchorChapter=5 and AnchorChapter2=4) ; 選擇關卡5-4
	{
		if (DwmCheckcolor(642, 284, 16777215))
		{
		LogShow("5-4")
		C_Click(623,285)
		}
	}
	else if (AnchorChapter=6 and AnchorChapter2=1) ; 選擇關卡6-1
	{
		if (DwmCheckcolor(965, 573, 16777215))
		{
		LogShow("6-1")
		C_Click(966,574)
		}
	}
	else 
	{
		LogShow("作者只通關到6-1，後面關卡無效")
		sleep 2000
		return
	}
	SwitchParty := 0 ;BOSS換隊
	;~ ChapterCheck := ("0,0,0")
	;~ ChapterCheckArray := StrSplit(ChapterCheck, ",")
	;~ msgbox % ChapterCheckArray.MaxIndex()
	;~ Loop % ChapterCheckArray.MaxIndex()
	;~ {
		;~ this_Chapter := ChapterCheckArray[A_Index]
		;~ Chapter++
		;~ if (this_Chapter=1)
		;~ {
			;~ msgbox, 目前位於：第 %Chapter% 關
			;~ Chapter := VarSetCapacity
			;~ break
		;~ }
	;~ }
	;~ LogShow("ERROR")
}
Try
{
	battlevictory()
	Battle()
	ChooseParty()
	ToMap()
	shipsfull(StopAnchor)
	BackAttack()
	Message_Story()
	Battle_End()
	UnknowWife()
	Message_Normal()
	Message_Center()
	NewWife()
	GetCard()
	GetItem2()
	GetItem()
	battlevictory()
	GuLuGuLuLu()
}
return

;~ F3::
;~ pBitmap := Gdip_BitmapFromHWND(UniqueID), Gdip_GetDimensions(pBitmap, w, h)
;~ MapX1 := 100, MapY1 := 100, MapX2 := 1235, MapY2 := 650
;~ g := Gdip_PixelSearch(pBitmap, FinalBoss,  x,  y)
;~ g := Gdip_PixelSearch2( x,  y, MapX1, MapY1, MapX2, MapY2, 4287895576, 0)
;~ tooltip x%x% y%y% g%g%
;~ g := GdipImageSearch2(x, y, "img/target4_1.png", 105, 8, 0, 0, 1280, 720) 
;~ return

BtnCheck:
    Withdraw := DwmCheckcolor(772, 706, 12996946) ; Checkcolor(772, 706, 4291187026)
    Switchover := DwmCheckcolor(1025, 697,9212581)  ;Checkcolor(1025, 697, 4287402661)
    Offensive := DwmCheckcolor(1234, 703, 16239426) ;Checkcolor(1234, 703, 4294429506)
    Dailytask := DwmCheckcolor(748, 716, 10864623)  ;Checkcolor(748, 716, 4289054703)
    Commission := DwmCheckcolor(942, 680, 8101524) ;Checkcolor(942, 680, 4286291604)
return 

演習SUB:
WinRestore,  %title%
WinMove,  %title%, , , , 1318, 758
LogShow("開始演習，請手動進入演習。")
Loop
{
	if (DwmCheckcolor(1186, 389, 16777215) and DwmCheckcolor(1122, 401, 16777215) and DwmCheckcolor(730, 692, 14085119)) ;演習介面隨機
	{
		LogShow("隨機選擇敵方部隊。")
		Random, clickpos, 1, 4
		if clickpos=1
		{
			C_Click(226, 286)
		}
		else if clickpos=2
		{
			C_Click(453, 286)
		}
		else if clickpos=3
		{
			C_Click(700, 286)
		}
		else if clickpos=4
		{
			C_Click(941, 286)
		}
	}
	else if (DwmCheckcolor(664, 231, 16777215) and DwmCheckcolor(752, 246, 16777215) and DwmCheckcolor(728, 604, 16238402)) ;演習對手訊息
	{
		C_Click(647, 608)
	}
	else if (DwmCheckcolor(1236, 651, 16777215) and DwmCheckcolor(1076, 654, 16777215) and DwmCheckcolor(1236, 665, 16239426)) ;出擊
	{
		LogShow("演習出擊。")
		C_Click(1089, 689)
		C_Click(1089, 689)
		if (DwmCheckcolor(529, 359, 16249847))
		{
			LogShow("演習結束！")
			C_Click(68, 88)
			break
		}
	}
	Try
	{
		battlevictory()
		Battle()
		ChooseParty()
		ToMap()
		shipsfull(StopAnchor)
		BackAttack()
		Message_Story()
		Battle_End()
		UnknowWife()
		Message_Normal()
		Message_Center()
		NewWife()
		GetCard()
		GetItem2()
		GetItem()
		battlevictory()
	}
	sleep 300
}
return

startemulatorSub:
run, dnconsole.exe launchex --index %emulatoradb% --packagename "com.hkmanjuu.azurlane.gp" , %ldplayer%, Hide
Loop
{
	if (DwmCheckcolor(1259, 695, 16777215) and DwmCheckcolor(1240, 700, 22957) and DwmCheckcolor(52, 578, 5937919))
	{
		LogShow("位於遊戲首頁，自動登入")
		C_Click(642, 420)
		sleep 6000
	}
	if (DwmCheckcolor(144, 93, 16777215) and DwmCheckcolor(183, 93, 16777215))
	{
		LogShow("出現系統公告，不再顯示")
		C_Click(994, 110)
		C_Click(1193, 103)
	}
	sleep 250
} until DwmCheckcolor(894, 422, 16777215) and DwmCheckcolor(12, 200, 16777215) and DwmCheckcolor(1012, 65, 16729459)
return

DailyGoalSub:
WinRestore,  %title%
WinMove,  %title%, , , , 1318, 758
if  (DailyGoal<1)
{
	iniread, Yesterday, settings.ini, Battle, Yesterday
	FormatTime, Today, ,dd
	if (Yesterday=Today)
	{
		DailyGoal := 1
	}
	else
	{
		;~ msgbox, %Yesterday%
	}
	Iniwrite, %Today%, settings.ini, Battle, Yesterday
}
else
{
	msgbox 123
}
DailyGoal := 1 ;打第一個
LogShow("開始每日任務，請手動進入每日。")
Loop
{
	if (DwmCheckcolor(384, 192, 16768825) and DwmCheckcolor(397, 190, 16768825))
	{
		A_Swipe(652,166,652,610)
		sleep 1000
		if DailyGoal=1
		{
			C_Click(721, 262)
		}
		else if DailyGoal=2
		{
			C_Click(721, 401)
		}
		else if DailyGoal=3
		{
			C_Click(721, 552)
		}
		if (DwmCheckcolor(477, 361, 15724527))
		{
			Logshow("每日任務已結束")
			C_Click(57, 95)
			C_Click(57, 95)
			Break
		}
	}
	else if (DwmCheckcolor(1075, 655, 16777215) and DwmCheckcolor(1234, 650, 16777215) and DwmCheckcolor(1222, 656, 16239426))
	{
		Logshow("出擊每日任務！")
		C_Click(1147, 667)
	}
	Try
	{
		battlevictory()
		Battle()
		ChooseParty()
		ToMap()
		shipsfull(StopAnchor)
		BackAttack()
		Message_Story()
		Battle_End()
		UnknowWife()
		Message_Normal()
		Message_Center()
		NewWife()
		GetCard()
		GetItem2()
		GetItem()
		battlevictory()
	}
}
return

MissionSub:
MissionCheck := DwmCheckcolor(943, 711, 11883842)
MainCheck := DwmCheckcolor(13, 201, 16777215) ;主選單圖示
if (MissionCheck and MainCheck) ;如果有任務獎勵
{
    LogShow("發現任務獎勵！")
    sleep 1500
    C_Click(883, 725)
    Loop
    {
        if (DwmCheckcolor(1070, 91, 13019697) and DwmCheckcolor(1198, 117, 12410186)) ;全部領取任務獎勵
        {
            LogShow("領取全部任務獎勵！")
            C_Click(1068, 63)
        }
        else if (DwmCheckcolor(594, 223, 16766794) and DwmCheckcolor(1198, 117, 12410186)) ;領取第一個任務獎勵
        {
            C_Click(1136, 187)
        }
		else if (DwmCheckcolor(712, 182, 16777215) and DwmCheckcolor(576, 188, 16777215))
		{
			C_Click(636, 91)
		}
        else if (GdiGetPixel(751, 205)=4286894079 or GdiGetPixel(749, 278)=4287419391 ) ;確認獎勵
        {
            C_Click(641, 597)
        }
        else if (GdiGetPixel(53, 692)=4294967295) ;卡片
        {
            C_Click(604, 349)
        }
        else if (GdiGetPixel(915, 232)=4291714403 and GdiGetPixel(815, 232)=4283594165) ;是否鎖定該腳色(否)
        {
            C_Click(489, 546)
        }
		else if (DwmGetPixel(459, 544)=16777215 and DwmGetPixel(811, 546)=16777215 and DwmGetPixel(413, 225)=16777215) ;是否提交物品(是)
        {
            C_Click(811, 546)
        }
		else if (DwmGetPixel(1273, 67)=10858165) ;劇情
        {
            C_Click(811, 546)
        }
        else if (DwmCheckcolor(1147, 183, 15198183) and DwmCheckcolor(1147, 337, 15198183) )
        {
            LogShow("獎勵領取結束，返回主選單！")
            C_Click(56, 91)
			break
        }
        sleep 500
    } until GdiGetPixel(1036, 350)=16777215
}
return

AcademySub:
AcademyCheck := DwmCheckcolor(627, 712, 11882818) ;學院驚嘆號
MainCheck := DwmCheckcolor(13, 201, 16777215) ;主選單圖示
if (AcademyCheck and MainCheck)
{
	DormX1 := 95
	DormY1 := 112
	DormX2 := 1246
	DormY2 := 611
	LogShow("發現學院任務！")
	C_Click(580, 727)
	sleep 1000
	Loop
	{
		 if (GdipImageSearch2(x, y, "img/AcademyOil.png", 100, 8, 95, 298, 542, 723) and AcademyOil ) ;
		{
			LogShow("發現石油，高雄發大財！")
			C_Click(x, y)
		}
		if (GdipImageSearch2(x, y, "img/AcademyCoin.png", 100, 8, 450, 411, 843, 748) and AcademyCoin and fullycoin<1) ;
		{
			LogShow("發現金幣，高雄發大財！")
			C_Click(x, y)
			if (DwmCheckcolor(437, 361, 15724527))
			{
				LogShow("高雄的錢…真的太多了…")
				fullycoin := 1
			}
		}
		if (GdipImageSearch2(x, y, "img/Academyshop.png", 100, 8, 1025, 149, 1202, 274) and AcademyShop) ;
		{
			LogShow("商店街發大財")
			C_Click(x, y)
			Loop
			{
				if (DwmCheckcolor(220, 187, 16777215) and DwmCheckcolor(66, 702, 16777215) and DwmCheckcolor(232, 701, 16777215))
				{
					LogShow("才不要買呢")
					C_Click(59, 91)
					break
				}
				sleep 200
			}
		}
		if (GdipImageSearch2(x, y, "img/AcademyTactics.png", 100, 8, 271, 167, 1127, 687) and AcademyTactics and learnt<1)
		{
			LogShow("我們真的學不來！")
			C_Click(x, y)
			sleep 5000
			Loop
			{
				;~ A_Swipe(612,140,612,620)
				if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(811, 548, 16777215) and DwmCheckcolor(460, 541, 16777215) and DwmCheckcolor(414, 225, 16777215) and DwmCheckcolor(750, 538, 4353453))
				{
					LogShow("學習！學習！")
					C_Click(786, 545)
				}
				else if (DwmCheckcolor(873, 649, 16777215) and DwmCheckcolor(1151, 654, 16777215) and DwmCheckcolor(915, 666, 16777215))
				{
					LogShow("開始課程！")
					C_Click(1097, 641)
					if (DwmCheckcolor(556, 358, 16249847))
					{
						LogShow("課本不足，無法學習")
						C_Click(903,653)
					}
				}
				else if (DwmCheckcolor(810, 547, 16777215) and DwmCheckcolor(460, 540, 16777215) and DwmCheckcolor(515, 534, 16777215))
				{
					LogShow("堅持學習！")
					C_Click(789, 541)
				}
				else if (DwmCheckcolor(225, 67, 14085119) and DwmCheckcolor(274, 165, 13022901))
				{
					sleep 3000
					if (DwmCheckcolor(225, 67, 14085119) and DwmCheckcolor(274, 165, 13022901))
					{
					LogShow("學習結束～！")
					learnt := 1
					C_Click(56, 94)
					sleep 1000
					break
					}
				}
			}
		}
		sleep 300
		Academycount++
		if (Academycount>60)
		{
			LogShow("離開學院。")
			Academycount := VarSetCapacity
			fullycoin := VarSetCapacity
			learnt := VarSetCapacity
			AcademyDone := 1
			Settimer, AcademyClock, -1800000 ;30分鐘後再開始檢查
			if (DwmCheckcolor(170, 68, 14610431))
			{
			C_Click(38,92)
			}
			break
		}
	}
}
return

AcademyClock:
LogShow("AcademyDone := VarSetCapacity")
AcademyDone := VarSetCapacity
return

WinSub:
WinGet, Wincheck, MinMax, %title%
if Wincheck=-1
{
	WinSet, Transparent, 0, %title%
	sleep 500
	WinRestore, %title%
	sleep 500
	WinSet, Transparent, off, %title%
}
else if Wincheck=1
{
	WinRestore, %title%
	LogShow("輔助運作中請勿放大視窗")
	LogShow("輔助運作中請勿放大視窗")
	LogShow("輔助運作中請勿放大視窗")
}
else if Wincheck=0
{
	;~ WinMove,  %title%, , , , 1318, 758
}
return

DormSub:
DormMissionCheck := DwmCheckcolor(784, 712, 11883842) ;後宅驚嘆號
MainCheck := DwmCheckcolor(13, 201, 16777215) ;主選單圖示
if ( DormMissionCheck and MainCheck) ;後宅發現任務
{
	DormX1 := 0
	DormY1 := 0
	DormX2 := 1250
	DormY2 := 620
	LogShow("發現後宅任務！")
	C_Click(723, 727)
	sleep 1500
	GuLuGuLuLu() ;如果太過飢餓 
	Loop
	{
		if (DwmCheckcolor(190, 90, 16711688) and DwmCheckcolor(1206, 115, 16765852) and DwmCheckcolor(665, 687, 16250871))
		{
			C_Click(1261, 464) ;點到訓練自動離開
		}
		else if (DwmCheckcolor(372, 337, 11924356) and DwmCheckcolor(458, 344, 9235282) and DwmCheckcolor(450, 292, 8090037))
		{
			C_Click(1261, 464) ;點到施工自動離開
		}
		else if (DwmCheckcolor(725, 665, 16776191) and DwmCheckcolor(1128, 665, 16777215) and DwmCheckcolor(1076, 657, 16777215))
		{
			C_Click(1110, 657) ;獲得經驗 按確定
		}
		else if (DormFood and DormFoodDone<1)
		{
			FoodX := (550-30)*(DormFoodBar/100)+30
			FoodCheck := DwmCheckcolor(FoodX, 723, 4343106) ;存糧進度條
			FoodCheck2 := DwmCheckcolor(48, 686, 16764746) ;左下黃十字
			if (FoodCheck and FoodCheck2)
			{
				if (DormFoodBar>=50 and DormFoodBar<65)
				{
					DormFoodBar := 66
				}
				else if (DormFoodBar<50 and DormFoodBar>39)
				{
					DormFoodBar := 38
				}
				LogShow("存糧不足，自動補給")
				C_Click(292,718)
				Loop
				{
					Food1 := DwmCheckcolor(402, 406, 6538215)
					Food2 := DwmCheckcolor(559, 403, 6535902)
					Food3 := DwmCheckcolor(711, 401, 5947102)
					Food4 := DwmCheckcolor(838, 380, 5941974)
					SuppilesbartargetX :=  (1020-430)*(DormFoodBar/100)+430  ; x1=430 , x2=1020, y=303
					Suppilesbar := DwmCheckcolor(SuppilesbartargetX, 303, 4869450)
					if (Food1 and Suppilesbar)
					{
						C_Click(358,416) 
					}
					else if (Food2 and Suppilesbar)
					{
						C_Click(519,416)
					}
					else if (Food3 and Suppilesbar)
					{
						C_Click(669,416)
					}
					else if (Food4 and Suppilesbar)
					{
						C_Click(826,416)
					}
					if (!Suppilesbar or (!Food1 and !Food2 and !Food3 and !Food4))
					{
						C_Click(557,119) ;離開餵食
						sleep 500
						DormFoodDone := 1
						break
					}
				}
			}
		}
		else if (GdipImageSearch2(x, y, "img/Dorm_Coin.png", 100, 8, DormX1, DormY1, DormX2, DormY2) and DormCoin and Dorm_Coin<3) 
		{
			LogShow("收成傢俱幣")
			C_Click(x, y)
			Dorm_Coin++
		}
		else if (GdipImageSearch2(x, y, "img/Dorm_Coin2.png", 100, 8, DormX1, DormY1, DormX2, DormY2) and DormCoin and Dorm_Coin<3) 
		{
			LogShow("收成傢俱幣")
			C_Click(x, y)
			Dorm_Coin++
		}
		else if (GdipImageSearch2(x, y, "img/Dorm_heart.png", 77, 8, DormX1, DormY1, DormX2, DormY2) and Dormheart and Dorm_heart<3) 
		{
			LogShow("增加親密度")
			C_Click(x, y)
			Dorm_heart++
		}
		else if (GdipImageSearch2(x, y, "img/Dorm_heart2.png", 77, 8, DormX1, DormY1, DormX2, DormY2) and Dormheart and Dorm_heart<3) 
		{
			LogShow("增加親密度")
			C_Click(x, y)
			Dorm_heart++
		}
		sleep 200
		Dormcount++
		if (Dormcount>30)
		{
			LogShow("離開後宅。")
			Dorm_Coin := VarSetCapacity
			Dorm_heart := VarSetCapacity
			Dormcount := VarSetCapacity
			DormFoodDone := VarSetCapacity
			DormDone := 1
			Settimer, DormClock, -1800000
			if (DwmCheckcolor(95, 573, 16711680))
			{
			C_Click(38,92)
			}
			break
		}
	}
}
return

DormClock:
DormDone := VarSetCapacity
LogShow("DormDone := VarSetCapacity")
return

Reload:
Reload
return

whitealbum: ;重要！
Random, num, 1, 15
if (num=1) 
    Guicontrol, ,starttext, 目前狀態：白色相簿什麼的已經無所謂了。
else if (num=2) 
    Guicontrol, ,starttext, 目前狀態：為什麼你會這麼熟練啊！
else if (num=3)   
    Guicontrol, ,starttext, 目前狀態：是我，是我先，明明都是我先來的……
else if (num=4) 
    Guicontrol, ,starttext, 目前狀態：又到了白色相簿的季節。
else if (num=5) 
    Guicontrol, ,starttext, 目前狀態：為什麼會變成這樣呢……
else if (num=6) 
    Guicontrol, ,starttext, 目前狀態：傳達不了的戀情已經不需要了。
else if (num=7) 
    Guicontrol, ,starttext, 目前狀態：你到底要把我甩開多遠你才甘心啊！？
else if (num=8) 
    Guicontrol, ,starttext, 目前狀態：冬馬和雪菜都是好女孩！
else if (num=9) 
    Guicontrol, ,starttext, 目前狀態：夢裡不覺秋已深，余情豈是為他人。
else if (num=10) 
    Guicontrol, ,starttext, 目前狀態：先從我眼前消失的是你吧！？
else if (num=11) 
    Guicontrol, ,starttext, 目前狀態：你就把你能治好的人給治好吧。
else if (num=12) 
    Guicontrol, ,starttext, 目前狀態：我……害怕雪，因為很美麗，所以我害怕。
else if (num=13) 
    Guicontrol, ,starttext, 目前狀態：對不起…我的嫉妒，真的很深啊。
else if (num=14) 
    Guicontrol, ,starttext, 目前狀態：逞強的話語中 卻總藏著一聲嘆息 。
return

DelegationMission() {
	Loop
	{
		sleep 300
	} until DwmCheckcolor(166, 65, 15201279) ;進入委託頁面
	C_Click(53, 191) ;每日
	Loop, 30
	{
		sleep 300
		if (DwmCheckcolor(181, 136, 11358530)) {
			LogShow("完成委託任務")
			C_Click(411, 180)
		}
		else if (DwmCheckcolor(58, 76, 16777215) or DwmCheckcolor(1215, 74, 16777215))
		{
			C_Click(411, 180)
		}
		else if (DwmCheckcolor(711, 261, 16777215) or DwmCheckcolor(575, 258, 16777215))
		{
			LogShow("獲得道具，點擊繼續")
			C_Click(636, 91)
		}
		else if (DwmCheckcolor(712, 182, 16777215) and DwmCheckcolor(576, 188, 16777215))
		{
			LogShow("獲得道具，點擊繼續")
			C_Click(636, 91)
		}
		else if (DwmCheckcolor(443, 205, 8699499) or DwmCheckcolor(443, 205, 6515067)) ;任務都在進行中 or 都沒接到任務
		{
			break
		}
	}
	C_Click(51, 283) ;緊急
	sleep 1200
	Loop, 30
	{
		sleep 500
		if (DwmCheckcolor(181, 136, 11358530))
		{
			LogShow("完成委託任務")
			C_Click(411, 180)
		}
		else if (DwmCheckcolor(58, 76, 16777215) or DwmCheckcolor(1215, 74, 16777215))
		{
			C_Click(411, 180)
		}
		else if (DwmCheckcolor(711, 261, 16777215) or DwmCheckcolor(575, 258, 16777215))
		{
			LogShow("獲得道具，點擊繼續")
			C_Click(636, 91)
		}
		else if (DwmCheckcolor(712, 182, 16777215) and DwmCheckcolor(576, 188, 16777215))
		{
			LogShow("獲得道具，點擊繼續")
			C_Click(636, 91)
		}
		else if !DwmCheckcolor(143, 205, 12404034) ;沒有接獲緊急任務
		{
			UrgentTask := 0
			break
		}
		else if (DwmCheckcolor(435, 204, 7042444)) ;第一個任務為灰階狀態
		{
			break
		}
	}
	if (UrgentTask=0)
	{
		UrgentTask := VarSetCapacity
	}
	else
	{
		DelegationMission3()
	}
	C_Click(53, 191) ;每日
	sleep 1200
	DelegationMission3()
	sleep 1500
	Loop
	{
		if (DwmCheckcolor(167, 64, 15201279))
		{
		C_Click(62, 91) ;離開
		break
		}
	}
}

DelegationMission3() ;自動接收軍事任務 . 0=接受失敗 . 1=接受成功 . 2=油耗過高不接受 . 3=進入選單失敗
{
	if (DwmCheckcolor(438, 205, 6515067) or DwmCheckcolor(438, 205, 7042444)) ;第一個任務未開始
	{
		LogShow("Mission1 := 0")
		Mission1 := 0
	}
	if (DwmCheckcolor(435, 352, 6516091) or DwmCheckcolor(435, 352, 7042444)) ;第二個任務未開始
	{
		LogShow("Mission2 := 0")
		Mission2 := 0
	}
	if (DwmCheckcolor(437, 499, 7040379) or DwmCheckcolor(437, 499, 7043468)) ;第三個任務未開始
	{
		LogShow("Mission3 := 0")
		Mission3 := 0
	}
	if (DwmCheckcolor(435, 643, 6516091) or DwmCheckcolor(435, 643, 7043468)) ;第四個任務未開始
	{
		LogShow("Mission4 := 0")
		Mission4 := 0
	}
	if (Mission1 = 0 and !DwmCheckcolor(1082, 62, 9211540))
	{
		C_Click(560, 192)
		Mission1 := DelegationMission2()
		if (Mission1=2 and !DwmCheckcolor(1082, 62, 9211540))
		{
			A_Swipe(1221,395, 1221, 115)
			C_Click(560, 651)
			DelegationMission2()
		}
	}
	if (Mission2 = 0 and !DwmCheckcolor(1082, 62, 9211540))
	{
		C_Click(560, 332)
		Mission2 := DelegationMission2()
		if (Mission1=2)
		{
			A_Swipe(1221,395, 1221, 115)
			C_Click(560, 651)
			DelegationMission2()
		}
	}
	if (Mission3 = 0 and !DwmCheckcolor(1082, 62, 9211540))
	{
		C_Click(560, 471)
		Mission3 := DelegationMission2()
		if (Mission3=2)
		{
			A_Swipe(1221,395, 1221, 115)
			C_Click(560, 651)
			DelegationMission2()
		}
	}
	if (Mission4 = 0 and !DwmCheckcolor(1082, 62, 9211540))
	{
		C_Click(560, 620)
		Mission4 := DelegationMission2()
		if (Mission4=2)
		{
			A_Swipe(1221,395, 1221, 115)
			C_Click(560, 651)
			DelegationMission2()
		}
	}
	Mission1 := VarSetCapacity
	Mission2 := VarSetCapacity
	Mission3 := VarSetCapacity
	Mission4 := VarSetCapacity
}

DelegationMission2()
{
Loop, 30  ;等待選單開啟
	{
		sleep 300
		if (DwmCheckcolor(992, 365, 16777215) and DwmCheckcolor(1149, 366, 16777215))
		{
			loopcount := VarSetCapacity
			break
		}
		loopcount++
		if (loopcount>10)
		{
			;~ Logshow("未能成功進入軍事任務選單")
			e := 3
			loopcount := VarSetCapacity
			return e
		}
	}
	;~ LogShow("成功進入")
	if (DwmCheckcolor(1138, 338, 4870499)) ;如果耗油是個位數
	{
		C_Click(931, 380)
		sleep 500
		if (DwmCheckcolor(1149, 386, 15709770)) ;如果成功推薦角色
		{
			C_Click(1096, 385) ;開始
			sleep 1000
			if (DwmCheckcolor(329, 209, 16777215) and DwmCheckcolor(811,547, 16777215)) ;如果有花費油
			{
				C_Click(784, 548) ;確認
				sleep 1000
			}
			C_Click(1227, 172) ;離開介面
			sleep 1000
			A_Swipe(1220,187,1220,473) ;往上拉
			sleep 1000
			e := 1 ;成功接受委託任務
			;~ LogShow("軍事任務成功接受")
			return e
		}
		else 
		{
			C_Click(1227, 172) ;離開介面
			sleep 1000
			A_Swipe(1220,187,1220,473) ;往上拉
			sleep 1000
			e := 0 ;接收失敗...可能是角色等級或數量不足 etc...
			;~ LogShow("軍事任務接收失敗")
			return e
		}
	}
	else
	{
		C_Click(1227, 172) ;離開介面
		sleep 1000
		A_Swipe(1220,187,1220,473) ;往上拉
		sleep 1000
		e := 2 ;油耗超過個位數 不予接受
		;~ LogShow("軍事任務油耗超過個位數")
		return e
	}
}

battlevictory()
{
	if (DwmCheckcolor(123, 650, 16777215)  or DwmCheckcolor(139, 666, 16777215) or DwmCheckcolor(125, 682, 16777215) or DwmCheckcolor(110, 666, 16777215)) and (DwmCheckcolor(68, 703, 16777215) or DwmCheckcolor(68, 703, 528417) or DwmCheckcolor(661, 405, 16777215)) and DwmCheckcolor(685, 406, 16777215) and !DwmCheckcolor(1208, 658, 4379631) and DwmCheckcolor(1, 1, 2633790) ;點擊繼續
	{
		LogShow("艦已靠港。")
		C_Click(638, 519)
	}
}

GetItem()
{
	if (DwmCheckcolor(576, 258, 16777215) and DwmCheckcolor(613, 257, 16777215) and DwmCheckcolor(715, 274, 16777215) and DwmCheckcolor(622, 275, 7574271)) ;獲得道具
	{
		LogShow("獲得道具，點擊繼續！")
		C_Click(638, 519)
	}
}

GetItem2()
{
	if (DwmCheckcolor(576, 186, 16777215) and DwmCheckcolor(711, 187, 16777215) and DwmCheckcolor(613, 187, 16777215) and DwmCheckcolor(641, 199, 8104703)) ;獲得道具
	{
		LogShow("獲得道具，點擊繼續2！")
		C_Click(638, 519)
	}
}

GetCard()
{
	if (DwmGetPixel(71, 412)=16777215 and DwmGetPixel(57, 514)=16777215 and DwmGetPixel(70, 607)=16777215 and DwmGetPixel(52, 694)=16777215 and DwmCheckcolor(1, 1, 2633790)) ;獲得新卡片
	{
		LogShow("獲得新卡片，自動上鎖！")
		C_Click(61, 609)
		C_Click(604, 349)
	}
}

NewWife()
{
	if (DwmCheckcolor(810, 549, 16777215) and DwmCheckcolor(414, 225, 16777215) and DwmCheckcolor(459, 544, 16777215) and DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(896, 229, 16777215) and DwmCheckcolor(718, 388, 16777207) and DwmCheckcolor(1, 1, 2633790)) ;訊息自動確認
	{
		LogShow("撿到老婆，簽字簽字！")
		C_Click(788, 545)
	}
}

Message_Center()
{
	if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(414, 225, 16777215) and DwmCheckcolor(661, 549, 16777215) and DwmCheckcolor(640, 545, 4355509)) ;中央訊息
	{
		LogShow("中央訊息，點擊確認！")
		C_Click(635, 542)
	}
	else if (DwmCheckcolor(330, 196, 16777215) and DwmCheckcolor(414, 210, 16777215) and DwmCheckcolor(690, 559, 16777215) and DwmCheckcolor(665, 349, 10268333))
	{
		LogShow("每日提示，今日不再顯示！")
		C_Click(774, 497)
		C_Click(638, 565)
	}
}

Message_Normal()
{
	if (DwmCheckcolor(810, 549, 16777215) and DwmCheckcolor(414, 225, 16777215) and DwmCheckcolor(459, 544, 16777215) and DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(896, 229, 16777215) and DwmCheckcolor(1, 1, 2633790)) ;訊息自動確認
	{
		LogShow("出現訊息，點擊取消！")
		C_Click(490, 548)
	}
}

UnknowWife()
{
	if (GdiGetPixel(811, 548)=4294967295 and GdiGetPixel(441, 346)=4283584850) ;未知腳色(確認)
	{
		LogShow("未知腳色(確認)！")
		C_Click(811, 546)
	}
}

Battle_End()
{
	if (DwmGetPixel(1108, 699)=16777215 and DwmGetPixel(914, 680)=16777215 and DwmGetPixel(98, 242)=16777215) and DwmCheckcolor(1, 1, 2633790)  ;確定
	{
		LogShow("結算畫面，點擊確定！")
		C_Click(1108, 699)
		sleep 6000
	}
}

Message_Story()
{
	 if (DwmCheckcolor(1274, 67, 11382461) and DwmCheckcolor(1236, 729, 12437462))
	{
		LogShow("劇情對話，自動略過")
		C_Click(1200, 74)
		sleep 1000
		if (DwmCheckcolor(810, 546, 16777215))
		{
			C_Click(784, 545)
		}
	}
}

BackAttack()
{
	 if (DwmCheckcolor(417, 389, 16777215) and DwmCheckcolor(842, 401, 16777215) and DwmCheckcolor(1096, 521, 16777215) and DwmCheckcolor(351, 417, 16735595)) ;遇襲
	{
		if Assault=迎擊
		{
			LogShow("遇襲：迎擊！")
			C_Click(843, 508)
		}
		else if Assault=規避
		{
			LogShow("遇襲：規避！")
			C_Click(1068, 502)
		}
		else
		{
			LogShow("伏擊錯誤")
			Msgbox, Assalut = %Assault%
		}
	}
}

shipsfull(byref StopAnchor)
{
	if (DwmCheckcolor(330, 209, 16777215) and DwmCheckcolor(897, 230, 16777215) and DwmCheckcolor(865, 557, 16777215) and DwmCheckcolor(463, 541, 16777215) and DwmCheckcolor(615, 533, 16777215) and DwmCheckcolor(402, 527, 3761564) and DwmCheckcolor(1, 1, 2633790))
	{
		if shipsfull=停止出擊
		{
			LogShow("船䲧已滿：停止出擊。")
			Traytip, Azur Lane, 船䲧已滿：停止出擊。
			C_Click(896,231)
			Loop
			{
				if (DwmCheckcolor(944, 540, 16250871) and DwmCheckcolor(1047, 531, 16250871))
				{
					C_Click(1034,210)
				}
				else if (DwmCheckcolor(143, 688, 16777215))
				{
					C_Click(58,89)
				}
				else if (DwmCheckcolor(12, 200, 16777215))
				{
					StopAnchor := 1 ;不再出擊
					Break
				}
			}
		}
		else if shipsfull=關閉遊戲
		{
			LogShow("船䲧已滿：關閉模擬器。")
			sleep 500
			run, dnconsole.exe quit --index %emulatoradb%, %ldplayer%, Hide
			sleep 500
		}
		else if shipsfull=整理船䲧
		{
			LogShow("船䲧已滿：開始整理。")
			C_Click(437, 539)
			sleep 1000
			Loop
			{
				if (DwmCheckcolor(830, 700, 16777215) and DwmCheckcolor(599, 710, 16777215))
				{
					C_Click(1136, 64) ;開啟篩選
					sleep 1000
					C_Click(502, 129) ;排序 等級
					C_Click(363, 266) ;索引 全部
					C_Click(363, 397)  ;陣營全 陣營
					C_Click(363, 530)  ;稀有度 全部
					if (Index1)
						C_Click(517, 264)
					if (Index2)
						C_Click(666, 265)
					if (Index3)
						C_Click(833, 265)
					if (Index4)
						C_Click(991, 265)
					if (Index5)
						C_Click(1134, 265)
					if (Index6)
						C_Click(348, 324)
					if (Index7)
						C_Click(517, 324)
					if (Index8)
						C_Click(666, 324)
					if (Index9)
						C_Click(833, 324)
					if (Camp1)
						C_Click(513, 397)
					if (Camp2)
						C_Click(666, 397)
					if (Camp3)
						C_Click(833, 397)
					if (Camp4)
						C_Click(991, 397)
					if (Camp5)
						C_Click(1134, 397)
					if (Camp6)
						C_Click(356, 457)
					if (Camp7)
						C_Click(513, 457)
					if (Rarity1)
						C_Click(513, 529)
					if (Rarity2)
						C_Click(666, 529)
					if (Rarity3)
						C_Click(833, 529)
					if (Rarity4)
						C_Click(991, 529)
					if (DwmCheckcolor(821, 702, 16777215))
					{
					C_Click(796, 702)
					break
					}
					else
					{
						Msgbox, 排序角色出錯
					}
				sleep 300
				}
			}
			;~ LogShow("排序完畢這裡繼續")
			Loop
			{
				if (DwmCheckcolor(1035, 683, 16777215) and DwmCheckcolor(825, 684, 16777215) and DwmCheckcolor(156, 84, 16777215))
					C_Click(1014,677)  ;退役確定
				else if (DwmCheckcolor(330, 208, 16777215) and DwmCheckcolor(523, 546, 16777215) and DwmCheckcolor(811, 555, 16777215)) ;如果有角色等級不為1(確定)
					C_Click(787,546)  
				else if (DwmGetPixel(711, 261)=16777215 and DwmGetPixel(575, 258)=16777215) ;獲得道具
					C_Click(636, 91)
				else if (DwmCheckcolor(712, 182, 16777215) and DwmCheckcolor(576, 188, 16777215)) ;獲得道具
					C_Click(636, 91)
				else if (DwmCheckcolor(212, 173, 16777215) and DwmCheckcolor(986, 592, 16777215)) ;拆裝(確定)
					C_Click(979, 580)
				else if (DwmCheckcolor(211, 153, 16777215) and DwmCheckcolor(828, 615, 16777215)) ;將獲得以下材料
					C_Click(805, 605)
				else if (DwmCheckcolor(1102, 705, 10856101) and DwmCheckcolor(1142, 386, 9718090) and DwmCheckcolor(111, 448, 9208460)) ;暫無符合條件的艦船
				{
					C_Click(64, 91)
					Logshow("退役結束")
					break
				}
				else if !(DwmCheckcolor(166, 720, 123)) ;第一位還沒被退役
				{
					C_Click(165,220) ;1
					C_Click(330,220) ;2
					C_Click(495,220) ;3
					C_Click(660,220) ;4
					C_Click(825,220) ;5
					C_Click(990,220) ;6
					C_Click(1155,220) ;7
					C_Click(165,420) ;2-1
					C_Click(330,420) ;2-2
					C_Click(495,420) ;2-3
					C_Click(1078,702)  ;確定
				}
				sleep 300
			}  
		}
	}
}

ToMap()
{
	if (DwmCheckcolor(869, 531, 14587474) and DwmCheckcolor(1045, 532, 16777215) and DwmCheckcolor(1045, 550, 16238402))
	{
		LogShow("立刻前往攻略地圖")
		C_Click(869, 531)
	}
}


ChooseParty()
{
	if (DwmCheckcolor(991, 619, 14586450) and DwmCheckcolor(1167, 636, 16238402) and DwmCheckcolor(1174, 617, 16777215)  )
	{
		LogShow("選擇出擊艦隊中。")
		if FirstChooseParty<1 ;只在第一次啟動選擇隊伍 直到選項變更
		{
			if AnchorMode!=困難
			{
				C_Click(1142, 370) ;先清掉第二艦隊
				C_Click(1053, 235) ;開啟第一艦隊的選擇選單
				if ChooseParty1=第一艦隊
					C_Click(1093, 301) 
				else if ChooseParty1=第二艦隊
					C_Click(1093, 337) 
				else if ChooseParty1=第三艦隊
					C_Click(1093, 382) 
				else if ChooseParty1=第四艦隊
					C_Click(1098, 424) 
				else if ChooseParty1=第五艦隊
					C_Click(1098, 469) 
				if ChooseParty2!=不使用
				{
					C_Click(1053, 368)	;開啟第二艦隊的選擇選單
				}
				if ChooseParty2=第一艦隊
					C_Click(1103, 436)
				else if ChooseParty2=第二艦隊
					C_Click(1103, 476)
				else if ChooseParty2=第三艦隊
					C_Click(1103, 516)
				else if ChooseParty2=第四艦隊
					C_Click(1103, 557)
				else if ChooseParty2=第五艦隊
					C_Click(1103, 597)
				FirstChooseParty := 1
			}
		}
		;~ msgbox 1
		C_Click(1067, 643)	;立刻前往
		if (GdiGetPixel(743, 541)=4282544557) ;心情低落
		{
			LogShow("老婆心情低落中。")
			C_Click(743, 541)
		}
		else if (DwmCheckcolor(530, 360, 15724535)) ; 資源不夠
		{
			LogShow("石油不足，需要更多的石油")
			C_Click(1230, 68) ;返回主選單
		}
	}
}

Battle()
{
	 if (DwmCheckcolor(1225, 83, 16249847) and DwmCheckcolor(1240, 83, 16249847))
	{
		LogShow("報告提督SAMA，艦娘航行中！")
		Loop
		{
			sleep 300
			if !(DwmCheckcolor(1225, 83, 16249847))
			{
				sleep 3000
				if !(DwmCheckcolor(1225, 83, 16249847))
				{
					Break
				}
			}
			else if Autobattle=半自動
			{
				if (DwmCheckcolor(455, 82, 15671329)) or (DwmCheckcolor(372, 61, 16777215))
				{
					if (DwmCheckcolor(897, 656, 16777215) and DwmCheckcolor(1225, 83, 16249847) and DwmCheckcolor(372, 61, 16777215)) ;飛機準備就緒
					{
						C_Click(897, 656)
					}
					else if (DwmCheckcolor(1043, 651, 16777215) and DwmCheckcolor(1225, 83, 16249847)) ;魚雷準備就緒
					{
						C_Click(1043, 651)
					}
					else if (DwmCheckcolor(1198, 654, 16777215) and DwmCheckcolor(1225, 83, 16249847)) ;大砲準備就緒
					{
						C_Click(1198, 654)
					}
				}
				HalfAuto++
				if HalfAuto>4
				{
					if swipeside<1
					{
					Random, swipeside, 3, 4
					}
					;~ if swipeside=1
					;~ {
						;~ A_Swipe2(149,545, 149, 400, 2500) ;上
						;~ Swipe := 2
					;~ }
					;~ else if swipeside=2
					;~ {
						;~ A_Swipe2(150,630, 150, 700, 2500) ;下
						;~ Swipe := 3
					;~ }
					if swipeside=3
					{
						A_Swipe2(198,591, 298, 591, 2000) ;左
						swipeside := 4
					}
					else if swipeside=4
					{
						A_Swipe2(116,587, 20, 587, 2000) ;右
						swipeside := 3
					}
					HalfAuto := 0
				}
				sleep 300
			}
		} 
	}
}

GuLuGuLuLu()
{
	if (DwmCheckcolor(355, 206, 16776183) and DwmCheckcolor(355, 206, 16776183) and DwmCheckcolor(468, 561, 16764787) and DwmCheckcolor(794, 564, 16755282))
	{
		;~ if !DormFood
		;~ {
			LogShow("提督SAMA人家不給吃飯飯！")
			C_Click(520,560)
		;~ }
		;~ else if DormFood
		;~ {
			;~ LogShow("HEHE，吃飯飯！")
			;~ C_Click(757,557)
		;~ }
		;~ else 
		;~ {
			;~ Msgbox, GuLuGuLuLu出現錯誤
		;~ }
	}
}

A_Click(x,y)
{
	sleep 200
	Runwait, ld.exe -s %emulatoradb% input tap %x% %y%, %ldplayer%, Hide
	sleep 500
}

A_Swipe(x1,y1,x2,y2,swipetime="")
{
	sleep 100
	runwait,  ld.exe -s %emulatoradb% input swipe %x1% %y1% %x2% %y2% %swipetime%,%ldplayer%, Hide
	sleep 500
}

A_Swipe2(x1,y1,x2,y2,swipetime="")
{
	Run,  ld.exe -s %emulatoradb% input swipe %x1% %y1% %x2% %y2% %swipetime%,%ldplayer%, Hide
}

C_Click(PosX, PosY, ShiftX="0", ShiftY="0")
{
sleep 200
;~ random , x, PosX - ShiftX, PosX + ShiftX
;~ random , y, PosY - ShiftY, PosY + ShiftY
;~ ControlClick, x%x% y%y%, ahk_id %UniqueID%,,,2 , NA
x := PosX
y := PosY-36
Runwait, ld.exe -s %emulatoradb% input tap %x% %y%, %ldplayer%, Hide
sleep 800
}

GdiGetPixel( x, y)
{
    pBitmap:= Gdip_BitmapFromHWND(UniqueID)
    Argb := Gdip_GetPixel(pBitmap, x, y)
    Gdip_DisposeImage(pBitmap)
    return ARGB
}

Checkcolor( x, y, color="")
{
    pBitmap:= Gdip_BitmapFromHWND(UniqueID)
    Argb := Gdip_GetPixel(pBitmap, x, y)
    Gdip_DisposeImage(pBitmap)
    if  (color=Argb)
    {
        Argb = 1
        return ARGB
    }
    else if (Color!=Argb)
    {
        Argb = 0
        return ARGB
    }
}

Capture() 
{
FileCreateDir, capture
formattime, nowtime,,yyyy.MM.dd_HH.mm.ss
pBitmap := Gdip_BitmapFromHWND(UniqueID)
pBitmap_part := Gdip_CloneBitmapArea(pBitmap, 0, 0, 1280, 758)
Gdip_SaveBitmapToFile(pBitmap_part, "capture/" . title . "AzurLane_" . nowtime . ".jpg")
Gdip_DisposeImage(pBitmap)
Gdip_DisposeImage(pBitmap_part)
}

;~ AreaDwmCheckcolor(byref x, byref y, x1, y1, x2, y2, color="") ; slow
;~ {
	;~ defaultX1 := x1
	;~ defaultY1 := y1
	;~ hDC := DllCall("user32.dll\GetDCEx", "UInt", UniqueID, "UInt", 0, "UInt", 1|2)
	;~ Loop
	;~ {
		;~ x1 := x1 +1
		;~ x := x1
		;~ if (x1=x2)
		;~ {
			;~ x1 := defaultX1
			;~ y1 := y1 +1
			;~ y := y1
		;~ }
	   ;~ pix := DllCall("gdi32.dll\GetPixel", "UInt", hDC, "Int", x, "Int", y, "UInt")
	   ;~ pix := ConvertColor(pix)
	   ;~ tooltip %x% %y%
	;~ } until pix=color or defaultY1=y2
	;~ DllCall("user32.dll\ReleaseDC", "UInt", UniqueID, "UInt", hDC)
	;~ DllCall("gdi32.dll\DeleteDC", "UInt", hDC)
	;~ x := x1
	;~ y := y1
	;~ return pix
;~ }

DwmCheckcolor(x, y, color="")
{
    
   hDC := DllCall("user32.dll\GetDCEx", "UInt", UniqueID, "UInt", 0, "UInt", 1|2)
   pix := DllCall("gdi32.dll\GetPixel", "UInt", hDC, "Int", x, "Int", y, "UInt")
   DllCall("user32.dll\ReleaseDC", "UInt", UniqueID, "UInt", hDC)
   DllCall("gdi32.dll\DeleteDC", "UInt", hDC)
   pix := ConvertColor(pix)
   if (Allowance>=(abs(color-pix)))
    {
        pix = 1
        return pix
    }
    else 
    {
        pix = 0
        return pix
    }  
}

debugmode()
{
    List = 0
    Msgbox, 即將點擊%List%
    return List
}

GetPixel(x, y)
{
    pBitmap:= Gdip_BitmapFromHWND(UniqueID)
    Argb := Gdip_GetPixel(pBitmap, x, y)
    Gdip_DisposeImage(pBitmap)
    return ARGB
}

FindThenClickColor(ARGB, delay="")
{
    pBitmap:= Gdip_BitmapFromHWND(UniqueID)
    Gdip_PixelSearch(pBitmap, ARGB, x, y)
    Random, rands, delay1, delay2
	sleep, %rands%
    ControlClick, x%x% y%y%, ahk_id %UniqueID%,,,, NA
    Gdip_DisposeImage(pBitmap)
    sleep %delay%
}

GdipImageSearch(byref x, byref y, imagePath = "img/picturehere.png",  Variation=100, direction = 1) 
{
    pBitmap := Gdip_BitmapFromHWND(UniqueID)
    LIST = 0
    bmpNeedle := Gdip_CreateBitmapFromFile(imagePath)
    RET := Gdip_ImageSearch(pBitmap, bmpNeedle, LIST, 150, 105, 1215, 630, Variation, , direction, 1)
    Gdip_DisposeImage(bmpNeedle)
    Gdip_DisposeImage(pBitmap)
    LISTArray := StrSplit(LIST, ",")
    x := LISTArray[1]
    y := LISTArray[2]
    return List
}

GdipImageSearch2(byref x, byref y, imagePath = "img/picturehere.png",  Variation=100, direction = 1, x1=0, y1=0, x2=0, y2=0) 
{
    pBitmap := Gdip_BitmapFromHWND(UniqueID)
    LIST = 0
    bmpNeedle := Gdip_CreateBitmapFromFile(imagePath)
    RET := Gdip_ImageSearch(pBitmap, bmpNeedle, LIST, x1, y1, x2, y2, Variation, , direction, 1)
    Gdip_DisposeImage(bmpNeedle)
    Gdip_DisposeImage(pBitmap)
    LISTArray := StrSplit(LIST, ",")
    x := LISTArray[1]
    y := LISTArray[2]
    return List
}

LogShow(logData) {
formattime, nowtime,, MM-dd HH:mm:ss
guicontrol, , ListBoxLog, [%nowtime%]  %logData%||
return
}

LogShow2(logData) {
guicontrol, , ListBoxLog, %logData%||
return
}

DwmGetPixel(x, y)
{
    
   hDC := DllCall("user32.dll\GetDCEx", "UInt", UniqueID, "UInt", 0, "UInt", 1|2)
   pix := DllCall("gdi32.dll\GetPixel", "UInt", hDC, "Int", x, "Int", y, "UInt")
   DllCall("user32.dll\ReleaseDC", "UInt", UniqueID, "UInt", hDC)
   DllCall("gdi32.dll\DeleteDC", "UInt", hDC)
   pix := ConvertColor(pix)
   return pix
}

DecToHex(dec)
{
   oldfrmt := A_FormatInteger
   hex := dec
   SetFormat, IntegerFast, hex
   hex += 0
   hex .= ""
   SetFormat, IntegerFast, %oldfrmt%
   return hex
}

ConvertColor( BGRValue )
{
	BlueByte := ( BGRValue & 0xFF0000 ) >> 16
	GreenByte := BGRValue & 0x00FF00
	RedByte := ( BGRValue & 0x0000FF ) << 16
	return RedByte | GreenByte | BlueByte
}


