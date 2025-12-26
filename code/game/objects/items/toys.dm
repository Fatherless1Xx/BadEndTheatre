/* Toys!
 * Contains
 *		Balloons
 *		Fake singularity
 *		Toy gun
 *		Toy crossbow
 *		Toy swords
 *		Crayons
 *		Snap pops
 *		Mech prizes
 *		AI core prizes
 *		Toy codex gigas
 * 		Skeleton toys
 *		Cards
 *		Toy nuke
 *		Fake meteor
 *		Foam armblade
 *		Toy big red button
 *		Beach ball
 *		Toy xeno
 *      Kitty toys!
 *		Snowballs
 *		Clockwork Watches
 *		Toy Daggers
 */


/obj/item/toy
	throwforce = 0
	throw_speed = 1
	throw_range = 7
	force = 0

/*
 * Snap pops
 */

/obj/item/toy/snappop
	name = "powder pack"
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "snappop"
	w_class = WEIGHT_CLASS_TINY
	var/ash_type = /obj/item/fertilizer/ash

/obj/item/toy/snappop/proc/pop_burst(n=3, c=1)
	var/datum/effect_system/spark_spread/s = new()
	s.set_up(n, c, src)
	s.start()
	new ash_type(loc)
	visible_message(span_warning("[src] explodes!"),
		span_hear("I hear a explosion!"))
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	qdel(src)

/obj/item/toy/snappop/fire_act(added, maxstacks)
	pop_burst()

/obj/item/toy/snappop/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	if(!..())
		pop_burst()

/obj/item/toy/snappop/Crossed(H as mob|obj)
	if(ishuman(H)) //i guess carp and shit shouldn't set them off
		var/mob/living/carbon/M = H
		if(M.m_intent == MOVE_INTENT_RUN)
			to_chat(M, span_danger("I step on the snap pop!"))
			pop_burst(2, 0)

/obj/item/toy/snappop/phoenix
	name = "magic powder pack"
	desc = ""
	ash_type = /obj/item/fertilizer/ash/snappop_phoenix

/obj/item/fertilizer/ash/snappop_phoenix
	var/respawn_time = 300

/obj/item/fertilizer/ash/snappop_phoenix/Initialize()
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(respawn)), respawn_time)

/obj/item/fertilizer/ash/snappop_phoenix/proc/respawn()
	new /obj/item/toy/snappop/phoenix(get_turf(src))
	qdel(src)

/obj/item/toy/cards
	resistance_flags = FLAMMABLE
	max_integrity = 50
	var/parentdeck = null
	var/deckstyle = "syndicate"
	var/card_hitsound = null
	var/card_force = 0
	var/card_throwforce = 0
	var/card_throw_speed = 1
	var/card_throw_range = 7
	var/list/card_attack_verb = list("attacked")
	w_class = WEIGHT_CLASS_TINY

/obj/item/toy/cards/suicide_act(mob/living/carbon/user)
	user.visible_message(span_suicide("[user] is slitting [user.p_their()] wrists with \the [src]! It looks like [user.p_they()] [user.p_have()] a crummy hand!"))
	playsound(src, 'sound/blank.ogg', 50, TRUE)
	return BRUTELOSS

/obj/item/toy/cards/proc/apply_card_vars(obj/item/toy/cards/newobj, obj/item/toy/cards/sourceobj) // Applies variables for supporting multiple types of card deck
	if(!istype(sourceobj))
		return

/obj/item/toy/cards/deck
	name = "deck of cards"
	desc = ""
	icon = 'icons/obj/toy.dmi'
	deckstyle = "syndicate"
	icon_state = "deck_syndicate_full"
	w_class = WEIGHT_CLASS_TINY
	var/cooldown = 0
	var/list/cards = list()

/obj/item/toy/cards/deck/Initialize()
	. = ..()
	populate_deck()

///Generates all the cards within the deck.
/obj/item/toy/cards/deck/proc/populate_deck()
	icon_state = "deck_[deckstyle]_full"
	for(var/suit in list("Hearts", "Spades", "Clubs", "Diamonds"))
		cards += "Ace of [suit]"
		for(var/i in 2 to 10)
			cards += "[i] of [suit]"
		for(var/person in list("Jack", "Queen", "King"))
			cards += "[person] of [suit]"

/obj/item/toy/cards/deck/examine(mob/user)
	. = ..()
	if(ishuman(user))
		if(HAS_TRAIT(user, TRAIT_BLACKLEG))
			. += span_notice("Peeking under the top card, you see it reads: [cards[1]].")

