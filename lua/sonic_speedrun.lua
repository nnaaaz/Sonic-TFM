--- sonic_speedrun
--
-- Spedrun variant of Sonic The Mouse.
pshy.require("pshy.alternatives.chat")
pshy.require("pshy.alternatives.timers")
pshy.require("sonic")
pshy.require("pshy.bases.checkpoints")
pshy.require("pshy.commands")
pshy.require("pshy.commands.list.all")
pshy.require("pshy.commands.list.tp")
pshy.require("pshy.help")


local counterui = pshy.require("counterui")

local speedrunTimer = counterui.create({
  text = '<p align="left"><font color="#ffd307" size="24" face="Soopafresh">%ss',
  shadow = '<p align="left"><font color="#000000" size="24" face="Soopafresh">%ss',
  x = 680, y = 65,
  width = 150,
})
local recordTimer = counterui.create({
  text = '<p align="left"><font color="#ffd307" size="25" face="Soopafresh">BEST\n%ss',
  shadow = '<p align="left"><font color="#000000" size="25" face="Soopafresh">BEST\n%ss',
  x = 680, y = 100,
  width = 150,
})

local spawn_time = {}
local rec_time = {}


local function TouchPlayer(name)
  speedrunTimer.add(name)
end


function eventNewGame()
  for name in next, tfm.get.room.playerList do
    spawn_time[name] = os.time()
  end

  rec_time = {}
end

function eventLoop(time, time_remaining)
    for name, time in next, spawn_time do
      speedrunTimer.update(name, (os.time() - time) / 1000)
    end
end

function eventNewPlayer(name)
  TouchPlayer(name)
end

function eventPlayerLeft(name)
  recordTimer.remove(name)
  speedrunTimer.remove(name)
end

function eventPlayerRespawn(name)
  if not spawn_time[name] then
    spawn_time[name] = os.time()
  end
end

function eventPlayerWon(name)
  if not spawn_time[name] then
    return
  end

  local completion = os.time() - spawn_time[name]

  spawn_time[name] = nil

  if not rec_time[name] or rec_time[name] > completion then
    rec_time[name] = completion
    recordTimer.add(name)
    recordTimer.update(name, completion / 1000)
  end
end


function eventInit()
  print("<fc>Speedrun variant.</fc>")

  for name in pairs(tfm.get.room.playerList) do
    TouchPlayer(name)
  end
end
