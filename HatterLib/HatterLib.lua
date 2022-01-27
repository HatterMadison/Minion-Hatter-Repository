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
h_lib.SettingsPath = h_lib.LibrarySettingPath .. [[Main_Settings.lua]]
h_lib.LocalDataPath = h_lib.LibrarySettingPath .. [[Users_Local_Data.lua]]

-- ------------------------- Settings ------------------------

h_lib.Default_Settings = {
	UIUX = { CurrentWindow = "Auto-Venture",
			Hotbar = false,
			MainFrame = true,
			KeyRing = true},
	
	max_retainer = 10,
	store_stack_items = false,
	store_materias = false,
	auto_gardening = false,
	auto_mini_cactpot = false,
	auto_venture_assign = "",
	auto_venture = false,
	auto_inventory = false,
	auto_venture_pulse = 750,
	auto_venture_pulse_plus = 250,
	auto_buy_housing = false,
	auto_buy_housing_timeout = 8500,
	auto_buy_housing_min_delay = 525,
	auto_buy_housing_pulse_atop = 50,
	auto_buy_housing_delay_between_buys = 575,
	auto_buy_housing_delay_between_buys_pulse_atop = 50,
	auto_buy_housing_type = 1,
	combat_qte_assist = false,
	pvp_target_assist = false,
	pvp_target_assist_mintime = 650,
	pvp_target_assist_delaytime = 180,
	
	keys = { disableFlight = false },

    Version = h_lib.Info.Version
}

h_lib.Default_LocalData = {

	character_data = {}
}

-- ------------------------- States ------------------------

h_lib.Style = {}
h_lib.SaveLastCheck = Now()

-- Begin Inefficiencies

h_lib.directories = {}
h_lib.directories.GUI = {}
h_lib.directories.GUI.path = h_lib.LibraryPath .. [[GUI_Files\]]
h_lib.directories.GUI.Icons = {}
h_lib.directories.GUI.Icons.path = h_lib.directories.GUI.path .. [[Icons\]]
h_lib.directories.GUI.Animations = h_lib.directories.GUI.path .. [[Animations\]]
h_lib.directories.GUI.Icons.generals = h_lib.directories.GUI.Icons.path .. [[generals\]]
h_lib.directories.GUI.Icons.overlays = h_lib.directories.GUI.Icons.path .. [[overlays\]]
h_lib.directories.GUI.Icons.items = h_lib.directories.GUI.Icons.path .. [[items\]]
h_lib.directories.GUI.Icons.customs = h_lib.directories.GUI.Icons.path .. [[customs\]]

h_lib.keys = {}
h_lib.keys.steps = {}
h_lib.keys.steps.auto_gardening = 1

h_lib.switches = {}
h_lib.switches.LocalData = false
h_lib.switches.character_data = false
h_lib.switches.forget_that = true

h_lib.frameKeepers = {}

h_lib.string = {}
function h_lib.string.lowercase_and_underscore(_string)
	return string.lower(_string:gsub("%s", "_"))
end

h_lib.currents = {}
h_lib.currents.retainer = {}
h_lib.currents.character_data_file_path = h_lib.LibrarySettingPath .. "z_items_" .. Player.name:gsub("%s", "_") .. "_" .. Player.id .. ".lua"

h_lib.timers = {}
h_lib.timers.super = Now()
h_lib.timers.auto_buy_housing = Now()
h_lib.timers.collect_retainer_list = Now()
h_lib.timers.collect_retainer_inventory = Now()

h_lib.timers.buy_housing = Now()
h_lib.timers.auto_buy_housing_timeout = Now()
h_lib.timers.wait_after_placard = Now()

h_lib.timers.LocalData = Now()
h_lib.timers.character_data = Now()
h_lib.timers.PlayerJob = Now()
h_lib.timers.forget_this = 0


for key = 1, 5 do
	h_lib.timers[key] = Now()
end

h_lib.functions = {}
h_lib.functions.auto_buy_housing = FileLoad(h_lib.LibraryPath.."buy_housing.lua")


h_lib.libraries = {}
h_lib.libraries.npc = {}
h_lib.libraries.interactable = {}
h_lib.libraries.interactable.summoning_bells = {}

h_lib.assist = {}
h_lib.dev = {}
h_lib.vars = {}
h_lib.vars.gQuestGatherAetherCurrents = nil

--[[
h_lib.filenames = {
    "xxx.lua",
    "xxx.lua",
    "xxx.lua",
    "xxx.lua",
    "xxx.lua",
}
for _, v in pairs(h_lib.filenames) do  
    local fname = ml_global_information.path.."\\LuaMods\\HereToPlay\\scripts\\"..v
    if FileExists(fname) then
        loadfile(fname)()
    end
end
]]


--Summoning Bells (Exteriors)
-- Mor Dhona
table.insert( h_lib.libraries.interactable.summoning_bells, { name = "Summoning Bell", intName = "summoning_bell", contentID = 2000441, mapID = 156, mapName = "Mor Dhona", pos = { x = 12.8845, y = 29, z = -733.782 } }	)	-- Mor Dhona
table.insert( h_lib.libraries.interactable.summoning_bells, { name = "Summoning Bell", intName = "summoning_bell", contentID = 2000401, mapID = 339, mapName = "Mist", pos = { x = -657.8566, y = 29.806, z = -843.4261 } }	)	-- Mist Apartment Main
--table.insert( h_lib.libraries.interactable.summoning_bells, 	)

--Summoning Bells (Interiors)
table.insert( h_lib.libraries.interactable.summoning_bells, { name = "Summoning Bell", intName = "summoning_bell", contentID = 2000403, mapID = 177, mapName = "Mizzenmast Inn", pos = { x = -1.0459, y = 0, z = 5.1567 } }	)	-- Limsa
table.insert( h_lib.libraries.interactable.summoning_bells, { name = "Summoning Bell", intName = "summoning_bell", contentID = 2000403, mapID = 179, mapName = "The Roost", pos = { x = -1.7503, y = 0, z = 4.4355 } }	)	-- Girdania
table.insert( h_lib.libraries.interactable.summoning_bells, { name = "Summoning Bell", intName = "summoning_bell", contentID = 2000403, mapID = 178, mapName = "The Hourglass", pos = { x = 0.3286, y = 0.0136, z = 2.9932 } }	)	-- Uldah
table.insert( h_lib.libraries.interactable.summoning_bells, { name = "Summoning Bell", intName = "summoning_bell", contentID = 2000403, mapID = 429, mapName = "Cloud Nine", pos = { x = -2.9565, y = -0.0002, z = 5.1254 } }	)	-- Foundation
table.insert( h_lib.libraries.interactable.summoning_bells, { name = "Summoning Bell", intName = "summoning_bell", contentID = 2000403, mapID = 629, mapName = "Bokairo Inn", pos = { x = -0.6385, y = -0.1017, z = 3.1868 } }	)	-- Kugane
--[[
table.insert( h_lib.libraries.interactable.summoning_bells, 	)
table.insert( h_lib.libraries.interactable.summoning_bells, 	)
]]

-- NPC Shops
h_lib.libraries.npc.battlecraft_suppliers = {}
h_lib.libraries.npc.tool_suppliers = {}
h_lib.libraries.npc.tailors = {}
h_lib.libraries.npc.jewelers = {}
h_lib.libraries.npc.culinarians = {}
h_lib.libraries.npc.battlecraft_suppliers[149] = {}
h_lib.libraries.npc.tool_suppliers[149] = {}
h_lib.libraries.npc.tailors[149] = {}
h_lib.libraries.npc.jewelers[149] = {}
h_lib.libraries.npc.culinarians[149] = {}

table.insert( h_lib.libraries.npc.battlecraft_suppliers[149], { name = "Geraint", intName = "geraint", contentID = 1000217, mapID = 133, mapName = "Old Gridania", pos = { x = 167.8605, y = 15.6999, z = -77.7234 } } )
table.insert( h_lib.libraries.npc.tool_suppliers[149], { name = "Admiranda", intName = "admiranda", contentID = 1000218, mapID = 133, mapName = "Old Gridania", pos = { x = 163.4858, y = 15.6999, z = -63.1569 } } )
table.insert( h_lib.libraries.npc.tailors[149], { name = "Domitien", intName = "domitien", contentID = 1000215, mapID = 133, mapName = "Old Gridania", pos = { x = 158.9026, y = 15.5, z = -68.1322 } } )
table.insert( h_lib.libraries.npc.jewelers[149], { name = "Ilorie", intName = "ilorie", contentID = 1000216, mapID = 133, mapName = "Old Gridania", pos = { x = 161.0989, y = 15.5, z = -74.7255 } } )
table.insert( h_lib.libraries.npc.culinarians[149], { name = "Sasamero", intName = "sasamero", contentID = 1000232, mapID = 133, mapName = "Old Gridania", pos = { x = 161.9712, y = 15.5, z = -130.1231 } } )

-- Other Stuff
local timestamp = {}
	timestamp.auto_venture = Now()
	timestamp.auto_venture_timeout = 0
	timestamp.auto_inventory = Now()
	timestamp.auto_inventory_timeout = 0
	timestamp.pvp_last_time_selected_target = Now()
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

h_lib.UIUX = {}

h_lib.UIUX.MainFrame = {
	Open = true,
    Visible = true,
}

h_lib.UIUX.KeyRing = {
	Open = true,
    Visible = true,
}

h_lib.UIUX.styles = {}
h_lib.UIUX.styles.buttons = { on = {0, 0.9, 0, 0.7}, off = {0.95, 0, 0, 0.14} }

h_lib.UIUX.statuses = {}
h_lib.UIUX.statuses.main = "\t\tLali-ho! Ya Namazues!"

-- ------------------------- Style ------------------------

h_lib.Style.MainWindow = {
    Size = { Width = 500, Height = 400 },
    Components = { MainTabs = GUI_CreateTabs([[Keysets,Currently In Dev.]]) }
}

-- ------------------------- Log ------------------------

function h_lib.Log(log)
    local content = "==== [" .. h_lib.Info.AddonName .. "] " .. tostring(log)
    d(content)
end

-- ------------------------- Init ------------------------

function h_lib.Init()
	d("h_lib debug: initializing")

    -- ------------------------- Folder Structure ------------------------

    if not FolderExists(h_lib.LibrarySettingPath) then
        FolderCreate(h_lib.LibrarySettingPath)
    end

    if FileExists(h_lib.SettingsPath) then
	
	
		-- loading
        h_lib.Settings = FileLoad(h_lib.SettingsPath)
		
		-- adding
		for k, v in pairs(h_lib.Default_Settings) do
			if h_lib.Settings[k] == nil then
				d("h_lib debug : adding to <Main_Settings> : "..tostring(k))
				h_lib.Settings[k] = h_lib.Default_Settings[k]
			end
			if table.valid(h_lib.Default_Settings[k]) then
				for k2, v2 in pairs(h_lib.Default_Settings[k]) do
					if h_lib.Settings[k][k2] == nil then
						d("h_lib debug : adding to <Main_Settings> : "..tostring(k2))
						h_lib.Settings[k][k2] = h_lib.Default_Settings[k][k2]
					end
				end
			end
		end
		
		-- removing
		for k, v in pairs(h_lib.Settings) do
			if h_lib.Default_Settings[k] == nil then
				d("h_lib debug: removing from <Main_Settings> : "..tostring(k))
				--table.remove(h_lib.Settings, k)
				h_lib.Settings[k] = h_lib.Default_Settings[k]
			elseif table.valid(h_lib.Settings[k]) then
				for k2, v2 in pairs(h_lib.Settings[k]) do
					if h_lib.Default_Settings[k][k2] == nil then
						d("h_lib debug : adding to <Main_Settings> : "..tostring(k2))
						h_lib.Settings[k2] = h_lib.Default_Settings[k2]
					end
				end
			end
		end

    else
        FileSave(h_lib.SettingsPath, h_lib.Default_Settings)
        h_lib.Settings = h_lib.Default_Settings
    end



    if FileExists(h_lib.LocalDataPath) then
	
		-- loading
        h_lib.LocalData = FileLoad(h_lib.LocalDataPath)
		-- adding

		for k, v in pairs(h_lib.Default_LocalData) do
			if h_lib.LocalData[k] == nil then
				d("h_lib debug: removing from <Users_Local_Data> : "..tostring(k))
				h_lib.LocalData[k] = h_lib.Default_LocalData[k]
			end
			--[[
			if table.valid(h_lib.Default_LocalData[k]) then
				for k2, v2 in pairs(h_lib.Default_LocalData[k]) do
					if h_lib.LocalData[k][k2] == nil then
						h_lib.LocalData[k][k2] = h_lib.Default_LocalData[k][k2]
					end
				end
			end
			]]
		end

		-- removing
			--[[
		for k, v in pairs(h_lib.LocalData) do
			if h_lib.Default_LocalData[k] == nil then
				table.remove(h_lib.LocalData, k)
			end
			elseif table.valid(h_lib.LocalData[k]) then
				for k2, v2 in pairs(h_lib.LocalData[k]) do
					if h_lib.Default_LocalData[k][k2] == nil then
						table.remove(h_lib.LocalData[k], k2)
					end
				end
			end
		end
		]]
		
    else
        FileSave(h_lib.LocalDataPath, h_lib.Default_LocalData)
        h_lib.LocalData = h_lib.Default_LocalData
    end


	-- Preparing Table for Retainer Data if nonexistance
	if h_lib.LocalData.character_data[Player.id] == nil then
		d("____Creating <Empty Table> for <Current Character> within <All Character Data>.")
		h_lib.LocalData.character_data[Player.id] = {}
		d("____Creating <Empty Table> for <Retainers> within <Current Character Data>.")
		h_lib.LocalData.character_data[Player.id].Retainers = {}
	end
	h_lib.LocalData.character_data[Player.id].itemsPath = h_lib.currents.character_data_file_path
	h_lib.LocalData.character_data[Player.id].name = Player.name
	h_lib.LocalData.character_data[Player.id].id = Player.id
	h_lib.LocalData.character_data[Player.id].job = h_lib.getJobName( Player.job )
	
	h_lib.switches.LocalData = true
	
	
	local file_path = h_lib.currents.character_data_file_path
	
    if FileExists( file_path ) then
        h_lib.currents.character_data = FileLoad(file_path)
    else
        h_lib.currents.character_data = { name = Player.name, id = Player.id, Retainers = {} }
        FileSave( file_path, h_lib.currents.character_data )
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
local icon_folder = (GetStartupPath() .. "\\GUI\\H_UI_Icons\\")

