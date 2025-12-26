/datum/bodypart_feature/hair
	var/hair_color = "#FFFFFF"
	var/natural_gradient = /datum/hair_gradient/none
	var/natural_color = "#FFFFFF"
	var/hair_dye_gradient = /datum/hair_gradient/none
	var/hair_dye_color = "#FFFFFF"

	var/static/list/extensions

/datum/bodypart_feature/hair/bodypart_overlays(mutable_appearance/standing, obj/item/bodypart/bodypart)
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

	var/dynamic = FALSE
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	if(extensions[accessory.icon_state+dynamic_hair_suffix])
		dynamic = dynamic_hair_suffix

	add_gradient_overlay(standing, natural_gradient, natural_color, dynamic)
	add_gradient_overlay(standing, hair_dye_gradient, hair_dye_color, dynamic)

/datum/bodypart_feature/hair/proc/add_gradient_overlay(mutable_appearance/standing, gradient_type, gradient_color, dynamic = FALSE)
	if(gradient_type == /datum/hair_gradient/none)
		return
	var/datum/hair_gradient/gradient = HAIR_GRADIENT(gradient_type)
	var/icon/temp = icon(gradient.icon, gradient.icon_state)
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	var/icon/temp_hair
	if(dynamic)
		temp_hair = icon(accessory.dynamic_file, "[accessory.icon_state][dynamic]")
	else
		temp_hair = icon(accessory.icon, accessory.icon_state)

	temp.Blend(temp_hair, ICON_ADD)
	var/mutable_appearance/gradient_appearance = mutable_appearance(temp)
	gradient_appearance.color = gradient_color
	standing.overlays += gradient_appearance

/datum/bodypart_feature/hair/head
	name = "Hair"
	feature_slot = BODYPART_FEATURE_HAIR
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/hair/facial
	name = "Facial Hair"
	feature_slot = BODYPART_FEATURE_FACIAL_HAIR
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/face_detail
	name = "Face Detail"
	feature_slot = BODYPART_FEATURE_FACE_DETAIL
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/accessory
	name = "Accessory"
	feature_slot = BODYPART_FEATURE_ACCESSORY
	body_zone = BODY_ZONE_HEAD

/datum/bodypart_feature/legwear
	name = "Legwear"
	feature_slot = BODYPART_FEATURE_LEGWEAR
	body_zone = BODY_ZONE_CHEST
	var/obj/item/legwears/legwear_item

/datum/bodypart_feature/legwear/set_accessory_type(new_accessory_type, colors, mob/living/carbon/owner, spawn_item = TRUE)
	accessory_type = new_accessory_type
	var/datum/sprite_accessory/legwear/accessory = SPRITE_ACCESSORY(accessory_type)
	if(!isnull(colors))
		accessory_colors = colors
	else
		accessory_colors = accessory.get_default_colors(color_key_source_list_from_carbon(owner))
	accessory_colors = accessory.validate_color_keys_for_owner(owner, colors)
	if(owner && spawn_item)
		var/mob/living/carbon/human/H = owner
		if(!istype(H))
			return
		legwear_item = new accessory.legwear_type(H)
		if(H.legwear_socks)
			qdel(H.legwear_socks)
		H.legwear_socks = legwear_item
		legwear_item.legwears_feature = src
		legwear_item.color = accessory_colors

/datum/bodypart_feature/underwear
	name = "Underwear"
	feature_slot = BODYPART_FEATURE_UNDERWEAR
	body_zone = BODY_ZONE_CHEST

/datum/bodypart_feature/underwear/set_accessory_type(new_accessory_type, colors, mob/living/carbon/owner)
	accessory_type = new_accessory_type
	var/datum/sprite_accessory/underwear/accessory = SPRITE_ACCESSORY(accessory_type)
	if(!isnull(colors))
		accessory_colors = colors
	else
		accessory_colors = accessory.get_default_colors(color_key_source_list_from_carbon(owner))
	accessory_colors = accessory.validate_color_keys_for_owner(owner, colors)
	if(!owner)
		return
	var/mob/living/carbon/human/H = owner
	if(!istype(H))
		return
	H.underwear = accessory.name
	if(!accessory.use_static)
		H.underwear_color = accessory_colors

/datum/bodypart_feature/underwear/get_bodypart_overlay(obj/item/bodypart/bodypart)
	return

/datum/bodypart_feature/vamprire_seal
	name = "Vampiric Seal"
	feature_slot = BODYPART_FEATURE_BRAND
	body_zone = BODY_ZONE_CHEST
	accessory_colors = COLOR_RED
	accessory_type = /datum/sprite_accessory/brand/vampire_seal

/datum/bodypart_feature/indentured_brand
	name = "Indentured Brand"
	feature_slot = BODYPART_FEATURE_BRAND
	body_zone = BODY_ZONE_CHEST
	accessory_type = /datum/sprite_accessory/brand/indentured_womb
