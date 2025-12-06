/client/proc/jumptoarea()
	set name = "Jump to Area"
	set desc = ""
	set category = "GameMaster"

	if(!holder)
		return

	var/mob/admin_mob = src.mob
	if(!admin_mob)
		to_chat(src, "No mob available to jump.")
		return

	var/list/sorted_areas = get_sorted_areas()
	var/area/A = browser_input_list(admin_mob, "Area to Jump To", "Area Jump", sorted_areas)
	if(!A)
		return

	var/list/turfs = list()
	for (var/list/zlevel_turfs as anything in A.get_zlevel_turf_lists())
		for (var/turf/area_turf as anything in zlevel_turfs)
			if(!area_turf.density)
				turfs.Add(area_turf)

	var/turf/T = safepick(turfs)
	if(!T)
		to_chat(src, "Nowhere to jump to!")
		return
	admin_mob.forceMove(T)
	log_admin("[key_name(admin_mob)] jumped to [AREACOORD(A)]")
	message_admins("[key_name_admin(admin_mob)] jumped to [AREACOORD(A)]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Area") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/jumptoturf(turf/T in world)
	set name = "Jump to Turf"
	set category = "Admin"

	if(!holder)
		return

	var/mob/admin_mob = src.mob
	if(!admin_mob)
		to_chat(src, "No mob available to jump.")
		return

	log_admin("[key_name(admin_mob)] jumped to [AREACOORD(T)]")
	message_admins("[key_name_admin(admin_mob)] jumped to [AREACOORD(T)]")
	admin_mob.forceMove(T)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Turf") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	return

/client/proc/jumptomob()
	set category = "GameMaster"
	set name = "Jump to Mob"

	if(!holder)
		return

	var/mob/admin_mob = src.mob
	if(!admin_mob)
		to_chat(src, "No mob available to jump.")
		return

	var/list/mobs = getpois(mobs_only = TRUE)
	var/target = browser_input_list(admin_mob, "Mob to jump to", "Jump to Mob", mobs)

	if(!target)
		return

	var/mob/M = mobs[target]
	if(!M)
		return

	var/mob/A = admin_mob
	var/turf/T = get_turf(M)

	if(T && isturf(T))
		A.forceMove(T)
		log_admin("[key_name(admin_mob)] jumped to [key_name(M)]")
		message_admins("[key_name_admin(admin_mob)] jumped to [ADMIN_LOOKUPFLW(M)] at [AREACOORD(M)]")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	else
		to_chat(A, span_warning("This mob is not located in the game world."))

/client/proc/jumptocoord(tx as num, ty as num, tz as num)
	set category = "Admin"
	set name = "Jump to Coordinate"

	if(!holder)
		return

	var/mob/admin_mob = src.mob
	if(!admin_mob)
		to_chat(src, "No mob available to jump.")
		return

	var/turf/T = locate(tx,ty,tz)
	admin_mob.forceMove(T)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Coordiate") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	message_admins("[key_name_admin(admin_mob)] jumped to coordinates [tx], [ty], [tz]")

/client/proc/jumptokey()
	set category = "GameMaster"
	set name = "Jump to Key"

	if(!holder)
		return

	var/mob/admin_mob = src.mob
	if(!admin_mob)
		to_chat(src, "No mob available to jump.")
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client

	keys = sortKey(keys)

	var/client/selection = browser_input_list(admin_mob, "Please, select a player!", "Admin Jumping", keys)
	if(!selection)
		to_chat(src, "No keys found.")
		return
	var/mob/M = selection.mob
	if(!M)
		return
	log_admin("[key_name(admin_mob)] jumped to [key_name(M)]")
	message_admins("[key_name_admin(admin_mob)] jumped to [ADMIN_LOOKUPFLW(M)]")

	admin_mob.forceMove(M.loc)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Jump To Key") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/Getmob()
	set category = "Admin"
	set name = "Get Mob"
	set desc = ""

	if(!holder)
		return

	var/mob/admin_mob = src.mob
	if(!admin_mob)
		to_chat(src, "No mob available to jump.")
		return

	var/list/mobs = getpois(mobs_only = TRUE)
	var/target = browser_input_list(admin_mob, "Mob to get", "Get Mob", mobs)

	if(!target)
		return

	var/mob/M = mobs[target]
	if(!M)
		return
	var/atom/loc = get_turf(admin_mob)
	M.admin_teleport(loc)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Get Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/// Proc to hook user-enacted teleporting behavior and keep logging of the event.
