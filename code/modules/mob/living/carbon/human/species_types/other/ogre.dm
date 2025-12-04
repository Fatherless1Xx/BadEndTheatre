/mob/living/carbon/human/species/ogre
	race = /datum/species/ogre

/datum/species/ogre
	name = "Ogre"
	id = SPEC_ID_OGRE
	native_language = "Orcish"
	desc = "Graggar's greatest creation, the ogres are favored precisely because they cannot grasp justice or morality and act on every impulse. Massive in appetite and size, they are titans of the battlefield who smash all opposition and seize what they want. Born on the windswept steppes of Gronn, they roam the world as conquerors, too simple to question their patron's will and too stubborn to change."

	skin_tone_wording = "Region"
	species_traits = list(EYECOLOR, HAIR, FACEHAIR, LIPS, STUBBLE, OLDGREY)
	inherent_traits = list(TRAIT_NOMOBSWAP)
	default_features = MANDATORY_FEATURE_LIST
	allowed_pronouns = PRONOUNS_LIST
	use_skintones = TRUE
	swap_female_clothes = TRUE
	possible_ages = ALL_AGES_LIST
	changesource_flags = WABBAJACK

	limbs_icon_m = 'icons/roguetown/mob/bodies/m/ogre.dmi'
	limbs_icon_f = 'icons/roguetown/mob/bodies/f/ogre.dmi'
	dam_icon_m = 'icons/roguetown/mob/bodies/dam/ogre.dmi'
	dam_icon_f = 'icons/roguetown/mob/bodies/dam/ogre.dmi'

	soundpack_m = /datum/voicepack/male/warrior
	soundpack_f = /datum/voicepack/female/dwarf

	offset_features_m = list(
		OFFSET_RING = list(0,1),\
		OFFSET_GLOVES = list(0,0),\
		OFFSET_WRISTS = list(0,1),\
		OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),\
		OFFSET_FACEMASK = list(0,6),\
		OFFSET_HEAD = list(0,0),\
		OFFSET_FACE = list(0,6),\
		OFFSET_BELT = list(0,1),\
		OFFSET_BACK = list(0,1),\
		OFFSET_NECK = list(0,1),\
		OFFSET_MOUTH = list(0,1),\
		OFFSET_PANTS = list(0,0),\
		OFFSET_SHIRT = list(0,1),\
		OFFSET_ARMOR = list(0,1),\
		OFFSET_UNDIES = list(0,1),\
	)

	offset_features_f = list(
		OFFSET_RING = list(0,1),\
		OFFSET_GLOVES = list(0,1),\
		OFFSET_WRISTS = list(0,1),\
		OFFSET_HANDS = list(0,1),\
		OFFSET_CLOAK = list(0,1),\
		OFFSET_FACEMASK = list(0,6),\
		OFFSET_HEAD = list(0,1),\
		OFFSET_FACE = list(0,6),\
		OFFSET_BELT = list(0,1),\
		OFFSET_BACK = list(0,1),\
		OFFSET_NECK = list(0,1),\
		OFFSET_MOUTH = list(0,1),\
		OFFSET_PANTS = list(0,1),\
		OFFSET_SHIRT = list(0,1),\
		OFFSET_ARMOR = list(0,1),\
		OFFSET_UNDIES = list(0,8),\
	)

	specstats_m = list(STATKEY_STR = 3, STATKEY_PER = 0, STATKEY_INT = -3, STATKEY_CON = 3, STATKEY_END = 1, STATKEY_SPD = -1, STATKEY_LCK = 0)
	specstats_f = list(STATKEY_STR = 3, STATKEY_PER = 0, STATKEY_INT = -3, STATKEY_CON = 3, STATKEY_END = 1, STATKEY_SPD = -1, STATKEY_LCK = 0)

	pain_mod = 0.5 // 50% less pain from wounds - THIS IS BECAUSE THEY ARE ANTAG ONLY. DO NOT MAKE OGRES NON-ANTAG WITHOUT CHANGING THIS BACK
	bleed_mod = 0.5 // 50% less bleed rate from injuries

	enflamed_icon = "widefire"

	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
		ORGAN_SLOT_GUTS = /obj/item/organ/guts,
	)

	bodypart_features = list(
		/datum/bodypart_feature/hair/head,
		/datum/bodypart_feature/hair/facial,
	)

	customizers = list(
		/datum/customizer/organ/eyes/humanoid,
		/datum/customizer/bodypart_feature/hair/head/humanoid,
		/datum/customizer/bodypart_feature/hair/facial/humanoid,
		/datum/customizer/bodypart_feature/accessory,
		/datum/customizer/bodypart_feature/face_detail,
		/datum/customizer/bodypart_feature/legwear,
		/datum/customizer/organ/genitals/penis/human,
		/datum/customizer/organ/genitals/vagina/human,
		/datum/customizer/organ/genitals/breasts/human,
		/datum/customizer/organ/genitals/testicles/human,
	)

	descriptor_choices = list(
		/datum/descriptor_choice/height,
		/datum/descriptor_choice/body,
		/datum/descriptor_choice/stature,
		/datum/descriptor_choice/face,
		/datum/descriptor_choice/face_exp,
		/datum/descriptor_choice/skin,
		/datum/descriptor_choice/voice,
	)

