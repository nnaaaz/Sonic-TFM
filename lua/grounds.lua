--- grounds


---
-- Imports
---

pshy.require("pshy.events")

local newgame = pshy.require("pshy.rotations.newgame")


---
-- Aliases
---

local sqrt = math.sqrt
local pow = math.pow


---
-- Variables
---

local groundsById = {}
local groundList = { _len = 0 }
local timedGrounds = { _len = 0 }
local timerTick = 0


---
-- Functions
---

local function condMeet(left, op, right)
  if op == 'eq' then
    return left == right
  elseif op == 'gt' then
    return left > right
  elseif op == 'ge' then
    return left >= right
  elseif op == 'lt' then
    return left < right
  elseif op == 'le' then
    return left <= right
  end
end

local function utilsCond(type, op, value, fnc)
  if type == 'speed' then
    return function(name, ground, contact)
      local speed = sqrt(pow(contact.speedX, 2) + pow(contact.speedY, 2))

      if condMeet(speed, op, value) then
        fnc(name, ground, contact)
      end
    end
  elseif type == 'speedX' then
    return function(name, ground, contact)
      if condMeet(contact.speedX, op, value) then
        fnc(name, ground, contact)
      end
    end
  elseif type == 'speedY' then
    return function(name, ground, contact)
      if condMeet(contact.speedY, op, value) then
        fnc(name, ground, contact)
      end
    end
  end
end


local function showGround(ground)
  local props = ground.props
  local img = ground.image

  tfm.exec.addPhysicObject(props.id, props.x, props.y, props)

  if img then
    if img._luaid then
      tfm.exec.removeImage(img._luaid)
    end

    img._luaid = tfm.exec.addImage(
      img.id,
      '+' .. props.id,
      img.x or 0,
      img.y or 0,
      nil,
			img.scaleX or 1,
			img.scaleY or 1,
			img.rotation or 0,
			img.alpha or 1,
			img.anchorX or 0.5,
			img.anchorY or 0.5,
			img.fadeIn
    )
  end
end

local function hideGround(ground)
  local props = ground.props
  local img = ground.image

  if img and img._luaid then
    tfm.exec.removeImage(img._luaid, img.fadeOut)
    img._luaid = nil
  end

  tfm.exec.removePhysicObject(props.id)
end

local function addGround(ground, index)
  local props = ground.props

  props.id = props.id or index

  if ground.onContact then
    props.contactListener = true
    ground.onContact._len = #ground.onContact
  end

  if not ground.hidden then
    showGround(ground)
  end

  if ground.interval or ground.timerTick then
    timedGrounds._len = 1 + timedGrounds._len
    timedGrounds[timedGrounds._len] = ground

    if not ground.timerTick then
      ground.timerTick = ground.interval
    end
  end

  groundList._len = 1 + groundList._len
  groundList[groundList._len] = ground
  groundsById[props.id] = ground
end


---
-- TFM Events
---

function eventNewGame()
  local map = newgame.current_settings.map

  timerTick = 0

	if map and map.grounds then
    local groundList = map.grounds

    for i=1, #groundList do
      addGround(groundList[i], i)
    end
	end
end

function eventLoop()
  local ground

  timerTick = 0.5 + timerTick

  for i=1, timedGrounds._len do
    ground = timedGrounds[i]

    if ground.timerTick == timerTick then
      ground.hidden = not ground.hidden

      if ground.hidden then
        hideGround(ground)
      else
        showGround(ground)
      end

      if ground.interval then
        ground.timerTick = ground.timerTick + ground.interval
      end
    end
  end
end

function eventNewPlayer(name)
  local ground

  for i=1, groundList._len do
    ground = groundList[i]

    if not ground.hidden then
      showGround(ground)
    end
  end
end

function eventContactListener(name, id, contact)
  local ground = groundsById[id]

  if ground and ground.onContact then
    local callbacks = ground.onContact

    for i=1, callbacks._len do
      callbacks[i](name, ground, contact)
    end
  end
end


---
-- Exports
---

return {
  actions = {
    hide = function(_, ground)
      hideGround(ground)
    end,

    hideEx = function(id)
      local ground = groundsById[id]

      return function()
        hideGround(ground)
      end
    end,

    showEx = function(id)
      local ground = groundsById[id]

      return function()
        showGround(ground)
      end
    end,

    teleport = function(x, y, isOffset, resetSpeed)
      return function(name, _, contact)
        local vx = resetSpeed and 0 or contact.speedX
        local vy = resetSpeed and 0 or contact.speedY

        tfm.exec.movePlayer(name, x, y, isOffset or false, vx, vy, false)
      end
    end,

    speed = function(vx, vy, set)
      return function(name)
        tfm.exec.movePlayer(name, 0, 0, true, vx, vy, set or false)
      end
    end,
  },

  utils = {
    cond = utilsCond,
  },
}
