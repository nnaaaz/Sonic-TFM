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
local mapinfo = pshy.require("pshy.rotations.mapinfo")
mapinfo.max_grounds = 0
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

pshy.require("bonuses.score1")
pshy.require("bonuses.score10")
pshy.require("bonuses.win")
pshy.require("bonuses.checkpoint")
pshy.require ("pshy.alternatives.chat")
pshy.require ("pshy.alternatives.timers")
splashscreen = pshy.require("pshy.bases.splashscreen")
splashscreen.image="18626ac8cb2.png"


---
-- TFM Settings
---

system.disableChatCommandDisplay(nil, true)
tfm.exec.disableAfkDeath(true)
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

perms.authors["Lays#1146"] = true
perms.authors["Nnaaaz#0000"] = true
perms.admins["Lays#1146"] = true
perms.admins["Nnaaaz#0000"] = true
perms.perms_auto_admin_authors = true

version.days_before_update_suggested = 14						-- How old the script should be before suggesting an update (`nil` to disable).
version.days_before_update_advised = 30							-- How old the script should be before requesting an update (`nil` to disable).
version.days_before_update_required = nil						-- How old the script should be before refusing to start (`nil` to disable).

splashscreen.y = 40                    -- y location
splashscreen.duration = 6 * 1000       -- duration of the splashscreen in milliseconds

---
-- Maps
---

rotations["sonic"] = Rotation:New({items = {}, autoskip = false, is_random = false, shamans = 0})
local sonic_maps = rotations["sonic"].items


--- Trap Test map
maps["test"] = {author = "Lays#1146", xml = levels["level-0"].xml, duration = 8 * 60}
maps["test"].traps = levels["level-0"].traps
maps["test"].disable_boost = true

--- Level 1
maps["level 1"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["level-1"].xml, title = "<strike><n>Green Hill Zone</n></strike> <j>Act 1</j>", background_color = "#2400b6", duration = 8 * 60}
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
table.insert(maps["level 1"].bonuses, {type = "SonicCheckpoint", x = 6520, y = 1010})
table.insert(sonic_maps, "level 1")

--- Level 2
maps["level 2"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["level-2"].xml, title = "<strike><n>Green Hill Zone</n></strike> <j>Act 2</j>",  background_color = "#2400b6", duration = 8 * 60}
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
table.insert(maps["level 2"].bonuses, {type = "SonicCheckpoint", x = 4445, y = 570})
table.insert(sonic_maps, "level 2")

--- Level 3
maps["level 3"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["level-3"].xml, title = "<strike><n>Green Hill Zone</n></strike> <j>Act 3</j>", background_color = "#2400b6", duration = 8 * 60}
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
table.insert(maps["level 3"].bonuses, {type = "SonicCheckpoint", x = 4900, y = 813})
table.insert(sonic_maps, "level 3")

--- special Stage 1
maps["special stage 1"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["special-stage-1"].xml, title = "<strike><n>Special Stage</n></strike> <j>1</j>", background_color = "#00b4b4", duration = 90, autorespawn = false}
maps["special stage 1"].traps = levels["special-stage-1"].traps
maps["special stage 1"].bonuses = {}

local coins = {{x = 242, y = 187}, {x = 271, y = 257}, {x = 407, y = 298}, {x = 479, y = 388}, {x = 482, y = 578}, {x = 482, y = 647}, {x = 272, y = 187}, {x = 301, y = 257}, {x = 437, y = 298}, {x = 511, y = 388}, {x = 514, y = 578}, {x = 514, y = 647}, {x = 494, y = 754}, {x = 494, y = 794}, {x = 494, y = 834}, {x = 638, y = 613}, {x = 678, y = 613}, {x = 718, y = 613}, {x = 137, y = 501}, {x = 137, y = 810}, {x = 137, y = 461}, {x = 137, y = 770}, {x = 137, y = 421}, {x = 137, y = 730}, {x = 89, y = 648}, {x = 89, y = 568}, {x = 187, y = 532}, {x = 187, y = 692}, {x = 273, y = 568}, {x = 273, y = 648}}
for i_coin, coin in ipairs(coins) do
  coin.type = "SonicScore1"
  table.insert(maps["special stage 1"].bonuses, coin)
end
table.insert(sonic_maps, "special stage 1")
--- Level 4
maps["level 4"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["level-4"].xml, title = "<strike><n>Marble Zone</n></strike> <j>Act 1</j>", background_color = "#0000b6", duration = 8 * 60}
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
table.insert(maps["level 4"].bonuses, {type = "SonicCheckpoint", x = 2677, y = 1226})
table.insert(sonic_maps, "level 4")