//ATTACK HAND IGNORING PARENT RETURN VALUE
//ATTACK HAND NOT CALLING PARENT
/obj/item/toy/cards/deck/attack_hand(mob/user)
	draw_card(user)

/obj/item/toy/cards/deck/proc/draw_card(mob/user)
	if(isliving(user))
		var/mob/living/L = user
		if(!(L.mobility_flags & MOBILITY_PICKUP))
			return
	var/choice = null
	if(cards.len == 0)
		to_chat(user, span_warning("There are no more cards to draw!"))
		return
	var/obj/item/toy/cards/singlecard/H = new/obj/item/toy/cards/singlecard(user.loc)
	choice = cards[1]
	H.cardname = choice
	H.parentdeck = src
	var/O = src
	H.apply_card_vars(H,O)
	cards -= choice
	H.pickup(user)
	user.put_in_hands(H)
	user.visible_message(span_notice("[user] draws a card from the deck."), span_notice("I draw a card from the deck."))
	update_appearance(UPDATE_ICON_STATE)

/obj/item/toy/cards/deck/update_icon_state()
	. = ..()
	var/card_num = length(cards)
	if(card_num > 26)
		icon_state = "deck_[deckstyle]_full"
	else if(card_num > 13)
		icon_state = "deck_[deckstyle]_half"
	else if(card_num > 6)
		icon_state = "deck_[deckstyle]_low"
	else if(card_num == 0)
		icon_state = "deck_[deckstyle]_empty"

/obj/item/toy/cards/deck/attack_self(mob/user, params)
	if(cooldown < world.time - 50)
		if(HAS_TRAIT(user, TRAIT_BLACKLEG))
			var/outcome = alert(user, "How do you want to shuffle the deck?","XYLIX","False Shuffle","Force Top Card","Play fair")
			switch(outcome)
				if("False Shuffle")
					record_featured_stat(FEATURED_STATS_CRIMINALS, user)
					record_round_statistic(STATS_GAMES_RIGGED)
					to_chat(user, span_notice("I shuffle the cards, then reverse the shuffle. Sneaky."))
				if("Force Top Card")
					record_featured_stat(FEATURED_STATS_CRIMINALS, user)
					record_round_statistic(STATS_GAMES_RIGGED)
					user.set_machine(src)
					interact(user)
				if("Play fair")
					to_chat(user, span_notice("I, in a surprising show of good faith, shuffle the deck fairly."))
					cards = shuffle(cards)
		else
			to_chat(user, span_notice("I shuffle the deck."))
			cards = shuffle(cards)
		user.visible_message(span_notice("[user] shuffles the deck."))
		playsound(src, 'sound/blank.ogg', 50, TRUE)
		cooldown = world.time

/obj/item/toy/cards/deck/ui_interact(mob/user)
	. = ..()
	var/dat = "The deck has<BR>"
	for(var/t in cards)
		dat += "<A href='byond://?src=[REF(src)];pick=[t]'>A [t].</A><BR>"
	dat += "Which card would you like to force?"
	var/datum/browser/popup = new(user, "deck", "Which card to force?", 400, 240)
	popup.set_content(dat)
	popup.open()

/obj/item/toy/cards/deck/Topic(href, href_list)
	if(..())
		return
	if(usr.stat || !ishuman(usr))
		return
	var/mob/living/carbon/human/cardUser = usr
	if(!(cardUser.mobility_flags & MOBILITY_USE))
		return
	if(href_list["pick"] && HAS_TRAIT(cardUser, TRAIT_BLACKLEG))
		var/choice = href_list["pick"]
		cards -= choice
		cards = shuffle(cards)
		cards.Insert(1,choice)
		to_chat(cardUser, span_notice("I shuffle the deck, sneakily putting the [choice] on top."))
		cardUser << browse(null, "window=deck")
		return

