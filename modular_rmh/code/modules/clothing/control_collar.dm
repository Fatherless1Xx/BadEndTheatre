GLOBAL_LIST_INIT(generated_slave_phrases, list()) //retarded dev made GLOB right here and entire fucking proc oh my goooooooooooooooood

/proc/generate_slave_code()
	var/list/syllables1 = list("ka", "zu", "lo", "da", "ra", "ve", "so", "ti", "ma", "xi", "no", "qu", "ga", "shi", "ni", "fa", "jo", "li", "pa", "re", "sa", "do", "ke", "mi")
	var/list/syllables2 = list("th", "gor", "lek", "ram", "dra", "von", "nar", "zeth", "mir", "kul", "tar", "mol", "shan", "ruk", "vek", "zun", "bel", "thrall", "grim")

	var/code
	var/tries = 0
	do
		var/code1 = "[pick(syllables1)][pick(syllables2)]"
		var/code2 = "[pick(syllables1)][pick(syllables2)]"
		while(code1 == code2)
			code2 = "[pick(syllables1)][pick(syllables2)]"
		code = "[capitalize(code1)] [capitalize(code2)]"
		tries++
	while(code in GLOB.generated_slave_phrases && tries < 100)

	GLOB.generated_slave_phrases += code
	return code


/obj/item/clothing/neck/gorget/slave_gorget
	name = "slave gorget"
	desc = "A metal gorget with ominous arcane engravings."
	icon_state = "gorget"
	item_state = "gorget"
	armor = ARMOR_NECK_BAD
	smeltresult = /obj/item/ingot/iron
	anvilrepair = /datum/skill/craft/armorsmithing
	max_integrity = 150
	resistance_flags = FIRE_PROOF
	slot_flags = ITEM_SLOT_NECK
	body_parts_covered = NECK
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	blocksound = PLATEHIT
	flags_1 = HEAR_1

	var/pleasure_phrase
	var/submission_phrase
	var/freedom_phrase
	var/collar_bound = FALSE
	COOLDOWN_DECLARE(collar_phrase_usage)

/obj/item/clothing/neck/gorget/slave_gorget/male
	name = "Cruel slave gorget"
	icon = 'modular_rmh/icons/clothing/neck.dmi'
	desc = "A brutal-looking iron gorget inscribed with cruel arcane patterns. There's no mistaking its purpose."
	icon_state = "m_collar"
	item_state = "gorget"

/obj/item/clothing/neck/gorget/slave_gorget/female
	name = "Elegant slave collar"
	icon = 'modular_rmh/icons/clothing/neck.dmi'
	desc = "An elegant black choker with faint arcane patterns along its trim. Beautiful, yet deeply symbolic."
	icon_state = "f_collar"
	item_state = "collar_f"

/obj/item/clothing/neck/gorget/slave_gorget/New()
	. = ..()
	pleasure_phrase = generate_slave_code()
	submission_phrase = generate_slave_code()
	freedom_phrase = generate_slave_code()


/obj/item/clothing/neck/gorget/slave_gorget/Initialize()
	. = ..()
	ADD_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)

/obj/item/clothing/neck/gorget/slave_gorget/equipped(mob/living/carbon/human/human)
	. = ..()
	RegisterSignal(human, COMSIG_MOVABLE_HEAR, PROC_REF(process_phrase), override = TRUE)

/obj/item/clothing/neck/gorget/slave_gorget/Destroy()
	var/mob/living/carbon/human/parent = loc
	if (ismob(parent))
		UnregisterSignal(parent, COMSIG_MOVABLE_HEAR)
	return ..()

