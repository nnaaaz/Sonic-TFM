--- sonic
--
-- Module description.
--
-- @header Description to put at the top of the compiled file.
--
-- @author TFM:Nnaaaz#0000 (map, concept)
-- @author TFM:Lays#1146 (lua)


---
-- Imports
---

pshy.require("pshy.essentials")
pshy.require("pshy.events")
pshy.require("pshy.rotations.mapinfo")
pshy.require("pshy.commands.list.all")

local perms = pshy.require("pshy.perms")
local version = pshy.require("pshy.bases.version")
local rotations = pshy.require("pshy.rotations.list")
local newgame = pshy.require("pshy.rotations.newgame")
local Rotation = pshy.require("pshy.utils.rotation")
local maps = pshy.require("pshy.maps.list")
pshy.require("pshy.bonuses")
pshy.require("pshy.bonuses.mapext")

local traps = pshy.require("traps")
local levels = pshy.require("generated_levels")

pshy.require("bonus_score1")
pshy.require("bonus_score10")
pshy.require("bonus_win")


---
-- TFM Settings
---

system.disableChatCommandDisplay(nil, true)
tfm.exec.disableAfkDeath(true)
tfm.exec.disableAutoNewGame(true)
tfm.exec.disableAutoScore(true)
tfm.exec.disableAutoShaman(true)
tfm.exec.disableAutoTimeLeft(true)
tfm.exec.disablePhysicalConsumables(true)
--tfm.exec.disableDebugCommand(true)
--tfm.exec.disableMinimalistMode(true)


---
-- Pshy Settings
---

--local loadersync = pshy.require("pshy.anticheats.loadersync")
--loadersync.enabled = true										-- Enable to force the sync player (this can cause problems with some scrips).
--local mapinfo = pshy.require("pshy.rotations.mapinfo")
--mapinfo.max_grounds = 50										-- Set the maximum amount of grounds parsed by `pshy_mapinfo`.
--local newgame = pshy.require("pshy.rotations.newgame")
--newgame.update_map_name_on_new_player = true					-- Enable or disable updating UI informations for new players.

perms.authors[5419276] = "Lays#1146"
perms.authors[70224600] = "Nnaaaz#0000"
perms.admins["Lays#1146"] = true
perms.admins["Nnaaaz#0000"] = true
perms.perms_auto_admin_authors = true

version.days_before_update_suggested = 14						-- How old the script should be before suggesting an update (`nil` to disable).
version.days_before_update_advised = 30							-- How old the script should be before requesting an update (`nil` to disable).
version.days_before_update_required = nil						-- How old the script should be before refusing to start (`nil` to disable).


---
-- Maps
---

rotations["sonic"] = Rotation:New({items = {}, autoskip = false, is_random = false, shamans = 0})
local sonic_maps = rotations["sonic"].items


--- Trap Test map
maps["test"] = {author = "Lays#1146", xml = levels["level-0"].xml, duration = 8 * 60}
maps["test"].traps = levels["level-0"].traps

