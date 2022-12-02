import xml.etree.ElementTree as ET
import os
import re

from os.path import splitext


OUTPUT_FILE = 'lua/generated_levels.lua'
TRAP_TYPES = [
    'activate',
    'gravitywind',
    'aie',
    'cheese',
    'object',
    'hide',
    'move',
    'speed',
    'teleport',
    'height',
    'width',
    'damping',
    'color',
    'foreground',
    'fixed',
    'mass',
    'restitution',
    'friction',
    'kill',
    'collision',
    'angle',
    'dynamic',
    'type',
    'image', # NOT IMPLEMENTED YET
]


levelXML = {}
traps = {}
lines = [] # output file


def default_collision(t):
    if t == '15' or t == '9':
        return 4
    return 1

def default_foreground(t):
    if t == '15' or t == '9':
        return True
    return False

def tonumber(val, base=10):
    if not val:
        return None

    try:
        return int(val, base)
    except ValueError:
        return None

def parse_ground_tag(ground):
    props = ground.get("P", "").split(",")
    collision = tonumber(ground.get("c")) or default_collision(ground.get("T"))

    return {
        "x": ground.get("X", 0),
        "y": ground.get("Y", 0),

        "type": ground.get("T", 0),
        "width": ground.get("L", 10),
        "height": ground.get("H", 10),
        "color": ground.get("o") and tonumber(ground.get("o"), 16) or None,
        "miceCollision": collision in (1, 3) and "true" or "false",
        "groundCollision": collision < 3 and "true" or "false",
        "dynamic": tonumber(props[0]) != 0 and "true" or "false",
        "mass": tonumber(props[1]) or 0,
        "friction": tonumber(props[2]) or 0,
        "restitution": tonumber(props[3]) or 0,
        "angle": tonumber(props[4]) or 0,
        "foreground": ground.get("N", default_foreground(ground.get("T"))) and "true" or "false",
        "fixedRotation": tonumber(props[5]) != 0 and "true" or "false",
        "linearDamping": tonumber(props[6]) or 0,
        "angularDamping": tonumber(props[7]) or 0,
    }

def parse_trap_commands(text):
    if not text:
        return []

    commands = text.split(";")
    ret = []

    for cmd in commands:
        match = re.match(r'^([a-zA-Z]+)(.*)$', cmd)

        if match:
            trap_type = match.group(1)
            params = match.group(2)
            ret += [
                {
                    "type": trap_type,
                    "params": params is not None and params.split(","),
                }
            ]
        else:
            print("Invalid trap command:", cmd)

    return ret

def parse_groups(text):
    if not text:
        return []

    groups = text.split(";")
    ret = []

    for group in groups:
        params = group.split(',')
        ret += [
            {
                "name": params[0],
                "behaviour": len(params) > 1 and params[1] or None,
            }
        ]

    return ret


def read_xmls():
    for name in os.listdir("maps/"):
        print(f"maps/{name}")
        levelXML[name] = ET.parse(f"maps/{name}")

def parse_traps():
    for (name, xml) in levelXML.items():
        traps[name] = []
        root = xml.getroot()
        lua_id = 1

        for elm in root.iter():
            if elm.text:
                elm.text = elm.text.strip()
            if elm.tail:
                elm.tail = elm.tail.strip()

        ground_root = root.find('Z').find('S')

        for ground in ground_root.findall('S'):
            if ground.get("lua") or ground.get("onactivate") or ground.get("ondeactivate") or ground.get("ontouch"):
                traps[name] += [
                    {
                        "id": lua_id,
                        "name": ground.get("lua", ""),
                        "groups": parse_groups(ground.get("groups")),
                        "onactivate": parse_trap_commands(ground.get("onactivate")),
                        "ondeactivate": parse_trap_commands(ground.get("ondeactivate")),
                        "ontouch": parse_trap_commands(ground.get("ontouch")),
                        "ground": parse_ground_tag(ground),
                        "duration": ground.get("duration") and tonumber(ground.get("duration")) or "TRAP_DURATION",
                        "reload": ground.get("reload") and tonumber(ground.get("reload")) or "TRAP_RELOAD",
                    }
                ]
                lua_id += 1
                ground_root.remove(ground)

        print(f'Traps found in {name}: {len(traps[name])}')

def concat_command_params(params):
    if not params:
        return ""

    return ', '.join([
        param
        if tonumber(param)
        else
        f'"{param}"'
        for param in params
    ])

def generate_command_code(lines, cmd):
    if cmd["type"] in TRAP_TYPES:
        lines += [f'          TRAP_TYPES["{cmd["type"]}"]({concat_command_params(cmd["params"])}),']
    else:
        print(f'Trap type not found: {cmd["type"]}')

def generate_code(lines):
    lines += ['local traps = pshy.require("traps")']
    lines += ['local TRAP_TYPES = traps.TRAP_TYPES']
    lines += ['local TRAP_RELOAD = traps.TRAP_RELOAD']
    lines += ['local TRAP_DURATION = traps.TRAP_DURATION']
    lines += ['return {']

    for (name, xml) in levelXML.items():
        lines += [f'  ["{splitext(name)[0]}"] = {{']
        lines += [f'    xml = [[{ET.tostring(xml.getroot(), encoding="unicode")}]],']
        lines += ['    traps = {']

        for trap in traps[name]:
            lines += ['      {']
            lines += [f'        id = {trap["id"]},']
            lines += [f'        name = "{trap["name"].replace("#", "")}",']

            lines += ['        groups = {']
            for group in trap["groups"]:
                lines += ['        {']
                lines += [f'          name = "{group["name"]}",']
                lines += [f'          behaviour = {group["behaviour"]},']
                lines += ['        },']
            lines += ['        },']

            lines += ['        onactivate = {']
            for cmd in trap["onactivate"]:
                generate_command_code(lines, cmd)
            lines += ['        },']

            lines += ['        ondeactivate = {']
            for cmd in trap["ondeactivate"]:
                generate_command_code(lines, cmd)
            lines += ['        },']

            lines += ['        ontouch = {']
            for cmd in trap["ontouch"]:
                generate_command_code(lines, cmd)
            lines += ['        },']

            ground = trap["ground"]
            lines += ['        ground = {']
            lines += [f'          x = {ground["x"]},']
            lines += [f'          y = {ground["y"]},']
            lines += [f'          type = {ground["type"]},']
            lines += [f'          width = {ground["width"]},']
            lines += [f'          height = {ground["height"]},']
            lines += [f'          color = {ground["color"] is None and "nil" or hex(ground["color"])},']
            lines += [f'          miceCollision = {ground["miceCollision"]},']
            lines += [f'          groundCollision = {ground["groundCollision"]},']
            lines += [f'          dynamic = {ground["dynamic"]},']
            lines += [f'          friction = {ground["friction"]},']
            lines += [f'          restitution = {ground["restitution"]},']
            lines += [f'          foreground = {ground["foreground"]},']
            lines += [f'          fixedRotation = {ground["fixedRotation"]},']
            lines += [f'          linearDamping = {ground["linearDamping"]},']
            lines += [f'          angularDamping = {ground["angularDamping"]},']
            lines += ['        },']

            lines += [f'        duration = {trap["duration"]},']
            lines += [f'        reload = {trap["reload"]},']
            lines += ['      },']

        lines += ['    },']
        lines += ['  },']

    lines += ['}']

def save_lua(lines):
    with open(OUTPUT_FILE, 'w', encoding="utf8") as luafile:
        luafile.write('\n'.join(lines))
        print("Generated lua code for levels successfully!")


read_xmls()
parse_traps()
generate_code(lines)
save_lua(lines)
