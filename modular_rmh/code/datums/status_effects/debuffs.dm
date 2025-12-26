// Facial status effect lives in core status_effects/neutral.dm.

/datum/status_effect/edged_penis_cooldown
	id = "tired_penis"
	alert_type = null
	duration = 7 MINUTES

/datum/status_effect/blue_bean
	id = "blue_bean"
	alert_type = null
	duration = -1

/datum/status_effect/blue_bean/on_apply()
	. = ..()
	owner.add_stress(/datum/stress_event/blue_bean)

/datum/status_effect/blue_bean/on_remove()
	. = ..()
	owner.remove_stress(/datum/stress_event/blue_bean)

/datum/status_effect/blue_balls
	id = "blue_balls"
	alert_type = null
	duration = -1

/datum/status_effect/blue_balls/on_apply()
	. = ..()
	owner.add_stress(/datum/stress_event/blue_balls)

/datum/status_effect/blue_balls/on_remove()
	. = ..()
	owner.remove_stress(/datum/stress_event/blue_balls)

/datum/status_effect/edging_overstimulation
	id = "edging_overstimulation"
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/edging_overstimulation
	effectedstats = list("strength" = -1, "speed" = -2, "intelligence" = -2)

/datum/stress_event/edging_overstimulation
	desc = "<span class='love_low'>I have been going at it for too long without release, I need relief...</span>\n"
	timer = 60 MINUTES
	stress_change = 1

/datum/status_effect/edging_overstimulation/on_apply()
	owner.add_stress(/datum/stress_event/edging_overstimulation)
	. = ..()

/datum/status_effect/edging_overstimulation/on_remove()
	owner.remove_stress(/datum/stress_event/edging_overstimulation)
	. = ..()

/atom/movable/screen/alert/status_effect/edging_overstimulation
	name = "Overstimulated"
	desc = "I have been going at it for too long without release, I need relief..."

/datum/status_effect/debuff/orgasmbroken
	id = "orgasmbroken"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/orgasmbroken
	effectedstats = list("intelligence" = -10, "strength" = -2, "speed" = -2, "perception" = -5, "endurance" = 2, "constitution" = -2)
	duration = -1

/datum/stress_event/orgasmbroken
	desc = "<span class='love_low'>My legs are shaking, but I need more.</span>\n"
	timer = 60 MINUTES
	stress_change = -5

/datum/status_effect/debuff/orgasmbroken/on_apply()
	owner.add_stress(/datum/stress_event/orgasmbroken)
	. = ..()

/datum/status_effect/debuff/orgasmbroken/on_remove()
	owner.remove_stress(/datum/stress_event/orgasmbroken)
	. = ..()

/datum/status_effect/debuff/orgasmbroken/on_apply()
	. = ..()
	owner.add_movespeed_modifier("ORGASM_SLOWDOWN", multiplicative_slowdown=4)

/datum/status_effect/debuff/orgasmbroken/on_remove()
	. = ..()
	owner.remove_movespeed_modifier("ORGASM_SLOWDOWN")

/atom/movable/screen/alert/status_effect/debuff/orgasmbroken
	name = "Orgasm Broken"
	desc = "My legs are shaking, but I need more."
	icon_state = "debuff"

/datum/status_effect/debuff/nympho_addiction
	id = "nympho_addiction"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/nympho_addiction
	//effectedstats = list("intelligence" = -20, "strength" = -8, "speed" = -6, "perception" = -5, "endurance" = 2, "constitution" = -2)
	duration = -1

/datum/stress_event/nympho_addiction
	desc = "<span class='love_low'>I want to do it again. And again. And again.</span>\n"
	timer = 60 MINUTES
	stress_change = -3

/datum/status_effect/debuff/nympho_addiction/on_apply()
	owner.add_stress(/datum/stress_event/nympho_addiction)
	. = ..()

/datum/status_effect/debuff/nympho_addiction/on_remove()
	owner.remove_stress(/datum/stress_event/nympho_addiction)
	. = ..()

/datum/status_effect/debuff/nympho_addiction/on_apply()
	. = ..()
	var/mob/living/carbon/human/human = owner
	human.charflaw = new /datum/charflaw/addiction/lovefiend(human)

/atom/movable/screen/alert/status_effect/debuff/nympho_addiction
	name = "Addicted to Sex"
	desc = "I want to do it again. And again. And again."
	icon_state = "debuff"

/datum/status_effect/debuff/cumbrained
	id = "cumbrained"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/cumbrained
	effectedstats = list("intelligence" = -10, "strength" = -6, "speed" = -6)
	duration = -1

