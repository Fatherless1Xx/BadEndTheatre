/datum/sprite_accessory/underwear
	abstract_type = /datum/sprite_accessory/underwear
	icon = 'icons/roguetown/mob/underwear.dmi'
	color_key_name = "Underwear"
	use_static = FALSE
	specuse = ALL_RACES_LIST
	var/hides_breasts = FALSE

/datum/sprite_accessory/underwear/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_UNDIES)

/datum/sprite_accessory/underwear/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return TRUE

/datum/sprite_accessory/underwear/briefs
	name = "Briefs"
	icon_state = "male_reg"

/datum/sprite_accessory/underwear/briefs/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(is_species(owner, /datum/species/dwarf))
		return "maledwarf_reg"
	if(owner.gender == FEMALE)
		return "maleelf_reg"
	return "male_reg"

/datum/sprite_accessory/underwear/bikini
	name = "Bikini"
	icon_state = "female_bikini"
	hides_breasts = TRUE

/datum/sprite_accessory/underwear/panties
	name = "Panties"
	icon_state = "panties"

/datum/sprite_accessory/underwear/leotard
	name = "Leotard"
	icon_state = "female_leotard"
	hides_breasts = TRUE

/datum/sprite_accessory/underwear/leotard/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.gender == MALE)
		return "male_leotard"
	return "female_leotard"

/datum/sprite_accessory/underwear/athletic_leotard
	name = "Athletic Leotard"
	icon_state = "female_athletic_leotard"
	hides_breasts = TRUE

/datum/sprite_accessory/underwear/athletic_leotard/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.gender == MALE)
		return "male_athletic_leotard"
	return "female_athletic_leotard"

/datum/sprite_accessory/underwear/braies
	name = "Braies"
	icon_state = "braies"

/datum/sprite_accessory/underwear/braies/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	if(owner.gender == FEMALE)
		return "braies_f"
	return "braies"

/datum/sprite_accessory/underwear/big_briefs
	name = "Big briefs"
	icon_state = "under"
	icon = 'icons/mob/sprite_accessory/big_underwear.dmi'
	specuse = list(SPEC_ID_OGRE)

/datum/sprite_accessory/underwear/big_briefs/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return "under"

/datum/sprite_accessory/underwear/big_bikini
	name = "Big bikini"
	icon_state = "ogre_bra"
	icon = 'icons/mob/sprite_accessory/big_underwear.dmi'
	hides_breasts = TRUE
	specuse = list(SPEC_ID_OGRE)
