--- sonic_funcorp
--
-- FunCorp variant of Sonic The Mouse.
if __IS_MAIN_MODULE__ and tfm.get.room.isTribeHouse then
	error("<r>You ran the FunCorp variant of this script in the tribehouse. Please use the TribeHouse variant instead.</r>")
end
pshy.require("sonic")
pshy.require("pshy.commands.list.all")
pshy.require("pshy.essentials.funcorp")
pshy.require("pshy.commands")
pshy.require("pshy.help")



function eventInit()
	print("<fc>FunCorp variant.</fc>")
end
