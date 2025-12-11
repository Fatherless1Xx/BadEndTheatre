/datum/action/cooldown/spell/status/seelie_dust
	name = "Seelie Dust"
	desc = "Douse a target in sparkling dust that alters their senses."
	button_icon_state = "createlight"
	cooldown_time = 150 SECONDS
	cast_range = 7
	invocation_type = INVOCATION_NONE
	sound = 'sound/magic/churn.ogg'
	status_effect = /datum/status_effect/buff/seelie_drugs
	has_visual_effects = FALSE

/datum/action/cooldown/spell/seelie_call_beast
	name = "Call Beast"
	desc = "Summon a rat to scamper to your aid."
	button_icon_state = "tamebeast"
	charge_required = FALSE
	cooldown_time = 2 MINUTES
	cast_range = 7
	invocation_type = INVOCATION_NONE
	sound = 'sound/magic/churn.ogg'
	has_visual_effects = FALSE

/datum/action/cooldown/spell/seelie_call_beast/is_valid_target(atom/cast_on)
	return isturf(cast_on) || isliving(cast_on)

/datum/action/cooldown/spell/seelie_call_beast/cast(atom/cast_on)
	. = ..()
	var/turf/T = isturf(cast_on) ? cast_on : get_turf(cast_on)
	if(!T)
		return
	if(prob(1))
		new /mob/living/simple_animal/hostile/retaliate/bigrat(T)
	else
		new /obj/item/reagent_containers/food/snacks/smallrat(T)

/datum/action/cooldown/spell/seelie_strip
	name = "Strip Clothes"
	desc = "Tug loose a random worn item."
	button_icon_state = "bcry"
	charge_required = FALSE
	cooldown_time = 6 MINUTES
	cast_range = 1
	invocation_type = INVOCATION_NONE
	sound = 'sound/magic/churn.ogg'
	has_visual_effects = FALSE

/datum/action/cooldown/spell/seelie_strip/is_valid_target(atom/cast_on)
	return ishuman(cast_on)

/datum/action/cooldown/spell/seelie_strip/cast(mob/living/carbon/human/cast_on)
	. = ..()
	if(!cast_on)
		return
	var/list/slots = list(ITEM_SLOT_GLOVES, ITEM_SLOT_SHOES, ITEM_SLOT_HEAD)
	var/chosen_slot = pick(slots)
	var/obj/item/choice = cast_on.get_item_by_slot(chosen_slot)
	if(choice && !istype(choice, /obj/item/clothing/head/helmet))
		cast_on.dropItemToGround(choice)
		to_chat(cast_on, span_warning("My clothes are yanked loose!"))

/datum/action/cooldown/spell/seelie_drain
	name = "Drain"
	desc = "Borrow stamina from a nearby target."
	button_icon_state = "bloodsteal"
	charge_required = FALSE
	cooldown_time = 3 MINUTES
	cast_range = 1
	invocation_type = INVOCATION_NONE
	sound = 'sound/magic/churn.ogg'
	spell_type = SPELL_STAMINA
	has_visual_effects = FALSE

/datum/action/cooldown/spell/seelie_drain/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/seelie_drain/cast(mob/living/cast_on)
	. = ..()
	if(!owner || !isliving(owner))
		return
	var/mob/living/target = cast_on
	var/mob/living/caster = owner

	var/drain_amount = 100
	var/gain_amount = 60

	if(target.stamina <= 0)
		to_chat(caster, span_warning("[target] is too exhausted to drain from!"))
		return

	if(caster.stamina >= caster.maximum_stamina - gain_amount)
		to_chat(caster, span_warning("I don't feel any more invigorated than I did..."))
		target.adjust_stamina(drain_amount)
		return

	target.adjust_stamina(drain_amount)
	caster.adjust_stamina(-gain_amount)
	to_chat(target, span_warning("I suddenly feel burdened and fatigued!"))
	to_chat(caster, span_warning("I reinvigorate myself with [target]'s energy!"))

/datum/action/cooldown/spell/seelie_replenish
	name = "Replenish Nature"
	desc = "Encourage an empty bush to bear fruit again."
	button_icon_state = "blesscrop"
	charge_required = FALSE
	cooldown_time = 3 MINUTES
	cast_range = 1
	invocation_type = INVOCATION_NONE
	sound = 'sound/magic/churn.ogg'
	has_visual_effects = FALSE

/datum/action/cooldown/spell/seelie_replenish/is_valid_target(atom/cast_on)
	return istype(cast_on, /obj/structure/flora/grass/bush)

