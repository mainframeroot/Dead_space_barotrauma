--if Game.IsMultiplayer and CLIENT then return end

DS = {} -- Dead Space 2.0_dev
DS.Name="Dead Space 2.0_dev"
DS.Version = "A1.0.0h1"
DS.VersionNum = 01080401
DS.Path = table.pack(...)[1]

-- config loading

if not File.Exists(DS.Path .. "/config.json") then

    -- create default config if there is no config file
    DS.Config = dofile(DS.Path .. "/Content/Lua/defaultconfig.lua")
    File.Write(DS.Path .. "/Content/config.json", json.serialize(DS.Config))

else

    -- load existing config
    DS.Config = json.parse(File.Read(DS.Path .. "/config.json"))
    
    -- add missing entries
    local defaultConfig = dofile(DS.Path .. "/Content/Lua/defaultconfig.lua")
    for key, value in pairs(defaultConfig) do
        if DS.Config[key] == nil then
            DS.Config[key] = value
        end
    end
end

dofile(DS.Path.."/Content/Lua/Scripts/helperfunctions.lua")

-- server-side code (also run in singleplayer)
if (Game.IsMultiplayer and SERVER) or not Game.IsMultiplayer then

    -- Version and expansion display
    Timer.Wait(function() Timer.Wait(function()
        local runstring = "\n/// Running Dead Space 2.0_dev V "..DS.Version.." ///\n"

        -- add dashes
        local linelength = string.len(runstring)+4
        local i = 0
        while i < linelength do runstring=runstring.."-" i=i+1 end
        local hasAddons = #NTC.RegisteredExpansions>0

        -- add expansions
        for val in NTC.RegisteredExpansions do
            runstring = runstring.."\n+ "..(val.Name or "Unnamed expansion").." V "..(val.Version or "???")
            if val.MinNTVersion ~= nil and NT.VersionNum < (val.MinNTVersionNum or 1) then
                runstring = runstring.."\n-- WARNING! Neurotrauma version "..val.MinNTVersion.." or higher required!"
            end
        end

        -- No expansions
        runstring=runstring.."\n"
        if not hasAddons then
            runstring = runstring.."- Not running any expansions\n"
        end

        print(runstring)
    end,1) end,1)

      dofile(NT.Path.."/Lua/Scripts/Server/fuckbots.lua")
end

-- client-side code
if CLIENT then
    dofile(DS.Path.."/Content/Lua/Scripts/Client/configgui.lua")
end