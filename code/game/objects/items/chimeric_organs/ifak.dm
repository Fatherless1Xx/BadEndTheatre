
/obj/item/storage/fancy/ifak
	name = "personal patch kit"
	desc = "Personal treatment pouch; has all you need to stop you or someone else from meeting Necra."
	icon = 'icons/obj/medical.dmi'
	icon_state = "ifak"
	w_class = WEIGHT_CLASS_SMALL
	component_type = /datum/component/storage/concrete/grid/ifak
	throwforce = 1
	slot_flags = ITEM_SLOT_HIP
	populate_contents = list(
		/obj/item/reagent_containers/syringe,
		/obj/item/reagent_containers/syringe,
		/obj/item/storage/fancy/pilltin/sate,
		/obj/item/storage/fancy/pilltin/devour,
		/obj/item/candle/yellow,
		/obj/item/needle,
	)

/obj/item/storage/fancy/ifak/update_icon()
	. = ..()
	if(is_open)
		if(contents.len == 0)
			icon_state = "ifak_empty"
		else
			icon_state = "ifak_open"
	else
		icon_state = "ifak"

/obj/item/storage/fancy/ifak/examine(mob/user)
	. = ..()
	if(is_open)
		if(length(contents) == 1)
			. += "There is one item left."
		else
			. += "There are [contents.len <= 0 ? "no" : "[contents.len]"] items left."

/obj/item/storage/fancy/ifak/attack_self(mob/user)
	is_open = !is_open
	update_icon()
	. = ..()

/obj/item/storage/fancy/ifak/Entered(mob/user)
	if(!is_open)
		to_chat(user, span_notice("[src] needs to be opened first."))
		return
	is_open = TRUE
	update_icon()
	. = ..()

/obj/item/storage/fancy/ifak/Exited(mob/user)
	is_open = FALSE
	update_icon()
	. = ..()

/obj/item/storage/fancy/ifak/MiddleClick(mob/user, params)
	is_open = !is_open
	update_icon()
	to_chat(user, span_notice("[src] is now [is_open ? "open" : "closed"]."))
