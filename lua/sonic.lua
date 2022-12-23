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

local perms = pshy.require("pshy.perms")
local version = pshy.require("pshy.bases.version")
local rotations = pshy.require("pshy.rotations.list")
local newgame = pshy.require("pshy.rotations.newgame")
local Rotation = pshy.require("pshy.utils.rotation")
local maps = pshy.require("pshy.maps.list")

local grounds = pshy.require("grounds")
local traps = pshy.require("traps")
local levels = pshy.require("generated_levels")


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

--- Level 2
maps["level 2"] = {author = "Nnaaaz#0000", xml = levels["level-2"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 2"].traps = levels["level-2"].traps

--- Level 3
maps["level 3"] = {author = "Nnaaaz#0000", xml = levels["level-3"].xml, background_color = "#5c94fc", duration = 8 * 60}
maps["level 3"].traps = levels["level-3"].traps
--[[
maps["level 1"].grounds = {
	{
		interval = 1, -- must be multiples of 0.5
		hidden = true,

		props = {
			x = 50,
			y = 250,
			type = tfm.enum.ground.wood,
			angle = 0,
			width = 100,
			height = 100,
			friction = 0.3,
			restitution = 0.1,
			miceCollision = true,
			groundCollision = true,
		},

		image = {
			id = "149a49e4b38.jpg",
			x = 0,
			y = 0,
			scaleX = 1,
			scaleY = 1,
			rotation = 0,
			alpha = 1,
			anchorX = 0.5,
			anchorX = 0.5,
			fadeIn = false,
		},
	},
	{
		interval = 3, -- must be multiples of 0.5
		timerTick = 6,
		hidden = false,

		props = {
			x = 300,
			y = 250,
			type = tfm.enum.ground.ice,
			angle = -30,
			width = 100,
			height = 100,
			friction = 0,
			restitution = 0.1,
			miceCollision = true,
			groundCollision = true,
			dynamic = false,
		},

		image = {
			id = "174c530f384.png",
		},
	},
	{
		onContact = {
			grounds.utils.cond('speed', 'gt', 5, grounds.actions.hide),
		},

		props = {
			id = 500,
			x = 300,
			y = 350,
			type = tfm.enum.ground.trampoline,
			angle = -30,
			width = 100,
			height = 100,
			friction = 0,
			restitution = 0.1,
			miceCollision = true,
			groundCollision = true,
			dynamic = false,
		},

		image = {
			id = "174c530f384.png",
		},
	},
}
--]]
table.insert(sonic_maps, "level 1")


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


---
-- TFM Events
---

function eventNewGame()
  tfm.exec.setWorldGravity(0.1, 10)
end


function eventNewPlayer(name)
  TouchPlayer(name)
end


function eventMouse(name, x, y)
  tfm.exec.movePlayer(name, x, y)
end


function eventKeyboard(name, key, down, x, y, vx, vy)
  if key == 2 or key == 0 then
    if down then
      holding_key[name] = (holding_key[name] or 0) + key - 1
    elseif holding_key[name] then
      holding_key[name] = holding_key[name] - key + 1
    end
    
    tfm.exec.setPlayerGravityScale(
      name,
      1,
      holding_key[name] and holding_key[name] ~= 0 and holding_key[name] * 30 or 1
    )
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
