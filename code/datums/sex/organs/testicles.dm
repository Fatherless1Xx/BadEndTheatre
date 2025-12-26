/obj/item/organ/genitals/filling_organ/testicles
	name = "testicles"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_TESTICLES
	accessory_type = /datum/sprite_accessory/genitals/testicles/pair
	altnames = list("balls", "testicles", "testes", "orbs", "cum tanks", "seed tanks") //used in thought messages.
	organ_size = DEFAULT_TESTICLES_SIZE
	var/virility = TRUE
	reagent_to_make = /datum/reagent/consumable/cum
	reagent_generate_rate = 6
	storage_per_size = 200 //more size since they have so little size selections.
	startsfilled = TRUE
	blocker = ITEM_SLOT_PANTS
	organ_sizeable  = TRUE
	refilling = TRUE

/obj/item/organ/genitals/filling_organ/testicles/internal
	name = "internal testicles"
	visible_organ = FALSE
	accessory_type = /datum/sprite_accessory/none

/obj/item/organ/genitals/filling_organ/testicles/Insert(mob/living/carbon/M, special, drop_if_replaced)
	. = ..()
	if(iscarbon(M))
		if(M.cum)
			reagent_to_make = M.cum
		if(!virility)
			reagent_to_make = /datum/reagent/consumable/cum/sterile
			reagents.clear_reagents()
			reagents.add_reagent(reagent_to_make, reagents.maximum_volume)
