--- bonus_score1
local bonuses = pshy.require("pshy.bonuses")
local bonus_types = pshy.require("pshy.bonuses.list")
local image_list = pshy.require("pshy.images.list")



--- BonusScore1.
image_list["1848a17e166.png"] = {bonus = true, w = 27, h = 27, desc = "+1 points bonus"}
local function SonicScore1Callback(player_name, bonus)
	tfm.exec.setPlayerScore(player_name, 1, true)
end
bonus_types["SonicScore1"] = {image = "1848a17e166.png", func = SonicScore1Callback}
