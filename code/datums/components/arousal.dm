#define ARO_LOSS_COEFFICIENT 10

/datum/component/arousal
	/// Our arousal level
	var/arousal = 0
	/// Arousal won't change if active
	var/arousal_frozen = FALSE
	/// Last time arousal increased
	var/last_arousal_increase_time = 0
	/// Last moan time for cooldowns
	var/last_moan = 0
	/// Last pain effect time
	var/last_pain = 0
	///our multiplier
	var/arousal_multiplier = 1
	/// Our charge gauge
	var/charge = SEX_MAX_CHARGE
	/// Last ejaculation time
	var/last_ejaculation_time = 0
	/// Last climax count reset time
	var/last_climax_reset_time = 0
	/// Our edging charge
	var/edging_charge = 0
	/// 60% arousal loss after each orgasm
	var/arousal_falloff_coeff = 0.4
	/// Level of pleasure resistance
	var/resistance_to_pleasure = RESIST_NONE
	/// Recent orgasm count
	var/recent_orgasm_count = 0

/datum/component/arousal/Initialize(...)
	. = ..()
	START_PROCESSING(SSobj, src)

/datum/component/arousal/Destroy(force)
	. = ..()
	STOP_PROCESSING(SSobj, src)

/datum/component/arousal/RegisterWithParent()
	. = ..()
	RegisterSignal(parent, COMSIG_SEX_ADJUST_AROUSAL, PROC_REF(adjust_arousal))
	RegisterSignal(parent, COMSIG_SEX_SET_AROUSAL, PROC_REF(set_arousal))
	RegisterSignal(parent, COMSIG_SEX_FREEZE_AROUSAL, PROC_REF(freeze_arousal))
	RegisterSignal(parent, COMSIG_SEX_GET_AROUSAL, PROC_REF(get_arousal))
	RegisterSignal(parent, COMSIG_SEX_RECEIVE_ACTION, PROC_REF(receive_sex_action))
	RegisterSignal(parent, COMSIG_SEX_ADJUST_EDGING, PROC_REF(adjust_edging))
	RegisterSignal(parent, COMSIG_SEX_SET_EDGING, PROC_REF(set_edging))
	RegisterSignal(parent, COMSIG_SEX_SET_HOLDING, PROC_REF(set_holding_pleasure))
	RegisterSignal(parent, COMSIG_SEX_HOLE_BEFORE_INSERT, PROC_REF(hole_before_insert_handle))
	RegisterSignal(parent, COMSIG_SEX_HOLE_AFTER_INSERT, PROC_REF(hole_after_insert_handle))
	RegisterSignal(parent, COMSIG_SEX_HOLE_BEFORE_REMOVE, PROC_REF(hole_before_remove_handle))
	RegisterSignal(parent, COMSIG_SEX_HOLE_AFTER_REMOVE, PROC_REF(hole_after_remove_handle))

/datum/component/arousal/UnregisterFromParent()
	. = ..()
	UnregisterSignal(parent, COMSIG_SEX_ADJUST_AROUSAL)
	UnregisterSignal(parent, COMSIG_SEX_SET_AROUSAL)
	UnregisterSignal(parent, COMSIG_SEX_FREEZE_AROUSAL)
	UnregisterSignal(parent, COMSIG_SEX_GET_AROUSAL)
	UnregisterSignal(parent, COMSIG_SEX_RECEIVE_ACTION)
	UnregisterSignal(parent, COMSIG_SEX_ADJUST_EDGING)
	UnregisterSignal(parent, COMSIG_SEX_SET_EDGING)
	UnregisterSignal(parent, COMSIG_SEX_SET_HOLDING)
	UnregisterSignal(parent, COMSIG_SEX_HOLE_BEFORE_INSERT)
	UnregisterSignal(parent, COMSIG_SEX_HOLE_AFTER_INSERT)
	UnregisterSignal(parent, COMSIG_SEX_HOLE_BEFORE_REMOVE)
	UnregisterSignal(parent, COMSIG_SEX_HOLE_AFTER_REMOVE)

/datum/component/arousal/process()
	handle_charge()
	handle_aroousal_cooling()
	handle_orgasm_count()
	handle_statuses()
	handle_passive_orgasm()


/datum/component/arousal/proc/handle_orgasm_count()
	if(!recent_orgasm_count)
		return
	if(last_climax_reset_time + ORGASM_RESET_TIME < world.time)
		recent_orgasm_count -= 1
		last_climax_reset_time = world.time

/datum/component/arousal/proc/handle_aroousal_cooling()
	//if(!can_lose_arousal())
	//	return
	if(arousal_frozen)
		return
	if(!can_climax())
		adjust_arousal(parent, -1 * ARO_LOSS_COEFFICIENT * IMPOTENT_AROUSAL_LOSS_RATE)
	if(last_arousal_increase_time + AROUSAL_TIME_TO_UNHORNY >= world.time)
		return
	var/rate
	switch(arousal)
		if(-INFINITY to 25)
			rate = AROUSAL_LOW_UNHORNY_RATE
		if(25 to 40)
			rate = AROUSAL_MID_UNHORNY_RATE
		if(40 to INFINITY)
			rate = AROUSAL_HIGH_UNHORNY_RATE
	adjust_arousal(parent, -1 * ARO_LOSS_COEFFICIENT * rate)

	adjust_edging(parent, -1 * ARO_LOSS_COEFFICIENT * 0.01)

