/datum/customizer/bodypart_feature/legwear
	name = "Legwear"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/legwear)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/legwear
	name = "Legwear"
	feature_type = /datum/bodypart_feature/legwear
	sprite_accessories = list(
		/datum/sprite_accessory/legwear/stockings,
		/datum/sprite_accessory/legwear/stockings/silk,
		/datum/sprite_accessory/legwear/stockings/fishnet,
		/datum/sprite_accessory/legwear/stockings/thigh,
		)

/datum/customizer/bodypart_feature/underwear
	name = "Underwear"
	customizer_choices = list(/datum/customizer_choice/bodypart_feature/underwear)
	allows_disabling = TRUE
	default_disabled = TRUE

/datum/customizer_choice/bodypart_feature/underwear
	name = "Underwear"
	feature_type = /datum/bodypart_feature/underwear
	sprite_accessories = list(
		/datum/sprite_accessory/underwear/briefs,
		/datum/sprite_accessory/underwear/bikini,
		/datum/sprite_accessory/underwear/panties,
		/datum/sprite_accessory/underwear/leotard,
		/datum/sprite_accessory/underwear/athletic_leotard,
		/datum/sprite_accessory/underwear/braies,
		/datum/sprite_accessory/underwear/big_briefs,
		/datum/sprite_accessory/underwear/big_bikini,
		)

/datum/customizer_choice/bodypart_feature/underwear/make_default_customizer_entry(datum/preferences/prefs, customizer_type, changed_entry = TRUE)
	var/datum/customizer_entry/entry = new customizer_entry_type()
	entry.customizer_type = customizer_type
	entry.customizer_choice_type = type
	var/default_type = sprite_accessories[1]
	if(istype(prefs, /datum/preferences))
		var/datum/preferences/pref_datum = prefs
		switch(pref_datum.gender)
			if(FEMALE)
				default_type = /datum/sprite_accessory/underwear/panties
			if(MALE)
				default_type = /datum/sprite_accessory/underwear/briefs
	set_accessory_type(prefs, default_type, entry)
	if(istype(prefs, /datum/preferences))
		var/datum/preferences/pref_datum = prefs
		if(pref_datum.underwear && pref_datum.underwear != "Nude")
			if(!GLOB.underwear_list.len)
				init_sprite_accessory_subtypes(/datum/sprite_accessory/underwear, GLOB.underwear_list, GLOB.underwear_m, GLOB.underwear_f)
			var/datum/sprite_accessory/underwear/saved = GLOB.underwear_list[pref_datum.underwear]
			if(istype(saved))
				set_accessory_type(pref_datum, saved.type, entry)
				if(pref_datum.underwear_color)
					set_accessory_colors(pref_datum, entry, pref_datum.underwear_color)
	return entry
