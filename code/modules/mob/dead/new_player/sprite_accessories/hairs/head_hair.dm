
//////////////////////
// Hair Definitions //
//////////////////////
/datum/sprite_accessory/hair/head
	icon = 'icons/roguetown/mob/hair.dmi'	  // default icon for all hairs
	dynamic_file = 'icons/roguetown/mob/hair_extensions.dmi'
	var/static/list/extensions

	// please make sure they're sorted alphabetically and, where needed, categorized
	// try to capitalize the names please~
	// try to spell
	// you do not need to define _s or _l sub-states, game automatically does this for you

	// each race gets four unique haircuts
	// dwarf - miner, gnomish, boss, hearth
	// elf - son, fancy, mysterious, long
	// human - adventurer, dark knight, graceful, squire, pigtails, noblesse
	// dual - nomadic, shrine
	// aasimar - amazon, topknot, martial, forsaken
	// tiefling - junia, performer, tribal, lover


/// Gets the appearance of the sprite accessory as a mutable appearance for an organ on a bodypart.
/datum/sprite_accessory/hair/head/get_icon_state(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/dynamic_hair_suffix = ""

	var/mob/living/carbon/H = bodypart.owner
	if(!H)
		H = bodypart.original_owner

	if(H.head)
		var/obj/item/I = H.head
		if(isclothing(I))
			var/obj/item/clothing/C = I
			dynamic_hair_suffix = C.dynamic_hair_suffix

	if(H.wear_mask)
		var/obj/item/I = H.wear_mask
		if(!dynamic_hair_suffix && isclothing(I)) //head > mask in terms of head hair
			var/obj/item/clothing/C = I
			dynamic_hair_suffix = C.dynamic_hair_suffix

	if(H.wear_neck)
		var/obj/item/I = H.wear_neck
		if(!dynamic_hair_suffix && isclothing(I)) //head > mask in terms of head hair
			var/obj/item/clothing/C = I
			dynamic_hair_suffix = C.dynamic_hair_suffix

	if(!extensions)
		var/icon/hair_extensions = icon('icons/roguetown/mob/hair_extensions.dmi') //hehe
		extensions = list()
		for(var/s in hair_extensions.IconStates(1))
			extensions[s] = TRUE
		qdel(hair_extensions)

	if(extensions[icon_state+dynamic_hair_suffix])
		return "[icon_state][dynamic_hair_suffix]"

	return icon_state


/datum/sprite_accessory/hair/head/get_icon(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	var/dynamic_hair_suffix = ""

	var/mob/living/carbon/H = bodypart.owner
	if(!H)
		H = bodypart.original_owner

	if(H.head)
		var/obj/item/I = H.head
		if(isclothing(I))
			var/obj/item/clothing/C = I
			dynamic_hair_suffix = C.dynamic_hair_suffix

	if(H.wear_mask)
		var/obj/item/I = H.wear_mask
		if(!dynamic_hair_suffix && isclothing(I)) //head > mask in terms of head hair
			var/obj/item/clothing/C = I
			dynamic_hair_suffix = C.dynamic_hair_suffix

	if(H.wear_neck)
		var/obj/item/I = H.wear_neck
		if(!dynamic_hair_suffix && isclothing(I)) //head > mask in terms of head hair
			var/obj/item/clothing/C = I
			dynamic_hair_suffix = C.dynamic_hair_suffix

	if(!extensions)
		var/icon/hair_extensions = icon('icons/roguetown/mob/hair_extensions.dmi') //hehe
		extensions = list()
		for(var/s in hair_extensions.IconStates(1))
			extensions[s] = TRUE
		qdel(hair_extensions)

	if(extensions[icon_state+dynamic_hair_suffix])
		return dynamic_file

	return icon

/datum/sprite_accessory/hair/head/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEHAIR)

/datum/sprite_accessory/hair/head/bald
	name = "Bald"
	icon_state = ""

/datum/sprite_accessory/hair/head/adventurer_human
	name = "Adventurer"
	icon_state = "adventurer"

/datum/sprite_accessory/hair/head/berserker
	name = "Berserker"
	icon_state = "berserker"
	under_layer = TRUE

/datum/sprite_accessory/hair/head/bog
	name = "Bog"
	icon_state = "bog"

/datum/sprite_accessory/hair/head/boss_dwarf
	name = "Boss"
	icon_state = "boss" // original name bodicker
	under_layer = TRUE

/datum/sprite_accessory/hair/head/bowlcut
	name = "Bowlcut"
	icon_state = "bowlcut"

/datum/sprite_accessory/hair/head/brother
	name = "Brother"
	icon_state = "brother"

/datum/sprite_accessory/hair/head/cavehead
	name = "Cavehead"
	icon_state = "cavehead" // original name thinning?
	under_layer = TRUE

/datum/sprite_accessory/hair/head/conscript
	name = "Conscript"
	icon_state = "conscript"
	under_layer = TRUE

/datum/sprite_accessory/hair/head/courtier
	name = "Courtier"
	icon_state = "courtier"

/datum/sprite_accessory/hair/head/dark_knight
	name = "Dark Knight"
	icon_state = "darkknight"

/datum/sprite_accessory/hair/head/dave
	name = "Dave"
	icon_state = "dave"

/datum/sprite_accessory/hair/head/dome
	name = "Dome"
	icon_state = "dome"
	under_layer = TRUE

/datum/sprite_accessory/hair/head/dunes
	name = "Dunes"
	icon_state = "dunes"


/datum/sprite_accessory/hair/head/druid
	name = "Druid"
	icon_state = "druid"  // original name elf_scout?

/datum/sprite_accessory/hair/head/fancy_elf
	name = "Fancy"
	icon_state = "fancy_elf"

/datum/sprite_accessory/hair/head/forester
	name = "Forester"
	icon_state = "forester"

/datum/sprite_accessory/hair/head/foreigner_tief
	name = "Foreigner"
	icon_state = "foreigner"

/datum/sprite_accessory/hair/head/forsaken_aas
	name = "Forsaken"
	icon_state = "forsaken"
	under_layer = TRUE

/datum/sprite_accessory/hair/head/forged
	name = "Forged"
	icon_state = "forged"
	under_layer = TRUE

/datum/sprite_accessory/hair/head/graceful
	name = "Graceful"
	icon_state = "graceful"

/datum/sprite_accessory/hair/head/heroic
	name = "Heroic"
	icon_state = "heroic"

/datum/sprite_accessory/hair/head/hunter
	name = "Hunter"
	icon_state = "hunter"

/datum/sprite_accessory/hair/head/landlord
	name = "Landlord"
	icon_state = "landlord"

/datum/sprite_accessory/hair/head/lover_tief
	name = "Lover"
	icon_state = "lover_tief_m"

/datum/sprite_accessory/hair/head/lion
	name = "Lions mane"
	icon_state = "lion"

/datum/sprite_accessory/hair/head/monk
	name = "Monk"
	icon_state = "monk"

/datum/sprite_accessory/hair/head/majestic_human
	name = "Majesty"
	icon_state = "majestic"

/datum/sprite_accessory/hair/head/merc
	name = "Mercenary"
	icon_state = "mercenary"

/datum/sprite_accessory/hair/head/miner_dwarf
	name = "Miner"
	icon_state = "miner"

/datum/sprite_accessory/hair/head/nobility_human
	name = "Nobility"
	icon_state = "nobility"

/datum/sprite_accessory/hair/head/nomadic_humtief
	name = "Nomadic"
	icon_state = "nomadic"

/datum/sprite_accessory/hair/head/pirate
	name = "Pirate"
	icon_state = "pirate"
	under_layer = TRUE

/datum/sprite_accessory/hair/head/princely
	name = "Princely"
	icon_state = "princely"

/datum/sprite_accessory/hair/head/rogue
	name = "Rogue"
	icon_state = "rogue"

/datum/sprite_accessory/hair/head/romantic
	name = "Romantic"
	icon_state = "romantic"

/datum/sprite_accessory/hair/head/scribe
	name = "Scribe"
	icon_state = "scribe"
	under_layer = TRUE

/datum/sprite_accessory/hair/head/southern_human
	name = "Southern"
	icon_state = "southern"

/datum/sprite_accessory/hair/head/son
	name = "Son"
	icon_state = "sun"

/datum/sprite_accessory/hair/head/son_elf
	name = "Sonne"
	icon_state = "son_elf"

/datum/sprite_accessory/hair/head/squire_human
	name = "Squired"
	icon_state = "squire" // original name shaved_european

/datum/sprite_accessory/hair/head/swain
	name = "Swain"
	icon_state = "swain"

/datum/sprite_accessory/hair/head/top_aas
	name = "Topknot"
	icon_state = "topknot"

/datum/sprite_accessory/hair/head/troubadour
	name = "Troubadour"
	icon_state = "troubadour"

/datum/sprite_accessory/hair/head/tied
	name = "Tied"
	icon_state = "tied"

/datum/sprite_accessory/hair/head/tied_long
	name = "Tied long"
	icon_state = "tiedlong"

/datum/sprite_accessory/hair/head/tied_sidecut
	name = "Tied sidecut"
	icon_state = "tsidecut"

/datum/sprite_accessory/hair/head/trimmed
	name = "Trimmed"
	icon_state = "trimmed"

/datum/sprite_accessory/hair/head/warrior
	name = "Warrior"
	icon_state = "warrior"

/datum/sprite_accessory/hair/head/wildside
	name = "Wild Sidecut"
	icon_state = "wildside"

/datum/sprite_accessory/hair/head/woodsman_elf
	name = "Woodsman"
	icon_state = "woodsman_elf"

/datum/sprite_accessory/hair/head/zaladin
	name = "Zaladin"
	icon_state = "zaladin" // orginal name gelled

/datum/sprite_accessory/hair/head/vagabond
	name = "Vagabond"
	icon_state = "vagabond"

/datum/sprite_accessory/hair/head/sandcrop
	name = "Sand Crop"
	icon_state = "sandcrop"


/datum/sprite_accessory/hair/head/steward
	name = "Steward"
	icon_state = "steward"

/////////////////////////////
// GIRLY Hair Definitions  //
/////////////////////////////

/datum/sprite_accessory/hair/head/amazon
	name = "Amazon"
	icon_state = "amazon_f"

/datum/sprite_accessory/hair/head/archivist
	name = "Archivist"
	icon_state = "archivist_f" // original name bob_scully

/datum/sprite_accessory/hair/head/barbarian
	name = "Barbarian"
	icon_state = "barbarian_f"

/datum/sprite_accessory/hair/head/beartails
	name = "Beartails"
	icon_state = "beartails_f" // modified cotton
	under_layer = TRUE

/datum/sprite_accessory/hair/head/buns
	name = "Buns"
	icon_state = "buns_f" // original name twinbuns

/datum/sprite_accessory/hair/head/lowbun
	name = "Bun (Low)"
	icon_state = "bun-low"

/datum/sprite_accessory/hair/head/bob
	name = "Bob"
	icon_state = "bob_f"

/datum/sprite_accessory/hair/head/curlyshort
	name = "Curly Short"
	icon_state = "curly_f"

/datum/sprite_accessory/hair/head/conscriptf
	name = "Conscript"
	icon_state = "conscript_f"

/datum/sprite_accessory/hair/head/emma
	name = "Emma"
	icon_state = "emma"

/datum/sprite_accessory/hair/head/empress
	name = "Empress"
	icon_state = "empress_f"

/datum/sprite_accessory/hair/head/fancy_femelf
	name = "Fancy"
	icon_state = "fancy_elf_f"

/datum/sprite_accessory/hair/head/felfhair_fatherless
	name = "Fatherless"
	icon_state = "fatherless_elf_f"

/datum/sprite_accessory/hair/head/grumpy_f
	name = "Grumpy"
	icon_state = "grumpy_f"

/datum/sprite_accessory/hair/head/gnomish_f
	name = "Gnomish"
	icon_state = "gnomish_f" // original name bun_grandma

/datum/sprite_accessory/hair/head/hearth_f
	name = "Hearth"
	icon_state = "hearth_f" // original name ponytail_fox

/datum/sprite_accessory/hair/head/homely
	name = "Homely"
	icon_state = "homely_f"

/datum/sprite_accessory/hair/head/junia
	name = "Junia"
	icon_state = "junia_tief_f" // modified hime_updo

/datum/sprite_accessory/hair/head/lady
	name = "Lady"
	icon_state = "lady_f" // original name newyou

/datum/sprite_accessory/hair/head/loosebraid
	name = "Loose Braid"
	icon_state = "loosebraid_f"

/datum/sprite_accessory/hair/head/maiden
	name = "Maiden"
	icon_state = "maiden_f"

/datum/sprite_accessory/hair/head/majestic_dwarf_F
	name = "Majestiq"
	icon_state = "majestic_dwarf"

/datum/sprite_accessory/hair/head/majestic_f
	name = "Majestic"
	icon_state = "majestic_f"

/datum/sprite_accessory/hair/head/messy
	name = "Messy"
	icon_state = "messy_f"

/datum/sprite_accessory/hair/head/mysterious_elf
	name = "Mysterious"
	icon_state = "mysterious_elf" // modified hime_long

/datum/sprite_accessory/hair/head/mystery
	name = "Mystery"
	icon_state = "mystery_f" // modified hime_long

/datum/sprite_accessory/hair/head/noblesse
	name = "Noblesse"
	icon_state = "noblesse_f" // modified sidetail

/datum/sprite_accessory/hair/head/orc
	name = "Orc"
	icon_state = "orc_f" // modified african_pigtails

/datum/sprite_accessory/hair/head/performer
	name = "Performer"
	icon_state = "performer_tief_f" // modified drillruru_long

/datum/sprite_accessory/hair/head/pix
	name = "Pixie"
	icon_state = "pixie_f"

/datum/sprite_accessory/hair/head/pigtails
	name = "Pigtails"
	icon_state = "pigtails"

/datum/sprite_accessory/hair/head/plain
	name = "Plain"
	icon_state = "plain_f"

/datum/sprite_accessory/hair/head/ponytail
	name = "Ponytail"
	icon_state = "ponytail"

/datum/sprite_accessory/hair/head/ponytail8
	name = "Ponytail 8"
	icon_state = "ponytail8"

/datum/sprite_accessory/hair/head/puffdouble
	name = "Puff Double"
	icon_state = "puffdouble"

/datum/sprite_accessory/hair/head/puffleft
	name = "Puff Left"
	icon_state = "puffleft"

/datum/sprite_accessory/hair/head/puffright
	name = "Puff Right"
	icon_state = "puffright"

/datum/sprite_accessory/hair/head/queen
	name = "Queenly"
	icon_state = "queenly_f"

/datum/sprite_accessory/hair/head/sideways_ponytail
	name = "Sideways Ponytail"
	icon_state = "sideways_ponytail"

/datum/sprite_accessory/hair/head/shrine
	name = "Shrinekeeper"
	icon_state = "shrine_f"

/datum/sprite_accessory/hair/head/soilbride
	name = "Soilbride"
	icon_state = "soilbride_f"

/datum/sprite_accessory/hair/head/squire_f
	name = "Squire"
	icon_state = "squire_f" // original name ponytail_rynn

/datum/sprite_accessory/hair/head/tails
	name = "Tails"
	icon_state = "tails_f"

/datum/sprite_accessory/hair/head/tied_pony
	name = "Tied Ponytail"
	icon_state = "tied_f"

/datum/sprite_accessory/hair/head/tiedup
	name = "Tied Up"
	icon_state = "tiedup_f"

/datum/sprite_accessory/hair/head/tiedcutf
	name = "Tied Sidecut"
	icon_state = "tsidecut_f"

/datum/sprite_accessory/hair/head/tomboy1
	name = "Tomboy 1"
	icon_state = "tomboy_f"

/datum/sprite_accessory/hair/head/tomboy2
	name = "Tomboy 2"
	icon_state = "tomboy2_f"

/datum/sprite_accessory/hair/head/tomboy3
	name = "Tomboy 3"
	icon_state = "rogue_f"

/datum/sprite_accessory/hair/head/twintail_floor
	name = "Twintail Floor"
	icon_state = "twintail_floor"

/datum/sprite_accessory/hair/head/updo
	name = "Updo"
	icon_state = "updo_f"

/datum/sprite_accessory/hair/head/wildcutf
	name = "Wild Sidecut"
	icon_state = "wildside_f"

/datum/sprite_accessory/hair/head/wisp
	name = "Wisp"
	icon_state = "wisp_f"

/datum/sprite_accessory/hair/head/singlebraid
	name = "Single Braid"
	icon_state = "singlebraid"

/datum/sprite_accessory/hair/head/shorthime
	name = "Hime Cut (Short)"
	icon_state = "shorthime"

/datum/sprite_accessory/hair/head/spicy
	name = "Spicy"
	icon_state = "spicy"

/datum/sprite_accessory/hair/head/stacy
	name = "Stacy"
	icon_state = "stacy"

/datum/sprite_accessory/hair/head/stacybun
	name = "Stacy (Bun)"
	icon_state = "stacy_bun"

/datum/sprite_accessory/hair/head/zoey
	name = "Zoey"
	icon_state = "zoey"

/datum/sprite_accessory/hair/head/mediumbraid
	name = "Medium Braid"
	icon_state = "mediumbraid"

/datum/sprite_accessory/hair/head/lakkaricut
	name = "Lakkari Cut"
	icon_state = "lakkaricut"

/datum/sprite_accessory/hair/head/lakkaribun
	name = "Lakkari Bun"
	icon_state = "lakkaribun"

//////////////////////////////
// UNISEX Hair Definitions  //
//////////////////////////////
/datum/sprite_accessory/hair/head/alchemist
	name = "Alchemist"
	icon_state = "alchemist"

/datum/sprite_accessory/hair/head/martial
	name = "Martial"
	icon_state = "martial"

/datum/sprite_accessory/hair/head/shaved
	name = "Shaved"
	icon_state = "shaved"
	under_layer = TRUE

/datum/sprite_accessory/hair/head/runt
	name = "Runt"
	icon_state = "runt"

/datum/sprite_accessory/hair/head/majestic_elf
	name = "Majestie"
	icon_state = "majestic_elf"

// Hairs below ported from Azure

/datum/sprite_accessory/hair/head/gloomy
	name = "Gloomy"
	icon_state = "gloomy"

/datum/sprite_accessory/hair/head/gloomylong
	name = "Gloomy (Long)"
	icon_state = "gloomylong"

/datum/sprite_accessory/hair/head/shortmessy
	name = "Messy (Short)"
	icon_state = "shortmessy"

/datum/sprite_accessory/hair/head/mediumessy
	name = "Messy (Medium)"
	icon_state = "mediummessy"

/datum/sprite_accessory/hair/head/inari
	name = "Inari"
	icon_state = "inari"

/datum/sprite_accessory/hair/head/ziegler
	name = "Ziegler"
	icon_state = "ziegler"

/datum/sprite_accessory/hair/head/gronnbraid
	name = "Gronn Braid"
	icon_state = "zone"

/datum/sprite_accessory/hair/head/grenzelcut
	name = "Grenzel Cut"
	icon_state = "grenzelcut"

/datum/sprite_accessory/hair/head/fluffy
	name = "Fluffy"
	icon_state = "fluffy"

/datum/sprite_accessory/hair/head/fluffyshort
	name = "Fluffy (Short)"
	icon_state = "fluffyshort"

/datum/sprite_accessory/hair/head/fluffylong
	name = "Fluffy (Long)"
	icon_state = "fluffylong"

/datum/sprite_accessory/hair/head/jay
	name = "Jay"
	icon_state = "jay"

/datum/sprite_accessory/hair/head/hairfre
	name = "Hairfre"
	icon_state = "hairfre"

/datum/sprite_accessory/hair/head/dawn
	name = "Dawn"
	icon_state = "dawn"

/datum/sprite_accessory/hair/head/morning
	name = "Morning"
	icon_state = "morning"

/datum/sprite_accessory/hair/head/kobeni_1
	name = "Kobeni"
	icon_state = "kobeni_1"

/datum/sprite_accessory/hair/head/kobeni_2
	name = "Kobeni (Alt)"
	icon_state = "kobeni_2"

/datum/sprite_accessory/hair/head/gloomy_short
	name = "Gloomy (Short)"
	icon_state = "gloomy_short"

/datum/sprite_accessory/hair/head/gloomy_medium
	name = "Gloomy (Medium)"
	icon_state = "gloomy_medium"

/datum/sprite_accessory/hair/head/gloomy_long
	name = "Gloomy (Long)"
	icon_state = "gloomy_long"

/datum/sprite_accessory/hair/head/emo_long
	name = "Emo Long (New)"
	icon_state = "emo_long"

/datum/sprite_accessory/hair/head/dreadlocks_long
	name = "Dreadlocks Long"
	icon_state = "dreadlocks_long"

/datum/sprite_accessory/hair/head/rows1
	name = "Row 1"
	icon_state = "rows1"

/datum/sprite_accessory/hair/head/rows2
	name = "Row 2"
	icon_state = "rows2"

/datum/sprite_accessory/hair/head/rowbraid
	name = "Row Braid"
	icon_state = "rowbraid"

/datum/sprite_accessory/hair/head/rowdualtail
	name = "Row Dual Tail"
	icon_state = "rowdualtail"

/datum/sprite_accessory/hair/head/rowbun
	name = "Row Bun"
	icon_state = "rowbun"

/datum/sprite_accessory/hair/head/long_over_eye_alt
	name = "Long Over Eye (Alt)"
	icon_state = "long_over_eye_alt"

/datum/sprite_accessory/hair/head/sabitsuki
	name = "Sabitsuki"
	icon_state = "sabitsuki"

/datum/sprite_accessory/hair/head/cotton
	name = "Cotton"
	icon_state = "cotton"

/datum/sprite_accessory/hair/head/cottonalt
	name = "Cotton (Alt)"
	icon_state = "cottonalt"

/datum/sprite_accessory/hair/head/bushy
	name = "Bushy"
	icon_state = "bushy"

/datum/sprite_accessory/hair/head/bushy_alt
	name = "Bushy (Alt)"
	icon_state = "bushy_alt"

/datum/sprite_accessory/hair/head/curtains
	name = "Curtains"
	icon_state = "curtains"

/datum/sprite_accessory/hair/head/glamourh
	name = "Glamourh"
	icon_state = "glamourh"

/datum/sprite_accessory/hair/head/wavylong
	name = "Wavy Long"
	icon_state = "wavylong"

/datum/sprite_accessory/hair/head/straightshort
	name = "Straight Short"
	icon_state = "straightshort"

/datum/sprite_accessory/hair/head/straightlong
	name = "Straight Long"
	icon_state = "straightlong"

/datum/sprite_accessory/hair/head/fluffball
	name = "Fluffball"
	icon_state = "fluffball"

/datum/sprite_accessory/hair/head/halfshave_long
	name = "Halfshave Long"
	icon_state = "halfshave_long"

/datum/sprite_accessory/hair/head/halfshave_long_alt
	name = "Halfshave Long (Alt)"
	icon_state = "halfshave_long_alt"

/datum/sprite_accessory/hair/head/halfshave_messy
	name = "Halfshave Messy"
	icon_state = "halfshave_messy"

/datum/sprite_accessory/hair/head/halfshave_messylong
	name = "Halfshave Messy Long"
	icon_state = "halfshave_messylong"

/datum/sprite_accessory/hair/head/halfshave_messy_alt
	name = "Halfshave Messy (Alt)"
	icon_state = "halfshave_messy_alt"

/datum/sprite_accessory/hair/head/halfshave_messylong_alt
	name = "Halfshave Messy Long (Alt)"
	icon_state = "halfshave_messylong_alt"

/datum/sprite_accessory/hair/head/halfshave_glamorous
	name = "Halfshave Glamorous"
	icon_state = "halfshave_glamorous"

/datum/sprite_accessory/hair/head/halfshave_glamorous_alt
	name = "Halfshave Glamorous (Alt)"
	icon_state = "halfshave_glamorous_alt"

/datum/sprite_accessory/hair/head/thicklong
	name = "Thick Long"
	icon_state = "thicklong"

/datum/sprite_accessory/hair/head/thickshort
	name = "Thick Short"
	icon_state = "thickshort"

/datum/sprite_accessory/hair/head/thickcurly
	name = "Thick Curly"
	icon_state = "thickcurly"

/datum/sprite_accessory/hair/head/baum
	name = "Baum"
	icon_state = "baum"

/datum/sprite_accessory/hair/head/highlander
	name = "Highlander"
	icon_state = "highlander"

/datum/sprite_accessory/hair/head/royalcurls
	name = "Royal Curls"
	icon_state = "royalcurls"

/datum/sprite_accessory/hair/head/dreadlocksmessy
	name = "Dreadlocks Messy"
	icon_state = "dreadlong"

/datum/sprite_accessory/hair/head/suave
	name = "Suave"
	icon_state = "suave"

/datum/sprite_accessory/hair/head/ponytailwitcher
	name = "Ponytail (Witcher)"
	icon_state = "ponytail_witcher"

/datum/sprite_accessory/hair/head/countryponytailalt
	name = "Ponytail (Country Alt)"
	icon_state = "countryalt"

/datum/sprite_accessory/hair/head/kusanagi_alt
	name = "Kusanagi (Alt)"
	icon_state = "kusanagi_alt"

/datum/sprite_accessory/hair/head/shorthair6
	name = "Short Hair (Alt)"
	icon_state = "shorthair_alt"

/datum/sprite_accessory/hair/head/helmet
	name = "Helmet Hair"
	icon_state = "helmet"

/datum/sprite_accessory/hair/head/protagonist
	name = "Protagonist"
	icon_state = "Protagonist"

/datum/sprite_accessory/hair/head/hero_protagonist
	name = "Hero Protagonist"
	icon_state = "hprotagonist"

/datum/sprite_accessory/hair/head/also_protagonist
	name = "Also Protagonist"
	icon_state = "alsoprotagonist"

/datum/sprite_accessory/hair/head/free_spirit
	name = "Free Spirit"
	icon_state = "freespirit"

/datum/sprite_accessory/hair/head/generic
	name = "Generic"
	icon_state = "Generic"

/datum/sprite_accessory/hair/head/polite
	name = "Polite"
	icon_state = "Polite"

/datum/sprite_accessory/hair/head/ghastly
	name = "Ghastly"
	icon_state = "ghastly"

/datum/sprite_accessory/hair/head/ghastly_f
	name = "Ghastly (Alt)"
	icon_state = "ghastly_f"

/datum/sprite_accessory/hair/head/astolfo
	name = "Astolfo"
	icon_state = "astolfo"

/datum/sprite_accessory/hair/head/astolfo_f
	name = "Astolfo (Alt)"
	icon_state = "astolfo_f"

/datum/sprite_accessory/hair/head/playful
	name = "Playful"
	icon_state = "playful"

/datum/sprite_accessory/hair/head/heiress
	name = "Heiress"
	icon_state = "heiress"

//Monke Main Port//

/datum/sprite_accessory/hair/head/phoenix
	name = "Phoenix"
	icon_state = "phoenix"

/datum/sprite_accessory/hair/head/phoenixhalfshaven
	name = "Phoenix Half Shaven"
	icon_state = "phoenix_half_shaven"

/datum/sprite_accessory/hair/head/royalcurl
	name = "Royal Curl"
	icon_state = "royalcurl"

/datum/sprite_accessory/hair/head/shorthair4
	name = "Short Hair 4"
	icon_state = "shorthair4"

/datum/sprite_accessory/hair/head/slightlymessy
	name = "Slightly Messy"
	icon_state = "slightlymessy"

/datum/sprite_accessory/hair/head/veryshortovereye
	name = "Very Short Over Eye"
	icon_state = "veryshortovereye"

/datum/sprite_accessory/hair/head/flatpressed
	name = "Flat Pressed"
	icon_state = "flatpressed"

/datum/sprite_accessory/hair/head/beachwave
	name = "Beachwave"
	icon_state = "beachwave"

/datum/sprite_accessory/hair/head/fortuneteller
	name = "Fortune Teller"
	icon_state = "fortuneteller"

/datum/sprite_accessory/hair/head/hyenamane
	name = "Hyena Mane"
	icon_state = "hyenamane"

/datum/sprite_accessory/hair/head/kajam
	name = "Kajam"
	icon_state = "kajam"

/datum/sprite_accessory/hair/head/mermaid
	name = "Mermaid"
	icon_state = "mermaid"

/datum/sprite_accessory/hair/head/unkemptcurls
	name = "Unkempt Curls"
	icon_state = "unkempt_curls"

/datum/sprite_accessory/hair/head/shrinepriestess
	name = "Shrine Priestess"
	icon_state = "shrine_priestess"

/datum/sprite_accessory/hair/head/triton
	name = "Base Triton"
	abstract_type = /datum/sprite_accessory/hair/head/triton
	icon = 'icons/mob/sprite_accessory/hair/triton.dmi'

/datum/sprite_accessory/hair/head/triton/fin
	name = "Fin"
	icon_state = "fin"

/datum/sprite_accessory/hair/head/triton/seaking
	name = "Seaking"
	icon_state = "seaking"

/datum/sprite_accessory/hair/head/triton/siren
	name = "Siren"
	icon_state = "siren"

/datum/sprite_accessory/hair/head/triton/jellyfish
	name = "Jellyfish"
	icon_state = "jellyfish"

/datum/sprite_accessory/hair/head/triton/anemonger
	name = "Anemonger"
	icon_state = "anemonger"

/datum/sprite_accessory/hair/head/triton/punkfish
	name = "Punkfish"
	icon_state = "punkfish"

/datum/sprite_accessory/hair/head/triton/weed
	name = "Weeds"
	icon_state = "weed"

/datum/sprite_accessory/hair/head/triton/gorgon
	name = "Gorgon"
	icon_state = "gorgon"

/datum/sprite_accessory/hair/head/triton/lion
	name = "Lion"
	icon_state = "lion"

/datum/sprite_accessory/hair/head/triton/betta
	name = "Betta"
	icon_state = "betta"

/datum/sprite_accessory/hair/head/medicator
	name = "Base Medicator"
	abstract_type = /datum/sprite_accessory/hair/head/medicator
	icon = 'icons/mob/sprite_accessory/hair/medicator.dmi'

/datum/sprite_accessory/hair/head/medicator/windswept
	name = "Windswept"
	icon_state = "windswept"

/datum/sprite_accessory/hair/head/medicator/curl
	name = "Curl"
	icon_state = "curl"

/datum/sprite_accessory/hair/head/medicator/spencer
	name = "Spencer"
	icon_state = "spencer"

/datum/sprite_accessory/hair/head/medicator/dynamic
	name = "Dynamic"
	icon_state = "dynamic"

/datum/sprite_accessory/hair/head/medicator/jockey
	name = "Jockey"
	icon_state = "jockey"

/datum/sprite_accessory/hair/head/medicator/hook
	name = "Hook"
	icon_state = "hook"

/datum/sprite_accessory/hair/head/medicator/crown
	name = "Crown"
	icon_state = "crown"
