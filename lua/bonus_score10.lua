--- bonus_score10
local bonuses = pshy.require("pshy.bonuses")
local bonus_types = pshy.require("pshy.bonuses.list")
local image_list = pshy.require("pshy.images.list")



--- BonusScore10.
image_list["181f3329429.png"] = {bonus = true, w = 20, h = 20, desc = "+10 points bonus"}
local function BonusScore10Callback(player_name, bonus)
	tfm.exec.setPlayerScore(player_name, 10, true)
end
bonus_types["BonusScore10"] = {image = "181f3329429.png", func = BonusScore10Callback}