local gui_icons_path = h_lib.directories.GUI.Icons.generals
local gui_overlays_path = h_lib.directories.GUI.Icons.overlays
local gui_items_path = h_lib.directories.GUI.Icons.items
local gui_customs_path = h_lib.directories.GUI.Icons.customs
local gui_overlays_key_1 = gui_overlays_path .. "overlay_key_1.png"

local gui_animation = {}

function h_lib.build_GUI_Animation(_stringTableAnimations, _stringFolderName, _numFrames)
	local FolderPath = h_lib.directories.GUI.Animations .. _stringFolderName
	if FolderExists( FolderPath ) then
		d("hh Folder Found")
		gui_animation[_stringTableAnimations] = {}
		for interval = 1, _numFrames do
			d(FolderPath .. interval .. ".png")
			gui_animation[_stringTableAnimations][interval] = FolderPath .."\\" .. interval .. ".png"
		end
	else
		d("hh Folder not Found for path : " .. FolderPath)
	end
end

function h_lib.getAnimationFrameNumber(_stringAnimationName, _stringFrameKeeper, _maxFrame, _FPS)
	local this_value = 1000/ _FPS
	
	if h_lib.frameKeepers[_stringFrameKeeper] == nil then
		h_lib.frameKeepers[_stringFrameKeeper] = 1
		return 1
		
	elseif h_lib.timers[_stringAnimationName] == nil then
		h_lib.timers[_stringAnimationName] = Now()
		return 1
		
	elseif TimeSince( h_lib.timers[_stringAnimationName] ) >= this_value then
		h_lib.timers[_stringAnimationName] = Now()
		if h_lib.frameKeepers[_stringFrameKeeper] == _maxFrame then
			h_lib.frameKeepers[_stringFrameKeeper] = 1
			--d("changing frame to " ..  h_lib.frameKeepers[_stringFrameKeeper])
			return h_lib.frameKeepers[_stringFrameKeeper]
		else
			h_lib.frameKeepers[_stringFrameKeeper] = h_lib.frameKeepers[_stringFrameKeeper] + 1
			--d("changing frame to " ..  h_lib.frameKeepers[_stringFrameKeeper])
			return h_lib.frameKeepers[_stringFrameKeeper]
		end
	end
end

gui_animation.spinning_h_icon = {}

h_lib.build_GUI_Animation( "spinning_h_icon", "spinning_h_icon", 6 )

-- 'cause I'm lazy
function h_lib.getJobName(_jobID)
	for job_name, job_id in pairs(FFXIV.JOBS) do
		if _jobID == job_id then
			return "<" .. tostring(job_name) .. ">"
		else
			return "<???>"
		end
	end
end

function h_lib.UIUX.build_on_off_buttons(_key_var)
	local L_textSettings = h_lib.UIUX.styles.buttons
	local L_parency_on = L_textSettings['off'][4]
	local L_parency_off = L_textSettings['on'][4]
	
	if h_lib.Settings[_key_var] then
		L_parency_on = L_textSettings['on'][4]
		L_parency_off = L_textSettings['off'][4]
	end

	GUI:PushStyleColor( GUI.Col_Button, L_textSettings['on'][1], L_textSettings['on'][2], L_textSettings['on'][3], L_parency_on )
	GUI:SmallButton( " On " )
	GUI:PopStyleColor( 1 )
	if GUI:IsItemClicked() then
		h_lib.Settings[_key_var] = true
	end
	
	GUI:SameLine( 0, 8 )
	
	GUI:PushStyleColor( GUI.Col_Button, L_textSettings['off'][1], L_textSettings['off'][2], L_textSettings['off'][3], L_parency_off )
	GUI:SmallButton( " Off " )
	GUI:PopStyleColor( 1 )
	if GUI:IsItemClicked() then
		h_lib.Settings[_key_var] = false
	end
end

function h_lib.build_GUI(temp_tbl, starting_index, ending_index)
	for LL_index = starting_index, ending_index do
		local character = temp_tbl[LL_index]
		local i_character = nil
		if FileExists(character.itemsPath) then
			i_character = FileLoad(character.itemsPath)
		end
		
		if i_character then
			local color_arr = {0.02, 0.02, 0.9, 1}
			if character.id ~= Player.id then
				color_arr = {0.01, 0.01, 0.9, 1}
			end
			

			if GUI:TreeNode( "" .. character.name .. "\t.id : " .. character.id ) then

				
				-- All Items

				if table.valid( i_character.all_items ) then
					if GUI:TreeNode( " + All Items") then
					
						GUI:SmallButton(" Update < + All Items> ")
						if GUI:IsItemClicked() then
							d(" Attempting to update table <All Items> ")
							h_lib.GenerateAllCurrentCharacterItems(character.id)
						end
						
						GUI:SameLine( 0, 4 )
						
						GUI:SmallButton(" Destroy < + All Items> ")
						if GUI:IsItemClicked() then
							h_lib.DestroyAllCurrentCharacterItems(character.id)
						end
						
						for each, item in pairs( i_character.all_items ) do
							local hq_status = "NQ"
							if item[2] then hq_status = "HQ" end
							GUI:BulletText( item[3] .. "x " .. hq_status .. " <" .. item[1] .. ">")
							GUI:Dummy(0, y_spacing_2)
						end
					GUI:TreePop()
					end
				elseif table.valid( i_character.Retainers ) then
					GUI:SmallButton(" Initalize <All Items> ")
					if GUI:IsItemClicked() then
						d(" Attempting to build table <All Items> ")
						h_lib.GenerateAllCurrentCharacterItems(character.id)
					end
				else
					GUI:Dummy(6, 0)
					GUI:SameLine( 0, 0 )
					GUI:SmallButton(" Go to <Summoning Bell> ")
					if GUI:IsItemHovered(GUI.HoveredFlags_Default) then GUI:SetTooltip( "Placeholder, currently does nothing." ) end
					if GUI:IsItemClicked() then
						d(" button go to <Summoning Bell> currently does nothing ")
					end
				end
				
				if table.valid( i_character.Retainers ) then
				
					-- Individual Retainers Items
					for index, retainer in pairs( i_character.Retainers ) do
						if retainer.name ~= nil then
							if GUI:TreeNode( "" .. index .. ". " .. retainer.name .. "" ) then
								if table.valid( retainer.inventory ) then
									for _bar_code, inventory in pairs(retainer.inventory) do
										for slot, item in pairs(inventory) do
											if item[h_lib.convertSavedData("name")] ~= nil then
												local hq_status = "NQ"
												if item[h_lib.convertSavedData("ishq")] then hq_status = "HQ" end
												GUI:BulletText( item[h_lib.convertSavedData("count")] .. "x " .. hq_status .. " <" .. item[h_lib.convertSavedData("name")] .. ">")
												GUI:Dummy(0, y_spacing_2)
											end
										end
									end
								else
									GUI:BulletText( "No Data" )
								end
							GUI:TreePop()
							end
						end
					end
				
				elseif not table.valid( i_character.Retainers ) then
					GUI:BulletText( "  No Retainer Data" )
				end
				
			
			GUI:TreePop()
			end
		end
	end
end

