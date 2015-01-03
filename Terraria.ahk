; Title: Terraria
; AutoHotkey Version Tested: AutoHotkey Basic and AutoHotkey_L Unicode 64 bits
; Language:       English
; Platform:       WINDOWS
; Author:         doppleganger

; Version 	1.0 Initial version
;			1.1	Cleanup in code and comments
;			1.2 Improvements to interactions between the various functionalities
;			1.3 Addition of tunneling functionalities
;			1.4 Addition of preview functionality in MultiLayer and Tunneling tools
;			1.5 Addition of chest Quick Stack related functionalities
;			1.6 Addition of save/restore of some settings to file TerrariaAHKScriptConfig.ini
;			1.7 Further improvements to interactions between the various functionalities
;			1.8 Addition of cyclical sell of inventory functionnality

#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.

SetTitleMatchMode, 1	;Using option 1, since the Window title of Terraria always begins with Terraria
#MaxThreadsPerHotkey 2


/*****************************USAGE*************************************

This script has been written to automate some tasks. You can customize the keybindings in the next section.

CONTINUOUS USAGE OF TOOLS
- use [Mouse Button 4] to enable/disable CONTINUOUS USE OF TOOLS. Selection of a tool/object from the toolbar [1,2...9,0]
  does cancel the continuous usage of the current tool.
    The proper tool must be equipped first.


CONTINUOUS AUTOATTACK
- use [Mouse Button 5] to enable/disable AUTOATTACK WITH A SWORD
    A sword that does not have autoattack ability must be equipped first.
- use [right Alt] while the functionality is active, followed by a number from [1,2...9,0] (0 treated as 10)
  to adjust the delay between each hit when in autoattack mode. By default, the script uses the value corresponding to number 5
  A smaller number gives a smaller delay and a bigger number gives a bigger delay, between hits.


AUTORUN
- use [q] and [e] to toggle the AUTORUN mode toward the left [q] and the right [e]. Use of directional
  movement keys [w] [a] [s] [d] does cancel the autorun state.


CONTINUOUS MULTILAYER TOOL USE
- use [z] and [x] to enable/disable MULTILAYER continuous use of tools in one direction (left or right) at a specific walking speed.
    The functionality of this tool is to affect layers of blocks, in the horizontal axis.
    The proper tool must be equipped first, and the mouse cursor must point on the desired starting block layer.
    PREVIEW functionality:
      1. the first time you press [z] or [x], the tool enters a Preview mode.
          The Preview mode moves the mouse cursor over the layers that are going to be affected when the tool is active.
          You can play with the [right Alt] and [right Ctrl] functionalities and see their effects in the Preview mode.
      2. the second time you press the same key [z] or [x], the tool will then become active.

- use [right Alt] while the functionality is active or in Preview, followed by a number from [1,2...9,0] (0 treated as 10)
    to adjust the time the pick spends on each block, before taking each step when using [z] or [x]
    By default, the script uses the value corresponding to number 5. A smaller number means the character
    will work less time on each block, and vice versa.
- use [right Ctrl] followed by a number from [1,2...9] to adjust the number of layers the tool will be working on. The default is 3.
    The multiLayer tool must be active or in Preview for this change to occur, because we also use [right Ctrl] for the Tunneling functionalties.

    Note:although the continuous multilayer tool use can be used to do some basic horizontal tunneling, there is a specialized
    feature for tunneling (see next feature)

CONTINUOUS TUNNELING
- use [left arrow], [right arrow] and [down arrow] to enable/disable continuous TUNNELING (left, right or downward).
    Note: the pick must be equipped, first.
    For [left] and [right] cases, set the mouse cursor near the ground, near the character
        1. Make sure character is flush against the surface he will be tunneling through
        2. Put mouse cursor centered on the 'boot' level block that lies besides the lower body of the character
    For the [down] case, do note that the character is 2 blocks wide, so you must align him and the cursor correctly!
        1. Make sure the character is aligned on the blocks beneath him
        2. Put mouse cursor centered on the left block portion of the character, a few pixels beneath his feet
    PREVIEW functionality:
      1. the first time you press [left arrow], [right arrow] or [down arrow], the tool enters a Preview mode.
          The Preview mode moves the cursor over the columns that are going to be affected when the tool is active.
          You can play with the [right Alt] and [right Ctrl] functionalities and see their effects in the Preview mode.
      2. the second time you press the same key [left arrow], [right arrow] or [down arrow], the tool will then become active.
- use [right Alt] while the functionality is active or in Preview, followed by a number from [1,2...9,0] (0 treated as 10)
    to adjust the time the pick spends on each block.
    By default, the script uses the value corresponding to number 5. A smaller number means the character
    will wait less time before each step, and vice versa.
- use [right Ctrl] followed by a number from [1,2...5] to adjust the width/height of the tunnels.
    If done when [Left] or [right] functionalities enabled, it will change only the height of horizontal tunnels.
    If done when [down] functionality enabled, it will change only the width of vertical tunnels.
    If done when neither functionalities are active, it will change both the width and heigth of tunnels.
    A minimum height of 3, and minimum width of 2, and maximums of 5, are enforced by the code.
    The default values are the minimum values, thus 3 for the height, and 2 for the width.

NOTE: The [Backspace] functionality has been commented out, as it does not look useful anymore
- use [Backspace] before using the tunneling functions, to Calibrate the script. NOTE: use of this function is no longer mandatory,
    as default values have been put for the block dimensions. Default values are 16 pixels X 16 pixels.
      After having pressed and released [backspace],
      press and hold the right mouse button and cover an area of 3 blocks high and 3 blocks wide. Release the right mouse button
      when this is done. The script will use this to determine the dimensions of a single block, according to the resolution at which you play the game.

- some specialised functionalities related to tunneling are available, but have some requirements:
    1. You will need to go customize the variables below, named keyToolbarItemPick and keyToolbarItemWithMaterial,
      so that the numbers assigned to them correspond to the numbers where those items are placed in your toolbar.
      - keyToolbarItemPick -> put the toolbar item number that contains the pick
      - keyToolbarItemWithMaterial -> put the toolbar item number that contains the material to be used for lining (stone block, etc)
    2. The safety net functionality requires that the character be equipped with the Toolbelt item, bought from Goblin Tinkerer.

    feature TUNNEL LINING: tunnels can have an extra block layer dug and then filled with the material of your choice
      - use [numpad left] and [numpad right] to toggle left and right side lining of vertical tunnels
      - use [numpad up] and [numpad down] to toggle top and bottom side lining of horizontal tunnels
      In Preview mode, the mouse cursor will adjust its course accordingly.

    feature SAFETY NET:  REQUIRES Toolbelt item equipped.
      usage is manual: press the [numpad clear] (the numpad 5 key) to toggle the functionality.
      -horizontal tunnels: The feature of putting a lining on the floor MUST be active. A stopper will be added automatically.
      -vertical tunnels: this features will try to lay down a column of 4 blocks heigth beneath the character,
          so that the character can stand on the lowest one when the usual layer of 3 blocks is dug.
          You might want to toggle it on only when you see the the character is about to dig through a ceiling.
      In Preview mode, you will see the mouse cursor adjust its course accordingly.


DELAYS ADJUSTMENT
- use [insert] and [delete] as an alternate way of ADJUSTING THE DELAYS that are affected by the [right Alt] functionality in all places above.
    [insert] will increase the delays by one step for the currently active functionality (it will slow things down)
    [delete] will decrease the delays by one step for the currently active functionality (it will speed things up)


SHORTCUT FOR QUICK STACK MENU BUTTON of chests
- use [r] as a shortcut to the QUICK STACK MENU BUTTON when chests are open.
- use [Ctrl + r] to CALIBRATE the feature. Just move the mouse cursor over the Quick Stack menu button,
    and press [Ctrl + r] so that the script memorize the cursor position.


AUTOMATIC MULTIPLE QUICK STACK
- use [y] as a shortcut to an AUTOMATIC MULTIPLE QUICK STACK functionality. See [ctrl + y] for more details on how to set it up.
    The goal of this feature is to have the character stand in an area and be surrounded with chests. Those chests will serve to
    quickly unload most of your inventory when you come back from exploration. We basically automate mouse clicks to each one of those chests,
    and then another mouse click to the Quick Stack menu button to quickly dump stuff in each chest.
    1. Make sure the character is positioned exactly where it should.
    2. press the [y] key

- use [ctrl + y] to SETUP the multiple quick stack feature.
    1. Have the character stand at a very precise and recognizable position, and be surrounded with as many chests as you can fit
      around the character and accesible via the right mouse button click.
    2. Press [ctrl + y] and release.
    3. For each chest you want to add to the setup, simply right mouse click the chest. Do all the chests.
      Make sure that for chests that are a little far away, the right mouse click results in opening that chest. This is important.
    4. Press and release [ctrl + y] again
    5. Now test the feature by simply clicking [y]. The mouse cursor should move to each chest, and activate the Quick Stack button for each chest.

- use [u] and [ctrl + u] in a similar way to [y] and [ctrl + y], to do a second setup of chests layout for the multiple quick stack feature


AUTOMATIC CYCLICAL SELLING OF COMPLETE INVENTORY
- use [i] as a shortcut to an AUTOMATIC CYCLICAL SELLING OF COMPLETE INVENTORY. See [ctrl + i] for more details on how to set it up.
    The goal of this feature is to enable the continuous automated selling of the complete inventory to an NPC, while standing
    under a statue farming machine. It does enable us to get cash while AFK.
    1. Open inventory and TRANSFER EVERYTHING, INCLUDING CONTENT OF HOTBAR/TOOLBAR, into chests. We want an empty inventory.
    2. Make sure the statue farming machine is started, then position yourself to receive the goods, and right click on nearby NPC and open the shop option.
    3. Press and release [i] and go AFK.
    4. To stop, press [i] again, or left mouse click. You can then proceed to sell the goods that accumulated in the hotbar region.

    NOTE: the only reason I suggest emptying the hotbar at the beginning is for security. You never know what glitch might cause the script to sell your
      valuable weaponry! One possible situation that could cause problems is if you switch from fullscreen to windowed mode, and do not redo
      the setup for this feature. The old setup coordinates could now be pointing directly at your hotbar/toolbar instead of the first row
      of inventory...

- use [ctrl+i] to SETUP the sell inventory feature
    1. Open inventory and transfer everything, including content of hotbar, into chests. We want an empty inventory.
    2. Press [ctrl + i] and release.
    3. Forget the hotbar/toolbar, consider only the 4 rows of the inventory. Right mouse click once in the middle of each cell
      situated at the corners of the rectangle formed by the 4 rows of inventory. Thus, 4 right mouse clicks does the job.
    4. Press and release [ctrl + i] again
    5. Now test the feature by simpling clicking [i]. The mouse cursor should start moving at each cell of the inventory,
      beginning at first cell of first row, then all other cells of same row, then next rows, to eventually come back to first row and so on.

- special feature to keep character hooked to the bottom of statue farm machine via any hook
    1. Make sure you customize the keybind keyGrapple in the next section, so that it does use the same keybind as in game (default is 'f')
    2. Put any hook in one of the hotbar/toolbar cells, dont put it in the inventory!
    3. Before starting the selling via [i], you must hook the character to the bottom of the machine
    4. Press [ctrl + f] and release. We are now registering cursor positions each time you press 'f'
    5. Position the mouse cursor above and sligthly behind the character, and press 'f' . If the character moved, even just a little bit,
      repeat step 5: reposition mouse cursor slightly and press 'f'
    6. Press [ctrl + f] and release, when you are satisfied that the character does not move when using the grapple key 'f'
    7. you are now ready to start selling via the [i] keybind
    NOTE: this must be redone each time you set yourself up to sell using the [i] feature, as the exact positioning of the character
      will change sligthly each time you hook him up under the statue farming machine.

RECORD/READ SOME SETTINGS TO/FROM .INI FILE
- use [;] to SAVE some calibration/setup data TO A FILE called: TerrariaAHKScriptConfig.ini
  The following data will be saved and later will be automatically read upon loading the script:
  1. A change to the block dimensions, done via calibration. See [Backspace] feature.
  2. A change to the QuickStack menu button position, done via calibration. See [Ctrl + r] feature.
  3. All the positions done by the setup of the advanced multiple quick stack feature, done via [ctrl + y] and [ctrl + u]
  4. The positioning data of the cyclical selling of complete inventory feature.

SUSPEND and PAUSE
- use [right Shift] to SUSPEND/re-enable the hotkeys.

- use [p] to PAUSE/unpause the script. Useful if script is moving cursor around in an infinite loop and you switched app accidentaly.

CHAT
- automatic pause/unpause and suspend/resume of the entire script and hotkeys when user enters/leaves chat mode.
  Both pause and suspend are needed because some functionalities run in infinite loops and keep sending movement key presses that would
  mess the chat text message.

FIXES
- fix of an annoyance regarding the switching of toolbar items. In my opinion, the game should cancel the actual tool use and switch to the
  new tool the user does select (by pressing a key from 1,2,...,9,0) whenever a new tool is selected. Instead, the game kind of prevents
  the change as long as the current tool is in use. This script does try to cancel tool use and force a tool change.

- added preemptive stop and restart of tools in some functionalities, to prevent drills from stopping working on their own.

NOTE
- you should suspend the script when creating a new character or world, and when entering IP address info at beginning of multiplayer games,
  so that you are not triggering hotkeys and mess up the text you enter...
- you should refrain from using the ENTER key when finishing entering IP address, or character or world names,
  as pressing ENTER will toggle on/off the entire script each time. This is because ENTER is the key used to enter/end chat mode
  in multiplayer. When you are done entering IP address, or names,  use the Accept button instead.

TROUBLESHOOTING THE TUNNELING functionality:
  1. Make sure the pick is the selected item in the Toolbar
  2. If using the tunnel lining feature, make sure you customized the keyToolbarItemPick and keyToolbarItemWithMaterial variables
  3. If using the safety net feature, make sure the character is equipped with the Toolbelt item
  4. Make sure you properly positionned both the character and the mouse cursor, before starting the tunneling. Experiment!
  5. If the tools leave some gaps, miss some spots, try:
      - make the delays longer via [insert] or [right Alt] functionality
      - or start over again by modifying sligthly the starting position of character and mouse cursor
      - or redo the calibration
  6. If the digging is way too slow, make the delays shorter via [delete] or [right Alt] functionality
  7. Things that will mess up tunneling: monsters attacks, sand/silt blocks, too much water, lava !!!

Generally, there is a nice interaction between the various functionalities, as much as was possible to provide. The most common interactions
being:
  -the activation of a functionality canceling other functionalities automatically.
  -clicking left mouse button stops all continuous/automated functionalities, excepted autorun.
  -autorun does coexist well with autoattack [Mouse button 5] and continuous tool use [Mouse button 4]

*/


