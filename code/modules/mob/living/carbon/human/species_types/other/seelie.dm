#define SEELIE_WING_TRAIT "seelie_nowings"

/mob
	var/seelie_aura = FALSE
	var/list/seelie_aura_affected
	var/seelie_aura_timer

/mob/living/carbon/human/species/seelie
	race = /datum/species/seelie

/datum/species/seelie
	name = "Seelie"
	id = SPEC_ID_SEELIE
	desc = "Tiny fae sprites whose mischief and magic are better suited to aiding others than swinging a hammer. They flit about on gossamer wings, but their bodies are fragile. NOTE: Due to a roundstart assignment issue, please join as a Seelie via latejoin. You will not be able to select a role before the round starts."

	skin_tone_wording = "Elemental Connection"

	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_TINY, TRAIT_NOMOBSWAP, TRAIT_NOFALLDAMAGE1)

	specstats_m = list(STATKEY_STR = -6, STATKEY_PER = 4, STATKEY_INT = 2, STATKEY_CON = -6, STATKEY_END = -1, STATKEY_SPD = 7)
	specstats_f = list(STATKEY_STR = -6, STATKEY_PER = 4, STATKEY_INT = 2, STATKEY_CON = -6, STATKEY_END = -1, STATKEY_SPD = 7)

	allowed_pronouns = PRONOUNS_LIST_NO_IT

	possible_ages = ALL_AGES_LIST
	use_skintones = TRUE

	limbs_icon_m = 'icons/roguetown/mob/bodies/f/fm.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/fm.dmi'
	dam_icon_m = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/dam_female.dmi'

	soundpack_m = /datum/voicepack/female/elf
	soundpack_f = /datum/voicepack/female/elf

	enflamed_icon = "widefire"

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
		ORGAN_SLOT_WINGS = /obj/item/organ/wings/anthro/seelie,
	)

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/organ/wings/seelie,
		/datum/customizer/organ/genitals/penis/human,
		/datum/customizer/organ/genitals/vagina/human,
		/datum/customizer/organ/genitals/breasts/human,
		/datum/customizer/organ/genitals/testicles/human,
	)

/datum/species/seelie/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)

/datum/species/seelie/spec_life(mob/living/carbon/human/C)
	. = ..()
	enforce_wing_requirement(C)
	// If someone managed to stand via buckle exploits, push them back down when wingless
	if(!C.getorganslot(ORGAN_SLOT_WINGS) && C.body_position != LYING_DOWN)
		C.set_body_position(LYING_DOWN)
		C.set_resting(TRUE, silent = TRUE)
	// Keep the smaller scale consistent
	C.seelie_ensure_scale()
	// Keep the innate movement penalty applied
	if(!C.has_movespeed_modifier("seelie_move"))
		C.add_movespeed_modifier("seelie_move", override = TRUE, multiplicative_slowdown = 0.5)

/datum/species/seelie/proc/enforce_wing_requirement(mob/living/carbon/human/C)
	if(!C)
		return
	var/has_wings = C.getorganslot(ORGAN_SLOT_WINGS)
	if(has_wings)
		REMOVE_TRAIT(C, TRAIT_FLOORED, SEELIE_WING_TRAIT)
		C.mobility_flags |= MOBILITY_STAND
		if(C.body_position == LYING_DOWN && !C.resting)
			C.set_body_position(STANDING_UP)
	else
		ADD_TRAIT(C, TRAIT_FLOORED, SEELIE_WING_TRAIT)
		C.mobility_flags &= ~MOBILITY_STAND
		if(C.body_position != LYING_DOWN)
			C.set_body_position(LYING_DOWN)
			C.set_resting(TRUE, silent = TRUE)

/mob/living/carbon/human/proc/seelie_ensure_scale()
	if(!isseelie(src))
		return
	var/matrix/mat = matrix() * 0.6
	if(transform != mat)
		transform = mat
		update_transform()