function h_lib.MainWindow(event, tickcount)

	if h_lib.Settings.UIUX.KeyRing then
		--GUI:SetNextWindowSize(50, 50, GUI.SetCond_Always)
		GUI:SetNextWindowPos(240, 32, GUI.SetCond_FirstUseEver)
		GUI:PushStyleColor(GUI.Col_WindowBg, 0, 0, 0, 0)
		
		h_lib.UIUX.KeyRing.Visible, h_lib.Settings.UIUX.KeyRing = GUI:Begin("##h_libKeyRingWindow", h_lib.Settings.UIUX.KeyRing, GUI.WindowFlags_NoTitleBar | GUI.WindowFlags_NoScrollbar | GUI.WindowFlags_NoCollapse | GUI.WindowFlags_NoResize | GUI.WindowFlags_AlwaysAutoResize )
		
		--GUI:PushStyleVar(GUI.StyleVar_WindowPadding, 0, 0)
	
		GUI:ImageButton( "##h_libKeyRingButton", gui_customs_path .. "gold_castrum_coffer_key_1.png", 32, 32, 0, 0, 1, 1, 2, 0, 0, 0, 1, 1, 1, 1, 1 )
		if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
			GUI:SetTooltip( "Opens <First Keyset>" )
		end
		if GUI:IsItemClicked() then
			h_lib.Settings.UIUX.MainFrame = not h_lib.Settings.UIUX.MainFrame
		end
	
		GUI:PopStyleColor(1)
		--GUI:PopStyleVar(1)
		
		GUI:End()
	end
	



    if h_lib.GUI.Open then

        -- ------------------------- MainWindow ------------------------

        --local flags = (GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoResize)
        --GUI:SetNextWindowSize(h_lib.Style.MainWindow.Size.Width, h_lib.Style.MainWindow.Size.Height, GUI.SetCond_Always)
        h_lib.GUI.Visible, h_lib.GUI.Open = GUI:Begin(h_lib.Info.AddonName, h_lib.GUI.Open) --, flags)
		
		if h_lib.GUI.Visible then
			

			local TabIndex, TabName = GUI_DrawTabs(h_lib.Style.MainWindow.Components.MainTabs)
			local y_spacing = 8
			local y_spacing_2 = 0
			-- ------------------------- Tab 1 ------------------------

			if TabIndex == 1 then
				GUI:PushItemWidth(90)
				
				h_lib.Settings.UIUX.KeyRing = GUI:Checkbox("Display <KeyRing>",h_lib.Settings.UIUX.KeyRing)
				GUI:Dummy(0, y_spacing_2)
				
				h_lib.Settings.UIUX.MainFrame = GUI:Checkbox("Opens <First Keyset>",h_lib.Settings.UIUX.MainFrame)
				GUI:Dummy(0, y_spacing_2)
				
				
				



			-- ------------------------- Tabs 2 ------------------------

			elseif TabIndex == 2 then

				h_lib.Settings.auto_gardening = GUI:Checkbox("<IN-DEV Auto-Gardening>",h_lib.Settings.auto_gardening)
				GUI:Dummy(0, y_spacing_2)
				
				h_lib.Settings.auto_mini_cactpot = GUI:Checkbox("<IN-DEV Auto-Mini-Cactpot>",h_lib.Settings.auto_mini_cactpot)
				GUI:Dummy(0, y_spacing_2)
				
				h_lib.Settings.keys.disableFlight = GUI:Checkbox("Dev Key: Disable Flight",h_lib.Settings.keys.disableFlight)
				GUI:PopItemWidth()
				
				

			-- ------------------------- Tabs 3 ------------------------


			end
		end
		
        GUI:End()
    end
	

	if h_lib.Settings.UIUX.MainFrame then

		h_lib.UIUX.MainFrame.Visible, h_lib.Settings.UIUX.MainFrame = GUI:Begin("First Keyset", h_lib.Settings.UIUX.MainFrame)
		
		if h_lib.UIUX.MainFrame.Visible then
			
			local temp_vx = 520
			local temp_vy = temp_vx*9/16
			GUI:SetNextWindowSize(temp_vx, temp_vy, GUI.SetCond_FirstUseEver)
			

			local y_spacing = 8
			local y_spacing_2 = 0

			local icon_px = 32
			local icon_spacing = 4
			local icon_spacing_break = 28
			local icon_padding = 1
			
			local x_pixel_distance = icon_px + 2*icon_padding
			local overlay_x_pixel_distance = 2*x_pixel_distance

			local current_color_value = {0.9, 0.1, 0.1, 0.5}
			local off_color_value = {0.4, 0.4, 0.4, 0.8}
			local on_color_value = {1, 1, 1, 1}
			
				if h_lib.Settings.UIUX.CurrentWindow == "Combat-Assist" then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("UI_auto_pvp_select", gui_items_path .. "halicarnassus_sword.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "<Combat-Assist>" )
				end
				if GUI:IsItemClicked() then
					if h_lib.Settings.UIUX.CurrentWindow ~= "Combat-Assist" then h_lib.Settings.UIUX.CurrentWindow = "Combat-Assist" end
				end
				--[[
				if h_lib.Settings.UIUX.CurrentWindow == "Combat-Assist" then
					GUI:SameLine( -overlay_x_pixel_distance, overlay_x_pixel_distance + 10 )
					GUI:Image(  gui_overlays_key_1, icon_px, icon_px )
					--local L_frame = h_lib.getAnimationFrameNumber("spinning_h_icon", "spinning_h_icon", 6, 4)
					--GUI:Image(  gui_animation.spinning_h_icon[ L_frame ] , icon_px, icon_px, 0, 0, 1, 1  )
					--GUI:Image(  gui_animation.spinning_h_icon[ 1 ] , icon_px, icon_px, 0, 0, 1, 1  )
				end
				]]
				GUI:SameLine( 0, icon_spacing_break/2 )

				if h_lib.Settings.UIUX.CurrentWindow == "Auto-Venture" then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("CW_auto_ventures", gui_customs_path .. "summoning_bell_3.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "<Auto-Venture>" )
				end
				if GUI:IsItemClicked() then
					if h_lib.Settings.UIUX.CurrentWindow ~= "Auto-Venture" then h_lib.Settings.UIUX.CurrentWindow = "Auto-Venture" end
				end
				GUI:SameLine( 0, icon_spacing_break/2 )
			
				if h_lib.Settings.UIUX.CurrentWindow == "Auto-Inventory" then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("CW_auto_inventory", gui_customs_path .. "dead_mans_chest_2.png", icon_px, icon_px, 1, 0, 0, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "<Auto-Inventory>" )
				end
				if GUI:IsItemClicked() then
					if h_lib.Settings.UIUX.CurrentWindow ~= "Auto-Inventory" then h_lib.Settings.UIUX.CurrentWindow = "Auto-Inventory" end
				end
				GUI:SameLine( 0, icon_spacing_break/2 )

				if h_lib.Settings.UIUX.CurrentWindow == "Storage-Data" then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("UI_storage_data", gui_customs_path .. "company_chest_1.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "<Storage-Data>" )
				end
				if GUI:IsItemClicked() then
					if h_lib.Settings.UIUX.CurrentWindow ~= "Storage-Data" then h_lib.Settings.UIUX.CurrentWindow = "Storage-Data" end
				end
				GUI:SameLine( 0, icon_spacing_break*2 )

				if h_lib.Settings.UIUX.CurrentWindow == "Auto-Buy-Housings" then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("CW_buy_housing", gui_customs_path .. "company_chest_1.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "<Auto-Buy-Housings>" )
				end
				if GUI:IsItemClicked() then
					if h_lib.Settings.UIUX.CurrentWindow ~= "Auto-Buy-Housings" then h_lib.Settings.UIUX.CurrentWindow = "Auto-Buy-Housings" end
				end
				GUI:SameLine( 0, icon_spacing_break*2 )
		
				if h_lib.GUI.Open then current_color_value = on_color_value else current_color_value = off_color_value end
			GUI:ImageButton("UI_open_main_option", gui_items_path .. "kitchen_hanger.png", icon_px, icon_px, 0, 0, 1, 1, icon_padding, 0, 0, 0, 0, current_color_value[1], current_color_value[2], current_color_value[3], current_color_value[4] )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "<Main Options>" )
				end
				if GUI:IsItemClicked() then
					if h_lib.GUI.Open == true then h_lib.GUI.Open = false else h_lib.GUI.Open = true end
				end
				--GUI:SameLine( 0, icon_spacing )

			GUI:Dummy(0, 2)
			GUI:Separator( )
			GUI:Text( "\t" .. h_lib.Settings.UIUX.CurrentWindow .. " :\t" .. h_lib.UIUX.statuses.main .. "" )
			GUI:Separator( )
			GUI:Dummy(0, 2)
			
			
			-- Trying to put Current Character atop list
			local temp_tbl = {}
			for k, v in pairs( h_lib.LocalData.character_data ) do
				if v.id == Player.id then
					temp_tbl[1] = v
					break
				end
			end
			-- Adding offline characters to list
			for k, v in pairs( h_lib.LocalData.character_data ) do
				if v.id ~= Player.id then
					table.insert( temp_tbl, v )
				end
			end
			
			
			if h_lib.Settings.UIUX.CurrentWindow == "Auto-Venture" then
				

				
		
				GUI:Dummy(0, 0)
				GUI:SameLine( 0, 4 )
				h_lib.UIUX.build_on_off_buttons("auto_venture")
				GUI:SameLine( 0, 12 )
				GUI:Text("<Auto-Venture>")
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "Will ring <Summoning Bell> if in range, <Auto-Venture>, then turn itself off, disengage <Bell> when finished sending." )
				end
				GUI:SameLine( 0, 16 )
				GUI:PushItemWidth(76)
				h_lib.Settings.max_retainer = GUI:InputInt( "Max Retainers", h_lib.Settings.max_retainer )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "Will send this many <Retainers> starting from top of <Retainer List>\n\n\t\tPrimarily used to disable sending attempt of unpaid <Retainers>\n\t\t\tOrganize unpaid <Retainers> at the bottom of list for example." )
				end
				GUI:PopItemWidth()
				GUI:PushItemWidth(65)
				GUI:SameLine( 0, 8 )
				h_lib.Settings.auto_venture_pulse = GUI:InputFloat("Minimum Delay", h_lib.Settings.auto_venture_pulse)
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "Minimum Delay between each action. (1000 = 1 sec)" )
				end
				GUI:SameLine( 0, 8 )
				h_lib.Settings.auto_venture_pulse_plus = GUI:InputFloat("Plus Pulse", h_lib.Settings.auto_venture_pulse_plus)
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "+ added to Minimum Delay to form Maximum Delay" )
				end
				--GUI:Dummy(0, y_spacing_2)
				GUI:PopItemWidth()

				
				GUI:Separator( )
				
				GUI:Dummy(0, 4)
				
				local VentureChoiceList = {
					[0] = "None",
					[1] = "Regular",
					[2] = "Exploration",
					[3] = "Quick",
					[4] = "Reassign",
				}
				
				local RegularVentureLevelRangeChoice = {
					[0] = "Lv 1-5",
					[1] = "Lv 6-10",
					[2] = "Lv 11-15",
					[3] = "Lv 16-20",
					[4] = "Lv 21-25",
					[5] = "Lv 26-30",
					[6] = "Lv 31-35",
					[7] = "Lv 36-40",
					[8] = "Lv 41-45",
					[9] = "Lv 46-50",
					[10] = "Lv 51-55",
					[11] = "Lv 56-60",
					[12] = "Lv 61-65",
					[13] = "Lv 66-70",
					[14] = "Lv 71-75",
					[15] = "Lv 76-80",
					[16] = "Lv 81-85",
					[17] = "Lv 86-90",
				}
				
				local LL_CHARACTERCOUNT = 0
				
				for index, character in pairs( temp_tbl ) do
				
				
				
				
				
				
					--local LLL = GUI:Combo( "##" .. character.id .. character.name .. "replaceALL", LLL, VentureChoiceList)
				
				
				
				
					LL_CHARACTERCOUNT = LL_CHARACTERCOUNT + 1
					local L_LSTATUS = "\t"
					local L_LCOUNT = 0
					local L_LCOUNT2 = 0
					
					for bar, retainer in pairs( h_lib.LocalData.character_data[character.id].Retainers ) do
						if retainer.int_venture_status == "Ongoing" and retainer.time_checked and retainer.venture_time_remain then
							if TimeSince( retainer.time_checked ) > retainer.venture_time_remain then
								h_lib.LocalData.character_data[character.id].Retainers[bar].int_venture_status = "Complete"
								h_lib.switches.LocalData = true
							end
						end
						
						if retainer.int_venture_status == "Complete" then
							L_LCOUNT = L_LCOUNT + 1
						elseif retainer.int_venture_status == "Ongoing" then
							L_LCOUNT2 = L_LCOUNT2 + 1
						end
					end
					
					if L_LCOUNT > 0 then L_LSTATUS = "\t" .. L_LCOUNT .. "x Complete" end
					if L_LCOUNT2 > 0 then L_LSTATUS = L_LSTATUS .. "\t" .. L_LCOUNT2 .. "x Ongoing" end
					if LL_CHARACTERCOUNT == 1 then
						GUI:SetNextTreeNodeOpened( true, GUI.SetCond_Once)
					end
					
					if GUI:TreeNode(	 "\t\t".. tostring(character.name) .. "\t" .. L_LSTATUS	) then
						if table.valid( character.Retainers ) then
						
							for index, retainer in pairs( h_lib.LocalData.character_data[character.id].Retainers ) do
								
								local bobby_bob = "##" .. character.id .. retainer.name
								
								local temp_string = bobby_bob .. "venture_type"
								local temp_string_2 = bobby_bob .. "venture_level_range"
								local temp_string_3 = bobby_bob .. "venture_id"
								
								
								GUI:PushItemWidth(70)
								h_lib.LocalData.character_data[character.id].Retainers[index].venture_type = GUI:Combo( temp_string, h_lib.LocalData.character_data[character.id].Retainers[index].venture_type, VentureChoiceList)
								if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
									GUI:SetTooltip( "Select the next type of Venture for this Retainer" )
								end
								GUI:PopItemWidth()
								GUI:SameLine( 0, 4 )
								
								GUI:PushItemWidth(78)
								h_lib.LocalData.character_data[character.id].Retainers[index].venture_level_range = GUI:Combo( temp_string_2, h_lib.LocalData.character_data[character.id].Retainers[index].venture_level_range, RegularVentureLevelRangeChoice)
								if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
									GUI:SetTooltip( "Only necessary for Regular venture, does not affect Exploration or Quick." )
								end
								GUI:PopItemWidth()
								GUI:SameLine( 0, 4 )
								
								GUI:PushItemWidth(68)
								h_lib.LocalData.character_data[character.id].Retainers[index].venture_id = GUI:InputInt( temp_string_3, h_lib.LocalData.character_data[character.id].Retainers[index].venture_id )
								if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
									GUI:SetTooltip( "Regular Venture: Index of item. Example, <Ice Shard> is 2, upon Lv 1-5 Mining Ventures.\nExploration Venture: Example, highest would be 1" )
								end
								GUI:PopItemWidth()
								GUI:SameLine( 0, 4 )
								

								
								local status = h_lib.LocalData.character_data[character.id].Retainers[index].int_venture_status
												
								
								if status == "Complete" then
									GUI:BulletText( index .. ". " .. tostring(retainer.name) .. " | " .. status	)
								elseif status == "Ongoing" then
									local tbl = h_lib.convertTime( retainer.venture_time_remain - TimeSince( retainer.time_checked ) )
									local hrs = tbl[1]
									local mins = tbl[2]
									local secs = tbl[3]
									if hrs == 0 then hrs = "" else hrs = hrs .. "h " end
									GUI:BulletText( index .. ". " .. tostring(retainer.name) .. " | " .. status )
									GUI:SameLine( 0, 8 )
									GUI:Text( " | " .. tostring(hrs) .. tostring(mins) .. "m " )
								elseif status == "None in progress" then
									GUI:BulletText(	"   None | " .. tostring(retainer.name) )
									GUI:SameLine( 0, 8 )
									GUI:Text( " | None in progress" )
								else
									GUI:BulletText(	index .. ". " .. tostring(retainer.name) .. " |  No Data" )
								end
								
								
								
								
								GUI:SameLine( 0, 12 )
									GUI:SmallButton(" <Remove> ")
									if GUI:IsItemClicked() then
										d("<Removing> " .. retainer.name .. "from index: " .. index)
										character.Retainers[index] = nil
									end
								
								GUI:Dummy(0, y_spacing_2)
								
							end
						else
							GUI:BulletText( " No Retainer Data" )
						end
					GUI:TreePop()
						
					
					
					
					end
				end
				
				if LL_CHARACTERCOUNT == 1 then
					GUI:Dummy(0, 6)
				end
				
				h_lib.switches.LocalData = true
				
			elseif h_lib.Settings.UIUX.CurrentWindow == "Auto-Inventory" then
			
				GUI:Dummy(0, 0)
				GUI:SameLine( 0, 4 )
				GUI:PushItemWidth(90)
				h_lib.UIUX.build_on_off_buttons("auto_inventory")
				GUI:SameLine( 0, 12 )
				GUI:Text("<Auto-Inventory-Storage>")
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "Will open <Summoning Bell> within range, entrust items to corresponding retainers if matched stackable with items in inventory.\n\n\tIf retainer is 175/175 and have 999x stack, bot will be stuck in loop. Im not sorry." )
				end
				
				GUI:Dummy(0, y_spacing_2)
				
				GUI:Separator( )
				
				--h_lib.Settings.auto_inventory = GUI:Checkbox("<Auto-Store-Stack-Items> All Retainers",h_lib.Settings.auto_inventory)

				GUI:Dummy(0, y_spacing_2)
				
				h_lib.Settings.store_stack_items = GUI:Checkbox("Current Opened Retainer Inventory, Store-Stack-Items.",h_lib.Settings.store_stack_items)
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "Does not affect <Auto-Storage-Inventory>, Requires opened <Retainer Inventory>." )
				end
				GUI:Dummy(0, y_spacing_2)
				
				h_lib.Settings.store_materias = GUI:Checkbox("Current Opened Retainer Inventory, Store-Materias",h_lib.Settings.store_materias)
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "Does not affect <Auto-Storage-Inventory>, Requires opened <Retainer Inventory>." )
				end
				GUI:Dummy(0, y_spacing_2)
				
				GUI:PopItemWidth()
				

			
				GUI:SetNextTreeNodeOpened( true, GUI.SetCond_Appearing)
				h_lib.build_GUI(temp_tbl, 1, 1)

			
			elseif h_lib.Settings.UIUX.CurrentWindow == "Storage-Data" then


				
				
					--GUI:Text( "  ____" )
				if GUI:TreeNode( " Current Character" ) then
					h_lib.build_GUI(temp_tbl, 1, 1)
				GUI:TreePop()	
				end
				
				
				

				GUI:Dummy(0, 5)
				

				if GUI:TreeNode( " Offline Characters" ) then

					h_lib.build_GUI(temp_tbl, 2, #temp_tbl)
				GUI:TreePop()
				end
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "This lags like crazy when opened and have few characters." )
				end

				
				
			elseif h_lib.Settings.UIUX.CurrentWindow == "Combat-Assist" then

				GUI:Dummy(0, 0)
				GUI:SameLine( 0, 4 )
				h_lib.UIUX.build_on_off_buttons("combat_qte_assist")
				
				GUI:SameLine( 0, 16 )
				
				--GUI:TextColored( L_textSettings[L_textStatus][1], L_textSettings[L_textStatus][2], L_textSettings[L_textStatus][3], L_textSettings[L_textStatus][4], "Auto-Quick Time Events" )
				GUI:Text( "<Auto-Quick-Time-Events>" )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "Will spam <1, 2, 3, 4> during <Quick Time Events>." )
				end
				
				GUI:Dummy(0, y_spacing_2)
				GUI:Separator( )
				
				GUI:PushItemWidth(90)
				
				
				GUI:Dummy(0, 20)
				GUI:Text("Belows are not functional or buggy.")
				h_lib.Settings.pvp_target_assist = GUI:Checkbox("Enables PVP Target Assistance",h_lib.Settings.pvp_target_assist)
				h_lib.Settings.pvp_target_assist_mintime = GUI:InputFloat("<PVP Target-Assist> Minimum Time Delay between target changes", h_lib.Settings.pvp_target_assist_mintime)
				h_lib.Settings.pvp_target_assist_delaytime = GUI:InputFloat([[<PVP Target-Assist> Random Delay Atop. math.random(min_delay, min_delay + random_delay)]], h_lib.Settings.pvp_target_assist_delaytime)
				GUI:PopItemWidth()
			
			elseif h_lib.Settings.UIUX.CurrentWindow == "Auto-Buy-Housings" then
				GUI:Dummy(0, 0)
				GUI:SameLine( 0, 4 )
				h_lib.UIUX.build_on_off_buttons("auto_buy_housing")
				GUI:SameLine( 0, 16 )
				
				--GUI:TextColored( L_textSettings[L_textStatus][1], L_textSettings[L_textStatus][2], L_textSettings[L_textStatus][3], L_textSettings[L_textStatus][4], "Auto-Quick Time Events" )
				GUI:Text( "<Auto-Buy-Housing>" )
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "If Near <Placard> will check if anyones owns it, if not, will try to snatch it up!\n\n\t\tMake sure have enough <gil> on personel to purchase." )
				end
				
				GUI:Dummy(0, y_spacing_2)
				GUI:Separator( )
				
				local BuyHousingTypeList = {	[1] = "Buy Personal",
												[2] = "Buy Free-Company",
												[3] = "Relo Personal",
												[4] = "Relo Free-Company"		}
												--[[
				local BuyHousingTypeList = {	["Buy Personal"] = "Buy Personal",
												["Buy Free-Company"] = "Buy Free-Company",
												["Relo Personal"] = "Relo Personal",
												["Relo Free-Company"] = "Relo Free-Company"		}]]
					
				
				GUI:PushItemWidth(160)
				
				h_lib.Settings.auto_buy_housing_type = GUI:Combo( "What are you spamming for ?", h_lib.Settings.auto_buy_housing_type, BuyHousingTypeList)
				GUI:Dummy(0, y_spacing_2)
				
				GUI:PopItemWidth()
				
				GUI:PushItemWidth(80)
				
				h_lib.Settings.auto_buy_housing_min_delay = GUI:InputFloat("Minimum Delay : Between Each Menu", h_lib.Settings.auto_buy_housing_min_delay)
				GUI:Dummy(0, y_spacing_2)
				h_lib.Settings.auto_buy_housing_pulse_atop = GUI:InputFloat("Pulse Atop Delay : Between Each Menu", h_lib.Settings.auto_buy_housing_pulse_atop)
				GUI:Dummy(0, y_spacing_2)
				h_lib.Settings.auto_buy_housing_delay_between_buys = GUI:InputFloat("Minimum Delay : After Purchase Attempt", h_lib.Settings.auto_buy_housing_delay_between_buys)
				GUI:Dummy(0, y_spacing_2)
				h_lib.Settings.auto_buy_housing_delay_between_buys_pulse_atop = GUI:InputFloat("Pulse Atop Delay : After Purchase Attempt", h_lib.Settings.auto_buy_housing_delay_between_buys_pulse_atop)
				
				GUI:PopItemWidth()
				
				GUI:Dummy(0, y_spacing)
				GUI:Dummy(0, 0)
				GUI:SameLine( 0, 24 )
				GUI:SmallButton( "Reload : buy_housing.lua")
				if GUI:IsItemHovered(GUI.HoveredFlags_Default) then
					GUI:SetTooltip( "For Devs Dev." )
				end
				if GUI:IsItemClicked() then
					d("Reloading buy_housing.lua")
					h_lib.functions.auto_buy_housing = FileLoad(h_lib.LibraryPath.."buy_housing.lua")
				end
				
				GUI:PushItemWidth(90)

			end
			
		end
		GUI:End()
	
	end
	
