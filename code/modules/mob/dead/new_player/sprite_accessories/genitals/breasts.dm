/datum/sprite_accessory/genitals/breasts
	icon = 'icons/mob/sprite_accessory/genitals/breasts.dmi'
	color_key_name = "Breasts"
	relevant_layers = list(BODY_ADJ_LAYER)

/datum/sprite_accessory/genitals/breasts/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/genitals/breasts/breasts = organ
	return "[icon_state]_[breasts.breast_size]"

/datum/sprite_accessory/genitals/breasts/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/human/owner)
	gender_genitals_adjust(appearance_list, organ, bodypart, owner, OFFSET_BREASTS)

/datum/sprite_accessory/genitals/breasts/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/human/owner)
	/*
	if(owner.underwear && owner.underwear.covers_breasts)
		return FALSE
	*/

	if(!genitals_can_show(owner))
		return FALSE
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)

/datum/sprite_accessory/genitals/breasts/pair
	icon_state = "pair"
	name = "Pair"
	color_key_defaults = list(KEY_CHEST_COLOR)

/datum/sprite_accessory/genitals/breasts/quad
	icon_state = "quad"
	name = "Quad"
	color_key_defaults = list(KEY_CHEST_COLOR)

/datum/sprite_accessory/genitals/breasts/sextuple
	icon_state = "sextuple"
	name = "Sextuple"
	color_key_defaults = list(KEY_CHEST_COLOR)
