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

local mesecon = {}

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
		groups = {snappy = 3, mesecon = 1}
	else
		groups = {snappy = 3, mesecon = 1, not_in_creative_inventory = 1}
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
			fixed = nodebox
		},
		node_box = {
			type = "fixed",
			fixed = nodebox
		},
		groups = groups,
		walkable = false,
		stack_max = 99,
		drop = "wires:horizontal_off"
	})

end
end
end
end
end
end
end
end

minetest.register_on_placenode(function(pos, node)
	if string.find(node.name, "wires:") ~= nil then
		mesecon:update_autoconnect(pos)
	end
end)

function mesecon:update_autoconnect(pos)
	xppos = {x=pos.x+1, y=pos.y, z=pos.z}
	zppos = {x=pos.x, y=pos.y, z=pos.z+1}
	xmpos = {x=pos.x-1, y=pos.y, z=pos.z}
	zmpos = {x=pos.x, y=pos.y, z=pos.z-1}
	xpypos = {x=pos.x+1, y=pos.y+1, z=pos.z}
	zpypos = {x=pos.x, y=pos.y+1, z=pos.z+1}
	xmypos = {x=pos.x-1, y=pos.y+1, z=pos.z}
	zmypos = {x=pos.x, y=pos.y+1, z=pos.z-1}

	xp = minetest.get_item_group(minetest.env:get_node(xppos), "mesecon")
	zp = minetest.get_item_group(minetest.env:get_node(zppos), "mesecon")
	xm = minetest.get_item_group(minetest.env:get_node(xmpos), "mesecon")
	zm = minetest.get_item_group(minetest.env:get_node(zmpos), "mesecon")

	xpy = minetest.get_item_group(minetest.env:get_node(xpypos), "mesecon")
	zpy = minetest.get_item_group(minetest.env:get_node(zpypos), "mesecon")
	xmy = minetest.get_item_group(minetest.env:get_node(xmypos), "mesecon")
	zmy = minetest.get_item_group(minetest.env:get_node(zmypos), "mesecon")

	if xpy then xp = 1 end
	if zpy then zp = 1 end
	if xmy then xm = 1 end
	if zmy then zm = 1 end

	local nodeid = 	tostring(xp )..tostring(zp )..tostring(xm )..tostring(zm )..
			tostring(xpy)..tostring(zpy)..tostring(xmy)..tostring(zmy)

	minetest.env:add_node(pos, {name = "wires:"..nodeid.."_off"})
end
