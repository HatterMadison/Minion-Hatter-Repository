-- ------------------------- Core ------------------------

h_lib = {}

-- ------------------------- Dev ------------------------

local LuaPath = GetLuaModsPath()
-- Check if a folder named HatterAdmin exists, if so, all paths that leads to your library or addons will have a "Dev" at the end.
-- eg. h_libDev\, HatterProfilesDev\
local DeveloperMode = FolderExists(LuaPath .. [[HatterAdmin\]]) or false
local DevPath = '' -- Keep this empty

if DeveloperMode then
    DevPath = [[Dev]]
end

-- ------------------------- Info ------------------------

h_lib.Info = {
    Author = "H",
    AddonName = "HatterLib",
    ClassName = "h_lib",
    Version = 1,
    StartDate = "01-04-2022",
    LastUpdate = "01-04-2022",
    Description = "H makes the codes! With help from community!",
    ChangeLog = {
        [1] = { Version = [[0.0.1]], Description = [[Starting development.]] }
    }
}

-- ------------------------- Paths ------------------------

LuaPath = GetLuaModsPath()
h_lib.LibraryPath = LuaPath .. [[HatterLib]] .. DevPath .. [[\]]
--h_lib.ModulePath         = LuaPath                   .. [[HatterLib]]      .. DevPath .. [[\]]
h_lib.MinionSettings = LuaPath .. [[ffxivminion\]]
--h_lib.ModuleSettingPath  = h_lib.MinionSettings       .. [[HatterLib_Settings]]      .. DevPath .. [[\]]
h_lib.LibrarySettingPath = h_lib.MinionSettings .. [[HatterLib_Settings]] .. DevPath .. [[\]]
h_lib.SettingsPath = h_lib.LibrarySettingPath .. [[HatterLib_Main_Settings.lua]]

-- ------------------------- Settings ------------------------

h_lib.DefaultSettings = {
	auto_venture = false,
	auto_venture_pulse = 750,
	auto_venture_pulse_plus = 250,

    Version = h_lib.Info.Version
}

-- ------------------------- States ------------------------

h_lib.Style = {}
h_lib.Misc = {}
h_lib.SaveLastCheck = Now()




-- Other Stuff
local timestamp = {}
	timestamp.auto_venture = Now()
local Double_Checker_AutoVenture = 0

-- ------------------ Quests Vars ----------------------

local quest_SpamButtonLastUpdatePulse = 0

-- ------------------ Quests Snipe Vars ----------------------


local snipe_LastUpdatePulse = 0
local snipe_MissCheckerTime = 0
local snipe_LoopIsRunning = false

local snipe_Current_Quest = nil
local snipe_Current_Progress = 1
local snipe_Current_Step = "1. Get Snipe Remaining Targets"

local snipe_Coordinates = nil
local snipe_Remaining_Targets = nil

local snipe_Current_Aim_x = nil
local snipe_Current_Aim_y = nil
local snipe_Current_Aim_Zoom = nil
local snipe_Current_Target_Name = nil



-- ------------------------- GUI ------------------------

h_lib.GUI = {
    Open = false,
    Visible = true,
    OnClick = loadstring(h_lib.Info.ClassName .. [[.GUI.Open = not ]] .. h_lib.Info.ClassName .. [[.GUI.Open]]),
    IsOpen = loadstring([[return ]] .. h_lib.Info.ClassName .. [[.GUI.Open]]),
    ToolTip = h_lib.Info.Description
}

-- ------------------------- Style ------------------------

h_lib.Style.MainWindow = {
    Size = { Width = 500, Height = 400 },
    Components = { MainTabs = GUI_CreateTabs([[Page 1,Page 2, Page 3]]) }
}

-- ------------------------- Log ------------------------

function h_lib.Log(log)
    local content = "==== [" .. h_lib.Info.AddonName .. "] " .. tostring(log)
    d(content)
end

