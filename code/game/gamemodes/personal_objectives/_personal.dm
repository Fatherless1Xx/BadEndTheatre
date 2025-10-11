/datum/objective/personal
	name = "Generic Personal Objective"
	var/category = "Personal"
	var/list/immediate_effects
	var/list/rewards

/datum/objective/personal/on_creation()
	. = ..()
	if(owner && !(owner in GLOB.personal_objective_minds))
		GLOB.personal_objective_minds |= owner

/datum/objective/personal/proc/escalate_objective(event_track = EVENT_TRACK_PERSONAL, second_event_track = EVENT_TRACK_INTERVENTION)
	if(event_track)
		var/first_points_to_add = SSgamemode.point_thresholds[event_track] * rand(0.5, 0.75)
		SSgamemode.event_track_points[event_track] += first_points_to_add
	if(second_event_track)
		var/second_points_to_add = SSgamemode.point_thresholds[second_event_track] * rand(0.05, 0.1)
		SSgamemode.event_track_points[second_event_track] += second_points_to_add
