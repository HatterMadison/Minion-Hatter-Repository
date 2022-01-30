-- Create the basic profile table.
local profile = {}
 
-- Create a GUI table, to hold GUI-related information.
profile.GUI = {
    open = false,
    visible = true,
    name = "Main Setting",
}


-- Create a classes table, to specify which classes this profile can be used for.
profile.classes = {
    [FFXIV.JOBS.ARCHER] = true,
    [FFXIV.JOBS.BARD] = true,
} 


	-- Supers
	local _s = {}

	-- Timers
	_s.keys = {}
	_s.timers = {}
	_s.timers.songAttempt = Now()
	_s.timers.super_LOCK = Now()
	--_s.timers.iron_will = Now()
	
	
	-- <Traits and their Levels>
	local Traits = {
		heavier_shot = 2,
		heavy_shot_dmgboost = 20,
		heavy_shot_dmgboost_ii = 40,
		bite_mastery = 64,
		enhanced_empyreal_arrow = 68,
		straight_shot_mastery = 70,
		enhanced_quick_nock = 72,
		bite_mastery_ii = 76,
		heavy_shot_mastery = 76,
		enhanced_armys_paeon = 78,
		soul_void = 80,
		quick_nock_mastery = 82,
		enhanced_bloodletter = 84,
		enhanced_apex_arrow = 86,
		enhanced_troubadour = 88,
		minstrels_coda = 90
	}
	
	
	-- Skills
	local peloton					= ActionList:Get(1, 7557)
	local repelling_shot			= ActionList:Get(1, 112)
	
	local barrage				= ActionList:Get(1, 107)
	local raging_strikes			= ActionList:Get(1, 101)

	local blast_arrow				= ActionList:Get(1, 25784)
	local apex_arrow				= ActionList:Get(1, 16496)
	
	local quick_nock				= ActionList:Get(1, 106)
	local ladonsbite				= ActionList:Get(1, 25783)
	local shadowbite				= ActionList:Get(1, 16494)
	local rain_of_death				= ActionList:Get(1, 117)

	local burst_shot				= ActionList:Get(1, 16495)
	local heavy_shot				= ActionList:Get(1, 97)
	
	local refulgent_arrow			= ActionList:Get(1, 7409)
	local straight_shot				= ActionList:Get(1, 98)
	
	local iron_jaws					= ActionList:Get(1, 3560)
	
	local caustic_bite				= ActionList:Get(1, 7406)
	local venomous_bite				= ActionList:Get(1, 100)
	
	local stormbite					= ActionList:Get(1, 7407)
	local windbite					= ActionList:Get(1, 113)
	
	local empyreal_arrow			= ActionList:Get(1, 3558)
	local sidewinder				= ActionList:Get(1, 3562)
	local bloodletter				= ActionList:Get(1, 110)
	local second_wind				= ActionList:Get(1, 7541)

	local radiant_finale			= ActionList:Get(1, 25785)
	
	local battle_voice				= ActionList:Get(1, 118)
	local pitch_perfect				= ActionList:Get(1, 7404)
	local the_wanderers_minuet		= ActionList:Get(1, 3559)
	local mages_ballad				= ActionList:Get(1, 114)
	local armys_paeon				= ActionList:Get(1, 116)
	
	local the_wardens_paean			= ActionList:Get(1, 3561)

	local head_graze				= ActionList:Get(1, 7551)
	local foot_graze				= ActionList:Get(1, 7553)
	local leg_graze					= ActionList:Get(1, 7554)




	local troubadour				= ActionList:Get(1, 7405)
	local natures_minne				= ActionList:Get(1, 7408)

	local arms_length				= ActionList:Get(1, 7548)



	-- <Defense> oGCD


	--<Debuffs>
	local venomous_bite_db = 124
	local windbite_db = 129
	
	local caustic_bite_db = 1200
	local stormbite_db = 1201
	
	local _db = 1201

	--<Defensive Buffs>
	local troubadour_b = 1934
	local natures_minne_b = 1202
	local arms_length_b = 1209
	local peloton_b = 1199
	local the_wardens_paean_b = 866
	
	local _b = 1202
	
	--<Offensive Buffs>
	local barrage_b = 128
	local raging_strikes_b = 125
	local straight_shot_ready_b = 122
	local shadowbite_ready_b = 3002
	local blast_arrow_ready_b = 2692
	
	--<Song Buffs> Note: Use Gauge Data instead to verify songs.
	local radiant_finale_b = 2964
	local radiant_finale_bb = 2722
	local battle_voice_b = 141
	local the_wanderers_minuet_b = 2216
	local mages_ballad_b = 2217
	local armys_paeon_b = 2218
	
	--<generals>
	local sprint_b = 50
	









