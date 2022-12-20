import xml.etree.ElementTree as ET
import os
import re

from os.path import splitext


OUTPUT_FILE = 'lua/generated_levels.lua'


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
        match = re.match(r'^([a-zA-Z]+)(.*)$', cmd.strip())

        if match:
            trap_type = match.group(1)
            params = match.group(2)
            ret += [
                {
                    "type": trap_type,
                    "params": params is not None and params.lstrip().split(","),
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

def parse_image(image, params):
    if not image:
        return None

    parts = image.split(',')
    if len(parts) < 3:
        return None

    x = tonumber(parts[0])
    y = tonumber(parts[1])
    url = parts[2]

    if x is None or y is None or len(url) < 12:
        return None

    ret = [url, str(x), str(y)]

    if not params:
        return ret

    parts = params.split(',')
    if len(parts) == 0:
        return ret

    parts = [tonumber(part) or 'nil' for part in parts]
    parts = [str(part) for part in parts]

    return ret + parts


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
        ground_index_mapping = {}
        ground_index = 0
        ground_current_index = 0

        for ground in ground_root.findall('S'):
            ground_index_mapping[str(ground_index)] = str(ground_current_index)
            ground_index += 1

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
                        "image": parse_image(ground.get("i") or "", ground.get("imgp") or ""),
                        "duration": ground.get("duration") and tonumber(ground.get("duration")) or "TRAP_DURATION",
                        "reload": ground.get("reload") and tonumber(ground.get("reload")) or "TRAP_RELOAD",
                        "vanish": ground.get("v") and tonumber(ground.get("v")) or "nil"
                    }
                ]
                lua_id += 1
                ground_root.remove(ground)
            else:
                ground_current_index += 1

        # We need to fix joint target platforms
        joint_root = root.find('Z').find('L')

        for joint in joint_root.findall('.//*'):
            m1 = joint.get("M1")
            m2 = joint.get("M2")

            if m1 and m1 in ground_index_mapping:
                joint.set("M1", ground_index_mapping[m1])

            if m2 and m2 in ground_index_mapping:
                joint.set("M2", ground_index_mapping[m2])

        print(f'Trap Grounds found in {name}: {len(traps[name])}')

def concat_command_params(params):
    if not params:
        return

    return ', '.join([
        f'"{param}"'
        for param in params
    ])

def generate_command_code(lines, cmd):
    lines += [f'          TRAP_TYPES["{cmd["type"]}"]({concat_command_params(cmd["params"])}),']

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

            if "image" in trap and trap["image"]:
                image = trap["image"]
                params = ','.join(image[1:9])

                if len(image) >= 10:
                    params += ',' + (params[9] == '1' and 'true' or 'false')

                lines += [f'          image = {{"{image[0]}",{params}}},']

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