/datum/stress_event/cumbrained
	desc = "<span class='love_low'>It's hard to think of anything but sex...</span>\n"
	timer = 60 MINUTES
	stress_change = -1

/datum/status_effect/debuff/cumbrained/on_apply()
	owner.add_stress(/datum/stress_event/cumbrained)
	. = ..()

/datum/status_effect/debuff/cumbrained/on_remove()
	owner.remove_stress(/datum/stress_event/cumbrained)
	. = ..()

/atom/movable/screen/alert/status_effect/debuff/cumbrained
	name = "Cum Brained"
	desc = "It's hard to think of anything but sex..."
	icon_state = "debuff"

/datum/status_effect/debuff/cumbrained/tick()
	. = ..()
	if(!owner)
		return

	if(!MOBTIMER_FINISHED(owner, "cumbrained_ticker", rand(30,90)SECONDS))
		return

	MOBTIMER_SET(owner, "cumbrained_ticker")

	var/list/arousal_data = list()
	SEND_SIGNAL(owner, COMSIG_SEX_GET_AROUSAL, arousal_data)

	if(arousal_data["arousal"] < 40)
		SEND_SIGNAL(owner, COMSIG_SEX_ADJUST_AROUSAL, rand(25, 35))//so it instantly fully arouses
	else
		SEND_SIGNAL(owner, COMSIG_SEX_ADJUST_AROUSAL, rand(5, 15))
	to_chat(owner, span_love("My body wants more..."))

/datum/status_effect/debuff/loinspent
	id = "loinspent"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/loinspent
	duration = -1

/datum/stress_event/loinspent
	desc = "<span class='love_low'>All this effort is starting to hurt a bit...</span>\n"
	timer = 60 MINUTES
	stress_change = 1

/datum/status_effect/debuff/loinspent/on_apply()
	owner.add_stress(/datum/stress_event/loinspent)
	. = ..()

/datum/status_effect/debuff/loinspent/on_remove()
	owner.remove_stress(/datum/stress_event/loinspent)
	. = ..()

/atom/movable/screen/alert/status_effect/debuff/loinspent
	name = "Spent Loins"
	desc = "It's starting to hurt a bit..."
	icon_state = "debuff"


/datum/status_effect/debuff/loinspent/tick()
	. = ..()
	if(!owner)
		return

	if(!MOBTIMER_FINISHED(owner, "chafing_loins", rand(20,90)SECONDS))
		return

	MOBTIMER_SET(owner, "chafing_loins")

	var/mob/living/carbon/human/human = owner
	if(human.underwear)
		if(rand(5))
			to_chat(human, span_love("I feel [human.underwear] rub against me..."))
		SEND_SIGNAL(owner, COMSIG_SEX_ADJUST_AROUSAL, rand(10,20))
	else if(human.wear_pants)
		if(human.wear_pants.flags_inv & HIDEUNDIESBOT && !human.wear_pants.genitalaccess)
			if(rand(5))
				to_chat(human, span_love("I feel [human.wear_pants] rub against me..."))
			SEND_SIGNAL(owner, COMSIG_SEX_ADJUST_AROUSAL, rand(5,10))


/datum/status_effect/debuff/bloatone
	id = "bloatone"
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/bloatone
	examine_text = span_notice("Their belly is bulging...")
	effectedstats = list("constitution" = 1, "speed" = -1)

/datum/stress_event/bloatsex
	desc = "<span class='love_low'>I have been filled to the brim...</span>\n"
	timer = 60 MINUTES
	stress_change = -1

/datum/status_effect/debuff/bloatone/on_apply()
	owner.add_stress(/datum/stress_event/bloatsex)
	. = ..()

/datum/status_effect/debuff/bloatone/on_remove()
	owner.remove_stress(/datum/stress_event/bloatsex)
	. = ..()

/atom/movable/screen/alert/status_effect/bloatone
	name = "Bloated"
	desc = "Bit full..."
	icon_state = "status"

/datum/status_effect/debuff/bloattwo
	id = "bloattwo"
	duration = 5 MINUTES
	alert_type = /atom/movable/screen/alert/status_effect/bloattwo
	examine_text = span_notice("Their belly is bulging largely...")
	effectedstats = list("constitution" = 2, "speed" = -2)

/datum/status_effect/debuff/bloattwo/on_apply()
	. = ..()
	if(owner.has_status_effect(/datum/status_effect/debuff/bloatone))
		owner.remove_status_effect(/datum/status_effect/debuff/bloatone)
	owner.add_stress(/datum/stress_event/bloatsex)

/datum/status_effect/debuff/bloattwo/on_remove()
	owner.remove_stress(/datum/stress_event/bloatsex)
	. = ..()

