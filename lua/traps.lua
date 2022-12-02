pshy.require("pshy.events")

local newgame = pshy.require("pshy.rotations.newgame")


--- Contants
local TRAP_DURATION = 5000
local TRAP_RELOAD = 5000


--- Aliases
local TFM, ROOM, ui, system = tfm.exec, tfm.get.room, ui, system
local tonumber, pairs, ipairs = tonumber, pairs, ipairs
local table_foreach, unpack = table.foreach, table.unpack
local random, max, floor, ceil, abs = math.random, math.max, math.floor, math.ceil, math.abs
local lshift, btest = bit32.lshift, bit32.btest
local string_match = string.match
local os_time = os.time


--- Common Functions
local function string_split(str, delimiter)
  local delimiter = delimiter or ','
  local array, n = {}, 0
  for part in str:gmatch('[^'..delimiter..']+') do
    n = 1 + n
    array[n] = part
  end
  array._len = n
  return array
end

local function table_clone(t)
  local ret = {}
  for k,v in next,t do
    ret[k] = v
  end
  return ret
end

local function table_keys(t, skip_key)
  local ret = {}
  local i = 0

  for key in pairs(t) do
    if key ~= skip_key then
      i = 1 + i
      ret[i] = key
    end
  end

  return ret, i
end

local function table_randomize(t)
  local len = t._len or #t
  local j

  for i=1,len do
    j = random(i)
    t[j], t[i] = t[i], t[j]
  end
end

local function string_trim(str)
  local content = str:match('^%s*(.+)%s*$')
  return content or ''
end

local function pythag(x1, y1, x2, y2, dist)
  return (x1 - x2) ^ 2 + (y1 - y2) ^ 2 <= dist ^ 2
end

local function find_tag(tags, target)
  for i=1,tags._len do
    if tags[i]._name == target then
      return tags[i]
    end
  end
end

local function gradient(i, n)
  -- TODO use HSV/HSL for rainbow
  return floor(0xffffff / n * i)
end


--- Ground System
do
  local RESERVED_START = 10000

  local _grounds = {}
  local _reservedLast

  local function _reserve(self)
    local idx = _reservedLast or RESERVED_START
    _reservedLast = 1 + idx

    return idx
  end

  local function _createGround(options)
    if options.onContact then
      options.contactListener = true
    end

    TFM.addPhysicObject(options.lua, options.x, options.y, options)
  end

  GroundSystem = {
    reset = function(self)
      _grounds = {}
      _reservedLast = nil
    end,

    add = function(self, options)
      local id = options.lua

      if id == nil then
        id = _reserve()
        options.lua = id
      elseif id >= RESERVED_START then
        return
      end

      _grounds[id] = options

      if options.hide then
        TFM.removePhysicObject(id)
      else
        _createGround(options)
      end

      return id
    end,

    update = function(self, options)
      local id = options.lua

      if id == nil then
        return
      end

      local ground = _grounds[id]

      if ground == nil then
        return
      end

      options.x = options.x or ground.x
      options.y = options.y or ground.y

      if options.hide then
        TFM.removePhysicObject(id)
      else
        _createGround(options)
      end

      if options.move then
        TFM.movePhysicObject(id, unpack(options.move))
      end
    end,

    revert = function(self, id)
      if not id then
        return
      end

      local ground = _grounds[id]

      if ground == nil then
        return
      end

      if ground.hide then
        TFM.removePhysicObject(id)
      else
        _createGround(ground)
      end
    end,

    remove = function(self, id)
      local ground = _grounds[id]

      if not ground then
        return
      end

      TFM.removePhysicObject(id)
    end,

    onContact = function(self, name, id, contactInfo)
      local ground = _grounds[id]

      if not ground then
        return
      end

      if not ground.onContact then
        return
      end


      ground.onContact(name, contactInfo)
    end,
  }
end


