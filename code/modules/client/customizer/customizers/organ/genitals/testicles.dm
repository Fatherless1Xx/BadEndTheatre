/datum/customizer/organ/genitals/testicles
	name = "Testicles"
	abstract_type = /datum/customizer/organ/genitals/testicles

/datum/customizer_choice/organ/genitals/testicles
	abstract_type = /datum/customizer_choice/organ/genitals/testicles

/datum/customizer/organ/genitals/testicles
	abstract_type = /datum/customizer/organ/genitals/testicles
	name = "Testicles"
	allows_disabling = TRUE
	default_disabled = TRUE
	gender_enabled = MALE

/datum/customizer/organ/genitals/testicles/is_allowed(datum/preferences/prefs)
	return TRUE

/datum/customizer_choice/organ/genitals/testicles
	abstract_type = /datum/customizer_choice/organ/genitals/testicles
	name = "Testicles"
	organ_type = /obj/item/organ/genitals/filling_organ/testicles
	customizer_entry_type = /datum/customizer_entry/organ/genitals/testicles
	organ_slot = ORGAN_SLOT_TESTICLES
	organ_dna_type = /datum/organ_dna/testicles
	var/can_customize_size = TRUE

/datum/customizer_choice/organ/genitals/testicles/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/genitals/testicles/testicles_entry = entry
	testicles_entry.ball_size = sanitize_integer(testicles_entry.ball_size, MIN_TESTICLES_SIZE, MAX_TESTICLES_SIZE, DEFAULT_TESTICLES_SIZE)

/datum/customizer_choice/organ/genitals/testicles/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/testicles/testicles_dna = organ_dna
	var/datum/customizer_entry/organ/genitals/testicles/testicles_entry = entry
	if(can_customize_size)
		testicles_dna.ball_size = testicles_entry.ball_size
	testicles_dna.virility = testicles_entry.virility

/datum/customizer_choice/organ/genitals/testicles/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/genitals/testicles/testicles_entry = entry
	if(can_customize_size)
		dat += "<br>Ball size: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=ball_size''>[find_key_by_value(TESTICLE_SIZES_BY_NAME, testicles_entry.ball_size)]</a>"
	dat += "<br>Virile: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=virile''>[testicles_entry.virility ? "Virile" : "Sterile"]</a>"

/datum/customizer_choice/organ/genitals/testicles/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/genitals/testicles/testicles_entry = entry
	switch(href_list["customizer_task"])
		if("ball_size")
			var/named_size = browser_input_list(user, "Choose your ball size:", "Character Preference", TESTICLE_SIZES_BY_NAME, testicles_entry.ball_size)
			if(isnull(named_size))
				return
			var/new_size = TESTICLE_SIZES_BY_NAME[named_size]
			testicles_entry.ball_size = sanitize_integer(new_size, MIN_TESTICLES_SIZE, MAX_TESTICLES_SIZE, DEFAULT_TESTICLES_SIZE)
		if("virile")
			testicles_entry.virility = !testicles_entry.virility

/datum/customizer/organ/genitals/testicles/external
	customizer_choices = list(/datum/customizer_choice/organ/genitals/testicles/external)

/datum/customizer/organ/genitals/testicles/human
	customizer_choices = list(/datum/customizer_choice/organ/genitals/testicles/human)

/datum/customizer/organ/genitals/testicles/internal
	customizer_choices = list(/datum/customizer_choice/organ/genitals/testicles/internal)

/datum/customizer/organ/genitals/testicles/anthro
	customizer_choices = list(
		/datum/customizer_choice/organ/genitals/testicles/external,
		/datum/customizer_choice/organ/genitals/testicles/internal,
	)

/datum/customizer_choice/organ/genitals/testicles/external
	name = "Testicles"
	sprite_accessories = list(/datum/sprite_accessory/genitals/testicles/pair)

/datum/customizer_choice/organ/genitals/testicles/human
	name = "Testicles"
	sprite_accessories = list(/datum/sprite_accessory/genitals/testicles/pair)
	allows_accessory_color_customization = FALSE

/datum/customizer_choice/organ/genitals/testicles/internal
	name = "Internal testicles"
	organ_type = /obj/item/organ/genitals/filling_organ/testicles/internal
	sprite_accessories = null
	can_customize_size = FALSE

/datum/customizer_entry/organ/genitals/testicles
	var/ball_size = DEFAULT_TESTICLES_SIZE
	var/virility = TRUE
