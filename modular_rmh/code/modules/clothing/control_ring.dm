/obj/item/clothing/ring/slave_control
	name = "Slave control ring"
	desc = "An ominous-looking ring with arcane engravings."
	icon_state = "g_ring_ruby"
	sellprice = 100

	var/pleasure_phrase = ""
	var/submission_phrase = ""
	var/freedom_phrase = ""
	var/ring_bound = FALSE

/obj/item/clothing/ring/slave_control/attackby(obj/item/I, mob/living/user)
	if(!ismob(user))
		return
	if(istype(I, /obj/item/clothing/neck/gorget/slave_gorget))
		if(ring_bound)
			to_chat(user, "<span class='warning'>The ring is already bound.</span>")
		var/obj/item/clothing/neck/gorget/slave_gorget/s_g = I
		if(s_g.collar_bound)
			to_chat(user, "<span class='warning'>The collar is already bound.</span>")
		to_chat(user, "<span class='info'>You bind the ring to the collar, transferring the control words.</span>")
		user.visible_message("<span class='info'><b>[user] touches the ring and collar together, producing a dull chime.</b></span>")
		s_g.collar_bound = TRUE
		ring_bound = TRUE
		pleasure_phrase = s_g.pleasure_phrase
		submission_phrase = s_g.submission_phrase
		freedom_phrase = s_g.freedom_phrase
		return
	return ..()


/obj/item/clothing/ring/slave_control/examine(mob/user)
	. = ..()
	. += span_userdanger("You notice three engraved phrases on the ring:")
	. += "<br><b>Lust:</b> \"[pleasure_phrase]\""
	. += "<br><b>Submission:</b> \"[submission_phrase]\""
	. += "<br><b>Freedom:</b> \"[freedom_phrase]\""

/datum/anvil_recipe/slave_control
	name = "Slave control ring"
	recipe_name = "a slave control ring"
	req_bar = /obj/item/ingot/gold
	additional_items = list(/obj/item/gem/red)
	created_item = /obj/item/clothing/ring/slave_control
	craftdiff = 3
	i_type = "Valuables"