--- Trap Group System
do
  local groups = {}
  local lastId = 1000

  TrapGroupSystem = {
    ENABLE_ALWAYS = 0,
    ENABLE_RANDOM = 1,
    ENABLE_RANDOM_SINGLE = 2,

    reset = function(self)
      groups = {}
      lastId = 1000
    end,

    add = function(self, trap, groupName, behaviour)
      local group = groups[groupName]

      if not group then
        lastId = 1 + lastId
        group = {
          id = lastId,
          _len = 0,
          _behaviour = {},
        }
        groups[groupName] = group
      end

      group._len = 1 + group._len
      group[group._len] = trap.id
      group._behaviour[trap.id] = behaviour
    end,

    register = function(self)
      local info, duration, reload

      for groupName, group in pairs(groups) do
        if group._len > 0 then
          duration, reload = 0, 0
        else
          duration, reload = TRAP_DURATION, TRAP_RELOAD
        end

        for i=1, group._len do
          info = TrapSystem:get(group[i])

          if duration ~= -1 then
            if info.duration < 0 then
              duration = -1
            else
              duration = max(duration, info.duration)
            end
          end

          reload = max(reload, info.reload)
        end

        TrapSystem:register({
          onactivate = {
            _len = 1,
            {
              activate = function()
                local randomTraps = { _len = 0 }
                local randomSingleTraps = { _len = 0 }
                local behaviour

                for i=1,group._len do
                  behaviour = group._behaviour[group[i]]

                  if behaviour == self.ENABLE_ALWAYS then
                    TrapSystem:activate(group[i])
                  elseif behaviour == self.ENABLE_RANDOM then
                    randomTraps._len = 1 + randomTraps._len
                    randomTraps[randomTraps._len] = group[i]
                  elseif behaviour == self.ENABLE_RANDOM_SINGLE then
                    randomSingleTraps._len = 1 + randomSingleTraps._len
                    randomSingleTraps[randomSingleTraps._len] = group[i]
                  end
                end

                if randomTraps._len > 0 then
                  local enabledmask = random(lshift(1, randomTraps._len - 1))

                  for i=1,randomTraps._len do
                    if btest(enabledmask, lshift(1, i - 1)) then
                      TrapSystem:activate(randomTraps[i])
                    end
                  end
                end

                if randomSingleTraps._len > 0 then
                  local idx = random(1, randomSingleTraps._len)

                  TrapSystem:activate(randomSingleTraps[idx])
                end
              end,

              deactivate = function()
                for i=1, group._len do
                  TrapSystem:deactivate(group[i])
                end
              end,
            }
          },
          name = "#" .. groupName,
          id = group.id,
          reload = reload,
          duration = duration,
        })
      end
    end,
  }
end


local TRAP_TYPES = {}

