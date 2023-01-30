--- bonus_win
local bonuses = pshy.require("pshy.bonuses")
local bonus_types = pshy.require("pshy.bonuses.list")
local image_list = pshy.require("pshy.images.list")
local addimage = pshy.require("pshy.images.addimage")



--- SonicBonusWin.
image_list["1848a16ac45.png"] = {bonus = true, w = 48, h = 48}
image_list["1848a165271.png"] = {bonus = true, w = 50, h = 50}
local function SonicWin(player_name, bonus)
	addimage.AddImage("1848a165271.png", "!0", bonus.x, bonus.y, player_name, nil, nil, 0.0, 1.0)
	tfm.exec.giveCheese(player_name)
	tfm.exec.playerVictory(player_name)
end
bonus_types["SonicWin"] = {image = "1848a16ac45.png", func = SonicWin, behavior = bonuses.BEHAVIOR_REMAIN}