end




-- aFunctions

function h_lib.dev.reloadACR( _filename, _alias)


	local routinePath = GetStartupPath()..[[\LuaMods\ACR\CombatRoutines\]]
	if (_filename ~= "" and FileExists(routinePath.._filename)) then
		local profileData = loadfile(routinePath.._filename)
		if (ValidTable(profileData)) then
			ACR.AddPrivateProfile(profileData,_alias)
		end
		d("ACR File Found, initiating load.")
	else
		d("h_lib.dev.reloadACR : Error")
	end
	 
end



-- bFunctions


function h_lib.assist.buildSkillTableForCurrentJob(_job_id)
	job_id = _job_id or Player.job
	local L_text = ""
	local actionlist = ActionList:Get(1)
	if table.valid(actionlist) then
		for actionid, action in pairs(actionlist) do
			if action.usable and (action.job == job_id or action.job == 255) then
				L_text = L_text .. "\tlocal " .. string.lower(action.name:gsub("%s", "_")) .. "\t\t\t\t" .. "= ActionList:Get(1, " .. actionid .. ")\n"
			end
		end
	end
	GUI:SetClipboardText(L_text)
	d(L_text .. "h_lib.assist <Activation> Copied to clipboard")
end

function h_lib.DestroyAllCurrentCharacterItems(_characterID)
	local all_items = {}
	local character = h_lib.LocalData.character_data[_characterID]
	local i_character = nil

	if FileExists(character.itemsPath) then
		i_character = FileLoad(character.itemsPath)
		i_character.all_items = all_items
		FileSave(character.itemsPath, i_character)
	end
	d("Destroyed Current Character <+ All Items>")
end

function h_lib.GenerateAllCurrentCharacterItems(_characterID)
	local all_items = {}
	local character = h_lib.LocalData.character_data[_characterID]
	local i_character = nil
	if FileExists(character.itemsPath) then
		d("<Items Path> found for " .. character.id .. " loading File.")
		i_character = FileLoad(character.itemsPath)
	end
	
	local retainer_list = i_character.Retainers
	if retainer_list then
		d("<Retainer List> exists for " .. character.id .. " proceeding.")
		for index, retainer in pairs (retainer_list) do
			for _, _inventory in pairs(retainer.inventory) do
				for _slot, _item in pairs(_inventory) do

					local L_id = _item[h_lib.convertSavedData("hqid")]
					local L_name = _item[h_lib.convertSavedData("name")]
					local L_ishq = _item[h_lib.convertSavedData("ishq")]
					local L_count = _item[h_lib.convertSavedData("count")]
					
					if all_items[L_id] then
						all_items[L_id][3] = all_items[L_id][3] + _item[h_lib.convertSavedData("count")]
					else
						all_items[L_id] = {L_name, L_ishq, L_count}
					end

				end
			end
		end
	end
	
	if table.valid(all_items) then
		d("< + All Items> table formulated, total unique NQ + HQ = " .. table.size(all_items) )
		i_character.all_items = all_items
		FileSave(character.itemsPath, i_character)
	end
end

function h_lib.auto_GC_supply_missions()
	if GetControl("ContentsInfoDetail") and GetControl("ContentsInfoDetail"):IsOpen() then
		local L_control = GetControl("ContentsInfoDetail")
		local L_keys = {	cpr = { id = 206, qtn = 222}, bsm = { id = 207, qtn = 223}, arm = { id = 208, qtn = 224}, gsm = { id = 209, qtn = 225},
							ltw = { id = 210, qtn = 226}, wvr = { id = 211, qtn = 227}, alc = { id = 212, qtn = 228}, cul = { id = 213, qtn = 229},
							min = { id = 265, qtn = 271}, btn = { id = 266, qtn = 272}, fsh = { id = 267, qtn = 273}	}
		
		for key, value in pairs(L_keys) do
			if not h_lib.itemInBag(key.id) then
				local buy_task = ffxiv_misc_shopping.Create()
					

					buy_task.name = "MISC_SHOPPING"
					
					buy_task.itemid = key.id
					buy_task.buyamount = key.qtn
					buy_task.id = 0
					buy_task.mapid = 0
					buy_task.pos = {}
					
					ml_task_hub:CurrentTask():AddSubTask(buy_task)

			end
		end
	end
end