; +++++++++++++++++++++	BEGINNING OF CUSTOMIZE SECTION ++++++++++++++++++

; ++++++++++++++++++++ CUSTOMIZE YOUR KEYBINDINGS ++++++++++++++++++++++
; For a list of the keys that can be used, see http://www.autohotkey.com/docs/KeyList.htm

; MAKE SURE THE 4 FOLLOWING KEYBINDINGS ARE THE SAME AS THE MOVEMENT KEYS YOU ASSIGNED IN THE GAME
keyMoveLeft:="a"					;Movement key monitored to cancel autorun mode
keyMoveRight:="d"					;Movement key monitored to cancel autorun mode
keyMoveUp:="w"						;Movement key monitored to cancel autorun mode
keyMoveDown:="s"					;Movement key monitored to cancel autorun mode

; MAKE SURE THE FOLLOWING KEYBINDING IS THE SAME AS THE KEYBIND YOU USE TO THROW THE GRAPPLE
keyGrapple:="f"						;key to send a grapple

keyAutorunLeft:="q"					;Toggle autorun toward left
keyAutorunRight:="e"				;Toggle autorun toward right

keyAutoAttack:="XButton2"			;Key to toggle autoattack for weapons that dont normally have autoattack in game, set to Mouse Button 5

keyUseTool:="XButton1"				;Key to toggle continous tool usage mode, set to Mouse Button 4 by default

keyMultiLayerLeftToolUse:="z"		;Key to toggle MultiLayer tool usage mode while moving toward left at a specific walk speed
keyMultiLayerRightToolUse:="x"		;Key to toggle MultiLayer tool usage mode while moving toward right at a specific walk speed

keyTunnelingLeftToolUse:="Left"		;Key to toggle continous tunneling mode while moving toward left at a specific walk speed
keyTunnelingRightToolUse:="Right"	;Key to toggle continous tunneling mode while moving toward right at a specific walk speed
keyTunnelingDownToolUse:="Down"		;Key to toggle continous tunneling mode while moving down
;keyBlockSizeCalibration:="Backspace"	;Key used to calibrate the blocks size, must be performed before tunneling functionality can be used
keyTunnelingNumberBlocks:="RCtrl"	;User has 2 seconds to select height/width of tunnels (for tunneling mode) by choosing from 1,2,..5
keySafetyNet:="NumpadClear"			;Key to toggle safety net feature when tunneling down. Requires Toolbelt item to be equipped.

keyTunnelLiningTop:="NumpadUp"		;key to toggle digging and lining with a specific material, the top of horizontal tunnels
keyTunnelLiningFloor:="NumpadDown"	;key to toggle digging and lining with a specific material, the floor of horizontal tunnels
keyTunnelLiningLeft:="NumpadLeft"	;key to toggle digging and lining with a specific material, the left of vertical tunnels
keyTunnelLiningRight:="NumpadRight"	;key to toggle digging and lining with a specific material, the right of vertical tunnels

keyAugmentDelay:="Insert"			;Key to select next higher delay
keyDecreaseDelay:="Delete"			;Key to select previous lower delay
keySelectDelay:="RAlt"				;User has 2 seconds to select a new delay by choosing from 1,2,...9,0 (0 treated as 10)
                  ;	For those 3 keys that are modifying delays, they can affect the delays of various functionalities

keyQuickStack:="r"					;Key to send click to the Quick Stack menu button when checking chest content
keyMultiQuickStack1:="y"			;Key to send multiple Quick Stack clicks from a single position in the middle of chests
keyMultiQuickStack2:="u"			;Key to send multiple Quick Stack clicks from a single position in the middle of chests, for different layout of chests

keySellInventory:="i"				;Key to send cyclical sell clicks from inventory

keySaveConfig:=";"					;Key to save some settings to an .ini file. Settings are loaded upon script start.

keySuspend:="RShift"				;Suspend script hotkeys (script stops responding to keystrokes, excepted the suspend key)
keyPause:="p"						;Pause script

; +++++++++++++++++++++ CUSTOMIZE OTHER SETTINGS +++++++++++++++++++++++

;MAKE SURE THE 2 FOLLOWING VARIABLES ARE ASSIGNED THE TOOLBAR ITEM NUMBER THAT YOU WANT TO BE USED, FOR THE TUNNELING
keyToolbarItemPick=2											;default toolbar item slot that holds the pick tool
keyToolbarItemWithMaterial=7									;default toolbar item slot that holds material for the tunnel lining

;LOWER THESE 2 VALUES BY A FACTOR OF ONE, IF YOU DO WANT THE BENEFIT OF THE SAFETY NET FUNCTIONALITY, BUT WITHOUT THE NEED TO EQUIP THE TOOLBELT ITEM.
;DO NOTE that this will make the pick tool dig one less block in depth (horizontal or vertical), so it will not be as efficient.
;Reach of Pick tool
nHorzReach=5													;default (5) horizontal reach used by the pick, when removing several columns of material in the tunneling functionalities
nVertReach=3													;default (3) vertical reach used by the pick, when removing several columns of material in the tunneling functionalities

;Quick Stack menu button coordinates
xQuickStack=0													;x coordinate for Quick Stack menu button when checking chest content
yQuickStack=0													;y coordinate for Quick Stack menu button when checking chest content

;Dimensions of a game block
nVertToolOffset:=15												;default (16) height of a block
nHorzToolOffset:=15												;default (16) width of a block

;AutoAttack related numbers
delayValues=10,20,30,40,50,75,100,150,200,250					;List of delays used to tweak the weapon autoattack speed (see keySelectDelay)
delayDuration=50												;default value taken from the delayValues list

;MultiLayer and Tunneling related numbers
delayMultiLayerValues=25,50,75,100,200,300,400,500,750,1000		;List of delays used to tweak the MultiLayer tool use walking speed (see keySelectDelay)
delayMultiLayerToolUse=200										;default value taken from the delayMultiLayerValues list
delayTunnelingValues=25,50,75,100,200,300,400,500,750,1000		;List of delays used to tweak the time spent by the pick on each block, when tunneling
nTunnelingDelayPerBlock=200										;default value taken from the delayTunnelingValues list
nTunnelHeight=3													;default height (in blocks) of horizontal tunnels
nTunnelWidth=2													;default width (in blocks) of vertical tunnels
nMultiLayerHeight=3												;default number of layers (in blocks) affected by the MultiLayer tool

; ++++++++++++++++++++ END OF CUSTOMIZE SECTION ++++++++++++++++++++++++


; Some internal keys

keyRightClick:="RButton"			;Right mouse button monitored during setup of multiple quick stack feature
keyLeftClick:="LButton"				;Left mouse button monitored to cancel usage of most features
keyChat:="Enter"					;Key to enter and leave chat mode, used to pause and suspend script and hotkeys when user gets in chat mode in multiplayer

KeyNum1:="1"						;Toolbar key monitored to cancel usage of most features
KeyNum2:="2"						;Toolbar key monitored to cancel usage of most features
KeyNum3:="3"						;Toolbar key monitored to cancel usage of most features
KeyNum4:="4"						;Toolbar key monitored to cancel usage of most features
KeyNum5:="5"						;Toolbar key monitored to cancel usage of most features
KeyNum6:="6"						;Toolbar key monitored to cancel usage of most features
KeyNum7:="7"						;Toolbar key monitored to cancel usage of most features
KeyNum8:="8"						;Toolbar key monitored to cancel usage of most features
KeyNum9:="9"						;Toolbar key monitored to cancel usage of most features
KeyNum0:="0"						;Toolbar key monitored to cancel usage of most features


;Dynamically create the Hotkeys, based on the keybindings
; Hotkeys active only when Terraria is the active app.
;		Note: cannot seem to be able to use ahk_class as a restriction on which apps the script works, since the class changes with computers, in my tests.
;		Instead, I restrict the windows in which the script will work via SetTitleMatchMode, 1
;		Combining   < SetTitleMatchMode, 1 > AND < requiring the window title to begin with: Terraria >  seems to work nicely
HotKey, IfWinActive, Terraria

Hotkey, % "*" keyAutoAttack, AutoAttack
Hotkey, % "*" keyUseTool, UseTool

Hotkey, % "*" keyMultiLayerLeftToolUse, MultiLayerLeftToolUseStart
Hotkey, % "*" keyMultiLayerRightToolUse, MultiLayerRightToolUseStart

Hotkey, % "*" keyTunnelingLeftToolUse, TunnelingLeftToolUseStart
Hotkey, % "*" keyTunnelingRightToolUse, TunnelingRightToolUseStart
Hotkey, % "*" keyTunnelingDownToolUse, TunnelingDownToolUseStart

Hotkey, % "*" keyTunnelLiningTop, TunnelLiningTop
Hotkey, % "*" keyTunnelLiningFloor, TunnelLiningFloor
Hotkey, % "*" keyTunnelLiningLeft, TunnelLiningLeft
Hotkey, % "*" keyTunnelLiningRight, TunnelLiningRight
Hotkey, % "*" keySafetyNet, SafetyNet
Hotkey, % "*" keyTunnelingNumberBlocks, SetTunnelingNumberBlocks
;Hotkey, % "*" keyBlockSizeCalibration, BlockSizeCalibration

Hotkey, % "*" keyAugmentDelay, AugmentDelay
Hotkey, % "*" keyDecreaseDelay, DecreaseDelay
Hotkey, % "*" keySelectDelay, SetDelay

