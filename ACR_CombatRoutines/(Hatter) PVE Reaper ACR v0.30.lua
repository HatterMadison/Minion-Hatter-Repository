--[[
:Stuff i needed to remember

Differentiate between Death Design of self and others
Check why Harvest Moon not activiating
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
    name = "(Hatter) PVE Reaper 0.30",
}

CustomTabs_1 = GUI_CreateTabs([[QuickBar,Settings,Misc, dev.]])
			 -- List or Combo
 
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
			local TabIndex, TabName = GUI_DrawTabs(CustomTabs_1)

			if TabIndex == 1 then
				-- Page 1 content
				ACR.GUIVarUpdate(GUI:Checkbox("On <RESERVE>.",ReserveMode),"ReserveMode")
				ACR.GUIVarUpdate(GUI:Checkbox("On <DESTROY>.",DestroyMode),"DestroyMode")
				ACR.GUIVarUpdate(GUI:Checkbox("On Smart <True North>.",SmartTrueNorth),"SmartTrueNorth")
				ACR.GUIVarUpdate(GUI:Checkbox("On <AOE> Skills.",SmartAOE),"SmartAOE")
				ACR.GUIVarUpdate(GUI:Checkbox("On <Enshroud>.",SmartEnshroud),"SmartEnshroud")
				ACR.GUIVarUpdate(GUI:Checkbox("On <Soul Gauge> Skills.",SmartSoulGauge),"SmartSoulGauge")
				ACR.GUIVarUpdate(GUI:Checkbox("On <Arcane Circle>.",AutoArcaneCircle),"AutoArcaneCircle")
				ACR.GUIVarUpdate(GUI:Checkbox("On <DEFENSE>.",SettingDefenses),"SettingDefenses")
				ACR.GUIVarUpdate(GUI:Checkbox("On <Arcane Crest>.",SettingArcaneCrest),"SettingArcaneCrest")
				ACR.GUIVarUpdate(GUI:Checkbox("On <Second Wind>.",SettingSecondWind),"SettingSecondWind")
				ACR.GUIVarUpdate(GUI:Checkbox("On <Bloodbath>.",SettingBloodbath),"SettingBloodbath")
			elseif TabIndex == 2 then
				-- Page 2 content
				GUI:PushItemWidth(90)
					ACR.GUIVarUpdate(GUI:InputFloat([[Save <Gluttony> when <Arcane Circle> CD is <= Second.##HatRPRSaveGluttony]], SettingSaveGluttony),"SettingSaveGluttony")
					ACR.GUIVarUpdate(GUI:InputFloat([[Save <Enshroud> and Overload <Shroud Gauge> when <Arcane Circle> CD is <= Second.##HatRPRSaveShroud]], SettingSaveShroud),"SettingSaveShroud")
					ACR.GUIVarUpdate(GUI:InputInt([[Unload <Soul Gauge> when <Soul Gauge> is >= .##HatUnloadSoul]], SettingUnloadSoul),"SettingUnloadSoul")
					ACR.GUIVarUpdate(GUI:InputFloat([[Use <Bloodbath> when HP <= this %.##HatRPRBloodbathHPP]], BloodbathHPP),"BloodbathHPP")
					ACR.GUIVarUpdate(GUI:InputFloat([[Use <Second Wind> when HP <= this %.##HatRPRSecondWindHPP]], SecondWindHPP),"SecondWindHPP")
					ACR.GUIVarUpdate(GUI:InputFloat([[Use <Arcane Crest> when HP <= this %.##HatRPRSecondWindHPP]], ArcaneCrestHPP),"ArcaneCrestHPP")
				GUI:PopItemWidth()
			elseif TabIndex == 3 then
				-- Page 3 content
				GUI:PushItemWidth(120)
					ACR.GUIVarUpdate(GUI:Combo([[<Enshroud> Combo Start Preference.##HatEnshroudSkillChoice]], EnshroudSkillChoice, EnshroudSettingTable),"EnshroudSkillChoice")
				GUI:PopItemWidth()
				GUI:PushItemWidth(90)
					ACR.GUIVarUpdate(GUI:InputInt([[Random <Void> Weight.##HatSettingVoidWeight]], SettingVoidWeight),"SettingVoidWeight")
					ACR.GUIVarUpdate(GUI:InputInt([[Random <Cross> Weight.##HatSettingCrossWeight]], SettingCrossWeight),"SettingCrossWeight")
				GUI:PopItemWidth()
				GUI:PushItemWidth(120)
					ACR.GUIVarUpdate(GUI:Combo([[<Gibbet or Gallows> Desperation Preference.##HatGibbetGallowsChoice]], GibbetGallowsChoice, GallowGibbetSettingTable),"GibbetGallowsChoice")
				GUI:PopItemWidth()
				GUI:PushItemWidth(90)
					ACR.GUIVarUpdate(GUI:InputInt([[Random <Gibbet> Weight.##HatSettingGibbetWeight]], SettingGibbetWeight),"SettingGibbetWeight")
					ACR.GUIVarUpdate(GUI:InputInt([[Random <Gallows> Weight.##HatSettingGallowsWeight]], SettingGallowsWeight),"SettingGallowsWeight")
				GUI:PopItemWidth()
				GUI:PushItemWidth(90)
					ACR.GUIVarUpdate(GUI:Checkbox("Use <Soulsow> when out of combat.",OutCombatSoulSow),"OutCombatSoulSow")
					ACR.GUIVarUpdate(GUI:InputFloat([[Random <Soulsow> Minimum -Seconds- out of combat time to activate.##HatSoulsowLow]], SettingSoulsowLow),"SettingSoulsowLow")
					ACR.GUIVarUpdate(GUI:InputFloat([[Random <Soulsow> Maximum -Seconds- out of combat time to activate.##HatSoulsowHigh]], SettingSoulsowHigh),"SettingSoulsowHigh")
				GUI:PopItemWidth()
			elseif TabIndex == 4 then
				ACR.GUIVarUpdate(GUI:Checkbox("On <DEV MONITOR>.",SettingDevMonitor),"SettingDevMonitor")
			end
        end
        GUI:End()
    end	
	
	if SettingDevMonitor then
	-- Debug Dev Monitor
		GUI:Text("______Player______")
		GUI:Text(".lastcastid = " .. tostring(Player.castinginfo.lastcastid))
		GUI:Text(".castingid = " .. tostring(Player.castinginfo.castingid))
		GUI:Text(".channelingid = " .. tostring(Player.castinginfo.channelingid))
		GUI:Text(".channelingtime = " .. tostring(Player.castinginfo.channelingtime))
		GUI:Text("")
		GUI:Text("______Target______")
		if ValidTable(MGetTarget()) then
			GUI:Text(".contentid = " .. tostring(MGetTarget().contentid))
			GUI:Text("hp.percent = " .. tostring(MGetTarget().hp.percent))
			GUI:Text(".lastcastid = " .. tostring(MGetTarget().castinginfo.lastcastid))
			GUI:Text(".castingid = " .. tostring(MGetTarget().castinginfo.castingid))
			GUI:Text(".channelingid = " .. tostring(MGetTarget().castinginfo.channelingid))
			GUI:Text(".channelingtime = " .. tostring(MGetTarget().castinginfo.channelingtime))
		end
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
    -- Set and (if necessary) create a saved variable named ACR_MyProfile_MySavedVar.
    SettingSaveGluttony = ACR.GetSetting("SettingSaveGluttony",5.5)
    SettingUnloadSoul = ACR.GetSetting("SettingUnloadSoul",90)
    SettingSaveShroud = ACR.GetSetting("SettingSaveShroud",18.5)
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
    AutoArcaneCircle = ACR.GetSetting("AutoArcaneCircle",true)
    SmartAOE = ACR.GetSetting("SmartAOE",true)
    SmartSoulGauge = ACR.GetSetting("SmartSoulGauge",true)
    SmartEnshroud = ACR.GetSetting("SmartEnshroud",true)
    BloodbathHPP = ACR.GetSetting("BloodbathHPP",67.2)
    SecondWindHPP = ACR.GetSetting("SecondWindHPP",55.6)
    ArcaneCrestHPP = ACR.GetSetting("ArcaneCrestHPP",35.4)
    SettingBloodbath = ACR.GetSetting("SettingBloodbath",true)
    SettingSecondWind = ACR.GetSetting("SettingSecondWind",true)
    OutCombatSoulSow = ACR.GetSetting("OutCombatSoulSow",true)
    ReserveMode = ACR.GetSetting("ReserveMode",false)
    SettingDefenses = ACR.GetSetting("SettingDefenses",true)
    SettingArcaneCrest = ACR.GetSetting("SettingArcaneCrest",false)
    SettingDevMonitor = ACR.GetSetting("SettingDevMonitor",false)
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
 
-- The OnUpdate() function is fired on the gameloop, like any other OnUpdate function found in FFXIVMinion code.
function profile.OnUpdate(event, tickcount)

end



	local DebugActivation = false

-- <Defense> oGCD
    local arcane_crest 					= ActionList:Get(1, 24404)
    local arcane_circle 				= ActionList:Get(1, 24405)
    local second_wind 					= ActionList:Get(1, 7541)
    local bloodbath 					= ActionList:Get(1, 7542)
    local arms_length 					= ActionList:Get(1, 7548)

-- <Buffs> oGCD
    local enshroud 						= ActionList:Get(1, 24394)
    local true_north 					= ActionList:Get(1, 7546)

-- <Buffs> GCD
	local soulsow 						= ActionList:Get(1, 24387)

-- <Special> oGCD Distance
    local hells_egress 					= ActionList:Get(1, 24402)
    local hells_ingress 				= ActionList:Get(1, 24401)

-- <Offense> GCD Multi-Target
    local guillotine 					= ActionList:Get(1, 24384)
	--
	local communio 						= ActionList:Get(1, 24398)
	local lemures_scythe				= ActionList:Get(1, 24400)
	--
    local grim_reaping 					= ActionList:Get(1, 24397)
	--
    local harvest_moon 					= ActionList:Get(1, 24388)
	--
    local whorl_of_death 				= ActionList:Get(1, 24379)
    local spinning_scythe 				= ActionList:Get(1, 24376)
    local nightmare_scythe 				= ActionList:Get(1, 24377)

-- <Offense> GCD Single-Target
    local gallows 						= ActionList:Get(1, 24383)
    local gibbet 						= ActionList:Get(1, 24382)
	--
	local lemures_slice 				= ActionList:Get(1, 24399)
	--
    local cross_reaping 				= ActionList:Get(1, 24396)
    local void_reaping 					= ActionList:Get(1, 24395)
	--
    local infernal_slice 				= ActionList:Get(1, 24375)
    local waxing_slice 					= ActionList:Get(1, 24374)
	local slice 						= ActionList:Get(1, 24373)
    local shadow_of_death 				= ActionList:Get(1, 24378)
    local harpe 						= ActionList:Get(1, 24386)

-- <Offense> oGCD Multi-Target
    local gluttony 						= ActionList:Get(1, 24393)
    local grim_swathe 					= ActionList:Get(1, 24392)	
	--
    local unveiled_gibbet 				= ActionList:Get(1, 24390)
    local unveiled_gallows 				= ActionList:Get(1, 24391)
	local blood_stalk 					= ActionList:Get(1, 24389)
	--
    local soul_scythe 					= ActionList:Get(1, 24381)

-- <Offense> oGCD Single-Target
    local soul_slice 					= ActionList:Get(1, 24380)

-- <Buffs & Debuffs>
	local deaths_design_db = 2586
	local soul_reaver_b = 2587 -- buff needed to ggg
	local enhanced_gibbet_b = 2588
	local enhanced_gallows_b = 2589
	local enhanced_void_b = 2590
	local enhanced_cross_b = 2591
	local enshroud_b = 2593
	local soulsow_b = 2594
	local arcane_circle_b = 2599
	local bloodbath_b = 84
	local arms_length = 1209
	local true_north_b = 1250

-- <Other Settings>
	local true_north_animationLock = 0.5

function getTablelength(tbl)
  local count = 0
  for _ in pairs(tbl) do count = count + 1 end
  return count
end

 
-- The Cast() function is where the magic happens.
-- Action code should be called and fired here.
function profile.Cast()

	math.randomseed(os.time())

	local PulseRate = gPulseTime*0.001

    local Target = MGetTarget()

	local GlobalRecast = slice.recasttime
	local tillNextGCD = slice.cdmax - slice.cd
	local lastCast = Player.castinginfo.lastcastid

	local SoulGauge = Player.gauge[1]
	local ShroudGauge = Player.gauge[2]
	local LemureShroud = Player.gauge[4]
	local VoidShroud = Player.gauge[5]

	local aoeCenterAttackableCount = getTablelength(EntityList('alive,attackable,maxdistance2d=5'))
	local aoeCenterEnemyCount = getTablelength(EntityList('aggro,attackable,maxdistance2d=5'))
	
	local aoeFrontalAttackableCount = getTablelength(EntityList('alive,attackable,maxdistance2d=8'))
	local aoeFrontalEnemyCount = getTablelength(EntityList('aggro,attackable,maxdistance2d=8'))

	function getCooldown(skill)
		ret  = skill.cdmax - skill.cd
		return ret
	end

	function condition_TrueNorth()
		if SmartTrueNorth == true and aoeFrontalAttackableCount <= 2 and true_north:IsReady(Player.id) and PlayerMissingBuffs(true_north_b) and tillNextGCD <= 0.50 + PulseRate then return true else return false end
	end


	-- If in combat.
	if ValidTable(Player:GetEnmityList()) then
		time_last_aggro = os.time()
		if	tillNextGCD <= 0.50 + PulseRate then
			if SettingDefenses then
				if SettingArcaneCrest and Player.hp.percent <= ArcaneCrestHPP and arcane_crest:IsReady(Player.id) then
					arcane_crest:Cast(Player.id)
					return true
				end
				if SettingSecondWind and Player.hp.percent <= SecondWindHPP and second_wind:IsReady(Player.id) then
					second_wind:Cast(Player.id)
					return true
				end
				if SettingBloodbath and Player.hp.percent <= BloodbathHPP and bloodbath:IsReady(Player.id) then
					bloodbath:Cast(Player.id)
					return true
				end
			end
			if AutoArcaneCircle == true and ReserveMode == false and arcane_circle:IsReady(Player.id) then
				if PlayerHasBuffs(enshroud_b, 1.5) then
					arcane_circle:Cast(Player.id)
					return true
				end
				if (SoulGauge >= 70 and getCooldown(soul_slice) <= (12 - GlobalRecast) and (LemureShroud >= 70)) or LemureShroud <= 30 or DestroyMode then
					if TargetHasBuffs(deaths_design_db, 20 + GlobalRecast) then
						arcane_circle:Cast(Player.id)
						return true
					elseif shadow_of_death:IsReady(Target.id) then
						shadow_of_death:Cast(Target.id)
						return true
					end
				end
			end
		end
	end

	function activateSoulsow()
		if soulsow.casttime == 0 and soulsow:IsReady(Player.id) then
			soulsow:Cast(Player.id)
			return true
		end
	end

	-- If out of combat.
	if not ValidTable(Player:GetEnmityList()) then
		if OutCombatSoulSow == true and PlayerMissingBuffs(soulsow_b) then
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
	end


	if (Target) then
		-- <Soul Reaver Buff Active>
		if PlayerHasBuffs(soul_reaver_b, GlobalRecast) then
			if SmartAOE == true and guillotine:IsReady(Target.id) and aoeFrontalAttackableCount >= 3 then
					guillotine:Cast(Target.id)
					return true
			end
			--<Should Player activate <True North> based on position?>
			if PlayerHasBuffs(enhanced_gallows_b, GlobalRecast) and not IsBehind2(Target,true,true) then
				if condition_TrueNorth() then
					true_north:Cast(Player.id)
					if DebugActivation then d("Activating .. <True North> Delta") end
					return true
				end
			end
			if PlayerHasBuffs(enhanced_gibbet_b, GlobalRecast) and not IsFlanking2(Target,true,true) then
				if condition_TrueNorth() then
					true_north:Cast(Player.id)
					if DebugActivation then d("Activating <True North> Echo") end
					return true
				end
			end
			if not IsFlanking2(Target,true,true) and not IsBehind2(Target,true,true) then
				if condition_TrueNorth() then
					true_north:Cast(Player.id)
					if DebugActivation then d("Activating <True North> Gamma") end
					return true
				end
			end
			-- <Which enhance buff does player have if any?>
			if PlayerHasBuffs(enhanced_gibbet_b, GlobalRecast) and gibbet:IsReady(Target.id) then
				gibbet:Cast(Target.id)
				if DebugActivation then d("Activating <Gibbet> Delta") end
				return true
			end
			if PlayerHasBuffs(enhanced_gallows_b, GlobalRecast) and gallows:IsReady(Target.id) then
				gallows:Cast(Target.id)
				if DebugActivation then d("Activating <Gallows> Delta") end
				return true
			end
			-- <Player has neither Enhance buff. Check and prioritize Position.>
			if IsFlanking2(Target,true,true) and gibbet:IsReady(Target.id) then
				gibbet:Cast(Target.id)
				if DebugActivation then d("Activating <Gibbet> Echo") end
				return true
			end
			if IsBehind2(Target,true,true) and gallows:IsReady(Target.id) then
				gallows:Cast(Target.id)
				if DebugActivation then d("Activating <Gallows> Echo") end
				return true
			end
			-- <Player has neither position brute activate gg.>
			function activateGibbet()
				if gibbet:IsReady(Target.id)then
					gibbet:Cast(Target.id)
					if DebugActivation then d("Activating <Gibbet> Gamma") end
					return true
				end
			end
			function activateGallows()
				if gallows:IsReady(Target.id) then
					gallows:Cast(Target.id)
					if DebugActivation then d("Activating <Gallows> Gamma") end
					return true
				end
			end
			if GibbetGallowsChoice == 1 then
				activateGibbet()
				activateGallows()
			elseif GibbetGallowsChoice == 2 then
				activateGallows()
				activateGibbet()
			elseif GibbetGallowsChoice == 3 then
				if math.random(1, SettingGibbetWeight + SettingGallowsWeight) <= SettingGallowsWeight then
					activateGibbet()
					activateGallows()
				else
					activateGibbet()
					activateGallows()
				end
			end
		end





	-- oGCD

		-- Use <Soul Gauge>
		if gluttony:IsReady(Target.id) and ReserveMode == false then
			if DestroyMode or (TargetHasBuffs(deaths_design_db, GlobalRecast*2) and (PlayerHasBuffs(arcane_circle_b, 1)) or getCooldown(arcane_circle) >= SettingSaveGluttony) then
				gluttony:Cast(Target.id)
				return true
			end
		elseif DestroyMode or PlayerHasBuffs(arcane_circle_b, 1) or (getCooldown(soul_slice) <= GlobalRecast*2 and SoulGauge >= 50) or SoulGauge >= SettingUnloadSoul then --[[getCooldown(arcane_circle) >= GlobalRecast*5 or]]
			if TargetHasBuffs(deaths_design_db, GlobalRecast) and (getCooldown(gluttony) >=  GlobalRecast*2) then
				-- Multi-Target
				if SmartAOE == true and aoeFrontalAttackableCount >= 3 and grim_swathe:IsReady(Target.id) then
					grim_swathe:Cast(Target.id)
					return true
				end
				-- Single-Target
				if unveiled_gibbet:IsReady(Target.id) then
					unveiled_gibbet:Cast(Target.id)
					if DebugActivation then d("Activating <Unveiled Gibbet> Gamma") end
					return true
				end
				if unveiled_gallows:IsReady(Target.id) then
					unveiled_gallows:Cast(Target.id)
					if DebugActivation then d("Activating <Unveiled Gallows> Gamma") end
					return true
				end
				if blood_stalk:IsReady(Target.id) then
					blood_stalk:Cast(Target.id)
					if DebugActivation then d("Activating <Blood Stalk> Gamma") end
					return true
				end
			end
		end

		-- Gain <Soul Gauge>
		if --[[getCooldown(arcane_circle) >= (30 - GlobalRecast) and]] (getCooldown(soul_slice) <= GlobalRecast*4 or PlayerHasBuffs(arcane_circle_b, 1) or DestroyMode) then
			if SmartSoulGauge == true and SoulGauge <= 50 then
				if TargetHasBuffs(deaths_design_db, GlobalRecast*2) then
					-- Multi-Target
					if SmartAOE == true and aoeCenterAttackableCount >= 3 and soul_scythe:IsReady(Player.id) then
						soul_scythe:Cast(Player.id)
						return true
					end
					-- Single-Target
					if soul_slice:IsReady(Target.id) then
						soul_slice:Cast(Target.id)
						return true
					end
				end
			end
		end

		-- Use <Shroud Gauge>
		if enshroud:IsReady(Player.id) and ReserveMode == false then
			if DestroyMode or (SmartEnshroud == true and HasBuffs(Target, deaths_design_db, 1.5*5) and PlayerMissingBuffs(soul_reaver_b)) then
				if DestroyMode or PlayerHasBuffs(arcane_circle_b, 1) or getCooldown(arcane_circle) <= 1 or (ShroudGauge >= 100 and getCooldown(arcane_circle) <= SettingSaveShroud) then
					enshroud:Cast(Player.id)
					return true
				end
			end
		end

		-- Use <Void Shroud>
		if VoidShroud >= 2 then
			if SmartAOE == true and aoeFrontalAttackableCount >= 3 and lemures_scythe:IsReady(Target.id) then
				lemures_scythe:Cast(Target.id)
				return true
			end
			if lemures_slice:IsReady(Target.id) then
				lemures_slice:Cast(Target.id)
				return true
			end
		elseif VoidShroud == 1 and LemureShroud == 1 and PlayerHasBuffs(enshroud_b, 1.25) then
			if communio:IsReady(Target.id) then
				communio:Cast(Target.id)
				return true
			end
		end

		-- Special: Enshrouded
		if grim_reaping:IsReady(Target.id) then
			-- Multi-Target
			if SmartAOE == true and aoeFrontalAttackableCount >= 3 then
				grim_reaping:Cast(Target.id)
				return true
			end
			function activateVoid()
				if void_reaping:IsReady(Target.id) and PlayerMissingBuffs(enhanced_cross_b, GlobalRecast) then
					void_reaping:Cast(Target.id)
					return true
				end
			end
			function activateCross()
				if cross_reaping:IsReady(Target.id) and PlayerMissingBuffs(enhanced_void_b, GlobalRecast) then
					cross_reaping:Cast(Target.id)
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
				if math.random(SettingCrossWeight + SettingVoidWeight) <= SettingVoidWeight then
					activateVoid()
					activateCross()
				else
					activateVoid()
					activateCross()
				end
			end
		end
		
				-- Lonely <Harvest Moon>
		if (DestroyMode or PlayerHasBuffs(arcane_circle_b, tillNextGCD + 0.25)) and TargetHasBuffs(deaths_design_db, tillNextGCD + 0.25) then
			if harvest_moon:IsReady(Target.id) then
				harvest_moon:Cast(Target.id)
				return true
			end
		end

		-- Multi-Target
		if SmartAOE == true and aoeCenterAttackableCount >= 3 then
			if TargetHasBuffs(deaths_design_db, GlobalRecast) then
				if Player.lastcomboid == spinning_scythe.id and nightmare_scythe:IsReady(Player.id) then
					nightmare_scythe:Cast(Player.id)
					return true
				end
				if spinning_scythe:IsReady(Player.id) then
					spinning_scythe:Cast(Player.id)
					return true
				end
			elseif Target.distance2d <= 5 and whorl_of_death:IsReady(Player.id) then
				whorl_of_death:Cast(Player.id)
				return true
			end
		end

		-- Single-Target
		local Skill = shadow_of_death
		if MissingBuffs(Target, deaths_design_db, GlobalRecast*2) and Skill:IsReady(Target.id) then
			Skill:Cast(Target.id)
			return true
		end
		
		local Skill = infernal_slice
		if Player.lastcomboid == waxing_slice.id and Skill:IsReady(Target.id) then
			Skill:Cast(Target.id)
			return true
		end
		
		local Skill = waxing_slice
		if Player.lastcomboid == slice.id and Skill:IsReady(Target.id) then
			Skill:Cast(Target.id)
			return true
		end

		local Skill = slice
		if Skill:IsReady(Target.id) then
			Skill:Cast(Target.id)
			return true
		end



	end

	-- <No Target Selected AOE>
	if --[[getCooldown(arcane_circle) >= (30 - GlobalRecast) and]] getCooldown(soul_slice) <= GlobalRecast*4 or PlayerHasBuffs(arcane_circle_b, 1) or DestroyMode then
		if SmartSoulGauge == true and SoulGauge <= 50 then
			if TargetHasBuffs(deaths_design_db, GlobalRecast*2) then
				-- Multi-Target
				if SmartAOE == true and aoeCenterAttackableCount >= 3 and soul_scythe:IsReady(Player.id) then
					soul_scythe:Cast(Player.id)
					return true
				end
				-- Single-Target
				if soul_slice:IsReady(Target.id) then
					soul_slice:Cast(Target.id)
					return true
				end
			end
		end
	end

	if SmartAOE == true and aoeCenterAttackableCount >= 3 then
		if Player.lastcomboid == spinning_scythe.id and nightmare_scythe:IsReady(Player.id) then
			nightmare_scythe:Cast(Player.id)
			return true
		end
		if spinning_scythe:IsReady(Player.id) then
			spinning_scythe:Cast(Player.id)
			return true
		end
	end


    return false
end
 
 

 
 
-- Other ffxivminion functions that small changes were made to make readability more enjoyable for the above.
 
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
 

 function TargetHasBuffs(buffs, duration, ownerid, stacks)
	local duration = duration or 0
	local owner = ownerid or 0
	local stacks = stacks or 0
	local buffs = IsNull(tostring(buffs),"")
	
	if (table.valid(MGetTarget()) and buffs ~= "") then
		local ebuffs = MGetTarget().buffs

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

 function PlayerHasBuffs(buffs, duration, ownerid, stacks)
	local duration = duration or 0
	local owner = ownerid or 0
	local stacks = stacks or 0
	local buffs = IsNull(tostring(buffs),"")
	
	if (table.valid(Player) and buffs ~= "") then
		local ebuffs = Player.buffs

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
	local duration = duration or 0
	local owner = ownerid or 0
	local stacks = stacks or 0
	local buffs = IsNull(tostring(buffs),"")
	
	if (table.valid(Player) and buffs ~= "") then
		local ebuffs = Player.buffs
		
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

function TargetMissingBuffs(buffs, duration, ownerid, stacks)
	local duration = duration or 0
	local owner = ownerid or 0
	local stacks = stacks or 0
	local buffs = IsNull(tostring(buffs),"")
	
	if (table.valid(MGetTarget()) and buffs ~= "") then
		local ebuffs = MGetTarget().buffs
		
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



-- Return the profile to ACR, so it can be read.
return profile