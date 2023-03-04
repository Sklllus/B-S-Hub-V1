--[
--Script Made By xS_Killus
--]

--Instances And Functions

local Strings = {
    "BetterConsole.lua",
    "HiddenUIFix.lua",
    "CryptLibraryFix.lua",
    "WebSocketFix.lua"
}

for _, es in next, Strings do
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Sklllus/B-S-Hub-V1/main/Utilities/" .. es))()
end

if rawget(getgenv(), "syn") then
    for fn, f in next, syn do
        getgenv()[fn] = getgenv()["syn"][fn]
    end
else
    getgenv()["syn"] = {}
end

local Functions = {
    --[
    --Meta Table Functions
    --]

    ["getrawmetatable"] = get_raw_metatable or getrawmetatable or function (...) return "Break-Skill Hub - V1 | Error | getrawmetatable Was not found in exploit environment." end,
    ["setrawmetatable"] = set_raw_metatable or setrawmetatable or function (...) return "Break-Skill Hub - V1 | Error | setrawmetatable Was not found in exploit environment." end,
    ["setreadonly"] = setreadonly or make_readonly or makereadonly or function (...) return "Break-Skill Hub - V1 | Error | setreadonly Was not found in exploit environment." end,
    ["iswriteable"] = iswriteable or writeable or is_writeable or function (...) return "Break-Skill Hub - V1 | Error | iswriteable Was nout found in exploit environment." end,

    --[
    --Mouse Inputs Functions
    --]

    ["mouse1release"] = mouse1release or syn_mouse1release or m1release or m1rel or mouse1up or function (...) return "Break-Skill Hub - V1 | Error | mouse1release Was not found in exploit environment." end,
    ["mouse1press"] = mouse1press or mouse1press or m1press or mouse1click or function (...) return "Break-Skill Hub - V1 | Error | mouse1press Was not found in exploit environment." end,
    ["mouse2release"] = mouse2release or syn_mouse2release or m2release or m1rel or mouse2up or function (...) return "Break-Skill Hub - V1 | Error | mouse2release Was not found in exploit environment." end,
    ["mouse2press"] = mouse2press or mouse2press or m2press or mouse2click or function (...) return "Break-Skill Hub - V1 | Error | mouse2press Was not found in exploit environment." end,

    --[
    --IO Functions
    --]

    ["isfolder"] = isfolder or syn_isfolder or is_folder or function (...) return "Break-Skill Hub - V1 | Error | isfolder Was not found in exploit environment." end,
    ["isfile"] = isfile or syn_isfile or is_file or function (...) return "Break-Skill Hub - V1 | Error | isfile Was not found in exploit environment." end,
    ["delfolder"] = delfolder or syn_delfolder or del_folder or function (...) return "Break-Skill Hub - V1 | Error | delfolder Was not found in exploit environment." end,
    ["delfile"] = delfile or syn_delfile or del_file or function (...) return "Break-Skill Hub - V1 | Error | delfile Was not found in exploit environment." end,
    ["appendfile"] = appendfile or syn_io_append or append_file or function (...) return "Break-Skill Hub - V1 | Error | appendfile Was not found in exploit environment." end,
    ["makefolder"] = makefolder or make_folder or createfolder or create_folder or function (...) return "Break-Skill Hub - V1 | Error | maakefolder Was not found in exploit environment." end,

    --[
    --Environment Manipulation Functions
    --]

    ["hookfunction"] = hookfunction or hookfunc or detour_function or function (...) return "Break-Skill Hub - V1 | Error | hookfunction Was not found in exploit environment." end,
    ["hookmetamethod"] = hookmetamethod or hook_meta_method or function (...) return "Break-Skill Hub - V1 | Error | hookmetamethod Was not found in exploit environment." end,
    ["islclosure"] = islclosure or is_lclosure or isluaclosure or function (...) return "Break-Skill Hub - V1 | Error | islclosure Was not found in exploit environment." end,
    ["iscclosure"] = iscclosure or is_cclosure or function (...) return "Break-Skill Hub - V1 | Error | iscclosure Was not found in exploit environment." end,
    ["newcclosure"] = newcclosure or new_cclosure or function (...) return "Break-Skill Hub - V1 | Error | newcclosure Was not found in exploit environment." end,
    ["cloneref"] = cloneref or clonereference or function (...) return "Break-Skill Hub - V1 | Error | cloneref Was not found in exploit environment." end,
    ["getconnections"] = getconnections or get_connections or get_signal_cons or function (...) return "Break-Skill Hub - V1 | Error | getconnections Was not found in exploit environment." end,
    ["getnamecallmethod"] = getnamecallmethod or get_namecall_method or function (...) return "Break-Skill Hub - V1 | Error | getnamecallmethod Was not found in exploit environment." end,
    ["setnamecallmethod"] = setnamecallmethod or set_namecall_method or function (...) return "Break-Skill Hub - V1 | Error | setnamecallmethod Was not found in exploit environment." end,

    --[
    --Instance Functions
    --]

    ["getnilinstances"] = getnilinstances or get_nil_instances or function (...) return "Break-Skill Hub - V1 | Error | getnilinstances Was not found in exploit environment." end,
    ["getproperties"] = getproperties or get_properties or function (...) return "Break-Skill Hub - V1 | Error | getproperties Was not found in exploit environment." end,
    ["fireclickdetector"] = fireclickdetector or fire_click_detector or function (...) return "Break-Skill Hub - V1 | Error | fireclickdetector Was not found in exploit environment." end,
    ["gethiddenproperties"] = gethiddenproperties or get_hidden_properties or gethiddenprop or get_hidden_prop or gethiddenproperty or function (...) return "Break-Skill Hub - V1 | Error | gethiddenproperties Was not found in exploit environment." end,
    ["sethiddenproperties"] = sethiddenproperties or set_hidden_properties or sethiddenprop or set_hidden_prop or sethiddenproperty or function (...) return "Break-Skill Hub - V1 | Error | sethiddenproperties Was not found in exploit environkent." end,
    ["getscripts"] = getscripts or getrunningscripts or get_running_scripts or get_scripts or function (...) return "Break-Skill Hub - V1 | Error | getscripts Was not found in exploit environment." end,

    --[
    --Network Functions
    --]

    ["setsimulationradius"] = setsimulationradius or setsimradius or set_simulation_radius or function (...) return "Break-Skill Hub - V1 | Error | setsimulationradius Was not found in exploit environment." end,
    ["getsimulationradius"] = getsimulationradius or getsimradius or get_simulation_radius or function (...) return "Break-Skill Hub - V1 | Error | getsimulationradius Was not found in exploit environment." end,
    ["isnetworkowner"] = isnetworkowner or isnetowner or is_network_owner or function (...) return "Break-Skill Hub - V1 | Error | isnetworkowner Was not found in exploit environment." end,

    --[
    --Misc Functions
    --]

    ["http_request"] = http_request or httprequest or request or function (...) return "Break-Skill Hub - V1 | Error | http_request Was not found in exploit environment." end,
    ["isrbxactive"] = isrbxactive or iswindowactive or function (...) return "Break-Skill Hub - V1 | Error | isrbxactive Was not found in exploit environment." end,
    ["writeclipboard"] = writeclipboard or write_clipboard or setclipboard or set_clipboard or function (...) return "Break-Skill Hub - V1 | Error | writeclipboard Was not found in exploit environment." end,
    ["queue_on_teleport"] = queue_on_teleport or queueonteleport or function (...) return "Break-Skill Hub - V1 | Error | queue_on_teleport Was not found in exploit environment." end,
    ["is_exploit_function"] = is_synapse_function or iskrnlclosure or isourclosure or isexecutorclosure or is_sirhurt_closure or is_sirhurtclosure or issentinelclosure or is_protosmasher_closure or function (...) return "Break-Skill Hub - V1 | Error | is_exploit_function Was not found in exploit environment." end,
    ["firesignal"] = firesignal or fire_signal or function (...) return "Break-Skill Hub - V1 | Error | firesignal Was not found in exploit environment." end,
    ["getcustomasset"] = getcustomasset or getsynasset or function (...) return "Break-Skill Hub - V1 | Error | getcustomasset Was not found in exploit environment." end,
    ["isluau"] = function() return true end,

    --[
    --Script Methods
    --]

    ["getthreadcontext"] = getthreadcontext or get_thread_context or getthreadidentity or get_thread_identity or function (...) return "Break-Skill Hub - V1 | Error | getthreadcontext Was not found in exploit environment." end,
    ["setthreadcontext"] = setthreadcontext or set_thread_context or setthreadidentity or set_thread_identity or function (...) return "Break-Skill Hub - V1 | Error | setthreadcontext Was not found in exploit environment." end,
    ["getcallingscript"] = getcallingscript or get_calling_script  or function (...) return "Break-Skill Hub - V1 | Error | getcallingscript Was not found in exploit environment." end,
    ["getscriptclosure"] = getscriptclosure or function (...) return "Break-Skill Hub - V1 | Error | getscriptclosure Was not found in exploit environment." end,
    ["securecall"] = KRNL_SAFE_CALL or securecall or secure_call or function (...) return "Break-Skill Hub - V1 | Error | securecall Was not found in exploit environment." end
}