Hotkey, % "*" keyAutorunLeft, AutorunLeft
Hotkey, % "*" keyAutorunRight, AutorunRight
Hotkey, % "*~" keyMoveLeft, MoveLeft
Hotkey, % "*~" keyMoveRight, MoveRight
Hotkey, % "*~" keyMoveUp, MoveUp
Hotkey, % "*~" keyMoveDown, MoveDown

Hotkey, % "*~" KeyNum1, Num1
Hotkey, % "*~" KeyNum2, Num2
Hotkey, % "*~" KeyNum3, Num3
Hotkey, % "*~" KeyNum4, Num4
Hotkey, % "*~" KeyNum5, Num5
Hotkey, % "*~" KeyNum6, Num6
Hotkey, % "*~" KeyNum7, Num7
Hotkey, % "*~" KeyNum8, Num8
Hotkey, % "*~" KeyNum9, Num9
Hotkey, % "*~" KeyNum0, Num0

Hotkey, % "^" keyQuickStack, CalibrateQuickStack
Hotkey, % "*" keyQuickStack, QuickStack
Hotkey, % "^" keyMultiQuickStack1, SetupMultiQuickStack1
Hotkey, % "*" keyMultiQuickStack1, MultiQuickStack1
Hotkey, % "^" keyMultiQuickStack2, SetupMultiQuickStack2
Hotkey, % "*" keyMultiQuickStack2, MultiQuickStack2

Hotkey, % "^" keySellInventory, SetupSellInventory
Hotkey, % "*" keySellInventory, SellInventory
Hotkey, % "^" keyGrapple, PositionCursorForStableGrapple
Hotkey, % "*~" keyGrapple, Grapple

Hotkey, % "*~" keyRightClick, SpecialRightClick
Hotkey, % "*~" keyLeftClick, SpecialLeftClick

Hotkey, % "*" keySaveConfig, SaveConfig

Hotkey, % "*~" keyChat, Chat

;We want those 2 hotkeys to be accessible even when Terraria is not the active application
HotKey, IfWinActive
Hotkey, % "*" keySuspend, SuspendHotkeys
Hotkey, % "*" keyPause, PauseScript



;Initialization of variables
messageRButton:="RButton"
messageLButton:="LButton"
bAutorunLeft:=false
bAutorunRight:=false
bChoosingNewDelay:=false
bBlockLeftMouseInput:=false
numberBlocksValues=1,2,3,4,5,6,7,8,9
bTunnelLiningTop:=false
bTunnelLiningFloor:=false
bTunnelLiningLeft:=false
bTunnelLiningRight:=false
bSafetyNet:=false
stateInactive:=0
statePreview:=1
stateActivating:=2
stateActive:=3
toolMLeftState:=stateInactive
toolMRightState:=stateInactive
toolTLeftState:=stateInactive
toolTRightState:=stateInactive
toolTDownState:=stateInactive
enumFeatureNone:=0
enumFeatureAutoAttack:=1
enumFeatureUseTool:=2
enumFeatureMultiLayerLeft:=3
enumFeatureMultiLayerRight:=4
enumFeatureTunnelingLeft:=5
enumFeatureTunnelingRight:=6
enumFeatureTunnelingDown:=7
enumFeatureMultiQuickStack:=8
enumFeatureSellInventory:=9
nActiveFeature:=0

nSetupMultiQuickStack:=0
arrayMultiQuickStack1_0_0:=0			;Initialize the size of the array to zero
arrayMultiQuickStack2_0_0:=0			;Initialize the size of the array to zero

bSetupSellInventory:=false
nSellInventoryXPos:=0
nSellInventoryYPos:=0
nSellInventoryXInc:=0
nSellInventoryYInc:=0

bPositioningCursorForStableGrapple:=false
nGrappleXPos:=0
nGrappleYPos:=0

StringSplit, arrayDelays, delayValues, `,
StringSplit, arrayDelaysMultiLayer, delayMultiLayerValues, `,
StringSplit, arrayNumberBlocks, numberBlocksValues, `,
StringSplit, arrayDelaysTunneling, delayTunnelingValues, `,

Gosub, ReadConfig	;Initialize some variables/arrays from TerrariaAHKScriptConfig.ini

return	; End of Auto-execute section

;=====================================================================================

SetActiveFeature(nFeature, bException = false)
{
  global nActiveFeature
  global enumFeatureAutoAttack
  global enumFeatureUseTool
  global enumFeatureSellInventory
  global enumFeatureNone
  global messageLButton
  global nGrappleXPos
  global nGrappleYPos

  ;If trying to set active feature to None, AND exception flag is turned on
  if( (nFeature = enumFeatureNone) and (bException = true))
  {
    ;If current feature is AutoAttack or UseTool, do nothing
    ;For the other cases, proceed to update the active feature
    ;Goal of this exception case, is to let basic move features (like autorun) to coexist well with other basic features like autoattack
    if((nActiveFeature != enumFeatureAutoAttack) and (nActiveFeature != enumFeatureUseTool))
    {
      nActiveFeature:= nFeature
    }
  }
  else	;set active feature, for all other cases
  {
    ;Special case for feature UseTool, as it is not relying on an infinite loop with a break condition, unlike most other features
    ;	Because of this difference, we are forced to execute special 'end' code in this function.
    if(nActiveFeature = enumFeatureUseTool)
    {
      send {%messageLButton% Up}
      sleep 200 			;Force some delay, in case a %messageLButton% Down message is sent again very soon in the script
    }
    else if(nActiveFeature = enumFeatureSellInventory)
    {
      ;Special case for the automated cyclic sell inventory feature
      ;Reset grapple positioning
      nGrappleXPos:=0
      nGrappleYPos:=0
    }

    nActiveFeature:= nFeature	;Set the new active feature
  }

  return
}


UseTool:
{
  ; If some feature other than UseTool was active, just cancel it and exit
  if( (nActiveFeature != enumFeatureUseTool) and (nActiveFeature != enumFeatureNone) )
  {
    SetActiveFeature(enumFeatureNone)
  }
  else	;Toggle on/off the continuous tool use, through Left Mouse Button messages
  {
    if(nActiveFeature = enumFeatureUseTool)
    {
      send {%messageLButton% Up}
      nActiveFeature:=enumFeatureNone
    }
    else
    {
      send {%messageLButton% Down}
      nActiveFeature:=enumFeatureUseTool
    }
  }

  return
}


AutoAttack:
{
  ;If AutoAttack already active, toggle it off
  if(nActiveFeature = enumFeatureAutoAttack)
  {
    SetActiveFeature(enumFeatureNone)
  }
  else ;Start AutoAttack
  {
    SetActiveFeature(enumFeatureAutoAttack)

    Loop	;Infinite loop
    {
      if(nActiveFeature != enumFeatureAutoAttack)
      {
        break
      }
      Send {%messageLButton% Down}
      sleep 10
      Send {%messageLButton% Up}

      sleep delayDuration
    }
  }

  return
}


MultiLayerLeftToolUseStart:
{
  if(toolMLeftState = stateActive)	;state Active + hotkey again = disactivate
  {
    toolMLeftState:=stateInactive	;Modify state of original thread and terminate this new thread
    return
  }

  if(toolMLeftState = statePreview)	;state Preview + hotkey again = prepare to activate
  {
    toolMLeftState:=stateActivating	;Modify state of original thread and terminate this new thread
    return
  }

  if(toolMLeftState = stateActivating)	;state Activating -> reset some variables and restart thread in Active mode
  {
    toolMLeftState:=stateActive
    MouseMove, xposInitial, yposInitial	;Reset mouse position
  }

  if(toolMLeftState = stateInactive)
  {
    toolMLeftState:=statePreview		;state Inactive + hotkey = start thread in Preview mode

    ; If actually using the MultiLayer right tool function, just cancel it and exit
    if(nActiveFeature = enumFeatureMultiLayerRight)
    {
      SetActiveFeature(enumFeatureNone)
      toolMLeftState:=stateInactive	;Reset this tool to inactive state
      return
    }

    Gosub, CancelAutorun
  }

  SetActiveFeature(enumFeatureMultiLayerLeft)


  if(toolMLeftState != statePreview)	;Dont do the digging in Preview mode
  {
    send {%messageLButton% Down}
  }

  nNumberBlocksRemoved:=0

  MouseGetPos, xposInitial, yposInitial ;Record initial Y position of mouse

  Loop	;Infinite loop
  {
    ;Verify if tool usage or state has changed
    if ( (nActiveFeature != enumFeatureMultiLayerLeft) or (toolMLeftState = stateInactive)) ; break the loop and exit
    {
      toolMLeftState:=stateInactive
      break
    }
    else if(toolMLeftState = stateActivating)
    {
      goto, MultiLayerLeftToolUseStart	;Start again in Active mode
    }

    sleep delayMultiLayerToolUse	; Let the tool work for some time
    nNumberBlocksRemoved++

    ;Iterate for each block in a given column
    Loop, % nMultiLayerHeight - 1
    {
      ;Verify if tool usage or state has changed
      if ((nActiveFeature != enumFeatureMultiLayerLeft)  or (toolMLeftState = stateInactive)) ; break the loop
      {
        toolMLeftState:=stateInactive
        break
      }
      else if(toolMLeftState = stateActivating)
      {
        goto, MultiLayerLeftToolUseStart	;Start again in Active mode
      }

      MouseMove, 0, -nVertToolOffset, , R	; Move the tool upward by one block

      sleep delayMultiLayerToolUse	; Let the tool work for some time
      nNumberBlocksRemoved++
    }

    ;Verify if tool usage or state has changed
    if ((nActiveFeature != enumFeatureMultiLayerLeft)  or (toolMLeftState = stateInactive)) ; break the loop and exit
    {
      toolMLeftState:=stateInactive
      break
    }
    else if(toolMLeftState = stateActivating)
    {
      goto, MultiLayerLeftToolUseStart	;Start again in Active mode
    }

    if (nMultiLayerHeight > 1)
    {
      MouseMove, xposInitial, yposInitial
    }

    if(toolMLeftState != statePreview)	;Dont move the character in Preview mode
    {
      send {%keyMoveLeft% Down}
      sleep 250
      send {%keyMoveLeft% Up}


      ;Code to prevent drills from stopping working on their own, we stop and restart them preemptively!
      if(nNumberBlocksRemoved > 100)
      {
        nNumberBlocksRemoved:=0
        send {%messageLButton% Up}
        sleep 100
        send {%messageLButton% Down}
      }
    }
  }

  send {%messageLButton% Up}

  if(nActiveFeature = enumFeatureMultiLayerLeft)
    SetActiveFeature(enumFeatureNone)

  return
}


