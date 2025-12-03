/datum/antagonist/dreamwalker
	name = "Dreamwalker"
	roundend_category = "dreamwalker"
	antagpanel_category = "Dreamwalker"
	job_rank = ROLE_DREAMWALKER
	confess_lines = list(
		"MY VISION ABOVE ALL!",
		"I'LL TAKE YOU TO MY REALM!",
		"HIS FORM IS MAGNIFICENT!",
	)
	show_in_roundend = TRUE

	var/traits_dreamwalker = list(
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_NOMOOD,
		TRAIT_NOLIMBDISABLE,
		TRAIT_SHOCKIMMUNE,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_HEAVYARMOR,
		TRAIT_RITUALIST,
		TRAIT_DREAMWALKER,
	)

/datum/antagonist/dreamwalker/on_gain()
	SSmapping.retainer.dreamwalkers |= owner
	owner.special_role = ROLE_DREAMWALKER
	. = ..()
	reset_dreamwalker_stats()
	greet()
	return ..()

/datum/antagonist/dreamwalker/greet()
	to_chat(owner.current, span_notice("I feel a rare ability awaken within me. I can pull matter from dreams and walk between visions."))
	to_chat(owner.current, span_notice("A piece of ritual chalk manifests. It hums with dream energy."))
	owner.announce_objectives()
	..()

/datum/antagonist/dreamwalker/proc/reset_dreamwalker_stats()
	var/mob/living/carbon/human/body = owner.current
	if(!body)
		return
	for(var/trait in traits_dreamwalker)
		ADD_TRAIT(body, trait, "[type]")

	body.ambushable = FALSE
	body.AddComponent(/datum/component/dreamwalker_repair)
	body.AddComponent(/datum/component/dreamwalker_mark)

	var/obj/item/ritechalk/chalk = new()
	body.put_in_hands(chalk)

	body.change_stat(STATKEY_STR, 5)
	body.change_stat(STATKEY_INT, 2)
	body.change_stat(STATKEY_CON, 2)
	body.change_stat(STATKEY_PER, 2)
	body.change_stat(STATKEY_SPD, 2)
	body.change_stat(STATKEY_END, 2)

/datum/outfit/job/roguetown/dreamwalker_armorrite
	name = "Dreamwalker Armor Rite"
	armor = /obj/item/clothing/armor/plate/full/dreamwalker
	pants = /obj/item/clothing/pants/platelegs/dreamwalker
	shoes = /obj/item/clothing/shoes/boots/armor/dreamwalker
	gloves = /obj/item/clothing/gloves/plate/dreamwalker
	head = /obj/item/clothing/head/helmet/bascinet/dreamwalker

// Dream-crafted metal, used for the ritual weapon shaping.
/obj/item/ingot/sylveric
	name = "sylveric ingot"
	icon = 'icons/roguetown/items/ore.dmi'
	icon_state = "ingotsylveric"
	desc = "An impossibly light metal that seems to grow harder when pressured. It thrums with distant whispers."

/obj/item/ingot/sylveric/examine(mob/user)
	. = ..()
	if(HAS_TRAIT(user, TRAIT_DREAMWALKER))
		. += span_notice("The metal resonates with your dream energy. Two ingots might shape a weapon if you focus.")

// Armor set
/obj/item/clothing/armor/plate/full/dreamwalker
	name = "otherworldly fullplate"
	desc = "Strange iridescent full plate. It reflects light as if covered in oily sheen."
	icon_state = "dreamplate"
	max_integrity = ARMOR_INT_CHEST_PLATE_ANTAG
	item_flags = DREAM_ITEM
	armor = ARMOR_PLATE

/obj/item/clothing/armor/plate/full/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/pants/platelegs/dreamwalker
	max_integrity = ARMOR_INT_LEG_ANTAG
	name = "otherworldly legplate"
	desc = "Strange iridescent leg plate. It reflects light as if covered in shiny oil."
	icon_state = "dreamlegs"
	armor = ARMOR_PLATE
	item_flags = DREAM_ITEM
	prevent_crits = ALL_EXCEPT_BLUNT

/obj/item/clothing/pants/platelegs/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/shoes/boots/armor/dreamwalker
	max_integrity = ARMOR_INT_SIDE_ANTAG
	name = "otherworldly boots"
	desc = "Strange iridescent plated boots. They shimmer with liquid color."
	icon_state = "dreamboots"
	armor = ARMOR_PLATE
	item_flags = DREAM_ITEM