/datum/species/seelie/on_species_gain(mob/living/carbon/C, datum/species/old_species, datum/preferences/pref_load)
	. = ..()
	C.pass_flags |= (PASSTABLE | PASSMOB)
	C.transform = matrix() * 0.6
	C.update_transform()
	C.add_movespeed_modifier("seelie_move", override = TRUE, multiplicative_slowdown = 0.5)
	ADD_TRAIT(C, TRAIT_PACIFISM, "[type]")
	ADD_TRAIT(C, TRAIT_MOVE_FLOATING, "[type]")
	var/obj/item/organ/wings/W = C.getorganslot(ORGAN_SLOT_WINGS)
	if(!W)
		W = new /obj/item/organ/wings/anthro/seelie()
		W.Insert(C, TRUE, TRUE)
	C.update_body()
	if(C.gender == MALE)
		if(!C.getorganslot(ORGAN_SLOT_PENIS))
			var/obj/item/organ/genitals/penis/P = new /obj/item/organ/genitals/penis()
			P.Insert(C, TRUE, TRUE)
		if(!C.getorganslot(ORGAN_SLOT_TESTICLES))
			var/obj/item/organ/genitals/testicles/T = new /obj/item/organ/genitals/testicles()
			T.Insert(C, TRUE, TRUE)
	else
		if(!C.getorganslot(ORGAN_SLOT_VAGINA))
			var/obj/item/organ/genitals/vagina/V = new /obj/item/organ/genitals/vagina()
			V.Insert(C, TRUE, TRUE)
	if(!C.getorganslot(ORGAN_SLOT_BREASTS))
		var/obj/item/organ/genitals/breasts/B = new /obj/item/organ/genitals/breasts()
		B.Insert(C, TRUE, TRUE)
	C.verbs |= list(
		/mob/living/carbon/human/proc/seelie_exit_container
	)

/datum/species/seelie/on_species_loss(mob/living/carbon/C)
	. = ..()
	C.pass_flags &= ~(PASSTABLE | PASSMOB)
	C.transform = matrix()
	C.update_transform()
	REMOVE_TRAIT(C, TRAIT_MOVE_FLOATING, "[type]")
	REMOVE_TRAIT(C, TRAIT_PACIFISM, "[type]")
	C.remove_movespeed_modifier("seelie_move")
	C.verbs -= list(
		/mob/living/carbon/human/proc/seelie_exit_container
	)

/datum/species/seelie/check_roundstart_eligible()
	return TRUE

/datum/species/seelie/get_skin_list()
	return sortList(list(
		"Moonlit Petal" = SKIN_COLOR_PLATINUM,
		"Dewdrop" = SKIN_COLOR_SNOW_ELF,
		"Lilac Mist" = SKIN_COLOR_COCOON,
		"Rose Quartz" = SKIN_COLOR_SPIRITCRUSHER,
		"Dusk Bloom" = SKIN_COLOR_GLOOMHAVEN,
		"Riverstone" = SKIN_COLOR_ASHEN,
		"Mosslight" = SKIN_COLOR_MURKWALKER,
		"Stormglass" = SKIN_COLOR_SHELLCREST,
		"Shadowed Willow" = SKIN_COLOR_BLACK_HAMMER,
		"Nectar Amber" = SKIN_COLOR_AURUM,
		"Soft Clay" = SKIN_COLOR_BLOOD_AXE,
		"Velvet Violet" = SKIN_COLOR_JACKPOISON,
	))