-- ------------------------- Init ------------------------

function h_lib.Init()

    -- ------------------------- Folder Structure ------------------------

    if not FolderExists(h_lib.LibrarySettingPath) then
        FolderCreate(h_lib.LibrarySettingPath)
    end

    if FileExists(h_lib.SettingsPath) then
        h_lib.Settings = FileLoad(h_lib.SettingsPath)
    else
        FileSave(h_lib.SettingsPath, h_lib.DefaultSettings)
        h_lib.Settings = FileLoad(h_lib.SettingsPath)
    end
	
    -- ------------------------- Init Status ------------------------

    h_lib.Log([[Addon started]])

    -- ------------------------- Dropdown Member ------------------------

    local ModuleTable = h_lib.GUI
    ml_gui.ui_mgr:AddMember({
        id = h_lib.Info.ClassName,
        name = h_lib.Info.AddonName,
        onClick = function()
            ModuleTable.OnClick()
        end,
        tooltip = ModuleTable.ToolTip,
        texture = [[]]
    }, [[FFXIVMINION##MENU_HEADER]])

end


-- ------------------------- Draw ------------------------

function h_lib.MainWindow(event, tickcount)
    if h_lib.GUI.Open then

        -- ------------------------- MainWindow ------------------------

        --local flags = (GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoResize)
        --GUI:SetNextWindowSize(h_lib.Style.MainWindow.Size.Width, h_lib.Style.MainWindow.Size.Height, GUI.SetCond_Always)
        h_lib.GUI.Visible, h_lib.GUI.Open = GUI:Begin(h_lib.Info.AddonName, h_lib.GUI.Open) --, flags)

        local TabIndex, TabName = GUI_DrawTabs(h_lib.Style.MainWindow.Components.MainTabs)

        -- ------------------------- Tab 1 ------------------------

        if TabIndex == 1 then
			h_lib.Settings.auto_venture = GUI:Checkbox("Enables Reassign-Ventures",h_lib.Settings.auto_venture)
			GUI:PushItemWidth(90)
			h_lib.Settings.auto_venture_pulse = GUI:InputFloat("<Reassign-Ventures> Minimum Time Delay between each action. 1000 = 1 sec", h_lib.Settings.auto_venture_pulse)
			h_lib.Settings.auto_venture_pulse_plus = GUI:InputFloat([[<Reassign-Ventures> Random Delay Atop. math.random(min_delay, min_delay + random_delay)]], h_lib.Settings.auto_venture_pulse_plus)
			GUI:PopItemWidth()
        end

        -- ------------------------- Tabs 2 ------------------------

        if TabIndex == 2 then
            -- Do stuff
        end

        -- ------------------------- Tabs 3 ------------------------

        if TabIndex == 3 then
            -- Do stuff
        end

        GUI:End()
    end
end


-- Indoor Retainer Bell 196630, Outdoor Bell 2000401
function h_lib.auto_venture()
	if TimeSince(timestamp.auto_venture) >= math.random(h_lib.Settings.auto_venture_pulse, h_lib.Settings.auto_venture_pulse + h_lib.Settings.auto_venture_pulse_plus) then
		timestamp.auto_venture = Now()

		local L_RetainerList_Data = {}
		-- Raw String Index Data, that is string == complete
		L_VentureStatus_Index = {11, 20, 29, 38, 47, 56, 65, 74, 83}
		
		
		-- In conversation, skipping.
		if GetControl("Talk") and GetControl("Talk"):IsOpen() then
			d("___In Conversation___ talking..")
			UseControlAction("Talk","Click")
			return
		
		
		-- Retainer List UI
		elseif GetControl("RetainerList") and GetControl("RetainerList"):IsOpen() then

			-- Sets Control
			local L_control = GetControl("RetainerList")
			
			-- Iterate through 9 maximum retainers
			for key = 1, 9 do
				local bar = L_control:GetRawData()[	L_VentureStatus_Index[key]	]
				if bar then
					d(tostring(bar.value) .. "Index:  " .. key)
					-- if Venture Status is Complete, then interact with index retainer.
					if bar.value == "Complete" then
						d("___Found Completed Venture, Interacting with Retainer  " .. key)
						-- +1 cause Action 0 is sort retainer list.
						L_control:Action("SelectIndex", key - 1)
						return
					end
				end
			end
			
			if Double_Checker_AutoVenture > 1 then 
				Double_Checker_AutoVenture = 0
				h_lib.Settings.auto_venture = false
				d("___All Ventures Seems to be in progress, farewell")
			else
				Double_Checker_AutoVenture = Double_Checker_AutoVenture + 1
			end
		
		-- Retainer UI
		elseif GetControl("SelectString") and GetControl("SelectString"):IsOpen() then 
			local L_control = GetControl("SelectString")
			local tbl = L_control:GetData()
			-- View Report To Continue
			for k, v in pairs(tbl) do
				if v == "View venture report. (Complete)" then
					d("___Found Finished Venture Report, interacting")
					L_control:DoAction(k)
					return
				end
			end
			for k, v in pairs(tbl) do
				if v == "Quit." then
					d("___Venture Appears to be in Progress, exiting")
					L_control:DoAction(k)
					return
				end
			end
			
		-- Venture Report UI
		elseif GetControl("RetainerTaskResult") and GetControl("RetainerTaskResult"):IsOpen() then
			d("RetainerTaskResult UI Open, Reassigning Venture")
			--GetControl("RetainerTaskResult"):PushButton(25, 2) -- Complete
			GetControl("RetainerTaskResult"):PushButton(25, 3) -- ReAssign
			return
		
		
		-- Ventures Task Ask
		elseif GetControl("RetainerTaskAsk") and GetControl("RetainerTaskAsk"):IsOpen() then
			d("RetainerTaskAsk UI Open, Assigning Venture")
			GetControl("RetainerTaskAsk"):PushButton(25, 1) -- Assign
			return
			
		
		end
		
		h_lib.Settings.auto_venture = false
		d("___Could not find any open UI or Retainer")	
	else

	end

end


-- ACTUAL LIBRARY

-- FUNCTIONS

h_lib.assist = {}
h_lib.vars = {}
h_lib.vars.gQuestGatherAetherCurrents = nil


-- ------------------------- Save ------------------------

function h_lib.Save(force)
    if FileExists(h_lib.SettingsPath) then
        if (force or TimeSince(h_lib.SaveLastCheck) > 1000) then
            h_lib.SaveLastCheck = Now()
            FileSave(h_lib.SettingsPath, h_lib.Settings)
        end
    end
end
-- ------------------------- Update ------------------------

function h_lib.Update()
    h_lib.Save(false)


	if h_lib.Settings.auto_venture then
		h_lib.auto_venture()
	end

	-- Quest Related

	if FFXIV_Common_BotRunning then
		-- Quest Snipes
		if snipe_LoopIsRunning then
			h_lib.snipe_Loop()
		
		-- Zenos Fight 4464  buff 1271 is <Clashing>	PlayerHasBuffs(1271) and IsOnMap(1013) 
		elseif IsControlOpen("QTE") and TimeSince(quest_SpamButtonLastUpdatePulse) > math.random(120, 160) then
			PressKey(math.random(49,52))	-- will randomly press key 1,2, or 3 or 4
			quest_SpamButtonLastUpdatePulse = Now()
		

        -- Quest Duties
		
		-- Quest: Frosty Reception Character: Thancred
		elseif Player.contentid == 713 and IsOnMap(1010) and HasBuffs(Player, 1547) then
			local activate = h_lib.action.activate
			
			-- Determines Thancred Next Combo ID
			local L_lastSkillID = Player.castinginfo.lastcastid
			local L_nextComboSkill = 27429
			if L_lastSkillID == 27429 then
				L_nextComboSkill = 27427
			elseif L_lastSkillID == 27428 then
				L_nextComboSkill = 27429
			elseif L_lastSkillID == 27427 then
				L_nextComboSkill = 27428
			end


			if Player.incombat then
				local T = GetNearestFromList('alive,attackable,targetable,maxrange2d=5', Player.pos, 5)
				if T then
					activate(27430, Player, "Activating Defensive Buff")
					activate(L_nextComboSkill, T, "Activating Thancred Basic Combo")
				end
			else
				--activate(27432, Player, "Activating Stealth")
			end
		-- Renda Rae ShB DPS Quest
        elseif IsOnMap(875) then
            local heavy_shot = h_lib.andreia.skillIDs["heavy_shot"]
            local globalRecast = heavy_shot.recasttime
            local tillNextGCD = heavy_shot.cdmax - heavy_shot.cd
            local T = GetNearestFromList('contentid=8397,alive,attackable,maxrange2d=25', Player.pos, 25)
            local activate = h_lib.action.activate

            if T then

                --d(tostring(T.castinginfo.channelingid).."	"..tostring(T.castinginfo.channeltime))
                -- Silence 	-- silences at 2.7 s
                if T.castinginfo.channelingid == 17136 then
                    d("pass 1")
                    if type(T.castinginfo.channeltime) == "number" then
                        d("pass 2")
                        if T.castinginfo.channeltime <= globalRecast * 1.4 then
                            activate(17125, T, "Activating Silence")
                            return
                        end
                    end
                end

                -- Venom
                if TargetMissingBuffs(2073, globalRecast) then
                    activate(17122, T, "Activating Venom")
                    return
                end

                -- Second
                if Player.hp.percent <= 68 and tillNextGCD >= 0.75 then
                    if activate(17596, T, "Activating Second") then
                        return
                    end
                end

                -- Heavy
                if activate(17123, T, "Activating Heavy") then
                    return
                end


                -- Radiant
                if activate(17124, T, "Activating Radiant") then
                    return
                end

            end
        end	-- end Renda Rae
    end


end

--Check and Toggle
h_lib.assist.turn_off_gQuestGatherAetherCurrents = function(gVar)
    if gVar == true then
        h_lib.vars.gQuestGatherAetherCurrents = true
        gQuestGatherAetherCurrents = false
    end
end

h_lib.assist.switch_back_gQuestGatherAetherCurrents = function(gVar)
    if gVar == true then
        h_lib.vars.gQuestGatherAetherCurrents = nil
        gQuestGatherAetherCurrents = true
    end
end

-- About Actions Activations
h_lib.action = {}
h_lib.item = {}

h_lib.action.activate = function(_skillID, _target, _debugString, _actionType)
	local L_actionType = _actionType or 1
    local skill = ActionList:Get(L_actionType, _skillID)


    local target = _target or Player
    local debugString = "Attempted to use skill :\t" .. skill.name
	
	if _debugString then
		debugString = debugString .. "\t--\t" .. _debugString
	end

	if table.size(target) == 3 then
		if skill:IsReady(Player.id) then
			skill:Cast(target[1],target[2],target[3])
			if debugString then
				d(debugString)
			end
			return true
		end

    elseif skill:IsReady(target.id) then
        skill:Cast(target.id)
        if debugString then
            d(debugString)
        end
        return true
    end
end

h_lib.item.use = function(_itemID, _target, _debugString)
    local item = GetItem(_itemID)

    local target = _target or Player
    local debugString = "Attempted to use item :\t" .. item.name
	
	if _debugString then
		debugString = debugString .. "\t--\t" .. _debugString
	end

	if table.size(target) == 3 then
		if item:IsReady(Player.id) then
			item:Cast(target[1],target[2],target[3])
			if debugString then
				d(debugString)
			end
			return true
		end

    elseif item:IsReady(target.id) then
        item:Cast(target.id)
        if debugString then
            d(debugString)
        end
        return true
    end
end

--These currently stop everything.
--[[
h_lib.assist.wait = function(wait_duration)
	local entry_time = os.time()
	while os.time() - entry_time <= wait_duration do end
	d("H Finished waiting:\t" .. tostring(wait_duration))
end

h_lib.assist.waitRandom = function(wait_duration_low, wait_duration_high)
	local entry_time = os.time()
	local wait_duration = math.random(wait_duration_low *1000, wait_duration_high *1000) / 1000
	d("Random Wait Time:" .. tostring(wait_duration))
	while os.time() - entry_time <= wait_duration do end
	d("H Finished waiting:\t" .. tostring(wait_duration))
end
]]



-- Quest Mode Assistance
h_lib.questAssist = {}
h_lib.questAssist.TheHarvestBegin = function()
    local temp_v = h_lib.vars.TheHarvestBegin
    if temp_v == nil or temp_v == 24383 then
        return 24384
    elseif temp_v == 24384 then
        return 24382
    elseif temp_v == 24382 then
        return 24383
    end
end








-- ------------------------- "Quest Mode Snipes" ------------------------
-- ---------------Community thanks <HereToPlay> for making snipes automated in (H) MSQ
h_lib.snipeData = {}


--Quests Snipe Coordinates

h_lib.snipeData[4363] = { data = { { snipe_Pos = {	{x = 0.07,	y = -5.59,	zoom = 20, triggerPos = {590.2844, 160.4621, -572.0511}, range = 0.5 },
													{x = 11.16,	y = -4.35,	zoom = 20, triggerPos = {579.243, 160.4621, -600.9200}, range = 0.5 },
													{x = -0.45,	y = -4.31,	zoom = 20, triggerPos = {596.4335, 160.4621, -594.9351}, range = 0.5 },
													{x = -12.2,	y = -5.83,	zoom = 20, triggerPos = {599.2211, 160.4598, -566.3778}, range = 0.5 },
													{x = -12.06,y = -5.68,	zoom = 20, triggerPos = {599.6523, 160.462, -567.2333}, range = 0.5	} }, contentID = { "1041228" },	debugName = "<Large Green Bird>"	}	}	}

h_lib.snipeData[4406] = { data = { { snipe_Pos = {	{ x = 21.20, y = 39.02, zoom = 0, triggerPos = nil, range = nil },
													{ x = -6.59, y = 26.66, zoom = 0, triggerPos = nil, range = nil },
													{ x = -24.16, y = 45.50, zoom = 0, triggerPos = nil, range = nil } }, contentID = { "1038940" }, debugName = "<Runningway?>" } } }

h_lib.snipeData[4443] = { data = { { snipe_Pos = {	{ x = 27.92, y = 38.67, zoom = 0, triggerPos = { 106.9199, 47.8065, -134.5388 }, range = 0.5 } }, contentID = { "2012430" }, debugName = "<Tanks>" },
                                   { snipe_Pos = {	{ x = -3.43, y = 40.35, zoom = 0, triggerPos = { 146.2577, 52.7809, -159.7468 }, range = 0.5 } }, contentID = { "2012431" }, debugName = "<Metallic Tube>" },
                                   { snipe_Pos = {	{ x = -36.04, y = 45.15, zoom = 0, triggerPos = { 144.9149, 24.6738, -98.1918 }, range = 0.5 } }, contentID = { "2012432" }, debugName = "<Mushroom-like Thing>" }, } }

h_lib.snipeData[4460] = { data = { { snipe_Pos = {	{ x = -0.15, y = -4.9, zoom = 14, triggerPos = { 490.4655, 436.9999, 321.1776 }, range = 0.5 },
													{ x = -19, y = -10.54, zoom = 14, triggerPos = { 512.9772, 436.9999, 344.0130 }, range = 0.5 },
													{ x = 1.59, y = -4.13, zoom = 14, triggerPos = { 487.0543, 436.9998, 317.6472 }, range = 0.5 },
													{ x = 2.18, y = -6.21, zoom = 14, triggerPos = { 499.0868, 436.9999, 336.8289 }, range = 0.5 },
													{ x = 5.41, y = -8.00, zoom = 14, triggerPos = { 502.3710, 436.9994, 343.1401 }, range = 0.5 },
													{ x = 13.07, y = -4.28, zoom = 14, triggerPos = { 477.4892, 437.1468, 324.9234 }, range = 0.5 },
													{ x = 18.52, y = -5.55, zoom = 14, triggerPos = { 488.1547, 436.9994, 339.9326 }, range = 0.5 },
													{ x = 19.51, y = -5.4, zoom = 14, triggerPos = { 486.3983, 436.9998, 338.9318 }, range = 0.5 },
													{ x = 24.9, y = -8.91, zoom = 14, triggerPos = { 476.5239, 436.9420, 309.2545 }, range = 0.5 },
													{ x = 16.02, y = -3.3, zoom = 14, triggerPos = { 476.5239, 436.942, 309.2545 }, range = 0.5 } }, contentID = { "1041233" }, debugName = "<M-017>" } } }

h_lib.snipeData[4461] = { data = { { snipe_Pos = {	{ x = -40.99, y = 23.95, zoom = 0, triggerPos = { 610.4218, 442.5454, 399.6367 }, range = 0.005 }, -- Head
													{ x = -45.09, y = 15.36, zoom = 0, triggerPos = { 610.3576, 442.3059, 399.4908 }, range = 0.005 }, -- Chest
													{ x = -27.81, y = -0.43, zoom = 0, triggerPos = { 610.7385, 441.9021, 399.6974 }, range = 0.005 }, -- Right Arm
													{ x = -55.33, y = -7.15, zoom = 0, triggerPos = { 610.0660, 441.6893, 399.4476 }, range = 0.005 } }, contentID = { "1039768" }, debugName = "<Anomaly>" } } }    -- Left Leg







-- Quests Snipe Functions

h_lib.snipeCore = function(_quest_id)
    d("h_lib.snipeCore() Started")
    snipe_Current_Quest = _quest_id
    snipe_Coordinates = h_lib.snipeData[_quest_id]["data"]
    snipe_LoopIsRunning = true
end

h_lib.snipe_resetLoop = function()
    snipe_Current_Quest = nil
    snipe_Current_Step = "1. Get Snipe Remaining Targets"
    snipe_Current_Progress = 1
    snipe_LoopIsRunning = false
end

h_lib.snipe_verifyTarget = function(_contentids)

    --generic shoot if no content id is provided
    if _contentids == nil or _contentids == {} or #_contentids == 0 then
        if IsControlOpen("Snipe") then
            if Player:SnipeHasTarget() then
                Player:SnipeShoot()
                return true
            end
        end
        return false
    end

    local L_filter = ""
    for _, id in pairs(_contentids) do
        L_filter = L_filter .. "contentid=" .. id .. ","
    end

    if L_filter == "" then
        return false
    end

    if IsControlOpen("Snipe") then
        local tbl = EntityList(L_filter)
        local langName = {}
        for _, entity in pairs(tbl) do
            langName[#langName + 1] = entity.name
        end
        if langName == {} then
            h_lib.Log("ERROR NAME NOT FOUND")
            ml_gui.showconsole = true --force console open
            return false
        end
        if Player:SnipeHasTarget() then
            if table.contains(langName, GetControl("Snipe"):GetStrings()[9]) then
                Player:SnipeShoot()
                --d("Shoot " .. GetControl("Snipe"):GetStrings()[9])
                return true
            else
                h_lib.Log("ERROR - this should never trigger")
                ml_gui.showconsole = true --force console open
                return false
            end
        end
    end
    return false
end

h_lib.snipe_inRange = function(_entityPos, _savedLoc, _radius)
    local L_savedLoc = { h = 0, x = _savedLoc[1], y = _savedLoc[2], z = _savedLoc[3] }
    local L_entityPos = _entityPos
    local L_radius = _radius

    if L_radius == nil then
        L_radius = 5
    end
    if math.distance3d(L_entityPos, L_savedLoc) <= L_radius then
        return true
    else
        return false
    end
end

h_lib.snipe_selectBestPos = function(_current_snipe_Pos_ARR, _current_snipe_contentID)

    if #_current_snipe_Pos_ARR == 1 then
        return _current_snipe_Pos_ARR[1] --only one option
    end

    local lastLoc = nil
    if _current_snipe_contentID ~= nil then
        --returne random current_snipe_Pos if no spercific target required
        for _, current_snipe_Pos in pairs(_current_snipe_Pos_ARR) do
            if current_snipe_Pos.triggerPos ~= nil then
                --if not triggerPos ist set choose random
                local L_filter = "contentid="
                for _, id in pairs(_current_snipe_contentID) do
                    if L_filter == "contentid=" then
                        L_filter = L_filter .. id
                    else
                        L_filter = L_filter .. "," .. id
                    end
                end

                if L_filter == "contentid=" then
                    return false
                end

                local tbl = EntityList(L_filter)

                local range = 0.5 --fallback
                if current_snipe_Pos.range ~= nil then
                    range = current_snipe_Pos.range
                end
                for _, entity in pairs(tbl) do
                    if h_lib.snipe_inRange(entity.pos, current_snipe_Pos.triggerPos, range) then
                        h_lib.Log(entity.name .. "is in range of a postition")
                        return current_snipe_Pos --return position where target nearby
                    end
                end
            end
        end
    end

    lastLoc = _current_snipe_Pos_ARR[math.random(#_current_snipe_Pos_ARR)]-- uses random aviable current_snipe_Pos if no valid current_snipe_Pos is found
    return lastLoc --fallback
end

-- Current Version
h_lib.snipe_Loop = function()


    if snipe_Current_Quest == nil then
        return
    end

    if IsControlOpen("Snipe") then
        if TimeSince(snipe_LastUpdatePulse) > math.random(150, 200) then
            -- ms

            --d("Snipe Control Still Open, trying to snipe")

            h_lib.Log("snipe_Current_Step: " .. snipe_Current_Step)

            if snipe_Current_Step == "1. Get Snipe Remaining Targets" then
                if #snipe_Coordinates < snipe_Current_Progress then
                    h_lib.Log("All Snipes Done")
                    h_lib.snipe_resetLoop()
                end

                --get Remaining Targets
                snipe_targets_left = Player:GetSnipeTargetsRemain()
                if snipe_targets_left ~= 0 then
                    snipe_Current_Step = "2. Getting Aim Data"
                    snipe_LastUpdatePulse = 0
                end
            elseif snipe_Current_Step == "2. Getting Aim Data" then

                if snipe_targets_left == 0 then
                    --end loop
                    h_lib.Log("All Snipes Done")
                    h_lib.snipe_resetLoop()
                end

                local current_snipe_Pos_ARR = snipe_Coordinates[snipe_Current_Progress].snipe_Pos
                local current_snipe_contentID = snipe_Coordinates[snipe_Current_Progress].contentID

                local L_location = h_lib.snipe_selectBestPos(current_snipe_Pos_ARR, current_snipe_contentID)
                --get Aimposition
                snipe_Current_Aim_x = L_location.x
                snipe_Current_Aim_y = L_location.y
                snipe_Current_Aim_Zoom = L_location.zoom


                --does player hava a target
                if not Player:SnipeHasTarget() then
                    --set Snipe Cam
                    Player:SetSnipeCam(snipe_Current_Aim_x, snipe_Current_Aim_y, snipe_Current_Aim_Zoom)
                    --d("h_lib.snipecore Aimed At Location:    " .. location)
                end

				if h_lib.snipe_verifyTarget(current_snipe_contentID) then
					--d("h_lib.snipecore Shot At: Location" .. location)
					--d("Restarting")
					snipe_Current_Step = "3. Check if something was hit"
					snipe_MissCheckerTime = Now()
				else
					--d("missed or not target")
				end


            elseif snipe_Current_Step == "3. Check if something was hit" then
                -- shot was a miss
                -- check 100 times to make sure, by higher timesince reduce number should be around 10 Sec
                if TimeSince(snipe_MissCheckerTime) > 10000 then
                    --shot was a miss go back to step 1
                    -- !!!DONT INCREASE snipe_Current_Progress here!!!
                    snipe_Current_Step = "1. Get Snipe Remaining Targets"
                end
            else
                --d("should never come this far")
            end

            snipe_LastUpdatePulse = Now()
        end
    else
        --Target might be hit and we are in a transition window
        if Player:GetSnipeTargetsRemain() == 0 then
            --if this is 0 we most likely have hit all targets or left snipe cam
            h_lib.Log("All Snipes Done")
            h_lib.snipe_resetLoop()
        elseif snipe_Current_Step == "3. Check if something was hit" then
            --the shot seems to hav hit something but still more targets to go
            h_lib.Log("Snipe Hit confirmed")
            snipe_Current_Step = "1. Get Snipe Remaining Targets"
            snipe_Current_Progress = snipe_Current_Progress + 1
            snipe_MissCheckerTime = Now()
            snipe_LastUpdatePulse = Now()
        end
    end
end




-- Main SKILL TABLE to be used.
h_lib.ac = {}

-- Basic SKILL TABLE used to form tbl above.
h_lib.role = {}
h_lib.role.skillIDs = { 7541, 7542, 7548, 7546 }

h_lib.sage = {}
h_lib.sage.buffIDs = {}
h_lib.sage.skillIDs = { 24283, 24284, 24285, 24286, 24287, 24288, 24289, 24290,
                        24294, 24295, 24296, 24297, 24298, 24299, 24300, 24301,
                        24302, 24303, 24304, 24305, 24306, 24307, 27822, 27823,
                        27824, 27825, 27826, 27827, 27828, 27829, 27830, 27831,
                        27832, 27833, 27834, 27835 }

h_lib.reaper = {}
h_lib.reaper.buffIDs = {}
h_lib.reaper.skillIDs = { 24404, 24405, 24394, 24387, 24402, 24401, 24403, 24385,
                          24384, 24398, 24400, 24397, 24388, 24379, 24376, 24377,
                          24383, 24382, 24399, 24396, 24395, 24375, 24374, 24373,
                          24378, 24386, 24393, 24392, 24390, 24391, 24389, 24381,
                          24380 }

h_lib.andreia = {}
h_lib.andreia.skillIDsR = { dulling_arrow = 17125, heavy_shot = 17123, radiant_arrow = 17124, acidic_bite = 17122,
                            second_wind = 17596 }
h_lib.andreia.skillIDs = {}
for k, v in pairs(h_lib.andreia.skillIDsR) do
    h_lib.andreia.skillIDs[k] = ActionList:Get(1, v)
end

h_lib.andreia.buffIDs = { acidic_bite_b = 2073 }
h_lib.andreia.castIDs = { roar = 17136 }    -- silences at 2.7 s








-- Default Minion Functions
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

-- ------------------------- RegisterEventHandler ------------------------

RegisterEventHandler([[Module.Initalize]], h_lib.Init, [[h_lib.Init]])
RegisterEventHandler([[Gameloop.Update]], h_lib.Update, [[h_lib.Update]])
RegisterEventHandler([[Gameloop.Draw]], h_lib.MainWindow, [[h_lib.MainWindow]])