--- Trap Parser
do
  local function getTrap(trapName)
    if not trapName then
      return
    end

    local sym = trapName:sub(1, 1)
    local trap

    if sym == '@' then
      trap = TrapSystem:get(trapName:sub(2))
    elseif sym == '#' then
      trap = TrapSystem:get(trapName)
    end

    if trap then
      return trap
    end
  end

  local function getCoords(strx, stry)
    local x, y = tonumber(strx), tonumber(stry)
    if x or y then
      return x, y
    end

    local trap = getTrap(strx)
    if trap then
      return trap.x, y or trap.y
    end
  end

  local types = {
    type = function(params) -- change type
      local value = tonumber(params)

      if not value then
        return
      end

      return {
        activate = function(ground)
          ground.type = value
        end,
      }
    end,
    dynamic = function(params) -- change dynamic
      local value = params ~= '0'

      return {
        activate = function(ground)
          ground.dynamic = value
        end,
      }
    end,
    angle = function(params) -- change angle
      local value = tonumber(params)

      return {
        activate = function(ground)
          ground.angle = value
        end,
      }
    end,
    collision = function(params) -- change mice collision
      local args = string_split(params)
      local mice = args[1] ~= '0'
      local ground = args[2] ~= '0'

      return {
        activate = function(ground)
          if args[1] then
            ground.miceCollision = mice
          end

          if args[2] then
            ground.groundCollision = ground
          end
        end,
      }
    end,
    kill = function(params) -- kill on touch
      local function activate(name, contact)
        TFM.killPlayer(name)
      end

      return {
        contact = activate,
        touch = activate,
      }
    end,
    friction = function(params) -- change friction
      local value = tonumber(params)
      return {
        activate = function(ground)
          ground.friction = value
        end,
      }
    end,
    restitution = function(params) -- change restitution
      local value = tonumber(params)
      return {
        activate = function(ground)
          ground.restitution = value
        end,
      }
    end,
    mass = function(params) -- change mass
      local value = tonumber(params)
      return {
        activate = function(ground)
          ground.mass = value
        end,
      }
    end,
    fixed = function(params) -- change fixed rotation
      local value = params ~= '0'
      return {
        activate = function(ground)
          ground.fixedRotation = value
        end,
      }
    end,
    foreground = function(params) -- change foreground
      local value = params ~= '0'
      return {
        activate = function(ground)
          ground.foreground = value
        end,
      }
    end,
    color = function(params) -- change color
      local value = tonumber(params, 16)
      return {
        activate = function(ground)
          ground.color = value
        end,
      }
    end,
    damping = function(params) -- change linear/angular damping
      local args = string_split(params)
      local linear = tonumber(args[1])
      local angular = tonumber(args[2])

      return {
        activate = function(ground)
          if args[1] then
            ground.linearDamping = linear
          end

          if args[2] then
            ground.angularDamping = angular
          end
        end,
      }
    end,
    width = function(params) -- change width
      local value = tonumber(params) or 10
      return {
        activate = function(ground)
          ground.width = value
        end,
      }
    end,
    height = function(params) -- change height
      local value = tonumber(params) or 10
      return {
        activate = function(ground)
          ground.height = value
        end,
      }
    end,
    teleport = function(params) -- teleport: x,y,relative (default x,y,false)
      local args = string_split(params)
      local relative = args[3] == '1'
      local x, y, ready

      local function activate(name, contact)
        if not ready then
          x, y = getCoords(args[1], args[2])
          x = x or (relative and 0)
          y = y or (relative and 0)
          ready = true
        end

        if x or y then
          TFM.movePlayer(name, x or contact.playerX, y or contact.playerY, relative)
        end
      end

      return {
        contact = activate,
        touch = activate,
      }
    end,
    speed = function(params) -- speed/velocity: x,y,relative (default: 0,0,true)
      local args = string_split(params)
      local x, y = tonumber(args[1]), tonumber(args[2])
      local relative = args[3] ~= '0'

      local function activate(name, contact)
        TFM.movePlayer(name, 0, 0, true, x or 0, y or 0, relative)
      end

      return {
        contact = activate,
        touch = activate,
      }
    end,
    move = function(params) -- move ground: x,y,rel,xs,ys,rels,a,rela (default: 0,0,true,0,0,true,0,true)
      local args = string_split(params)
      local prel = args[3] ~= '0'
      local vx, vy = tonumber(args[4]) or 0, tonumber(args[5]) or 0
      local vrel = args[6] ~= '0'
      local a = tonumber(args[7]) or 0
      local arel = args[8] ~= '0'
      local x, y, ready

      return {
        activate = function(ground)
          if not ready then
            x, y = getCoords(args[1], args[2])
            x, y = x or 0, y or 0
            ready = true
          end

          ground.move = { x, y, prel, vx, vy, vrel, a, arel }
        end,
        deactivate = function(ground)
          ground.move = nil
        end,
      }
    end,
    hide = function(params) -- hide/remove the ground
      return {
        activate = function(ground)
          ground.hide = true
        end,
        deactivate = function(ground)
          ground.hide = nil
        end,
      }
    end,
    object = function(params) -- create shaman object: typ,x,y,ghost,angle,vx,vy,fx,fy (default: 1,0,0,false,0,0,0,,)
      local args = string_split(params)
      local typ = tonumber(args[1]) or 1
      local ghost = args[4] == '1'
      local angle = tonumber(args[5]) or 0
      local vx = tonumber(args[6]) or 0
      local vy = tonumber(args[7]) or 0
      local options = (args[8] or args[9]) and {
        fixedXSpeed = tonumber(args[8]) or 0,
        fixedYSpeed = tonumber(args[9]) or 0
      } or nil
      local lastObjId
      local x, y, ready

      return {
        activate = function(ground)
          if not ready then
            x, y = getCoords(args[2], args[3])
            x, y = x or 0, y or 0
            ready = true
          end

          lastObjId = TFM.addShamanObject(typ, x, y, angle, vx, vy, ghost, options)
        end,
        deactivate = function(ground)
          TFM.removeObject(lastObjId)
        end,
      }
    end,
    cheese = function(params) -- give/take cheese: give (default: 1)
      local args = string_split(params)
      local give = args[1] ~= '0'

      local function activate(name, contact)
        if give then
          TFM.giveCheese(name)
        else
          TFM.removeCheese(name)
        end
      end

      return {
        contact = activate,
        touch = activate,
      }
    end,
    aie = function(params) -- enable/disable aie mode: enable,sensitivity (default: 1,1)
      local args = string_split(params)
      local enable = args[1] ~= '0'
      local sensitivity = tonumber(args[2]) or 1

      local function activate(name, contact)
        TFM.setAieMode(enable, sensitivity, name)
      end

      return {
        contact = activate,
        touch = activate,
      }
    end,
    gravitywind = function(params) -- set gravity and wind scale: gravity,wind (default: 1,1)
      local args = string_split(params)
      local gravity = tonumber(args[1]) or 1
      local wind = tonumber(args[2]) or 1

      local function activate(name, contact)
        TFM.setPlayerGravityScale(name, gravity, wind)
      end

      return {
        contact = activate,
        touch = activate,
      }
    end,
    activate = function(params) -- activate a trap or a group: @trap/#group
      local trap, ready

      local function activate()
        if not ready then
          trap = getTrap(params)
          ready = true
        end
        
        if trap then
          TrapSystem:activate(trap.id)
        end
      end

      return {
        activate = activate,
        touch = activate,
      }
    end,
  }

  TRAP_TYPES = types

  TrapParser = {
    parse = function(self, trapStr)
      if not trapStr then
        return
      end

      local traps = string_split(trapStr, ";")
      local ret = { _len = 0 }
      local trapType, params, processor

      for i=1, traps._len do
        trapType, params = traps[i]:match('^(%a+)(.-)$')
        processor = types[trapType]

        if processor then
          ret._len = 1 + ret._len
          ret[ret._len] = processor(params or "")
        end
      end

      return ret
    end,
  }