/atom/movable/proc/admin_teleport(atom/new_location)
	if(isnull(new_location))
		log_admin("[key_name(usr)] teleported [key_name(src)] to nullspace")
		moveToNullspace()
	else
		var/turf/location = get_turf(new_location)
		log_admin("[key_name(usr)] teleported [key_name(src)] to [AREACOORD(location)]")
		forceMove(new_location)

/mob/admin_teleport(atom/new_location)
	var/turf/location = get_turf(new_location)
	var/msg = "[key_name_admin(usr)] teleported [ADMIN_LOOKUPFLW(src)] to [isnull(new_location) ? "nullspace" : ADMIN_VERBOSEJMP(location)]"
	message_admins(msg)
	admin_ticket_log(src, msg)
	return ..()

/client/proc/Getkey()
	set category = "Admin"
	set name = "Get Key"
	set desc = ""

	if(!holder)
		return

	var/mob/admin_mob = src.mob
	if(!admin_mob)
		to_chat(src, "No mob available to jump.")
		return

	var/list/keys = list()
	for(var/mob/M in GLOB.player_list)
		keys += M.client

	keys = sortKey(keys)

	var/client/selection = browser_input_list(admin_mob, "Please, select a player!", "Admin Jumping", keys)
	if(!selection)
		return

	var/mob/M = selection.mob
	if(!M)
		return

	log_admin("[key_name(admin_mob)] teleported [key_name(M)]")
	var/msg = "[key_name_admin(admin_mob)] teleported [ADMIN_LOOKUPFLW(M)]"
	message_admins(msg)
	admin_ticket_log(M, msg)
	if(M)
		M.forceMove(get_turf(admin_mob))
		admin_mob.forceMove(M.loc)
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Get Key") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/sendmob()
	set category = "Admin"
	set name = "Send Mob"

	if(!holder)
		return

	var/mob/admin_mob = src.mob
	if(!admin_mob)
		to_chat(src, "No mob available to jump.")
		return

	var/list/mobs = getpois(mobs_only = TRUE)
	var/target = browser_input_list(admin_mob, "Mob to send", "Send Mob", mobs)

	if(!target)
		return

	var/mob/M = mobs[target]
	if(!M)
		return

	var/list/sorted_areas = get_sorted_areas()
	if(!length(sorted_areas))
		to_chat(src, "No areas found.")
		return

	var/area/A = browser_input_list(admin_mob, "Pick an area", "Area pick", sorted_areas)
	if(A && istype(A))
		if(M.forceMove(safepick(get_area_turfs(A))))
			log_admin("[key_name(admin_mob)] teleported [key_name(M)] to [AREACOORD(A)]")
			var/msg = "[key_name_admin(admin_mob)] teleported [ADMIN_LOOKUPFLW(M)] to [AREACOORD(A)]"
			message_admins(msg)
			admin_ticket_log(M, msg)
		else
			to_chat(src, "Failed to move mob to a valid location.")
		SSblackbox.record_feedback("tally", "admin_verb", 1, "Send Mob") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/spawn_in_test_area()
	set name = "Spawn in Test Area"
	set desc = ""
	set category = "GameMaster"

	if(!holder)
		return

	var/turf/warp_place = pick(GLOB.admin_warp)
	if(!warp_place)
		return

	var/mob/living/carbon/human/new_human = new (warp_place)

	var/datum/outfit/outfit = new /datum/outfit/tailor
	outfit.equip(new_human)

	prefs.safe_transfer_prefs_to(new_human)
	new_human.ckey = ckey
