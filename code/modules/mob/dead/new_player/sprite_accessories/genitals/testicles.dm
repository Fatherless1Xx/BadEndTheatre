/datum/sprite_accessory/genitals/testicles
	icon = 'icons/mob/sprite_accessory/genitals/gonads.dmi'
	color_key_name = "Sack"
	relevant_layers = list(BODY_BEHIND_LAYER, BODY_ADJ_LAYER)
	abstract_type = /datum/sprite_accessory/genitals/testicles

/datum/sprite_accessory/genitals/testicles/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/obj/item/organ/genitals/filling_organ/testicles/testes = organ
	var/fuck = "[icon_state]_[testes.organ_size]"
	return fuck

/datum/sprite_accessory/genitals/testicles/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	gender_genitals_adjust(appearance_list, organ, bodypart, owner, OFFSET_TESTICLES)

/datum/sprite_accessory/testicles/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	/*
	if(owner.underwear)
		return FALSE
	*/
	if(!genitals_can_show(owner))
		return FALSE
	var/obj/item/organ/genitals/penis/penis = owner.getorganslot(ORGAN_SLOT_PENIS)
	if(penis && penis.sheath_type == SHEATH_TYPE_SLIT)
		return FALSE
	return is_human_part_visible(owner, HIDEJUMPSUIT|HIDEUNDIESBOT)

/datum/sprite_accessory/genitals/testicles/pair
	name = "Pair"
	icon_state = "pair"
	color_key_defaults = list(KEY_SKIN_COLOR)
