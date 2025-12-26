/datum/migrant_role/slaver/master
	name = "Zybantine Slaver Master"
	greet_text = "You lead a Zybantine slaver crew, here to profit through muscle and intimidation. Your band carries no captives, but plenty of ambition."
	migrant_job = /datum/job/migrant/slaver/master

/datum/job/migrant/slaver/master
	title = "Zybantine Slaver Master"
	tutorial = "You lead a Zybantine slaver crew, here to profit through muscle and intimidation. Your band carries no captives, but plenty of ambition."
	outfit = /datum/outfit/slaver/master
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL

	jobstats = list(
		STATKEY_STR = 3,
		STATKEY_SPD = 2,
		STATKEY_CON = 2,
		STATKEY_END = 2,
		STATKEY_INT = 1,
	)

	skills = list(
		/datum/skill/combat/whipsflails = 5,
		/datum/skill/combat/crossbows = 3,
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 3,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/riding = 3,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/mathematics = 3,
	)

	traits = list(TRAIT_MEDIUMARMOR)
	languages = list(/datum/language/zalad)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/outfit/slaver/master
	name = "Zybantine Slaver Master"
	shoes = /obj/item/clothing/shoes/shalal
	head = /obj/item/clothing/head/helmet/sallet/zalad
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/shalal
	armor = /obj/item/clothing/armor/medium/scale
	beltl = /obj/item/weapon/sword/sabre/shalal
	beltr = /obj/item/weapon/whip/antique
	cloak = /obj/item/clothing/cloak/raincloak/colored/purple
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	pants = /obj/item/clothing/pants/tights/colored/red
	neck = /obj/item/clothing/neck/keffiyeh/colored/red
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(
		/obj/item/storage/belt/pouch/coins/rich = 1,
		/obj/item/flashlight/flare/torch/lantern = 1,
	)

/datum/migrant_role/slaver/blade
	name = "Zybantine Blade Mercenary"
	greet_text = "A hired blade in a Zybantine slaver crew, you are here for coin and the thrill of violence."
	migrant_job = /datum/job/migrant/slaver/blade

/datum/job/migrant/slaver/blade
	title = "Zybantine Blade Mercenary"
	tutorial = "A hired blade in a Zybantine slaver crew, you are here for coin and the thrill of violence."
	outfit = /datum/outfit/slaver/blade
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = 1,
		STATKEY_END = 1,
		STATKEY_INT = 1,
	)

	skills = list(
		/datum/skill/combat/whipsflails = 3,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/swords = 4,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/riding = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/mathematics = 1,
	)

	traits = list(TRAIT_MEDIUMARMOR)
	languages = list(/datum/language/zalad)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/outfit/slaver/blade
	name = "Zybantine Blade Mercenary"
	shoes = /obj/item/clothing/shoes/shalal
	head = /obj/item/clothing/head/helmet/sallet
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/shalal
	armor = /obj/item/clothing/armor/brigandine/coatplates
	beltr = /obj/item/weapon/sword/long/rider
	beltl = /obj/item/storage/belt/pouch/coins/poor
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	pants = /obj/item/clothing/pants/tights/colored/red
	neck = /obj/item/clothing/neck/keffiyeh/colored/red
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/weapon/knife/dagger/steel = 1)

/datum/migrant_role/slaver/whip
	name = "Zybantine Whip Mercenary"
	greet_text = "A hired whip in a Zybantine slaver crew, you enforce order with steel and leather."
	migrant_job = /datum/job/migrant/slaver/whip

/datum/job/migrant/slaver/whip
	title = "Zybantine Whip Mercenary"
	tutorial = "A hired whip in a Zybantine slaver crew, you enforce order with steel and leather."
	outfit = /datum/outfit/slaver/whip
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL

	jobstats = list(
		STATKEY_STR = 2,
		STATKEY_SPD = 1,
		STATKEY_CON = 1,
		STATKEY_END = 1,
		STATKEY_INT = 1,
	)

	skills = list(
		/datum/skill/combat/whipsflails = 4,
		/datum/skill/combat/crossbows = 2,
		/datum/skill/combat/bows = 2,
		/datum/skill/combat/axesmaces = 2,
		/datum/skill/combat/swords = 3,
		/datum/skill/combat/knives = 3,
		/datum/skill/combat/wrestling = 3,
		/datum/skill/combat/unarmed = 3,
		/datum/skill/misc/swimming = 2,
		/datum/skill/misc/climbing = 2,
		/datum/skill/misc/athletics = 3,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 1,
		/datum/skill/misc/riding = 2,
		/datum/skill/craft/crafting = 1,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/mathematics = 1,
	)

	traits = list(TRAIT_MEDIUMARMOR)
	languages = list(/datum/language/zalad)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/outfit/slaver/whip
	name = "Zybantine Whip Mercenary"
	shoes = /obj/item/clothing/shoes/shalal
	head = /obj/item/clothing/head/helmet/sallet
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/shalal
	armor = /obj/item/clothing/armor/brigandine/coatplates
	beltr = /obj/item/weapon/whip
	beltl = /obj/item/weapon/knife/dagger/steel
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	pants = /obj/item/clothing/pants/tights/colored/red
	neck = /obj/item/clothing/neck/keffiyeh/colored/red
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)