/obj/item/clothing/neck/gorget/slave_gorget/attackby(obj/item/I, mob/living/user)
	if(!ismob(user))
		return
	if(istype(I, /obj/item/clothing/ring/slave_control))
		if(collar_bound)
			to_chat(user, "<span class='warning'>The collar is already bound.</span>")
		var/obj/item/clothing/ring/slave_control/s_r = I
		if(s_r.ring_bound)
			to_chat(user, "<span class='warning'>The ring is already bound.</span>")
		to_chat(user, "<span class='info'>You bind the ring to the collar, transferring the control words.</span>")
		user.visible_message("<span class='info'><b>[user] touches the ring and collar together, producing a dull chime.</b></span>")
		collar_bound = TRUE
		s_r.ring_bound = TRUE
		s_r.pleasure_phrase = pleasure_phrase
		s_r.submission_phrase = submission_phrase
		s_r.freedom_phrase = freedom_phrase
		return
	return ..()

/obj/item/clothing/neck/gorget/slave_gorget/proc/process_phrase(datum/source, list/hear_args)
	var/raw_message = hear_args[HEARING_RAW_MESSAGE]
	var/atom/movable/speaker = hear_args[HEARING_SPEAKER]

	if (!ismob(speaker))
		return

	var/mob/living/carbon/human/H = src.loc
	if (!ismob(H))
		return

	var/msg = normalize_slave_phrase(raw_message)
	if(!(msg == normalize_slave_phrase(src.pleasure_phrase) || msg == normalize_slave_phrase(src.submission_phrase) || msg == normalize_slave_phrase(src.freedom_phrase)))
		return

	if(!COOLDOWN_FINISHED(src, collar_phrase_usage))
		return
	COOLDOWN_START(src, collar_phrase_usage, 20 SECONDS)

	if(H == speaker)
		H.visible_message("<span class='warning'><b>The collar around [H]'s neck flashes brightly, muting the wearer in punishment.</b></span>")

		ADD_TRAIT(H, TRAIT_MUTE, "rune")
		addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(remove_mute), H), 30 SECONDS) //shameless copypaste
		return


	if (msg == normalize_slave_phrase(src.pleasure_phrase))
		H.visible_message("<span class='danger'><b>[H] shivers, pleasure foced on them!</b></span>")
		H.emote("moan")
		SEND_SIGNAL(H, COMSIG_SEX_ADJUST_AROUSAL, 80)
		SEND_SIGNAL(H, COMSIG_SEX_ADJUST_EDGING, 30)
		return

	if (msg == normalize_slave_phrase(src.submission_phrase))
		H.visible_message("<span class='warning'><b>[H] is shocked, collar tightening!</b></span>")
		H.electrocute_act(5, src)
		H.emote("choke")
		if(H.oxyloss > 65)
			return
		H.adjustOxyLoss(35)
		return

	if (msg == normalize_slave_phrase(src.freedom_phrase))
		H.visible_message("<span class='notice'><b>The collar around [H]'s neck falls off.</b></span>")

		/*if(H.wear_neck == src)
			H.wear_neck = null*/
		//src.doMove(get_turf(user))
		REMOVE_TRAIT(src, TRAIT_NODROP, CURSED_ITEM_TRAIT)
		H.dropItemToGround(src, force = TRUE, silent = TRUE)

		return

/proc/normalize_slave_phrase(text)
	text = lowertext(strip_html(text))
	text = strip_punctuation(text)
	text = trim(text)
	return text


/datum/anvil_recipe/slavecollar
	name = "Slave gorget"
	recipe_name = "a slave collar"
	req_bar = /obj/item/ingot/iron
	additional_items = list(/obj/item/gem/red, /obj/item/gem/blue, /obj/item/gem/diamond)
	created_item = /obj/item/clothing/neck/gorget/slave_gorget
	craftdiff = 3
	i_type = "Valuables"

/datum/anvil_recipe/slavecollar/cruel
	name = "Cruel slave gorget"
	recipe_name = "a cruel slave collar"
	created_item = /obj/item/clothing/neck/gorget/slave_gorget/male
	craftdiff = 4

/datum/anvil_recipe/slavecollar/elegant
	name = "Elegant slave collar"
	recipe_name = "an elegant slave collar"
	created_item = /obj/item/clothing/neck/gorget/slave_gorget/female
	additional_items = list(/obj/item/natural/hide/cured, /obj/item/gem/red, /obj/item/gem/blue, /obj/item/gem/diamond)
	craftdiff = 4

