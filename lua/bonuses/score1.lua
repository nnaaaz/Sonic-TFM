--- bonus_score1
local bonuses = pshy.require("pshy.bonuses")
local bonus_types = pshy.require("pshy.bonuses.list")
local image_list = pshy.require("pshy.images.list")



--- BonusScore1.
image_list["1848a17e166.png"] = {bonus = true, w = 27, h = 27, desc = "+1 points bonus"}
local function SonicScore1Callback(player_name, bonus)
	tfm.exec.setPlayerScore(player_name, 1, true)
	tfm.exec.displayParticle(tfm.enum.particle.yellowGlitter, bonus.x, bonus.y - 1, 0, -6, 0, 0.4, player_name)
	tfm.exec.displayParticle(tfm.enum.particle.yellowGlitter, bonus.x - 1, bonus.y, 0, -6, 0, 0.4, player_name)
	tfm.exec.displayParticle(tfm.enum.particle.yellowGlitter, bonus.x, bonus.y + 1, 0, -6, 0, 0.4, player_name)
	tfm.exec.displayParticle(tfm.enum.particle.yellowGlitter, bonus.x + 1, bonus.y, 0, -6, 0, 0.4, player_name)
end
bonus_types["SonicScore1"] = {image = "1848a17e166.png", foreground = true, func = SonicScore1Callback}
