/datum/organ_dna/penis
	organ_type = /obj/item/organ/genitals/penis
	var/penis_size = DEFAULT_PENIS_SIZE
	var/functional = TRUE

/datum/organ_dna/penis/imprint_organ(obj/item/organ/organ, datum/species/species)
	..()
	var/obj/item/organ/genitals/penis/penis_organ = organ
	penis_organ.organ_size = penis_size
	penis_organ.functional = functional

/datum/organ_dna/testicles
	organ_type = /obj/item/organ/genitals/filling_organ/testicles
	var/ball_size = DEFAULT_TESTICLES_SIZE
	var/virility = TRUE

/datum/organ_dna/testicles/imprint_organ(obj/item/organ/organ, datum/species/species)
	..()
	var/obj/item/organ/genitals/filling_organ/testicles/testicles_organ = organ
	testicles_organ.organ_size = ball_size
	testicles_organ.virility = virility

/datum/organ_dna/breasts
	organ_type = /obj/item/organ/genitals/filling_organ/breasts
	var/breast_size = DEFAULT_BREASTS_SIZE
	var/lactating = FALSE

/datum/organ_dna/breasts/imprint_organ(obj/item/organ/organ, datum/species/species)
	..()
	var/obj/item/organ/genitals/filling_organ/breasts/breasts_organ = organ
	breasts_organ.organ_size = breast_size
	breasts_organ.refilling = lactating
	breasts_organ.max_reagents = max(75, breasts_organ.organ_size * 100)

/datum/organ_dna/vagina
	organ_type = /obj/item/organ/genitals/filling_organ/vagina
	var/fertility = TRUE

/datum/organ_dna/vagina/imprint_organ(obj/item/organ/organ, datum/species/species)
	..()
	var/obj/item/organ/genitals/filling_organ/vagina/vagina_organ = organ
	vagina_organ.fertility = fertility