/datum/component/arousal/proc/handle_passive_orgasm()
	if(arousal < PASSIVE_EJAC_THRESHOLD)
		return
	if(!can_climax())
		return FALSE
	ejaculate(giving = FALSE)

/datum/component/arousal/proc/can_climax()
	// Add some checks for like curses or something here.
	if(last_ejaculation_time + ORGASM_COOLDOWN_TIME - clamp(edging_charge, 0, ORGASM_COOLDOWN_TIME - 10) >= world.time)
		return FALSE
	return TRUE

/datum/component/arousal/proc/can_lose_arousal()
	if(last_arousal_increase_time + 2 MINUTES > world.time)
		return FALSE
	return TRUE

/datum/component/arousal/proc/set_holding_pleasure(datum/source, level)
	resistance_to_pleasure = level
	return resistance_to_pleasure

/datum/component/arousal/proc/set_arousal(datum/source, amount)
	if(amount > arousal)
		last_arousal_increase_time = world.time
	arousal = clamp(amount, 0, MAX_AROUSAL)
	update_arousal_effects()
	if(iscarbon(parent))
		SEND_SIGNAL(parent, COMSIG_SEX_AROUSAL_CHANGED)
	return arousal

/datum/component/arousal/proc/adjust_arousal(datum/source, amount)
	if(arousal_frozen)
		return arousal
	if(arousal > 0)
		arousal *= arousal_multiplier
	return set_arousal(source, arousal + amount)

/datum/component/arousal/proc/freeze_arousal(datum/source, freeze_state = null)
	if(freeze_state == null)
		arousal_frozen = !arousal_frozen
	else
		arousal_frozen = freeze_state
	return arousal_frozen

/datum/component/arousal/proc/get_arousal(datum/source, list/arousal_data)
	arousal_data += list(
		"arousal" = arousal,
		"frozen" = arousal_frozen,
		"last_increase" = last_arousal_increase_time,
		"arousal_multiplier" = arousal_multiplier,
		"last_ejaculation_time" = last_ejaculation_time,
		"is_spent" = is_spent(),
		"edging" = edging_charge,
		"resistance_to_pleasure" = resistance_to_pleasure
	)

/datum/component/arousal/proc/adjust_edging(datum/source, amount)
	set_edging(source, edging_charge + amount)

/datum/component/arousal/proc/set_edging(datum/source, amount)
	edging_charge = clamp(amount, 0, MAX_EDGING)