function h_lib.UIUX.setLogicMessage( _string_message )
	d("h_lib debug : " .. _string_message)
	h_lib.UIUX.statuses.main = _string_message
end

-- Indoor Retainer Bell 196630, Outdoor Bell 2000401, 2000441 mor dhona
function h_lib.auto_venture()
	if TimeSince(timestamp.auto_venture) >= math.random(h_lib.Settings.auto_venture_pulse, h_lib.Settings.auto_venture_pulse + h_lib.Settings.auto_venture_pulse_plus) then
		timestamp.auto_venture = Now()
		
		
		local L_RetainerList_Data = {}
		-- Raw String Venture Status Index Data
		local L_VentureStatus_Index = {11, 20, 29, 38, 47, 56, 65, 74, 83, 92}
		
	

	
		
		-- Player Dont Have Target Or Retainer List Not Open
		if not MGetTarget() then
			h_lib.spam_checker(760,150)
			local tbl = EntityList('maxdistance2d=2')
				if table.valid(tbl) then
					for key, entity in pairs(tbl) do
						if entity.name == "Summoning Bell" and entity.interactable then
							h_lib.UIUX.setLogicMessage( "1. Found <Summoning Bell>, selecting <Summoning Bell>." )
							Player:SetTarget(entity.id)
							return true
						end
					end
				else
					h_lib.UIUX.setLogicMessage( "Ending, no <Summoning Bell> within range." )
					h_lib.Settings.auto_venture = false
				end
			return
		
		-- In conversation, skipping.
		elseif GetControl("Talk") and GetControl("Talk"):IsOpen() then
			h_lib.UIUX.setLogicMessage( "Misc. Talking, within <Conversation>." )
			UseControlAction("Talk","Click")
			timestamp.auto_venture_timeout = Now()
			return

		
		
		-- Retainer List UI
		elseif GetControl("RetainerList") and GetControl("RetainerList"):IsOpen() then

			local max_retainer = h_lib.Settings.max_retainer
			
			-- Sets Control
			local L_control = GetControl("RetainerList")
			
			h_lib.retrieveRetainerListData()
			
			-- Iterate through retainers CODERED
			for key = 1, max_retainer do
			
				if h_lib.LocalData.character_data[Player.id].Retainers[key].venture_type ~= 0 then
				
					local bar = L_control:GetRawData()[	L_VentureStatus_Index[key]	]
					if bar then
						d(tostring(bar.value) .. "Index:  " .. key)
						-- if Venture Status is Complete, then interact with index retainer.
						if bar.value == "Complete" or bar.value == "None in progress" then
							h_lib.currents.retainer.index = key
							h_lib.UIUX.setLogicMessage( "Calling ".. h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].name .. ", found idle at index : " .. key .. "." )
							-- +1 cause Action 0 is sort retainer list.
							L_control:Action("SelectIndex", key - 1)
							timestamp.auto_venture_timeout = Now()
							return
						end
					end
				
				end
				
			end
				h_lib.Settings.auto_venture = false
			
			--[[
			if Double_Checker_AutoVenture > 0 then 
				Double_Checker_AutoVenture = 0
				h_lib.Settings.auto_venture = false
				GetControl("RetainerList"):Close()
				d("___All Ventures Seems to be in progress, farewell")
			else
				Double_Checker_AutoVenture = Double_Checker_AutoVenture + 1
			end
			]]


		-- Retainer UI
		elseif GetControl("SelectString") and GetControl("SelectString"):IsOpen() then 
		
			local L_control = GetControl("SelectString")
			local tbl = L_control:GetData()
			-- View Report To Continue
			for k, v in pairs(tbl) do
				if v == "View venture report. (Complete)" then
					d("___Found Complete Venture Report, interacting")
					h_lib.UIUX.setLogicMessage( "View Report, " .. h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].name .. " have returned.")
					L_control:DoAction(k)
					timestamp.auto_venture_timeout = Now()
					return
				end
			end
			for k, v in pairs(tbl) do
				if v == "Assign venture." then
					h_lib.UIUX.setLogicMessage( "Assigning Venture to <" .. h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].name .. ">." )
					L_control:DoAction(k)
					timestamp.auto_venture_timeout = Now()
					return
				end
			end
			if h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].venture_type == 1 then
				for k, v in pairs(tbl) do
					if v == "Mining." or v == "Woodcutting." or v == "Fishing." or v == "Hunting." then
						h_lib.UIUX.setLogicMessage( "Assigning <" .. v .. "> Venture to <" .. h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].name .. ">." )
						L_control:DoAction(k)
						timestamp.auto_venture_timeout = Now()
						return
					end
				end
			end
			if h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].venture_type == 3 then
				for k, v in pairs(tbl) do
					if v == "Quick Exploration." then
						h_lib.UIUX.setLogicMessage( "Assigning <Quick> Venture to <" .. h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].name .. ">." )
						L_control:DoAction(k)
						timestamp.auto_venture_timeout = Now()
						return
					end
				end
			end
			if h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].venture_type == 2 then
				for k, v in pairs(tbl) do
					if v == "Highland Exploration." or v == "Woodland Exploration." or v == "Waterside Exploration." or v == "Field Exploration."then
						h_lib.UIUX.setLogicMessage( "Assigning <" .. v .. "> Venture to <" .. h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].name .. ">." )
						L_control:DoAction(k)
						timestamp.auto_venture_timeout = Now()
						return
					end
				end
			end

			-- within Regular Venture level range select
			if GetControl("SelectString"):GetStrings()[2] == "Select a level range." then
				h_lib.UIUX.setLogicMessage( "Selecting <Level-Range> for <Regular> Venture." )
				L_control:DoAction( h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].venture_level_range )
				timestamp.auto_venture_timeout = Now()
				return
			end
				
			for k, v in pairs(tbl) do
				if v == "Quit." then
					h_lib.UIUX.setLogicMessage( "Farewell, Venture sent for <" .. h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].name .. ">" )
					L_control:DoAction(k)
					timestamp.auto_venture_timeout = Now()
					return
				end
			end

		-- Ventures Task Ask
		elseif GetControl("RetainerTaskAsk") and GetControl("RetainerTaskAsk"):IsOpen() then
			h_lib.UIUX.setLogicMessage("<RetainerTaskAsk> Opened, confirming Venture.")
			--GetControl("RetainerTaskAsk"):PushButton(25, 1) -- Assign
			GetControl("RetainerTaskAsk"):Action("Assign", 0) -- Assign
			

			
			timestamp.auto_venture_timeout = Now()
			return



		-- GetControl("RetainerTaskList"):GetData() cost, id, itemid, quantity
		-- Venture Task List UI
		elseif GetControl("RetainerTaskList") and GetControl("RetainerTaskList"):IsOpen() then
		
				h_lib.UIUX.setLogicMessage("<RetainerTaskList> Open, choosing Venture.")
				GetControl("RetainerTaskList"):Action("SelectItem", h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].venture_id - 1)
				timestamp.auto_venture_timeout = Now()
				return


		-- Venture Report UI
		elseif GetControl("RetainerTaskResult") and GetControl("RetainerTaskResult"):IsOpen() then
			-- if current retainer is set to <Reassign> then Reassign, otherwise, complete and then Assign new venture.
			if h_lib.LocalData.character_data[Player.id].Retainers[h_lib.currents.retainer.index].venture_type == 4 then
				h_lib.UIUX.setLogicMessage("<RetainerTaskResult> Open, reassigning Venture.")
				GetControl("RetainerTaskResult"):PushButton(25, 3) -- ReAssign
				timestamp.auto_venture_timeout = Now()
				return
			else
				h_lib.UIUX.setLogicMessage("<RetainerTaskResult> Open, completing Venture.")
				GetControl("RetainerTaskResult"):PushButton(25, 2) -- Complete
				timestamp.auto_venture_timeout = Now()
				return
			end
		
		-- Player Targeting Bell, however no windows is open
		elseif MGetTarget().name == "Summoning Bell" and MGetTarget().interactable then
			h_lib.UIUX.setLogicMessage("Rining <Summoning Bell>, as <Summoning Bell> is within range.")
			Player:Interact(MGetTarget().id)
			timestamp.auto_venture_timeout = Now()
			return
		end
		
		
		if timestamp.auto_venture_timeout == 0 then
			timestamp.auto_venture_timeout = Now()
		end
		
		h_lib.UIUX.setLogicMessage("No UI found, time until Timed-Out : " .. tostring(	10000 - TimeSince(timestamp.auto_venture_timeout)	) .. "."	)
		if TimeSince(timestamp.auto_venture_timeout) > 10000 then
			timestamp.auto_venture_timeout = 0
			h_lib.Settings.auto_venture = false
			h_lib.UIUX.setLogicMessage("Ending, Timed-Out.")
		end

	else

	end

end

function h_lib.auto_gardening()
	if TimeSince(timestamp.auto_venture) >= math.random(h_lib.Settings.auto_venture_pulse, h_lib.Settings.auto_venture_pulse + h_lib.Settings.auto_venture_pulse_plus) then
	timestamp.auto_venture = Now()


		if GetControl("Talk") and GetControl("Talk"):IsOpen() then
			d("___In Conversation___ talking..")
			UseControlAction("Talk","Click")
			timestamp.auto_venture_timeout = Now()
			return
		
		
		elseif GetControl("SelectString") and GetControl("SelectString"):IsOpen() then 
			local L_control = GetControl("SelectString")
			local tbl = L_control:GetData()
			for k, v in pairs(tbl) do
				if v == "Harvest Crop" then
					d("___Harvesting Crop")
					L_control:DoAction(k)
					timestamp.auto_venture_timeout = Now()
					return
				elseif v == "Plant Seeds" then
					d("___Planting Seeds")
					L_control:DoAction(k)
					timestamp.auto_venture_timeout = Now()
					return
				elseif v == "Tend Crop" then
					for k, v in pairs(tbl) do
						if v == "Quit" then
							d("Quitting")
							L_control:DoAction(k)
							timestamp.auto_venture_timeout = Now()
							return
						end
					end
				end
			end
			
			
		elseif GetControl("SelectYesno") and GetControl("SelectYesno"):IsOpen() then
			GetControl("SelectYesno"):Action("Yes", 0)
			h_lib.keys.steps.auto_gardening = 1
			timestamp.auto_venture_timeout = Now()
			return
	
	
		elseif GetControl("HousingGardening") and GetControl("HousingGardening"):IsOpen() then
			if h_lib.keys.steps.auto_gardening == 1 then
				--Fire, Ice, Wind, Earth, Lightning, Water
				local elementSeeds = {15865,15866,15867,15868,15869,15870}
				elementSeeds = {15869,15867,15865,15870,15866,15868}
				for key, value in pairs(elementSeeds) do
					if h_lib.itemInBag(value) then
						d("Selecting Seed : "..GetItem(value).name)
						GetItem(value):Gardening()
						h_lib.keys.steps.auto_gardening = 2
						timestamp.auto_venture_timeout = Now() - ( h_lib.Settings.auto_venture_pulse/3.5 )
						return
					end
				end
				
				-- Grade 3 Shroud
			elseif h_lib.keys.steps.auto_gardening == 2 then
				if h_lib.itemInBag(7763) then
					d("Selecting Soil : " ..GetItem(7763).name)
					GetItem(7763):Gardening()
					h_lib.keys.steps.auto_gardening = 3
					timestamp.auto_venture_timeout = Now()
					return
				end
				
				-- confirm
			elseif h_lib.keys.steps.auto_gardening == 3 then
				GetControl("HousingGardening"):Action("Confirm", 0)
				h_lib.keys.steps.auto_gardening = 1
				timestamp.auto_venture_timeout = Now()
				return
			end
		
		end
		
		d("error : Function Auto-Gardening")
	
	
	
	end
end


