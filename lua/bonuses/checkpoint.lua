--- bonus_checkpoint
local checkpoints = pshy.require("pshy.bases.checkpoints")
local bonuses = pshy.require("pshy.bonuses")
local bonus_types = pshy.require("pshy.bonuses.list")
local image_list = pshy.require("pshy.images.list")
local addimage = pshy.require("pshy.images.addimage")
local players = pshy.require("pshy.players")



local player_checkpoint_images = {}



--- SonicCheckpoint.
image_list["185fe23fbb5.png"] = {bonus = true, w = 16, h = 64, ay = 0.80}
image_list["185fe23af80.png"] = {bonus = true, w = 16, h = 64, ay = 0.80}
local function SonicCheckpoint(player_name, bonus)
	checkpoints.SetPlayerCheckpoint(player_name, bonus.x, bonus.y)
	if player_checkpoint_images[player_name] then
		tfm.exec.removeImage(player_checkpoint_images[player_name])
	end
	player_checkpoint_images[player_name] = addimage.AddImage("185fe23af80.png", "!9999999", bonus.x, bonus.y, player_name, nil, nil, 0.0, 1.0)
end
bonus_types["SonicCheckpoint"] = {image = "185fe23fbb5.png", foreground = true, func = SonicCheckpoint, behavior = bonuses.BEHAVIOR_REMAIN}



function eventPlayerWon(player_name)
	if player_checkpoint_images[player_name] then
		tfm.exec.removeImage(player_checkpoint_images[player_name])
	end
	checkpoints.UnsetPlayerCheckpoint(player_name)
end
