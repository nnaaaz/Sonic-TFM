--- bonus_score10
local bonuses = pshy.require("pshy.bonuses")
local bonus_types = pshy.require("pshy.bonuses.list")
local image_list = pshy.require("pshy.images.list")



--- BonusScore10.
image_list["185bbbc0145.png"] = {bonus = true, w = 30, h = 30, desc = "+10 points bonus"}
local function SonicScore10Callback(player_name, bonus)
	tfm.exec.setPlayerScore(player_name, 10, true)
	tfm.exec.displayParticle(tfm.enum.particle.yellowGlitter, bonus.x, bonus.y - 1, 0, -6, 0, 0.4, player_name)
	tfm.exec.displayParticle(tfm.enum.particle.yellowGlitter, bonus.x - 1, bonus.y, 0, -6, 0, 0.4, player_name)
	tfm.exec.displayParticle(tfm.enum.particle.yellowGlitter, bonus.x, bonus.y + 1, 0, -6, 0, 0.4, player_name)
	tfm.exec.displayParticle(tfm.enum.particle.yellowGlitter, bonus.x + 1, bonus.y, 0, -6, 0, 0.4, player_name)
	tfm.exec.playSound('lua/sonic/ring', 100, nil, nil, player_name)
end
bonus_types["SonicScore10"] = {image = "185bbbc0145.png", foreground = true, func = SonicScore10Callback}
