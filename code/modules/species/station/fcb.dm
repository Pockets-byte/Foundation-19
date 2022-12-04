/datum/species/fcb
	name = SPECIES_FCB
	name_plural = "Humans"
	primitive_form = "Monkey"
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch, /datum/unarmed_attack/bite)
	description = "Humanity originated in the Sol system, and over the last five centuries has spread \
	colonies across a wide swathe of space. They hold a wide range of forms and creeds.<br/><br/> \
	While the central Sol government maintains control of its far-flung people, powerful corporate \
	interests, rampant cyber and bio-augmentation and secretive factions make life on most human \
	worlds tumultous at best."
	assisted_langs = list(LANGUAGE_NABBER)
	min_age = 18
	max_age = 100
	cold_level_1 = SYNTH_COLD_LEVEL_1
	cold_level_2 = SYNTH_COLD_LEVEL_2
	cold_level_3 = SYNTH_COLD_LEVEL_3

	heat_level_1 = SYNTH_HEAT_LEVEL_1		// Gives them about 25 seconds in space before taking damage
	heat_level_2 = SYNTH_HEAT_LEVEL_2
	heat_level_3 = SYNTH_HEAT_LEVEL_3
	var/oxy_mod = 2
	hidden_from_codex = FALSE
	bandages_icon = 'icons/mob/bandage.dmi'

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_NO_FBP_CONSTRUCTION | SPECIES_IS_WHITELISTED
	appearance_flags = HAS_HAIR_COLOR | HAS_SKIN_TONE_NORMAL | HAS_LIPS | HAS_UNDERWEAR | HAS_EYE_COLOR

	sexybits_location = BP_GROIN

	inherent_verbs = list(/mob/living/carbon/human/proc/tie_hair)

	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_HUMAN_EARTH,
			CULTURE_HUMAN_ARABIC,
			CULTURE_HUMAN_BRITISH,
			CULTURE_HUMAN_CHINESE,
			CULTURE_HUMAN_EASTSLAVIC,
			CULTURE_HUMAN_FRENCH,
			CULTURE_HUMAN_GERMAN,
			CULTURE_HUMAN_GOIDELIC,
			CULTURE_HUMAN_ITALIAN,
			CULTURE_HUMAN_JAPANESE,
			CULTURE_HUMAN_LATINAMERICAN
		)
	)

	exertion_effect_chance = 10
	exertion_hydration_scale = 1
	exertion_charge_scale = 1
	exertion_reagent_scale = 5
	exertion_reagent_path = /datum/reagent/lactic_acid
	exertion_emotes_biological = list(
		/decl/emote/exertion/biological,
		/decl/emote/exertion/biological/breath,
		/decl/emote/exertion/biological/pant
	)
	exertion_emotes_synthetic = list(
		/decl/emote/exertion/synthetic,
		/decl/emote/exertion/synthetic/creak
	)

	has_limbs = list(
		BP_CHEST =  list("path" = /obj/item/organ/external/chest),
		BP_ALL_LIMBS =  list("path" = /obj/item/organ/external/robot)
	)
	has_organ = list(
		BP_EYES = /obj/item/organ/internal/eyes/robot
	)

/datum/species/human/get_bodytype(var/mob/living/carbon/human/H)
	return SPECIES_HUMAN

/datum/species/human/handle_npc(var/mob/living/carbon/human/H)
	if(H.stat != CONSCIOUS)
		return

	if(H.get_shock() && H.shock_stage < 40 && prob(3))
		H.emote(pick("moan","groan"))

	if(H.shock_stage > 10 && prob(3))
		H.emote(pick("cry","whimper"))

	if(H.shock_stage >= 40 && prob(3))
		H.emote("scream")

	if(!H.restrained() && H.lying && H.shock_stage >= 60 && prob(3))
		H.custom_emote("thrashes in agony")

	if(!H.restrained() && H.shock_stage < 40 && prob(3))
		var/maxdam = 0
		var/obj/item/organ/external/damaged_organ = null
		for(var/obj/item/organ/external/E in H.organs)
			if(!E.can_feel_pain()) continue
			var/dam = E.get_damage()
			// make the choice of the organ depend on damage,
			// but also sometimes use one of the less damaged ones
			if(dam > maxdam && (maxdam == 0 || prob(50)) )
				damaged_organ = E
				maxdam = dam
		if(damaged_organ)
			if(damaged_organ.status & ORGAN_BLEEDING)
				H.custom_emote("clutches [H.p_their()] [damaged_organ.name], trying to stop the blood.")
			else if(damaged_organ.status & ORGAN_BROKEN)
				H.custom_emote("holds [H.p_their()] [damaged_organ.name] carefully.")
			else if(damaged_organ.burn_dam > damaged_organ.brute_dam && damaged_organ.organ_tag != BP_HEAD)
				H.custom_emote("blows on [H.p_their()] [damaged_organ.name] carefully.")
			else
				H.custom_emote("rubs [H.p_their()] [damaged_organ.name] carefully.")

		for(var/obj/item/organ/I in H.internal_organs)
			if((I.status & ORGAN_DEAD) || BP_IS_ROBOTIC(I)) continue
			if(I.damage > 2) if(prob(2))
				var/obj/item/organ/external/parent = H.get_organ(I.parent_organ)
				H.custom_emote("clutches [H.p_their()] [parent.name]!")

/datum/species/human/get_ssd(var/mob/living/carbon/human/H)
	if(H.stat == CONSCIOUS)
		return "staring blankly, not reacting to your presence"
	return ..()