/obj/item/toy/cards/deck/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/cards/singlecard))
		var/obj/item/toy/cards/singlecard/SC = I
		if(SC.parentdeck == src)
			if(!user.temporarilyRemoveItemFromInventory(SC))
				to_chat(user, span_warning("The card is stuck to your hand, you can't add it to the deck!"))
				return
			cards += SC.cardname
			user.visible_message(span_notice("[user] adds a card to the bottom of the deck."), span_notice("I add the card to the bottom of the deck."))
			qdel(SC)
		else
			to_chat(user, span_warning("I can't mix cards from other decks!"))
		update_appearance(UPDATE_ICON_STATE)
	else if(istype(I, /obj/item/toy/cards/cardhand))
		var/obj/item/toy/cards/cardhand/CH = I
		if(CH.parentdeck == src)
			if(!user.temporarilyRemoveItemFromInventory(CH))
				to_chat(user, span_warning("The hand of cards is stuck to your hand, you can't add it to the deck!"))
				return
			cards += CH.currenthand
			user.visible_message(span_notice("[user] puts [user.p_their()] hand of cards in the deck."), span_notice("I put the hand of cards in the deck."))
			qdel(CH)
		else
			to_chat(user, span_warning("I can't mix cards from other decks!"))
		update_appearance(UPDATE_ICON_STATE)
	else
		return ..()

/obj/item/toy/cards/deck/MouseDrop(atom/over_object)
	. = ..()
	var/mob/living/M = usr
	if(!istype(M) || !(M.mobility_flags & MOBILITY_PICKUP))
		return
	if(Adjacent(usr))
		if(over_object == M && loc != M)
			M.put_in_hands(src)
			to_chat(usr, span_notice("I pick up the deck."))

		else if(istype(over_object, /atom/movable/screen/inventory/hand))
			var/atom/movable/screen/inventory/hand/H = over_object
			if(M.putItemFromInventoryInHandIfPossible(src, H.held_index))
				to_chat(usr, span_notice("I pick up the deck."))

	else
		to_chat(usr, span_warning("I can't reach it from here!"))



/obj/item/toy/cards/cardhand
	name = "hand of cards"
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "syndicate_hand2"
	w_class = WEIGHT_CLASS_TINY
	var/list/currenthand = list()
	var/choice = null


/obj/item/toy/cards/cardhand/attack_self(mob/user, params)
	user.set_machine(src)
	interact(user)

/obj/item/toy/cards/cardhand/ui_interact(mob/user)
	. = ..()
	var/dat = "You have:<BR>"
	for(var/t in currenthand)
		dat += "<A href='byond://?src=[REF(src)];pick=[t]'>A [t].</A><BR>"
	dat += "Which card will you remove next?"
	var/datum/browser/popup = new(user, "cardhand", "Hand of Cards", 400, 240)
	popup.set_content(dat)
	popup.open()


/obj/item/toy/cards/cardhand/Topic(href, href_list)
	if(..())
		return
	if(usr.stat || !ishuman(usr))
		return
	var/mob/living/carbon/human/cardUser = usr
	if(!(cardUser.mobility_flags & MOBILITY_USE))
		return
	var/O = src
	if(href_list["pick"])
		if (cardUser.is_holding(src))
			var/choice = href_list["pick"]
			var/obj/item/toy/cards/singlecard/C = new/obj/item/toy/cards/singlecard(cardUser.loc)
			currenthand -= choice
			C.parentdeck = parentdeck
			C.cardname = choice
			C.apply_card_vars(C,O)
			C.pickup(cardUser)
			cardUser.put_in_hands(C)
			cardUser.visible_message(span_notice("[cardUser] draws a card from [cardUser.p_their()] hand."), span_notice("I take the [C.cardname] from your hand."))

			interact(cardUser)
			if(currenthand.len < 3)
				icon_state = "[deckstyle]_hand2"
			else if(currenthand.len < 4)
				icon_state = "[deckstyle]_hand3"
			else if(currenthand.len < 5)
				icon_state = "[deckstyle]_hand4"
			if(currenthand.len == 1)
				var/obj/item/toy/cards/singlecard/N = new/obj/item/toy/cards/singlecard(loc)
				N.parentdeck = parentdeck
				N.cardname = currenthand[1]
				N.apply_card_vars(N,O)
				qdel(src)
				N.pickup(cardUser)
				cardUser.put_in_hands(N)
				to_chat(cardUser, span_notice("I also take [currenthand[1]] and hold it."))
				cardUser << browse(null, "window=cardhand")
		return

/obj/item/toy/cards/cardhand/attackby(obj/item/toy/cards/singlecard/C, mob/living/user, params)
	if(istype(C))
		if(C.parentdeck == parentdeck)
			currenthand += C.cardname
			user.visible_message(span_notice("[user] adds a card to [user.p_their()] hand."), span_notice("I add the [C.cardname] to your hand."))
			qdel(C)
			interact(user)
			if(currenthand.len > 4)
				icon_state = "[deckstyle]_hand5"
			else if(currenthand.len > 3)
				icon_state = "[deckstyle]_hand4"
			else if(currenthand.len > 2)
				icon_state = "[deckstyle]_hand3"
		else
			to_chat(user, span_warning("I can't mix cards from other decks!"))
	else
		return ..()

