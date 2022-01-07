--[[
__Needed Additions
Add lb1,2,3 toggle.
 Don't Reserve SoulSLice Finale

__QOL
Add Skill Icons, teleport and return, mount.

__To Be Implemented
Add <Arcane Crest> reaction.

]]

-- Create the basic profile table.
local profile = {}
 
-- Create a classes table, to specify which classes this profile can be used for.
profile.classes = {
    [FFXIV.JOBS.REAPER] = true,
} 


-- Create a GUI table, to hold GUI-related information.
profile.GUI = {
    open = false,
    visible = true,
    name = "Options Menu",
}

profile.UI_QuickActionBar = {
    open = true,
    visible = true,
	name = "Combat Toggles"
}

profile.UI_DevMonitor = {
    open = true,
    visible = true,
	name = "Info Monitor"
}

profile.UI_SkillHistory = {
    open = true,
    visible = true,
	name = "Skill History"
}


	local icon_folder = (GetStartupPath() .. "\\GUI\\H_UI_Icons\\")

	local settingTargetChangeDelayLow = 120
	local settingTargetChangeDelayHigh = 180

-- _______________________________________<Skill Variables Storage>
	local PulseRate = gPulseTime*0.001

	local ReaperSkills = {}
	local skill_id_tbl = {}

	local DebugActivation = false

	-- DOn't make my mistake, form your primary table using format   tbl[num skill_id] = ActionList:Get(1, 3) for example, then use that table to create conversion table if needed.

    local sprint 						= ActionList:Get(1, 3)		;	ReaperSkills["sprint"]					= sprint				;	skill_id_tbl[3] = "sprint"
    local braver						= ActionList:Get(1, 200)	;	ReaperSkills["braver"]					= braver				;	skill_id_tbl[200] = "braver"
    local bladedance 					= ActionList:Get(1, 201)	;	ReaperSkills["bladedance"]				= bladedance			;	skill_id_tbl[201] = "bladedance"
    local final_heaven 					= ActionList:Get(1, 202)	;	ReaperSkills["final_heaven"]			= final_heaven			;	skill_id_tbl[202] = "final_heaven"

	-- <Defense> oGCD
    local arcane_crest 					= ActionList:Get(1, 24404)	;	ReaperSkills["arcane_crest"]			= arcane_crest			;	skill_id_tbl[24404] = "arcane_crest"
    local arcane_circle 				= ActionList:Get(1, 24405)	;	ReaperSkills["arcane_circle"]			= arcane_circle			;	skill_id_tbl[24405] = "arcane_circle"
    local second_wind 					= ActionList:Get(1, 7541)	;	ReaperSkills["second_wind"] 			= second_wind			;	skill_id_tbl[7541] = "second_wind"
    local bloodbath 					= ActionList:Get(1, 7542)	;	ReaperSkills["bloodbath"] 				= bloodbath				;	skill_id_tbl[7542] = "bloodbath"
    local arms_length 					= ActionList:Get(1, 7548)	;	ReaperSkills["arms_length"] 			= arms_length			;	skill_id_tbl[7548] = "arms_length"

	-- <Buffs> oGCD
    local enshroud 						= ActionList:Get(1, 24394)	;	ReaperSkills["enshroud"] 				= enshroud				;	skill_id_tbl[24394] = "enshroud"
    local true_north 					= ActionList:Get(1, 7546)	;	ReaperSkills["true_north"] 				= true_north			;	skill_id_tbl[7546] = "true_north"

	-- <Buffs> GCD
	local soulsow 						= ActionList:Get(1, 24387)	;	ReaperSkills["soulsow"] 				= soulsow				;	skill_id_tbl[24387] = "soulsow"

	-- <Special> oGCD Distance
    local hells_egress 					= ActionList:Get(1, 24402)	;	ReaperSkills["hells_egress"] 			= hells_egress			;	skill_id_tbl[24402] = "hells_egress"
    local hells_ingress 				= ActionList:Get(1, 24401)	;	ReaperSkills["hells_ingress"]			= hells_ingress			;	skill_id_tbl[24401] = "hells_ingress"
    local regress 						= ActionList:Get(1, 24403)	;	ReaperSkills["regress"]	   				= regress				;	skill_id_tbl[24403] = "regress"

	-- <Offense> GCD Multi-Target
	local plentiful_harvest				= ActionList:Get(1, 24385)	;	ReaperSkills["plentiful_harvest"]		= plentiful_harvest		;	skill_id_tbl[24385] = "plentiful_harvest"
    local guillotine 					= ActionList:Get(1, 24384)	;	ReaperSkills["guillotine"]				= guillotine			;	skill_id_tbl[24384] = "guillotine"
	--
	local communio 						= ActionList:Get(1, 24398)	;	ReaperSkills["communio"]				= communio				;	skill_id_tbl[24398] = "communio"
	local lemures_scythe				= ActionList:Get(1, 24400)	;	ReaperSkills["lemures_scythe"] 			= lemures_scythe		;	skill_id_tbl[24400] = "lemures_scythe"
	--
    local grim_reaping 					= ActionList:Get(1, 24397)	;	ReaperSkills["grim_reaping"] 			= grim_reaping			;	skill_id_tbl[24397] = "grim_reaping"
	--
    local harvest_moon 					= ActionList:Get(1, 24388)	;	ReaperSkills["harvest_moon"] 			= harvest_moon			;	skill_id_tbl[24388] = "harvest_moon"
	--
    local whorl_of_death 				= ActionList:Get(1, 24379)	;	ReaperSkills["whorl_of_death"] 			= whorl_of_death		;	skill_id_tbl[24379] = "whorl_of_death"
    local spinning_scythe 				= ActionList:Get(1, 24376)	;	ReaperSkills["spinning_scythe"] 		= spinning_scythe		;	skill_id_tbl[24376] = "spinning_scythe"
    local nightmare_scythe 				= ActionList:Get(1, 24377)	;	ReaperSkills["nightmare_scythe"] 		= nightmare_scythe		;	skill_id_tbl[24377] = "nightmare_scythe"

	-- <Offense> GCD Single-Target
    local gallows 						= ActionList:Get(1, 24383)	;	ReaperSkills["gallows"] 				= gallows				;	skill_id_tbl[24383] = "gallows"
    local gibbet 						= ActionList:Get(1, 24382)	;	ReaperSkills["gibbet"] 					= gibbet				;	skill_id_tbl[24382] = "gibbet"
	--
	local lemures_slice 				= ActionList:Get(1, 24399)	;	ReaperSkills["lemures_slice"] 			= lemures_slice			;	skill_id_tbl[24399] = "lemures_slice"
	--
    local cross_reaping 				= ActionList:Get(1, 24396)	;	ReaperSkills["cross_reaping"] 			= cross_reaping			;	skill_id_tbl[24396] = "cross_reaping"
    local void_reaping 					= ActionList:Get(1, 24395)	;	ReaperSkills["void_reaping"] 			= void_reaping			;	skill_id_tbl[24395] = "void_reaping"
	--
    local infernal_slice 				= ActionList:Get(1, 24375)	;	ReaperSkills["infernal_slice"] 			= infernal_slice		;	skill_id_tbl[24375] = "infernal_slice"
    local waxing_slice 					= ActionList:Get(1, 24374)	;	ReaperSkills["waxing_slice"] 			= waxing_slice			;	skill_id_tbl[24374] = "waxing_slice"
	local slice 						= ActionList:Get(1, 24373)	;	ReaperSkills["slice"] 					= slice					;	skill_id_tbl[24373] = "slice"
    local shadow_of_death 				= ActionList:Get(1, 24378)	;	ReaperSkills["shadow_of_death"] 		= shadow_of_death		;	skill_id_tbl[24378] = "shadow_of_death"
    local harpe 						= ActionList:Get(1, 24386)	;	ReaperSkills["harpe"] 					= harpe					;	skill_id_tbl[24386] = "harpe"

	-- <Offense> oGCD Multi-Target
    local gluttony 						= ActionList:Get(1, 24393)	;	ReaperSkills["gluttony"] 				= gluttony				;	skill_id_tbl[24393] = "gluttony"
    local grim_swathe 					= ActionList:Get(1, 24392)	;	ReaperSkills["grim_swathe"] 			= grim_swathe			;	skill_id_tbl[24392] = "grim_swathe"
	--
    local unveiled_gibbet 				= ActionList:Get(1, 24390)	;	ReaperSkills["unveiled_gibbet"] 		= unveiled_gibbet		;	skill_id_tbl[24390] = "unveiled_gibbet"
    local unveiled_gallows 				= ActionList:Get(1, 24391)	;	ReaperSkills["unveiled_gallows"] 		= unveiled_gallows		;	skill_id_tbl[24391] = "unveiled_gallows"
	local blood_stalk 					= ActionList:Get(1, 24389)	;	ReaperSkills["blood_stalk"] 			= blood_stalk			;	skill_id_tbl[24389] = "blood_stalk"
	--
    local soul_scythe 					= ActionList:Get(1, 24381)	;	ReaperSkills["soul_scythe"] 			= soul_scythe			;	skill_id_tbl[24381] = "soul_scythe"

	-- <Offense> oGCD Single-Target
    local soul_slice 					= ActionList:Get(1, 24380)	;	ReaperSkills["soul_slice"] 				= soul_slice			;	skill_id_tbl[24380] = "soul_slice"


	local soul_reaver_initiators_tbl = { gluttony.id, grim_swathe.id, blood_stalk.id, unveiled_gallows.id, unveiled_gibbet.id }

	-- <Debuffs>
	local deaths_design_db = 2586
	local feint_db = 1195
	local legs_sweep_db = 2 -- Stun

	-- <Teammate Buffs>
	-- Dancer
	local devilment_b = 1825 
	local technical_finish_b = 1822 
	local standard_finish_b = 2105 
	-- Dragoon
	local left_eye_b = 1454
	local right_eye_b = 1453
	local battle_litany = 786

	-- <Buffs>
	local soulsow_b = 2594
	local threshold_b = 2595 -- needed for <regress>
	local enhanced_harpe_b = 2845 -- needed to instant cast Harpe.
	local enshroud_b = 2593
	local immortal_sacrifice_b = 2592 -- needed to activate <plentiful harvest>
	local arcane_circle_b = 2599
	local bloodsown_circle_b = 2972
	local circle_of_sacrifice_b = 2600
	local soul_reaver_b = 2587 -- needed to <gallows>, <gibbet>, and <guillotine>
	local enhanced_gibbet_b = 2588
	local enhanced_gallows_b = 2589
	local enhanced_void_b = 2590
	local enhanced_cross_b = 2591
	local bloodbath_b = 84
	local arms_length_b = 1209
	local true_north_b = 1250

	--<Real AOE hit range>>
	local cone_aoe_range = 7
	local ring_aoe_range = 3.5

	local gluttony_range = 25
	local gluttony_radius = 5
	local communio_range = 25
	local communio_radius = 5

	--<Cooldown Potency Values>
	local chargeValue = {}
		chargeValue.soul_slice = 460/30
		chargeValue.gluttony = 500/60

	--<Opportunity Cost>
	local smart_potency = {}

	local soul_gauge_gain = {}
	soul_gauge_gain.soul_scythe = 50
	soul_gauge_gain.soul_slice = 50
	soul_gauge_gain.deaths_design_db = 10
	soul_gauge_gain.spinning_scythe = 10
	soul_gauge_gain.nightmare_scythe = 10
	soul_gauge_gain.slice = 10
	soul_gauge_gain.waxing_slice = 10
	soul_gauge_gain.infernal_slice = 10

	local shroud_gauge_gain = {}
	shroud_gauge_gain.plentiful_harvest = 50
	shroud_gauge_gain.guillotine = 10
	shroud_gauge_gain.gibbet = 10
	shroud_gauge_gain.gallows = 10


	--<Potency Values>
	local damage_potency = {}

	 damage_potency.whorl_of_death = 100
	 damage_potency.spinning_scythe = 140
	 damage_potency.nightmare_scythe = 180
	 damage_potency.guillotine = 200
	 damage_potency.harvest_moon = {}
		 damage_potency.harvest_moon.target = 600
		 damage_potency.harvest_moon.remEn = 300
	 damage_potency.plentiful_harvest = {}
		 damage_potency.plentiful_harvest.target = {520, 560, 600, 640, 680, 720, 760, 800}
		 damage_potency.plentiful_harvest.remEn = {208, 224, 240, 256, 272, 288, 304, 320}


	 damage_potency.harpe = 300
	 damage_potency.shadow_of_death = 300
	 damage_potency.slice = 300
	 damage_potency.waxing_slice = 380
	 damage_potency.infernal_slice = 460
	 damage_potency.gibbet = {}
		 damage_potency.gibbet.enhanced = {}
		 damage_potency.gibbet.enhanced.posAdv = 520
		 damage_potency.gibbet.enhanced.posDis = 460
		 damage_potency.gibbet.unenhanced = {}
		 damage_potency.gibbet.unenhanced.posAdv = 460
		 damage_potency.gibbet.unenhanced.posDis = 400
	 damage_potency.gallows = {}
		 damage_potency.gallows.enhanced = {}
		 damage_potency.gallows.enhanced.posAdv = 520
		 damage_potency.gallows.enhanced.posDis = 460
		 damage_potency.gallows.unenhanced = {}
		 damage_potency.gallows.unenhanced.posAdv = 460
		 damage_potency.gallows.unenhanced.posDis = 400

	 damage_potency.soul_scythe = 180
	 damage_potency.soul_slice = 460

	 damage_potency.gluttony = {}
		 damage_potency.gluttony.target = 500
		 damage_potency.gluttony.remEn = 500 *0.75
	 damage_potency.grim_swathe = 140
	 damage_potency.blood_stalk = 340
	 damage_potency.unveiled_gibbet = 400
	 damage_potency.unveiled_gallows = 400

	 damage_potency.communio = {}
		 damage_potency.communio.target = 1000
		 damage_potency.communio.remEn = 400
	 damage_potency.grim_reaping = 200
	 damage_potency.void_reaping = {}
		 damage_potency.void_reaping.enhanced = 520
		 damage_potency.void_reaping.unenhanced = 460
	 damage_potency.cross_reaping = {}
		 damage_potency.cross_reaping.enhanced = 520
		 damage_potency.cross_reaping.unenhanced = 460

	 damage_potency.lemures_scythe = 100
	 damage_potency.lemures_slice = 200
	-- damage_potency. = 

	--<Buff Potency Calculation>
	local buff_potency = {}
		buff_potency.arcane_circle = function(potency) return potency*1.03 end




	--<Animation Locks>
	local animationLocks = {}
		animationLocks.true_north = 0.5



	local SkillTextArr = {}
	
	for k, v in pairs(ReaperSkills) do
		SkillTextArr[k] = { iname = k, name = v.name}
	end