/datum/action/cooldown/spell/seelie_replenish/cast(obj/structure/flora/grass/bush/cast_on)
	. = ..()
	if(!cast_on)
		return
	var/old_len = cast_on.looty?.len || 0
	cast_on.looty = list() // clear to force a fresh roll
	cast_on.loot_replenish()
	var/new_len = cast_on.looty?.len || 0
	if(new_len > old_len)
		to_chat(owner, span_notice("The bush swells with new growth."))
	else
		to_chat(owner, span_warning("Nature resists my touch; nothing changes."))

/datum/action/cooldown/spell/projectile/water_bolt
	name = "Water Bolt"
	desc = "Launch a small bolt of water that splashes on impact, dousing flames and lightly soaking targets."
	button_icon_state = "frostbolt"
	sound = 'sound/magic/churn.ogg'
	projectile_type = /obj/projectile/magic/waterbolt

	point_cost = 1
	charge_time = 1.5 SECONDS
	charge_drain = 1
	cooldown_time = 15 SECONDS
	spell_cost = 20
	spell_flags = SPELL_RITUOS

/datum/action/cooldown/spell/projectile/water_bolt/cast(atom/cast_on)
	. = ..()
	owner.visible_message(span_notice("[owner] flicks a splash of water toward [cast_on]!"), span_notice("I flick a splash of water toward [cast_on]!"))

/datum/action/cooldown/spell/projectile/water_bolt/ready_projectile(obj/projectile/to_fire, atom/target, mob/user, iteration)
	. = ..()
	to_fire.damage *= attuned_strength

/obj/projectile/magic/waterbolt
	name = "water bolt"
	icon = 'icons/obj/projectiles.dmi'
	icon_state = "arcane_barrage" // existing projectile state for visibility
	damage = 10
	damage_type = BRUTE
	range = 10
	speed = 1
	nodamage = FALSE

/obj/projectile/magic/waterbolt/on_hit(atom/target, blocked = FALSE, pierce_hit)
	. = ..()
	var/turf/T = get_turf(target)
	if(T)
		var/datum/reagents/R = new
		R.add_reagent(/datum/reagent/water, 20)
		chem_splash(T, 1, list(R))
	if(isliving(target))
		var/mob/living/L = target
		L.ExtinguishMob(TRUE)
	return .

/datum/status_effect/buff/seelie_luck_good
	id = "seelie_luck_good"
	alert_type = /atom/movable/screen/alert/status_effect/buff/seelie_luck_good
	duration = 6 SECONDS

/atom/movable/screen/alert/status_effect/buff/seelie_luck_good
	name = "Blessing of Luck"
	desc = span_nicegreen("Fortune smiles upon me.")
	icon_state = "great_meal"

/datum/status_effect/debuff/seelie_luck_bad
	id = "seelie_luck_bad"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/seelie_luck_bad
	duration = 6 SECONDS

/atom/movable/screen/alert/status_effect/debuff/seelie_luck_bad
	name = "Blight of Misery"
	desc = span_warning("Misfortune clings to me.")
	icon_state = "great_meal"

/datum/action/cooldown/spell/seelie_kiss
	name = "Fae Kiss"
	desc = "A gentle kiss that soothes wounds and stanches bleeding over time."
	button_icon_state = "bless"
	charge_required = FALSE
	cooldown_time = 40 SECONDS
	cast_range = 1
	invocation_type = INVOCATION_NONE
	sound = 'sound/magic/heal.ogg'
	has_visual_effects = FALSE

/datum/action/cooldown/spell/seelie_kiss/is_valid_target(atom/cast_on)
	return isliving(cast_on)

/datum/action/cooldown/spell/seelie_kiss/cast(mob/living/cast_on)
	. = ..()
	if(!cast_on)
		return
	var/mob/living/target = cast_on
	to_chat(target, span_notice("A soft, fae kiss settles on my skin, easing my pain."))
	target.visible_message(span_notice("[owner] gives [target] a gentle, glowing kiss."), span_notice("I give [target] a gentle, glowing kiss."))
	target.adjustBruteLoss(-8)
	target.adjustFireLoss(-4)
	target.bleed_rate = max(target.bleed_rate - 2, 0)
	target.suppress_bloodloss(50) // brief suppression of bleeding
	// Apply a short regen over time
	addtimer(CALLBACK(target, /mob/living/proc/adjustBruteLoss, -6), 5 SECONDS)
	addtimer(CALLBACK(target, /mob/living/proc/adjustFireLoss, -2), 5 SECONDS)