function h_lib.auto_mini_cactpot()
	if TimeSince(timestamp.auto_venture) >= math.random(h_lib.Settings.auto_venture_pulse, h_lib.Settings.auto_venture_pulse + h_lib.Settings.auto_venture_pulse_plus) then
	timestamp.auto_venture = Now()
		if GetControl("LotteryDaily") and GetControl("LotteryDaily"):IsOpen() then
		
			-- Getting current Ticket Information
			local ticket_grid = {}
			local known_grid = {}
			local known_number = 0
			for index = 1, 9 do
				ticket_grid[index] = GetControl("LotteryDaily"):GetRawData()[index + 6]
			end
			for key, value in pairs(ticket_grid) do
				if value ~= 0 then
					table.insert(known_grid, key)
					known_number = known_number + 1
				end
			end
			
			ticket_grid.non_cardinal = { ticket_grid[1], ticket_grid[3], ticket_grid[7], ticket_grid[9] }
			ticket_grid.cardinal = { ticket_grid[2], ticket_grid[4], ticket_grid[6], ticket_grid[8] }
			
			
			-- Helper Function
			function check_grid(_trigger, _tbl_entry)
				for key, value in pairs(_tbl_entry) do
					if value == _trigger then
						return true, key
					end
				end
				return false
			end
			
			local condition, placement = "Hello", " World"
			local temp_tbl = {}
			local bar = "foo"
			
			if known_number == 1 then
				-- if non-cardinal is, then uncovers adjacent non-cardinal
				temp_tbl = {1,2,3}
				for key, value in pairs(temp_tbl) do
					condition, placement = check_grid(value, ticket_grid.non_cardinal)
					if condition then
						if placement == 1 or placement == 9 then
							if random.math(0, 1) == 0 then
								GetControl("LotteryDaily"):PushButton(25, 3)
								return
							else
								GetControl("LotteryDaily"):PushButton(25, 7)
								return
							end
						elseif placement == 3 or placement == 7 then
							if random.math(0, 1) == 0 then
								GetControl("LotteryDaily"):PushButton(25, 1)
								return
							else
								GetControl("LotteryDaily"):PushButton(25, 9)
								return
							end
						end
					end
				end
				temp_tbl = {8,9}
				for key, value in pairs(temp_tbl) do
					condition, placement = check_grid(value, ticket_grid.non_cardinal)
					if condition then
						bar = random.math(1, 3)
						if placement == 1 or placement == 9 then
							if bar == 1 then
								GetControl("LotteryDaily"):PushButton(25, 3)
								return
							elseif bar == 2 then
								GetControl("LotteryDaily"):PushButton(25, 7)
								return
							elseif bar == 3 then
								GetControl("LotteryDaily"):PushButton(25, 5)
								return
							end
						elseif placement == 3 or placement == 7 then
							if bar == 1 then
								GetControl("LotteryDaily"):PushButton(25, 1)
								return
							elseif bar == 2 then
								GetControl("LotteryDaily"):PushButton(25, 9)
								return
							elseif bar == 3 then
								GetControl("LotteryDaily"):PushButton(25, 5)
								return
							end
						end
					end
				end
				temp_tbl = {4,5,6,7}
				for key, value in pairs(temp_tbl) do
					condition, placement = check_grid(value, ticket_grid.non_cardinal)
					if condition then
						GetControl("LotteryDaily"):PushButton(25, 3)
						return
					end
				end

			end
			
			
			
			
			
			
		end





	end
end


function h_lib.PVP_GetLowestTargets()
	local L_aliveEnemy = MEntityList('los,alive,attackable,targetable,maxdistance2d=24')
	if table.valid(L_aliveEnemy) then
		local L_lowestTank = nil
		local L_lowestTankPercent = 100
		local L_lowestHealer = nil
		local L_lowestHealerPercent = 100
		local L_lowestDPS = nil
		local L_lowestDPSPercent = 100
		local L_lowestUnknown = nil
		local L_lowestUnknownPercent = 100
		local L_mountedWithoutDebuff = nil
		for k, entity in pairs(L_aliveEnemy) do
			if IsTank(entity.job) and entity.hp.percent < L_lowestTankPercent  then
				L_lowestTank = entity
				L_lowestTankPercent = entity.hp.percent
			elseif IsHealer(entity.job) and entity.hp.percent < L_lowestHealerPercent  then
				L_lowestHealer = entity
				L_lowestHealerPercent = entity.hp.percent
			elseif ( IsPhysicalDPS(entity.job) or IsRangedDPS(entity.job) ) and  entity.hp.percent < L_lowestDPSPercent  then
				L_lowestDPS = entity
				L_lowestDPSPercent = entity.hp.percent
			elseif entity.hp.percent < L_lowestUnknownPercent then
				L_lowestUnknown = entity
				L_lowestUnknownPercent = entity.hp.percent
			end
		end
		return { healer = L_lowestHealer, dps = L_lowestDPS, tank = L_lowestTank, unknown = L_lowestUnknown }
	end
end


function h_lib.GetLowestHealthEveryRoleInParty()
	local L_aliveParty = MEntityList('myparty,los,alive,targetable,maxdistance2d=30')
	if table.valid(L_aliveParty) then
		local L_lowestTank = nil
		local L_lowestTankPercent = 100
		local L_lowestHealer = nil
		local L_lowestHealerPercent = 100
		local L_lowestDPS = nil
		local L_lowestDPSPercent = 100
		for k, entity in pairs(L_aliveParty) do
			if IsTank(entity.job) and entity.hp.percent < L_lowestTankPercent  then
				L_lowestTank = entity
				L_lowestTankPercent = entity.hp.percent
			elseif IsHealer(entity.job) and entity.hp.percent < L_lowestHealerPercent  then
				L_lowestHealer = entity
				L_lowestHealerPercent = entity.hp.percent
			elseif ( IsPhysicalDPS(entity.job) or IsRangedDPS(entity.job) ) and  entity.hp.percent < L_lowestDPSPercent  then
				L_lowestDPS = entity
				L_lowestDPSPercent = entity.hp.percent
			end
		end
		return { L_lowestTank, L_lowestHealer, L_lowestDPS }
	end
end

function h_lib.GetLowestNpcInRange(_input_range)
	local L_string = 'myparty,los,alive,targetable'
	if _input_range then L_string = L_string .. ',maxdistance2d=' .. _input_range end
	local L_aliveParty = MEntityList(L_string)
	if table.valid(L_aliveParty) then
		local L_lowestNPC = nil
		local L_lowestNPCPercent = 100
		for k, entity in pairs(L_aliveParty) do
			if entity.hp.percent < L_lowestTankPercent  then
				L_lowestNPC = entity
				L_lowestNPCPercent = entity.hp.percent
			end
		end
		return L_lowestNPC
	end
end


-- Inventory Management
function h_lib.FindEmptySlotToMoveItem(_inventories)
	if table.valid(_inventories) then
		for _, invid in pairs(_inventories) do
			local bag = Inventory:Get(invid)
			if table.valid(bag) then
				local ilist = bag:GetList()
				if table.valid(ilist) then
					for slot = 1, 25 do
						if ilist[slot] == nil then
							local debug_text = "Found Empty Item Slot: "..slot.." -@- " .. invid
							d(debug_text)
							return invid, (slot - 1)
						end
					end	
				else
					return invid, 0
				end
			end
		end
		return nil, nil
	elseif type(_inventories) == "number" then
		d("input Table instead")
		return nil, nil
	end
end

function h_lib.FindMatchingSlotToMoveItem_2(_input_itemID, _input_inventories)
	if table.valid(_input_inventories) then
		for _, invid in pairs(_input_inventories) do
			if table.valid(invid) then
				for slot, item in pairs(invid) do
					if item[h_lib.convertSavedData("hqid")] == _input_itemID and not item[h_lib.convertSavedData("isunique")] then
						if item[h_lib.convertSavedData("count")] ~= item[h_lib.convertSavedData("max")] then
							local debug_text = "Found Matching Item Slot For <"..item[17] .."> -@- "..slot.." -@- " .. invid
							d(debug_text)
							return invid, (slot - 1)
						else
							return "Found", "Full"
						end
					end
				end	
			end
		end
	elseif type(_input_inventories) == "number" then
		d("input Table instead")
	else
		d("FindMatchingSlot Error")
	end
	return nil, nil
end

function h_lib.FindMatchingSlotToMoveItem_3(_input_itemID, _input_inventories)
	if table.valid(_input_inventories) then
		for _, invid in pairs(_input_inventories) do
			local bag = Inventory:Get(invid)
			if table.valid(bag) then
				local ilist = bag:GetList()
				if table.valid(ilist) then
					for slot, item in pairs(ilist) do
						--d("trying " .. item.name .. " " .. item.hqid .. " and " .. _input_itemID)
						if item.hqid == _input_itemID and not item.isunique and item.max > 1 then
							local debug_text = "Found Matching Item Slot For <"..item.name.."> -@- "..slot.." -@- " .. invid
							d(debug_text)
							return invid, (slot - 1)
						end
					end	
				end
			end
		end
		--d("Nothing Found for ")
	elseif type(_input_inventories) == "number" then
		d("input Table instead")
	else
		d("FindMatchingSlot Error")
	end
	return nil, nil
end

function h_lib.FindMatchingSlotToMoveItem(_input_itemID, _input_inventories)
	if table.valid(_input_inventories) then
		for _, invid in pairs(_input_inventories) do
			local bag = Inventory:Get(invid)
			if table.valid(bag) then
				local ilist = bag:GetList()
				if table.valid(ilist) then
					for slot, item in pairs(ilist) do
						--d(item.hqid .. " is? " .. _input_itemID .. " is unique? " .. tostring(item.isunique) )
						--d(item.hqid == _input_itemID)
						if item.hqid == _input_itemID and not item.isunique then
							if item.count ~= item.max then
								local debug_text = "Found Matching Item Slot For <"..item.name.."> -@- "..slot.." -@- " .. invid
								d(debug_text)
								return invid, (slot - 1)
							else
								return "Found", "Full"
							end
						end
					end	
				end
			end
		end
	elseif type(_input_inventories) == "number" then
		d("input Table instead")
	else
		d("FindMatchingSlot Error")
	end
	return nil, nil
end

function h_lib.StoreStackItems(_store_location)
	local retainer = {10000,10001,10002,10003,10004,10005,10006}
	local store_inventories = _store_location or retainer
	if _store_location == "retainer" then
		store_inventories = retainer
	end
	
	local inventories = {0,1,2,3}
	local count = 0
	for _,invid in pairs(inventories) do
		local bag = Inventory:Get(invid)
		if (table.valid(bag)) then
			local ilist = bag:GetList()
			if (table.valid(ilist)) then
				for slot, item in pairs(ilist) do
				
						local move_inv, move_slot = "hello", " world"
						move_inv, move_slot = h_lib.FindMatchingSlotToMoveItem(item.hqid, store_inventories)
						
						if move_inv == "Found" and move_slot == "Full" then
							move_inv, move_slot = h_lib.FindEmptySlotToMoveItem(store_inventories)
						end
						
						
						if type(move_inv) == "number" and type(move_slot) == "number" then
							debug_text = "moving item : <" .. item.name .. "> to move_inv : " .. move_inv .. " -- " .. "move_slot : " .. move_slot
							d(debug_text)
							
							
							--GetItem(item.id,inventories):Move(move_inv, move_slot)
							item:Move(move_inv, move_slot)
							count = count + 1
							return true
						else
							count = count + 1
							--d("StoreStackItems : No Stack Found for item <" .. item.name .. ">")
							
						end
				end
				
				
			end
		end
	end
	d("StoreStackItems : Iterated through all " .. count .." inventory items")
	return false
end

function h_lib.auto_storage_stack_items()
	if h_lib.spam_checker(450, 100) then
		if ( GetControl("InventoryRetainer") and GetControl("InventoryRetainer"):IsOpen() ) or ( GetControl("InventoryRetainerLarge") and GetControl("InventoryRetainerLarge"):IsOpen() ) then
			if not h_lib.StoreStackItems() then
				h_lib.Settings.store_stack_items = false
			end
		else
			d("No Retainer Inventory Open")
			h_lib.Settings.store_stack_items = false
		end
	end
end

