/obj/item/organ/genitals
    abstract_type = /obj/item/organ/genitals
    var/organ_size = 1

/obj/item/organ/genitals/is_visible_on_owner()
	if(!ishuman(owner))
		return ..()
	var/mob/living/carbon/human/H = owner
	if(!genitals_can_show(H))
		return FALSE
	if(!get_location_accessible(H, zone, skipundies = TRUE))
		return FALSE
	return TRUE
