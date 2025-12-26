/obj/item/organ/genitals/filling_organ/anus
	//absorbs faster than womb, less capacity.
	name = "anus"
	//icon = 'modular_stonehedge/licensed-eaglephntm/icons/obj/surgery.dmi'
	icon_state = "severedtail"
	dropshrink = 0.5
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_ANUS
	accessory_type = /datum/sprite_accessory/none
	max_reagents = 20 //less size than vagene in turn for more effective absorbtion
	absorbing = TRUE
	absorbmult = 1.5 //more effective absorb than others i guess.
	altnames = list("ass", "asshole", "butt", "butthole", "guts") //used in thought messages.
	spiller = TRUE
	blocker = ITEM_SLOT_PANTS
	bloatable = TRUE
	additional_blocker = "underwear"

/obj/item/organ/genitals/filling_organ/anus/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(!refilling)
		reagents.clear_reagents()
	M.add_hole(ORGAN_SLOT_ANUS, /datum/component/storage/concrete/grid/hole/ass)
	SEND_SIGNAL(M, COMSIG_HOLE_MODIFY_HOLE, ORGAN_SLOT_ANUS, 3, CEILING(organ_size / 4, 1))

/obj/item/organ/genitals/filling_organ/anus/Remove(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	SEND_SIGNAL(M, COMSIG_HOLE_REMOVE_HOLE, ORGAN_SLOT_ANUS)