/obj/item/clothing/shoes/boots/armor/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/gloves/plate/dreamwalker
	name = "otherworldly gauntlets"
	desc = "Strange iridescent plated gauntlets. They flash with dreamlight."
	icon_state = "dreamgauntlets"
	max_integrity = ARMOR_INT_SIDE_ANTAG
	item_flags = DREAM_ITEM

/obj/item/clothing/gloves/plate/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

/obj/item/clothing/head/helmet/bascinet/dreamwalker
	name = "otherworldly squid helm"
	desc = "An alien-looking helm that ripples like oil."
	adjustable = CAN_CADJUST
	icon_state = "dreamsquidhelm"
	max_integrity = ARMOR_INT_HELMET_ANTAG
	item_flags = DREAM_ITEM
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/32x48/head.dmi'
	block2add = null
	worn_x_dimension = 32
	worn_y_dimension = 48
	body_parts_covered = FULL_HEAD
	flags_inv = HIDEEARS|HIDEFACE|HIDEHAIR
	flags_cover = HEADCOVERSEYES | HEADCOVERSMOUTH

/obj/item/clothing/head/helmet/bascinet/dreamwalker/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)

// Dream weapons
/obj/item/weapon/axe/dreamscape
	name = "otherworldly greataxe"
	desc = "A strange greataxe made of otherworldly metal."
	icon_state = "dreamaxe"
	item_flags = DREAM_ITEM
	max_integrity = 275
	force = 20
	force_wielded = 35
	wdefense = 6
	gripped_intents = list(/datum/intent/axe/cut,/datum/intent/axe/chop)

/obj/item/weapon/axe/dreamscape/active
	icon_state = "dreamaxeactive"
	max_integrity = 500
	force = 25
	force_wielded = 40

/obj/item/weapon/axe/dreamscape/active/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, "fire", 20 SECONDS)

/obj/item/weapon/polearm/spear/dreamscape
	name = "otherworldly spear"
	desc = "A strange spear of bone-like metal."
	icon_state = "dreamspear"
	item_flags = DREAM_ITEM
	max_integrity = 240
	force = 18
	force_wielded = 28
	wdefense = 8
	gripped_intents = list(POLEARM_THRUST, SPEAR_CUT, POLEARM_BASH)

/obj/item/weapon/polearm/spear/dreamscape/active
	icon_state = "dreamspearactive"
	max_integrity = 380
	force = 22
	force_wielded = 32
	wdefense = 9

/obj/item/weapon/polearm/spear/dreamscape/active/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, "frost", 40 SECONDS)

/obj/item/weapon/sword/long/greatsword/dreamscape
	name = "otherworldly sword"
	desc = "A strange reflective greatsword. It hums with dreamstuff."
	icon_state = "dreamsword"
	force = 22
	force_wielded = 30
	max_integrity = 275
	item_flags = DREAM_ITEM
	wdefense = 4
	possible_item_intents = list(/datum/intent/sword/cut,/datum/intent/sword/chop,/datum/intent/stab, /datum/intent/sword/strike)

/obj/item/weapon/sword/long/greatsword/dreamscape/active
	icon_state = "dreamswordactive"
	max_integrity = 480
	force = 28
	force_wielded = 34
	wdefense = 5

/obj/item/weapon/sword/long/greatsword/dreamscape/active/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, "poison", 20 SECONDS)

/obj/item/weapon/polearm/spear/dreamscape_trident
	name = "otherworldly trident"
	desc = "A strange trident. It feels like it shouldn't be effective, yet whispers promise power."
	icon_state = "dreamtri"
	item_flags = DREAM_ITEM
	max_integrity = 260
	throwforce = 40
	force = 28
	force_wielded = 22
	wdefense = 4
	minstr = 8

/obj/item/weapon/polearm/spear/dreamscape_trident/active
	name = "iridescent trident"
	desc = "A strange trident glimmering with oily hues."
	icon_state = "dreamtriactive"
	max_integrity = 480
	throwforce = 50
	force = 32
	force_wielded = 24
	wdefense = 5

/obj/item/weapon/polearm/spear/dreamscape_trident/active/Initialize()
	. = ..()
	AddComponent(/datum/component/dream_weapon, null, 20 SECONDS)