CustomTabs_2 = GUI_CreateTabs([[Main, FinaleMode, Misc, Info Screen]])
			 -- List or Combo


local color_settings = {}
	color_settings["yellow"] = {0.95, 0.95, 0.2}
	color_settings["gold"] = {0.9, 0.9, 0.3}
	color_settings["green"] = {0.3, 0.95, 0.4}
	color_settings["darkred"] = {0.47, 0.01, 0.2}
	color_settings["darkred_2"] = {0.07, 0.07, 0.07}
	color_settings["darkred_3"] = {0.27, 0.01, 0.02}
	color_settings["red"] = {0.9, 0.2, 0.2}
	color_settings["red_2"] = {0.9, 0.3, 0.3}
	color_settings["red_3"] = {0.9, 0.4, 0.4}
	color_settings["pink"] = {0.9, 0.7, 0.7}
	color_settings["pink_purple"] = {0.9, 0.1, 0.3}
	color_settings["pink_purple_2"] = {0.9, 0.2, 0.4}
	color_settings["blue"] = {0.5, 0.5, 0.9}
	color_settings["blue_2"] = {0.3, 0.6, 0.9}
	color_settings["blue_3"] = {0.35, 0.82, 0.9}
	color_settings["blue_4"] = {0.2, 0.85, 1}