--- Level 5
maps["level 5"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["level-5"].xml, title = "<strike><n>Marble Zone</n></strike> <j>Act 2</j>", background_color = "#0000b6", duration = 8 * 60}
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
table.insert(maps["level 5"].bonuses, {type = "SonicCheckpoint", x = 2015, y = 1227})
table.insert(maps["level 5"].bonuses, {type = "SonicCheckpoint", x = 3585, y = 300})
table.insert(sonic_maps, "level 5")

--- Level 6
maps["level 6"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["level-6"].xml, title = "<strike><n>Marble Zone</n></strike> <j>Act 3</j>", background_color = "#0000b6", duration = 8 * 60}
maps["level 6"].traps = levels["level-6"].traps
maps["level 6"].bonuses = {
	{type = "SonicScore10", x = 2030, y = 642};
	{type = "SonicScore10", x = 270, y = 1698};
	{type = "SonicScore10", x = 2903, y = 1410};
	{type = "SonicScore10", x = 2959, y = 1410};
	{type = "SonicScore10", x = 3018, y = 1410};
	{type = "SonicScore10", x = 3630, y = 1026};
	{type = "SonicWin", x = 6762, y = 637};
}
local coins = {{x = 1383, y = 433}, {x = 1423, y = 473}, {x = 1463, y = 513}, {x = 1503, y = 543}, {x = 1842, y = 803}, {x = 1882, y = 803}, {x = 1559, y = 1059}, {x = 1599, y = 1059}, {x = 1639, y = 1059}, {x = 867, y = 1640}, {x = 927, y = 1640}, {x = 987, y = 1640}, {x = 1047, y = 1640}, {x = 1107, y = 1640}, {x = 1167, y = 1640}, {x = 1227, y = 1640}, {x = 1287, y = 1640}, {x = 1347, y = 1640}, {x = 1808, y = 1469}, {x = 1936, y = 1469}, {x = 3982, y = 1728}, {x = 4111, y = 1728}, {x = 1840, y = 1469}, {x = 1968, y = 1469}, {x = 4014, y = 1728}, {x = 4143, y = 1728}, {x = 4900, y = 1698}, {x = 4900, y = 1668}, {x = 4900, y = 1638}, {x = 4900, y = 1608}, {x = 5206, y = 1666}, {x = 5246, y = 1666}, {x = 5226, y = 1646}, {x = 5286, y = 1666}, {x = 5266, y = 1646}, {x = 5246, y = 1626}, {x = 4620, y = 1249}, {x = 4362, y = 1249}, {x = 4105, y = 1249}, {x = 4660, y = 1249}, {x = 4402, y = 1249}, {x = 4145, y = 1249}, {x = 3858, y = 1313}, {x = 3888, y = 1313}, {x = 3918, y = 1313}, {x = 5097, y = 638}, {x = 5137, y = 638}, {x = 881, y = 378}, {x = 921, y = 378}, {x = 332, y = 322}, {x = 372, y = 322}}
for i_coin, coin in ipairs(coins) do
  coin.type = "SonicScore1"
  table.insert(maps["level 6"].bonuses, coin)
end
table.insert(maps["level 6"].bonuses, {type = "SonicCheckpoint", x = 360, y = 1698})
table.insert(maps["level 6"].bonuses, {type = "SonicCheckpoint", x = 2372, y = 1953})
table.insert(maps["level 6"].bonuses, {type = "SonicCheckpoint", x = 5154, y = 1667})
table.insert(sonic_maps, "level 6")

--- special stage 2
maps["special stage 2"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["special-stage-2"].xml, title = "<strike><n>Special Stage</n></strike> <j>2</j>", background_color = "#00b4b4", duration = 90, autorespawn = false}
maps["special stage 2"].traps = levels["special-stage-2"].traps
maps["special stage 2"].bonuses = {}

