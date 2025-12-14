// Music Lists
//Fucking cargo cultists - FUCK YOU VANDERLIN/AZUREPEAK/SCARLETREACH PEOPLE. This is easy as fuck to fix but you still managed to FUCK IT ALL UP!

/datum/looping_sound/musloop
	mid_sounds = list()
	mid_length = 4 MINUTES
	volume = 200
	extra_range = 8
	falloff_exponent = 0
	persistent_loop = TRUE
	var/stress2give = /datum/stress_event/music
	channel = CHANNEL_JUKEBOX

/datum/looping_sound/musloop/on_hear_sound(mob/M)
	. = ..()
	if(stress2give)
		if(isliving(M))
			var/mob/living/carbon/L = M
			L.add_stress(stress2give)

/obj/structure/fake_machine/musicbox
	name = "wax music device"
	desc = "A marvelous device created by Heartfelts artificers before its fall, it plays a variety of songs from across Faience, as if their preformers where within the same room."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "music0"
	density = TRUE
	anchored = TRUE
	resistance_flags = INDESTRUCTIBLE
	rattle_sound = 'sound/misc/machineno.ogg'
	unlock_sound = 'sound/misc/beep.ogg'
	lock_sound = 'sound/misc/beep.ogg'
	var/datum/looping_sound/musloop/soundloop
	var/list/init_curfile = list() // A list of songs that curfile is set to on init. MUST BE IN ONE OF THE MUSIC_TAVCAT_'s. MAPPERS MAY TOUCH THIS.
	var/curfile // The current track that is playing right now
	var/playing = FALSE // If music is playing or not. playmusic() deals with this don't mess with it.
	var/curvol = 100 // The current volume at which audio is played. MAPPERS MAY TOUCH THIS.
	var/playuponspawn = FALSE // Does the music box start playing music when it first spawns in? MAPPERS MAY TOUCH THIS.

/obj/structure/fake_machine/musicbox/Initialize()
	. = ..()
	init_curfile = flist("sound/music/jukebox/tunes/") //Yeah, we're just fucking taking all the oggs in our special little fucking folder. That's all we have to do.
	curfile = pick(init_curfile)
	soundloop = new(src, FALSE)
	if(playuponspawn)
		start_playing()

/obj/structure/fake_machine/musicbox/Destroy()
	. = ..()
	qdel(soundloop)

/obj/structure/fake_machine/musicbox/update_icon_state()
	. = ..()
	icon_state = "music[playing]"

/obj/structure/fake_machine/musicbox/examine(mob/user)
	. = ..()
	. += "Volume: [curvol]/100"
	if(lock_check(TRUE))
		. += span_info("It's [locked() ? "locked" : "unlocked"].")
		. += span_info("It's keyhole has [access2string()] etched next to it.")

/obj/structure/fake_machine/musicbox/proc/toggle_music()
	if(!playing)
		start_playing()
	else
		stop_playing()

/obj/structure/fake_machine/musicbox/proc/start_playing()
	playing = TRUE
	soundloop.mid_sounds = list(curfile)
	soundloop.cursound = null
	soundloop.volume = curvol
	soundloop.start()
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/fake_machine/musicbox/proc/stop_playing()
	playing = FALSE
	soundloop.stop()
	update_appearance(UPDATE_ICON_STATE)

/obj/structure/fake_machine/musicbox/attack_hand(mob/user)
	. = ..()

	if(.)
		return

	user.changeNext_move(CLICK_CD_MELEE)

	if(locked())
		to_chat(user, span_info("\The [src] is locked..."))
		return

	var/button_selection = input(user, "What button do I press?", "\The [src]") as null | anything in list("Stop/Start","Change Song","Change Volume")
	if(!Adjacent(user))
		return
	if(!button_selection)
		to_chat(user, span_info("I change my mind..."))
		return
	user.visible_message(span_info("[user] presses a button on \the [src]."),span_info("I press a button on \the [src]."))
	playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)

	if(button_selection=="Stop/Start")
		toggle_music()

	if(button_selection=="Change Song")
		var/songlists_selection = input(user, "Which song list?", "\The [src]") as null | anything in list("CHILL"=MUSIC_TAVCAT_CHILL, "FUCK"=MUSIC_TAVCAT_FUCK, "PARTY"=MUSIC_TAVCAT_PARTY, "SCUM"=MUSIC_TAVCAT_SCUM, "DAMN"=MUSIC_TAVCAT_DAMN, "MISC"=MUSIC_TAVCAT_MISC)
		playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)
		user.visible_message(span_info("[user] presses a button on \the [src]."),span_info("I press a button on \the [src]."))
		var/chosen_songlists_selection = null
		if(songlists_selection=="CHILL")
			chosen_songlists_selection = MUSIC_TAVCAT_CHILL
		if(songlists_selection=="FUCK")
			chosen_songlists_selection = MUSIC_TAVCAT_FUCK
		if(songlists_selection=="PARTY")
			chosen_songlists_selection = MUSIC_TAVCAT_PARTY
		if(songlists_selection=="SCUM")
			chosen_songlists_selection = MUSIC_TAVCAT_SCUM
		if(songlists_selection=="DAMN")
			chosen_songlists_selection = MUSIC_TAVCAT_DAMN
		if(songlists_selection=="MISC")
			chosen_songlists_selection = MUSIC_TAVCAT_MISC
		var/song_selection = input(user, "Which song do I play?", "\The [src]") as null | anything in chosen_songlists_selection
		if(!Adjacent(user))
			return
		if(!song_selection)
			to_chat(user, span_info("I change my mind..."))
			return
		playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)
		user.visible_message(span_info("[user] presses a button on \the [src]."),span_info("I press a button on \the [src]."))
		curfile = chosen_songlists_selection[song_selection]
		stop_playing()
		start_playing()

	if(button_selection=="Change Volume")
		var/volume_selection = input(user, "How loud do you wish me to be?", "\The [src] (Volume Currently : [curvol]/[100])") as num|null
		if(!Adjacent(user))
			return
		if(!volume_selection)
			to_chat(user, span_info("I change my mind..."))
			return
		playsound(loc, pick('sound/misc/keyboard_select (1).ogg','sound/misc/keyboard_select (2).ogg','sound/misc/keyboard_select (3).ogg','sound/misc/keyboard_select (4).ogg'), 100, FALSE, -1)
		user.visible_message(span_info("[user] presses a button on \the [src]."),span_info("I press a button on \the [src]."))
		volume_selection = clamp(volume_selection, 1, 100)
		if(curvol<volume_selection)
			to_chat(user, span_info("I make \the [src] louder."))
		else
			to_chat(user, span_info("I make \the [src] quieter."))
		curvol = volume_selection
		playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
		stop_playing()
		start_playing()

/obj/structure/fake_machine/musicbox/mannor
	lock = /datum/lock/key/manor

/obj/structure/fake_machine/musicbox/tavern
	lock = /datum/lock/key/inn
	curvol = 100

/obj/structure/fake_machine/musicbox/tavern/Initialize()
	. = ..()
	soundloop.extra_range = 12
	soundloop.falloff_exponent = 6

#undef MUSIC_TAVCAT_CHILL
#undef MUSIC_TAVCAT_FUCK
#undef MUSIC_TAVCAT_PARTY
#undef MUSIC_TAVCAT_SCUM
#undef MUSIC_TAVCAT_DAMN
#undef MUSIC_TAVCAT_MISC