function h_lib.auto_inventory()
	if TimeSince(timestamp.auto_inventory) >= math.random(h_lib.Settings.auto_venture_pulse, h_lib.Settings.auto_venture_pulse + h_lib.Settings.auto_venture_pulse_plus) then
		timestamp.auto_inventory = Now()

		
		
		local L_RetainerList_Data = {}
		-- Raw String Venture Status Index Data
		local L_VentureStatus_Index = {11, 20, 29, 38, 47, 56, 65, 74, 83, 92}
		
	

	
		
		-- Player Dont Have Target Or Retainer List Not Open
		if not MGetTarget() then
			h_lib.spam_checker(760,150)
			local tbl = EntityList('maxdistance2d=2')
				if table.valid(tbl) then
					for key, entity in pairs(tbl) do
						if entity.name == "Summoning Bell" and entity.interactable then
							Player:SetTarget(entity.id)
							return
						end
					end
				else
					d("No <Summoning Bell> within range")
					h_lib.Settings.auto_inventory = false
				end
			return


		-- In conversation, skipping.
		elseif GetControl("Talk") and GetControl("Talk"):IsOpen() then
			d("___In Conversation___ talking..")
			UseControlAction("Talk","Click")
			timestamp.auto_inventory_timeout = Now()
			return


		-- Retainer List UI
		elseif MGetTarget().name == "Summoning Bell" and GetControl("RetainerList") and GetControl("RetainerList"):IsOpen() then
			if h_lib.switches.forget_that then
				h_lib.switches.forget_that = false
				h_lib.timers.forget_this = Now()
			elseif TimeSince(h_lib.timers.forget_this) >= 777 then
				h_lib.switches.forget_that = true
				
				local L_control = GetControl("RetainerList")
				local player_itembag = {0,1,2,3}
				
				--Find Retainer Stack Item
				for index, retainer in pairs( h_lib.currents.character_data.Retainers ) do
					for _, inventory in pairs( retainer.inventory ) do
						for slot, item in pairs( inventory ) do
							local LOCO = nil
							local LOCO_S = nil
							LOCO, LOCO_S = h_lib.FindMatchingSlotToMoveItem_3( item[h_lib.convertSavedData("hqid")], player_itembag )
							if LOCO and LOCO_S then
								d("Found matching item <" .. item[17] .. "> at " .. retainer.name .. " " .. _)
								local bar = L_control:GetRawData()[	L_VentureStatus_Index[index] ]
								if bar then
									h_lib.switches.flip_flop_flip = true
									L_control:Action("SelectIndex", index - 1)
									h_lib.currents.retainer.index = index
									timestamp.auto_inventory_timeout = Now()
									return
								end
							end
						end
						d("Matched all item for inventory : <" .. _ .. "> of " .. retainer.name .. " moving on to next")
					end
					d("Matched all items for <" .. retainer.name .. "> moving on to next")
				end
				d("Matched all items Retainers, <Auto-Inventory> Completion")
				h_lib.Settings.auto_inventory = false
				GetControl("RetainerList"):Close()
				
			end



		-- Retainer UI
		elseif GetControl("SelectString") and GetControl("SelectString"):IsOpen() then 
		
			local L_control = GetControl("SelectString")
			local tbl = L_control:GetData()
			-- View Report To Continue
			if h_lib.switches.flip_flop_flip then
				for k, v in pairs(tbl) do
					if v == "Entrust or withdraw items." then
						d("Entrust or withdraw items.")
						L_control:DoAction(k)
						timestamp.auto_inventory_timeout = Now()
						return
					end
				end
			else
				for k, v in pairs(tbl) do
					if v == "Quit." then
						d("Quitting.")
						L_control:DoAction(k)
						timestamp.auto_inventory_timeout = Now()
						return
					end
				end
			end


		-- Retainer Inventory
		elseif ( GetControl("InventoryRetainer") and GetControl("InventoryRetainer"):IsOpen() ) or ( GetControl("InventoryRetainerLarge") and GetControl("InventoryRetainerLarge"):IsOpen() ) then 

			if not h_lib.StoreStackItems() then
				if ( GetControl("InventoryRetainer") and GetControl("InventoryRetainer"):IsOpen() ) then
					GetControl("InventoryRetainer"):Close()
				elseif ( GetControl("InventoryRetainerLarge") and GetControl("InventoryRetainerLarge"):IsOpen() ) then
					GetControl("InventoryRetainerLarge"):Close()
				end
			end
			
			h_lib.switches.flip_flop_flip = false
			
			return

		-- Player Targeting Bell, however no windows is open
		elseif MGetTarget().name == "Summoning Bell" and MGetTarget().interactable then
		
			d("<Summoning Bell> within range, ringing bell")
			Player:Interact(MGetTarget().id)
			timestamp.auto_inventory_timeout = Now()
			return
			
		end





		if timestamp.auto_inventory_timeout == 0 then
			timestamp.auto_inventory_timeout = Now()
		end
		
		d("___No UI found, waiting until timeout__" .. tostring(	10000 - TimeSince(timestamp.auto_inventory_timeout)	)	)
		if TimeSince(timestamp.auto_inventory_timeout) > 10000 then
			timestamp.auto_inventory_timeout = 0
			h_lib.Settings.auto_inventory = false
			d("___Could not find any open UI or Retainer")
		end

	else

	end


end


function h_lib.StoreMaterias(_store_location)
	local retainer = {10000,10001,10002,10003,10004,10005,10006}
	local store_inventories = _store_location or retainer
	if _store_location == "retainer" then
		store_inventories = retainer
	end
	
	local inventories = {0,1,2,3}
	for _,invid in pairs(inventories) do
		local bag = Inventory:Get(invid)
		if (table.valid(bag)) then
			local ilist = bag:GetList()
			if (table.valid(ilist)) then
				for slot, item in pairs(ilist) do
					if string.find(item.name, "Materia") then
					
						local debug_text = "Materia Found : "..slot.."   ".. item.name .. "Moving Materia"
						d(debug_text)
						
						local move_inv, move_slot = "hello", " world"
						move_inv, move_slot = h_lib.FindMatchingSlotToMoveItem(item.hqid, store_inventories)
						
						if (move_inv == "Found" and move_slot == "Full") or (move_inv == nil and move_slot == nil) then
							move_inv, move_slot = h_lib.FindEmptySlotToMoveItem(store_inventories)
						end
						
						if type(move_inv) == "number" and type(move_slot) == "number" then
							debug_text = "move_inv : " .. move_inv .. " -- " .. "move_slot : " .. move_slot
							d(debug_text)
							
							
							--GetItem(item.id,inventories):Move(move_inv, move_slot)
							item:Move(move_inv, move_slot)
							return true
						else
							d("StoreMaterias : No available move_inv or move_slot found")
							return false
						end
					end
				end	
			end
		end
	end
	d("No Materias Found")
	return false
end

function h_lib.auto_storage_materias()
	if h_lib.spam_checker(450, 100) then
		if ( GetControl("InventoryRetainer") and GetControl("InventoryRetainer"):IsOpen() ) or ( GetControl("InventoryRetainerLarge") and GetControl("InventoryRetainerLarge"):IsOpen() ) then
			if not h_lib.StoreMaterias() then
				h_lib.Settings.store_materias = false
			end
		else
			d("No Retainer Inventory Open")
			h_lib.Settings.store_materias = false
		end
	end
end


function h_lib.spam_checker(_num_entry, _add_entry)
	if TimeSince(h_lib.timers.super) >= math.random(_num_entry, _num_entry + _add_entry) then
		h_lib.timers.super = Now()
		return true
	else
		return false
	end
end

--GetControl("RetainerList"):GetRawData()[3]

-- returns ms
function h_lib.extractRetainerVentureTimeRemain(_string) -- "Complete in 59m"
	local time_remain_s = 0


	local _, H_startIndex = _string:find"Complete in "
	if H_startIndex then H_startIndex = H_startIndex + 1 end
	
	local H_endIndex = _string:find"h "
	if H_startIndex and H_endIndex then
	
		H_endIndex = H_endIndex - 1
		local hours = tonumber( string.sub(_string, H_startIndex, H_endIndex) )

		
		local _, M_startIndex = _string:find"h "
		if M_startIndex then M_startIndex = M_startIndex + 1 end
		
		local M_endIndex = "bill"
		if _string:find"%d%dm" then
			M_endIndex = _string:find"%d%dm" + 1
		elseif _string:find"%dm" then
			M_endIndex = _string:find"%dm"
		end
		
		local minutes = tonumber( string.sub(_string, M_startIndex, M_endIndex) )
		

		if hours and minutes then
			time_remain_s = 3600*hours + 60*minutes
			local time_remain_ms = 1000*time_remain_s
			return time_remain_ms
		end
	else
		local M_endIndex = "bill"
		if _string:find"%d%dm" then
			M_endIndex = _string:find"%d%dm" + 1
		elseif _string:find"%dm" then
			M_endIndex = _string:find"%dm"
		end
		local minutes = tonumber( string.sub(_string, H_startIndex, M_endIndex) )
		if minutes then
			time_remain_s = 60*minutes
			local time_remain_ms = 1000* time_remain_s
			return time_remain_ms
		end
	end
	
end

function h_lib.retrieveRetainerListData()
		
		if GetControl("RetainerList") and GetControl("RetainerList"):IsOpen() then
				
			-- make better conversion by string sub
			local L_job_swap_table = {}
			L_job_swap_table[62016] = {"Miner"}
			L_job_swap_table[62017] = {"Botanist"}
		
			-- Sets Control
			local L_control = GetControl("RetainerList")
			-- Retainer List UI
			local L_Retainer_List = {}
			
			local _data = L_control:GetRawData()
			
			for index = 1, 10 do
				-- if Player has access to retainer.
				if _data[(index)*9 + 3] then
					if h_lib.LocalData.character_data[Player.id].Retainers[index] == nil then
						d("<Current Retainer> #".. index .. ", no info table found, creating <Info Table>")
						h_lib.LocalData.character_data[Player.id].Retainers[index] = {}
					end
					if h_lib.currents.character_data.Retainers[index] == nil then
						d("<Current Retainer> #".. index .. ", no main table found, creating <Main Table>")
						h_lib.currents.character_data.Retainers[index] = {}
					end
					if h_lib.currents.character_data.Retainers[index].inventory == nil then
						d("<Current Retainer> #".. index .. ", no inventory found, creating <Inventory Table>")
						h_lib.currents.character_data.Retainers[index].inventory = {}
					end
					local temp_name = _data[(index)*9 - 5].value
					local temp_venture_status = _data[(index)*9 + 2].value
					h_lib.currents.character_data.Retainers[index].name							= temp_name
					h_lib.LocalData.character_data[Player.id].Retainers[index].name				= temp_name
					h_lib.LocalData.character_data[Player.id].Retainers[index].job				= _data[(index)*9 - 4].value
					h_lib.LocalData.character_data[Player.id].Retainers[index].level			= _data[(index)*9 - 3].value
					h_lib.LocalData.character_data[Player.id].Retainers[index].inventory_used	= _data[(index)*9 - 2].value
					h_lib.LocalData.character_data[Player.id].Retainers[index].gil				= _data[(index)*9 - 1].value
					h_lib.LocalData.character_data[Player.id].Retainers[index].selling_status	= _data[(index)*9 + 1].value
					h_lib.LocalData.character_data[Player.id].Retainers[index].venture_status	= temp_venture_status
					
					if not h_lib.LocalData.character_data[Player.id].Retainers[index].venture_type then
						h_lib.LocalData.character_data[Player.id].Retainers[index].venture_type	= 4
					end
					if not h_lib.LocalData.character_data[Player.id].Retainers[index].venture_level_range then
						h_lib.LocalData.character_data[Player.id].Retainers[index].venture_level_range = 0
					end
					if not h_lib.LocalData.character_data[Player.id].Retainers[index].venture_id then
						h_lib.LocalData.character_data[Player.id].Retainers[index].venture_id = 1
					end

					h_lib.LocalData.character_data[Player.id].Retainers[index].time_checked		= Now() 

					if temp_venture_status == "Complete" then
						h_lib.LocalData.character_data[Player.id].Retainers[index].int_venture_status = "Complete"
					elseif temp_venture_status:find"Complete in" then
						h_lib.LocalData.character_data[Player.id].Retainers[index].venture_time_remain	= h_lib.extractRetainerVentureTimeRemain( temp_venture_status )
						h_lib.LocalData.character_data[Player.id].Retainers[index].int_venture_status = "Ongoing"
					elseif temp_venture_status == "None in progress" then
						h_lib.LocalData.character_data[Player.id].Retainers[index].int_venture_status = "None in progress"
					end

				end
			end
			
				
				

			h_lib.switches.LocalData = true

				
				--d("Collected" .. "Players" .. "<Retainer List Data>")

		end
		
end



function h_lib.extractRetainerName(_string)
	local _, startIndex = _string:find"Retainer: "
	if startIndex then startIndex = startIndex + 1 end
	
	local endIndex = _string:find"\rVentures: "
	if endIndex then endIndex = endIndex - 1 end
	
	if startIndex and endIndex then
		return string.sub(_string, startIndex, endIndex)
	end
	return ("retrieveRetainerInventoryData() Error Alert")
end

function h_lib.getCurrentRetainerIndex()
	for index, retainer in pairs( h_lib.LocalData.character_data[Player.id].Retainers ) do
		if retainer.name == h_lib.currents.retainer.name then
			return index
		end
	end
	return false
end


function h_lib.IsEntityHitboxFrontIfPlayerFacingTarget(entity, target)
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


