/datum/sprite_accessory/genitals/penis
	icon = 'icons/mob/sprite_accessory/genitals/pintle.dmi'
	color_keys = 2
	color_key_names = list("Member", "Skin")
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_FRONT_LAYER)
	abstract_type = /datum/sprite_accessory/genitals/penis

/datum/sprite_accessory/genitals/penis/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	gender_genitals_adjust(appearance_list, organ, bodypart, owner, OFFSET_PENIS)

/datum/sprite_accessory/genitals/penis/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/genitals/penis/penis = organ
	if(penis.sheath_type != SHEATH_TYPE_NONE && penis.erect_state != ERECT_STATE_HARD)
		switch(penis.sheath_type)
			if(SHEATH_TYPE_NORMAL)
				if(penis.erect_state == ERECT_STATE_NONE)
					return "sheath_1"
				else
					return "sheath_2"
			if(SHEATH_TYPE_SLIT)
				if(penis.erect_state == ERECT_STATE_NONE)
					return "slit_1"
				else
					return "slit_2"
	if(penis.erect_state == ERECT_STATE_HARD)
		return "[icon_state]_[min(3,penis.penis_size+1)]"
	else
		return "[icon_state]_[penis.penis_size]"

/datum/sprite_accessory/genitals/penis/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/human/owner)
	/*
	if(owner.underwear)
		return FALSE
	*/
	if(!genitals_can_show(owner))
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDEUNDIESBOT)

/datum/sprite_accessory/genitals/penis/human
	icon_state = "human"
	name = "Plain"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/genitals/penis/knotted
	icon_state = "knotted"
	name = "Knotted"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/genitals/penis/knotted2
	name = "Knotted 2"
	icon_state = "knotted2"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/genitals/penis/flared
	icon_state = "flared"
	name = "Flared"
	color_key_defaults = list(KEY_CHEST_COLOR, KEY_CHEST_COLOR)

/datum/sprite_accessory/genitals/penis/barbknot
	icon_state = "barbknot"
	name = "Barbed, Knotted"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/genitals/penis/tapered
	icon_state = "tapered"
	name = "Tapered"
	default_colors = list("C52828", "C52828")

/datum/sprite_accessory/genitals/penis/tapered_mammal
	icon_state = "tapered"
	name = "Tapered"
	color_key_defaults = list(null, KEY_CHEST_COLOR)
	default_colors = list("C52828", null)

/datum/sprite_accessory/genitals/penis/tentacle
	icon_state = "tentacle"
	name = "Tentacled"
	default_colors = list("C52828", "C52828")

/datum/sprite_accessory/genitals/penis/hemi
	icon_state = "hemi"
	name = "Hemi"
	default_colors = list("C52828", "C52828")

/datum/sprite_accessory/genitals/penis/hemiknot
	icon_state = "hemiknot"
	name = "Knotted Hemi"
	default_colors = list("C52828", "C52828")