-- The Draw() function provides a place where a developer can show custom options.
function profile.Draw()


    if (profile.GUI.open) then	
		profile.GUI.visible, profile.GUI.open = GUI:Begin(profile.GUI.name, profile.GUI.open)
		if ( profile.GUI.visible ) then

			local EnshroudSettingTable = {
				[1] = "<Void Reaping>",
				[2] = "<Cross Reaping>",
				[3] = "<Random>",
			}
			local GallowGibbetSettingTable = {
				[1] = "<Gibbet>",
				[2] = "<Gallows>",
				[3] = "<Random>",
			}
			local TabIndex, TabName = GUI_DrawTabs(CustomTabs_2)

			local y_spacing = 8
			local y_spacing_2 = 0
			
			if TabIndex == 2 then

				GUI:PushItemWidth(90)
					ACR.GUIVarUpdate( GUI:InputFloat([[Save <Arcane Circle> when ETA VICTORY is lower than X seconds.]], FinaleSettingArcaneCircle),"FinaleSettingArcaneCircle")
					GUI:Dummy(0, y_spacing_2)

					ACR.GUIVarUpdate( GUI:InputFloat([[Save <Enshroud> when ETA VICTORY is lower than X seconds.]], FinaleSettingEnshroud),"FinaleSettingEnshroud")
					GUI:Dummy(0, y_spacing_2)

					ACR.GUIVarUpdate( GUI:InputFloat([[Save <Gluttony> when ETA VICTORY is lower than X seconds.]], FinaleSettingGluttony),"FinaleSettingGluttony")
					GUI:Dummy(0, y_spacing_2)
					ACR.GUIVarUpdate( GUI:InputFloat([[Save <Soul Slice> and <Soul Scythe> when ETA VICTORY is lower than X seconds.]], FinaleSettingSoulSlice),"FinaleSettingSoulSlice")
					GUI:Dummy(0, y_spacing_2)
				GUI:PopItemWidth()

				--[[
				ACR.GUIVarUpdate( GUI:Checkbox("a. Enable: ",ReserveMode), "ReserveMode")						GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["green"][1], color_settings["green"][2], color_settings["green"][3], 1, "\t\t<RESERVE>")
				ACR.GUIVarUpdate( GUI:Checkbox("b. Enable: ",DestroyMode), "DestroyMode")						GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["red"][1], color_settings["red"][2], color_settings["red"][3], 1, "\t\t<DESTROY>")
				ACR.GUIVarUpdate( GUI:Checkbox("c. Enable: ",FinaleMode), "FinaleMode")							GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["pink_purple"][1], color_settings["pink_purple"][2], color_settings["pink_purple"][3], 1, "\t\t<FINALE>")
				ACR.GUIVarUpdate( GUI:Checkbox("d. Enable: ",SmartTrueNorth), "SmartTrueNorth")					GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["yellow"][1], color_settings["yellow"][2], color_settings["yellow"][3], 1, "\t<True North> Smart Activate")
				ACR.GUIVarUpdate( GUI:Checkbox("e. Enable: ",SettingSmartAOE), "SettingSmartAOE")				GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["gold"][1], color_settings["gold"][2], color_settings["gold"][3], 1, "\t<AOE> Smart Select")
				ACR.GUIVarUpdate( GUI:Checkbox("f. Enable: ",SettingEnableAOE), "SettingEnableAOE")				GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["gold"][1], color_settings["gold"][2], color_settings["gold"][3], 1, "\t<AOE> Skills")
				ACR.GUIVarUpdate( GUI:Checkbox("g. Enable: ",SettingEnshroud), "SettingEnshroud")				GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["pink_purple"][1], color_settings["pink_purple"][2], color_settings["pink_purple"][3], 1, "\t<Enshroud>")
				ACR.GUIVarUpdate( GUI:Checkbox("h. Enable: ",SettingSoulGauge), "SettingSoulGauge")				GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["red_2"][1], color_settings["red_2"][2], color_settings["red_2"][3], 1, "\t<Soul Gauge> Skills")
				ACR.GUIVarUpdate( GUI:Checkbox("i. Enable: ",SettingArcaneCircle), "SettingArcaneCircle")		GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["pink"][1], color_settings["pink"][2], color_settings["pink"][3], 1, "\t<Arcane Circle>")
				ACR.GUIVarUpdate( GUI:Checkbox("j. Enable: ",SettingDefenses), "SettingDefenses") 				GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["blue_2"][1], color_settings["blue_2"][2], color_settings["blue_2"][3], 1, "\t\t<DEFENSE>")
				ACR.GUIVarUpdate( GUI:Checkbox("k. Enable: ",SettingArcaneCrest), "SettingArcaneCrest") 		GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["pink_purple_2"][1], color_settings["pink_purple_2"][2], color_settings["pink_purple_2"][3], 1, "\t<Arcane Crest>")
				ACR.GUIVarUpdate( GUI:Checkbox("l. Enable: ",SettingSecondWind), "SettingSecondWind") 			GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["blue_3"][1], color_settings["blue_3"][2], color_settings["blue_3"][3], 1, "\t<Second Wind>")
				ACR.GUIVarUpdate( GUI:Checkbox("m. Enable: ",SettingBloodbath), "SettingBloodbath") 			GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["red_2"][1], color_settings["red_2"][2], color_settings["red_2"][3], 1, "\t<Bloodbath>")
				]]
			elseif TabIndex == 1 then
				-- Page 2 content
				GUI:PushItemWidth(90)
					ACR.GUIVarUpdate( GUI:InputFloat([[Minimum time after stopping before attempting to recast Communio]], SettingMoveCastMin),"SettingMoveCastMin")
					if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "This is for when you cancel Communio for dodging" ) end
					GUI:Dummy(0, y_spacing_2)
					
					ACR.GUIVarUpdate( GUI:InputFloat([[Unused Placeholder]], SettingMoveCastMax),"SettingMoveCastMax")
					if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Currently Unused" ) end
					GUI:Dummy(0, y_spacing_2)
					
					ACR.GUIVarUpdate( GUI:InputFloat([[If Enemy HP is <= Player HP / THIS VALUE, then kill, don't reapply <Deaths Design>]], SettingDeathsDesignDivision),"SettingDeathsDesignDivision")
					if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Do not set as 0, setting to lower than 1 would be multiplication" ) end
					GUI:Dummy(0, y_spacing_2)
					
					ACR.GUIVarUpdate( GUI:InputFloat([[Use <Whorl of Death> if total in range enemy with <Death\'s Design> / total in range enemy is lower than this ratio.]], SettingWhorlUsage),"SettingWhorlUsage")
					GUI:Dummy(0, y_spacing_2)
					
					ACR.GUIVarUpdate( GUI:InputFloat([[Save <Gluttony> when <Arcane Circle> CD is <= Second.##HatRPRSaveGluttony]], SettingSaveGluttony),"SettingSaveGluttony")
					GUI:Dummy(0, y_spacing_2)
					
					ACR.GUIVarUpdate( GUI:InputFloat([[Save <Enshroud> and Overload <Shroud Gauge> when <Arcane Circle> CD is <= Second.##HatRPRSaveShroud]], SettingSaveShroud),"SettingSaveShroud")
					if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "This is mostly for lvl 87 sync rotation and below." ) end
					GUI:Dummy(0, y_spacing_2)
					
					ACR.GUIVarUpdate( GUI:InputInt([[When below lvl 88, Unload <Shroud Gauge> when <Shroud Gauge> is >=]], SettingUnloadShroud_low),"SettingUnloadShroud_low")
					if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "For double <enshroud> combo prior to lvl 88\n\nDon't set below 50, I didn't code in prevention errors" ) end
					GUI:Dummy(0, y_spacing)
					
					ACR.GUIVarUpdate( GUI:InputInt([[When atleast lvl 88, Unload <Shroud Gauge> when <Shroud Gauge> is >=]], SettingUnloadShroud),"SettingUnloadShroud")
					if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Don't set below 50, I didn't code in prevention errors" ) end
					GUI:Dummy(0, y_spacing)
					
					ACR.GUIVarUpdate( GUI:InputInt([[Unload <Soul Gauge> when <Soul Gauge> is >= .##HatUnloadSoul]], SettingUnloadSoul),"SettingUnloadSoul")
					if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Don't set below 50, I didn't code in prevention errors" ) end
					GUI:Dummy(0, y_spacing)
					
					ACR.GUIVarUpdate( GUI:InputFloat([[Use <Bloodbath> when HP <= this %.##HatRPRBloodbathHPP]], BloodbathHPP),"BloodbathHPP")
					GUI:Dummy(0, y_spacing_2)
					
					ACR.GUIVarUpdate( GUI:InputFloat([[Use <Second Wind> when HP <= this %.##HatRPRSecondWindHPP]], SecondWindHPP),"SecondWindHPP")
					GUI:Dummy(0, y_spacing_2)
					
					ACR.GUIVarUpdate( GUI:InputFloat([[Use <Arcane Crest> when HP <= this %.##HatRPRSecondWindHPP]], ArcaneCrestHPP),"ArcaneCrestHPP")
					GUI:Dummy(0, y_spacing)
					
					ACR.GUIVarUpdate( GUI:Checkbox("Enables Hover Tooltips",SettingHoverTooltips), "SettingHoverTooltips")
				GUI:PopItemWidth()
			elseif TabIndex == 3 then
				-- Page 3 content
				GUI:PushItemWidth(120)
					ACR.GUIVarUpdate(GUI:Combo([[<Enshroud> Combo Start Preference.##HatEnshroudSkillChoice]], EnshroudSkillChoice, EnshroudSettingTable),"EnshroudSkillChoice")
					GUI:Dummy(0, y_spacing_2)
				GUI:PopItemWidth()
				GUI:PushItemWidth(90)
					ACR.GUIVarUpdate(GUI:InputInt([[Random <Void> Weight.##HatSettingVoidWeight]], SettingVoidWeight),"SettingVoidWeight")
					GUI:Dummy(0, y_spacing_2)
					ACR.GUIVarUpdate(GUI:InputInt([[Random <Cross> Weight.##HatSettingCrossWeight]], SettingCrossWeight),"SettingCrossWeight")
					GUI:Dummy(0, y_spacing)
				GUI:PopItemWidth()
				GUI:PushItemWidth(120)
					ACR.GUIVarUpdate(GUI:Combo([[<Gibbet or Gallows> Desperation Preference.##HatGibbetGallowsChoice]], GibbetGallowsChoice, GallowGibbetSettingTable),"GibbetGallowsChoice")
					GUI:Dummy(0, y_spacing_2)
				GUI:PopItemWidth()
				GUI:PushItemWidth(90)
					ACR.GUIVarUpdate(GUI:InputInt([[Random <Gibbet> Weight.##HatSettingGibbetWeight]], SettingGibbetWeight),"SettingGibbetWeight")
					GUI:Dummy(0, y_spacing_2)
					ACR.GUIVarUpdate(GUI:InputInt([[Random <Gallows> Weight.##HatSettingGallowsWeight]], SettingGallowsWeight),"SettingGallowsWeight")
					GUI:Dummy(0, y_spacing)
				GUI:PopItemWidth()
				GUI:PushItemWidth(90)
					ACR.GUIVarUpdate(GUI:Checkbox("Use <Soulsow> when out of combat.",OutCombatSoulSow),"OutCombatSoulSow")
					GUI:Dummy(0, y_spacing_2)
					ACR.GUIVarUpdate(GUI:InputFloat([[Random <Soulsow> Minimum -Seconds- out of combat time to activate.##HatSoulsowLow]], SettingSoulsowLow),"SettingSoulsowLow")
					GUI:Dummy(0, y_spacing_2)
					ACR.GUIVarUpdate(GUI:InputFloat([[Random <Soulsow> Maximum -Seconds- out of combat time to activate.##HatSoulsowHigh]], SettingSoulsowHigh),"SettingSoulsowHigh")
				GUI:PopItemWidth()
			elseif TabIndex == 4 then
				ACR.GUIVarUpdate(GUI:Checkbox("a. On: ",SettingIconQuickBar),"SettingIconQuickBar")		GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["blue_3"][1], color_settings["blue_3"][2], color_settings["blue_3"][3], 1, "<Quick Action Bar>")
				ACR.GUIVarUpdate(GUI:Checkbox("b. On: ",SettingCombatMonitor),"SettingCombatMonitor")		GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["blue_3"][1], color_settings["blue_3"][2], color_settings["blue_3"][3], 1, "<Combat Monitor>")
				ACR.GUIVarUpdate(GUI:Checkbox("c. On: ",SettingTargetMonitor),"SettingTargetMonitor")		GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["blue_3"][1], color_settings["blue_3"][2], color_settings["blue_3"][3], 1, "<Target Monitor>")
				ACR.GUIVarUpdate(GUI:Checkbox("f. On: ",SettingPlayerInfo),"SettingPlayerInfo")			GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["blue_3"][1], color_settings["blue_3"][2], color_settings["blue_3"][3], 1, "<Player Monitor>")
				ACR.GUIVarUpdate(GUI:Checkbox("z. On: ",SettingSkillHistory),"SettingSkillHistory")			GUI:SameLine( 0, 0 )	GUI:TextColored( color_settings["blue_3"][1], color_settings["blue_3"][2], color_settings["blue_3"][3], 1, "<Skill History>")
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Currently doesn/'t fully capture every passed skill, still working that out." ) end
			end
        end
        GUI:End()
    end

	-- Quick Icon Bar
	if SettingIconQuickBar then
		GUI:PushStyleColor(GUI.Col_WindowBg, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0.65)
		GUI:PushStyleColor(GUI.Col_TitleBg, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0.75)
		--GUI:PushStyleColor(GUI.Col_Button, color_settings["yellow"][1], color_settings["yellow"][2], color_settings["yellow"][3], 0.6)
		profile.UI_QuickActionBar.visible = true
		profile.UI_QuickActionBar.visible, profile.UI_QuickActionBar.open = GUI:Begin(profile.UI_QuickActionBar.name, profile.UI_QuickActionBar.open)


		local icon_px = 28
		local icon_spacing = 3
		local icon_spacing_break = 14
		local icon_padding = 1
		
		if ( profile.UI_QuickActionBar.visible ) then
			local current_color_value = {0.9, 0.1, 0.1, 0.5}
			local off_color_value = {0.4, 0.4, 0.4, 0.8}
			local on_color_value = {1, 1, 1, 1}
			if ReserveMode then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("ReserveMode", icon_folder .. "braver_e2.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables <Reserve>, ACR will save bursts CD\n\n\t\tSupersede <Destroy> and <Finale>" ) end
				if GUI:IsItemClicked() then
					if ReserveMode then ACR.GUIVarUpdate(false, "ReserveMode") else ACR.GUIVarUpdate(true, "ReserveMode") end
				end
				GUI:SameLine( 0, icon_spacing )
			if DestroyMode then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("DestroyMode", icon_folder .. "braver_e1.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables <Destroy>, ACR will obliterate target to smithereens\n\n\t\tSupersede <Finale>" ) end
				if GUI:IsItemClicked() then
					if DestroyMode then ACR.GUIVarUpdate(false, "DestroyMode") else ACR.GUIVarUpdate(true, "DestroyMode") end
				end
				GUI:SameLine( 0, icon_spacing_break )
			if FinaleMode then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("FinaleMode", icon_folder .. "braver_e3.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables <Finale>, ACR will auto <Reserve> and <Destroy> based on ETA Victory\n\n\t\tSweet Dreams are made of this" ) end
				if GUI:IsItemClicked() then
					if FinaleMode then ACR.GUIVarUpdate(false, "FinaleMode") else ACR.GUIVarUpdate(true, "FinaleMode") end
				end
				GUI:SameLine( 0, icon_spacing )
			if SmartTrueNorth then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SmartTrueNorth", icon_folder .. "true_north_e1.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: Auto-Activate <True North> only when adventageous" ) end
				if GUI:IsItemClicked() then
					if SmartTrueNorth then ACR.GUIVarUpdate(false, "SmartTrueNorth") else ACR.GUIVarUpdate(true, "SmartTrueNorth") end
				end
				GUI:SameLine( 0, icon_spacing )
			if SettingSmartAOE then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingSmartAOE", icon_folder .. "communio_e1.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: Auto-Select best target for <Gluttony>, <Communio>, Cone AOEs\n\n\t\t Note: Cone AOE have not received much testing." ) end
				if GUI:IsItemClicked() then
					if SettingSmartAOE then ACR.GUIVarUpdate(false, "SettingSmartAOE") else ACR.GUIVarUpdate(true, "SettingSmartAOE") end
				end
				GUI:SameLine( 0, icon_spacing_break )
			if SettingEnableAOE then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingEnableAOE", icon_folder .. "spinning_scythe.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <AOE> skills" ) end
				if GUI:IsItemClicked() then
					if SettingEnableAOE then ACR.GUIVarUpdate(false, "SettingEnableAOE") else ACR.GUIVarUpdate(true, "SettingEnableAOE") end
				end
				GUI:SameLine( 0, icon_spacing )
			if SettingArcaneCircle then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingArcaneCircle", icon_folder .. "arcane_circle.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <Arcane Circle>" ) end
				if GUI:IsItemClicked() then
					if SettingArcaneCircle then ACR.GUIVarUpdate(false, "SettingArcaneCircle") else ACR.GUIVarUpdate(true, "SettingArcaneCircle") end
				end
				GUI:SameLine( 0, icon_spacing )
			if SettingEnshroud then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingEnshroud", icon_folder .. "enshroud.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <Enshroud>" ) end
				if GUI:IsItemClicked() then
					if SettingEnshroud then ACR.GUIVarUpdate(false, "SettingEnshroud") else ACR.GUIVarUpdate(true, "SettingEnshroud") end
				end
				GUI:SameLine( 0, icon_spacing )
			if SettingGluttony then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingGluttony", icon_folder .. "gluttony.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <Gluttony>" ) end
				if GUI:IsItemClicked() then
					if SettingGluttony then ACR.GUIVarUpdate(false, "SettingGluttony") else ACR.GUIVarUpdate(true, "SettingGluttony") end
				end
				GUI:SameLine( 0, icon_spacing )
			if SettingSoulGauge then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingSoulGauge", icon_folder .. "soul_slice.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <Soul Scythe> and <Soul Slice>" ) end
				if GUI:IsItemClicked() then
					if SettingSoulGauge then ACR.GUIVarUpdate(false, "SettingSoulGauge") else ACR.GUIVarUpdate(true, "SettingSoulGauge") end
				end

				GUI:SameLine( 0, 0 )
			GUI:Dummy(28, 0)


				--GUI:PushStyleColor(GUI.Col_Border, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0)
				--GUI:PushStyleColor(GUI.Col_FrameBgHovered, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0)
				GUI:PushStyleColor(GUI.Col_Button, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0)
				GUI:PushStyleColor(GUI.Col_ButtonHovered, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0)
				GUI:PushStyleColor(GUI.Col_ButtonActive, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0)

				GUI:SameLine( 0, icon_spacing )
			if SettingPlaceHolder_1 then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingPlaceHolder_1", icon_folder .. "Reaper_Icon_1.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] - .04 )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "<Finale Reaper>" ) end
				--[[
				if GUI:IsItemClicked() then
					if SettingPlaceHolder_1 then ACR.GUIVarUpdate(false, "SettingPlaceHolder_1") else ACR.GUIVarUpdate(true, "SettingPlaceHolder_1") end
				end
				]]
				GUI:PopStyleColor(3)

			GUI:Dummy(icon_px, 0.6*icon_spacing)
			GUI:Dummy(0.5*icon_px, 0)
				GUI:SameLine( 0, icon_spacing )
			if SettingLimitBreak then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingLimitBreak", icon_folder .. "braver.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Currently Does Not Work, couldn't figure it out.\n\n\t\tPlaceholder TEXT: Enables: <Limit Break>" ) end
				if GUI:IsItemClicked() then
					if SettingLimitBreak then ACR.GUIVarUpdate(false, "SettingLimitBreak") else ACR.GUIVarUpdate(true, "SettingLimitBreak") end
				end

				GUI:SameLine( 0, icon_spacing )
			GUI:Dummy(icon_px + 3*icon_padding + 3*icon_spacing, 0)

				GUI:SameLine( 0, 2*icon_spacing )
			if SettingHarvestMoon then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingHarvestMoon", icon_folder .. "harvest_moon.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <Harvest Moon>" ) end
				if GUI:IsItemClicked() then
					if SettingHarvestMoon then ACR.GUIVarUpdate(false, "SettingHarvestMoon") else ACR.GUIVarUpdate(true, "SettingHarvestMoon") end
				end

				GUI:SameLine( 0, icon_spacing )
			if SettingPlentifulHarvest then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingPlentifulHarvest", icon_folder .. "plentiful_harvest.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <Plentiful Harvest>" ) end
				if GUI:IsItemClicked() then
					if SettingPlentifulHarvest then ACR.GUIVarUpdate(false, "SettingPlentifulHarvest") else ACR.GUIVarUpdate(true, "SettingPlentifulHarvest") end
				end

				GUI:SameLine( 0, 0 )
			GUI:Dummy(41, 0)

				GUI:SameLine( 0, icon_spacing)
			if SettingDefenses then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingDefenses", icon_folder .. "bulwark_e1.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <Defense> skills\n\n\tIndividual Defense Skill must also be enable to activate" ) end
				if GUI:IsItemClicked() then
					if SettingDefenses then ACR.GUIVarUpdate(false, "SettingDefenses") else ACR.GUIVarUpdate(true, "SettingDefenses") end
				end

				--GUI:SameLine( 0, 0 )
			--GUI:Dummy(0, 0)

				GUI:SameLine( 0, icon_spacing)
			if SettingArcaneCrest then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingArcaneCrest", icon_folder .. "arcane_crest.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <Arcane Crest>" ) end
				if GUI:IsItemClicked() then
					if SettingArcaneCrest then ACR.GUIVarUpdate(false, "SettingArcaneCrest") else ACR.GUIVarUpdate(true, "SettingArcaneCrest") end
				end
				GUI:SameLine( 0, icon_spacing )
			if SettingBloodbath then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingBloodbath", icon_folder .. "bloodbath.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <Bloodbath>" ) end
				if GUI:IsItemClicked() then
					if SettingBloodbath then ACR.GUIVarUpdate(false, "SettingBloodbath") else ACR.GUIVarUpdate(true, "SettingBloodbath") end
				end
				GUI:SameLine( 0, icon_spacing )
			if SettingSecondWind then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingSecondWind", icon_folder .. "second_wind.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: <Second Wind>" ) end
				if GUI:IsItemClicked() then
					if SettingSecondWind then ACR.GUIVarUpdate(false, "SettingSecondWind") else ACR.GUIVarUpdate(true, "SettingSecondWind") end
				end

				GUI:SameLine( 0, 0 )
			GUI:Dummy(28, 0)

				GUI:SameLine( 0, icon_spacing )
			if SettingLateGluttony then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("SettingLateGluttony", icon_folder .. "asphodelos_war_scythe.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) and SettingHoverTooltips then GUI:SetTooltip( "Enables: Late <Gluttony> Openor\n\n\t\t Don't enable unless about to fight boss and party is syncing buffs\n\n\t\t\tNot recommended enabling unless Player are sure party will sync. Will result DPS lost otherwise" ) end
				if GUI:IsItemClicked() then
					if SettingLateGluttony then ACR.GUIVarUpdate(false, "SettingLateGluttony") else ACR.GUIVarUpdate(true, "SettingLateGluttony") end
				end				

        end
        GUI:End()
		GUI:PopStyleColor(2)
    else
		profile.UI_QuickActionBar.visible = false
	end


	if SettingCombatMonitor or SettingTargetMonitor or SettingPlayerInfo then
		GUI:PushStyleColor(GUI.Col_WindowBg, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0.60)
		GUI:PushStyleColor(GUI.Col_TitleBg, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0.70)
		profile.UI_DevMonitor.visible = true

		local icon_px = 28
		local icon_spacing = 2
		
		profile.UI_DevMonitor.visible, profile.UI_DevMonitor.open = GUI:Begin(profile.UI_DevMonitor.name, profile.UI_DevMonitor.open)
		if ( profile.UI_DevMonitor.visible ) then


			-- <Combat Info Monitor>
			if SettingCombatMonitor then
					GUI:Text("_____Combat_____")
					GUI:Text("Enemies Average HP:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.4, 0.95, 0.4, 1, tostring(getEnemyAverageHP()) .. " %%")
					GUI:Text("Enemies Total HP:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.4, 0.95, 0.4, 1, tostring(getTotalHP()))
				
				if aoeCenterAttackableCount ~= nil and aoeCenterAttackableCount >= 3 then
					GUI:Text("Circle AOE Enemies:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0, 0.9, 0, 1, tostring(aoeCenterAttackableCount))
				elseif aoeCenterAttackableCount > 0 then 
					GUI:Text("Circle AOE Enemies:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.90, 0.90, 0.2, 1, tostring(aoeCenterAttackableCount))
				else
					GUI:Text("Circle AOE Enemies:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.9, 0, 0, 1, "0")
				end
				
				if aoeConeAttackableCount ~= nil and aoeConeAttackableCount >= 3 then
					GUI:Text("\t\tCone AOE Enemies:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0, 0.9, 0, 1, tostring(aoeConeAttackableCount))
				elseif aoeConeAttackableCount > 0 then
					GUI:Text("\t\tCone AOE Enemies:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.90, 0.90, 0.2, 1, tostring(aoeConeAttackableCount))
				else
					GUI:Text("\t\tCone AOE Enemies:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.9, 0, 0, 1, "0")
				end
				
				if HPpercentPSec ~= nil and HPpercentPSec > 0 then
					GUI:Text("%% HP Per Sec:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(1, 0.3, 0.3, 1, tostring(roundNum(HPpercentPSec,2)) .. " %%")
				end
				
				if totalPassedGCD ~= nil then
					GUI:Text("Elapse / GCD:\t")		GUI:SameLine( 0, 0 )	GUI:TextColored(0.4, 0.95, 0.4, 1, tostring(roundNum(totalPassedGCD,2)))
				end
				
				if expectedDeathTime ~= nil then
					local total_secs = roundNum(expectedDeathTime,2)
					local total_minutes = math.floor(total_secs/60)
					local remaining_secs = roundNum((total_secs - (total_minutes*60)),2)
					GUI:Text("ETA Victory:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.4, 0.95, 0.4, 1, tostring(total_minutes) .. "m " .. tostring(remaining_secs) .. "s")
				else
					GUI:Text("ETA Victory:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.95, 0.95, 0.2, 1, "No Combat")
				end
				
				if skill_Logic_name ~= "No Combat" then
					GUI:Text("Skill Logic:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.8, 0.3, 0.8, 1, tostring(skill_Logic_name))
				else
					GUI:Text("Skill Logic:\t")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.95, 0.95, 0.2, 1, tostring(skill_Logic_name))
				end
				
				if table.valid(skill_logic_icon_arr) then
					local opacity = 1.08
					local darken_value = 1.10
					for k, v in pairs(skill_logic_icon_arr) do
						opacity = opacity - 0.08
						darken_value = darken_value - 0.10
						GUI:ImageButton("Buttonskill_Logic_name" .. tostring(k), v, icon_px, icon_px, 0, 0, 1, 1, 2, 0, 0, 0, 0, darken_value, darken_value, darken_value, opacity )
							GUI:SameLine( 0, icon_spacing )
					end
					GUI:NewLine()
				end
					if MGetTarget() then
						GUI:Text("Plenty Ready :")	GUI:SameLine( 0, 0 )	GUI:TextColored(0.95, 0.95, 0.2, 1, tostring( plentiful_harvest:IsReady(MGetTarget().id)))
					end

			end


			-- <Target Info Monitor>
			if SettingTargetMonitor then
				if ValidTable(MGetTarget()) then
					GUI:Text("\n_____Target_____")
					GUI:Text(".distance2d:\t" .. tostring(MGetTarget().distance2d))
					GUI:Text(".contentid:\t" .. tostring(MGetTarget().contentid))
					GUI:Text(" hp.percent:\t" .. tostring(MGetTarget().hp.percent))
					GUI:Text(" hp.current:\t" .. tostring(MGetTarget().hp.current))
					GUI:Text(".lastcastid:\t" .. tostring(MGetTarget().castinginfo.lastcastid))
					GUI:Text(".castingid:\t" .. tostring(MGetTarget().castinginfo.castingid))
					GUI:Text(".channelingid:\t" .. tostring(MGetTarget().castinginfo.channelingid))
					GUI:Text(".channelingtime:\t" .. tostring(MGetTarget().castinginfo.channelingtime))
				end
			end

			-- <Player Info Monitor>
			if SettingPlayerInfo then
				GUI:Text("\n_____Player_____")
				GUI:Text(".lastcastid:\t" .. tostring(Player.castinginfo.lastcastid))
				GUI:Text(".castingid:\t" .. tostring(Player.castinginfo.castingid))
				GUI:Text(".channelingid:\t" .. tostring(Player.castinginfo.channelingid))
				GUI:Text(".channelingtime:\t" .. tostring(Player.castinginfo.channelingtime))
				GUI:Text("\n GetMapName:\t" .. tostring(GetMapName(Player.localmapid)))
				GUI:Text(".localmapid:\t" .. tostring(Player.localmapid))
				GUI:Text(".pos.x:\t" .. tostring(Player.pos.x))
				GUI:Text(".pos.y:\t" .. tostring(Player.pos.y))
				GUI:Text(".pos.z:\t" .. tostring(Player.pos.z))
			end


		end
		GUI:End()
		GUI:PopStyleColor(2)
	else
		profile.UI_DevMonitor.visible = false
	end


-- UI Skill History
	if SettingSkillHistory then

		profile.UI_SkillHistory.visible = true

		GUI:PushStyleColor(GUI.Col_WindowBg, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0.60)
		GUI:PushStyleColor(GUI.Col_TitleBg, color_settings["darkred_2"][1], color_settings["darkred_2"][2], color_settings["darkred_2"][3], 0.70)

		local icon_px = 28
		local icon_spacing = 3
		local icon_spacing_break = 14
		local icon_padding = 1

		profile.UI_SkillHistory.visible, profile.UI_SkillHistory.open = GUI:Begin(profile.UI_SkillHistory.name, profile.UI_SkillHistory.open)
		if ( profile.UI_SkillHistory.visible ) then

			if table.valid(skill_history_icon_arr) then
				local opacity = 1.00
				local darken_value = 1.00
				for k, v in pairs(skill_history_icon_arr) do
					--opacity = 1 opacity - 0.08
					--darken_value = 1 darken_value - 0.10
					GUI:ImageButton("Buttonskill_history_name" .. tostring(k), v, icon_px, icon_px, 0, 0, 1, 1, 2, 0, 0, 0, 0, darken_value, darken_value, darken_value, opacity )
					if k ~= 14 then
						GUI:SameLine( 0, icon_spacing )
					elseif k == 14 then
						GUI:Dummy(icon_px, 0.6*icon_spacing)
						GUI:Dummy(0.5*icon_px, 0)
						GUI:SameLine( 0, icon_spacing )
					end
				end
				GUI:NewLine()
			end

		end
		GUI:End()
		GUI:PopStyleColor(2)

	else

		profile.UI_SkillHistory.visible = false

	end




end


-- Adds a customizable header to the top of the ffxivminion task window.
function profile.DrawHeader()
 
end
 
-- Adds a customizable footer to the top of the ffxivminion task window.
function profile.DrawFooter()
 
end
 
-- The OnOpen() function is fired when a user pressed "View Profile Options" on the main ACR window.
function profile.OnOpen()
    -- Set our GUI table //open// variable to true so that it will be drawn.
    profile.GUI.open = true
end
 
-- The OnLoad() function is fired when a profile is prepped and loaded by ACR.
function profile.OnLoad()

	skill_Logic_name = "No Combat"
	skill_Logic_iname = "reaper_icon_silver"
	skill_logic_icon_arr = {}
	skill_history_icon_arr = {}

	lastTimePlayerMoved				 = os.time()
	last_skill_activation_attempt	 = os.time()
	timeLastCastStop				 = os.time()
	TimeTriedSkillActivated			 = os.time()
	ClusterCount 					 = 0
	expectedDeathTime = 0
	ReapersLastCast_id = 3
	activate_delta = false


    -- Set and (if necessary) create a saved variable named ACR_MyProfile_MySavedVar.
    SettingWhorlUsage = ACR.GetSetting("SettingWhorlUsage",0.72)
    SettingSaveGluttony = ACR.GetSetting("SettingSaveGluttony",5.5)
    SettingUnloadSoul = ACR.GetSetting("SettingUnloadSoul",50)
    SettingUnloadShroud = ACR.GetSetting("SettingUnloadShroud",90)
    SettingUnloadShroud_low = ACR.GetSetting("SettingUnloadShroud_low",90)
    SettingSaveShroud = ACR.GetSetting("SettingSaveShroud",0)
    SettingSoulsowHigh = ACR.GetSetting("SettingSoulsowHigh",3.570)
    SettingSoulsowLow = ACR.GetSetting("SettingSoulsowLow",2.740)
    SettingGibbetWeight = ACR.GetSetting("SettingGibbetWeight",1000 - 347)
    SettingGallowsWeight = ACR.GetSetting("SettingGallowsWeight",347)
    SettingVoidWeight = ACR.GetSetting("SettingVoidWeight",1000 - 277)
    SettingCrossWeight = ACR.GetSetting("SettingCrossWeight",277)
    EnshroudSkillChoice = ACR.GetSetting("EnshroudSkillChoice",3)
    GibbetGallowsChoice = ACR.GetSetting("GibbetGallowsChoice",3)
    DestroyMode = ACR.GetSetting("DestroyMode",false)
    SmartTrueNorth = ACR.GetSetting("SmartTrueNorth",true)
    SettingArcaneCircle = ACR.GetSetting("SettingArcaneCircle",true)
    SettingEnableAOE = ACR.GetSetting("SettingEnableAOE",true)
    SettingSoulGauge = ACR.GetSetting("SettingSoulGauge",true)
    SettingEnshroud = ACR.GetSetting("SettingEnshroud",true)
    BloodbathHPP = ACR.GetSetting("BloodbathHPP",67.2)
    SecondWindHPP = ACR.GetSetting("SecondWindHPP",55.6)
    ArcaneCrestHPP = ACR.GetSetting("ArcaneCrestHPP",35.4)
    SettingBloodbath = ACR.GetSetting("SettingBloodbath",true)
    SettingSecondWind = ACR.GetSetting("SettingSecondWind",true)
    OutCombatSoulSow = ACR.GetSetting("OutCombatSoulSow",true)
    ReserveMode = ACR.GetSetting("ReserveMode",false)
    SettingDefenses = ACR.GetSetting("SettingDefenses",true)
    SettingArcaneCrest = ACR.GetSetting("SettingArcaneCrest",false)
    SettingTargetMonitor = ACR.GetSetting("SettingTargetMonitor",false)
    SettingCombatMonitor = ACR.GetSetting("SettingCombatMonitor",false)
    SettingPlayerInfo = ACR.GetSetting("SettingPlayerInfo",false)
    SettingSmartAOE = ACR.GetSetting("SettingSmartAOE",false)
    SettingIconQuickBar = ACR.GetSetting("SettingIconQuickBar",true)
    FinaleMode = ACR.GetSetting("FinaleMode",true)
    SettingHoverTooltips = ACR.GetSetting("SettingHoverTooltips",true)
    SettingLimitBreak = ACR.GetSetting("SettingLimitBreak",false)
    SettingHarvestMoon = ACR.GetSetting("SettingHarvestMoon",false)
    SettingGluttony = ACR.GetSetting("SettingGluttony",true)
    SettingSkillHistory = ACR.GetSetting("SettingSkillHistory",false)
    SettingMoveCastMin = ACR.GetSetting("SettingMoveCastMin",0.35)
    SettingMoveCastMax = ACR.GetSetting("SettingMoveCastMax",0.45)
    SettingDeathsDesignDivision = ACR.GetSetting("SettingDeathsDesignDivision",3.4)
    SettingPlentifulHarvest = ACR.GetSetting("SettingPlentifulHarvest",true)
    SettingLateGluttony = ACR.GetSetting("SettingLateGluttony",false)
    SettingPlaceHolder_1 = ACR.GetSetting("SettingPlaceHolder_1",true)
    FinaleSettingSoulSlice = ACR.GetSetting("FinaleSettingSoulSlice", 9)
    FinaleSettingEnshroud = ACR.GetSetting("FinaleSettingEnshroud", 16)
    FinaleSettingGluttony = ACR.GetSetting("FinaleSettingGluttony", 20)
    FinaleSettingArcaneCircle = ACR.GetSetting("FinaleSettingArcaneCircle", 20)
end
 
-- The OnClick function is fired when a user clicks on the ACR party interface.
-- It accepts 5 parameters:
-- mouse /int/ - Possible values are 0 (Left-click), 1 (Right-click), 2 (Middle-click)
-- shiftState /bool/ - Is shift currently pressed?
-- controlState /bool/ - Is control currently pressed?
-- altState /bool/ - Is alt currently pressed?
-- entity /table/ - The entity information for the party member that was clicked on.
function profile.OnClick(mouse,shiftState,controlState,altState,entity)
 
end
 

function profile.OnUpdate(event, tickcount)

	--check if player is moving and timestamp
	if Player:IsMoving() then 
		lastTimePlayerMoved = os.time()
	end

	timeSincePlayerLastMoved = os.time() - lastTimePlayerMoved


	-- check to see if a skill activate
	local now_casting_id = Player.castinginfo.castingid
	local last_cast_id = Player.castinginfo.lastcastid

	local isNewSkill = false


--[[
-- Version 1
	if now_casting_id ~= 0 and now_casting_id ~= ReapersLastCast_id then

		isNewSkill = true
		ctivate_delta = true
		ReapersLastCast_id = now_casting_id

	elseif now_casting_id ~= 0 and now_casting_id == ReapersLastCast_id then
		if timeLastCastStop > TimeTriedSkillActivated then
			isNewSkill = true
			activate_delta = true
			ReapersLastCast_id = now_casting_id
		end
	elseif now_casting_id == 0 then
		timeLastCastStop = os.time()
	else
		TimeTriedSkillActivated = os.time()
	end
]]


-- Version 2
	if SettingCombatMonitor or SettingSkillHistory then
		if now_casting_id ~= 0 then 
			if now_casting_id ~= ReapersLastCast_id then
				isNewSkill = true
				ReapersLastCast_id = now_casting_id
			elseif now_casting_id == ReapersLastCast_id then
				TimeTriedSkillActivated = os.time()
				activate_delta = true
			end
		elseif now_casting_id == 0 then
			timeLastCastStop = os.time()
			if timeLastCastStop > TimeTriedSkillActivated and activate_delta then
				activate_delta = false
				isNewSkill = true
				ReapersLastCast_id = now_casting_id
			end
		end
	end

--[[
	-- version 3
	if now_casting_id ~= 0 then 
		if now_casting_id ~= last_cast_id then
			isNewSkill = true
			ReapersLastCast_id = now_casting_id
		elseif now_casting_id == last_cast_id then
			TimeTriedSkillActivated = os.time()
			if TimeTriedSkillActivated > timeLastCastStop then
				timeLastCastStop = os.time()
				isNewSkill = true
				ReapersLastCast_id = now_casting_id
			end
		end
	elseif now_casting_id == 0 then
		timeLastCastStop = os.time()
	end
]]


	if SettingCombatMonitor then
		if isNewSkill then
			if skill_id_tbl[ReapersLastCast_id] ~= nil then
				skill_logic_icon = (icon_folder .. skill_id_tbl[ReapersLastCast_id] .. ".png")
				if #skill_logic_icon_arr == 5 then
					table.insert(skill_logic_icon_arr, 1, skill_logic_icon )
					table.remove(skill_logic_icon_arr, 6 )
				else
					table.insert(skill_logic_icon_arr, 1, skill_logic_icon )
				end
			end
		end
	end

	if SettingSkillHistory then
		-- Skill History UI
		if isNewSkill then
			if skill_id_tbl[ReapersLastCast_id] ~= nil then
				skill_logic_icon = (icon_folder .. skill_id_tbl[ReapersLastCast_id] .. ".png")
				if #skill_history_icon_arr == 28 then
					table.insert(skill_history_icon_arr, 1, skill_logic_icon )
					table.remove(skill_history_icon_arr, 29 )
				else
					table.insert(skill_history_icon_arr, 1, skill_logic_icon )
				end
			end
		end
	end


	local TTarget = MGetTarget() or nil

	aoeConeAttackableCount = 0
	local tbl = EntityList('alive,attackable,maxdistance2d=7')
	if table.valid(tbl) then
		local count = 0
		for k, v in pairs(tbl) do
			if IsEntityHitboxFrontIfPlayerFacingTarget(v, TTarget) then
				count = count + 1
			end
			aoeConeAttackableCount = count
		end
	end


	aoeCenterAttackableCount = 0
	local tbl = EntityList('alive,attackable,maxdistance2d=4')
	if table.valid(tbl) then
		local count = 0
		for k, v in pairs(tbl) do
			if v.distance2d <= 3.5 then
				count = count + 1
			end
			aoeCenterAttackableCount = count
		end
	end

end

--[[
function inefficientFunction_1( tbl, total_index )
    for k, v in pairs(tbl) do
        table.remove( tbl, 5 )
        table.insert( tbl, , tbl[#tbl] )
    end
end
]]

	--<Functions> I'll learn to use lib eventually.
function roundNum(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end


function getTablelength(tbl)
  local count = 0
  for _ in pairs(tbl) do count = count + 1 end
  return count
end


function getCooldown(skill)
	return skill.cdmax - skill.cd
end


function getTotalHP()
	local tbl = MEntityList("alive,attackable,maxdistance2d=35")
	if (table.valid(tbl) ) then
		local sum = 0
		for k, v in pairs(tbl) do
			sum = sum + v.hp.current
		end
		return sum
	else
		return 0
	end
end


function getEnemyAverageHP()
	local tbl = MEntityList("alive,attackable,maxdistance2d=35")
	if (table.valid(tbl) ) then
		local enemyCount = getTablelength(tbl)
		local sum = 0
		for k, v in pairs(tbl) do
			sum = sum + v.hp.percent
		end
		return sum/enemyCount
	else
		return 0
	end
end



-- Accepts singular number or table of numbers of skill.id(s)
function lastCastIs(entry)
	if type(entry) == "number" then
		if Player.castinginfo.lastcastid == entry then
			return true
		end
		return false
	elseif table.valid(entry) then
		for k, v in pairs(entry) do
			if Player.castinginfo.lastcastid == v then
				return true
			end
		end
		return false
	end
	--d("Bug: Not activated. function lastCastIs()")
end

-- Accepts singular number or table of numbers of skill.id(s)
function lastCastNot(entry)
	if type(entry) == "number" then
		if Player.castinginfo.lastcastid == entry then
			return false
		end
		return true
	elseif table.valid(entry) then
		for k, v in pairs(entry) do
			if Player.castinginfo.lastcastid == v then
				return false
			end
		end
		return true
	end
	--d("Bug: Not activated. function lastCastNot()")
end


function IsEntityExactFrontIfPlayerFacingTarget(entity)
	if MGetTarget() ~= nil then
		if entity then
			if entity.id == Player.id then return false end

			local mpos = MGetTarget().pos
			local ppos = Player.pos
			local epos = entity.pos

			local playerHeading = math.atan2(mpos.x - ppos.x, mpos.z - ppos.z)
			local playerAngle = math.atan2(epos.x - ppos.x, epos.z - ppos.z)

			local deviation = playerAngle - playerHeading
			local absDeviation = math.abs(deviation)
			local leftover = math.abs(absDeviation - math.pi)
			
			if (leftover > (math.pi * 0.50) and leftover < (math.pi * 1.50)) then
				return true
			end
		end
		return false
	end
	return false
end

function IsEntityHitboxFrontIfPlayerFacingTarget(entity, target)
	local TTarget = target or nil
	if TTarget ~= nil then
		if entity then
			if entity.id == Player.id then return false end

			local mpos = TTarget.pos
			local ppos = Player.pos
			local epos = entity.pos
			
			local playerHeading = math.atan2(mpos.x - ppos.x, mpos.z - ppos.z)
			
			local eradius = entity.hitradius or 0
			--local distance = Distance2D(epos.x,epos.z,ppos.x,ppos.z)
			
			local entityHeading = math.atan2(ppos.x - epos.x, ppos.z - epos.z)
			
			local neweposx =  epos.x + eradius* math.cos(entityHeading)
			local neweposz =  epos.z + eradius* math.sin(entityHeading)

			local playerAngle = math.atan2(neweposx - ppos.x, neweposz - ppos.z)

			local deviation = playerAngle - playerHeading
			local absDeviation = math.abs(deviation)
			local leftover = math.abs(absDeviation - math.pi)
			
			if (leftover > (math.pi * 0.50) and leftover < (math.pi * 1.50)) then
				return true
			end
		end
		return false
	end
	return false
end


function GetBestConeEntityTarget(skill_range)
	local tbl = MEntityList("alive,attackable,targetable,maxdistance2d=" ..tostring( math.ceil( skill_range ) ) )
	if table.valid(tbl) then
		local count = 0
		local previousTarget = MGetTarget() or nil
		local currentTarget = MGetTarget() or nil
		local finalTarget = currentTarget
		for w, x in pairs(tbl) do
			local tempcount = 0
			for k, v in pairs(tbl) do
				if IsEntityHitboxFrontIfPlayerFacingTarget(v, x) then
					count = count + 1
				end
				if tempcount > count then
					count = tempcount
					if currentTarget ~= checkEntity then
						finalTarget = checkEntity
					end
				end
			end
		end
		ConeCount = count
		return finalTarget
	else
		return false
	end
end


function GetBestClusteredEntityTarget(skill_range, skill_radius)
	local tbl = MEntityList("alive,attackable,targetable,maxdistance2d=" ..tostring( math.ceil( skill_range + skill_radius) ) )
	if table.valid(tbl) then
		local count = 1  -- Got to include the targeted enemy as well in total count.
		local previousTarget = MGetTarget() or nil
		local currentTarget = MGetTarget() or nil
		local finalTarget = currentTarget
		for key_1, value_1 in pairs(tbl) do
			local tempcount = 1  -- Got to include the targeted enemy as well in total count.
			local centerEntity = value_1
			if centerEntity ~= nil then
				--checks to see if entity collides with other enemies in regard to Skill Radius
				--need to find distance2d between target exact and other entities distance from target w/ hitradius
				--only need to consider checkEntity's hitradius, no need to consider centerEntity's hitradius.
				for key_2, value_2 in pairs(tbl) do
					local checkEntity = value_2
					if checkEntity ~= nil and checkEntity ~= centerEntity then
						--if checkEntity ~= centerEntity then
							local exactDistance2d = Distance2D(centerEntity.pos.x, centerEntity.pos.z, checkEntity.pos.x, checkEntity.pos.z)
							local realDistance2d = exactDistance2d - checkEntity.hitradius
							if realDistance2d < skill_radius then
								tempcount = tempcount + 1
							end
							if tempcount > count then
								count = tempcount
								if currentTarget ~= checkEntity then
									finalTarget = checkEntity
								end
							end
						--end
					end
				end
			end
		end
		ClusterCount = count
		--d("SmartAOE:  " .. tostring(ClusterCount) .. "  " .. finalTarget.name)
		return finalTarget
	else
		--d("Debug: Not Activated. Function GetBestClusteredEntityTarget()")
		return false
	end
end


	--<Default Minion Function Ref>
function Distance2DT(pos1,pos2)
	assert(type(pos1) == "table","Distance3DT - expected type table for first argument")
	assert(type(pos2) == "table","Distance3DT - expected type table for second argument")

	local distance = Distance2D(pos1.x,pos1.z,pos2.x,pos2.z)
	return round(distance,2)
end

function CopyGetBestBaneTarget()
	local bestTarget = nil
	local party = EntityList.myparty
	local el = nil
	
	--Check the original diseased target, make sure it has all the required buffs, and that they're all 3 or more, blow it up, reset the best dot target.
	if (SkillMgr.bestAOE ~= 0) then
		local e = EntityList:Get(SkillMgr.bestAOE)
		if (table.valid(e) and e.alive and e.attackable and e.los and e.distance <= 25 and HasBuffs(e, "179+180+189", 3, Player.id)) then
			SkillMgr.bestAOE = 0
			return e
		end
	end
	
	--If the original target is not found, check the best target with clustered, blow it up, reset the best dot target.
	for i,member in pairs(party) do
		if (member.id ~= 0) then
			local el = MEntityList("alive,attackable,los,clustered=8,targeting="..tostring(member.id)..",maxdistance=25")
			if ( el ) then
				for k,e in pairs(el) do
					if HasBuffs(e, "179+180+189", 3, Player.id) then
						SkillMgr.bestAOE = 0
						return e
					end
				end
			end
		end
	end
	
    return nil
end
 
 
-- Other ffxivminion functions that small changes were made to make readability more enjoyable for usage.
 
function IsFlanking2(entity,dorangecheck,ignoreTrueNorth)
	if not entity or entity.id == Player.id then return false end
	local dorangecheck = IsNull(dorangecheck,true)
	
	if ignoreTrueNorth == false and (HasBuffs(Player,1250)) then return true end
	if (round(entity.pos.h,4) > round(math.pi,4) or round(entity.pos.h,4) < (-1 * round(math.pi,4))) then
		return true
	end
	
    if (entity.distance2d <= ml_global_information.AttackRange or not dorangecheck) then
        local entityHeading = nil
        
        if (entity.pos.h < 0) then
            entityHeading = entity.pos.h + 2 * math.pi
        else
            entityHeading = entity.pos.h
        end
		
		local myPos = Player.pos
        local entityAngle = math.atan2(myPos.x - entity.pos.x, myPos.z - entity.pos.z)        
        local deviation = entityAngle - entityHeading
        local absDeviation = math.abs(deviation)
        local leftover = math.abs(absDeviation - math.pi)
		
        if ((leftover < (math.pi * 1.75) and leftover > (math.pi * 1.25)) or
			(leftover < (math.pi * .75) and leftover > (math.pi * .25))) 
		then
            return true
        end
    end
	
    return false
end

function IsBehind2(entity,dorangecheck,ignoreTrueNorth)
	if not entity or entity.id == Player.id then return false end
	local dorangecheck = IsNull(dorangecheck,true)
	
	if ignoreTrueNorth == false and (HasBuffs(Player,1250)) then return true end
	if (round(entity.pos.h,4) > round(math.pi,4) or round(entity.pos.h,4) < (-1 * round(math.pi,4))) then
		return true
	end
	
    if (entity.distance2d <= ml_global_information.AttackRange or not dorangecheck) then
        local entityHeading = nil
        
        if (entity.pos.h < 0) then
            entityHeading = entity.pos.h + 2 * math.pi
        else
            entityHeading = entity.pos.h
        end
        
		local myPos = Player.pos
        local entityAngle = math.atan2(myPos.x - entity.pos.x, myPos.z - entity.pos.z)        
        local deviation = entityAngle - entityHeading
        local absDeviation = math.abs(deviation)
        local leftover = math.abs(absDeviation - math.pi)
		
        if (leftover > (math.pi * 1.75) or leftover < (math.pi * .25)) then
            return true
        end
    end
    return false
end


function PlayerHasBuffs(buffs, duration, ownerid, stacks)
	local entity = Player
	local duration = duration or 0
	local owner = ownerid or 0
	local stacks = stacks or 0
	local buffs = IsNull(tostring(buffs),"")
	
	if (table.valid(entity) and buffs ~= "") then
		local ebuffs = entity.buffs

		if (table.valid(ebuffs)) then
			for _orids in StringSplit(buffs,",") do
				local found = false
				for _andid in StringSplit(_orids,"+") do
					found = false
					for i, buff in pairs(ebuffs) do
						if (buff.id == tonumber(_andid) 
							and (stacks == 0 or stacks == buff.stacks)
							and (duration == 0 or buff.duration > duration or HasInfiniteDuration(buff.id)) 
							and (owner == 0 or buff.ownerid == owner)) 
						then 
							found = true 
						end
					end
					if (not found) then 
						break
					end
				end
				if (found) then 
					return true 
				end
			end
		end
	end
	return false
end

function PlayerMissingBuffs(buffs, duration, ownerid, stacks)
	local entity = Player
	local duration = duration or 0
	local owner = ownerid or 0
	local stacks = stacks or 0
	local buffs = IsNull(tostring(buffs),"")
	
	if (table.valid(entity) and buffs ~= "") then
		local ebuffs = entity.buffs
		
		if (table.valid(ebuffs)) then
			for _orids in StringSplit(buffs,",") do
				local missing = true
				for _andid in StringSplit(_orids,"+") do
					for i, buff in pairs(ebuffs) do
						if (buff.id == tonumber(_andid) 
							and (stacks == 0 or stacks == buff.stacks)
							and (duration == 0 or buff.duration > duration or HasInfiniteDuration(buff.id))
							and (owner == 0 or buff.ownerid == owner)) 
						then
							missing = false 
						end
					end
					if (not missing) then 
						break
					end
				end
				if (missing) then 
					return true
				end
			end
			
			return false
		end
		
		return true
	end
    
    return false
end

function TargetHasBuffs(buffs, duration, ownerid, stacks)
	local entity = MGetTarget()
	local duration = duration or 0
	local owner = ownerid or 0
	local stacks = stacks or 0
	local buffs = IsNull(tostring(buffs),"")
	
	if (table.valid(entity) and buffs ~= "") then
		local ebuffs = entity.buffs

		if (table.valid(ebuffs)) then
			for _orids in StringSplit(buffs,",") do
				local found = false
				for _andid in StringSplit(_orids,"+") do
					found = false
					for i, buff in pairs(ebuffs) do
						if (buff.id == tonumber(_andid) 
							and (stacks == 0 or stacks == buff.stacks)
							and (duration == 0 or buff.duration > duration or HasInfiniteDuration(buff.id)) 
							and (owner == 0 or buff.ownerid == owner)) 
						then 
							found = true 
						end
					end
					if (not found) then 
						break
					end
				end
				if (found) then 
					return true 
				end
			end
		end
	end
	return false
end

function TargetMissingBuffs(buffs, duration, ownerid, stacks)
	local entity = MGetTarget()
	local duration = duration or 0
	local owner = ownerid or 0
	local stacks = stacks or 0
	local buffs = IsNull(tostring(buffs),"")
	
	if (table.valid(entity) and buffs ~= "") then
		local ebuffs = entity.buffs
		
		if (table.valid(ebuffs)) then
			for _orids in StringSplit(buffs,",") do
				local missing = true
				for _andid in StringSplit(_orids,"+") do
					for i, buff in pairs(ebuffs) do
						if (buff.id == tonumber(_andid) 
							and (stacks == 0 or stacks == buff.stacks)
							and (duration == 0 or buff.duration > duration or HasInfiniteDuration(buff.id))
							and (owner == 0 or buff.ownerid == owner)) 
						then
							missing = false 
						end
					end
					if (not missing) then 
						break
					end
				end
				if (missing) then 
					return true
				end
			end
			
			return false
		end
		
		return true
	end
    
    return false
end




function ReaperActivate(string_skill)

	local eSkill = ReaperSkills[string_skill]

	skill_Logic_iname = string_skill
	skill_Logic_name = tostring(eSkill.name)
	

end










function profile.Cast()



	math.randomseed(os.time())


	-- These variables need to be updated somewhere like here, if outside this .Cast or .onUpdate, it won't update.
	local globalRecast			 = slice.recasttime
	local globalRecastPlusPulse	 = slice.recasttime + PulseRate
	local tillNextGCD			 = slice.cdmax - slice.cd
	local tillNextGCDPlusPulse 	 = PulseRate + tillNextGCD
	local lastCast 				 = Player.castinginfo.lastcastid

	local SoulGauge 			 = Player.gauge[1]
	local ShroudGauge 			 = Player.gauge[2]
	local LemureShroud  		 = Player.gauge[4]
	local VoidShroud			 = Player.gauge[5]



    local Target = MGetTarget()
	
	-- Profile Specific
	function condition_TrueNorth()
		if SmartTrueNorth and aoeCenterAttackableCount <= 2 and true_north:IsReady(Player.id) and PlayerMissingBuffs(true_north_b) and tillNextGCD <= 0.50 + PulseRate then return true else return false end
	end

	function setTargetBestCone()
		if SettingSmartAOE then
			previous_target = Target
			Player:SetTarget(GetBestConeEntityTarget(cone_aoe_range).id)
			--d("setTargetBestCone() activated")
			targetChangeTimer = os.time()
		end
	end

	function ShouldUseWhorl()
		-- CODEBLUE , string maxdistance parameter does not go decimal, got to do a whole 2d distance thing, like within bestCluster
		local tbl = MEntityList('maxdistance2d=4, attackable, targetable')
		local total_in_range = table.size(tbl)
		local missing_count = 0
		if table.valid(tbl) and total_in_range >= 3 then
			for k, v in pairs(tbl) do
				if MissingBuffs(v, deaths_design_db, globalRecastPlusPulse) then
					missing_count = missing_count + 1
				end
			end
			if missing_count / total_in_range >= SettingWhorlUsage then
				--d("True Whorl Count:" .. tostring(missing_count) .. tostring(total_in_range))
				return true
			else
				--d("False Whorl Count:" .. tostring(missing_count) ..  tostring(total_in_range))
				return false
			end
		end
		return false
	end

	function activateSoulsow()
		if soulsow.casttime == 0 and soulsow:IsReady(Player.id) then
			soulsow:Cast(Player.id)
			ReaperActivate("soulsow")
			return true
		end
	end

	-- If out of combat.
	if not table.valid(MEntityList('attackable,alive,aggro')) or not ValidTable(Player:GetEnmityList()) then
		time_last_nocombat = os.time()
		if highestHPpool ~= 0 then
			highestHPpool = 0
		end

		if OutCombatSoulSow and PlayerMissingBuffs(soulsow_b) then
			if time_last_aggro ~= nil then
				out_of_combat_time = os.time() - time_last_aggro
			else activateSoulsow()
			end
			if out_of_combat_time ~= nil then
				local time_to_defeat = math.random(SettingSoulsowLow*1000000, SettingSoulsowHigh*1000000)
				local time_to_defeat = time_to_defeat/1000000
				if	out_of_combat_time >= time_to_defeat then
					activateSoulsow()
				end
			end
		end
	

	-- If in combat.
	--if table.valid(Player:GetEnmityList()) then
	else
		time_last_aggro = os.time()
		
		if highestHPpool == nil then
			highestHPpool = 0
		end
		

		local temp_v = getTotalHP()
		
		if temp_v > highestHPpool then
			highestHPpool = temp_v	
			timeOfHighest = os.time()
		end

		timeSinceHighest = os.time() - timeOfHighest

		if timeSinceHighest > 0 and getTotalHP() > 0 and highestHPpool > 0 then
			TotalHPpercent = getTotalHP()/highestHPpool
			TotalHPdown = 1 - TotalHPpercent
			HPpercentPSec = 100*(TotalHPdown/timeSinceHighest)
		end
		
		if TotalHPpercent ~= nil then
			local ed1 = (TotalHPpercent*100)/HPpercentPSec
				if ed1 > 0 then
					_G.expectedDeathTime = ed1
				else
					_G.expectedDeathTime = 0
				end
		end
		if timeSinceHighest ~= nil then
			local ed2 = timeSinceHighest/globalRecast
				if ed2 > 0 then
					_G.totalPassedGCD = ed2
				else 
					_G.totalPassedGCD = 0
				end
		end

		-- Changes target back from Auto-Targetting.
		if previous_target ~= Target and previous_target ~= nil then
			local checker_value = math.random(settingTargetChangeDelayLow, settingTargetChangeDelayHigh)
			if targetChangeTimer ~= nil then
				if os.time() - targetChangeTimer >= checker_value then
					Player:SetTarget(previous_target.id)
					previous_target = nil
					targetChangeTimer = nil
				end
			end
		end

		-- <START>


		-- Activates <Arcane Circle>, attempts to maximize effective buff time.
		if not ReserveMode and tillNextGCD <= 0.50 + PulseRate and PlayerMissingBuffs(arcane_circle_b) then
			if not FinaleMode or expectedDeathTime >= FinaleSettingArcaneCircle then
				if SettingArcaneCircle and arcane_circle:IsReady(Player.id) then
					if PlayerHasBuffs(enshroud_b, 1.5) then
						arcane_circle:Cast(Player.id)
						ReaperActivate("arcane_circle")
						return true
					end
					--if (SoulGauge >= 50 and getCooldown(soul_slice) <= (12 - globalRecast) and (LemureShroud >= 50)) or (LemureShroud >= 40 and Player.lastcomboid == waxing_slice.id ) or DestroyMode then
					if getCooldown(soul_slice) <= (12 - globalRecast) and (LemureShroud >= 50 or LemureShroud <= 30 or DestroyMode) then
						if TargetHasBuffs(deaths_design_db, 20 + globalRecast, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) then
							arcane_circle:Cast(Player.id)
							ReaperActivate("arcane_circle")
							return true
						elseif shadow_of_death:IsReady(Target.id) then
							shadow_of_death:Cast(Target.id)
							ReaperActivate("shadow_of_death")
							return true
						end
					end
				end
			end
		end

		if	tillNextGCD >= 0.25 + PulseRate then
			if SettingDefenses then
				if SettingArcaneCrest and Player.hp.percent <= ArcaneCrestHPP and arcane_crest:IsReady(Player.id) then
					arcane_crest:Cast(Player.id)
					ReaperActivate("arcane_crest")
					return true
				end
				if SettingSecondWind and Player.hp.percent <= SecondWindHPP and second_wind:IsReady(Player.id) then
					second_wind:Cast(Player.id)
					ReaperActivate("second_wind")
					return true
				end
				if SettingBloodbath and Player.hp.percent <= BloodbathHPP and bloodbath:IsReady(Player.id) then
					bloodbath:Cast(Player.id)
					ReaperActivate("bloodbath")
					return true
				end
			end
		end
		
		-- 2* globalRecast servers as a buffer.
		if not ReserveMode and SettingGluttony and ( not SettingLateGluttony or os.time() - time_last_nocombat >= 5* globalRecast + 4* void_reaping.recasttime + 2.50 - 2* globalRecast ) and SoulGauge >= 50 and getCooldown(gluttony) == 0 and lastCastNot(soul_reaver_initiators_tbl) then
			if not FinaleMode or expectedDeathTime >= FinaleSettingGluttony then
				if SettingSmartAOE then
					previous_target = MGetTarget()
					Player:SetTarget(GetBestClusteredEntityTarget(gluttony_range, gluttony_radius).id)
					targetChangeTimer = os.time()
				end
				if gluttony:IsReady(Target.id) then
					gluttony:Cast(Target.id)
					ReaperActivate("gluttony")
				end
			end
		end
		
		if not Player:IsMoving() and timeSincePlayerLastMoved >= SettingMoveCastMin and LemureShroud == 1 and VoidShroud == 0 and PlayerHasBuffs(enshroud_b, 1.25) then
			if SettingSmartAOE then
				previous_target = MGetTarget()
				Player:SetTarget(GetBestClusteredEntityTarget(communio_range, communio_radius).id)
				targetChangeTimer = os.time()
			end
			if communio:IsReady(MGetTarget().id) then
				communio:Cast(MGetTarget().id)
				ReaperActivate("communio")
				return true
			end
		end
	end


	-- START
	if (Target) ~= nil then

--[[
		-- <Limit Break)
		if SettingLimitBreak then
			if final_heaven:IsReady(Target.id) then
				final_heaven:Cast(Target.id)
				
			elseif bladedance:IsReady(Target.id) then
				bladedance:Cast(Target.id)
				
			-- I have no idea why, but these two lines just breaks thing. I'm assuming it's how variable <braver> is assigned.
			-- but i cannot figure this out.
			--elseif braver:IsReady(Target.id) then
				--braver:Cast(Target.id)
				
			end
		end
]]








		-- <Soul Reaver Buff Active>
		if PlayerHasBuffs(soul_reaver_b, tillNextGCD) or lastCastIs(soul_reaver_initiators_tbl) then
			if SettingEnableAOE and guillotine:IsReady(Target.id) and aoeConeAttackableCount >= 3 then
				setTargetBestCone()
				guillotine:Cast(Target.id)
				ReaperActivate("guillotine")
				return true
			end
			--<Should Player activate <True North> based on position?>
			if PlayerHasBuffs(enhanced_gallows_b, globalRecast) and not IsBehind2(Target,true,true) then
				if condition_TrueNorth() then
					true_north:Cast(Player.id)
					ReaperActivate("true_north")
					return true
				end
			end
			if PlayerHasBuffs(enhanced_gibbet_b, globalRecast) and not IsFlanking2(Target,true,true) then
				if condition_TrueNorth() then
					true_north:Cast(Player.id)
					ReaperActivate("true_north")
					return true
				end
			end
			if not IsFlanking2(Target,true,true) and not IsBehind2(Target,true,true) then
				if condition_TrueNorth() then
					true_north:Cast(Player.id)
					ReaperActivate("true_north")
					return true
				end
			end
			-- <Which enhance buff does player have if any?>
			if PlayerHasBuffs(enhanced_gibbet_b, globalRecast) and gibbet:IsReady(Target.id) then
				gibbet:Cast(Target.id)
				ReaperActivate("gibbet")
				return true
			end
			if PlayerHasBuffs(enhanced_gallows_b, globalRecast) and gallows:IsReady(Target.id) then
				gallows:Cast(Target.id)
				ReaperActivate("gallows")
				return true
			end
			-- <Player has neither Enhance buff. Check and prioritize Position.>
			if IsFlanking2(Target,true,true) and gibbet:IsReady(Target.id) then
				gibbet:Cast(Target.id)
				ReaperActivate("gibbet")
				return true
			end
			if IsBehind2(Target,true,true) and gallows:IsReady(Target.id) then
				gallows:Cast(Target.id)
				ReaperActivate("gallows")
				return true
			end
			-- <Player has neither position brute activate gg.>
			if GibbetGallowsChoice == 1 and gibbet:IsReady(Target.id) then
						gibbet:Cast(Target.id)
						ReaperActivate("gibbet")
						return true
			elseif GibbetGallowsChoice == 2 and gallows:IsReady(Target.id) then
						gallows:Cast(Target.id)
						ReaperActivate("gallows")
						return true
			elseif GibbetGallowsChoice == 3 then
				if math.random(1, SettingGibbetWeight + SettingGallowsWeight) <= SettingGallowsWeight and gibbet:IsReady(Target.id) then
					gibbet:Cast(Target.id)
					ReaperActivate("gibbet")
					return true
				elseif gallows:IsReady(Target.id) then
					gallows:Cast(Target.id)
					ReaperActivate("gallows")
					return true
				end
			end
		end


		-- No <Soul Reaver> 

		if PlayerMissingBuffs(soul_reaver_b) then

			-- Super <Plentiful Harvest>
			if SettingEnableAOE and SettingPlentifulHarvest then
				if PlayerMissingBuffs(arcane_circle_b, 8.5 + globalRecast) or PlayerMissingBuffs(immortal_sacrifice_b, globalRecastPlusPulse) or expectedDeathTime <= 3*globalRecast then
					if plentiful_harvest:IsReady(Target.id) and (TargetHasBuffs(deaths_design_db, tillNextGCD, Player.id)  or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) ) then
						plentiful_harvest:Cast(Target.id)
						ReaperActivate("plentiful_harvest")
						d("Plentiful Gamma")
						return true
					end
				end
			end





		-- oGCD





			-- Use <Soul Gauge>
			if not ReserveMode and ( not SettingLateGluttony or os.time() - time_last_nocombat >= 5* globalRecast + 4* void_reaping.recasttime + 2.50 - 2* globalRecast ) then
				if PlayerMissingBuffs(immortal_sacrifice_b) or PlayerHasBuffs(arcane_circle_b, 16) then
					if gluttony:IsReady(Target.id) and lastCastNot(soul_reaver_initiators_tbl) and PlayerMissingBuffs(soul_reaver_b) and ( TargetHasBuffs(deaths_design_db, globalRecast*2, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) ) then
						if not FinaleMode and expectedDeathTime >= FinaleSettingGluttony then
							if SettingGluttony and DestroyMode and (PlayerMissingBuffs(arcane_circle_b, globalRecast) or getCooldown(arcane_circle) >= SettingSaveGluttony) then
								if SettingSmartAOE and PlayerMissingBuffs(soul_reaver_b) and lastCastNot(soul_reaver_initiators_tbl) then
									previous_target = MGetTarget()
									Player:SetTarget(GetBestClusteredEntityTarget(gluttony_range, gluttony_radius).id)
									targetChangeTimer = os.time()
								end
								gluttony:Cast(Target.id)
								ReaperActivate("gluttony")
								return true
							end
						end
					elseif DestroyMode or PlayerHasBuffs(arcane_circle_b, 1) or (getCooldown(soul_slice) <= globalRecast*2 and SoulGauge >= 50) or SoulGauge >= SettingUnloadSoul then --[[getCooldown(arcane_circle) >= globalRecast*5 or]]
						if ( TargetHasBuffs(deaths_design_db, globalRecast, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) ) and (getCooldown(gluttony) >=  globalRecast*2 or Player.level < 76) and lastCastNot(soul_reaver_initiators_tbl) and PlayerMissingBuffs(soul_reaver_b) then
							-- Multi-Target
							if PlayerMissingBuffs(soul_reaver_b) and SettingEnableAOE and aoeConeAttackableCount >= 3 and grim_swathe:IsReady(Target.id) then
								setTargetBestCone()
								grim_swathe:Cast(Target.id)
								ReaperActivate("grim_swathe")
								return true
							end
							-- Single-Target
							if PlayerMissingBuffs(soul_reaver_b) and unveiled_gibbet:IsReady(Target.id) then
								unveiled_gibbet:Cast(Target.id)
								ReaperActivate("unveiled_gibbet")
								return true
							end
							if PlayerMissingBuffs(soul_reaver_b) and unveiled_gallows:IsReady(Target.id) then
								unveiled_gallows:Cast(Target.id)
								ReaperActivate("unveiled_gallows")
								return true
							end
							if PlayerMissingBuffs(soul_reaver_b) and blood_stalk:IsReady(Target.id) then
								blood_stalk:Cast(Target.id)
								ReaperActivate("blood_stalk")
								return true
							end
						end
					end
				end
			end

			-- Use <Immortal Sacrifice> Bravo
			if SettingEnableAOE and SettingPlentifulHarvest and PlayerHasBuffs(immortal_sacrifice_b, tillNextGCDPlusPulse) then -- CODEBLUE
				if ( TargetHasBuffs(deaths_design_db, tillNextGCD, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) ) and (PlayerHasBuffs(arcane_circle_b, 5 + globalRecast)) then -- CODEBLUE and PlayerMissingBuffs(arcane_circle_b, 9 + 2*globalRecast)) then
					if plentiful_harvest:IsReady(Target.id) then
						if ShroudGauge <= 50 then 
							plentiful_harvest:Cast(Target.id)
							ReaperActivate("plentiful_harvest")
							d("Plentiful Bravo")
							return true
						end
					end
				end
			end



				-- Gain <Soul Gauge>
				function gainSoulGauge()
					if --[[getCooldown(arcane_circle) >= (30 - globalRecast) and]] DestroyMode or (getCooldown(soul_slice) <= globalRecast*3 or PlayerHasBuffs(arcane_circle_b, 1)) or (getCooldown(gluttony) <= 2*globalRecast and SoulGauge <= 20) or expectedDeathTime <= FinaleSettingSoulSlice then
						if SettingSoulGauge and SoulGauge <= 50 then
							if TargetHasBuffs(deaths_design_db, globalRecast*2, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) then
								-- Multi-Target
								if SettingEnableAOE and aoeCenterAttackableCount >= 3 and soul_scythe:IsReady(Player.id) then
									soul_scythe:Cast(Player.id)
									ReaperActivate("soul_scythe")
									return true
								end
								-- Single-Target
								if soul_slice:IsReady(Target.id) then
									soul_slice:Cast(Target.id)
									ReaperActivate("soul_slice")
									return true
								end
							end
						end
					end
				end


			if ( not SettingLateGluttony and PlayerMissingBuffs(arcane_circle_b) ) or getCooldown(soul_slice) <=  (5 * void_reaping.recasttime + globalRecastPlusPulse) then
				gainSoulGauge()
			end

			-- Use <Shroud Gauge>
			if not ReserveMode and SettingEnshroud and ShroudGauge >= 50 and (getCooldown(soul_slice) >= 8.5 + PulseRate) and enshroud:IsReady(Player.id) and lastCastNot(soul_reaver_initiators_tbl) then
				if DestroyMode or not FinaleMode or expectedDeathTime >= FinaleSettingEnshroud then
					if (SettingSaveShroud == 0 or getCooldown(arcane_circle) <= SettingSaveShroud) then
						if ( PlayerHasBuffs( tostring(left_eye_b) .. "," .. tostring(battle_litany) .. "," .. tostring(devilment_b) .. "," .. tostring(technical_finish_b) .. "," .. tostring(standard_finish_b).. "," .. tostring(arcane_circle_b), 9) ) or ( getCooldown(arcane_circle) <= tillNextGCD + 3*globalRecast + 0.50 and true ) or (Player.level < 88 and ShroudGauge >= SettingUnloadShroud_low) or (Player.level >= 88 and ShroudGauge >= SettingUnloadShroud) then
							if ( TargetHasBuffs(deaths_design_db, (5 * void_reaping.recasttime + globalRecastPlusPulse), Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) ) then
								enshroud:Cast(Player.id)
								ReaperActivate("enshroud")
								return true
							end
						end
					end
				end
			end




			gainSoulGauge()



			-- Use <Void Shroud>
			if VoidShroud >= 2 then
				if SettingEnableAOE and aoeConeAttackableCount >= 3 and lemures_scythe:IsReady(Target.id) then
					setTargetBestCone()
					lemures_scythe:Cast(Target.id)
					ReaperActivate("lemures_scythe")
					return true
				end
				if lemures_slice:IsReady(Target.id) then
					lemures_slice:Cast(Target.id)
					ReaperActivate("lemures_slice")
					return true
				end
			-- Activates <Communio>
			elseif not Player:IsMoving() and timeSincePlayerLastMoved >= SettingMoveCastMin and LemureShroud == 1 and VoidShroud == 0 and PlayerHasBuffs(enshroud_b, 1.25) then
				if SettingSmartAOE then
					previous_target = MGetTarget()
					Player:SetTarget(GetBestClusteredEntityTarget(communio_range, communio_radius).id)
					targetChangeTimer = os.time()
				end
				if communio:IsReady(MGetTarget().id) then
					communio:Cast(MGetTarget().id)
					ReaperActivate("communio")
					return true
				end
			end


			-- Special: Enshroud Combo
			if not ReserveMode and (PlayerHasBuffs(enshroud_b) or grim_reaping:IsReady(Target.id)) and (Player.level < 90 or (Player.level >= 90 and LemureShroud ~= 1)) then
				-- Multi-Target
				if SettingEnableAOE and aoeConeAttackableCount >= 3 then
					setTargetBestCone()
					grim_reaping:Cast(Target.id)
					ReaperActivate("grim_reaping")
					return true
				end


				-- Important Note: Here, the parameter  if PlayerHasBuffs and if void_reaping:IsReady should not be on the same line, if it is, it causes missed checks.
				-- Need to place them on separate lines.
				if PlayerHasBuffs(enhanced_void_b) then
					if void_reaping:IsReady(Target.id) then
						void_reaping:Cast(Target.id)
						ReaperActivate("void_reaping")
						--d("Void Reaping Bravo")
						return true
					end
				elseif PlayerHasBuffs(enhanced_cross_b) then
					if cross_reaping:IsReady(Target.id) then
						cross_reaping:Cast(Target.id)
						ReaperActivate("cross_reaping")
						--d("Cross Reaping Delta")
						return true
					end
				end


				if PlayerMissingBuffs(enhanced_void_b) and PlayerMissingBuffs(enhanced_cross_b) then
					--d("Void Reaping Omega 1")
					if EnshroudSkillChoice == 1 then
						if void_reaping:IsReady(Target.id) then
							void_reaping:Cast(Target.id)
							ReaperActivate("void_reaping")
							return true
						end
					elseif EnshroudSkillChoice == 2 then
						if cross_reaping:IsReady(Target.id) then
							cross_reaping:Cast(Target.id)
							ReaperActivate("cross_reaping")
							return true
						end
					elseif EnshroudSkillChoice == 3 then
						if math.random( 1, SettingCrossWeight + SettingVoidWeight ) <= SettingVoidWeight then
							if void_reaping:IsReady(Target.id) then
								void_reaping:Cast(Target.id)
								ReaperActivate("void_reaping")
								return true
							end
						else
							if cross_reaping:IsReady(Target.id) then
								cross_reaping:Cast(Target.id)
								ReaperActivate("cross_reaping")
								return true
							end
						end
					end
				end


				--[[
				
					function activateVoid()
						if PlayerHasBuffs(enhanced_void_b) and void_reaping:IsReady(Target.id) then
							void_reaping:Cast(Target.id)
							ReaperActivate("void_reaping")
							return true
						elseif PlayerMissingBuffs(enhanced_cross_b) then
							cross_reaping:Cast(Target.id)
							ReaperActivate("cross_reaping")
							return true
						end
					end
					
					function activateCross()
						if PlayerHasBuffs(enhanced_cross_b) and cross_reaping:IsReady(Target.id) then
							cross_reaping:Cast(Target.id)
							ReaperActivate("cross_reaping")
							return true
						elseif PlayerMissingBuffs(enhanced_void_b) then
							void_reaping:Cast(Target.id)
							ReaperActivate("void_reaping")
							return true
						end
					end
				-- Single-Target
				if EnshroudSkillChoice == 1 then
					activateVoid()
					activateCross()
				elseif EnshroudSkillChoice == 2 then
					activateCross()
					activateVoid()
				elseif EnshroudSkillChoice == 3 then
					if math.random(1, SettingCrossWeight + SettingVoidWeight) <= SettingVoidWeight then
						activateVoid()
						activateCross()
					else
						activateCross()
						activateVoid()
					end
				end
				]]
			end

			
			-- Use <Immortal Sacrifice> Priority 3
			if SettingPlentifulHarvest and ShroudGauge <= 50 and PlayerMissingBuffs(bloodsown_circle_b) and ( TargetHasBuffs(deaths_design_db, tillNextGCD, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) ) then
				if plentiful_harvest:IsReady(Target.id) then
					plentiful_harvest:Cast(Target.id)
					ReaperActivate("plentiful_harvest")
					return true
				end
			end

			-- Lonely <Harvest Moon>
			if SettingHarvestMoon then
				if (DestroyMode or getEnemyAverageHP() <= 35 or PlayerHasBuffs(arcane_circle_b, tillNextGCD + 0.25)) and ( TargetHasBuffs(deaths_design_db, tillNextGCD + 0.25, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) ) then
					if harvest_moon:IsReady(Target.id) then
						harvest_moon:Cast(Target.id)
						ReaperActivate("harvest_moon")
						return true
					end
				end
			end






			-- Multi-Target v1
			--[[
			if SettingEnableAOE and aoeCenterAttackableCount >= 3 then
				if TargetHasBuffs(deaths_design_db, globalRecast, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) then
					if Player.lastcomboid == spinning_scythe.id and nightmare_scythe:IsReady(Player.id) then
						nightmare_scythe:Cast(Player.id)
						ReaperActivate("nightmare_scythe")
						return true
					end
					if spinning_scythe:IsReady(Player.id) then
						spinning_scythe:Cast(Player.id)
						ReaperActivate("spinning_scythe")
						return true
					end
				elseif Target.distance2d <= ring_aoe_range and whorl_of_death:IsReady(Player.id) and ShouldUseWhorl() then
					whorl_of_death:Cast(Player.id)
					ReaperActivate("whorl_of_death")
					return true
				end
			end
			]]

			-- Multi-Target v2
			if SettingEnableAOE and aoeCenterAttackableCount >= 3 then
				if ShouldUseWhorl() then
					if whorl_of_death:IsReady(Player.id) then
						whorl_of_death:Cast(Player.id)
						ReaperActivate("whorl_of_death")
						return true
					end
				else	--if TargetHasBuffs(deaths_design_db, globalRecast, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) then
					if Player.lastcomboid == spinning_scythe.id and nightmare_scythe:IsReady(Player.id) then
						nightmare_scythe:Cast(Player.id)
						ReaperActivate("nightmare_scythe")
						return true
					elseif spinning_scythe:IsReady(Player.id) then
						spinning_scythe:Cast(Player.id)
						ReaperActivate("spinning_scythe")
						return true
					end
				end
			end

			-- Single-Target
			if TargetMissingBuffs(deaths_design_db, globalRecast*2, Player.id) and not (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) and shadow_of_death:IsReady(Target.id) then
				shadow_of_death:Cast(Target.id)
				ReaperActivate("shadow_of_death")
				return true
			end
			

			if Player.lastcomboid == waxing_slice.id and infernal_slice:IsReady(Target.id) then
				infernal_slice:Cast(Target.id)
				ReaperActivate("infernal_slice")
				return true
			end
			

			if Player.lastcomboid == slice.id and waxing_slice:IsReady(Target.id) then
				waxing_slice:Cast(Target.id)
				ReaperActivate("waxing_slice")
				return true
			end


			if slice:IsReady(Target.id) then
				slice:Cast(Target.id)
				ReaperActivate("slice")
				return true
			end




		end -- ends if missing soul_reaver_b


	end -- ends if (Target)



			-- <If No Target Selected AOE> EDIT
	if DestroyMode or getCooldown(soul_slice) <= globalRecast*5 or PlayerHasBuffs(arcane_circle_b, tillNextGCD) then
		if (DestroyMode or SettingSoulGauge) and SoulGauge <= 50 then
			--Perhaps change this logic to if nearest target possess, or if ratio of nearby targets possess Deaths Design
			--if TargetHasBuffs(deaths_design_db, globalRecast*2, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) then
				-- Multi-Target
				if SettingEnableAOE and SettingSoulGauge and aoeCenterAttackableCount >= 3 and soul_scythe:IsReady(Player.id) then
					soul_scythe:Cast(Player.id)
					ReaperActivate("soul_scythe")
					return true
				end
			--end
		end
	end

	if SettingEnableAOE and aoeCenterAttackableCount >= 3 then
		if ShouldUseWhorl() then
			if whorl_of_death:IsReady(Player.id) then
				whorl_of_death:Cast(Player.id)
				ReaperActivate("whorl_of_death")
				return true
			end
		else	--if TargetHasBuffs(deaths_design_db, globalRecast, Player.id) or (Target.hp.current <= Player.hp.current / SettingDeathsDesignDivision) then
			if Player.lastcomboid == spinning_scythe.id and nightmare_scythe:IsReady(Player.id) then
				nightmare_scythe:Cast(Player.id)
				ReaperActivate("nightmare_scythe")
				return true
			elseif spinning_scythe:IsReady(Player.id) then
				spinning_scythe:Cast(Player.id)
				ReaperActivate("spinning_scythe")
				return true
			end
		end
	end




    return false
end



return profile