for fn, f in next, Functions do
    getgenv()[fn] = f
end

if not (type(Functions["setreadonly"]) == "string" and type(Functions["setrawmetatable"]) == "string") then
    Functions["setreadonly"](getgenv()["syn"], false)

    Functions["setrawmetatable"](getgenv()["syn"], {
        __index = function(originalEnv, element)
            return getgenv()[element]
        end
    })

    Functions["setreadonly"](getgenv()["syn"], true)
end

local SynIsGoingToMakeMeCry = {
    ["syn_checkcaller"] = checkcaller,
    ["syn_clipboard_set"] = clipboard_set or setclipboard,
    ["syn_context_get"] = context_get or getthreadcontext,
    ["syn_context_set"] = context_set or setthreadcontext,
    ["syn_decompile"] = decompile,
    ["syn_getcallingscript"] = getcallingscript,
    ["syn_getgc"] = getgc,
    ["syn_getgenv"] = getgenv,
    ["syn_getinstances"] = getinstances,
    ["syn_getloadedmodules"] = getloadedmodules,
    ["syn_getmenv"] = getmenv,
    ["syn_getreg"] = getreg,
    ["syn_getrenv"] = getrenv,
    ["syn_getsenv"] = getsenv,
    ["syn_io_append"] = appendfile,
    ["syn_io_delfile"] = delfile,
    ["syn_io_delfolder"] = delfolder,
    ["syn_io_isfile"] = isfile,
    ["syn_io_isfolder"] = isfolder,
    ["syn_io_listdir"] = listdir,
    ["syn_io_makefolder"] = makefolder,
    ["syn_io_read"] = read or readfile,
    ["syn_io_write"] = write or writefile,
    ["syn_isactive"] = isactive,
    ["syn_islclosure"] = islclosure,
    ["syn_keypress"] = keypress,
    ["syn_keyrelease"] = keyrelease,
    ["syn_mouse1click"] = mouse1click,
    ["syn_mouse1press"] = mouse1press,
    ["syn_mouse1release"] = mouse1release,
    ["syn_mouse2click"] = mouse2click,
    ["syn_mouse2press"] = mouse2press,
    ["syn_mouse2release"] = mouse2release,
    ["syn_mousemoveabs"] = mousemoveabs,
    ["syn_mousemoverel"] = mousemoverel,
    ["syn_mousescroll"] = mousescroll,
    ["syn_newcclosure"] = newcclosure,
    ["syn_setfflag"] = setfflag
}

for fn, f in next, SynIsGoingToMakeMeCry do
    getgenv()[fn] = f
end
