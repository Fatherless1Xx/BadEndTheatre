/datum/patron/pagan
	name = null
	associated_faith = /datum/faith/pagan

	profane_words = list()

	confess_lines = list(
		"We have crushed the heads of every child borne to the people of Hal'desh.",
		"No matter what, the way perseveres.",
		"Together we are stronger than anything you perverted defilers could ever hope!"
	)

/datum/patron/pagan/edledhron
	name = "Edledhron"
	desc = "It was once called the chill of Asador, the gadfly of Forostar, the brisk and conniving death of Bandama and Borea.\n\
	To his followers, he is the Arbiter of Fates, the Guardian of Graves and the Scriber of Statutes whose words will ever be observed.\n\
	That he is the de-facto leader of the Pact is testament to the rapacity of Death and the devious trickery employed to ensure that all under the Pact follow His protocol.\n\
	\n\
	It is considered a fell omen to speak his name, for it is said he laughs whenver it is spoken, and ill luck befalls those who speak his name in vain."
	flaws = "Narrow-Mindedness, Seen with Distrust by Other Members of the Pact, Edledhron's Attention is Upon You."
	sins = "Failure to adhere to the letter of His Law, Decapitating the Dead, Leniency, Violations of the Body, Failure to Protect a Faithful of the Pact."
	boons = "An inherent capability to lead people."
	worshippers = "Lawmen, Sages, Scholars, Gravetenders, the Diseased, the Elderly, and Thieves."
	added_traits = list(TRAIT_NO_REFLECTION, TRAIT_FEARLESS)

	devotion_holder = /datum/devotion/pagan/edledhron

/datum/patron/pagan/zhakral
	name = "Zhakral"
	desc = "Blood flows hotter when in the throes of abject pleasure. Yet pleasure itself is not the most important thing in life.\n\
	But there is a special kind of blood-joy one indulges in when doing battle against a mighty enemy, and those who do battle are ever recorded in the grisly halls of Zhakral's warriors.\n\
	Worshippers deemed worthy are taken to the halls to partake in the bacchanal feast-orgy for all eternity.\n\
	A warrior may do as he wishes with the spoils of war, after all, and a warrior always makes his living off the battlefield.\n\
	Any other path in life is utter cowardice."
	flaws = "Bravado, inability to partake in discretion, bloodthirst."
	sins = "Cowardice, surrendering, allowing one not of the Pact to insult the Pact, refusal to indulge in a deep-seated pleasure."
	boons = "A fearsome countenance."
	worshippers = "Warriors, Guardsmen, Bandits, Tacticians and Generals, the Ogrish Tribes, Bards, Lovefiends"

	added_traits = list(TRAIT_STEELHEARTED, TRAIT_STRONGBITE, TRAIT_NOSEGRAB)
	confess_lines = list(
		"Aaaaugghh!!!",
		"P-please don't kill me I'll suck your dick PLEASE!!!",
		"I can't take it anymore!! STOP!!",
		"N-no don't!!!"
	)

	devotion_holder = /datum/devotion/pagan/zhakral

/datum/patron/pagan/tsaiya
	name = "Tsaiya"
	desc = "It is perhaps unsurprising that the merciless force that is Tsaiya holds sympathy for those downtrodden masses.\n\
	They have been shackled by the trappings of 'civilization', of 'aristrocracy' that attempts to live outside natural forces.\n\
	False friendships are formed and gluttonous pigs hide themselves in castles.\n\
	But their shells of stone will not protect them from what will very soon come to them. It will be a massacre and the Wyld will claim all that belongs to it.\n\
	It will be the day the common lot takes its place at the high table and tear apart the 'civilization' that robbed them of their freedom.\n\
	And at last the natural cycles will find their place restored."
	flaws = "Naivete, impossible dreams, uncouth manners, feral behaviour, difficulties prosetylizing."
	sins = "Restricting one's freedom, making an attempt to live outside the cycles of nature, besmirching the sanctity of nature, rejecting the hunt, partaking in the use of indulgent machinery, tax collection."
	boons = "You are blessed by the Moon."
	worshippers = "Peasants, farmers, rebels, freedom-fighters, hunters, radicals, homosexuals"

	added_traits = list(TRAIT_POISONBITE, TRAIT_TOLERANT, TRAIT_BRUSHWALK, TRAIT_WEBWALK)
