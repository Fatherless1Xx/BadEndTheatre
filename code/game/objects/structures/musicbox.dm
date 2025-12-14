// Music Lists
//Fucking cargo cultists - FUCK YOU VANDERLIN/AZUREPEAK/SCARLETREACH PEOPLE. This is easy as fuck to fix but you still managed to FUCK IT ALL UP!

#define JUKEBOX_MUSIC_PATH "sound/music/jukeboxes/tunes/"

/datum/looping_sound/musloop
	mid_sounds = list()
	mid_length = 5 MINUTES
	volume = 100
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
	//Flist's path should be to wherever the folder that holds all our song .oggs is. Doesn't matter where.
	init_curfile = flist(JUKEBOX_MUSIC_PATH) //Yeah, we're just fucking taking all the oggs in our special little fucking folder. That's all we have to do.
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

	if(locked())
		to_chat(user, span_info("\The [src] is locked..."))
		return

	ui_interact(user)

/obj/structure/fake_machine/musicbox/ui_interact(mob/user)
	. = ..()

	var/list/menu = list()

	menu += "<style>"
	menu += "body"
	menu += "{background-color: #000000; font-size: 24}"
	menu += "</style>"


	for(var/i in 1 to init_curfile.len)
		menu += "<A href='byond://?src=[REF(src)];song_choice=[JUKEBOX_MUSIC_PATH][init_curfile[i]]'>Song [i]</A><BR>"

	menu += "<A href='byond://?src=[REF(src)];off=1'>OFF</A><BR>"

	var/datum/browser/popup = new(user, "musikk", "<div align='center'>ENTERTAINMENT</div>", 100, 450)
	popup.set_content(menu.Join())
	popup.open(FALSE)

/obj/structure/fake_machine/musicbox/Topic(href, list/href_list)
	if(!usr || !usr.client)
		return

	if(href_list["song_choice"])
		stop_playing()
		say(href_list["song_choice"])
		playsound(get_turf(src), rattle_sound)
		curfile = file(href_list["song_choice"])
		start_playing()

	if(href_list["off"])
		playsound(get_turf(src), rattle_sound)
		stop_playing()


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