/mob/living/carbon/human/proc/seelie_perch_on(atom/target)
	if(!isseelie(src) || QDELETED(target))
		return FALSE
	if(get_dist(src, target) > 1)
		return FALSE
	if(!ishuman(target) && !istype(target, /mob/living/simple_animal/hostile/retaliate/bigrat) && !istype(target, /mob/living/simple_animal/hostile/retaliate/smallrat))
		return FALSE
	var/mob/living/L = target
	if(L == src || L.buckled)
		return FALSE
	if(L.buckle_mob(src, TRUE, TRUE, FALSE, 0, 0))
		src.visible_message(span_notice("[src] flutters onto [L]'s shoulder."), span_notice("I perch on [L]."))
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/seelie_enter_container(atom/target)
	if(!isseelie(src) || QDELETED(target))
		return FALSE
	if(get_dist(src, target) > 1)
		return FALSE
	// Lanterns keep their special light behavior
	if(istype(target, /obj/item/flashlight/flare/torch/lantern))
		var/obj/item/flashlight/flare/torch/lantern/L = target
		if(L.on || L.seelie_inside)
			return FALSE
		if(L.seelie_inside)
			return FALSE
		L.seelie_inside = WEAKREF(src)
		src.forceMove(L)
		to_chat(src, span_notice("I squeeze into [L]."))
		L.update_brightness()
		return TRUE
	// Closets/crates and other closet children
	if(istype(target, /obj/structure/closet))
		var/obj/structure/closet/C = target
		if(!C.opened)
			C.open()
		src.forceMove(C)
		to_chat(src, span_notice("I slip into [C]."))
		seelie_ensure_scale()
		return TRUE
	// Generic storage items (satchels, bags, boxes)
	if(istype(target, /obj/item/storage))
		var/obj/item/storage/S = target
		src.forceMove(S)
		to_chat(src, span_notice("I tuck myself inside [S]."))
		seelie_ensure_scale()
		return TRUE
	return FALSE

/mob/living/carbon/human/proc/seelie_force_into_container(atom/target, mob/living/forcer)
	if(!isseelie(src) || QDELETED(target))
		return FALSE
	// allow being stuffed into worn containers on the grabber
	if(forcer)
		if(get_dist(src, forcer) > 1 && get_dist(src, target) > 1)
			return FALSE
	else
		if(get_dist(src, target) > 1)
			return FALSE
	if(forcer)
		var/highest = null
		if(ishuman(forcer))
			var/mob/living/carbon/human/HF = forcer
			highest = HF.get_highest_grab_state_on(src)
		if(isnull(highest))
			highest = forcer.grab_state
		if(highest < GRAB_AGGRESSIVE)
			return FALSE
	return seelie_enter_container(target)

/mob/living/carbon/human/proc/seelie_exit_container()
	set name = "Leave Container"
	set category = "Seelie"
	if(!isseelie(src))
		return
	if(handcuffed || legcuffed)
		to_chat(src, span_warning("I'm bound and can't wriggle free. I need to escape my restraints first!"))
		resist_restraints()
		return
	var/obj/item/flashlight/flare/torch/lantern/L
	if(istype(loc, /obj/item/flashlight/flare/torch/lantern))
		L = loc
		L.seelie_inside = null
	var/turf/T = get_turf(loc)
	forceMove(T)
	seelie_ensure_scale()
	to_chat(src, span_notice("I flutter out of [loc]."))
	if(L)
		L.update_brightness()

/mob/living/carbon/human/proc/Turnlight()
	set name = "Seelie glow"
	set category = "Seelie"

	if(!isseelie(src))
		return
	if(src.light_power)
		to_chat(src, span_notice("I stop glowing"))
		src.set_light(0, 0, 0, LIGHTING_DEFAULT_FALLOFF_CURVE, null, FALSE)
		src.update_light()
	else
		to_chat(src, span_notice("I begin to glow once more"))
		src.set_light(3, 1.5, 1.5, LIGHTING_DEFAULT_FALLOFF_CURVE, "#d4fcac", TRUE)
		src.update_light()

