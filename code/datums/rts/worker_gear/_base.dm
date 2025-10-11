/datum/worker_gear
	var/obj/item/item
	var/slot
	var/datum/worker_mind/owner

	// Gear effects
	var/work_speed_modifier = 1.0
	var/stamina_cost_modifier = 1.0
	var/walkspeed_modifier = 0
	var/stamina_regen_modifier = 1.0
	var/stamina_modifier = 0

	// Task-specific bonuses
	var/list/task_bonuses = list()

/datum/worker_gear/New(obj/item/new_item, new_slot, datum/worker_mind/new_owner)
	. = ..()
	item = new_item
	slot = new_slot
	owner = new_owner

/datum/worker_gear/proc/get_task_bonus(datum/work_order/task, task_key)
	// Apply any task-specific bonuses
	for(var/task_type in task_bonuses)
		if(istype(task, task_type) && (task_key in task_bonuses[task_type]))
			var/list/bonuses = task_bonuses[task_type]
			return bonuses[task_key]
	return


/datum/worker_gear/proc/get_work_speed_modifier()
	return work_speed_modifier

/datum/worker_gear/proc/get_stamina_cost_modifier()
	return stamina_cost_modifier

/datum/worker_gear/proc/get_walkspeed_modifier()
	return walkspeed_modifier

/datum/worker_gear/proc/get_stamina_regen_modifier()
	return stamina_regen_modifier

/datum/worker_gear/proc/get_stamina_modifier()
	return stamina_modifier

/datum/worker_gear/instrument

/datum/worker_gear/pickaxe
	task_bonuses = list(
		/datum/work_order/mine = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9, TASK_KEY_QUANTITY = 2),
		/datum/work_order/break_turf = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/miner_cap
	task_bonuses = list(
		/datum/work_order/mine = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9),
		/datum/work_order/break_turf = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/miner_shoes
	task_bonuses = list(
		/datum/work_order/mine = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9),
		/datum/work_order/break_turf = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/miner_chest
	task_bonuses = list(
		/datum/work_order/mine = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9),
		/datum/work_order/break_turf = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)

/datum/worker_gear/miner_pants
	task_bonuses = list(
		/datum/work_order/mine = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9),
		/datum/work_order/break_turf = list(TASK_KEY_SPEED = 1.1, TASK_KEY_REDUCTION = 0.9)
	)