/datum/component/arousal/proc/receive_sex_action(datum/source, arousal_amt, pain_amt, giving, applied_force, applied_speed, applied_resist, edged_by_other)
	var/mob/living/user = parent

	// Apply multipliers
	arousal_amt *= get_force_pleasure_multiplier(applied_force, giving)
	pain_amt *= get_force_pain_multiplier(applied_force)
	pain_amt *= get_speed_pain_multiplier(applied_speed)

	if(user.stat == DEAD)
		arousal_amt = 0
		pain_amt = 0
		//if(prob(2)) //since there is no proper diseases....
			//target.reagents.add_reagent(/datum/reagent/toxin, 1)

	var/sexhealrand = rand(0.2, 0.4)
	//go go gadget sex healing.. magic?
	/*if(user.buckled?.sleepy) //gooder healing in bed
		sexhealrand *= 4
	if(!issimple(parent)||!issimple(target))
		if(parent.health < user.maxHealth) //so its not spammy
			if(parent.patron.type == /datum/patron/divine/eora)
				var/sexhealmult = parent.mind.get_skill_level(/datum/skill/magic/holy)
				if(sexhealmult < 2) //so its never below 2 for ones with trait.
					sexhealmult = 2
				sexhealrand *= sexhealmult
				//heals target unless user zaping.
				if(!user.cmode)
					if(!issimple(target))
						target.adjustBruteLoss(-sexhealrand)
						target.adjustFireLoss(-sexhealrand/2)
				if(prob(4))
					to_chat(user, span_green("I feel Viiritri's miracle upon me."))
					sexhealrand *= 2*/

	if(!user.cmode && prob(1)) //surprise heal burst at 1% chance
		to_chat(user, span_greentextbig("I suddenly feel much better thanks to this act..."))
		sexhealrand *= 5
	user.heal_wounds(sexhealrand)
	user.heal_overall_damage(sexhealrand, sexhealrand/2, updating_health = TRUE)

	//grant devotion through sex because who needs praying.
	//not sure if it works right but i dont need to test cuz its asked to be commented out anyway, ffs.
	/*if(!issimple(user))
		var/mob/living/carbon/human/devouser = user
		var/datum/devotion/C = devouser.patron?.devotion_holder
		if(devouser && C?.devotion)
			if(devouser.get_skill_level(/datum/skill/magic/holy))
				if(C.devotion < C.max_devotion)
					C.update_devotion(rand(1,2))
					if(devouser.patron.type == /datum/patron/divine/eora)
						C.update_devotion(rand(4,8))
						if(prob(3))
							to_chat(devouser, span_info("I feel Viiritri guide me."))*/

	var/isnymph = 0
	if(HAS_TRAIT(user, TRAIT_NYMPHO_CURSE) || user.has_flaw(/datum/charflaw/addiction/lovefiend))
		isnymph = 2
	if(user.has_status_effect(/datum/status_effect/debuff/orgasmbroken))
		if(isnymph)
			arousal_amt *= 2
		else
			arousal_amt *= 1.5
		update_aching(1, giving)
		var/lovermessage = pick("This feels too good!", "I must never stop!", "I want MORE!", "I need this!")
		if(prob(15))
			to_chat(user, span_love(lovermessage))
	else if(user.has_status_effect(/datum/status_effect/debuff/cumbrained))
		update_aching(5, giving)
		var/lovermessage
		if(!isnymph)
			arousal_amt *= 0.5
			lovermessage = pick("My mind is going blank!", "I'm too spent!", "This is too much!")
		else
			lovermessage = pick("My mind is getting fucked out!", "I'm soo full!", "I LOVE this!")
		if(prob(15))
			to_chat(user, span_love(lovermessage))
	else if(user.has_status_effect(/datum/status_effect/debuff/loinspent))
		update_aching(2, giving)
		var/lovermessage
		if(!isnymph)
			arousal_amt *= 0.8
			lovermessage = pick("This is starting to feel unpleasant...", "Maybe I should rest soon...", "My loins are starting to chafe a bit.")
		else
			lovermessage = pick("This is starting to feel interesting.", "We're getting there...", "I love this feeling.")
		if(prob(15))
			to_chat(user, span_love(lovermessage))
	if(user.has_status_effect(/datum/status_effect/edging_overstimulation))
		arousal_amt *= 2
		if(prob(15))
			var/stimmessage
			stimmessage = pick("I'm too sensitive!", "There's too much pleasure!")
			to_chat(user, span_love(stimmessage))
	if(arousal > 45 && applied_resist > RESIST_NONE)
		var/resmessage
		if(user.has_status_effect(/datum/status_effect/debuff/cumbrained))
			if(prob(15))
				resmessage = pick("I can't hold in the pleasure!", "My mind is blank, I can't concentrate on not cumming!")
				to_chat(user, span_love(resmessage))
		else
			arousal_amt *= get_resist_multiplier(applied_resist)
			if(prob(5))
				resmessage = pick("I focus on holding in the pleasure.", "I concentrate on trying not to cum...")
				to_chat(user, span_love(resmessage))
	if(arousal > AROUSAL_EDGING_THRESHOLD)
		adjust_edging(source, arousal_amt / 3)
		if(edged_by_other)
			arousal_amt = 0
			if(prob(15))
				var/edgemessage = pick("They are not letting me cum!", "Please, let me cum!", "I need to cum already!")
				to_chat(user, span_love(edgemessage))
	if(is_spent() || is_manhood_overstimulated())
		arousal_amt *= 0.8
		update_aching(8, giving)
		if(prob(5))
			var/spentmessage = pick("I need to let my loins rest!", "I came too much too quickly!")
			to_chat(user, span_warn(spentmessage))

	if(!arousal_frozen)
		adjust_arousal(source, arousal_amt)

	damage_from_pain(pain_amt, giving)
	try_ejaculate(giving)
	try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	try_do_pain_effect(pain_amt, giving)

/datum/component/arousal/proc/update_arousal_effects()
	update_pink_screen()
	handle_statuses()
	update_erect_state()

/datum/component/arousal/proc/try_ejaculate(giving = FALSE)
	if(arousal < PASSIVE_EJAC_THRESHOLD)
		return
	if(!can_climax())
		return
	ejaculate(giving)