/atom/movable/screen/alert/status_effect/bloattwo
	name = "Bloated"
	desc = "So full..."
	icon_state = "status"

/datum/stress_event/loinache
	timer = 1 MINUTES
	stress_change = 2
	desc = span_red("My loins ache!")

/datum/stress_event/loinachegood
	timer = 5 MINUTES
	stress_change = -3
	desc = list(span_green("My loins took a GOOD beating!~"),span_green("My loins got slammed GOOD!"),span_green("My loins got beaten GOOD!"))

/datum/status_effect/debuff/bigboobs
	id = "bigboobs"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bigboobs
	examine_text = span_notice("They have massive MAGICAL GOODS!")
	effectedstats = list("constitution" = 3, "speed" = -1)
	duration = 10 MINUTES
	var/initialpenis
	var/initialbutt
	var/initialball
	var/initialbreasts
	var/nodrawback = FALSE

/datum/status_effect/debuff/bigboobs/permanent
	duration = -1 //used for quirk
/*
/datum/status_effect/debuff/bigboobs/permanent/lite
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bigboobslite
	examine_text = span_notice("They have massive GOODS!")
	nodrawback = TRUE
	effectedstats = null*/

/atom/movable/screen/alert/status_effect/debuff/bigboobs
	name = "Enchanted Endowment" //was gonna name it a curse but it isn't a technically one.
	desc = "They feel as heavy as gold and are massive... My back hurts."
	//icon = 'modular_stonehedge/licensed-eaglephntm/icons/mob/screen_alert.dmi'
	icon_state = "status"
/*
/atom/movable/screen/alert/status_effect/debuff/bigboobslite
	name = "Natural Endowment"
	desc = "I got unusually large, natural bits, they aren't as heavy as an enchanted one thankfully."
	icon = 'modular_stonehedge/licensed-eaglephntm/icons/mob/screen_alert.dmi'
	icon_state = "bigboobslite"
*/
/datum/status_effect/debuff/bigboobs/on_apply()
	. = ..()
	var/mob/living/carbon/human/species/user = owner
	if(!user)
		return
	/*if(nodrawback)
		ADD_TRAIT(user, TRAIT_ENDOWMENTLITE, id)
	else
		ADD_TRAIT(user, TRAIT_ENDOWMENT, id)*/
	to_chat(user, span_warning("Gah! my [user.gender == FEMALE ? "TITS" : "JUNK"] expand to impossible sizes!"))
	//max them out.
	for(var/obj/item/organ/genitals/forgan as anything in user.internal_organs) //as anything cause i either do this or use for() twice which is i guess worse.
		if(istype(forgan, /obj/item/organ/genitals/penis))
			initialpenis = forgan.organ_size
			forgan.organ_size = TOTAL_PENIS_SIZE
			continue
		if(istype(forgan, /obj/item/organ/genitals/filling_organ/testicles))
			initialball = forgan.organ_size
			forgan.organ_size = TOTAL_TESTICLES_SIZE
			continue
		if(istype(forgan, /obj/item/organ/genitals/filling_organ/breasts))
			initialbreasts = forgan.organ_size
			forgan.organ_size = TOTAL_BREASTS_SIZE - 2
			continue
		continue
	user.update_body_parts(TRUE)
	//drop our unwearable equipment to the floor.
	/*if(user.gender == MALE)
		var/obj/item/clothing/thepants = user.wear_pants
		if(thepants && !thepants?.can_hold_endowed)
			user.dropItemToGround(thepants)
	else
		var/obj/item/clothing/theshirt = user.wear_shirt
		var/obj/item/clothing/thearmor = user.wear_armor
		if(theshirt && !theshirt?.can_hold_endowed)
			user.dropItemToGround(theshirt)
		if(thearmor && !thearmor?.can_hold_endowed)
			user.dropItemToGround(thearmor)*/

/datum/status_effect/debuff/bigboobs/on_remove()
	. = ..()
	var/mob/living/carbon/human/species/user = owner
	if(!user)
		return
	//REMOVE_TRAIT(user, TRAIT_ENDOWMENT, id)
	to_chat(user, span_notice("Phew, My bits shrunk back to the way they were."))
	//return to pref sizes.
	for(var/obj/item/organ/genitals/forgan as anything in user.internal_organs)
		if(istype(forgan, /obj/item/organ/genitals/penis))
			forgan.organ_size = initialpenis
			continue
		if(istype(forgan, /obj/item/organ/genitals/filling_organ/testicles))
			forgan.organ_size = initialball
			continue
		if(istype(forgan, /obj/item/organ/genitals/filling_organ/breasts))
			forgan.organ_size = initialbreasts
			continue
		continue
	user.update_body_parts(TRUE)
