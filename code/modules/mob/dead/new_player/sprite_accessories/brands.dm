/datum/sprite_accessory/brand
	abstract_type = /datum/sprite_accessory/brand
	icon = 'icons/mob/body_markings/other_markings.dmi'
	color_key_name = "Brand"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/brand/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BACK)

/datum/sprite_accessory/brand/vampire_seal
	name = "Vampiric Seal"
	icon_state = "slave_seal"
	glows = TRUE
	default_colors = COLOR_RED

/datum/sprite_accessory/brand/indentured_womb
	name = "Baothan Womb Mark"
	icon = 'icons/roguetown/misc/baotha_marking.dmi'
	icon_state = "marking"
	glows = TRUE
	// sit below pants/stockings so clothing hides it
	layer = LEG_DAMAGE_LAYER
	relevant_layers = null

/datum/sprite_accessory/brand/indentured_womb/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	// push lower toward the groin
	for(var/mutable_appearance/appearance as anything in appearance_list)
		appearance.pixel_y -= 1
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_PANTS)

/datum/sprite_accessory/brand/indentured_womb/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/mob/living/carbon/human/H = owner
	if(istype(H) && H.gender == FEMALE)
		return "marking_f"
	return "marking_m"
