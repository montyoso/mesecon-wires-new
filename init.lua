-- Wires test mod by Vanessa Ezekowitz - 2012-08-08
--
-- Entirely my own code.  This mod merely supplies enough nodes to build 
-- a bunch of wires in all directions.
--
-- License: WTFPL
--

-- naming scheme: wire:(xp)(zp)(xm)(zm)_on/off
-- The conditions in brackets define whether there is a mesecon at that place or not
-- 1 = there is one; 0 = there is none
-- y always means y+

box_center = {-1/16, -.5, -1/16, 1/16, -.5+1/32, 1/16}
box_xp = {1/16, -.5, -1/16, 8/16, -.5+1/32, 1/16}
box_zp = {-1/16, -.5, 1/16, 1/16, -.5+1/32, 8/16}
box_xm = {-8/16, -.5, -1/16, -1/16, -.5+1/32, 1/16}
box_zm = {-1/16, -.5, -8/16, 1/16, -.5+1/32, -1/16}

box_xpy = {.5-1/32, -.5+1/32, -1/16, .5, .5+1/32, 1/16}
box_zpy = {-1/16, -.5+1/32, .5-1/32, 1/16, .5+1/32, .5}
box_xmy = {-.5+1/32, -.5+1/32, -1/16, -.5, .5+1/32, 1/16}
box_zmy = {-1/16, -.5+1/32, -.5+1/32, 1/16, .5+1/32, -.5}

for xp=0, 1 do
for zp=0, 1 do
for xm=0, 1 do
for zm=0, 1 do
for xpy=0, 1 do
for zpy=0, 1 do
for xmy=0, 1 do
for zmy=0, 1 do
	if (xpy == 1 and xp == 0) or (zpy == 1 and zp == 0) 
	or (xmy == 1 and xm == 0) or (zmy == 1 and zm == 0) then break end

	local groups
	local nodeid = 	tostring(xp )..tostring(zp )..tostring(xm )..tostring(zm )..
			tostring(xpy)..tostring(zpy)..tostring(xmy)..tostring(zmy)

	if nodeid == "00000000" then
		groups = {dig_immediate = 3, mesecon = 1}
	else
		groups = {dig_immediate = 3, mesecon = 1, not_in_creative_inventory = 1}
	end

	local nodebox = {box_center}
	if xp == 1 then table.insert(nodebox, box_xp) end
	if zp == 1 then table.insert(nodebox, box_zp) end
	if xm == 1 then table.insert(nodebox, box_xm) end
	if zm == 1 then table.insert(nodebox, box_zm) end
	if xpy == 1 then table.insert(nodebox, box_xpy) end
	if zpy == 1 then table.insert(nodebox, box_zpy) end
	if xmy == 1 then table.insert(nodebox, box_xmy) end
	if zmy == 1 then table.insert(nodebox, box_zmy) end


	minetest.register_node("wires:"..nodeid.."_off", {
		description = "Wire ID:"..nodeid,
		drawtype = "nodebox",
		tiles = {
			"wires_vertical_off.png",
			"wires_vertical_off.png",
			"wires_vertical_off.png",
			"wires_vertical_off.png",
			"wires_vertical_off.png",
			"wires_vertical_off.png"
		},
		paramtype = "light",
		paramtype2 = "facedir",
		selection_box = {
              		type = "fixed",
			fixed = {-.5, -.5, -.5, .5, -.5+1/32, .5}
		},
		node_box = {
			type = "fixed",
			fixed = nodebox
		},
		groups = groups,
		walkable = false,
		stack_max = 99,
		drop = "wires:00000000_off"
	})

	minetest.register_node("wires:"..nodeid.."_on", {
		description = "Wire ID:"..nodeid,
		drawtype = "nodebox",
		tiles = {
			"wires_vertical_on.png",
			"wires_vertical_on.png",
			"wires_vertical_on.png",
			"wires_vertical_on.png",
			"wires_vertical_on.png",
			"wires_vertical_on.png"
		},
		paramtype = "light",
		paramtype2 = "facedir",
		selection_box = {
              		type = "fixed",
			fixed = {-.5, -.5, -.5, .5, -.5+1/32, .5}
		},
		node_box = {
			type = "fixed",
			fixed = nodebox
		},
		groups = {dig_immediate = 3, mesecon = 1, not_in_creative_inventory = 1},
		walkable = false,
		stack_max = 99,
		drop = "wires:00000000_off"
	})
	mesecon:register_conductor("wires:"..nodeid.."_on", "wires:"..nodeid.."_off")
