/datum/customizer/organ/genitals/vagina
	abstract_type = /datum/customizer/organ/genitals/vagina
	name = "Vagina"
	allows_disabling = TRUE
	default_disabled = TRUE
	gender_enabled = FEMALE
	abstract_type = /datum/customizer/organ/genitals/vagina

/datum/customizer/organ/genitals/vagina/is_allowed(datum/preferences/prefs)
	return TRUE

/datum/customizer_choice/organ/genitals/vagina
	abstract_type = /datum/customizer_choice/organ/genitals/vagina
	name = "Vagina"
	customizer_entry_type = /datum/customizer_entry/organ/genitals/vagina
	organ_type = /obj/item/organ/genitals/filling_organ/vagina
	organ_slot = ORGAN_SLOT_VAGINA
	organ_dna_type = /datum/organ_dna/vagina

/datum/customizer_entry/organ/genitals/vagina
	var/fertility = TRUE

/datum/customizer_choice/organ/genitals/vagina/generate_pref_choices(list/dat, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/genitals/vagina/vagina_entry = entry
	dat += "<br>Fertile: <a href='?_src_=prefs;task=change_customizer;customizer=[customizer_type];customizer_task=fertile''>[vagina_entry.fertility ? "Fertile" : "Sterile"]</a>"

/datum/customizer_choice/organ/genitals/vagina/imprint_organ_dna(datum/organ_dna/organ_dna, datum/customizer_entry/entry, datum/preferences/prefs)
	..()
	var/datum/organ_dna/vagina/vagina_dna = organ_dna
	var/datum/customizer_entry/organ/genitals/vagina/vagina_entry = entry
	vagina_dna.fertility = vagina_entry.fertility

/datum/customizer_choice/organ/genitals/vagina/handle_topic(mob/user, list/href_list, datum/preferences/prefs, datum/customizer_entry/entry, customizer_type)
	..()
	var/datum/customizer_entry/organ/genitals/vagina/vagina_entry = entry
	switch(href_list["customizer_task"])
		if("fertile")
			vagina_entry.fertility = !vagina_entry.fertility


/datum/customizer/organ/genitals/vagina/human
	customizer_choices = list(/datum/customizer_choice/organ/genitals/vagina/human)

/datum/customizer_choice/organ/genitals/vagina/human
	sprite_accessories = list(
		/datum/sprite_accessory/genitals/vagina/human,
		/datum/sprite_accessory/genitals/vagina/gaping,
		/datum/sprite_accessory/genitals/vagina/hairy,
		/datum/sprite_accessory/genitals/vagina/trimmed,
		)
	allows_accessory_color_customization = FALSE

/datum/customizer/organ/genitals/vagina/human_anthro
	customizer_choices = list(/datum/customizer_choice/organ/genitals/vagina/human_anthro)

/datum/customizer_choice/organ/genitals/vagina/human_anthro
	sprite_accessories = list(
		/datum/sprite_accessory/genitals/vagina/human,
		/datum/sprite_accessory/genitals/vagina/gaping,
		/datum/sprite_accessory/genitals/vagina/hairy,
		/datum/sprite_accessory/genitals/vagina/trimmed,
		)
	allows_accessory_color_customization = TRUE

/datum/customizer/organ/genitals/vagina/animal
	customizer_choices = list(/datum/customizer_choice/organ/genitals/vagina/animal)

/datum/customizer_choice/organ/genitals/vagina/animal
	sprite_accessories = list(
		/datum/sprite_accessory/genitals/vagina/human,
		/datum/sprite_accessory/genitals/vagina/gaping,
		/datum/sprite_accessory/genitals/vagina/hairy,
		/datum/sprite_accessory/genitals/vagina/trimmed,
		/datum/sprite_accessory/genitals/vagina/spade,
		/datum/sprite_accessory/genitals/vagina/furred,
		)

/datum/customizer/organ/genitals/vagina/anthro
	customizer_choices = list(/datum/customizer_choice/organ/genitals/vagina/anthro)

/datum/customizer_choice/organ/genitals/vagina/anthro
	sprite_accessories = list(
		/datum/sprite_accessory/genitals/vagina/human,
		/datum/sprite_accessory/genitals/vagina/gaping,
		/datum/sprite_accessory/genitals/vagina/hairy,
		/datum/sprite_accessory/genitals/vagina/trimmed,
		/datum/sprite_accessory/genitals/vagina/spade,
		/datum/sprite_accessory/genitals/vagina/furred,
		/datum/sprite_accessory/genitals/vagina/cloaca,
		)