--- Level 1
maps["level 1"] = {author = "Nnaaaz#0000", xml = levels["level-1"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 1"].traps = levels["level-1"].traps
maps["level 1"].bonuses = {
	{type = "SonicScore10", x = 4865, y = 490};
  {type = "SonicScore10", x = 8765, y = 970};
	{type = "SonicWin", x = 9456, y = 1317};
}
local coins = {{x = 600, y = 965}, {x = 640, y = 965}, {x = 680, y = 965}, {x = 1910, y = 951}, {x = 2513, y = 854}, {x = 3771, y = 638},  {x = 3811, y = 628},  {x = 3851, y = 628},  {x = 3891, y = 628},  {x = 3965, y = 844},  {x = 4005, y = 844},  {x = 4045, y = 844},  {x = 4482, y = 973},  {x = 4570, y = 966}, {x = 4651, y = 971}, {x = 4821, y = 933}, {x = 4861, y = 933}, {x = 5557, y = 761}, {x = 5565, y = 708}, {x = 5535, y = 671}, {x = 5477, y = 669}, {x = 5442, y = 711}, {x = 5449, y = 762}, {x = 5705, y = 793}, {x = 5737, y = 773}, {x = 5774, y = 757}, {x = 5864, y = 554}, {x = 5896, y = 555}, {x = 6177, y = 231}, {x = 6317, y = 231}, {x = 6457, y = 231}, {x = 6597, y = 231}, {x = 6737, y = 231}, {x = 6877, y = 231}, {x = 6153, y = 492}, {x = 6293, y = 492}, {x = 6433, y = 492}, {x = 6573, y = 492}, {x = 6449, y = 1004}, {x = 6489, y = 1004}, {x = 6529, y = 1004}, {x = 6569, y = 1004}, {x = 6609, y = 1004}, {x = 7281, y = 1152}, {x = 7307, y = 1070}, {x = 7351, y = 1009}, {x = 7930, y = 1324}, {x = 7970, y = 1324}, {x = 8010, y = 1324}, {x = 8050, y = 1324}, {x = 8090, y = 1324}, {x = 8520, y = 999}, {x = 8577, y = 1014}, {x = 8628, y = 1040}, {x = 8680, y = 1057}, {x = 8805, y = 969}, {x = 8845, y = 969}, {x = 9075, y = 1266}, {x = 9106, y = 1284}, {x = 9138, y = 1301}, {x = 9176, y = 1315}, {x = 9222, y = 1320}}
for i_coin, coin in ipairs(coins) do
coin.type = "SonicScore1"
table.insert(maps["level 1"].bonuses, coin)
end
table.insert(sonic_maps, "level 1")

--- Level 2
maps["level 2"] = {author = "Nnaaaz#0000", xml = levels["level-2"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 2"].traps = levels["level-2"].traps
maps["level 2"].bonuses = {
	{type = "SonicScore10", x = 220, y = 630};
  {type = "SonicScore10", x = 5250, y = 306};
	{type = "SonicWin", x = 7390, y = 857};
}
local coins = {{x = 342, y = 224}, {x = 382, y = 224}, {x = 423, y = 224}, {x = 1274, y = 238}, {x = 1314, y = 238}, {x = 1354, y = 238}, {x = 2185, y = 498}, {x = 2185, y = 538}, {x = 2185, y = 578}, {x = 2165, y = 608}, {x = 2132, y = 619}, {x = 2698, y = 493}, {x = 2698, y = 573}, {x = 2698, y = 533}, {x = 2718, y = 613}, {x = 2749, y = 626}, {x = 2790, y = 630}, {x = 3188, y = 600}, {x = 3208, y = 558}, {x = 3185, y = 509}, {x = 3117, y = 508}, {x = 3093, y = 559}, {x = 3116, y = 601}, {x = 3055, y = 453}, {x = 3185, y = 453}, {x = 3085, y = 453}, {x = 3215, y = 453}, {x = 3115, y = 453}, {x = 3245, y = 453}, {x = 3482, y = 630}, {x = 3522, y = 628}, {x = 3561, y = 618}, {x = 3583, y = 587}, {x = 3852, y = 569}, {x = 4150, y = 569}, {x = 4264, y = 569}, {x = 4555, y = 569}, {x = 3892, y = 569}, {x = 4190, y = 569}, {x = 4304, y = 569}, {x = 4595, y = 569}, {x = 5961, y = 494}, {x = 5961, y = 534}, {x = 5964, y = 573}, {x = 5983, y = 606}, {x = 6022, y = 625}, {x = 6054, y = 628}, {x = 5962, y = 458}, {x = 5184, y = 398}, {x = 5224, y = 398}, {x = 5264, y = 398}, {x = 2418, y = 861}, {x = 2458, y = 861}, {x = 2498, y = 861}, {x = 2538, y = 861}, {x = 1285, y = 632}, {x = 1325, y = 632}}
for i_coin, coin in ipairs(coins) do
coin.type = "SonicScore1"
table.insert(maps["level 2"].bonuses, coin)
end
table.insert(sonic_maps, "level 2")

--- Level 3
maps["level 3"] = {author = "Nnaaaz#0000", xml = levels["level-3"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 3"].traps = levels["level-3"].traps
maps["level 3"].bonuses = {
	{type = "SonicScore10", x = 2865, y = 240};
  {type = "SonicScore10", x = 5245, y = 1105};
  {type = "SonicScore10", x = 2865, y = 240};
  {type = "SonicScore10", x = 6930, y = 478};
	{type = "SonicWin", x = 9353, y = 864};
}
local coins = {{x = 721, y = 811}, {x = 761, y = 811}, {x = 801, y = 806}, {x = 841, y = 794}, {x = 881, y = 774}, {x = 971, y = 579}, {x = 1011, y = 579}, {x = 1051, y = 579}, {x = 1091, y = 579}, {x = 1490, y = 606}, {x = 1529, y = 597}, {x = 1569, y = 580}, {x = 1609, y = 580}, {x = 3116, y = 337}, {x = 3156, y = 337}, {x = 3196, y = 337}, {x = 3927, y = 851}, {x = 3858, y = 850}, {x = 3947, y = 829}, {x = 3838, y = 828}, {x = 3956, y = 799}, {x = 3829, y = 798}, {x = 3947, y = 765}, {x = 3838, y = 764}, {x = 3925, y = 743}, {x = 3860, y = 742}, {x = 3892, y = 733}, {x = 2881, y = 1289}, {x = 2921, y = 1289}, {x = 2961, y = 1289}, {x = 3001, y = 1289}, {x = 3041, y = 1289}, {x = 3081, y = 1289}, {x = 4288, y = 812}, {x = 4328, y = 810}, {x = 4368, y = 798}, {x = 4400, y = 785}, {x = 5935, y = 869}, {x = 6005, y = 869}, {x = 6085, y = 869}, {x = 6165, y = 869}, {x = 6245, y = 869}, {x = 6325, y = 869}, {x = 7126, y = 879}, {x = 7166, y = 867}, {x = 7206, y = 844}, {x = 7246, y = 824}, {x = 8240, y = 869}, {x = 8280, y = 869}, {x = 8318, y = 857}, {x = 8338, y = 827}, {x = 3450, y = 166}, {x = 3490, y = 166}, {x = 3530, y = 166}, {x = 3570, y = 166}, {x = 3283, y = 102}, {x = 3283, y = 152}, {x = 7424, y = 724}, {x = 7854, y = 714}, {x = 7894, y = 714}}
for i_coin, coin in ipairs(coins) do
coin.type = "SonicScore1"
table.insert(maps["level 3"].bonuses, coin)
end
table.insert(sonic_maps, "level 3")

--- Level 4
maps["level 4"] = {author = "Nnaaaz#0000", xml = levels["level-4"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 4"].traps = levels["level-4"].traps
maps["level 4"].bonuses = {
	{type = "SonicScore10", x = 2105, y = 586};
	{type = "SonicScore10", x = 3665, y = 1065};
  {type = "SonicScore10", x = 3695, y = 1065};
  {type = "SonicScore10", x = 3755, y = 1065};
  {type = "SonicScore10", x = 3785, y = 1065};
	{type = "SonicWin", x = 6395, y = 550};
}
local coins = {{x = 379, y = 477}, {x = 419, y = 477}, {x = 459, y = 477}, {x = 599, y = 461}, {x = 858, y = 461}, {x = 1108, y = 461}, {x = 639, y = 451}, {x = 898, y = 451}, {x = 1148, y = 451}, {x = 679, y = 461}, {x = 938, y = 461}, {x = 1188, y = 461}, {x = 1867, y = 226}, {x = 1907, y = 226}, {x = 2132, y = 326}, {x = 2164, y = 356}, {x = 2198, y = 387}, {x = 2228, y = 424}, {x = 2262, y = 448}, {x = 2301, y = 453}, {x = 3672, y = 588}, {x = 3712, y = 626}, {x = 3751, y = 666}, {x = 3791, y = 700}, {x = 3831, y = 710}, {x = 3086, y = 869}, {x = 3213, y = 869}, {x = 3340, y = 869}, {x = 3469, y = 869}, {x = 3116, y = 869}, {x = 3243, y = 869}, {x = 3370, y = 869}, {x = 3499, y = 869}, {x = 3868, y = 1287}, {x = 3934, y = 1256}, {x = 4015, y = 1224}, {x = 4055, y = 1224}, {x = 4095, y = 1224}, {x = 4135, y = 1224}, {x = 4806, y = 537}, {x = 4935, y = 487}, {x = 5125, y = 487}, {x = 5320, y = 427}, {x = 5448, y = 491}, {x = 4846, y = 537}, {x = 4975, y = 487}, {x = 5165, y = 487}, {x = 5360, y = 427}, {x = 5488, y = 491}, {x = 5658, y = 553}}
for i_coin, coin in ipairs(coins) do
coin.type = "SonicScore1"
table.insert(maps["level 4"].bonuses, coin)
end
table.insert(sonic_maps, "level 4")

--- Level 5
maps["level 5"] = {author = "Nnaaaz#0000", xml = levels["level-5"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 5"].traps = levels["level-5"].traps
maps["level 5"].bonuses = {
	{type = "SonicScore10", x = 1200, y = 841};
	{type = "SonicScore10", x = 2408, y = 1065};
	{type = "SonicScore10", x = 2488, y = 1065};
	{type = "SonicScore10", x = 3895, y = 584};
	{type = "SonicScore10", x = 3920, y = 584};
	{type = "SonicWin", x = 6505, y = 550};
}
local coins = {{x = 339, y = 489}, {x = 369, y = 489}, {x = 1362, y = 647}, {x = 1392, y = 647}, {x = 1422, y = 647}, {x = 1452, y = 647}, {x = 907, y = 1353}, {x = 1161, y = 1353}, {x = 1418, y = 1353}, {x = 1564, y = 1291}, {x = 1994, y = 1131}, {x = 3340, y = 907}, {x = 3084, y = 907}, {x = 927, y = 1353}, {x = 1181, y = 1353}, {x = 1438, y = 1353}, {x = 1584, y = 1291}, {x = 2014, y = 1131}, {x = 3360, y = 907}, {x = 3104, y = 907}, {x = 947, y = 1353}, {x = 1201, y = 1353}, {x = 1458, y = 1353}, {x = 1604, y = 1291}, {x = 2034, y = 1131}, {x = 3380, y = 907}, {x = 3124, y = 907}, {x = 2475, y = 693}, {x = 2571, y = 490}, {x = 2892, y = 377}, {x = 3932, y = 336}, {x = 2515, y = 693}, {x = 2611, y = 490}, {x = 2932, y = 377}, {x = 3969, y = 369}, {x = 3999, y = 399}, {x = 4029, y = 429}, {x = 4059, y = 452}, {x = 4115, y = 1256}, {x = 4145, y = 1256}, {x = 4515, y = 1286}, {x = 4665, y = 1286}, {x = 4175, y = 1256}, {x = 4545, y = 1286}, {x = 4695, y = 1286}}
for i_coin, coin in ipairs(coins) do
coin.type = "SonicScore1"
table.insert(maps["level 5"].bonuses, coin)
end
table.insert(sonic_maps, "level 5")

--- Level 6
maps["level 6"] = {author = "Nnaaaz#0000", xml = levels["level-6"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 6"].traps = levels["level-6"].traps
table.insert(sonic_maps, "level 6")
---
-- Variables
---

local holding_key = {}


---
-- Functions
---

local function TouchPlayer(name)
  tfm.exec.bindKeyboard(name, 0, true, true)
  tfm.exec.bindKeyboard(name, 0, false, true)
  tfm.exec.bindKeyboard(name, 2, true, true)
  tfm.exec.bindKeyboard(name, 2, false, true)
  system.bindMouse(name, true)
end


local function ApplyPlayerForce(name)
    tfm.exec.setPlayerGravityScale(
      name,
      1,
      holding_key[name] and holding_key[name] ~= 0 and holding_key[name] * 30 or 1
    )
end


---
-- TFM Events
---

function eventNewGame()
  tfm.exec.setWorldGravity(0.1, 10)
end


function eventNewPlayer(name)
  TouchPlayer(name)
  tfm.exec.respawnPlayer(name)
end


function eventPlayerRespawn(name)
  ApplyPlayerForce(name)
end


function eventMouse(name, x, y)
  tfm.exec.movePlayer(name, x, y)
end


function eventKeyboard(name, key, down, x, y, vx, vy)
  if key == 2 or key == 0 then
    if down then
      holding_key[name] = key - 1
    elseif holding_key[name] then
      holding_key[name] = 0
    end
    
    ApplyPlayerForce(name)
  end
end


function eventPlayerDied(name)
  tfm.exec.respawnPlayer(name)
end


function eventPlayerWon(name)
  tfm.exec.respawnPlayer(name)
end


---
-- Other Events
---

function eventInit()
  for name in pairs(tfm.get.room.playerList) do
    TouchPlayer(name)
  end
  
	newgame.SetRotation("sonic")
	tfm.exec.newGame("sonic")
end