--[[ Data Order
						canequip = false,
						class = 12,
						collectability = 0,
						condition = 100,
						count = 99,
						desynthvalue = 0,
						equipslot = 0,
						hqid = 5328,
						id = 5328,
						iscollectable = false,
						ishq = 0,
						isunique = false,
						isuntradeable = false,
						level = 39,
						materiaslotcount = 0,
						max = 999,
						name = "Undyed Woolen Cloth",
						price = 1,
						rarity = 1,
						repairclassjob = 0,
						repairitem = 0,
						requiredlevel = 1,
						searchcategory = 50,
						uicategory = 51,

							local _item = {	name = item.name, id = item.id, hqid = item.hqid, ishq = item.ishq, count = item.count, max = item.max, condition = item.condition, collectability = item.collectability,
											level = item.level, requiredlevel = item.requiredlevel, class = item.class, uicategory = item.uicategory, searchcategory = item.searchcategory,
											canequip = item.canequip, equipslot = item.equipslot, price = item.price, materiaslotcount = item.materiaslotcount, rarity = item.rarity,
											isunique = item.isunique, isuntradeable = item.isuntradeable, iscollectable = item.iscollectable, desynthvalue = item.desynthvalue,
											repairclassjob = item.repairclassjob, repairitem = item.repairitem}

]]

function h_lib.convertSavedData(_string)
	if _string == "canequip" then return 1 end
	if _string == "class" then return 2 end
	if _string == "collectability" then return 3 end
	if _string == "condition" then return 4 end
	if _string == "count" then return 5 end
	if _string == "desynthvalue" then return 6 end
	if _string == "equipslot" then return 7 end
	if _string == "hqid" then return 8 end
	if _string == "id" then return 9 end
	if _string == "iscollectable" then return 10 end
	if _string == "ishq" then return 11 end
	if _string == "isunique" then return 12 end
	if _string == "isuntradeable" then return 13 end
	if _string == "level" then return 14 end
	if _string == "materiaslotcount" then return 15 end
	if _string == "max" then return 16 end
	if _string == "name" then return 17 end
	if _string == "price" then return 18 end
	if _string == "rarity" then return 19 end
	if _string == "repairclassjob" then return 20 end
	if _string == "repairitem" then return 21 end
	if _string == "requiredlevel" then return 22 end
	if _string == "searchcategory" then return 23 end
	if _string == "uicategory" then return 24 end
end

function h_lib.retrieveRetainerInventoryData()
		
		
	function retrieveRetainerData()
		for index, retainer in pairs( h_lib.currents.character_data.Retainers ) do
			
			if retainer.name == h_lib.currents.retainer.name then
				local tbl_2 = {10000,10001,10002,10003,10004,10005,10006}
				for _,invid in pairs(tbl_2) do
					local bag = Inventory:Get(invid)
					--d("Bag Valid")
					if (table.valid(bag)) then
					--d("Working within inventory : " .. invid)
						
						h_lib.currents.character_data.Retainers[index].inventory[invid] = {}
						
						for slot, item in pairs( bag:GetList() ) do
							local _item_slot = item.slot
							local _item = {}
								_item[1] = item.canequip
								_item[2] = item.class
								_item[3] = item.collectability
								_item[4] = item.condition
								_item[5] = item.count
								_item[6] = item.desynthvalue
								_item[7] = item.equipslot
								_item[8] = item.hqid
								_item[9] = item.id
								_item[10] = item.iscollectable
								_item[11] = item.ishq
								_item[12] = item.isunique
								_item[13] = item.isuntradeable
								_item[14] = item.level
								_item[15] = item.materiaslotcount
								_item[16] = item.max
								_item[17] = item.name
								_item[18] = item.price
								_item[19] = item.rarity
								_item[20] = item.repairclassjob
								_item[21] = item.repairitem
								_item[22] = item.requiredlevel
								_item[23] = item.searchcategory
								_item[24] = item.uicategory
								
							h_lib.currents.character_data.Retainers[index].inventory[invid][slot] = _item
						end
					end
				end
				break
			end
			h_lib.switches.character_data = true
		end
	end
	
	
		-- Entrust Item
	if GetControl("RetainerCrystalGrid") and GetControl("RetainerCrystalGrid"):IsOpen() then 
		retrieveRetainerData()
		return

		-- Sell Retainer Item
	elseif GetControl("RetainerSellList") and GetControl("RetainerSellList"):IsOpen() then 
		retrieveRetainerData()
		return
		
		-- Retainer UI
	elseif GetControl("SelectString") and GetControl("SelectString"):IsOpen() then

		local tbl = GetControl("SelectString"):GetData()
		
		-- View Report To Continue
		for k, v in pairs(tbl) do
			if v == "Entrust or withdraw items." then
			
				-- Updates Current Temp Current Retainer Info
				if TimeSince(h_lib.timers[2]) > 500 then
					h_lib.timers[2] = Now()
					h_lib.currents.retainer.name = h_lib.extractRetainerName( GetControl("SelectString"):GetStrings()[2] )
					h_lib.currents.retainer.index = h_lib.getCurrentRetainerIndex()
					h_lib.switches.LocalData = true
				end
				
				-- Updates Retainer Inventory
				if TimeSince(h_lib.timers[1]) > 1000 then
					h_lib.timers[1] = Now()
					retrieveRetainerData()
					return
				end
			end
		end
		
	end
		


end



-- ACTUAL LIBRARY

-- SUPERSEDE MINION

function CanFlyInZone()
	if h_lib.Settings.keys.disableFlight then
		return false
	end

	if (GetPatchLevel() >= 5.35) then
	--if (QuestCompleted(524)) then
		--return true
	--end 
	end
	
	if (Player.flying) then
		if (Player.flying.canflyinzone) then
			return true
		end
	end
	return false
end

function h_lib.auto_buy_housing()
	h_lib.functions.auto_buy_housing.Execute()
end

-- FUNCTIONS

function h_lib.roundNum(num, numDecimalPlaces)
  return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end

function h_lib.convertTime(_nowTime)
	local L_time = _nowTime/1000
	local total_secs = h_lib.roundNum(L_time,2)
	local total_minutes = math.floor(total_secs/60)
	local total_hours = math.floor(total_minutes/60)
	local remaining_mins = math.round(total_minutes - (total_hours*60))
	local remaining_secs = math.round(total_secs - (total_minutes*60))
	return {total_hours, remaining_mins, remaining_secs}
end

function h_lib.itemInBag(_itemID)
	local inventories = {0,1,2,3,2004}
	for _,invid in pairs(inventories) do
		local bag = Inventory:Get(invid)
		if (table.valid(bag)) then
			local ilist = bag:GetList()
			if (table.valid(ilist)) then
				for slot, item in pairs(ilist) do
					if item.id == _itemID then
						d("Item Found : "..slot.."\t   "..item.name)
						return true
					end
				end	
			end
		end
	end
	d("Item Not Found")
	return false
end




-- ------------------------- Save ------------------------

function h_lib.Save(force)
	if (force or TimeSince(h_lib.SaveLastCheck) > 10000) then
		h_lib.SaveLastCheck = Now()
		
		if FileExists(h_lib.SettingsPath) then
			FileSave(h_lib.SettingsPath, h_lib.Settings)
		end
		
	end
end

function h_lib.QueueSaves()
	if Player.id and TimeSince(h_lib.timers.PlayerJob) > 25000 then
		h_lib.timers.PlayerJob = Now()
		
		h_lib.LocalData.character_data[Player.id].job = h_lib.getJobName( Player.job )
		if FileExists(h_lib.LocalDataPath) then
			FileSave(h_lib.LocalDataPath, h_lib.LocalData)
		end
	end
		
	if h_lib.switches.LocalData and TimeSince(h_lib.timers.LocalData) > 15000 then
		h_lib.switches.LocalData = false
		h_lib.timers.LocalData = Now()
		if FileExists(h_lib.LocalDataPath) then
			FileSave(h_lib.LocalDataPath, h_lib.LocalData)
		end
	end
	
	if h_lib.switches.character_data and TimeSince(h_lib.timers.character_data) > 15000 then
		h_lib.switches.character_data = false
		h_lib.timers.character_data = Now()
		local file_path = h_lib.currents.character_data_file_path
		if FileExists(file_path) then
			FileSave(file_path, h_lib.currents.character_data)
		end
	end
end

-- ------------------------- Update ------------------------

	
function h_lib.Update()

    h_lib.Save(false)

	local settings = h_lib.Settings


	-- <Auto-Inventory> and <Auto-Venture>
	if TimeSince(h_lib.timers.collect_retainer_list) > 1000 then
		h_lib.timers.collect_retainer_list = Now()
		h_lib.retrieveRetainerListData()
	end
	
	if TimeSince(h_lib.timers.collect_retainer_inventory) > gPulseTime then
		h_lib.timers.collect_retainer_inventory = Now()
		h_lib.retrieveRetainerInventoryData()
	end

	-- Queues Saves
	h_lib.QueueSaves()

	-- Auto-Venture
	if h_lib.Settings.auto_buy_housing then
		h_lib.auto_buy_housing()
	elseif h_lib.Settings.auto_venture then
		h_lib.auto_venture()
	elseif h_lib.Settings.auto_gardening then
		h_lib.auto_gardening()
	elseif h_lib.Settings.auto_mini_cactpot then
		h_lib.auto_mini_cactpot()
	elseif h_lib.Settings.auto_inventory then
		h_lib.auto_inventory()
	elseif h_lib.Settings.store_stack_items then
		h_lib.auto_storage_stack_items()
	elseif h_lib.Settings.store_materias then
		h_lib.auto_storage_materias()
	end


	local TTarget = MGetTarget() or nil

	h_lib.vars.aoeConeAttackableCount = 0
	local player_job_cone_range = ""
	if Player.job == FFXIV.JOBS.ARCHER or Player.job == FFXIV.JOBS.BARD then
		player_job_cone_range = ",maxdistance2d=" .. 12
	end
	local tbl = EntityList('alive,attackable'..player_job_cone_range)
	if table.valid(tbl) then
		local count = 0
		for k, v in pairs(tbl) do
			if h_lib.IsEntityHitboxFrontIfPlayerFacingTarget(v, TTarget) then
				count = count + 1
			end
			h_lib.vars.aoeConeAttackableCount = count
		end
	end


	-- Bot is Running

	-- PVP Target Selector
	if IsPVPMap(Player.localmapid) and h_lib.Settings.pvp_target_assist and FFXIV_Common_BotRunning and Player.alive then
		if TimeSince(timestamp.pvp_last_time_selected_target) >= math.random(settings.pvp_target_assist_mintime, settings.pvp_target_assist_mintime + settings.pvp_target_assist_delaytime) then
			local tbl_targets = h_lib.PVP_GetLowestTargets()
			if table.valid(tbl_targets) then
				local L_current_target = MGetTarget() or Player
				local healer = nil
				local dps = nil
				local tank = nil
				local unknown = nil
				if tbl_targets.healer then healer = tbl_targets.healer end
				if tbl_targets.dps then dps = tbl_targets.dps end
				if tbl_targets.tank then tank = tbl_targets.tank end
				if tbl_targets.unknown then unknown = tbl_targets.unknown end
				
				function doSelect(target, current)
					if target.id ~= current.id then
						Player:SetTarget(target.id)
						d("Target Selected:	" .. target.name)
						timestamp.pvp_last_time_selected_target = Now()
						return
					end
					return false
				end
				
				if unknown ~= nil then
					doSelect(unknown, L_current_target)
					return
				elseif healer ~= nil then
					if dps ~= nil then
						if healer.HP.percent <= dps.HP.percent then 
							doSelect(healer, L_current_target)
							return
						else
							doSelect(dps, L_current_target)
							return
						end
					else
						doSelect(healer, L_current_target)
						return
					end
				elseif dps ~= nil then
					doSelect(dps, L_current_target)
					return
				elseif tank ~= nil then
					doSelect(tank,L_current_target)
					return
				end
			end
		end
	-- Quest Related
	elseif FFXIV_Common_BotRunning then
		-- Quest Snipes
		if snipe_LoopIsRunning then
			h_lib.snipe_Loop()
		
		-- Zenos Fight 4464  buff 1271 is <Clashing>	PlayerHasBuffs(1271) and IsOnMap(1013) 
		elseif h_lib.Settings.combat_qte_assist and IsControlOpen("QTE") and TimeSince(quest_SpamButtonLastUpdatePulse) > math.random(120, 160) then
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
    local debugString = "Attempted to use skill : " .. skill.name
	
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