/datum/component/arousal/proc/ejaculate(giving)
	var/mob/living/mob = parent
	var/list/parent_sessions = return_sessions_with_user(parent)
	var/datum/sex_session/highest_priority = return_highest_priority_action(parent_sessions, parent)
	playsound(parent, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
	// Special cases for when the user has a penis but no testicles & for eunuchs
	if((!mob.getorganslot(ORGAN_SLOT_TESTICLES) && mob.getorganslot(ORGAN_SLOT_PENIS)) || (!mob.getorganslot(ORGAN_SLOT_TESTICLES) && !mob.getorganslot(ORGAN_SLOT_VAGINA)))
		mob.visible_message(span_love("[mob] climaxes, yet nothing is released!"))
		after_ejaculation(FALSE, parent)
		return
	if(!highest_priority || !giving)
		mob.visible_message(span_love("[mob] orgasms!"))
		var/turf/turf = get_turf(parent)
		if(mob.getorganslot(ORGAN_SLOT_TESTICLES) && mob.getorganslot(ORGAN_SLOT_PENIS))
			var/obj/item/organ/genitals/filling_organ/testicles/testes = mob.getorganslot(ORGAN_SLOT_TESTICLES)
			if(testes)
				var/cum_to_take = min(3, testes.reagents.total_volume)
				if(testes.reagents)
					turf.add_liquid_from_reagents(testes.reagents, amount = cum_to_take)
		if(mob.getorganslot(ORGAN_SLOT_VAGINA))
			var/obj/item/organ/genitals/filling_organ/vagina/vag = mob.getorganslot(ORGAN_SLOT_VAGINA)
			if(vag)
				var/femcum_to_take = min(3, vag.reagents.total_volume)
				if(vag.reagents)
					turf.add_liquid_from_reagents(vag.reagents, amount = femcum_to_take)
		after_ejaculation(FALSE, parent, null)
	else
		var/datum/sex_action/action = SEX_ACTION(highest_priority.current_action)
		var/return_type = action.handle_climax_message(highest_priority.user, highest_priority.target)
		if(!return_type)
			var/turf/turf = get_turf(parent)
			if(mob.getorganslot(ORGAN_SLOT_TESTICLES) && mob.getorganslot(ORGAN_SLOT_PENIS))
				var/obj/item/organ/genitals/filling_organ/testicles/testes = mob.getorganslot(ORGAN_SLOT_TESTICLES)
				if(testes)
					var/cum_to_take = min(3, testes.reagents.total_volume)
					if(testes.reagents)
						turf.add_liquid_from_reagents(testes.reagents, amount = cum_to_take)
			if(mob.getorganslot(ORGAN_SLOT_VAGINA))
				var/obj/item/organ/genitals/filling_organ/vagina/vag = mob.getorganslot(ORGAN_SLOT_VAGINA)
				if(vag)
					var/femcum_to_take = min(3, vag.reagents.total_volume)
					if(vag.reagents)
						turf.add_liquid_from_reagents(vag.reagents, amount = femcum_to_take)
			after_ejaculation(FALSE, parent, highest_priority.target)
		else
			handle_climax(action, return_type, highest_priority.user, highest_priority.target)
		if(action.knot_on_finish)
			action.try_knot_on_climax(mob, highest_priority.target)


/datum/component/arousal/proc/handle_climax(datum/sex_action/action, climax_type, mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/genitals/filling_organ/testicles/testes
	var/obj/item/organ/genitals/filling_organ/vagina/vag
	if(user.getorganslot(ORGAN_SLOT_TESTICLES) && user.getorganslot(ORGAN_SLOT_PENIS))
		testes = user.getorganslot(ORGAN_SLOT_TESTICLES)
	if(user.getorganslot(ORGAN_SLOT_VAGINA))
		vag = user.getorganslot(ORGAN_SLOT_VAGINA)
	if(issimple(user))
		log_combat(user, user, "Ejaculated")
		user.visible_message(span_love("[user] makes a mess!"))
		playsound(user, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
		var/turf/turf = get_turf(target)
		turf.add_liquid(/datum/reagent/consumable/cum, 5)
		after_ejaculation(climax_type == "into" || climax_type == "oral", user, target)
		return
	switch(climax_type)
		if("onto")
			log_combat(user, target, "Came onto the target")
			playsound(target, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
			var/turf/turf = get_turf(target)
			if(testes)
				var/cum_to_take = CLAMP((testes.reagents.maximum_volume/2), 1, testes.reagents.total_volume)
				if(testes.reagents)
					turf.add_liquid_from_reagents(testes.reagents, amount = cum_to_take)
					if(target && !action.knot_on_finish)
						target.apply_status_effect(/datum/status_effect/facial)
			if(vag)
				var/femcum_to_take = min(8, vag.reagents.total_volume)
				if(vag.reagents)
					turf.add_liquid_from_reagents(testes.reagents, amount = femcum_to_take)
		if("into")
			var/obj/item/organ/genitals/filling_organ/cameloc
			switch(action.hole_id)
				if(ORGAN_SLOT_VAGINA)
					cameloc = target.getorganslot(ORGAN_SLOT_VAGINA)
				if(ORGAN_SLOT_ANUS)
					cameloc = target.getorganslot(ORGAN_SLOT_ANUS)
			if(cameloc)
				if(testes)
					if(testes.reagents)
						var/cum_to_take = CLAMP((testes.reagents.maximum_volume/4), 1, min(testes.reagents.total_volume, cameloc.reagents.maximum_volume - cameloc.reagents.total_volume))
						testes.reagents.trans_to(cameloc, cum_to_take, transfered_by = user, method = INGEST)
			else
				if(testes)
					if(testes.reagents)
						var/cum_to_take = CLAMP((testes.reagents.maximum_volume/4), 1, testes.reagents.total_volume)
						testes.reagents.trans_to(target,  cum_to_take, transfered_by = user, method = INGEST) //digest anyway if none of those.
			log_combat(user, target, "Came inside the target")
			playsound(target, 'sound/misc/mat/endin.ogg', 50, TRUE, ignore_walls = FALSE)
		if("oral")
			if(user.getorganslot(ORGAN_SLOT_PENIS) && action.check_sex_lock(user, ORGAN_SLOT_PENIS))
				if(testes)
					if(testes.reagents)
						var/cum_to_take = CLAMP((testes.reagents.maximum_volume/4), 1, min(testes.reagents.total_volume, target.reagents.maximum_volume - target.reagents.total_volume))
						testes.reagents.trans_to(target, cum_to_take, transfered_by = user, method = INGEST)
			if(user.getorganslot(ORGAN_SLOT_VAGINA) && action.check_sex_lock(user, ORGAN_SLOT_VAGINA))
				if(vag)
					if(vag.reagents)
						var/femcum_to_take = min(8, vag.reagents.total_volume)
						testes.reagents.trans_to(target, femcum_to_take, transfered_by = user, method = INGEST)
			log_combat(user, target, "Came inside the mouth of the target")
			playsound(target, 'sound/misc/mat/endin.ogg', 50, TRUE, ignore_walls = FALSE)
		if("self")
			log_combat(user, user, "Ejaculated")
			user.visible_message(span_love("[user] makes a mess!"))
			playsound(user, 'sound/misc/mat/endout.ogg', 50, TRUE, ignore_walls = FALSE)
			var/turf/turf = get_turf(target)
			if(testes)
				var/cum_to_take = CLAMP((testes.reagents.maximum_volume/2), 1, testes.reagents.total_volume)
				if(testes.reagents)
					turf.add_liquid_from_reagents(testes.reagents, amount = cum_to_take)
			if(vag)
				var/femcum_to_take = min(8, vag.reagents.total_volume)
				if(vag.reagents)
					turf.add_liquid_from_reagents(testes.reagents, amount = femcum_to_take)
	if(testes)
		if(testes.reagents)
			if(testes.reagents.total_volume <= testes.reagents.maximum_volume / 4)
				to_chat(user, span_info("Damn, my [pick(testes.altnames)] are pretty dry now."))
	after_ejaculation(climax_type == "into" || climax_type == "oral", user, target)

/datum/component/arousal/proc/after_ejaculation(intimate = FALSE, mob/living/carbon/human/user, mob/living/carbon/human/target)
	switch(edging_charge)
		if(10 to 20)
			to_chat(user, span_love("Feels good to finally cum!"))
		if(21 to 50)
			to_chat(user, span_love("Oh gods, I came!"))
		if(51 to MAX_EDGING)
			to_chat(user, span_love("Finally finally finally!"))

	if(user.has_penis())
		if(is_spent())
			to_chat(user, span_warn("This is really starting to hurt my dick!"))
			user.apply_status_effect(/datum/status_effect/edged_penis_cooldown)
			SEND_SIGNAL(user, COMSIG_SEX_SET_EDGING, edging_charge * 0.40)
		else
			SEND_SIGNAL(user, COMSIG_SEX_SET_EDGING, 0)

	else
		SEND_SIGNAL(user, COMSIG_SEX_SET_EDGING, edging_charge * 0.70)

	SEND_SIGNAL(user, COMSIG_SEX_SET_AROUSAL, arousal * (arousal_falloff_coeff + edging_charge / MAX_EDGING))
	SEND_SIGNAL(user, COMSIG_SEX_CLIMAX)

	if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
		user.sate_addiction()

	if(!user.rogue_sneaking && user.alpha > 100) //stealth sex, keep your voice down.
		if(!user.can_speak())
			user.emote("sexmoangag_org", forced = TRUE)
		else
			user.emote("sexmoanhvy", forced = TRUE)

	charge = max(0, charge - CHARGE_FOR_CLIMAX)

	user.add_stress(/datum/stress_event/cumok)
	user.playsound_local(user, 'sound/misc/mat/end.ogg', 100)
	last_ejaculation_time = world.time
	recent_orgasm_count += 1
	if(intimate)
		if(target)
			after_intimate_climax(user, target)

/datum/component/arousal/proc/after_intimate_climax(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return
	if(HAS_TRAIT(target, TRAIT_GOODLOVER))
		if(!MOBTIMER_FINISHED(user, "cumtri", 5 MINUTES)) //this isn't how mob timers work
			return

		MOBTIMER_SET(user, "cumtri")
		user.adjust_triumphs(1)
		user.add_stress(/datum/stress_event/cummax)
		to_chat(user, span_love("Our loving is a true TRIUMPH!"))
	if(HAS_TRAIT(user, TRAIT_GOODLOVER))
		if(!MOBTIMER_FINISHED(user, "cumtri", 5 MINUTES)) //this isn't how mob timers work
			return

		MOBTIMER_SET(user, "cumtri")
		target.adjust_triumphs(1)
		user.add_stress(/datum/stress_event/cummax)
		to_chat(target, span_love("Our loving is a true TRIUMPH!"))

/datum/component/arousal/proc/set_charge(amount)
	var/empty = (charge < CHARGE_FOR_CLIMAX)
	charge = clamp(amount, 0, SEX_MAX_CHARGE)
	var/after_empty = (charge < CHARGE_FOR_CLIMAX)
	if(empty && !after_empty)
		to_chat(parent, span_notice("I feel like I'm not so spent anymore"))
	if(!empty && after_empty)
		to_chat(parent, span_notice("I'm spent!"))

/datum/component/arousal/proc/adjust_charge(amount)
	set_charge(charge + amount)

/datum/component/arousal/proc/handle_charge()
	var/mob/living/user = parent
	adjust_charge(ARO_LOSS_COEFFICIENT * CHARGE_RECHARGE_RATE)
	if(is_spent())
		if(arousal > 60)
			if(!MOBTIMER_FINISHED(user, "sex_charge_msg", rand(20,40)SECONDS))
				return
			MOBTIMER_SET(user, "sex_charge_msg")
			to_chat(parent, span_warning("I've came too much recently."))
			return
		adjust_arousal(parent, -1 * ARO_LOSS_COEFFICIENT * SPENT_AROUSAL_RATE)

/datum/component/arousal/proc/is_spent()
	if(charge < CHARGE_FOR_CLIMAX)
		return TRUE
	return FALSE

/datum/component/arousal/proc/is_manhood_overstimulated()
	var/mob/living/user = parent
	if(user.has_status_effect(/datum/status_effect/edged_penis_cooldown))
		return TRUE
	return FALSE

/datum/component/arousal/proc/update_pink_screen()
	var/mob/user = parent
	var/severity = 0
	switch(arousal)
		if(1 to 20)
			severity = 1
		if(20 to 40)
			severity = 2
		if(40 to 60)
			severity = 3
		if(60 to 80)
			severity = 4
		if(80 to 100)
			severity = 5
		if(100 to 120)
			severity = 6
		if(120 to 140)
			severity = 7
		if(140 to 160)
			severity = 8
		if(160 to 180)
			severity = 9
		if(180 to INFINITY)
			severity = 10
	if(severity > 0)
		user.overlay_fullscreen("horny", /atom/movable/screen/fullscreen/love, severity)
	else
		user.clear_fullscreen("horny")

/*/datum/component/arousal/proc/update_blueballs()
	var/mob/user = parent
	if(last_arousal_increase_time + 30 SECONDS > world.time)
		return
	if(arousal >= BLUEBALLS_GAIN_THRESHOLD)
		user.add_stress(/datum/stress_event/blue_balls)
	else if(arousal <= BLUEBALLS_LOOSE_THRESHOLD)
		user.remove_stress(/datum/stress_event/blue_balls)*/

/datum/component/arousal/proc/update_erect_state()
	var/mob/user = parent
	var/obj/item/organ/genitals/penis/penis = user.getorganslot(ORGAN_SLOT_PENIS)

	if(user.mind)
		var/datum/antagonist/werewolf/W = user.mind.has_antag_datum(/datum/antagonist/werewolf/)
		if(W && W.transformed == TRUE)
			user.regenerate_icons()

	if(penis && hascall(penis, "update_erect_state"))// && !istype(penis, /obj/item/organ/genitals/penis/internal))//if(penis && hascall(penis, "update_erect_state"))
		penis.update_erect_state()


/datum/component/arousal/proc/damage_from_pain(pain_amt, giving)
	//var/mob/living/carbon/user = parent
	if(pain_amt < PAIN_MINIMUM_FOR_DAMAGE)
		return
	//var/damage = (pain_amt / PAIN_DAMAGE_DIVISOR)
	//var/obj/item/bodypart/part = user.get_bodypart(BODY_ZONE_CHEST)
	//if(!part)
	//	return
	//user.apply_damage(damage, BRUTE, part)
	update_aching(pain_amt, giving)

/datum/component/arousal/proc/try_do_moan(arousal_amt, pain_amt, applied_force, giving)
	var/mob/user = parent
	if(arousal_amt < 1.5)
		return
	if(user.stat != CONSCIOUS)
		return
	if(last_moan + MOAN_COOLDOWN >= world.time)
		return
	if(prob(50))
		return
	var/chosen_emote
	switch(arousal_amt)
		if(0 to 40)
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				chosen_emote = "sexmoanlight"
		if(40 to 75)
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				chosen_emote = "sexmoanmed"
		if(75 to INFINITY)
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				chosen_emote = "sexmoanhvy"
	if(pain_amt >= PAIN_MILD_EFFECT)
		if(!user.can_speak())
			chosen_emote = "sexmoangag"
		else
			if(prob(15))
				chosen_emote = "sexmoanhvy"
			else
				chosen_emote = "sexmoanmed"
	if(pain_amt >= PAIN_MED_EFFECT)
		if(giving)
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				if(prob(20))
					chosen_emote = "sexmoanhvy"
				else
					chosen_emote = "sexmoanmed"
		else
			if(!user.can_speak())
				chosen_emote = "sexmoangag"
			else
				if(prob(60))
					// Because males have atrocious whimper noise
					if(user.gender == FEMALE && prob(15))
						chosen_emote = "whimper"
					else
						chosen_emote = "sexmoanhvy"

	last_moan = world.time
	user.emote(chosen_emote, forced = TRUE)

/datum/component/arousal/proc/try_do_pain_effect(pain_amt, giving)
	var/mob/user = parent
	if(pain_amt < PAIN_MILD_EFFECT)
		return
	if(last_pain + PAIN_COOLDOWN >= world.time)
		return
	if(prob(50))
		return
	last_pain = world.time
	if(!user.has_flaw(/datum/charflaw/masochist))
		if(pain_amt >= PAIN_HIGH_EFFECT)
			var/pain_msg = pick(list("IT HURTS!!!", "IT NEEDS TO STOP!!!", "I CAN'T TAKE IT ANYMORE!!!"))
			to_chat(user, span_boldwarning(pain_msg))
			user.flash_fullscreen("redflash2")
			if(prob(70) && user.stat == CONSCIOUS)
				user.visible_message(span_warning("[user] shudders in pain!"))
		else if(pain_amt >= PAIN_MED_EFFECT)
			var/pain_msg = pick(list("It hurts!", "It pains me!"))
			to_chat(user, span_boldwarning(pain_msg))
			user.flash_fullscreen("redflash1")
			if(prob(40) && user.stat == CONSCIOUS)
				user.visible_message(span_warning("[user] shudders in pain!"))
		else
			var/pain_msg = pick(list("It hurts a little...", "It stings...", "I'm aching..."))
			to_chat(user, span_warning(pain_msg))
	else
		if(pain_amt >= PAIN_HIGH_EFFECT)
			var/pain_msg = pick(list("IT HURTS, DON'T STOP!!!", "DON'T STOP!!!", "MORE, MORE!!!"))
			to_chat(user, span_boldgreen(pain_msg))
			user.flash_fullscreen("redflash2")
			if(prob(70) && user.stat == CONSCIOUS)
				user.visible_message(span_warning("[user] shudders in pain!"))
		else if(pain_amt >= PAIN_MED_EFFECT)
			var/pain_msg = pick(list("It hurts!", "It pains me!"))
			to_chat(user, span_boldgreen(pain_msg))
			user.flash_fullscreen("redflash1")
			if(prob(40) && user.stat == CONSCIOUS)
				user.visible_message(span_warning("[user] shudders in pain!"))
		else
			var/pain_msg = pick(list("It hurts a little...", "It stings...", "I'm aching..."))
			to_chat(user, span_boldgreen(pain_msg))

/datum/component/arousal/proc/update_aching(pain_amt, giving)
	var/mob/user = parent
	if(pain_amt >= LOINHURT_GAIN_THRESHOLD)
		if(user.has_flaw(/datum/charflaw/masochist))
			user.sate_addiction()
			user.add_stress(/datum/stress_event/loinachegood)
			return
		if(user.has_flaw(/datum/charflaw/addiction/lovefiend))
			user.add_stress(/datum/stress_event/loinachegood)
			return
		user.add_stress(/datum/stress_event/loinache)
	else if (pain_amt <= LOINHURT_LOSE_THRESHOLD)
		user.remove_stress(/datum/stress_event/loinache)

/datum/component/arousal/proc/get_force_pleasure_multiplier(passed_force, giving)
	switch(passed_force)
		if(SEX_FORCE_LOW)
			if(giving)
				return 0.8
			else
				return 0.8
		if(SEX_FORCE_MID)
			if(giving)
				return 1.2
			else
				return 1.2
		if(SEX_FORCE_HIGH)
			if(giving)
				return 1.6
			else
				return 1.2
		if(SEX_FORCE_EXTREME)
			if(giving)
				return 2.0
			else
				return 0.8

/datum/component/arousal/proc/get_force_pain_multiplier(passed_force)
	switch(passed_force)
		if(SEX_FORCE_LOW)
			return 0.5
		if(SEX_FORCE_MID)
			return 1.0
		if(SEX_FORCE_HIGH)
			return 2.0
		if(SEX_FORCE_EXTREME)
			return 3.0

/datum/component/arousal/proc/get_speed_pain_multiplier(passed_speed)
	switch(passed_speed)
		if(SEX_SPEED_LOW)
			return 0.8
		if(SEX_SPEED_MID)
			return 1.0
		if(SEX_SPEED_HIGH)
			return 1.2
		if(SEX_SPEED_EXTREME)
			return 1.4

/datum/component/arousal/proc/get_resist_multiplier(passed_res)
	switch(passed_res)
		if(RESIST_NONE)
			return 1
		if(RESIST_LOW)
			return 0.7
		if(RESIST_MEDIUM)
			return 0.4
		if(RESIST_HIGH)
			return 0.2

/datum/component/arousal/proc/handle_statuses()
	var/mob/living/user = parent
	var/nymph_mod = 0
	if(HAS_TRAIT(user, TRAIT_NYMPHO_CURSE) || user.has_flaw(/datum/charflaw/addiction/lovefiend))
		nymph_mod = 2

	//Sorry but idk how else to do this
	if(user.has_status_effect(/datum/status_effect/debuff/loinspent))
		if(recent_orgasm_count <= LOW_ORGASM_THRESHOLD_LOSS + nymph_mod)
			user.remove_status_effect(/datum/status_effect/debuff/loinspent)
	else
		if(recent_orgasm_count >= LOW_ORGASM_THRESHOLD_GAIN + nymph_mod)
			user.apply_status_effect(/datum/status_effect/debuff/loinspent)

	if(user.has_status_effect(/datum/status_effect/debuff/cumbrained))
		if(recent_orgasm_count <= MED_ORGASM_THRESHOLD_LOSS + nymph_mod)
			user.remove_status_effect(/datum/status_effect/debuff/cumbrained)
	else
		if(recent_orgasm_count >= MED_ORGASM_THRESHOLD_GAIN + nymph_mod)
			user.apply_status_effect(/datum/status_effect/debuff/cumbrained)

	if(user.has_status_effect(/datum/status_effect/debuff/orgasmbroken))
		if(recent_orgasm_count <= HIGH_ORGASM_THRESHOLD_LOSS + nymph_mod)
			user.remove_status_effect(/datum/status_effect/debuff/orgasmbroken)
	else
		if(recent_orgasm_count >= HIGH_ORGASM_THRESHOLD_GAIN + nymph_mod)
			user.apply_status_effect(/datum/status_effect/debuff/orgasmbroken)

	if(user.has_status_effect(/datum/status_effect/debuff/nympho_addiction))
		if(recent_orgasm_count <= OVER_THE_TOP_ORGASM_THRESHOLD_LOSS + nymph_mod)
			user.remove_status_effect(/datum/status_effect/debuff/nympho_addiction)
	else
		if(recent_orgasm_count >= OVER_THE_TOP_ORGASM_THRESHOLD_GAIN + nymph_mod)
			user.apply_status_effect(/datum/status_effect/debuff/nympho_addiction)

	if(user.has_penis())
		if(user.has_status_effect(/datum/status_effect/blue_balls))
			if(edging_charge <= 15)
				user.remove_status_effect(/datum/status_effect/blue_balls)
		else
			if(edging_charge >= 20)
				user.apply_status_effect(/datum/status_effect/blue_balls)
	if(user.has_vagina())
		if(user.has_status_effect(/datum/status_effect/blue_bean))
			if(edging_charge <= 15)
				user.remove_status_effect(/datum/status_effect/blue_bean)
		else
			if(edging_charge >= 20)
				user.apply_status_effect(/datum/status_effect/blue_bean)
	if(edging_charge > 60)
		if(!MOBTIMER_FINISHED(user, "edging_overstimulation", 5 MINUTES)) //this isn't how mob timers work
			return

		MOBTIMER_SET(user, "edging_overstimulation")
		user.apply_status_effect(/datum/status_effect/edging_overstimulation)

/datum/component/arousal/proc/hole_before_insert_handle(datum/source, obj/item/item, hole_id, mob/living/inserter)
	//var/mob/living/user = parent
	if(istype(item, /obj/item/penis_fake)) //this is silly yes
		return
	adjust_arousal(source, 2)

/datum/component/arousal/proc/hole_before_remove_handle(datum/source, obj/item/item, hole_id, mob/living/inserter)
	//var/mob/living/user = parent
	if(istype(item, /obj/item/penis_fake)) //it's because of the hole system
		return
	adjust_arousal(source, 2)

/datum/component/arousal/proc/hole_after_insert_handle(datum/source, obj/item/item, hole_id, mob/living/inserter)
	//var/mob/living/user = parent
	if(istype(item, /obj/item/penis_fake)) //this is silly yes
		return
	adjust_arousal(source, 1)

/datum/component/arousal/proc/hole_after_remove_handle(datum/source, obj/item/item, hole_id, mob/living/inserter)
	//var/mob/living/user = parent
	if(istype(item, /obj/item/penis_fake)) //it's because of the hole system
		return
	adjust_arousal(source, 1)

/datum/stress_event/blue_balls
	timer = 1.5 MINUTES
	stress_change = 2
	desc = span_red("My manhood aches!")

/datum/stress_event/blue_bean
	timer = 1 MINUTES
	stress_change = 2
	desc = span_red("My loins ache!")