MultiLayerRightToolUseStart:
{
  if(toolMRightState = stateActive)	;state Active + hotkey again = disactivate
  {
    toolMRightState:=stateInactive	;Modify state of original thread and terminate this new thread
    return
  }

  if(toolMRightState = statePreview)	;state Preview + hotkey again = prepare to activate
  {
    toolMRightState:=stateActivating	;Modify state of original thread and terminate this new thread
    return
  }

  if(toolMRightState = stateActivating)	;state Activating -> reset some variables and restart thread in Active mode
  {
    toolMRightState:=stateActive
    MouseMove, xposInitial, yposInitial	;Reset mouse position
  }

  if(toolMRightState = stateInactive)
  {
    toolMRightState:=statePreview		;state Inactive + hotkey = start thread in Preview mode

    ; If actually using the MultiLayer left tool function, just cancel it and exit
    if(nActiveFeature = enumFeatureMultiLayerLeft)
    {
      SetActiveFeature(enumFeatureNone)
      toolMRightState:=stateInactive	;Reset this tool to inactive state
      return
    }

    Gosub, CancelAutorun
  }

  SetActiveFeature(enumFeatureMultiLayerRight)

  if(toolMRightState != statePreview)	;Dont do the digging in Preview mode
  {
    send {%messageLButton% Down}
  }

  nNumberBlocksRemoved:=0

  MouseGetPos, xposInitial, yposInitial ;Record initial Y position of mouse

  Loop	;Infinite loop
  {
    ;Verify if tool usage or state has changed
    if ( (nActiveFeature != enumFeatureMultiLayerRight) or (toolMRightState = stateInactive)) ; break the loop and exit
    {
      toolMRightState:=stateInactive
      break
    }
    else if(toolMRightState = stateActivating)
    {
      goto, MultiLayerRightToolUseStart	;Start again in Active mode
    }

    sleep delayMultiLayerToolUse	; Let the tool work for some time
    nNumberBlocksRemoved++

    ;Iterate for each block in a given column
    Loop, % nMultiLayerHeight - 1
    {
      ;Verify if tool usage or state has changed
      if ( (nActiveFeature != enumFeatureMultiLayerRight) or (toolMRightState = stateInactive)) ; break the loop
      {
        toolMRightState:=stateInactive
        break
      }
      else if(toolMRightState = stateActivating)
      {
        goto, MultiLayerRightToolUseStart	;Start again in Active mode
      }

      MouseMove, 0, -nVertToolOffset, , R	; Move the tool upward by one block

      sleep delayMultiLayerToolUse	; Let the tool work for some time
      nNumberBlocksRemoved++
    }

    ;Verify if tool usage or state has changed
    if ( (nActiveFeature != enumFeatureMultiLayerRight) or (toolMRightState = stateInactive)) ; break the loop and exit
    {
      toolMRightState:=stateInactive
      break
    }
    else if(toolMRightState = stateActivating)
    {
      goto, MultiLayerRightToolUseStart	;Start again in Active mode
    }

    if (nMultiLayerHeight > 1)
    {
      MouseMove, xposInitial, yposInitial
    }

    if(toolMRightState != statePreview)	;Dont move the character in Preview mode
    {
      send {%keyMoveRight% Down}
      sleep 250
      send {%keyMoveRight% Up}


      ;Code to prevent drills from stopping working on their own, we stop and restart them preemptively!
      if(nNumberBlocksRemoved > 100)
      {
        nNumberBlocksRemoved:=0
        send {%messageLButton% Up}
        sleep 100
        send {%messageLButton% Down}
      }
    }
  }

  send {%messageLButton% Up}

  if(nActiveFeature = enumFeatureMultiLayerRight)
    SetActiveFeature(enumFeatureNone)

  return
}


TunnelingDownToolUseStart:
{
  if((nHorzToolOffset = 0) or (nVertToolOffset = 0))	;Calibration must have been done first
    return

  if(toolTDownState = stateActive)	;state Active + hotkey again = disactivate
  {
    toolTDownState:=stateInactive	;Modify state of original thread and terminate this new thread
    return
  }

  if(toolTDownState = statePreview)	;state Preview + hotkey again = prepare to activate
  {
    toolTDownState:=stateActivating	;Modify state of original thread and terminate this new thread
    return
  }

  if(toolTDownState = stateActivating)	;state Activating -> reset some variables and restart original thread in Active mode
  {
    toolTDownState:=stateActive
    MouseMove, xposInitial, yposInitial	;Reset mouse position
  }

  if(toolTDownState = stateInactive)
  {
    toolTDownState:=statePreview		;state Inactive + hotkey = start thread in Preview mode, this is the original thread

    ; If actually using other Tunneling tool functions, just cancel it and exit
    if( (nActiveFeature = enumFeatureTunnelingLeft) or (nActiveFeature = enumFeatureTunnelingRight) )
    {
      SetActiveFeature(enumFeatureNone)
      toolTDownState:=stateInactive	;Reset this tool to inactive state
      return
    }

    Gosub, CancelAutorun
  }

  SetActiveFeature(enumFeatureTunnelingDown)

  MouseGetPos, xposInitial, yposInitial

  ; Initialize some dynamic variables
  nLastColToDig:= 1
  nBeforeLastColToDig:= 2
  bCurrentToolIsPick:=true


  Loop	;Infinite loop
  {
    MouseGetPos, xposCurrent, yposCurrent


    ;Block of code related to ensuring the character always have a block beneath his feet
    ;	Necessitates the use of the Toolbelt item, which gives +1 reach for putting blocks
    ;	Code will lay down a column of 4 blocks heigth, so that the character can stand
    ;	on the lowest one when the usual layer of 3 blocks is dug
    if (bSafetyNet = true)
    {
      ;If not already done, switch tools to the block laying tool
      if(bCurrentToolIsPick = true)
      {
        if(toolTDownState != statePreview)	;Dont switch tools in Preview mode
        {
          ;Switch tools
          sleep 400	; Requires a certain delay before game is ready to accept an actual toolbar item change

          send {%keyToolbarItemWithMaterial% Down} ;Switch to toolbar item with lining material
          sleep 20
          send {%keyToolbarItemWithMaterial% Up}

          sleep 100
          bCurrentToolIsPick:= false
        }
      }

      ; Move mouse cursor to the before last to be dug column
      MouseMove, (xposInitial + ((nBeforeLastColToDig-1) * nHorzToolOffset)), yposCurrent

      if(toolTDownState != statePreview)	;Dont do the laying in Preview mode
      {
        send {%messageLButton% Down}	;Start laying lining
      }

      ;Iterate for each block in a given column (4 blocks deep per column)
      Loop, 3
      {
        sleep 100							; Let the tool work for some time
        MouseMove, 0, nVertToolOffset, , R	; Move the tool downward by one block
      }

      sleep 100								; Let the tool work for some time

      ;Dont end the laying in Preview mode
      if(toolTDownState != statePreview)
      {
        send {%messageLButton% Up}		;Stop laying lining

        sleep 100
      }
    }

    if(toolTDownState != statePreview)	;Dont switch tools in Preview mode
    {
      ;Block of code to ensure we switch back to the pick tool
      if((bCurrentToolIsPick = false) and (nActiveFeature = enumFeatureTunnelingDown))
      {
        ;Switch tool back to pick
        sleep 400	; Requires a certain delay before game is ready to accept an actual toolbar item change

        send {%keyToolbarItemPick% Down} ;Switch to toolbar item with pick
        sleep 20
        send {%keyToolbarItemPick% Up}

        sleep 100

        bCurrentToolIsPick:= true
      }
    }

    ;Verify if tool usage or state has changed
    if ( (nActiveFeature != enumFeatureTunnelingDown) or (toolTDownState = stateInactive)) ; break the main loop and exit
    {
      toolTDownState:=stateInactive
      break
    }
    else if(toolTDownState = stateActivating)
    {
      goto, TunnelingDownToolUseStart	;Start again in Active mode
    }

    ;Dont do the main digging script when in Preview mode
    if(toolTDownState != statePreview)
    {
      ;Initialize first column to be dug as the rightmost one
      nStartingColToDig:=  nTunnelWidth + bTunnelLiningRight

      ;Special case when shaft is only 2 blocks wide
        ;need this code because of the MouseMove code, where we position the cursor at proper initial position for digging
      if(nStartingColToDig < 3)
        nStartingColToDig:=nBeforeLastColToDig

      ; Move mouse cursor to first column of shaft to be dug, and 3 blocks down in depth
      MouseMove, (xposInitial + ((nStartingColToDig-1) * nHorzToolOffset)), (yposCurrent + ((nVertReach - 1) * nVertToolOffset))

      ; Begin the digging
      send {%messageLButton% Down}


      ;Block of code to determine digging order of columns
      {
        nIndex:=1

        if(bTunnelLiningRight = true)			;If right side lining is present, its the first column that will be dug
        {
          arrayCol%nIndex%:= nTunnelWidth + bTunnelLiningRight
          nIndex++
        }

        Loop, % nTunnelWidth-2					;Next candidates are the columns to the right of the first 2 columns (those 2 have a special status)
        {
          arrayCol%nIndex%:= nTunnelWidth + 1 - A_Index
          nIndex++
        }

        if(bTunnelLiningLeft = true)			;Next candidate is the left side lining, if present
        {
          arrayCol%nIndex%:= 0
          nIndex++
        }

        arrayCol%nIndex%:= nBeforeLastColToDig	;Then, one of the alternating columns
        nIndex++

        arrayCol%nIndex%:= nLastColToDig		;Finally, the other alternating column

        arrayCol0:= nIndex						;Put the size of the array at index 0 of arrayCol
      }


      ;Block of code to dig all the columns of the shaft
      {
        ;Iterate each column, in the order determined by the array that was filled in previous step
        Loop, % arrayCol0
        {
          ;Verify if tool usage or state has changed
          if ( (nActiveFeature != enumFeatureTunnelingDown) or (toolTDownState = stateInactive)) ; break the loop
          {
            toolTDownState:=stateInactive
            break
          }
          else if(toolTDownState = stateActivating)
          {
            goto, TunnelingDownToolUseStart	;Start again in Active mode
          }

          ; Move mouse cursor to current column of shaft to be dug, and 3 blocks down in depth (or less if customized)
          MouseMove, (xposInitial + ((arrayCol%A_Index%-1) * nHorzToolOffset)), (yposCurrent + ((nVertReach - 1) * nVertToolOffset))

          sleep nTunnelingDelayPerBlock	; Give additionnal time for tool to work, after a big cursor move

          ;Iterate for each block in a given column (3 blocks deep per column, or less if customized)
          Loop, % nVertReach - 1
          {
            ;Verify if tool usage or state has changed
            if ( (nActiveFeature != enumFeatureTunnelingDown) or (toolTDownState = stateInactive)) ; break the loop
            {
              toolTDownState:=stateInactive
              break
            }
            else if(toolTDownState = stateActivating)
            {
              goto, TunnelingDownToolUseStart	;Start again in Active mode
            }

            sleep nTunnelingDelayPerBlock	; Let the tool work for some time

            MouseMove, 0, -nVertToolOffset, , R	; Move the tool upward by one block
          }

          sleep nTunnelingDelayPerBlock	; Let the tool work for some time

        }
      }


      send {%messageLButton% Up}	;Stop digging

      ;Verify if tool usage or state has changed
      if ( (nActiveFeature != enumFeatureTunnelingDown) or (toolTDownState = stateInactive)) ; break the main loop and exit
      {
        toolTDownState:=stateInactive
        break
      }
      else if(toolTDownState = stateActivating)
      {
        goto, TunnelingDownToolUseStart	;Start again in Active mode
      }
    }
    else	;Do a modified pattern for the Preview mode
    {
      ; Move mouse cursor to first column of shaft to be dug
      MouseMove, (xposInitial + (-bTunnelLiningLeft * nHorzToolOffset)), yposInitial

      Loop, % nTunnelWidth + bTunnelLiningLeft + bTunnelLiningRight -1
      {
        ;Verify if tool usage or state has changed
        if ( (nActiveFeature != enumFeatureTunnelingDown) or (toolTDownState = stateInactive)) ; break the loop
        {
          toolTDownState:=stateInactive
          break
        }
        else if(toolTDownState = stateActivating)
        {
          goto, TunnelingDownToolUseStart	;Start again in Active mode
        }

        sleep nTunnelingDelayPerBlock	; Let the tool work for some time

        MouseMove, nHorzToolOffset, 0, , R	; Move the tool to the right by one block
      }

      sleep nTunnelingDelayPerBlock	; Let the tool work for some time
    }

    ;Block of code that deals with putting on the lining on the left and right sides, if option is selected
    if((bTunnelLiningLeft = true) or (bTunnelLiningRight = true))
    {
      MouseGetPos, xposPick, yposPick

      if(toolTDownState != statePreview)	;Dont switch tools in Preview mode
      {
        ;Switch tools
        sleep 400	; Requires a certain delay before game is ready to accept an actual toolbar item change

        send {%keyToolbarItemWithMaterial% Down} ;Switch to toolbar item with lining material
        sleep 20
        send {%keyToolbarItemWithMaterial% Up}

        sleep 200

        bCurrentToolIsPick:= false
      }

      ;Determine with which column to begin; we always begin with the right side, if that side is getting filled with lining
      if(bTunnelLiningRight = true)
      {
        nColToFill:= arrayCol1	;The column number of the right side lining (if present)is always in the array at position 1
      }
      else
      {
        nColToFill:= 0			;The column number of the left side lining is always the value zero
      }


      ;Put the lining on
      Loop, % bTunnelLiningRight + bTunnelLiningLeft 	;Loop once or twice, depending on the booleans corresponding to each side
      {
        ;Verify if tool usage or state has changed
        if ( (nActiveFeature != enumFeatureTunnelingDown) or (toolTDownState = stateInactive)) ; break the loop
        {
          toolTDownState:=stateInactive
          break
        }
        else if(toolTDownState = stateActivating)
        {
          goto, TunnelingDownToolUseStart	;Start again in Active mode
        }

        ;Dont do the laying and normal mouse move when in Preview mode
        if(toolTDownState != statePreview)
        {
          ; Move mouse cursor to column of lining at previous altitude of character
          ; Do note here, that character does not fall in the screen, its rather the world that moves up!
          MouseMove, (xposInitial + ((nColToFill - 1) * nHorzToolOffset)), (yposCurrent - (nVertReach  * nVertToolOffset))

          send {%messageLButton% Down}	;Start laying lining
        }
        else	;Do a modified mouse move for Preview mode
        {
          MouseMove, (xposInitial + ((nColToFill - 1) * nHorzToolOffset)), yposInitial
        }

        ;Iterate for each block in a given column (3 blocks deep per column, or less if customized)
        Loop, % nVertReach - 1
        {
          sleep 100							; Let the tool work for some time
          MouseMove, 0, nVertToolOffset, , R	; Move the tool downward by one block
        }

        sleep 100								; Let the tool work for some time

        ;Dont end the laying when in Preview mode
        if(toolTDownState != statePreview)
        {
          send {%messageLButton% Up}	;Stop laying lining

          sleep 200
        }

        nColToFill:= 0			;Update the position of column to fill to zero, as its always the position of the left side lining
                    ;If there is a second iteration in this loop, we will thus have the correct position for the second iteration
      }

      ;NOTE: there is no switch back to the pick tool at this point, because the block laying tool might still be needed at the beginning of the
      ;			next iteration, for laying down the 'safety net'. The pick tool will be selected back, after that point.

      MouseMove, xposPick, yposPick, , 	; Move the mouse cursor back to its previous position
    }

    ;Verify if tool usage or state has changed
    if ( (nActiveFeature != enumFeatureTunnelingDown) or (toolTDownState = stateInactive)) ; break the main loop and exit
    {
      toolTDownState:=stateInactive
      break
    }
    else if(toolTDownState = stateActivating)
    {
      goto, TunnelingDownToolUseStart	;Start again in Active mode
    }

    sleep 200	;Give little bit extra time for character to fall down for cases where we just dig very fast


    ; Modify some dynamic variables, to reverse dig order of 2 leftmost columns in next iteration
    nTemp:= nLastColToDig
    nLastColToDig:= nBeforeLastColToDig
    nBeforeLastColToDig:= nTemp
  }

  if(nActiveFeature = enumFeatureTunnelingDown)
    SetActiveFeature(enumFeatureNone)

  return
}


