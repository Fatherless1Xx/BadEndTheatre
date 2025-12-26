/datum/customizer/organ/genitals/breasts
	abstract_type = /datum/customizer/organ/genitals/breasts
	name = "Breasts"
	allows_disabling = TRUE
	default_disabled = TRUE
	gender_enabled = FEMALE

/datum/customizer/organ/genitals/breasts/is_allowed(datum/preferences/prefs)
	return TRUE

/datum/customizer_choice/organ/genitals/breasts
	abstract_type = /datum/customizer_choice/organ/genitals/breasts
	name = "Breasts"
	customizer_entry_type = /datum/customizer_entry/organ/genitals/breasts
	organ_type = /obj/item/organ/genitals/filling_organ/breasts
	organ_slot = ORGAN_SLOT_BREASTS
	organ_dna_type = /datum/organ_dna/breasts

/datum/customizer_choice/organ/genitals/breasts/validate_entry(datum/preferences/prefs, datum/customizer_entry/entry)
	..()
	var/datum/customizer_entry/organ/genitals/breasts/breasts_entry = entry
	breasts_entry.breast_size = sanitize_integer(breasts_entry.breast_size, MIN_BREASTS_SIZE, MAX_BREASTS_SIZE, DEFAULT_BREASTS_SIZE)

/datum/customizer_choice/organ/genitals/breasts/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/breasts/breasts_dna = organ_dna
	var/datum/customizer_entry/organ/genitals/breasts/breasts_entry = entry
	breasts_dna.breast_size = breasts_entry.breast_size
	breasts_dna.lactating = breasts_entry.lactating

/datum/customizer_choice/organ/genitals/breasts/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/genitals/breasts/breasts_entry = entry
	dat += "<br>Breast size: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=breast_size''>[find_key_by_value(BREAST_SIZES_BY_NAME, breasts_entry.breast_size)]</a>"
	dat += "<br>Lactation: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=lactating''>[breasts_entry.lactating ? "Enabled" : "Disabled"]</a>"

/datum/customizer_choice/organ/genitals/breasts/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/genitals/breasts/breasts_entry = entry
	switch(href_list["customizer_task"])
		if("breast_size")
			var/named_size = browser_input_list(user, "Choose your breast size:", "Character Preference", BREAST_SIZES_BY_NAME, breasts_entry.breast_size)
			if(isnull(named_size))
				return
			var/new_size = BREAST_SIZES_BY_NAME[named_size]
			breasts_entry.breast_size = sanitize_integer(new_size, MIN_BREASTS_SIZE, MAX_BREASTS_SIZE, DEFAULT_BREASTS_SIZE)
		if("lactating")
			breasts_entry.lactating = !breasts_entry.lactating

/datum/customizer_entry/organ/genitals/breasts
	var/breast_size = DEFAULT_BREASTS_SIZE
	var/lactating = FALSE

/datum/customizer/organ/genitals/breasts/human
	customizer_choices = list(/datum/customizer_choice/organ/genitals/breasts/human)

/datum/customizer_choice/organ/genitals/breasts/human
	sprite_accessories = list(/datum/sprite_accessory/genitals/breasts/pair)
	allows_accessory_color_customization = FALSE

/datum/customizer/organ/genitals/breasts/animal
	customizer_choices = list(/datum/customizer_choice/organ/genitals/breasts/animal)

/datum/customizer_choice/organ/genitals/breasts/animal
	sprite_accessories = list(
		/datum/sprite_accessory/genitals/breasts/pair,
		/datum/sprite_accessory/genitals/breasts/quad,
		/datum/sprite_accessory/genitals/breasts/sextuple,
		)
