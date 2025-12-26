/datum/sprite_accessory/genitals/vagina
	icon = 'icons/mob/sprite_accessory/genitals/nethers.dmi'
	color_key_name = "Nethers"
	relevant_layers = list(BODY_FRONT_LAYER)

/datum/sprite_accessory/genitals/vagina/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	gender_genitals_adjust(appearance_list, organ, bodypart, owner, OFFSET_VAGINA)

/datum/sprite_accessory/genitals/vagina/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	/*
	if(owner.underwear)
		return FALSE
	*/
	if(!genitals_can_show(owner))
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDEUNDIESBOT)

/datum/sprite_accessory/genitals/vagina/human
	icon_state = "human"
	name = "Plain"
	default_colors = list("ea6767")

/datum/sprite_accessory/genitals/vagina/hairy
	icon_state = "hairy"
	name = "Hairy"
	color_key_defaults = list(KEY_HAIR_COLOR)

/datum/sprite_accessory/genitals/vagina/trimmed
	icon_state = "trimmed"
	name = "Trimmed"
	color_key_defaults = list(KEY_HAIR_COLOR)

/datum/sprite_accessory/genitals/vagina/spade
	icon_state = "spade"
	name = "Spade"
	default_colors = list("C52828")

/datum/sprite_accessory/genitals/vagina/furred
	icon_state = "furred"
	name = "Furred"
	color_key_defaults = list(KEY_MUT_COLOR_ONE)

/datum/sprite_accessory/genitals/vagina/gaping
	icon_state = "gaping"
	name = "Gaping"
	default_colors = list("f99696")

/datum/sprite_accessory/genitals/vagina/cloaca
	icon_state = "cloaca"
	name = "Cloaca"
	default_colors = list("f99696")