TunnelingLeftToolUseStart:
{
  if(nVertToolOffset = 0)	;Calibration must have been done first
    return

  if(toolTLeftState = stateActive)	;state Active + hotkey again = disactivate
  {
    toolTLeftState:=stateInactive	;Modify state of original thread and terminate this new thread
    return
  }

  if(toolTLeftState = statePreview)	;state Preview + hotkey again = prepare to activate
  {
    toolTLeftState:=stateActivating	;Modify state of original thread and terminate this new thread
    return
  }

  if(toolTLeftState = stateActivating)	;state Activating -> reset some variables and restart original thread in Active mode
  {
    toolTLeftState:=stateActive
    MouseMove, xposInitial, yposInitial	;Reset mouse position
  }

  if(toolTLeftState = stateInactive)
  {
    toolTLeftState:=statePreview		;state Inactive + hotkey = start thread in Preview mode, this is the original thread

    ; If actually using other Tunneling tool functions, just cancel it and exit
    if( (nActiveFeature = enumFeatureTunnelingDown) or (nActiveFeature = enumFeatureTunnelingRight) )
    {
      SetActiveFeature(enumFeatureNone)
      toolTLeftState:=stateInactive	;Reset this tool to inactive state
      return
    }

    Gosub, CancelAutorun
  }

  SetActiveFeature(enumFeatureTunnelingLeft)

  MouseGetPos, xposInitial, yposInitial ;Record initial Y position of mouse


  Loop	;Infinite loop
  {
    MouseGetPos, xposCurrent, yposCurrent

    ;Verify if tool usage or state has changed
    if ( (nActiveFeature != enumFeatureTunnelingLeft) or (toolTLeftState = stateInactive)) ; break the main loop and exit
    {
      toolTLeftState:=stateInactive
      break
    }
    else if(toolTLeftState = stateActivating)
    {
      goto, TunnelingLeftToolUseStart	;Start again in Active mode
    }

    if(toolTLeftState != statePreview)	;Dont do the digging when in Preview mode
    {
      send {%messageLButton% Down}	;Start Digging
    }

    ;Dig on 5 columns deep (or less if customized)
    if(toolTLeftState != statePreview)
      nDigDepth:=nHorzReach
    else
      nDigDepth:=1	;Only dig 1st column when in Preview mode

    Loop, %nDigDepth%
    {
      ;Verify if tool usage or state has changed
      if ( (nActiveFeature != enumFeatureTunnelingLeft) or (toolTLeftState = stateInactive)) ; break the loop
      {
        toolTLeftState:=stateInactive
        break
      }
      else if(toolTLeftState = stateActivating)
      {
        goto, TunnelingLeftToolUseStart	;Start again in Active mode
      }

      ; Move mouse cursor to current column to be dug
      MouseMove, (xposInitial - ((A_Index-1) * nHorzToolOffset)), (yposCurrent + (bTunnelLiningFloor * nVertToolOffset))

      sleep nTunnelingDelayPerBlock	; Give additionnal time for tool to work, after a big cursor move


      ;Iterate for each block in a given column
      Loop, % nTunnelHeight-1+bTunnelLiningFloor+bTunnelLiningTop
      {
        ;Verify if tool usage or state has changed
        if ( (nActiveFeature != enumFeatureTunnelingLeft) or (toolTLeftState = stateInactive)) ; break the loop
        {
          toolTLeftState:=stateInactive
          break
        }
        else if(toolTLeftState = stateActivating)
        {
          goto, TunnelingLeftToolUseStart	;Start again in Active mode
        }

        sleep nTunnelingDelayPerBlock	; Let the tool work for some time

        MouseMove, 0, -nVertToolOffset, , R	; Move the tool upward by one block
      }

      sleep nTunnelingDelayPerBlock + 100 ; Let the tool work for some time
    }

    ;End the digging when not in Preview mode
    if(toolTLeftState != statePreview)
    {
      send {%messageLButton% Up} ;Stop digging
    }

    ;Verify if tool usage or state has changed
    if ( (nActiveFeature != enumFeatureTunnelingLeft) or (toolTLeftState = stateInactive)) ; break the main loop and exit
    {
      toolTLeftState:=stateInactive
      break
    }
    else if(toolTLeftState = stateActivating)
    {
      goto, TunnelingLeftToolUseStart	;Start again in Active mode
    }

    ;Block of code that deals with putting on the lining on the top and bottom, if option is selected
    if((bTunnelLiningTop = true) or (bTunnelLiningFloor = true))
    {
      MouseGetPos, xposPick, yposPick

      if(toolTLeftState != statePreview)	;Dont switch tools when in Preview mode
      {
        ;Switch tools
        sleep 400	; Requires a certain delay before game is ready to accept an actual toolbar item change

        send {%keyToolbarItemWithMaterial% Down} ;Switch to toolbar item with lining material
        sleep 20
        send {%keyToolbarItemWithMaterial% Up}

        sleep 200

        bCurrentToolIsPick:= false
      }

      ;Put lining on the floor
      if((bTunnelLiningFloor = true) and (nActiveFeature = enumFeatureTunnelingLeft))
      {
        ; Move mouse cursor to row of lining to the bottom
        MouseMove, xposInitial , (yposCurrent + nVertToolOffset)

        if(toolTLeftState != statePreview)	;Dont do the laying when in Preview mode
        {
          send {%messageLButton% Down}	;Start laying lining
        }

        ;Iterate for each block in a given row (5 blocks deep per row, or less if customized)
        Loop, % nHorzReach - 1
        {
          sleep 100							; Let the tool work for some time
          MouseMove, -nHorzToolOffset, 0, , R	; Move the tool left by one block
        }

        sleep 100								; Let the tool work for some time

        ;Put safety stop, so the char does not run into the void
        if(bSafetyNet = true)
        {
          MouseMove, -nHorzToolOffset, 0, , R	; Move the tool left by one block
          sleep 100							; Let the tool work for some time

          MouseMove, 0, -nVertToolOffset, , R	; Move the tool up by one block
          sleep 100							; Let the tool work for some time

          MouseMove, 0, -nVertToolOffset, , R	; Move the tool up by one block
          sleep 100							; Let the tool work for some time
        }

        ;Dont end the laying when in Preview mode
        if(toolTLeftState != statePreview)
        {
          send {%messageLButton% Up}	;Stop laying lining

          sleep 200
        }
      }

      ;Put lining at the top
      if((bTunnelLiningTop = true) and (nActiveFeature = enumFeatureTunnelingLeft))
      {
        ; Move mouse cursor to row of lining to the top
        MouseMove, xposInitial , (yposCurrent -(nTunnelHeight * nVertToolOffset))

        if(toolTLeftState != statePreview)	;Dont do the laying when in Preview mode
        {
          send {%messageLButton% Down}	;Start laying lining
        }

        ;Iterate for each block in a given row (5 blocks deep per row, or less if customized)
        Loop, % nHorzReach - 1
        {
          sleep 100							; Let the tool work for some time
          MouseMove, -nHorzToolOffset, 0, , R	; Move the tool left by one block
        }

        sleep 100								; Let the tool work for some time

        ;Dont end the laying when in Preview mode
        if(toolTLeftState != statePreview)
        {
          send {%messageLButton% Up}	;Stop laying lining

          sleep 200
        }
      }


      ;Verify if tool usage or state has changed
      if ( (nActiveFeature != enumFeatureTunnelingLeft) or (toolTLeftState = stateInactive)) ; break the main loop and exit
      {
        toolTLeftState:=stateInactive
        break
      }
      else if(toolTLeftState = stateActivating)
      {
        goto, TunnelingLeftToolUseStart	;Start again in Active mode
      }

      if(toolTLeftState != statePreview)	;Dont switch tools when in Preview mode
      {
        ;Switch tool back to pick
        sleep 400	; Requires a certain delay before game is ready to accept an actual toolbar item change

        send {%keyToolbarItemPick% Down} ;Switch to toolbar item with pick
        sleep 20
        send {%keyToolbarItemPick% Up}

        sleep 100
      }

    }

    MouseMove, xposCurrent, yposInitial	; Bring back the tool to initial position

    if(toolTLeftState != statePreview)	;Dont move character when in Preview mode
    {
      ; Let the character move a little
      send {%keyMoveLeft% Down}
      sleep 750
      send {%keyMoveLeft% Up}
    }
  }

  if(nActiveFeature = enumFeatureTunnelingLeft)
    SetActiveFeature(enumFeatureNone)

  return
}


