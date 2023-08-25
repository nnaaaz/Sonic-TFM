local setPlayerScore = tfm.exec.setPlayerScore
local room = tfm.get.room

tfm.exec.setPlayerScore = function(name, score, add)
    setPlayerScore(name, score, add)
    local newscore = score
    if add then
        newscore = newscore + (room.playerList[name].score or 0)
    end
    eventScoreUpdate(name, newscore)
end

system.newTimer(function()
    for name, player in next, room.playerList do
        eventScoreUpdate(name, player.score)
    end
end, 1000, false)