/obj/item/toy/cards/cardhand/apply_card_vars(obj/item/toy/cards/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "[deckstyle]_hand2" // Another dumb hack, without this the hand is invisible (or has the default deckstyle) until another card is added.
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.card_attack_verb = sourceobj.card_attack_verb
	newobj.resistance_flags = sourceobj.resistance_flags

/obj/item/toy/cards/singlecard
	name = "card"
	desc = ""
	icon = 'icons/obj/toy.dmi'
	icon_state = "singlecard_down_syndicate"
	w_class = WEIGHT_CLASS_TINY
	var/cardname = null
	var/flipped = 0
	SET_BASE_PIXEL(-5, 0)

/obj/item/toy/cards/singlecard/examine(mob/user)
	. = ..()
	if(ishuman(user))
		var/mob/living/carbon/human/cardUser = user
		if(cardUser.is_holding(src))
			cardUser.visible_message(span_notice("[cardUser] checks [cardUser.p_their()] card."), span_notice("The card reads: [cardname]."))
		else if(HAS_TRAIT(user, TRAIT_BLACKLEG))
			. += span_notice("Peeking under the card, you see the card reads: [cardname].")
		else
			. += span_warning("You need to have the card in your hand to check it!")


/obj/item/toy/cards/singlecard/verb/Flip()
	set name = "Flip Card"
	set hidden = 1
	set src in range(1)

	if(!ishuman(usr) || !usr.can_perform_action(src, NEED_DEXTERITY))
		return
	if(!flipped)
		flipped = 1
		if (cardname)
			icon_state = "sc_[cardname]_[deckstyle]"
			name = cardname
		else
			icon_state = "sc_Ace of Spades_[deckstyle]"
			name = "What Card"
		pixel_x = base_pixel_x + 5
	else if(flipped)
		flipped = 0
		icon_state = "singlecard_down_[deckstyle]"
		name = "card"
		pixel_x = base_pixel_x - 5

/obj/item/toy/cards/singlecard/attackby(obj/item/I, mob/living/user, params)
	if(istype(I, /obj/item/toy/cards/singlecard/))
		var/obj/item/toy/cards/singlecard/C = I
		if(C.parentdeck == parentdeck)
			var/obj/item/toy/cards/cardhand/H = new/obj/item/toy/cards/cardhand(user.loc)
			H.currenthand += C.cardname
			H.currenthand += cardname
			H.parentdeck = C.parentdeck
			H.apply_card_vars(H,C)
			to_chat(user, span_notice("I combine the [C.cardname] and the [cardname] into a hand."))
			qdel(C)
			qdel(src)
			H.pickup(user)
			user.put_in_active_hand(H)
		else
			to_chat(user, span_warning("I can't mix cards from other decks!"))

	if(istype(I, /obj/item/toy/cards/cardhand/))
		var/obj/item/toy/cards/cardhand/H = I
		if(H.parentdeck == parentdeck)
			H.currenthand += cardname
			user.visible_message(span_notice("[user] adds a card to [user.p_their()] hand."), span_notice("I add the [cardname] to your hand."))
			qdel(src)
			H.interact(user)
			if(H.currenthand.len > 4)
				H.icon_state = "[deckstyle]_hand5"
			else if(H.currenthand.len > 3)
				H.icon_state = "[deckstyle]_hand4"
			else if(H.currenthand.len > 2)
				H.icon_state = "[deckstyle]_hand3"
		else
			to_chat(user, span_warning("I can't mix cards from other decks!"))
	else
		return ..()

/obj/item/toy/cards/singlecard/attack_self(mob/living/carbon/human/user, params)
	if(!ishuman(user) || !(user.mobility_flags & MOBILITY_USE))
		return
	Flip()

/obj/item/toy/cards/singlecard/apply_card_vars(obj/item/toy/cards/singlecard/newobj,obj/item/toy/cards/sourceobj)
	..()
	newobj.deckstyle = sourceobj.deckstyle
	newobj.icon_state = "singlecard_down_[deckstyle]" // Without this the card is invisible until flipped. It's an ugly hack, but it works.
	newobj.card_hitsound = sourceobj.card_hitsound
	newobj.hitsound = newobj.card_hitsound
	newobj.card_force = sourceobj.card_force
	newobj.force = newobj.card_force
	newobj.card_throwforce = sourceobj.card_throwforce
	newobj.throwforce = newobj.card_throwforce
	newobj.card_throw_speed = sourceobj.card_throw_speed
	newobj.throw_speed = newobj.card_throw_speed
	newobj.card_throw_range = sourceobj.card_throw_range
	newobj.throw_range = newobj.card_throw_range
	newobj.card_attack_verb = sourceobj.card_attack_verb
	newobj.attack_verb = newobj.card_attack_verb


/*
|| Syndicate playing cards, for pretending you're Gambit and playing poker for the nuke disk. ||
*/

/obj/item/toy/cards/deck/syndicate
	name = "cards"
	desc = "a pack of cards."
	icon_state = "deck_syndicate_full"
	deckstyle = "syndicate"
	card_hitsound = 'sound/blank.ogg'
	card_force = 5
	card_throwforce = 10
	card_throw_speed = 1
	card_throw_range = 7
	card_attack_verb = list("attacked", "sliced", "diced", "slashed", "cut")
	resistance_flags = NONE

/*
 * Dildos and plugs
 */

/obj/item/dildo
	parent_type = /obj/item/toy
	name = "unfinished dildo"
	desc = "You have to finish it first."
	icon = 'modular_rmh/icons/obj/lewd/dildo.dmi'
	icon_state = "unfinished"
	item_state = "dildo"
	lefthand_file = 'modular_rmh/icons/mob/lewd/items_lefthand.dmi'
	righthand_file = 'modular_rmh/icons/mob/lewd/items_righthand.dmi'
	force = 1
	throwforce = 10
	w_class = WEIGHT_CLASS_SMALL
	obj_flags = CAN_BE_HIT
	sellprice = 1
	var/dildo_type = "human"
	var/dildo_size = "small"
	var/pleasure = 4
	var/can_custom = TRUE
	var/dildo_material
	var/shape_choice
	var/size_choice
	var/mob/living/carbon/human/wearer
	var/obj/item/organ/genitals/penis/strapon
	slot_flags = ITEM_SLOT_BELT

/obj/item/dildo/New()
	. = ..()
	name = "unfinished [dildo_material] dildo"

/obj/item/dildo/attack_self(mob/living/user)
	. = ..()
	if(!istype(user))
		return
	if(can_custom)
		customize(user)

/obj/item/dildo/equipped(mob/user, slot, initial = FALSE)
	if(slot == ITEM_SLOT_BELT)
		var/mob/living/carbon/human/U = user
		if(strapon)
			var/obj/item/organ/genitals/penis/penis = U.getorganslot(ORGAN_SLOT_PENIS)
			if(!penis)
				penis = strapon
				wearer = U
				penis.Insert(U)
	. = ..()

/obj/item/dildo/dropped() //called when belt removed so we can use it to remove the strapon
	if(wearer) // so males who already have a penis dont get their dicks removed
		var/obj/item/organ/genitals/penis = wearer.getorganslot(ORGAN_SLOT_PENIS)
		if (penis)
			penis.Remove(wearer)
	. = ..()

/obj/item/dildo/proc/customize(mob/living/user)
	if(!can_custom)
		return FALSE
	if(src && !user.incapacitated() && in_range(user,src))
		var/shape_choice = input(user, "Choose a shape for your dildo.","Dildo Shape") as null|anything in list("knotted", "human", "flared")
		if(src && shape_choice && !user.incapacitated() && in_range(user,src))
			dildo_type = shape_choice
	update_appearance()
	if(src && !user.incapacitated() && in_range(user,src))
		var/size_choice = input(user, "Choose a size for your dildo.","Dildo Size") as null|anything in list("small", "medium", "big")
		if(src && size_choice && !user.incapacitated() && in_range(user,src))
			dildo_size = size_choice
			switch(dildo_size)
				if("small")
					pleasure = 4
				if("medium")
					pleasure = 6
				if("big")
					pleasure = 8
	update_appearance()
	update_strapon()
	can_custom = FALSE
	return TRUE

/obj/item/dildo/proc/update_strapon()
	var/obj/item/organ/genitals/penis/temp = new /obj/item/organ/genitals/penis
	temp.name = name
	icon_state = "dildo_[dildo_type]_[dildo_size]"
	switch(shape_choice)
		if("knotted")
			temp.penis_type = PENIS_TYPE_KNOTTED
		if("human")
			temp.penis_type = PENIS_TYPE_PLAIN
		if("flared")
			temp.penis_type = PENIS_TYPE_EQUINE
	switch(dildo_size)
		if("small")
			temp.organ_size = DEFAULT_PENIS_SIZE-1
		if("medium")
			temp.organ_size = DEFAULT_PENIS_SIZE
		if("big")
			temp.organ_size = DEFAULT_PENIS_SIZE+1
		if("huge")
			temp.organ_size = DEFAULT_PENIS_SIZE+1 //huge doesnt exist in mobs
	temp.always_hard = TRUE
	temp.strapon = TRUE
	strapon = temp

/obj/item/dildo/update_appearance()
	. = ..()
	icon_state = "dildo_[dildo_type]_[dildo_size]"
	name = "[dildo_size] [dildo_type] [dildo_material] dildo"
	desc = "To quench the woman's thirst."

/obj/item/dildo/wood
	color = "#7D4033"
	resistance_flags = FLAMMABLE
	dildo_material = "wooden"
	sellprice = 1

/obj/item/dildo/iron
	color = "#9EA48E"
	dildo_material = "iron"
	sellprice = 5

/obj/item/dildo/steel
	color = "#9BADB7"
	dildo_material = "steel"
	sellprice = 10

/obj/item/dildo/silver/
	color = "#C6D5E1"
	dildo_material = "silver"
	sellprice = 30

/obj/item/dildo/silver/pickup(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	var/datum/antagonist/vampire/V_lord = H.mind.has_antag_datum(/datum/antagonist/vampire/)
	var/datum/antagonist/werewolf/W = H.mind.has_antag_datum(/datum/antagonist/werewolf/)
	if(ishuman(H))
		if(H.mind.has_antag_datum(/datum/antagonist/vampire))
			to_chat(H, span_userdanger("The silver sizzles and burns my hand!"))
			H.adjustFireLoss(35)
		if(V_lord)
			//if(V_lord.vamplevel < 4 && !H.mind.has_antag_datum(/datum/antagonist/vampirelord/lesser))
			to_chat(H, span_userdanger("The silver sizzles in my hand..."))
			H.adjustFireLoss(15)
		if(W && W.transformed == TRUE)
			to_chat(H, span_userdanger("The silver sizzles and burns my hand!"))
			H.adjustFireLoss(25)

/obj/item/dildo/silver/funny_attack_effects(mob/living/target, mob/living/user = usr, nodmg)
	if(world.time < src.last_used + 100)
		to_chat(user, span_notice("The silver needs more time to purify again."))
		return

	. = ..()
	if(ishuman(target))
		//var/mob/living/carbon/human/s_user = user
		var/mob/living/carbon/human/H = target
		var/datum/antagonist/werewolf/W = H.mind.has_antag_datum(/datum/antagonist/werewolf/)
		var/datum/antagonist/vampire/Vp = H.mind.has_antag_datum(/datum/antagonist/vampire)
		//var/datum/antagonist/vampirelord/lesser/V = H.mind.has_antag_datum(/datum/antagonist/vampirelord/lesser)
		//var/datum/antagonist/vampirelord/V_lord = H.mind.has_antag_datum(/datum/antagonist/vampirelord/)
		if(Vp)
			H.Stun(20)
			to_chat(H, span_userdanger("The silver burns me!"))
			H.adjustFireLoss(30)
			H.Paralyze(20)
			H.fire_act(1,4)
			H.apply_status_effect(/datum/status_effect/debuff/silver_curse)
			src.last_used = world.time
		/*if(V)
			if(V.disguised)
				H.Stun(20)
				H.visible_message("<font color='white'>The silver weapon manifests the [H] curse!</font>")
				to_chat(H, span_userdanger("The silver burns me!"))
				H.adjustFireLoss(30)
				H.Paralyze(20)
				H.fire_act(1,4)
				//H.apply_status_effect(/datum/status_effect/debuff/silver_curse)
				src.last_used = world.time
			else
				H.Stun(20)
				to_chat(H, span_userdanger("The silver burns me!"))
				H.adjustFireLoss(30)
				H.Paralyze(20)
				H.fire_act(1,4)
				//H.apply_status_effect(/datum/status_effect/debuff/silver_curse)
				src.last_used = world.time
		if(V_lord)
			if(V_lord.vamplevel < 4 && !V)
				if(V_lord.disguised)
					H.visible_message("<font color='white'>The silver weapon manifests the [H] curse!</font>")
				to_chat(H, span_userdanger("The silver burns me!"))
				H.Stun(10)
				H.adjustFireLoss(25)
				H.Paralyze(10)
				H.fire_act(1,4)
				src.last_used = world.time
			if(V_lord.vamplevel == 4 && !V)
				s_user.Stun(10)
				s_user.Paralyze(10)
				to_chat(s_user, "<font color='red'> The silver weapon fails!</font>")
				H.visible_message(H, span_userdanger("This feeble metal can't hurt me, I AM THE ANCIENT!"))*/
		if(W && W.transformed == TRUE)
			H.Stun(40)
			H.Paralyze(40)
			to_chat(H, span_userdanger("The silver burns me!"))
			src.last_used = world.time

/obj/item/dildo/gold
	color = "#A0A075"
	dildo_material = "golden"
	sellprice = 50

//plug
/obj/item/dildo/plug
	name = "unfinished plug"
	desc = "You have to finish it first."
	icon = 'modular_rmh/icons/obj/lewd/plug.dmi'
	icon_state = "unfinished"
	item_state = "plug"
	lefthand_file = 'modular_rmh/icons/mob/lewd/items_lefthand.dmi'
	righthand_file = 'modular_rmh/icons/mob/lewd/items_righthand.dmi'
	slot_flags = 0
	w_class = WEIGHT_CLASS_TINY

/obj/item/dildo/plug/New()
	. = ..()
	name = "unfinished [dildo_material] plug"

/obj/item/dildo/plug/customize(mob/living/user)
	if(!can_custom)
		return FALSE
	if(src && !user.incapacitated() && in_range(user,src))
		size_choice = input(user, "Choose a size for your dildo.","Dildo Size") as null|anything in list("small", "medium", "big", "huge")
		if(src && size_choice && !user.incapacitated() && in_range(user,src))
			dildo_size = size_choice
			switch(dildo_size)
				if("small")
					pleasure = 4
				if("medium")
					pleasure = 6
				if("big")
					pleasure = 8
				if("huge")
					pleasure = 10
	update_appearance()
	//update_strapon()
	can_custom = FALSE
	return TRUE

/obj/item/dildo/plug/update_appearance()
	. = ..()
	icon_state = "plug_[dildo_size]"
	name = "[dildo_size] [dildo_material] plug"
	if(!istype(src, /obj/item/dildo/plug/gold) && !istype(src, /obj/item/dildo/plug/silver) && !istype(src, /obj/item/dildo/plug/stone) && !istype(src, /obj/item/dildo/plug/wood) && !istype(src, /obj/item/dildo/plug/glass)) //those will maintain desc, rest are randomized below.
		desc = pick("To keep a woman's contents within.","To shut a hole.","Redirector.","Suitable chair replacement.","Redirect to the correct path.","Keeps what's needed, within.")
	if(istype(src, /obj/item/dildo/plug/gold))
		desc = pick("Prevents royal accidents.","Royal hole preserver.","Shuts the wrong hole of royalty.","Best investment ever.")
/*
/obj/item/dildo/plug/update_strapon()
	var/obj/item/organ/genitals/penis/temp = new /obj/item/organ/genitals/penis
	temp.name = name
	icon_state = "plug_[dildo_size]"
	switch(dildo_size)
		if("small")
			temp.organ_size = DEFAULT_PENIS_SIZE-1
		if("medium")
			temp.organ_size = DEFAULT_PENIS_SIZE
		if("big")
			temp.organ_size = DEFAULT_PENIS_SIZE+1
		if("huge")
			temp.organ_size = DEFAULT_PENIS_SIZE+1 //huge doesnt exist in mobs
	temp.always_hard = TRUE
	temp.strapon = TRUE
	strapon = temp*/

/obj/item/dildo/plug/wood
	color = "#7D4033"
	resistance_flags = FLAMMABLE
	dildo_material = "wooden"
	sellprice = 1
	desc = "Watch for splinters."

/obj/item/dildo/plug/stone
	color = "#3f3f3f"
	dildo_material = "stone"
	sellprice = 3
	desc = "Same as putting a regular stone up a place, probably. Now comes in convenient shape?"

/obj/item/dildo/plug/iron
	color = "#909090"
	dildo_material = "iron"
	sellprice = 5

/obj/item/dildo/plug/copper
	color = "#a86918"
	dildo_material = "copper"
	sellprice = 8

/obj/item/dildo/plug/steel
	color = "#887e99"
	dildo_material = "steel"
	sellprice = 12

/obj/item/dildo/plug/silver
	color = "#ffffff"
	dildo_material = "silver"
	sellprice = 30
	desc = "Not recommended for vampires and verevolves in heat."
	last_used = 0

/obj/item/dildo/plug/silver/pickup(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	var/datum/antagonist/vampire/V_lord = H.mind.has_antag_datum(/datum/antagonist/vampire/)
	var/datum/antagonist/werewolf/W = H.mind.has_antag_datum(/datum/antagonist/werewolf/)
	if(ishuman(H))
		if(V_lord)
			//if(V_lord.vamplevel < 4 && !H.mind.has_antag_datum(/datum/antagonist/vampirelord/lesser))
			to_chat(H, span_userdanger("The silver sizzles in my hand..."))
			H.adjustFireLoss(15)
		if(W && W.transformed == TRUE)
			to_chat(H, span_userdanger("The silver sizzles and burns my hand!"))
			H.adjustFireLoss(25)

/obj/item/dildo/plug/silver/funny_attack_effects(mob/living/target, mob/living/user = usr, nodmg)
	if(world.time < src.last_used + 100)
		to_chat(user, span_notice("The silver needs more time to purify again."))
		return

	. = ..()
	if(ishuman(target))
		//var/mob/living/carbon/human/s_user = user
		var/mob/living/carbon/human/H = target
		var/datum/antagonist/werewolf/W = H.mind.has_antag_datum(/datum/antagonist/werewolf/)
		var/datum/antagonist/vampire/Vp = H.mind.has_antag_datum(/datum/antagonist/vampire)
		//var/datum/antagonist/vampirelord/lesser/V = H.mind.has_antag_datum(/datum/antagonist/vampirelord/lesser)
		//var/datum/antagonist/vampirelord/V_lord = H.mind.has_antag_datum(/datum/antagonist/vampirelord/)
		if(Vp)
			H.Stun(20)
			to_chat(H, span_userdanger("The silver burns me!"))
			H.adjustFireLoss(30)
			H.Paralyze(20)
			H.fire_act(1,4)
			H.apply_status_effect(/datum/status_effect/debuff/silver_curse)
			src.last_used = world.time
		/*if(V)
			if(V.disguised)
				H.Stun(20)
				H.visible_message("<font color='white'>The silver weapon manifests the [H] curse!</font>")
				to_chat(H, span_userdanger("The silver burns me!"))
				H.adjustFireLoss(30)
				H.Paralyze(20)
				H.fire_act(1,4)
				H.apply_status_effect(/datum/status_effect/debuff/silver_curse)
				src.last_used = world.time
			else
				H.Stun(20)
				to_chat(H, span_userdanger("The silver burns me!"))
				H.adjustFireLoss(30)
				H.Paralyze(20)
				H.fire_act(1,4)
				H.apply_status_effect(/datum/status_effect/debuff/silver_curse)
				src.last_used = world.time
		if(V_lord)
			if(V_lord.vamplevel < 4 && !V)
				if(V_lord.disguised)
					H.visible_message("<font color='white'>The silver weapon manifests the [H] curse!</font>")
				to_chat(H, span_userdanger("The silver burns me!"))
				H.Stun(10)
				H.adjustFireLoss(25)
				H.Paralyze(10)
				H.fire_act(1,4)
				src.last_used = world.time
			if(V_lord.vamplevel == 4 && !V)
				s_user.Stun(10)
				s_user.Paralyze(10)
				to_chat(s_user, "<font color='red'> The silver weapon fails!</font>")
				H.visible_message(H, span_userdanger("This feeble metal can't hurt me, I AM THE ANCIENT!"))*/
		if(W && W.transformed == TRUE)
			H.Stun(40)
			H.Paralyze(40)
			to_chat(H, span_userdanger("The silver burns me!"))
			src.last_used = world.time

/obj/item/dildo/plug/gold
	color = "#b38f1b"
	dildo_material = "golden"
	sellprice = 50

/obj/item/dildo/plug/glass
	color = "#9ffcff"
	dildo_material = "glass"
	sellprice = 5
	alpha = 123
	desc = "Similiar to putting a jar up where?"
