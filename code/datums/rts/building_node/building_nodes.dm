/obj/effect/building_node
	name = "Building Node"
	desc = "A generic building"
	plane = STRATEGY_PLANE

	///this is our template id
	var/work_template

	var/list/added_assignments

	var/list/workspots = list()

	var/maximum_workers = 1

	var/list/materials_to_store = list()

	var/list/material_requests = list()

	var/list/persistant_nodes = list()

	var/list/work_materials = list()

	var/list/stored_gear = list()

/obj/effect/building_node/Click(location, control, params)
	. = ..()
	var/list/modifiers = params2list(params)
	if(modifiers["right"])
		handle_right_click(usr)

/obj/effect/building_node/proc/handle_right_click(mob/camera/strategy_controller/user)
	if(!istype(user))
		return
	user.open_gear_ui(src)

/obj/effect/building_node/proc/store_gear(obj/item/item, gear_type)
	if(!stored_gear)
		stored_gear = list()
	stored_gear[gear_type] = item
	item.forceMove(src)

/obj/effect/building_node/proc/retrieve_gear(gear_type)
	if(!stored_gear || !(gear_type in stored_gear))
		return null

	var/obj/item/item = stored_gear[gear_type]
	stored_gear -= gear_type
	return item

/obj/effect/building_node/proc/get_stored_gear(gear_type)
	if(!stored_gear)
		return null
	return stored_gear[gear_type]

/obj/effect/building_node/proc/get_stored_gear_by_type(slot_type)
	if(!stored_gear)
		return list()

	var/list/matching_gear = list()
	for(var/gear_key in stored_gear)
		if(findtext(gear_key, slot_type))
			matching_gear[gear_key] = stored_gear[gear_key]

	return matching_gear

/obj/effect/building_node/proc/get_storage_capacity(slot_type)
	return 6 // override in subtypes if needed

/obj/effect/building_node/proc/get_stored_count(slot_type)
	var/list/matching = get_stored_gear_by_type(slot_type)
	return length(matching)

/obj/effect/building_node/proc/can_store_more(slot_type)
	return get_stored_count(slot_type) < get_storage_capacity(slot_type)

/obj/effect/building_node/proc/on_construction(mob/camera/strategy_controller/master_controller)
	SHOULD_CALL_PARENT(TRUE)
	master_controller.constructed_building_nodes |= src
	if(length(added_assignments))
		master_controller.add_assignments(added_assignments)

	var/datum/map_template/template = SSmapping.map_templates[work_template]

	var/list/turfs = template.get_affected_turfs(get_turf(src), TRUE)
	for(var/turf/turf as anything in turfs)
		for(var/obj/effect/workspot/spot in turf.contents)
			workspots |= spot
	after_construction(turfs, master_controller)

	var/list/created_nodes = list()
	for(var/datum/persistant_workorder/node as anything in persistant_nodes)
		created_nodes |= new node(src)
	persistant_nodes = created_nodes

/obj/effect/building_node/proc/after_construction(list/turfs, atom/master)
	SHOULD_CALL_PARENT(TRUE)
	for(var/turf/turf in turfs)
		var/mob/camera/strategy_controller/overlord_controller/controller = master
		for(var/obj/structure/lootable_structure/stockpile/structure in turf.contents)
			structure.linked_stockpile = controller.resource_stockpile
	return

/obj/effect/building_node/proc/add_material_request(location, list/resource_amount, multiplier = 1)
	if(location in material_requests)
		return
	material_requests |= location

	for(var/resource in resource_amount)
		resource_amount[resource] *= multiplier
	material_requests[location] = resource_amount

/obj/effect/building_node/proc/use_work_materials(list/used_materials)
	if(!length(work_materials))
		return FALSE

	for(var/material in used_materials)
		if(!(material in work_materials))
			return FALSE
		if(work_materials[material] < used_materials[material])
			return FALSE

	for(var/material in used_materials)
		work_materials[material] -= used_materials[material]
	return TRUE

/obj/effect/building_node/proc/select_workorder(mob/user)
	if(!length(persistant_nodes))
		return
	var/list/name_to_node = list()
	var/list/radial_options = list()
	for(var/datum/persistant_workorder/order in persistant_nodes)
		radial_options |= order.name
		radial_options[order.name] = image(order.ui_icon, order.ui_icon_state)
		name_to_node |= order.name
		name_to_node[order.name] = order

	var/picked = show_radial_menu(user, src, radial_options)
	if(!picked)
		return

	return name_to_node[picked]

/obj/effect/building_node/stockpile
	name = "Stockpile"
	work_template = "stockpile"

	var/datum/stockpile/stockpile

/obj/effect/building_node/stockpile/on_construction(mob/camera/strategy_controller/master_controller)
	. = ..()
	if(!master_controller.resource_stockpile)
		master_controller.resource_stockpile = new /datum/stockpile
	stockpile = master_controller.resource_stockpile

/obj/effect/building_node/proc/override_click(mob/camera/strategy_controller/user)
	return FALSE