/datum/species/ogre/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	C.grant_language(/datum/language/common)
	C.grant_language(/datum/language/orcish)

/datum/species/ogre/after_creation(mob/living/carbon/C)
	. = ..()
	C.grant_language(/datum/language/orcish)
	to_chat(C, span_info("I can speak Orcish with ,o before my speech."))

/datum/species/ogre/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	C.remove_language(/datum/language/orcish)

/datum/species/ogre/qualifies_for_rank(rank, list/features)
	return TRUE

/datum/species/ogre/check_roundstart_eligible()
	return TRUE

/datum/species/ogre/get_skin_list()
	return sortList(list(
		"Icecap" = SKIN_COLOR_ICECAP,
		"Arctic" = SKIN_COLOR_ARCTIC,
		"Tundra" = SKIN_COLOR_TUNDRA,
		"Continental" = SKIN_COLOR_CONTINENTAL,
		"Temperate" = SKIN_COLOR_TEMPERATE,
		"Coastal" = SKIN_COLOR_COASTAL,
		"Subtropical" = SKIN_COLOR_SUBTROPICAL,
		"Tropical Dry" = SKIN_COLOR_TROPICALDRY,
		"Tropical Wet" = SKIN_COLOR_TROPICALWET,
		"Desert" = SKIN_COLOR_DESERT,
		"Oasis" = SKIN_COLOR_OASIS,
		"Crimsonlands" = SKIN_COLOR_CRIMSONLANDS,
		"Volcanic" = SKIN_COLOR_VOLCANIC,
		"Island" = SKIN_COLOR_ISLAND,
		"Swamp" = SKIN_COLOR_SWAMP,
		"Taiga" = SKIN_COLOR_TAIGA,
		"Shellcrest" = SKIN_COLOR_SHELLCREST,
		"Bloodaxe" = SKIN_COLOR_BLOOD_AXE,
		"Splitjaw" = SKIN_COLOR_GROONN,
		"Blackhammer" = SKIN_COLOR_BLACK_HAMMER,
		"Skullseeker" = SKIN_COLOR_SKULL_SEEKER,
		"Crescent Fang" = SKIN_COLOR_CRESCENT_FANG,
		"Murkwalker" = SKIN_COLOR_MURKWALKER,
		"Shatterhorn" = SKIN_COLOR_SHATTERHORN,
		"Spiritcrusher" = SKIN_COLOR_SPIRITCRUSHER
	))

/datum/species/ogre/get_hairc_list()
	return sortList(list(
	"Minotaur" = "58433b",
	"Volf" = "48322a",
	"Maneater" = "458745",
	"Mud" = "201616",
	))

/datum/species/ogre/random_name(gender, unique, lastname)
	var/randname
	if(unique)
		if(gender == MALE)
			for(var/i in 1 to 10)
				randname = pick(world.file2list("strings/rt/names/other/halforcm.txt"))
				if(!findname(randname))
					break
		if(gender == FEMALE)
			for(var/i in 1 to 10)
				randname = pick(world.file2list("strings/rt/names/other/halforcf.txt"))
				if(!findname(randname))
					break
	else
		if(gender == MALE)
			randname = pick(world.file2list("strings/rt/names/other/halforcm.txt"))
		if(gender == FEMALE)
			randname = pick(world.file2list("strings/rt/names/other/halforcf.txt"))
	return randname

/datum/species/ogre/random_surname()
	return
