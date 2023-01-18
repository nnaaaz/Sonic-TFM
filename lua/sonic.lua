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
	{type = "SonicScore1", x = 1, y = 1};
	{type = "SonicScore10", x = 509, y = 1076};
	{type = "SonicWin", x = 609, y = 1076};
}
local coins = {{x = 600, y = 965}, {x = 640, y = 965}, {x = 680, y = 965}, {x = 1910, y = 951}, {x = 2513, y = 854}, {x = 3771, y = 638},  {x = 3811, y = 628},  {x = 3851, y = 628},  {x = 3891, y = 628},  {x = 3965, y = 844},  {x = 4005, y = 844},  {x = 4045, y = 844},  {x = 4482, y = 973},  {x = 4570, y = 966}, {x = 4651, y = 971}, {x = 4821, y = 933}, {x = 4861, y = 933}, {x = 4825, y = 487}, {x = 4865, y = 487}, {x = 4905, y = 487}, {x = 5557, y = 761}, {x = 5565, y = 708}, {x = 5535, y = 671}, {x = 5477, y = 669}, {x = 5442, y = 711}, {x = 5449, y = 762}, {x = 5705, y = 793}, {x = 5737, y = 773}, {x = 5774, y = 757}, {x = 5864, y = 554}, {x = 5896, y = 555}, {x = 6177, y = 231}, {x = 6317, y = 231}, {x = 6457, y = 231}, {x = 6597, y = 231}, {x = 6737, y = 231}, {x = 6877, y = 231}, {x = 6153, y = 492}, {x = 6293, y = 492}, {x = 6433, y = 492}, {x = 6573, y = 492}, {x = 6449, y = 1004}, {x = 6489, y = 1004}, {x = 6529, y = 1004}, {x = 6569, y = 1004}, {x = 6609, y = 1004}, {x = 7281, y = 1152}, {x = 7307, y = 1070}, {x = 7351, y = 1009}, {x = 7930, y = 1324}, {x = 7970, y = 1324}, {x = 8010, y = 1324}, {x = 8050, y = 1324}, {x = 8090, y = 1324}, {x = 8520, y = 999}, {x = 8577, y = 1014}, {x = 8628, y = 1040}, {x = 8680, y = 1057}, {x = 8805, y = 969}, {x = 8845, y = 969}, {x = 9075, y = 1266}, {x = 9106, y = 1284}, {x = 9138, y = 1301}, {x = 9176, y = 1315}, {x = 9222, y = 1320}}
for i_coin, coin in ipairs(coins) do
coin.type = "SonicScore1"
table.insert(maps["level 1"].bonuses, coin)
end
table.insert(sonic_maps, "level 1")

--- Level 2
maps["level 2"] = {author = "Nnaaaz#0000", xml = levels["level-2"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 2"].traps = levels["level-2"].traps
table.insert(sonic_maps, "level 2")

--- Level 3
maps["level 3"] = {author = "Nnaaaz#0000", xml = levels["level-3"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 3"].traps = levels["level-3"].traps
table.insert(sonic_maps, "level 3")

--- Level 4
maps["level 4"] = {author = "Nnaaaz#0000", xml = levels["level-4"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 4"].traps = levels["level-4"].traps
table.insert(sonic_maps, "level 4")

--- Level 5
maps["level 5"] = {author = "Nnaaaz#0000", xml = levels["level-5"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 5"].traps = levels["level-5"].traps
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