function profile.OnLoad()
    settings_useAOE = ACR.GetSetting( "settings_useAOE", true )
    settings_use_dots = ACR.GetSetting( "settings_use_dots", true )
    settings_dots_triggerHP = ACR.GetSetting( "settings_dots_triggerHP", 1.8 )
    settings_dots_modifier = ACR.GetSetting( "settings_dots_modifier", 2 )
    settings_use_second_wind = ACR.GetSetting( "settings_use_second_wind", true )
    settings_use_second_wind_HP = ACR.GetSetting( "settings_use_second_wind_HP", 65 )
    settings_use_raging_strikes = ACR.GetSetting( "settings_use_raging_strikes", true )
    settings_singSong = ACR.GetSetting( "settings_singSong", true )
    settings_use_natures_minne = ACR.GetSetting( "settings_use_natures_minne", true )
    settings_use_peloton = ACR.GetSetting( "settings_use_peloton", true )
    settings_head_graze = ACR.GetSetting( "settings_head_graze", true )
    settings_apex_arrow_soulgauge = ACR.GetSetting( "settings_apex_arrow_soulgauge", 90 )
end


-- The OnOpen() function is fired when a user pressed "View Profile Options" on the main ACR window.
function profile.OnOpen()
    profile.GUI.open = true
end



function profile.Draw()
    if (profile.GUI.open) then	
	profile.GUI.visible, profile.GUI.open = GUI:Begin(profile.GUI.name, profile.GUI.open)
	if ( profile.GUI.visible ) then 
			GUI:PushItemWidth(50)
            ACR.GUIVarUpdate( GUI:Checkbox("AOE",settings_useAOE) ,"settings_useAOE" )
            ACR.GUIVarUpdate( GUI:Checkbox("Dots",settings_use_dots) ,"settings_use_dots" )
            ACR.GUIVarUpdate( GUI:InputFloat("Dot when Enemy Current HP >= this_value * Player Max HP",settings_dots_triggerHP) ,"settings_dots_triggerHP" )
            ACR.GUIVarUpdate( GUI:InputFloat("Dot when current Dot duration <= this_value * globalRecast",settings_dots_modifier) ,"settings_dots_modifier" )
            ACR.GUIVarUpdate( GUI:Checkbox("Raging Strikes",settings_use_raging_strikes) ,"settings_use_raging_strikes" )
            ACR.GUIVarUpdate( GUI:Checkbox("Sing Songs",settings_singSong) ,"settings_singSong" )
            ACR.GUIVarUpdate( GUI:Checkbox("2nd Wind",settings_use_second_wind) ,"settings_use_second_wind" )
			GUI:PopItemWidth()
			GUI:PushItemWidth(80)
            ACR.GUIVarUpdate( GUI:InputInt("Use <Second Wind> when HP below or equals this %",settings_use_second_wind_HP) ,"settings_use_second_wind_HP" )
            ACR.GUIVarUpdate( GUI:InputInt("Use <Apex Arrow> when over X <Soul Gauge>",settings_apex_arrow_soulgauge) ,"settings_apex_arrow_soulgauge" )
			GUI:Text('Below Does Nothing')
            ACR.GUIVarUpdate( GUI:Checkbox("Nature\'s Minne",settings_use_natures_minne) ,"settings_use_natures_minne" )
			if GUI:IsItemHovered(GUI.HoveredFlags_Default) then GUI:SetTooltip( "Currently does nothing." ) end
            ACR.GUIVarUpdate( GUI:Checkbox("Peloton",settings_use_peloton) ,"settings_use_peloton" )
			if GUI:IsItemHovered(GUI.HoveredFlags_Default) then GUI:SetTooltip( "Currently does nothing." ) end
            ACR.GUIVarUpdate( GUI:Checkbox("Head Graze",settings_head_graze) ,"settings_head_graze" )
			if GUI:IsItemHovered(GUI.HoveredFlags_Default) then GUI:SetTooltip( "Currently does nothing." ) end
			GUI:PopItemWidth()
        end
        GUI:End()
    end	
