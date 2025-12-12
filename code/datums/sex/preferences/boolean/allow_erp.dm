/datum/erp_preference/boolean/allow_erp
	name = "Allow ERP"
	description = "ERP is always enabled."
	default_value = TRUE
	category = "General"

/// ERP cannot be disabled. Always report true and ignore toggle requests.
/datum/erp_preference/boolean/allow_erp/get_value(datum/preferences/prefs)
	return TRUE

/datum/erp_preference/boolean/allow_erp/set_value(datum/preferences/prefs, value)
	if(!prefs?.erp_preferences)
		prefs.erp_preferences = list()
	// Ensure stored value stays TRUE for consistency
	prefs.erp_preferences[type] = TRUE

/datum/erp_preference/boolean/allow_erp/show_pref_ui(datum/preferences/prefs)
	return "<span class='pref-toggle enabled'>Always enabled</span>"

/datum/erp_preference/boolean/allow_erp/handle_topic(mob/user, list/href_list, datum/preferences/prefs)
	return

/datum/erp_preference/boolean/allow_erp/show_session_ui(datum/preferences/prefs, editable = FALSE, datum/sex_session/session)
	return "<div class='pref-toggle enabled'>Always enabled</div>"

/datum/erp_preference/boolean/allow_erp/handle_session_topic(mob/user, list/href_list, datum/preferences/prefs, datum/sex_session/session)
	return TRUE