local coins = {{x = 283, y = 130}, {x = 430, y = 309}, {x = 575, y = 450}, {x = 285, y = 450}, {x = 283, y = 882}, {x = 583, y = 882}, {x = 573, y = 130}, {x = 283, y = 170}, {x = 430, y = 349}, {x = 575, y = 490}, {x = 285, y = 490}, {x = 283, y = 922}, {x = 583, y = 922}, {x = 573, y = 170}, {x = 323, y = 130}, {x = 470, y = 309}, {x = 615, y = 450}, {x = 325, y = 450}, {x = 323, y = 882}, {x = 623, y = 882}, {x = 613, y = 130}, {x = 323, y = 170}, {x = 470, y = 349}, {x = 615, y = 490}, {x = 325, y = 490}, {x = 323, y = 922}, {x = 623, y = 922}, {x = 613, y = 170}}
for i_coin, coin in ipairs(coins) do
  coin.type = "SonicScore1"
  table.insert(maps["special stage 2"].bonuses, coin)
end
table.insert(sonic_maps, "special stage 2")
--- Level 7
maps["level 7"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["level-7"].xml, title = "<strike><n>Spring Yard Zone</n></strike> <j>Act 1</j>", background_color = "#6d246d", duration = 8 * 60}
maps["level 7"].traps = levels["level-7"].traps
maps["level 7"].bonuses = {
	{type = "SonicScore10", x = 382, y = 210};
  {type = "SonicScore10", x = 2333, y = 240};
  {type = "SonicScore10", x = 6865, y = 832};
	{type = "SonicWin", x = 9216, y = 699};
}
local coins = {{x = 298, y = 213}, {x = 338, y = 213}, {x = 430, y = 213}, {x = 470, y = 213}, {x = 1039, y = 417}, {x = 1039, y = 357}, {x = 1039, y = 297}, {x = 1114, y = 145}, {x = 1149, y = 143}, {x = 1182, y = 150}, {x = 1603, y = 242}, {x = 1643, y = 242}, {x = 1683, y = 242}, {x = 1723, y = 242}, {x = 2641, y = 235}, {x = 2681, y = 235}, {x = 2721, y = 235}, {x = 3431, y = 336}, {x = 3471, y = 336}, {x = 4041, y = 433}, {x = 4111, y = 433}, {x = 4191, y = 433}, {x = 4510, y = 428}, {x = 4813, y = 422}, {x = 4271, y = 433}, {x = 4545, y = 447}, {x = 4778, y = 441}, {x = 4580, y = 465}, {x = 4743, y = 459}, {x = 4187, y = 1140}, {x = 5209, y = 1140}, {x = 4217, y = 1140}, {x = 5239, y = 1140}, {x = 4247, y = 1140}, {x = 5269, y = 1140}, {x = 6973, y = 594}, {x = 7231, y = 594}, {x = 7013, y = 604}, {x = 7271, y = 604}, {x = 7053, y = 604}, {x = 7311, y = 604}, {x = 7093, y = 594}, {x = 7351, y = 594}, {x = 7443, y = 409}, {x = 7958, y = 409}, {x = 7473, y = 309}, {x = 7988, y = 309}, {x = 7513, y = 409}, {x = 8028, y = 409}, {x = 7473, y = 509}, {x = 7988, y = 509}, {x = 7513, y = 609}, {x = 8028, y = 609}, {x = 7543, y = 309}, {x = 8058, y = 309}, {x = 7583, y = 409}, {x = 8098, y = 409}, {x = 7543, y = 509}, {x = 8058, y = 509}, {x = 7583, y = 609}, {x = 8098, y = 609}, {x = 7613, y = 309}, {x = 8128, y = 309}, {x = 7653, y = 409}, {x = 8168, y = 409}, {x = 7613, y = 509}, {x = 8128, y = 509}}
for i_coin, coin in ipairs(coins) do
  coin.type = "SonicScore1"
  table.insert(maps["level 7"].bonuses, coin)
end
table.insert(maps["level 7"].bonuses, {type = "SonicCheckpoint", x = 2820, y = 915})
table.insert(sonic_maps, "level 7")