end


--- Trap System
do
  local _traps = {}
  local _active = {}
  local _deactivatetime = {}
  local _reloadtime = {}
  local nameMapping = {}

  local function scanCallback(arr, name)
    local ret = { _len=0 }

    if arr then
      for i=1, #arr do
        if arr[i][name] then
          ret._len = 1 + ret._len
          ret[ret._len] = arr[i][name]
        end
      end
    end

    return ret
  end

  -- e.g. groups="group1name,behaviour;group2,behaviour;robots,random"
  local function parseGroups(str)
    local groupParams = string_split(str, ";")
    local groups = { _len = groupParams._len }
    local grp

    for i=1, groupParams._len do
      grp = string_split(groupParams[i], ",")
      groups[i] = {
        name = grp[1],
        behaviour = grp[2]
      }
    end

    return groups
  end

  TrapSystem = {
    reset = function()
      _traps = {}
      _active = {}
      _deactivatetime = {}
      _reloadtime = {}
      nameMapping = {}
    end,

    register = function(self, trap)
      local id = trap.id
      local group

      _deactivatetime[id] = 0
      _reloadtime[id] = 0
      _traps[id] = trap

      if trap.name then
        nameMapping[trap.name] = id
      end

      trap.callbacks = {
        contact = scanCallback(trap.onactivate, "contact"),
        activate = scanCallback(trap.onactivate, "activate"),
        deactivate = scanCallback(trap.onactivate, "deactivate"),

        contact2 = scanCallback(trap.ondeactive, "contact"),
        activate2 = scanCallback(trap.ondeactive, "activate"),
        deactivate2 = scanCallback(trap.ondeactive, "deactivate"),

        touch = scanCallback(trap.ontouch, "touch"),
      }

      if trap.groups then
        for i=1, #trap.groups do
          group = trap.groups[i]
          behaviour = TrapGroupSystem.ENABLE_ALWAYS

          if group.behaviour == 'random' then
            behaviour = TrapGroupSystem.ENABLE_RANDOM
          elseif group.behaviour == 'randomone' then
            behaviour = TrapGroupSystem.ENABLE_RANDOM_SINGLE
          end

          TrapGroupSystem:add(trap, group.name, behaviour)
        end
      end

      if trap.ground then
        local callbacks = trap.callbacks.contact
        local callbacks2 = trap.callbacks.contact2

        if trap.ontouch then
          local touchCallbacks = trap.callbacks.touch

          callbacks._len = 1 + callbacks._len
          callbacks[callbacks._len] = function(name, contact)
            for i=1, touchCallbacks._len do
              touchCallbacks[i](name, contact)
            end
          end
          callbacks2._len = 1 + callbacks2._len
          callbacks2[callbacks2._len] = callbacks[callbacks._len]
        end

        if callbacks._len > 0 or callbacks2._len > 0 then
          trap.ground.onContact = function(name, contact)
            local active = _active[id] and true or false

            if active then
              for i=1, callbacks._len do
                callbacks[i](name, contact)
              end
            else
              for i=1, callbacks2._len do
                callbacks2[i](name, contact)
              end
            end
          end
        end

        GroundSystem:add(table_clone(trap.ground))
      end

      local activate2 = trap.callbacks.activate2

      for i=1, activate2._len do
        activate2[i](trap.ground)
      end
    end,

    get = function(self, identifier)
      local trap = _traps[identifier] or _traps[nameMapping[identifier]]

      if not trap then
        return
      end

      return {
        id = trap.id,
        active = _active[trap.id],
        deactivateTime = _deactivatetime[trap.id],
        reloadTime = _reloadtime[trap.id],
        duration = trap.duration,
        reload = trap.reload,
        x = trap.ground and trap.ground.x,
        y = trap.ground and trap.ground.y,
      }
    end,

    activate = function(self, trapId)
      if _active[trapId] then
        return
      end

      local trap = _traps[trapId]

      if not trap then
        print(('Attempt to activate unregistered trap: %s'):format(tostring(trapId)))
        return
      end

      if os_time() - _reloadtime[trapId] < 0 then
        return
      end

      _deactivatetime[trapId] = os_time() + trap.duration
      _reloadtime[trapId] = _deactivatetime[trapId] + trap.reload
      _active[trapId] = true

      local callbacks = trap.callbacks.activate
      local callbacks2 = trap.callbacks.deactivate2

      for i=1, callbacks._len do
        callbacks[i](trap.ground)
      end

      for i=1, callbacks2._len do
        callbacks2[i](trap.ground)
      end

      if trap.ground then
        GroundSystem:update(trap.ground)
      end
    end,

    deactivate = function(self, trapId)
      if not _active[trapId] then
        return
      end

      local trap = _traps[trapId]

      if not trap then
        print(('Attempt to deactivate unregistered trap: %s'):format(tostring(trapId)))
        return
      end

      if trap.duration < 0 or os_time() - _deactivatetime[trapId] < 0 then
        return
      end

      _active[trapId] = false

      local trap = _traps[trapId]

      if trap then
        if trap.ground then
          GroundSystem:revert(trapId)
        end

        local callbacks = trap.callbacks.deactivate
        local callbacks2 = trap.callbacks.activate2

        for i=1,callbacks._len do
          callbacks[i](trap.ground)
        end

        for i=1,callbacks2._len do
          callbacks2[i](trap.ground)
        end
      end
    end,

    onLoop = function(self)
      for trapId in pairs(_active) do
        self:deactivate(trapId)
      end
    end,
  }
end


--- Events
function eventNewGame()
  local map = newgame.current_settings.map

  TrapSystem:reset()

	if map and map.traps then
    local trapList = map.traps

    for i=1, #trapList do
      TrapSystem:register(trapList[i])
    end
	end

  TrapGroupSystem:register()
end

function eventLoop(elapsed, remaining)
  TrapSystem:onLoop()
end

function eventPlayerRespawn(name)
  TFM.setAieMode(false, 0, name)
  TFM.setPlayerGravityScale(name, 1, 1)
end

function eventContactListener(name, id, contactInfo)
  GroundSystem:onContact(name, id, contactInfo)
end


return {
  TRAP_TYPES = TRAP_TYPES,
  TRAP_DURATION = TRAP_DURATION,
  TRAP_RELOAD = TRAP_DURATION,
}