end


-- Adds a customizable header to the top of the ffxivminion task window.
function profile.DrawHeader()
 
end


-- Adds a customizable footer to the top of the ffxivminion task window.
function profile.DrawFooter()
 
end


function profile.OnUpdate(event, tickcount)

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

-- AOE Functions

--Cone AOE, Between Player and Target
function EntityCountBetweenPlayerAndTarget( _input_range )
	local TTarget = MGetTarget() or nil
	local tbl = EntityList('alive,attackable,targetable,onmesh,maxdistance2d='..tostring( math.ceil( _input_range ) ) )
	local return_count = 0
	
	if TTarget and table.valid(tbl) then
		local count = 0
		for k, v in pairs(tbl) do
			if IsEntityHitboxFrontIfPlayerFacingTarget(v, TTarget) then
				count = count + 1
			end
			return_count = count
		end
		return return_count
	end
	return 0
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

--Circle AOE, Surrounding Player. Note: Not used in this Bard profile.
function EntityWithinRangeOfPlayer( _input_range )
	local return_count = 0
	local tbl = EntityList('alive,attackable,targetable,onmesh,maxdistance2d='..tostring( math.ceil( _input_range ) ) )
	if table.valid(tbl) then
		for k, v in pairs(tbl) do
			if v.distance2d <= 3.5 then
				return_count = return_count + 1
			end
		end
		return return_count
	end
	return 0
end

--Bomb AOE, Surrounding Target
function EntityWithinRangeOfTarget( _input_range, _input_radius )
	local TTarget = MGetTarget() or nil
	local tbl = MEntityList("alive,attackable,targetable,onmesh,maxdistance2d=" ..tostring( math.ceil( _input_range + _input_radius ) ) )
	if TTarget and table.valid(tbl) then
		local return_count = 1
		for id, entity in pairs(tbl) do
			local exactDistance2d = Distance2D(TTarget.pos.x, TTarget.pos.z, entity.pos.x, entity.pos.z)
			local desiredDistance2d = exactDistance2d - entity.hitradius
			if desiredDistance2d < _input_radius then
				return_count = return_count + 1
			end
		end
		return return_count
	end
	return 0
end


-- <Variables>

	local PulseRate = gPulseTime*0.001
	local TimeLastSwitchTarget = Now()
	local TimeLastSwitchWait = 550
	

-- The Cast() function is where the magic happens.
-- Action code should be called and fired here.
function profile.Cast()

	math.randomseed(os.time())
	
	
	--[[
	function super_LOCK()
		if TimeSince(_s.timers.super_LOCK) >= gPulseTime then
			_s.timers.super_LOCK = Now()
			return true
		else
			return false
		end
	end

	if super_LOCK() then
		return
	end]]
	

	-- These variables need to be updated somewhere like here, if outside this .Cast or .onUpdate, it won't update for example.
	local globalRecast			 = heavy_shot.recasttime
	local globalRecastPlusPulse	 = heavy_shot.recasttime + PulseRate
	local tillNextGCD			 = heavy_shot.cdmax - heavy_shot.cd
	local tillNextGCDPlusPulse 	 = PulseRate + tillNextGCD
	local lastCast 				 = Player.castinginfo.lastcastid
	local oGCD_lateWeave = 0.50
	
	local SongType 			 	= Player.gauge[1]
	local SongGauge 			= Player.gauge[2]
	local SongRemainingTime		= Player.gauge[3]
	local SoulGauge				= Player.gauge[4]
	
	local Songs = { the_wanderers_minuet = 15, mages_ballad = 5, armys_paeon = 10 }
	local Songs_Coda = { }