--- Level 8
maps["level 8"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["level-8"].xml, title = "<strike><n>Spring Yard Zone</n></strike> <j>Act 2</j>", background_color = "#6d246d", duration = 8 * 60}
maps["level 8"].traps = levels["level-8"].traps
maps["level 8"].bonuses = {
	{type = "SonicScore10", x = 1600, y = 211};
	{type = "SonicScore10", x = 5138, y = 1457};
	{type = "SonicScore10", x = 6420, y = 593};
	{type = "SonicScore10", x = 1630, y = 211};
	{type = "SonicWin", x = 10752, y = 1214};
	{type = "SonicWin", x = 10752, y = 1470};
}
local coins = {{x = 792, y = 1332}, {x = 821, y = 1362}, {x = 862, y = 1377}, {x = 913, y = 1379}, {x = 954, y = 1371}, {x = 989, y = 1346}, {x = 1894, y = 1391}, {x = 2405, y = 1359}, {x = 1934, y = 1391}, {x = 2445, y = 1359}, {x = 1837, y = 845}, {x = 2094, y = 845}, {x = 8492, y = 1102}, {x = 1989, y = 845}, {x = 2246, y = 845}, {x = 8661, y = 1101}, {x = 1884, y = 864}, {x = 2141, y = 864}, {x = 8549, y = 1121}, {x = 1942, y = 864}, {x = 2199, y = 864}, {x = 8607, y = 1121}, {x = 3417, y = 314}, {x = 3424, y = 514}, {x = 3372, y = 414}, {x = 3382, y = 614}, {x = 3487, y = 314}, {x = 3494, y = 514}, {x = 3442, y = 414}, {x = 3452, y = 614}, {x = 3512, y = 414}, {x = 3522, y = 614}, {x = 5176, y = 1198}, {x = 5197, y = 1070}, {x = 5226, y = 1198}, {x = 5247, y = 1070}, {x = 5276, y = 1198}, {x = 5297, y = 1070}, {x = 5326, y = 1198}, {x = 3906, y = 1408}, {x = 4046, y = 1408}, {x = 4186, y = 1408}, {x = 4326, y = 1408}, {x = 4466, y = 1408}, {x = 4606, y = 1408}, {x = 4746, y = 1408}, {x = 4886, y = 1408}, {x = 5026, y = 1408}, {x = 6816, y = 649}, {x = 6816, y = 689}, {x = 6816, y = 729}, {x = 6816, y = 769}, {x = 7340, y = 630}, {x = 7567, y = 663}, {x = 7935, y = 658}, {x = 9782, y = 1051}, {x = 9822, y = 1051}, {x = 9862, y = 1051}, {x = 9933, y = 1051}, {x = 9234, y = 1312}, {x = 9252, y = 1350}, {x = 9290, y = 1374}, {x = 9336, y = 1377}, {x = 9381, y = 1365}, {x = 9422, y = 1342}, {x = 9460, y = 1325}}
for i_coin, coin in ipairs(coins) do
  coin.type = "SonicScore1"
  table.insert(maps["level 8"].bonuses, coin)
end
table.insert(maps["level 8"].bonuses, {type = "SonicCheckpoint", x = 5786, y = 708})
table.insert(sonic_maps, "level 8")

--- Level 9
maps["level 9"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["level-9"].xml, title = "<strike><n>Spring Yard Zone</n></strike> <j>Act 3</j>", background_color = "#6d246d", duration = 8 * 60}
maps["level 9"].traps = levels["level-9"].traps
maps["level 9"].bonuses = {
	{type = "SonicScore10", x = 2710, y = 705};
	{type = "SonicScore10", x = 10660, y = 722};
	{type = "SonicScore10", x = 10690, y = 722};
	{type = "SonicScore10", x = 3610, y = 705};
	{type = "SonicWin", x = 12096, y = 1355};
}
local coins = {{x = 1847, y = 1279}, {x = 9777, y = 1589}, {x = 1847, y = 1099}, {x = 9777, y = 1409}, {x = 1877, y = 1189}, {x = 9807, y = 1499}, {x = 1927, y = 1279}, {x = 9857, y = 1589}, {x = 1927, y = 1099}, {x = 9857, y = 1409}, {x = 1957, y = 1189}, {x = 9887, y = 1499}, {x = 1997, y = 1279}, {x = 9927, y = 1589}, {x = 1997, y = 1099}, {x = 9927, y = 1409}, {x = 2919, y = 1141}, {x = 2959, y = 1141}, {x = 3958, y = 336}, {x = 3998, y = 336}, {x = 4205, y = 191}, {x = 4245, y = 191}, {x = 4285, y = 191}, {x = 4659, y = 851}, {x = 4917, y = 851}, {x = 4720, y = 866}, {x = 4978, y = 866}, {x = 4790, y = 854}, {x = 5048, y = 854}, {x = 5393, y = 961}, {x = 5472, y = 961}, {x = 5552, y = 961}, {x = 6160, y = 283}, {x = 6160, y = 583}, {x = 6160, y = 883}, {x = 6380, y = 733}, {x = 6380, y = 433}, {x = 6380, y = 133}, {x = 6160, y = 383}, {x = 6160, y = 683}, {x = 6160, y = 983}, {x = 6380, y = 833}, {x = 6380, y = 533}, {x = 6380, y = 233}, {x = 6160, y = 333}, {x = 6160, y = 633}, {x = 6160, y = 933}, {x = 6380, y = 783}, {x = 6380, y = 483}, {x = 6380, y = 183}, {x = 6160, y = 433}, {x = 6160, y = 733}, {x = 6160, y = 1033}, {x = 6380, y = 883}, {x = 6380, y = 583}, {x = 6380, y = 283}, {x = 7235, y = 1485}, {x = 7362, y = 1485}, {x = 7487, y = 1485}, {x = 7617, y = 1485}, {x = 7840, y = 1175}, {x = 7840, y = 1225}, {x = 7840, y = 1275}, {x = 8209, y = 786}, {x = 8414, y = 786}, {x = 8465, y = 786}, {x = 8669, y = 786}, {x = 8722, y = 786}, {x = 8925, y = 786}, {x = 8309, y = 866}, {x = 8569, y = 866}, {x = 8826, y = 866}, {x = 9486, y = 1167}, {x = 9486, y = 1117}, {x = 9486, y = 1067}, {x = 9486, y = 1017}, {x = 10285, y = 722}, {x = 10365, y = 722}, {x = 10445, y = 722}}
for i_coin, coin in ipairs(coins) do
  coin.type = "SonicScore1"
  table.insert(maps["level 9"].bonuses, coin)