/datum/migrant_role/slaver/marksman
	name = "Zybantine Crossbow Mercenary"
	greet_text = "A hired marksman in a Zybantine slaver crew, you keep distance and pick targets clean."
	migrant_job = /datum/job/migrant/slaver/marksman

/datum/job/migrant/slaver/marksman
	title = "Zybantine Crossbow Mercenary"
	tutorial = "A hired marksman in a Zybantine slaver crew, you keep distance and pick targets clean."
	outfit = /datum/outfit/slaver/marksman
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_PLAYER_ALL

	jobstats = list(
		STATKEY_PER = 3,
		STATKEY_SPD = 2,
		STATKEY_INT = 2,
		STATKEY_END = 1,
	)

	skills = list(
		/datum/skill/combat/crossbows = 4,
		/datum/skill/combat/bows = 3,
		/datum/skill/combat/knives = 4,
		/datum/skill/combat/swords = 2,
		/datum/skill/combat/whipsflails = 2,
		/datum/skill/combat/wrestling = 2,
		/datum/skill/combat/unarmed = 2,
		/datum/skill/misc/swimming = 3,
		/datum/skill/misc/climbing = 4,
		/datum/skill/misc/athletics = 4,
		/datum/skill/misc/reading = 1,
		/datum/skill/misc/medicine = 2,
		/datum/skill/misc/riding = 2,
		/datum/skill/craft/crafting = 2,
		/datum/skill/craft/cooking = 1,
		/datum/skill/labor/mathematics = 1,
	)

	languages = list(/datum/language/zalad)
	cmode_music = 'sound/music/cmode/adventurer/CombatOutlander.ogg'

/datum/outfit/slaver/marksman
	name = "Zybantine Crossbow Mercenary"
	shoes = /obj/item/clothing/shoes/shalal
	head = /obj/item/clothing/head/roguehood/colored/black
	gloves = /obj/item/clothing/gloves/angle
	belt = /obj/item/storage/belt/leather/shalal
	armor = /obj/item/clothing/armor/leather/hide
	backr = /obj/item/gun/ballistic/revolver/grenadelauncher/crossbow
	beltr = /obj/item/ammo_holder/quiver/bolts
	beltl = /obj/item/weapon/knife/dagger/steel
	shirt = /obj/item/clothing/shirt/undershirt/colored/black
	pants = /obj/item/clothing/pants/tights/colored/red
	neck = /obj/item/clothing/neck/keffiyeh/colored/red
	backl = /obj/item/storage/backpack/satchel
	backpack_contents = list(/obj/item/storage/belt/pouch/coins/poor = 1)

/datum/migrant_wave/slaver
	name = "The Zybantine Slavers"
	max_spawns = 1
	weight = 60
	downgrade_wave = /datum/migrant_wave/slaver_down_one
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/blade = 3,
		/datum/migrant_role/slaver/whip = 2,
		/datum/migrant_role/slaver/marksman = 1,
	)
	greet_text = "A Zybantine slaver crew arrives without captives, looking for coin, contracts, and control."

/datum/migrant_wave/slaver_down_one
	name = "The Zybantine Slavers"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/blade = 2,
		/datum/migrant_role/slaver/whip = 2,
		/datum/migrant_role/slaver/marksman = 1,
	)
	greet_text = "A Zybantine slaver crew arrives without captives, looking for coin, contracts, and control."

/datum/migrant_wave/slaver_down_two
	name = "The Zybantine Slavers"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/blade = 1,
		/datum/migrant_role/slaver/whip = 2,
		/datum/migrant_role/slaver/marksman = 1,
	)
	greet_text = "A Zybantine slaver crew arrives without captives, looking for coin, contracts, and control."

/datum/migrant_wave/slaver_down_three
	name = "The Zybantine Slavers"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_four
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/blade = 1,
		/datum/migrant_role/slaver/whip = 1,
		/datum/migrant_role/slaver/marksman = 1,
	)
	greet_text = "A Zybantine slaver crew arrives without captives, looking for coin, contracts, and control."

/datum/migrant_wave/slaver_down_four
	name = "The Zybantine Slavers"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_five
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/whip = 1,
		/datum/migrant_role/slaver/marksman = 1,
	)
	greet_text = "A Zybantine slaver crew arrives without captives, looking for coin, contracts, and control."

/datum/migrant_wave/slaver_down_five
	name = "The Zybantine Slavers"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_six
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/whip = 1,
	)
	greet_text = "A Zybantine slaver crew arrives without captives, looking for coin, contracts, and control."

/datum/migrant_wave/slaver_down_six
	name = "The Zybantine Slavers"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_seven
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/marksman = 1,
	)
	greet_text = "A Zybantine slaver crew arrives without captives, looking for coin, contracts, and control."

/datum/migrant_wave/slaver_down_seven
	name = "The Zybantine Slavers"
	shared_wave_type = /datum/migrant_wave/slaver
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1
	)
	greet_text = "A Zybantine slaver crew arrives without captives, looking for coin, contracts, and control."
