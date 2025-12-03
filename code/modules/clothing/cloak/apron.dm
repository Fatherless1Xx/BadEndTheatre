
/obj/item/clothing/cloak/apron
	name = "apron"
	desc = ""
	color = null
	icon_state = "apron"
	item_state = "apron"
	alternate_worn_layer = TABARD_LAYER
	body_parts_covered = CHEST|GROIN
	boobed = TRUE
	salvage_result = /obj/item/natural/cloth

/obj/item/clothing/cloak/apron/brown
	color = CLOTHING_BARK_BROWN
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/cloak/apron/waist
	name = "apron"
	desc = ""
	color = null
	icon_state = "waistpron"
	item_state = "waistpron"
	body_parts_covered = GROIN
	boobed = FALSE

/obj/item/clothing/cloak/apron/waist/colored
	misc_flags = CRAFTING_TEST_EXCLUDE

/obj/item/clothing/cloak/apron/waist/colored/brown
	color = CLOTHING_BARK_BROWN

/obj/item/clothing/cloak/apron/waist/colored/bar
	color = "#251f1d"

/obj/item/clothing/cloak/apron/cook
	name = "cook apron"
	desc = "An apron covering the frontal part of the body. Apart of protection from spills, won't prevent you from getting cut in half."
	color = null
	icon_state = "aproncook"
	item_state = "aproncook"
	body_parts_covered = GROIN
	boobed = FALSE

/obj/item/clothing/cloak/apron/ogre
	name = "gigantic apron"
	desc = "An absurdly oversized apron. Most humanoids can't wear this."
	icon = 'icons/roguetown/ogre/clothing/cloaks.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x64/ogre_onmob.dmi'
	icon_state = "cookapron"
	item_state = "cookapron"
	allowed_race = list(SPEC_ID_OGRE)