TunnelingRightToolUseStart:
{
  if(nVertToolOffset = 0)	;Calibration must have been done first
    return

  if(toolTRightState = stateActive)	;state Active + hotkey again = disactivate
  {
    toolTRightState:=stateInactive	;Modify state of original thread and terminate this new thread
    return
  }

  if(toolTRightState = statePreview)	;state Preview + hotkey again = prepare to activate
  {
    toolTRightState:=stateActivating	;Modify state of original thread and terminate this new thread
    return
  }

  if(toolTRightState = stateActivating)	;state Activating -> reset some variables and restart original thread in Active mode
  {
    toolTRightState:=stateActive
    MouseMove, xposInitial, yposInitial	;Reset mouse position
  }

  if(toolTRightState = stateInactive)
  {
    toolTRightState:=statePreview		;state Inactive + hotkey = start thread in Preview mode, this is the original thread

    ; If actually using other Tunneling tool functions, just cancel it and exit
    if( (nActiveFeature = enumFeatureTunnelingDown) or (nActiveFeature = enumFeatureTunnelingLeft) )
    {
      SetActiveFeature(enumFeatureNone)
      toolTRightState:=stateInactive	;Reset this tool to inactive state
      return
    }

    Gosub, CancelAutorun
  }

  SetActiveFeature(enumFeatureTunnelingRight)

  MouseGetPos, xposInitial, yposInitial ;Record initial Y position of mouse


  Loop	;Infinite loop
  {
    MouseGetPos, xposCurrent, yposCurrent

    ;Verify if tool usage or state has changed
    if ( (nActiveFeature != enumFeatureTunnelingRight) or (toolTRightState = stateInactive)) ; break the main loop and exit
    {
      toolTRightState:=stateInactive
      break
    }
    else if(toolTRightState = stateActivating)
    {
      goto, TunnelingRightToolUseStart	;Start again in Active mode
    }

    if(toolTRightState != statePreview)	;Dont do the digging when in Preview mode
    {
      send {%messageLButton% Down}
    }

    ;Dig on 5 columns deep (or less if customized)
    if(toolTRightState != statePreview)
      nDigDepth:=nHorzReach
    else
      nDigDepth:=1	;Only dig 1st column when in Preview mode

    Loop, %nDigDepth%
    {
      ;Verify if tool usage or state has changed
      if ( (nActiveFeature != enumFeatureTunnelingRight) or (toolTRightState = stateInactive)) ; break the loop
      {
        toolTRightState:=stateInactive
        break
      }
      else if(toolTRightState = stateActivating)
      {
        goto, TunnelingRightToolUseStart	;Start again in Active mode
      }

      ; Move mouse cursor to current column to be dug
      MouseMove, (xposInitial + ((A_Index-1) * nHorzToolOffset)), (yposCurrent + (bTunnelLiningFloor * nVertToolOffset))

      sleep nTunnelingDelayPerBlock	; Give additionnal time for tool to work, after a big cursor move


      ;Iterate for each block in a given column
      Loop, % nTunnelHeight-1+bTunnelLiningFloor+bTunnelLiningTop
      {
        ;Verify if tool usage or state has changed
        if ( (nActiveFeature != enumFeatureTunnelingRight) or (toolTRightState = stateInactive)) ; break the loop
        {
          toolTRightState:=stateInactive
          break
        }
        else if(toolTRightState = stateActivating)
        {
          goto, TunnelingRightToolUseStart	;Start again in Active mode
        }

        sleep nTunnelingDelayPerBlock	; Let the tool work for some time


        MouseMove, 0, -nVertToolOffset, , R	; Move the tool upward by one block
      }

      sleep nTunnelingDelayPerBlock ; Let the tool work for some time
    }

    ;Dont end the digging when in Preview mode
    if(toolTRightState != statePreview)
    {
      send {%messageLButton% Up} ;Stop digging
    }

    ;Verify if tool usage or state has changed
    if ( (nActiveFeature != enumFeatureTunnelingRight) or (toolTRightState = stateInactive)) ; break the main loop and exit
    {
      toolTRightState:=stateInactive
      break
    }
    else if(toolTRightState = stateActivating)
    {
      goto, TunnelingRightToolUseStart	;Start again in Active mode
    }


    ;Block of code that deals with putting on the lining on the top and bottom, if option is selected
    if((bTunnelLiningTop = true) or (bTunnelLiningFloor = true))
    {
      MouseGetPos, xposPick, yposPick

      if(toolTRightState != statePreview)	;Dont switch tools when in Preview mode
      {
        ;Switch tools
        sleep 400	; Requires a certain delay before game is ready to accept an actual toolbar item change

        send {%keyToolbarItemWithMaterial% Down} ;Switch to toolbar item with lining material
        sleep 20
        send {%keyToolbarItemWithMaterial% Up}

        sleep 200

        bCurrentToolIsPick:= false
      }

      ;Put lining on the floor
      if((bTunnelLiningFloor = true) and (nActiveFeature = enumFeatureTunnelingRight))
      {
        ; Move mouse cursor to row of lining to the bottom
        MouseMove, xposInitial , (yposCurrent + nVertToolOffset)

        if(toolTRightState != statePreview)	;Dont do the laying when in Preview mode
        {
          send {%messageLButton% Down}	;Start laying lining
        }

        ;Iterate for each block in a given row (5 blocks deep per row, or less if customized)
        Loop, % nHorzReach - 1
        {
          sleep 100							; Let the tool work for some time
          MouseMove, nHorzToolOffset, 0, , R	; Move the tool left by one block
        }

        sleep 100								; Let the tool work for some time

        ;Put safety stop, so the char does not run into the void
        if(bSafetyNet = true)
        {
          MouseMove, nHorzToolOffset, 0, , R	; Move the tool left by one block
          sleep 100							; Let the tool work for some time

          MouseMove, 0, -nVertToolOffset, , R	; Move the tool up by one block
          sleep 100							; Let the tool work for some time

          MouseMove, 0, -nVertToolOffset, , R	; Move the tool up by one block
          sleep 100							; Let the tool work for some time
        }

        ;Dont end the laying when in Preview mode
        if(toolTRightState != statePreview)
        {
          send {%messageLButton% Up}	;Stop laying lining

          sleep 200
        }
      }

      ;Put lining at the top
      if((bTunnelLiningTop = true) and (nActiveFeature = enumFeatureTunnelingRight))
      {
        ; Move mouse cursor to row of lining to the top
        MouseMove, xposInitial , (yposCurrent -(nTunnelHeight * nVertToolOffset))

        if(toolTRightState != statePreview)	;Dont do the laying when in Preview mode
        {
          send {%messageLButton% Down}	;Start laying lining
        }

        ;Iterate for each block in a given row (5 blocks deep per row, or less if customized)
        Loop, % nHorzReach - 1
        {
          sleep 100							; Let the tool work for some time
          MouseMove, nHorzToolOffset, 0, , R	; Move the tool left by one block
        }

        sleep 100								; Let the tool work for some time

        ;Dont end the laying when in Preview mode
        if(toolTRightState != statePreview)
        {
          send {%messageLButton% Up}	;Stop laying lining

          sleep 200
        }
      }

      ;Verify if tool usage or state has changed
      if ( (nActiveFeature != enumFeatureTunnelingRight) or (toolTRightState = stateInactive)) ; break the main loop and exit
      {
        toolTRightState:=stateInactive
        break
      }
      else if(toolTRightState = stateActivating)
      {
        goto, TunnelingRightToolUseStart	;Start again in Active mode
      }

      if(toolTRightState != statePreview)	;Dont switch tools when in Preview mode
      {
        ;Switch tool back to pick
        sleep 400	; Requires a certain delay before game is ready to accept an actual toolbar item change

        send {%keyToolbarItemPick% Down} ;Switch to toolbar item with pick
        sleep 20
        send {%keyToolbarItemPick% Up}

        sleep 100
      }
    }

    MouseMove, xposCurrent, yposInitial	; Bring back the tool to initial position

    if(toolTRightState != statePreview)	;Dont move character when in Preview mode
    {
      ; Let the character move a little
      send {%keyMoveRight% Down}
      sleep 750
      send {%keyMoveRight% Up}
    }
  }

  if(nActiveFeature = enumFeatureTunnelingRight)
    SetActiveFeature(enumFeatureNone)

  return
}


SafetyNet:
{
  bSafetyNet:= !bSafetyNet
  return
}

TunnelLiningTop:
{
  bTunnelLiningTop:= !bTunnelLiningTop
  return
}

TunnelLiningFloor:
{
  bTunnelLiningFloor:= !bTunnelLiningFloor
  return
}

TunnelLiningLeft:
{
  bTunnelLiningLeft:= !bTunnelLiningLeft
  return
}

TunnelLiningRight:
{
  bTunnelLiningRight:= !bTunnelLiningRight
  return
}


SetDelay:
{
  bChoosingNewDelay:=true	;Flag set up to prevent some actions that normally happen when pressing number keys

    ;Case: sword autoattack
  if(nActiveFeature = enumFeatureAutoAttack)
  {
    Input, UserInput, L1 T2, , 1,2,3,4,5,6,7,8,9,0
    if ErrorLevel = Match
    {
      if(UserInput = 0)
        UserInput=10
      delayDuration = % arrayDelays%UserInput%
    }
  }	;Case: MultiLayer tool use along one horizontal layer of block
  else if((nActiveFeature = enumFeatureMultiLayerRight) or (nActiveFeature = enumFeatureMultiLayerLeft))
  {
    Input, UserInput, L1 T2, , 1,2,3,4,5,6,7,8,9,0
    if ErrorLevel = Match
    {
      if(UserInput = 0)
        UserInput=10
      delayMultiLayerToolUse = % arrayDelaysMultiLayer%UserInput%
    }
  }	;Case: tunneling
  else if((nActiveFeature = enumFeatureTunnelingLeft) or (nActiveFeature = enumFeatureTunnelingRight)
        or (nActiveFeature = enumFeatureTunnelingDown))
  {
    Input, UserInput, L1 T2, , 1,2,3,4,5,6,7,8,9,0
    if ErrorLevel = Match
    {
      if(UserInput = 0)
        UserInput=10
      nTunnelingDelayPerBlock = % arrayDelaysTunneling%UserInput%
    }
  }

  bChoosingNewDelay:=false

  return
}


AugmentDelay:
{
    ;Case: sword autoattack
  if(nActiveFeature = enumFeatureAutoAttack)
  {
    Loop, parse, delayValues, `,
    {
      if(A_LoopField = delayDuration)
      {
        newIndex:= A_Index + 1
        if(newIndex > arrayDelays0)
          newIndex:= arrayDelays0

        delayDuration = % arrayDelays%newIndex%

        break
      }
    }
  }	;Case: MultiLayer tool use along one horizontal layer of block
  else if((nActiveFeature = enumFeatureMultiLayerRight) or (nActiveFeature = enumFeatureMultiLayerLeft))
  {
    Loop, parse, delayMultiLayerValues, `,
    {
      if(A_LoopField = delayMultiLayerToolUse)
      {
        newIndex:= A_Index + 1
        if(newIndex > arrayDelaysMultiLayer0)
          newIndex:= arrayDelaysMultiLayer0

        delayMultiLayerToolUse = % arrayDelaysMultiLayer%newIndex%

        break
      }
    }
  }	;Case: tunneling
  else if((nActiveFeature = enumFeatureTunnelingLeft) or (nActiveFeature = enumFeatureTunnelingRight)
        or (nActiveFeature = enumFeatureTunnelingDown))
  {
    Loop, parse, delayTunnelingValues, `,
    {
      if(A_LoopField = nTunnelingDelayPerBlock)
      {
        newIndex:= A_Index + 1
        if(newIndex > arrayDelaysTunneling0)
          newIndex:= arrayDelaysTunneling0

        nTunnelingDelayPerBlock = % arrayDelaysTunneling%newIndex%

        break
      }
    }
  }
  return
}


DecreaseDelay:
{
    ;Case: sword autoattack
  if(nActiveFeature = enumFeatureAutoAttack)
  {
    Loop, parse, delayValues, `,
    {
      if(A_LoopField = delayDuration)
      {
        newIndex:= A_Index - 1
        if(newIndex < 1)
          newIndex:= 1

        delayDuration = % arrayDelays%newIndex%

        break
      }
    }
  }	;Case: MultiLayer tool use along one horizontal layer of block
  else if((nActiveFeature = enumFeatureMultiLayerRight) or (nActiveFeature = enumFeatureMultiLayerLeft))
  {
    Loop, parse, delayMultiLayerValues, `,
    {
      if(A_LoopField = delayMultiLayerToolUse)
      {
        newIndex:= A_Index - 1
        if(newIndex < 1)
          newIndex:= 1

        delayMultiLayerToolUse = % arrayDelaysMultiLayer%newIndex%

        break
      }
    }
  }	;Case: tunneling
  else if((nActiveFeature = enumFeatureTunnelingLeft) or (nActiveFeature = enumFeatureTunnelingRight)
        or (nActiveFeature = enumFeatureTunnelingDown))
  {
    Loop, parse, delayTunnelingValues, `,
    {
      if(A_LoopField = nTunnelingDelayPerBlock)
      {
        newIndex:= A_Index - 1
        if(newIndex < 1)
          newIndex:= 1

        nTunnelingDelayPerBlock = % arrayDelaysTunneling%newIndex%

        break
      }
    }
  }
  return
}