--[[
	local aliveParty = MEntityList('myparty,los,alive,targetable,maxdistance2d=30')
	local lowestAliveParty = MEntityList('lowesthealth,myparty,los,alive,targetable,maxdistance2d=30')
	local alivePartyAOEheal = MEntityList('myparty,los,alive,targetable,maxdistance2d=15')
	local deadParty = MEntityList('myparty,los,dead,targetable,maxdistance2d=25')
]]

	-- Check if trait is unlocked by level
	function hasTrait( _string_trait_name )
		return Player.level >= Traits[ _string_trait_name ]
	end
	-- Check if can Early Weave
	function isEarlyWeavable()
		return tillNextGCD >= globalRecast - oGCD_lateWeave
	end
	-- Check if can Late Weave
	function isLateWeavable()
		return tillNextGCD <= oGCD_lateWeave + 0.05 and tillNextGCD >= oGCD_lateWeave
	end

	-- Check if off GlobalRecast
	function isCurrentlyOffGCD()
		return tillNextGCD >= oGCD_lateWeave
	end
	
	-- Return MS Cooldown of Skill
	function getCooldown(skill)
		return skill.cdmax - skill.cd
	end
	
	-- Check if Cooldown is less than or equal to
	function isCooldown_lessOrEqual(_skill, _num_ms)
		return _skill.cdmax - _skill.cd <= _num_ms
	end
	
	function lastCastIs( _skill )
		return Player.castinginfo.lastcastid == _skill.id
	end

	function lastCastNot( _skill )
		return Player.castinginfo.lastcastid ~= _skill.id
	end
	
	--[[
	-- Check if respected Song is being sung
	function isSong_Minuet()
		d(SongType.." songtype "..Songs["the_wanderers_minuet"].." m "..Songs["mages_ballad"].." b "..Songs["armys_paeon"])
		return SongType == Songs["the_wanderers_minuet"]
	end
	function isSong_Ballad()
		d(tostring((SongType == Songs["mages_ballad"])).." song is minute")
		return SongType == Songs["mages_ballad"]
	end
	function isSong_Army()
		d(tostring((SongType == Songs["armys_paeon"])).." song is minute")
		return SongType == Songs["armys_paeon"]
	end
	function isNo_Songs()
		if isSong_Minuet() or isSong_Ballad() or isSong_Army() then
			return false
		else
			return true
		end
	end
	]]

	-- Check if respected Song is being sung
	function isSong_Minuet()
		return PlayerHasBuffs(the_wanderers_minuet_b)
	end
	function isSong_Ballad()
		return PlayerHasBuffs(mages_ballad_b)
	end
	function isSong_Army()
		return PlayerHasBuffs(armys_paeon_b)
	end
	function isNo_Songs()
		if isSong_Minuet() or isSong_Ballad() or isSong_Army() then
			return false
		else
			return true
		end
	end

	-- Check if Song Duration is less than or equal to
	function songTime_lessOrEqual( _num_ms )
		return SongRemainingTime <= _num_ms*1000
	end
	
	-- Check if should perform cone AOE
	function shouldUse_ConeAoe( _num_target_threshold )
		if EntityCountBetweenPlayerAndTarget( quick_nock.range ) >= _num_target_threshold	then	return true		else	return false	end
	end
	
	function shouldUse_shadowbite( _num_target_threshold )
		if EntityWithinRangeOfTarget( shadowbite.range, shadowbite.radius ) >= _num_target_threshold		then	return true		else	return false	end
	end





    local Target = MGetTarget() or nil
	local Target_distance2d = nil
	
	if Target then
		Target_distance2d =Target.distance2d
	end


		--Functions
	-- Use AOE Attacks Logics.
	function useAOE_skills(Target)
	
		if settings_useAOE and shouldUse_ConeAoe( 2 ) then
			local COOLDOWN_OFFSET = 15
			if hasTrait( "enhanced_bloodletter" ) then
				COOLDOWN_OFFSET = 0
			end
					-- oGCD
			if settings_use_raging_strikes and raging_strikes:IsReady(Player.id) and Target_distance2d < quick_nock.range and (quick_nock.usable or ladonsbite.usable) then
				if isCooldown_lessOrEqual( barrage, 2*globalRecast ) or PlayerHasBuffs( barrage_b ) then
					raging_strikes:Cast(Player.id)
					return "confirm"
				end
			end

		
			if isSong_Ballad() and isCooldown_lessOrEqual( rain_of_death, 2*globalRecast + 7.5 + COOLDOWN_OFFSET ) then
				if rain_of_death:IsReady(Target.id) then
					rain_of_death:Cast(Target.id)
					return "confirm"
				end
			elseif isCooldown_lessOrEqual( rain_of_death, 2*globalRecast + COOLDOWN_OFFSET ) then
				if rain_of_death:IsReady(Target.id) then
					rain_of_death:Cast(Target.id)
					return "confirm"
				end
			elseif PlayerHasBuffs(raging_strikes_b, 0.05) then
				if not battle_voice.usable or PlayerHasBuffs(battle_voice_b, 0.05) then
					if not radiant_finale.usable or PlayerHasBuffs(radiant_finale_b, 0.05) then
						if rain_of_death:IsReady(Target.id) then
							rain_of_death:Cast(Target.id)
							return "confirm"
						end
					end
				end
			end


			if shouldUse_shadowbite(2) and shadowbite:IsReady(Target.id) then
				shadowbite:Cast(Target.id)
				return "confirm"
			end
				
			
			if ladonsbite:IsReady(Target.id) then
				ladonsbite:Cast(Target.id)
				return "confirm"
			elseif not shadowbite.usable and not shouldUse_ConeAoe( 3 ) and refulgent_arrow:IsReady(Target.id) then
				refulgent_arrow:Cast(Target.id)
				return "confirm"
			elseif quick_nock:IsReady(Target.id) then
				quick_nock:Cast(Target.id)
				return "confirm"
			end
			
		end
	end




	-- Start Skills


	if isCurrentlyOffGCD() then
	
		-- <Iron Will>

	end






	if not Target then
	
	
	
	



	elseif Target and Target.attackable and Target.alive then

	
		if isEarlyWeavable() then
		--[[
			if PlayerMissingBuffs( straight_shot_ready_b ) then
				if isCooldown_lessOrEqual( raging_strikes, tillNextGCD - 0.55 ) or PlayerHasBuffs( raging_strikes_b ) then
					if barrage:IsReady(Player.id) then
						barrage:Cast(Player.id)
						return
					end
				end
			end
		]]
		end
	
		--[[
		-- Late Weaving
		if isLateWeavable() then
			if Player.castinginfo.lastcastid == raging_strikes.id then
				if songTime_lessOrEqual( 2*globalRecast ) then
					if the_wanderers_minuet:IsReady(Target.id) then
						the_wanderers_minuet:Cast(Target.id)
						return
					elseif mages_ballad:IsReady(Target.id) then
						mages_ballad:Cast(Target.id)
						return
					elseif armys_paeon:IsReady(Target.id) then
						armys_paeon:Cast(Target.id)
						return
					end
				end
			end
			if isCooldown_lessOrEqual( barrage, 2*globalRecast ) or PlayerHasBuffs( barrage_b ) then
				raging_strikes:Cast(Player.id)
				return
			end
		end
		]]
		
		-- oGCD non Late Weaves
		if isCurrentlyOffGCD() then

			-- Raging Strikes
			if settings_use_raging_strikes then
				if isCooldown_lessOrEqual( barrage, 2*globalRecast ) or PlayerHasBuffs( barrage_b ) or not barrage.usable then
					if isCooldown_lessOrEqual( battle_voice, 2*globalRecast ) or not battle_voice.usable then
						if raging_strikes:IsReady(Player.id) then
							raging_strikes:Cast(Player.id)
							return
						end
					end
				end
			end

			-- Songs
			--if TimeSince( _s.timers.songAttempt ) >= globalRecast/4 then
			if settings_singSong then
				if lastCastNot( the_wanderers_minuet ) and lastCastNot( mages_ballad ) and lastCastNot( armys_paeon ) then
					if isNo_Songs() or songTime_lessOrEqual( globalRecast/2  ) then
						if the_wanderers_minuet:IsReady(Target.id) then
							the_wanderers_minuet:Cast(Target.id)
							_s.timers.songAttempt = Now()
							return
						elseif mages_ballad:IsReady(Target.id) then
							mages_ballad:Cast(Target.id)
							_s.timers.songAttempt = Now()
							return
						elseif armys_paeon:IsReady(Target.id) then
							armys_paeon:Cast(Target.id)
							_s.timers.songAttempt = Now()
							return
						end
					elseif isSong_Army() and songTime_lessOrEqual( globalRecast/2  ) then
						if the_wanderers_minuet:IsReady(Target.id) then
							the_wanderers_minuet:Cast(Target.id)
							_s.timers.songAttempt = Now()
							return
						elseif mages_ballad:IsReady(Target.id) then
							mages_ballad:Cast(Target.id)
							_s.timers.songAttempt = Now()
							return
						end
					elseif ( isSong_Minuet() or isSong_Ballad() ) and songTime_lessOrEqual( globalRecast/2 ) then
						if armys_paeon:IsReady(Target.id) then
							armys_paeon:Cast(Target.id)
							_s.timers.songAttempt = Now()
							return
						end
					end
				end
			end
			--end

			-- Battle Voice
			if PlayerHasBuffs( raging_strikes_b ) or lastCastIs( raging_strikes ) then
				if battle_voice:IsReady(Player.id) then
					battle_voice:Cast(Player.id)
					return
				end
			end

			--Radiant Finale
			if ( PlayerHasBuffs( raging_strikes_b ) or lastCastIs( raging_strikes ) ) and ( PlayerHasBuffs( battle_voice_b ) or lastCastIs( battle_voice ) ) then
				if radiant_finale:IsReady(Player.id) then
					radiant_finale:Cast(Player.id)
					return
				end
			end
			
			-- Barage
			if PlayerMissingBuffs( straight_shot_ready_b ) then
				if isCooldown_lessOrEqual( raging_strikes, tillNextGCD - 0.55 ) or PlayerHasBuffs( raging_strikes_b ) then
					if not battle_voice.usable or PlayerHasBuffs( battle_voice_b ) or lastCastIs( battle_voice ) then
						if not radiant_finale.usable or PlayerHasBuffs( radiant_finale_b ) or lastCastIs( radiant_finale ) then
							if barrage:IsReady(Player.id) then
								barrage:Cast(Player.id)
								return
							end
						end
					end
				end
			end
		
			if settings_use_second_wind then
				if Player.hp.percent <= settings_use_second_wind_HP then
					if second_wind:IsReady(Player.id) then
						second_wind:Cast(Player.id)
						return
					end
				end
			end
			
		end

		--if PlayerHasBuffs( blast_arrow_ready_b )
		if blast_arrow:IsReady(Target.id) then
			if PlayerMissingBuffs( blast_arrow_ready_b, 2*globalRecast) then
				blast_arrow:Cast(Target.id)
				return
			elseif PlayerHasBuffs(raging_strikes_b, 0.05) then
				if not battle_voice.usable or PlayerHasBuffs(battle_voice_b, 0.05) then
					if not radiant_finale.usable or PlayerHasBuffs(radiant_finale_b, 0.05) then
						blast_arrow:Cast(Target.id)
						return
					end
				end
			end
		end
	
		if SoulGauge >= settings_apex_arrow_soulgauge then
			if apex_arrow:IsReady(Target.id) then
				apex_arrow:Cast(Target.id)
				return
			end
		end
		if PlayerHasBuffs( raging_strikes_b ) and PlayerMissingBuffs( raging_strikes_b, 2*globalRecast ) then
			if apex_arrow:IsReady(Target.id) then
				apex_arrow:Cast(Target.id)
				return
			end
		end
		
		-- AOE Attacks
		if useAOE_skills(Target) == "confirm" then
			return
		end
		
		if isCurrentlyOffGCD() then
			if empyreal_arrow:IsReady(Target.id) then
				empyreal_arrow:Cast(Target.id)
				return
			end	
			
			if sidewinder:IsReady(Target.id) then
				sidewinder:Cast(Target.id)
				return
			end
			
						-- Pitch Perfect
			if pitch_perfect:IsReady(Target.id) then
				if SongGauge == 3 or songTime_lessOrEqual( globalRecast ) then
					pitch_perfect:Cast(Target.id)
					return
				end
			end
			
			if bloodletter:IsReady(Target.id) then
			
				local COOLDOWN_OFFSET = 15
				if hasTrait( "enhanced_bloodletter" ) then
					COOLDOWN_OFFSET = 0
				end
				

				if isSong_Ballad() and isCooldown_lessOrEqual( bloodletter, 2*globalRecast + 7.5 + COOLDOWN_OFFSET ) then
					if bloodletter:IsReady(Target.id) then
						bloodletter:Cast(Target.id)
						return "confirm"
					end
				elseif isCooldown_lessOrEqual( bloodletter, 2*globalRecast + COOLDOWN_OFFSET ) then
					if bloodletter:IsReady(Target.id) then
						bloodletter:Cast(Target.id)
						return "confirm"
					end
				elseif PlayerHasBuffs(raging_strikes_b, 0.05) then
					if not battle_voice.usable or PlayerHasBuffs(battle_voice_b, 0.05) then
						if not radiant_finale.usable or PlayerHasBuffs(radiant_finale_b, 0.05) then
							if bloodletter:IsReady(Target.id) then
								bloodletter:Cast(Target.id)
								return "confirm"
							end
						end
					end
				end

			end
		end
		
		if PlayerHasBuffs( straight_shot_ready_b ) and PlayerMissingBuffs( straight_shot_ready_b, globalRecast) then
			if refulgent_arrow:IsReady(Target.id) then
				refulgent_arrow:Cast(Target.id)
				return
			end
		end
		
		if settings_use_dots and Target.hp.current >= settings_dots_triggerHP* Player.hp.current then
			local settings_dots_time_activation = settings_dots_modifier *globalRecast
			
			if stormbite.usable then
				if TargetMissingBuffs(stormbite_db, settings_dots_time_activation) then
					if iron_jaws.usable and TargetHasBuffs(stormbite_db, tillNextGCD + 0.05) then
						if iron_jaws:IsReady(Target.id) then
							iron_jaws:Cast(Target.id)
							return
						end
					elseif stormbite:IsReady(Target.id) then
						stormbite:Cast(Target.id)
						return
					end
				end
			end
			
			if caustic_bite.usable then
				if TargetMissingBuffs(caustic_bite_db, settings_dots_time_activation) then
					if iron_jaws.usable and TargetHasBuffs(caustic_bite_db, tillNextGCD + 0.05) then
						if iron_jaws:IsReady(Target.id) then
							iron_jaws:Cast(Target.id)
							return
						end
					elseif caustic_bite:IsReady(Target.id) then
						caustic_bite:Cast(Target.id)
						return
					end
				end
			end
			
			if TargetMissingBuffs(windbite_db, settings_dots_time_activation) then
				if iron_jaws.usable and TargetHasBuffs(windbite_db, tillNextGCD + 0.05) then
					if iron_jaws:IsReady(Target.id) then
						iron_jaws:Cast(Target.id)
						return
					end
				elseif windbite:IsReady(Target.id) then
					windbite:Cast(Target.id)
					return
				end
			elseif TargetMissingBuffs(venomous_bite_db, settings_dots_time_activation) then
				if iron_jaws.usable and TargetHasBuffs(venomous_bite_db, tillNextGCD + 0.05) then
					if iron_jaws:IsReady(Target.id) then
						iron_jaws:Cast(Target.id)
						return
					end
				elseif venomous_bite:IsReady(Target.id) then
					venomous_bite:Cast(Target.id)
					return
				end
			end
		end


		-- Basic Combo 3
		
		if refulgent_arrow:IsReady(Target.id) then
			refulgent_arrow:Cast(Target.id)
			return
		elseif straight_shot:IsReady(Target.id) then
			straight_shot:Cast(Target.id)
			return
		end
			

		-- Basic Combo Start
		if burst_shot:IsReady(Target.id) then
		
			burst_shot:Cast(Target.id)
			return
			
		elseif heavy_shot:IsReady(Target.id) then
		
			heavy_shot:Cast(Target.id)
			return

		end -- The End


	
	end -- The End End
	

	



    return false
end


-- Return the profile to ACR, so it can be read.
return profile