/mob/living/carbon/proc/switchaura()
	set name = "Luck aura"
	set category = "Seelie"

	if(!isseelie(src))
		return
	seelie_aura = !seelie_aura
	src.update_seelie_aura_field()
	src.log_message("[key_name(src)] has switched their aura to apply [seelie_aura ? "good" : "bad"] luck")
	if(seelie_aura)
		to_chat(src, span_warning("My aura is now one of blessing"))
		src.visible_message(span_notice("[src] radiates a gentle, lucky glow."), span_notice("I radiate a gentle, lucky glow."))
	else
		to_chat(src, span_warning("My aura is now one of misery"))
		src.visible_message(span_warning("[src] radiates a faintly ominous aura."), span_warning("I radiate a faintly ominous aura."))
	start_seelie_aura_loop()

/mob/living/carbon/proc/start_seelie_aura_loop()
	if(seelie_aura_timer)
		return
	if(!seelie_aura_affected)
		seelie_aura_affected = list()
	seelie_aura_timer = addtimer(CALLBACK(src, PROC_REF(process_seelie_aura_tick)), 2 SECONDS, TIMER_LOOP | TIMER_STOPPABLE)

/mob/living/carbon/proc/stop_seelie_aura_loop()
	if(seelie_aura_timer)
		deltimer(seelie_aura_timer)
	seelie_aura_timer = null

/mob/living/carbon/proc/clear_seelie_aura_effects()
	if(!length(seelie_aura_affected))
		return
	for(var/mob/living/L as anything in seelie_aura_affected)
		if(QDELETED(L))
			continue
		L.remove_stat_modifier("[REF(src)]_seelie_aura")
	seelie_aura_affected = null

/mob/living/carbon/proc/process_seelie_aura_tick()
	if(QDELETED(src) || !isseelie(src))
		stop_seelie_aura_loop()
		clear_seelie_aura_effects()
		return
	update_seelie_aura_field()

/mob/living/carbon/proc/update_seelie_aura_field()
	if(!isseelie(src))
		return
	if(!seelie_aura_affected)
		seelie_aura_affected = list()
	var/luck_delta = seelie_aura ? 2 : -2
	var/list/current = list()
	for(var/mob/living/L in view(3, src))
		if(QDELETED(L))
			continue
		L.adjust_stat_modifier("[REF(src)]_seelie_aura", list(STATKEY_LCK = luck_delta))
		if(seelie_aura)
			L.apply_status_effect(/datum/status_effect/buff/seelie_luck_good)
		else
			L.apply_status_effect(/datum/status_effect/debuff/seelie_luck_bad)
		current |= L
	if(!(src in current))
		src.adjust_stat_modifier("[REF(src)]_seelie_aura", list(STATKEY_LCK = luck_delta))
		if(seelie_aura)
			src.apply_status_effect(/datum/status_effect/buff/seelie_luck_good)
		else
			src.apply_status_effect(/datum/status_effect/debuff/seelie_luck_bad)
		current |= src
	if(seelie_aura_affected)
		for(var/mob/living/old as anything in seelie_aura_affected)
			if(QDELETED(old))
				continue
			if(!(old in current))
				old.remove_stat_modifier("[REF(src)]_seelie_aura")
				old.remove_status_effect(/datum/status_effect/buff/seelie_luck_good)
				old.remove_status_effect(/datum/status_effect/debuff/seelie_luck_bad)
	seelie_aura_affected = current

/mob/living/carbon/human/Move(NewLoc, direct)
	if(isseelie(src) && (handcuffed || legcuffed))
		if(istype(loc, /obj/structure/closet) || istype(loc, /obj/item/storage) || istype(loc, /obj/item/flashlight/flare/torch/lantern))
			to_chat(src, span_warning("I'm bound and can't wriggle free. I need to escape my restraints first!"))
			resist_restraints()
			return FALSE
	. = ..()

/mob/living/carbon/human/MouseDrop_T(atom/over_object, src_location, over_location, src_control, over_control, params)
	if(isseelie(src))
		if(seelie_perch_on(over_object))
			return
		if(seelie_enter_container(over_object))
			return
	. = ..()

#undef SEELIE_WING_TRAIT