/*
This functionality has been commented out, as it does not seem useful anymore
BlockSizeCalibration:
{
  ;Wait for user to press down the right mouse button
  keywait, %keyRightClick%, D

  MouseGetPos, xpos, ypos
  nUpperYValue:=ypos
  nLowerYValue:=ypos
  nUpperXValue:=xpos
  nLowerXValue:=xpos

  ;Record the lowest and highest values in the 'x' and 'y' axis,
  ;	as the user holds the right mouse button and moves the mouse
  While GetKeyState(keyRightClick, "P")
  {
    MouseGetPos, xpos, ypos

    if(ypos < nLowerYValue)
      nLowerYValue:=ypos

    if(ypos > nUpperYValue)
      nUpperYValue:=ypos

    if(xpos < nLowerXValue)
      nLowerXValue:=xpos

    if(xpos > nUpperXValue)
      nUpperXValue:=xpos

  }

  ;Calculate dimensions of one block
  nVertToolOffset:= (nUpperYValue - nLowerYValue) / 3
  nHorzToolOffset:= (nUpperXValue - nLowerXValue) / 3

  return
}
*/


SetTunnelingNumberBlocks:
{
  bChoosingNewDelay:=true	;Flag set up to prevent some actions that normally happen when pressing number keys

  Input, UserInput, L1 T2, , 1,2,3,4,5,6,7,8,9
  if ErrorLevel = Match
  {
    nNumberBlocks = % arrayNumberBlocks%UserInput%

    ; Left or Right tunneling tool is active, so adjust only the tunnel heigth
    if((nActiveFeature = enumFeatureTunnelingLeft) or (nActiveFeature = enumFeatureTunnelingRight))
    {
      nTunnelHeight:= nNumberBlocks
    }
    ; Down tunneling tool is active, so adjust only the tunnel width
    else if(nActiveFeature = enumFeatureTunnelingDown)
    {
      nTunnelWidth:= nNumberBlocks
    }
    else if((nActiveFeature = enumFeatureMultiLayerRight) or (nActiveFeature = enumFeatureMultiLayerLeft))
    {
      nMultiLayerHeight:=nNumberBlocks
    }
    else ;If set while neither tools are used, update both tunnel heigth and width
    {
      nTunnelHeight:= nNumberBlocks
      nTunnelWidth:= nNumberBlocks
    }

    ;Force a minimal tunnel height of 3, else the character cannot circulate in it...
    if(nTunnelHeight < 3)
    {
      nTunnelHeight:=3
    }

    if(nTunnelHeight > 5)
    {
      nTunnelHeight:=5
    }

    ;Force a minimal tunnel width of 2, else the character cannot circulate in it...
    if(nTunnelWidth < 2)
    {
      nTunnelHeight:=2
    }

    if(nTunnelWidth > 5)
    {
      nTunnelWidth:=5
    }
  }

  bChoosingNewDelay:=false

  return
}


AutorunLeft:
{
  SetActiveFeature(enumFeatureNone, true)

  if(bAutorunRight = true)
  {
    send {%keyMoveRight% Up}
    bAutorunRight:=false
  }

  if(bAutorunLeft = true)
  {
    send {%keyMoveLeft% Up}
    bAutorunLeft:=false
  }
  else
  {
    send {%keyMoveLeft% Down}
    bAutorunLeft:=true
  }
  return
}


AutorunRight:
{
  SetActiveFeature(enumFeatureNone, true)

  if(bAutorunLeft = true)
  {
    send {%keyMoveLeft% Up}
    bAutorunLeft:=false
  }

  if(bAutorunRight = true)
  {
    send {%keyMoveRight% Up}
    bAutorunRight:=false
  }
  else
  {
    send {%keyMoveRight% Down}
    bAutorunRight:=true
  }
  return
}


CancelAutorun:
{
  if(bAutorunLeft = true)
  {
    send {%keyMoveLeft% Up}
    bAutorunLeft:=false
  }

  if(bAutorunRight = true)
  {
    send {%keyMoveRight% Up}
    bAutorunRight:=false
  }
  return
}


MoveLeft:
{
  SetActiveFeature(enumFeatureNone, true)

  if(bAutorunLeft = true)
  {
    bAutorunLeft:=false
  }

  if(bAutorunRight = true)
  {
    send {%keyMoveRight% Up}
    bAutorunRight:=false
  }
  return
}

MoveRight:
{
  SetActiveFeature(enumFeatureNone, true)

  if(bAutorunRight = true)
  {
    bAutorunRight:=false
  }

  if(bAutorunLeft = true)
  {
    send {%keyMoveLeft% Up}
    bAutorunLeft:=false
  }
  return
}


MoveUp:
MoveDown:
{
  SetActiveFeature(enumFeatureNone, true)

  Gosub, CancelAutorun

  return
}


Num1:
{
  if( bChoosingNewDelay = false )	; We dont want to cancel automated tools use when user is choosing a new delay
  {
    ForceSwitch(1)
  }

  return
}

Num2:
{
  if( bChoosingNewDelay = false )	; We dont want to cancel automated tools use when user is choosing a new delay
  {
    ForceSwitch(2)
  }

  return
}

Num3:
{
  if( bChoosingNewDelay = false )	; We dont want to cancel automated tools use when user is choosing a new delay
  {
    ForceSwitch(3)
  }

  return
}

Num4:
{
  if( bChoosingNewDelay = false )	; We dont want to cancel automated tools use when user is choosing a new delay
  {
    ForceSwitch(4)
  }

  return
}

Num5:
{
  if( bChoosingNewDelay = false )	; We dont want to cancel automated tools use when user is choosing a new delay
  {
    ForceSwitch(5)
  }

  return
}

Num6:
{
  if( bChoosingNewDelay = false )	; We dont want to cancel automated tools use when user is choosing a new delay
  {
    ForceSwitch(6)
  }

  return
}

Num7:
{
  if( bChoosingNewDelay = false )	; We dont want to cancel automated tools use when user is choosing a new delay
  {
    ForceSwitch(7)
  }

  return
}

Num8:
{
  if( bChoosingNewDelay = false )	; We dont want to cancel automated tools use when user is choosing a new delay
  {
    ForceSwitch(8)
  }

  return
}

Num9:
{
  if( bChoosingNewDelay = false )	; We dont want to cancel automated tools use when user is choosing a new delay
  {
    ForceSwitch(9)
  }

  return
}

Num0:
{
  if( bChoosingNewDelay = false )	; We dont want to cancel automated tools use when user is choosing a new delay
  {
    ForceSwitch(0)
  }

  return
}


;This function is used to counter a bad keyboard/mouse interaction in the game.
  ;When the user is actively using a tool, either by holding down or spamming Left Mouse Button,
  ;it is almost impossible to switch to a new Toolbar Item by pressing one of 1,2,...9,0
  ;If this 'bug' ever gets fixed, then the function can be simplified and made to just
  ;do the <Cancel any active feature> code snippet
ForceSwitch(num)
{
  global keyLeftClick
  global messageLButton
  global nActiveFeature
  global enumFeatureNone

  bAddDelay:=false

  ;Cancel any active feature
  if(nActiveFeature != enumFeatureNone)
  {
    SetActiveFeature(enumFeatureNone)
    bAddDelay:=true
  }

  ; If left mouse button is actively pressed down, cancel it
  if(GetKeyState(keyLeftClick, "P"))
  {
    Send {%messageLButton% Up}
    bAddDelay:=true
  }

  if(bAddDelay = true)
    sleep 400	; Requires a certain delay before game is ready to accept an actual toolbar item change

  ; Force a switch to the new toolbar item, by simulating another key press
  send {%num% Down}
  sleep 20
  send {%num% Up}

  return
}


QuickStack:
{
  MouseGetPos, xpos, ypos

  MouseMove, xQuickStack, yQuickStack

  send {%messageLButton% Down}
  sleep 10
  send {%messageLButton% Up}

  MouseMove, xpos, ypos

  return
}


CalibrateQuickStack:
{
  MouseGetPos, xQuickStack, yQuickStack

  ;Uncomment to get a message with the QuickStack coordinates
  ;MsgBox, x %xQuickStack% y %yQuickStack%

  return
}


MultiQuickStack1:
{
  SetActiveFeature(enumFeatureMultiQuickStack)

  MouseGetPos, xOrigMultiStack, yOrigMultiStack

  ;For each mouse cursor coordinates in the array, do
  Loop, %arrayMultiQuickStack1_0_0%
  {
    if(nActiveFeature != enumFeatureMultiQuickStack)
      break

    ;Move the mouse cursor to one of the positions found in the array
    MouseMove, arrayMultiQuickStack1_%A_Index%_0, arrayMultiQuickStack1_%A_Index%_1

    ;Send right mouse button click to that position, to open the chest and the chest menu buttons
    sleep 300
    send {%messageRButton% Down}
    sleep 25
    send {%messageRButton% Up}
    sleep 300

    if(nActiveFeature != enumFeatureMultiQuickStack)
      break

    ;Move the mouse cursor to the QuickStack menu button position
    MouseMove, xQuickStack, yQuickStack

    ;Send left mouse button click to that position, to execute the Quick Stack for this chest
    sleep 300
    send {%messageLButton% Down}
    sleep 25
    send {%messageLButton% Up}
    sleep 300
  }

  ;Return mouse cursor to original position
  MouseMove, xOrigMultiStack, yOrigMultiStack

  SetActiveFeature(enumFeatureNone)

  return
}


SetupMultiQuickStack1:
{
  ;if a second thread is started for this hotkey, turn off the setup that is going on in the first thread
  if(nSetupMultiQuickStack = 1)
  {
    nSetupMultiQuickStack:= 0	;turn off the setup mode
    return
  }

  nMultiIndex:=0

  nSetupMultiQuickStack:= 1

  arrayMultiQuickStack1_0_0:=0	;Initialize the size of the array to zero

  Loop	;Infinite loop, to keep the thread active
  {
    sleep 100

    if(nSetupMultiQuickStack = 0)	;User finished selecting targets, break loop
    {
      break
    }

  }

  ;If at least one Quick Stack target was recorded, update the 0 indexed element of the array to put the size of array in it
  if(nMultiIndex > 0)
  {
    arrayMultiQuickStack1_0_0:=nMultiIndex
  }

  return
}


MultiQuickStack2:
{
  SetActiveFeature(enumFeatureMultiQuickStack)

  MouseGetPos, xOrigMultiStack, yOrigMultiStack

  ;For each mouse cursor coordinates in the array, do
  Loop, %arrayMultiQuickStack2_0_0%
  {
    if(nActiveFeature != enumFeatureMultiQuickStack)
      break

    ;Move the mouse cursor to one of the positions found in the array
    MouseMove, arrayMultiQuickStack2_%A_Index%_0, arrayMultiQuickStack2_%A_Index%_1

    ;Send right mouse button click to that position, to open the chest and the chest menu buttons
    sleep 300
    send {%messageRButton% Down}
    sleep 25
    send {%messageRButton% Up}
    sleep 300

    if(nActiveFeature != enumFeatureMultiQuickStack)
      break

    ;Move the mouse cursor to the QuickStack menu button position
    MouseMove, xQuickStack, yQuickStack

    ;Send left mouse button click to that position, to execute the Quick Stack for this chest
    sleep 300
    send {%messageLButton% Down}
    sleep 25
    send {%messageLButton% Up}
    sleep 300
  }

  ;Return mouse cursor to original position
  MouseMove, xOrigMultiStack, yOrigMultiStack

  SetActiveFeature(enumFeatureNone)

  return
}