end
end
end
end
end
end
end
end

minetest.register_on_placenode(function(pos, node)
	mesecon:update_autoconnect(pos)
end)

minetest.register_on_dignode(function(pos, node)
	mesecon:update_autoconnect(pos)
end)

function mesecon:update_autoconnect(pos, secondcall)
	local xppos = {x=pos.x+1, y=pos.y, z=pos.z}
	local zppos = {x=pos.x, y=pos.y, z=pos.z+1}
	local xmpos = {x=pos.x-1, y=pos.y, z=pos.z}
	local zmpos = {x=pos.x, y=pos.y, z=pos.z-1}

	local xpympos = {x=pos.x+1, y=pos.y-1, z=pos.z}
	local zpympos = {x=pos.x, y=pos.y-1, z=pos.z+1}
	local xmympos = {x=pos.x-1, y=pos.y-1, z=pos.z}
	local zmympos = {x=pos.x, y=pos.y-1, z=pos.z-1}

	local xpypos = {x=pos.x+1, y=pos.y+1, z=pos.z}
	local zpypos = {x=pos.x, y=pos.y+1, z=pos.z+1}
	local xmypos = {x=pos.x-1, y=pos.y+1, z=pos.z}
	local zmypos = {x=pos.x, y=pos.y+1, z=pos.z-1}

	if secondcall == nil then
		mesecon:update_autoconnect(xppos, true)
		mesecon:update_autoconnect(zppos, true)
		mesecon:update_autoconnect(xmpos, true)
		mesecon:update_autoconnect(zmpos, true)

		mesecon:update_autoconnect(xpypos, true)
		mesecon:update_autoconnect(zpypos, true)
		mesecon:update_autoconnect(xmypos, true)
		mesecon:update_autoconnect(zmypos, true)

		mesecon:update_autoconnect(xpympos, true)
		mesecon:update_autoconnect(zpympos, true)
		mesecon:update_autoconnect(xmympos, true)
		mesecon:update_autoconnect(zmympos, true)
	end

	nodename = minetest.env:get_node(pos).name
	if string.find(nodename, "wires:") == nil then return nil end

	xp = 	(minetest.get_item_group(minetest.env:get_node(xppos).name, "mesecon") > 0 or
		minetest.get_item_group(minetest.env:get_node(xpympos).name, "mesecon") > 0) and 1 or 0
	zp = 	(minetest.get_item_group(minetest.env:get_node(zppos).name, "mesecon")  > 0 or
		minetest.get_item_group(minetest.env:get_node(zpympos).name, "mesecon") > 0) and 1 or 0
	xm = 	(minetest.get_item_group(minetest.env:get_node(xmpos).name, "mesecon") > 0 or
		minetest.get_item_group(minetest.env:get_node(xmympos).name, "mesecon") > 0) and 1 or 0
	zm = 	(minetest.get_item_group(minetest.env:get_node(zmpos).name, "mesecon") > 0 or 
		minetest.get_item_group(minetest.env:get_node(zmympos).name, "mesecon") > 0) and 1 or 0


	xpy = minetest.get_item_group(minetest.env:get_node(xpypos).name, "mesecon")
	zpy = minetest.get_item_group(minetest.env:get_node(zpypos).name, "mesecon")
	xmy = minetest.get_item_group(minetest.env:get_node(xmypos).name, "mesecon")
	zmy = minetest.get_item_group(minetest.env:get_node(zmypos).name, "mesecon")

	if xpy == 1 then xp = 1 end
	if zpy == 1 then zp = 1 end
	if xmy == 1 then xm = 1 end
	if zmy == 1 then zm = 1 end

	local nodeid = 	tostring(xp )..tostring(zp )..tostring(xm )..tostring(zm )..
			tostring(xpy)..tostring(zpy)..tostring(xmy)..tostring(zmy)

	if string.find(nodename, "_off") ~= nil then
		minetest.env:set_node(pos, {name = "wires:"..nodeid.."_off"})
	else
		minetest.env:set_node(pos, {name = "wires:"..nodeid.."_on" })
	end
end
