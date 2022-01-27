local tbl = {


  Execute = function()
	
	if TimeSince(h_lib.timers.buy_housing) > math.random( h_lib.Settings.auto_buy_housing_min_delay, h_lib.Settings.auto_buy_housing_min_delay + h_lib.Settings.auto_buy_housing_pulse_atop ) then
		h_lib.timers.buy_housing = Now()
	
		if not MGetTarget() then
		
			if TimeSince(h_lib.timers.wait_after_placard) > math.random( h_lib.Settings.auto_buy_housing_delay_between_buys, h_lib.Settings.auto_buy_housing_delay_between_buys + h_lib.Settings.auto_buy_housing_delay_between_buys_pulse_atop )  then
				local tbl = EntityList('maxdistance2d=2')
				if table.valid(tbl) then
					for key, entity in pairs(tbl) do
						if entity.name == "Placard" and entity.interactable then
							h_lib.UIUX.setLogicMessage("1. Found <Placard>, targetting.")
							Player:SetTarget(entity.id)
							return
						end
					end
				else
					h_lib.UIUX.setLogicMessage("1. No <Placard> within range, ending.")
					h_lib.Settings.auto_buy_housing = false
				end
			end
	
	
		elseif GetControl("HousingSignBoard") and GetControl("HousingSignBoard"):IsOpen() then
			h_lib.UIUX.setLogicMessage("2. <HousingSignBoard> Opened.")
			if GetControl("HousingSignBoard"):GetStrings()[6] == "" and GetControl("HousingSignBoard"):GetStrings()[13] == "" then 
				h_lib.UIUX.setLogicMessage("2. Plot Available, Owner: <" .. tostring(GetControl("HousingSignBoard"):GetStrings()[13]) .. ">, proceeding with Purchase.")
				GetControl("HousingSignBoard"):Action("PurchaseLand", 0)
				h_lib.timers.auto_buy_housing_timeout = Now()
				return
			else
				h_lib.UIUX.setLogicMessage("2. Someone ones this plot, Owner: <" .. tostring(GetControl("HousingSignBoard"):GetStrings()[13]) .. ">, ending.")
				GetControl("HousingSignBoard"):Close()
				h_lib.Settings.auto_buy_housing = false
			end
		
		
		elseif GetControl("SelectString") and GetControl("SelectString"):IsOpen() then
		
			h_lib.UIUX.setLogicMessage("3. <SelectString> Opened.")
			local STRINGS = GetControl("SelectString"):GetData()
			
			if h_lib.Settings.auto_buy_housing_type == 1 then
				if STRINGS[0] and string.find( STRINGS[0], "Private Individual." ) then
					h_lib.UIUX.setLogicMessage("3. <Private Individual.> string found, choosing option")
					GetControl("SelectString"):Action("SelectIndex", 0)
					h_lib.timers.auto_buy_housing_timeout = Now()
					return
				end
			elseif h_lib.Settings.auto_buy_housing_type == 2 then
				if STRINGS[1] and string.find( STRINGS[1], "Free Company." ) then
					h_lib.UIUX.setLogicMessage("3. <Free Company.> string found, choosing option")
					GetControl("SelectString"):Action("SelectIndex", 1)
					h_lib.timers.auto_buy_housing_timeout = Now()
					return
				end
			elseif h_lib.Settings.auto_buy_housing_type == 3 then
				if STRINGS[2] and string.find( STRINGS[2], "Private Residence Relocation" ) then
					h_lib.UIUX.setLogicMessage("3. <Private Residence Relocation> string found, choosing option")
					GetControl("SelectString"):Action("SelectIndex", 2)
					h_lib.timers.auto_buy_housing_timeout = Now()
					return
				end
			elseif h_lib.Settings.auto_buy_housing_type == 4 then
				if STRINGS[3] and string.find( STRINGS[3], "Free Company Estate Relocation" ) then
					h_lib.UIUX.setLogicMessage("3. <Free Company Estate Relocation> string found, choosing option")
					GetControl("SelectString"):Action("SelectIndex", 3)
					h_lib.timers.auto_buy_housing_timeout = Now()
					return
				end
			end
			
			h_lib.UIUX.setLogicMessage("3. Error, could not find <string> DM Hatter if have time. Ending.")
			h_lib.Settings.auto_buy_housing = false
		
		
		elseif GetControl("SelectYesno") and GetControl("SelectYesno"):IsOpen() then
		
			h_lib.UIUX.setLogicMessage("4. <SelectYesno> Opened.")
			
			if h_lib.Settings.auto_buy_housing_type == 1 or h_lib.Settings.auto_buy_housing_type == 2 then
				if string.find( GetControl("SelectYesno"):GetStrings()[2], "Purchase this plot of land" ) then
					h_lib.UIUX.setLogicMessage("4. Found <Purchase"..h_lib.Settings.auto_buy_housing_type.."> option, proceeding.")
					GetControl("SelectYesno"):Action("Yes", 0)
					h_lib.timers.auto_buy_housing_timeout = Now()
					h_lib.timers.wait_after_placard = Now()
					return
				end
			elseif h_lib.Settings.auto_buy_housing_type == 3 then
				if string.find( GetControl("SelectYesno"):GetStrings()[2], "Relocate to a new private estate" ) then
					h_lib.UIUX.setLogicMessage("4. Found <Relocate Private Estate> option, proceeding.")
					GetControl("SelectYesno"):Action("Yes", 0)
					h_lib.timers.auto_buy_housing_timeout = Now()
					h_lib.timers.wait_after_placard = Now()
					return
				end
			elseif h_lib.Settings.auto_buy_housing_type == 4 then
				if string.find( GetControl("SelectYesno"):GetStrings()[2], "Relocate to a new free company estate" ) then
					h_lib.UIUX.setLogicMessage("4. Found <Relocate Free-Company> option, proceeding.")
					GetControl("SelectYesno"):Action("Yes", 0)
					h_lib.timers.auto_buy_housing_timeout = Now()
					h_lib.timers.wait_after_placard = Now()
					return
				end
			end
	
			h_lib.UIUX.setLogicMessage("4. Error, could not find <string> DM Hatter if have time. Ending.")
			h_lib.Settings.auto_buy_housing = false

	
		elseif MGetTarget().name == "Placard" and MGetTarget().interactable then
			h_lib.UIUX.setLogicMessage("1. <Placard> is targeted, interacting with <Placard>")
			Player:Interact(MGetTarget().id)
			h_lib.timers.auto_buy_housing_timeout = Now()
			return
			
		
		end
		
		
		
		
		-- TIMEOUT
		if h_lib.timers.auto_buy_housing_timeout == 0 then
			h_lib.timers.auto_buy_housing_timeout = Now()
		end
		
		h_lib.UIUX.setLogicMessage("No UI found, time until Timed-Out : " .. tostring(	h_lib.Settings.auto_buy_housing_timeout - TimeSince(h_lib.timers.auto_buy_housing_timeout)	)	)
		if TimeSince(h_lib.timers.auto_buy_housing_timeout) > h_lib.Settings.auto_buy_housing_timeout then
			h_lib.timers.auto_buy_housing_timeout = 0
			h_lib.Settings.auto_buy_housing = false
			h_lib.UIUX.setLogicMessage("Ending, Timed-Out.")
		end

	
	
	end

  end,



  Name = "Bob"
}

return tbl