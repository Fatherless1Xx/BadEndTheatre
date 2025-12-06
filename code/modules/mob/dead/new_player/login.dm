/mob/dead/new_player/Login()
//	winset(client, "outputwindow.output", "max-lines=1")
//	winset(client, "outputwindow.output", "max-lines=100")

	if(CONFIG_GET(flag/use_exp_tracking))
		client.set_exp_from_db()
		client.set_db_player_flags()
	if(!mind)
		mind = new /datum/mind(key)
		mind.active = 1
		mind.current = src

	..()
	if(!require_grimdark_warning_acknowledgment())
		return

	var/motd = global.config.motd
	if(motd)
		to_chat(src, "<div class=\"motd\">[motd]</div>", handle_whitespace=FALSE)

	if(GLOB.rogue_round_id)
		to_chat(src, "<span class='info'>ROUND ID: [GLOB.rogue_round_id]</span>")

//	if(motd)
//		to_chat(src, "<B>If this is your first time here,</B> <a href='byond://?src=[REF(src)];rpprompt=1'>read this lore primer.</a>", handle_whitespace=FALSE)

	if(GLOB.admin_notice)
		to_chat(src, "<span class='notice'><b>Admin Notice:</b>\n \t [GLOB.admin_notice]</span>")

	var/spc = CONFIG_GET(number/soft_popcap)
	if(spc && living_player_count() >= spc)
		to_chat(src, "<span class='notice'><b>Server Notice:</b>\n \t [CONFIG_GET(string/soft_popcap_message)]</span>")

	sight |= SEE_TURFS

	new_player_panel()
	client?.playtitlemusic()
	if(SSticker.current_state < GAME_STATE_SETTING_UP)
		var/tl = SSticker.GetTimeLeft()
		var/postfix
		if(tl > 0)
			postfix = "in about [DisplayTimeText(tl)]"
		else
			postfix = "soon"
		to_chat(src, "The game will start [postfix].")
		if(client)
			var/usedkey = get_display_ckey(ckey)
			var/list/thinz = list("takes [client.p_their()] seat.", "settles in.", "joins the session", "joins the table.", "becomes a player.")
			SEND_TEXT(world, "<span class='notice'>[usedkey] [pick(thinz)]</span>")

	// client?.change_view(8)
	// sleep(1 SECONDS)
	client?.view_size?.resetToDefault()

/mob/dead/new_player/proc/require_grimdark_warning_acknowledgment()
	var/client/C = client
	if(!C || !C.prefs)
		return TRUE
	if(C.prefs.grimdark_warning_acknowledged)
		return TRUE

	// blocking choice. this is what gates play
	var/choice = alert(C,
		"This server leans heavily into grimdark themes. Helplessness and losing are part of the experience; your character may be humiliated, killed, and even raped without your consent. Do you understand this and confirm you are 18 or older?",
		"Grimdark Warning",
		"Yes",
		"No"
	)

	if(choice == "Yes")
		C.prefs.grimdark_warning_acknowledged = TRUE
		C.prefs.save_preferences()
		return TRUE

	if(choice == "No")
		to_chat(C, "<span class='warning'>This is not the place for you.</span>")
		qdel(C)
		return FALSE

	// fallback
	return FALSE