end
table.insert(maps["level 9"].bonuses, {type = "SonicCheckpoint", x = 3375, y = 708})
table.insert(maps["level 9"].bonuses, {type = "SonicCheckpoint", x = 6877, y = 1428})
table.insert(sonic_maps, "level 9")

--- special stage 3
maps["special stage 3"] = {author = "<strike><b><bv>SONIC</bv></b></strike>", xml = levels["special-stage-3"].xml, title = "<strike><n>Special Stage</n></strike> <j>3</j>", background_color = "#00b4b4", duration = 90, autorespawn = false}
maps["special stage 3"].traps = levels["special-stage-3"].traps
maps["special stage 3"].bonuses = {}
local coins = {{x = 333, y = 169}, {x = 330, y = 720}, {x = 383, y = 169}, {x = 380, y = 720}, {x = 433, y = 169}, {x = 430, y = 720}, {x = 483, y = 169}, {x = 480, y = 720}, {x = 128, y = 373}, {x = 681, y = 373}, {x = 128, y = 423}, {x = 681, y = 423}, {x = 128, y = 473}, {x = 681, y = 473}, {x = 128, y = 523}, {x = 681, y = 523}, {x = 194, y = 635}, {x = 194, y = 248}, {x = 580, y = 635}, {x = 580, y = 248}, {x = 234, y = 635}, {x = 234, y = 248}, {x = 620, y = 635}, {x = 620, y = 248}, {x = 370, y = 564}, {x = 370, y = 322}, {x = 335, y = 380}, {x = 475, y = 378}, {x = 475, y = 508}, {x = 335, y = 508}, {x = 410, y = 564}, {x = 410, y = 322}, {x = 450, y = 564}, {x = 450, y = 322}}
for i_coin, coin in ipairs(coins) do
  coin.type = "SonicScore1"
  table.insert(maps["special stage 3"].bonuses, coin)
end
table.insert(sonic_maps, "special stage 3")

---
-- Variables
---

local holding_key = {}
local boost_enabled = true
local pending_respawn_players = {}


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
  if boost_enabled then
    tfm.exec.setPlayerGravityScale(
      name,
      1,
      holding_key[name] and holding_key[name] * 30 or 0
    )
  end
end


---
-- TFM Events
---

function eventNewGame()
  local map = newgame.current_map
  boost_enabled = not map or not map.disable_boost
  pending_respawn_players = {}
end

function eventNewPlayer(name)
  TouchPlayer(name)
  pending_respawn_players[name] = true
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
  pending_respawn_players[name] = true
end


function eventPlayerWon(name)
  tfm.exec.chatMessage(string.format("<v>[<bv>SONIC</bv>]</v> <ch>%s completed the level!</ch>", name))
  pending_respawn_players[name] = true
end


function eventLoop()
  if newgame.current_map and newgame.current_map.autorespawn ~= false then
    for player_name in pairs(pending_respawn_players) do
      tfm.exec.respawnPlayer(player_name)
    end
  end
  pending_respawn_players = {}
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