SetupMultiQuickStack2:
{
  ;if a second thread is started for this hotkey, turn off the setup that is going on in the first thread
  if(nSetupMultiQuickStack = 2)
  {
    nSetupMultiQuickStack:= 0	;turn off the setup mode
    return
  }

  nMultiIndex:=0

  nSetupMultiQuickStack:= 2

  arrayMultiQuickStack2_0_0:=0	;Initialize the size of the array to zero

  Loop	;Infinite loop, to keep the thread active
  {
    sleep 100

    if(nSetupMultiQuickStack = 0)	;User finished selecting targets, break loop
    {
      break
    }

  }

  ;If at least one Quick Stack target was recorded, update the 0 indexed element of the array to put the size of array in it
  if(nMultiIndex > 0)
  {
    arrayMultiQuickStack2_0_0:=nMultiIndex
  }

  return
}


SetupSellInventory:
{
  nSellInventoryXPos:=0
  nSellInventoryYPos:=0
  nSellInventoryXInc:=0
  nSellInventoryYInc:=0


  ;if a second thread is started for this hotkey, turn off the setup that is going on in the first thread
  if(bSetupSellInventory = true)
  {
    bSetupSellInventory:= false	;turn off the setup mode
    return
  }

  nUpperYValue:=-1
  nLowerYValue:=-1
  nUpperXValue:=-1
  nLowerXValue:=-1

  bSetupSellInventory:= true

  Loop	;Infinite loop, to keep the thread active
  {
    sleep 100

    if(bSetupSellInventory = false)	;User finished selecting targets, break loop
    {
      break
    }

  }

  if(nLowerXValue > -1)
  {
    nSellInventoryXPos:= nLowerXValue
    nSellInventoryYPos:= nLowerYValue

    nSellInventoryXInc:= (nUpperXValue - nLowerXValue)/9
    nSellInventoryYInc:= (nUpperYValue - nLowerYValue)/3
  }

  return
}


SellInventory:
{
  ;if a second thread is started for this hotkey, turn off the selling that is going on in the first thread
  if(nActiveFeature = enumFeatureSellInventory)
  {
    SetActiveFeature(enumFeatureNone)
    return
  }

  if(nSellInventoryXPos > 0)
  {
    SetActiveFeature(enumFeatureSellInventory)

    send {LShift Down}
    sleep 25

    Loop	;Infinite loop
    {
      if(nActiveFeature != enumFeatureSellInventory)	;User cancelled selling, break loop
      {
        break
      }

      Loop, 10	;Loop 10 times in the whole inventory, after which, we update the grapple hook to keep it active
      {

        Loop, 4 ;Loop each row
        {
          if(nActiveFeature != enumFeatureSellInventory)	;User cancelled selling, break loop
          {
            break
          }

          MouseMove, nSellInventoryXPos, nSellInventoryYPos + ((A_Index - 1) * nSellInventoryYInc)

          sleep 250
          send {%messageLButton% Down}
          sleep 20
          send {%messageLButton% Up}
          sleep 250

          Loop, 9	;Loop each cell in a given row, first cell is already done
          {
            if(nActiveFeature != enumFeatureSellInventory)	;User cancelled selling, break loop
            {
              break
            }

            MouseMove, nSellInventoryXInc, 0, , R	; Move the tool to the right by one block

            sleep 250
            send {%messageLButton% Down}
            sleep 20
            send {%messageLButton% Up}
            sleep 250
          }
        }
      }

      ;Special code to keep the grapple hook active (else it deactivates after 10 minutes)
      if(nGrappleXPos != 0)
      {
        MouseMove, nGrappleXPos, nGrappleYPos
        sleep 500	;give ample time for this mousemove to resolve, positioning is critical

        send {%keyGrapple% Down}
        sleep 25
        send {%keyGrapple% Up}
        sleep 500
      }

    }

    send {LShift Up}
    sleep 25

  }
  return
}


PositionCursorForStableGrapple:
{
  ;Toggle feature on/off
  bPositioningCursorForStableGrapple:= !bPositioningCursorForStableGrapple

  return
}


Grapple:
{
  if(bPositioningCursorForStableGrapple = true)
  {
    MouseGetPos, nGrappleXPos, nGrappleYPos
  }

  return
}


SpecialRightClick:
{
  ;when in setup mode for Multi Quick Stack, add current mouse position to array
  if(nSetupMultiQuickStack = 1)
  {
    nMultiIndex++
    MouseGetPos, xpos, ypos

    arrayMultiQuickStack1_%nMultiIndex%_0:= xpos
    arrayMultiQuickStack1_%nMultiIndex%_1:= ypos
  }
  else if(nSetupMultiQuickStack = 2)
  {
    nMultiIndex++
    MouseGetPos, xpos, ypos

    arrayMultiQuickStack2_%nMultiIndex%_0:= xpos
    arrayMultiQuickStack2_%nMultiIndex%_1:= ypos
  }
  else if(bSetupSellInventory =  true)
  {
    MouseGetPos, xpos, ypos

    ;Is this the first click to be registered
    if(nLowerXValue = -1)
    {
      nUpperXValue:= xpos
      nLowerXValue:= xpos
      nUpperYValue:= ypos
      nLowerYValue:= ypos
    }
    else	;additionnal clicks registered
    {
      if(xpos < nLowerXValue)
        nLowerXValue:= xpos

      if(xpos > nUpperXValue)
        nUpperXValue:= xpos

      if(ypos < nLowerYValue)
        nLowerYValue:= ypos

      if(ypos > nUpperYValue)
        nUpperYValue:= ypos

    }
  }

  return
}


SpecialLeftClick:
{
  ;Cancel any feature usage
  SetActiveFeature(enumFeatureNone)

  return
}


SaveConfig:
{
  ;MultiQuickStack mouse positions
  if(arrayMultiQuickStack1_0_0 != 0)
  {
    IniDelete, TerrariaAHKScriptConfig.ini, MultiQuickStack1

    IniWrite, %arrayMultiQuickStack1_0_0%, TerrariaAHKScriptConfig.ini, MultiQuickStack1, arraySize

    Loop, %arrayMultiQuickStack1_0_0%
    {
      IniWrite, % arrayMultiQuickStack1_%A_Index%_0, TerrariaAHKScriptConfig.ini, MultiQuickStack1, xpos%A_Index%
      IniWrite, % arrayMultiQuickStack1_%A_Index%_1, TerrariaAHKScriptConfig.ini, MultiQuickStack1, ypos%A_Index%
    }
  }

  if(arrayMultiQuickStack2_0_0 != 0)
  {
    IniDelete, TerrariaAHKScriptConfig.ini, MultiQuickStack2

    IniWrite, %arrayMultiQuickStack2_0_0%, TerrariaAHKScriptConfig.ini, MultiQuickStack2, arraySize

    Loop, %arrayMultiQuickStack2_0_0%
    {
      IniWrite, % arrayMultiQuickStack2_%A_Index%_0, TerrariaAHKScriptConfig.ini, MultiQuickStack2, xpos%A_Index%
      IniWrite, % arrayMultiQuickStack2_%A_Index%_1, TerrariaAHKScriptConfig.ini, MultiQuickStack2, ypos%A_Index%
    }
  }

  ;QuickStack menu button position
  if((xQuickStack != 0) or (yQuickStack != 0))
  {
    IniDelete, TerrariaAHKScriptConfig.ini, QuickStackButton

    IniWrite, %xQuickStack%, TerrariaAHKScriptConfig.ini, QuickStackButton, xpos
    IniWrite, %yQuickStack%, TerrariaAHKScriptConfig.ini, QuickStackButton, ypos
  }


  ;Dimensions of a game block
  if((nVertToolOffset != 16) or (nHorzToolOffset != 16))
  {
    IniDelete, TerrariaAHKScriptConfig.ini, BlockDimensions

    IniWrite, %nHorzToolOffset%, TerrariaAHKScriptConfig.ini, BlockDimensions, width
    IniWrite, %nVertToolOffset%, TerrariaAHKScriptConfig.ini, BlockDimensions, height
  }

  ;coordinates for sell inventory
  if(nSellInventoryXPos != 0)
  {
    IniDelete, TerrariaAHKScriptConfig.ini, SellInventory

    IniWrite, %nSellInventoryXPos%, TerrariaAHKScriptConfig.ini, SellInventory, xpos
    IniWrite, %nSellInventoryYPos%, TerrariaAHKScriptConfig.ini, SellInventory, ypos
    IniWrite, %nSellInventoryXInc%, TerrariaAHKScriptConfig.ini, SellInventory, xincrement
    IniWrite, %nSellInventoryYInc%, TerrariaAHKScriptConfig.ini, SellInventory, yincrement
  }

  return
}


ReadConfig:
{

  ;MultiQuickStack mouse positions
  IniRead, OutputArraySize, TerrariaAHKScriptConfig.ini, MultiQuickStack1, arraySize ,0

  if(OutputArraySize > 0)
  {
    Loop, %OutputArraySize%
    {
      IniRead, Outputxpos, TerrariaAHKScriptConfig.ini, MultiQuickStack1, xpos%A_Index%
      IniRead, Outputypos, TerrariaAHKScriptConfig.ini, MultiQuickStack1, ypos%A_Index%

      arrayMultiQuickStack1_%A_Index%_0:= Outputxpos
      arrayMultiQuickStack1_%A_Index%_1:= Outputypos
    }

    arrayMultiQuickStack1_0_0:=OutputArraySize
  }

  IniRead, OutputArraySize, TerrariaAHKScriptConfig.ini, MultiQuickStack2, arraySize ,0

  if(OutputArraySize > 0)
  {
    Loop, %OutputArraySize%
    {
      IniRead, Outputxpos, TerrariaAHKScriptConfig.ini, MultiQuickStack2, xpos%A_Index%
      IniRead, Outputypos, TerrariaAHKScriptConfig.ini, MultiQuickStack2, ypos%A_Index%

      arrayMultiQuickStack2_%A_Index%_0:= Outputxpos
      arrayMultiQuickStack2_%A_Index%_1:= Outputypos
    }

    arrayMultiQuickStack2_0_0:=OutputArraySize
  }

  ;QuickStack menu button position
  IniRead, Outputxpos, TerrariaAHKScriptConfig.ini, QuickStackButton, xpos ,0
  IniRead, Outputypos, TerrariaAHKScriptConfig.ini, QuickStackButton, ypos ,0

  if(Outputxpos != 0)
    xQuickStack:= Outputxpos

  if(Outputypos != 0)
    yQuickStack:= Outputypos


  ;Dimensions of a game block
  IniRead, OutputWidth, TerrariaAHKScriptConfig.ini, BlockDimensions, width ,0
  IniRead, OutputHeight, TerrariaAHKScriptConfig.ini, BlockDimensions, height ,0

  if(OutputWidth != 0)
    nHorzToolOffset:= OutputWidth

  if(OutputHeight != 0)
    nVertToolOffset:= OutputHeight


  ;coordinates for sell inventory
  IniRead, Outputxpos, TerrariaAHKScriptConfig.ini, SellInventory, xpos ,0
  IniRead, Outputypos, TerrariaAHKScriptConfig.ini, SellInventory, ypos ,0
  IniRead, Outputxinc, TerrariaAHKScriptConfig.ini, SellInventory, xincrement ,0
  IniRead, Outputyinc, TerrariaAHKScriptConfig.ini, SellInventory, yincrement ,0

  if(Outputxpos != 0)
    nSellInventoryXPos:= Outputxpos

  if(Outputypos != 0)
    nSellInventoryYPos:= Outputypos

  if(Outputxinc != 0)
    nSellInventoryXInc:= Outputxinc

  if(Outputyinc != 0)
    nSellInventoryYInc:= Outputyinc

  return
}


Chat:
  ;Both suspend and pause are needed
  suspend
  pause
  return

SuspendHotkeys:
  Suspend
  return

PauseScript:
  Pause
  return
