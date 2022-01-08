-- ------------------------- Core ------------------------

h_lib = {}

-- ------------------------- Dev ------------------------

local LuaPath       = GetLuaModsPath()
-- Check if a folder named HatterAdmin exists, if so, all paths that leads to your library or addons will have a "Dev" at the end.
-- eg. h_libDev\, HatterProfilesDev\
local DeveloperMode = FolderExists(LuaPath .. [[HatterAdmin\]]) or false
local DevPath       = '' -- Keep this empty

if DeveloperMode then
	DevPath = [[Dev]]
end

-- ------------------------- Info ------------------------

h_lib.Info = {
    Author      = "H",
    AddonName   = "HatterLib",
    ClassName   = "h_lib",
    Version     = 1,
    StartDate   = "01-04-2022",
    LastUpdate  = "01-04-2022",
    Description = "H makes the codes!",
    ChangeLog = {
        [1] = { Version = [[0.0.1]], Description = [[Starting development.]] }
    }
}

-- ------------------------- Paths ------------------------

local LuaPath           = GetLuaModsPath()
h_lib.MinionSettings     = LuaPath                   .. [[ffxivminion\]]
h_lib.ModulePath         = LuaPath                   .. h_lib.Info.ClassName      .. DevPath .. [[\]]
h_lib.ModuleSettingPath  = h_lib.MinionSettings       .. h_lib.Info.AddonName      .. DevPath .. [[\]]
h_lib.LibraryPath        = LuaPath                   .. [[HatterLib]]              .. DevPath .. [[\]]
h_lib.LibrarySettingPath = h_lib.MinionSettings       .. [[HatterLib_Settings]]              .. DevPath .. [[\]]
h_lib.SettingsPath       = h_lib.ModuleSettingPath    .. [[HatterLib_Main_Settings.lua]]

-- ------------------------- Settings ------------------------

h_lib.DefaultSettings = {
    Version = h_lib.Info.Version
}

if FileExists(h_lib.SettingsPath) then
    h_lib.Settings = FileLoad(h_lib.SettingsPath)
else
    FileSave(h_lib.SettingsPath, h_lib.DefaultSettings)
    h_lib.Settings = FileLoad(h_lib.SettingsPath)
end

-- ------------------------- States ------------------------

h_lib.Style          = {}
h_lib.Misc           = {}
h_lib.SaveLastCheck  = Now()


-- ------------------------- GUI ------------------------

h_lib.GUI = {
    Open    = false,
    Visible = true,
    OnClick = loadstring(h_lib.Info.ClassName .. [[.GUI.Open = not ]] .. h_lib.Info.ClassName .. [[.GUI.Open]]),
    IsOpen  = loadstring([[return ]] .. h_lib.Info.ClassName .. [[.GUI.Open]]),
    ToolTip = h_lib.Info.Description
}

-- ------------------------- Style ------------------------

h_lib.Style.MainWindow = {
    Size        = { Width = 500, Height = 400 },
    Components  = { MainTabs = GUI_CreateTabs([[Page 1,Page 2, Page 3]]) }
}

-- ------------------------- Log ------------------------

function h_lib.Log(log)
    local content = "==== [" .. h_lib.Info.AddonName .. "] " .. tostring(log)
    d(content)
end

-- ------------------------- Save ------------------------

function h_lib.Save(force)
    if FileExists(h_lib.SettingsPath) then
        if (force or h_lib.assist.timeSince(h_lib.SaveLastCheck) > 500) then
            h_lib.SaveLastCheck = Now()
            FileSave(h_lib.SettingsPath, h_lib.Settings)
        end
    end
end

-- ------------------------- Init ------------------------

function h_lib.Init()

-- ------------------------- Folder Structure ------------------------

    if not FolderExists(h_lib.SettingsPath) then
        FolderCreate(h_lib.SettingsPath)
    end

-- ------------------------- Init Status ------------------------

    h_lib.Log([[Addon started]])

-- ------------------------- Dropdown Member ------------------------

    local ModuleTable = h_lib.GUI
    ml_gui.ui_mgr:AddMember({
        id      = h_lib.Info.ClassName,
        name    = h_lib.Info.AddonName,
        onClick = function() ModuleTable.OnClick() end,
        tooltip = ModuleTable.ToolTip,
        texture = [[]]
    }, [[FFXIVMINION##MENU_HEADER]])
end

-- ------------------------- Update ------------------------

function h_lib.Update()
    h_lib.Save(false)
end

-- ------------------------- Draw ------------------------

function h_lib.MainWindow(event, tickcount)
    if h_lib.GUI.Open then

-- ------------------------- MainWindow ------------------------

        local flags = (GUI.WindowFlags_NoScrollbar + GUI.WindowFlags_NoResize)
        GUI:SetNextWindowSize(h_lib.Style.MainWindow.Size.Width, h_lib.Style.MainWindow.Size.Height, GUI.SetCond_Always)
        h_lib.GUI.Visible, h_lib.GUI.Open = GUI:Begin(h_lib.Info.AddonName, h_lib.GUI.Open, flags)

            local TabIndex, TabName = GUI_DrawTabs(h_lib.Style.MainWindow.Components.MainTabs)
            
-- ------------------------- Tab 1 ------------------------

                if TabIndex == 1 then
                    -- Do stuff
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

-- ACTUAL LIBRARY

-- FUNCTIONS

h_lib.assist        = {}

h_lib.assist.timeSince = function(input_os_time)
	return os.time() - input_os_time
end



-- About Actions Activations
h_lib.action = {}

h_lib.action.activate = function(_skill, _target, _debugString)
	local skill = _skill
	local target = _target
	if skill:IsReady(target.id) then
		skill:Cast(target.id)
		return true
		d(_debugString)
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

-- Quest Mode Sniping Nonsense

h_lib.snipeData = {}

--Quests Snipe Coordinates


h_lib.snipeData[4363] = {	{	-1.37,  -5.83 	0,	"<Big Green Bird>"},	4 }

h_lib.snipeData[4443] = {	{	21.20,	39.02,	0,	"<Tanks>"},
							{	-6.59,	26.66,	0,	"<Metallic Tube>"},
							{	-24.16,	45.50,	0,	"<Mushroom-like Thing>"},	4 }	-- 4 Total Targets



h_lib.snipeCore = function(_quest_id)
	
	local _switch_Boo = true
	local snipe_coordinates = {}
	local snipe_total_targets = nil
	
	for k, v in pairs( h_lib.snipeData[_quest_id] ) do
		if table.valid(v) then
			snipe_coordinates[k] = v
		elseif type(v) == "number" then
			snipe_total_targets = v
		end
	end

	while IsControlOpen("Snipe") do
		if _switch_Boo then
			_switch_Boo = false
			
			local snipe_targets_left = Player:GetSnipeTargetsRemain() or 1
			local current_progress = 1 + snipe_total_targets - snipe_targets_left
			local current_aim_x =	 snipe_coordinates[current_progress][1]
			local current_aim_y =	 snipe_coordinates[current_progress][2]
			local current_aim_zoom = snipe_coordinates[current_progress][3]
			local current_T_name =	 snipe_coordinates[current_progress][4]


			if not Player:SnipeHasTarget() then
				local randomXoffset = math.random(-1, 1)
				local randomYoffset = math.random(-1, 1)
				ml_global_information.Queue( math.random(1250,1500) ,
				function()
					Player:SetSnipeCam(current_aim_x + randomXoffset, current_aim_y + randomYoffset, current_aim_zoom)
					d("h_lib.snipecore\t\t\tAimed At:\t" .. current_T_name)
						ml_global_information.Queue( math.random(350,700) ,
						function()
							if Player:SnipeHasTarget() then
								Player:SnipeShoot()
								d("h_lib.snipecore\t\t\tShot At:\t" .. current_T_name)
							end
							ml_global_information.Queue( math.random(1250,1500) ,
							function()
								_switch_Boo = true
							end )
						end )
				end )
			end		
		end
	end

end


-- Main SKILL TABLE to be used.
h_lib.ac = {}

-- Basic SKILL TABLE used to form tbl above.
h_lib.role = {}
h_lib.role.skillIDs = 	{	7541, 7542, 7548, 7546}



h_lib.sage = {}
h_lib.sage.buffIDs = {}
h_lib.sage.skillIDs = 	{	24283, 24284, 24285, 24286, 24287, 24288, 24289, 24290,
							24294, 24295, 24296, 24297, 24298, 24299, 24300, 24301,
							24302, 24303, 24304, 24305, 24306, 24307, 27822, 27823,
							27824, 27825, 27826, 27827, 27828, 27829, 27830, 27831,
							27832, 27833, 27834, 27835	}




h_lib.reaper = {}
h_lib.reaper.buffIDs = {}
h_lib.reaper.skillIDs = {	24404, 24405, 24394, 24387, 24402, 24401, 24403, 24385,
							24384, 24398, 24400, 24397, 24388, 24379, 24376, 24377,
							24383, 24382, 24399, 24396, 24395, 24375, 24374, 24373,
							24378, 24386, 24393, 24392, 24390, 24391, 24389, 24381,
							24380	}





-- ------------------------- RegisterEventHandler ------------------------

RegisterEventHandler([[Module.Initalize]], h_lib.Init, [[h_lib.Init]])
RegisterEventHandler([[Gameloop.Update]], h_lib.Update, [[h_lib.Update]])
RegisterEventHandler([[Gameloop.Draw]], h_lib.MainWindow, [[h_lib.MainWindow]])
