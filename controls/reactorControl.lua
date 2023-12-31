--  BiggerReactor Control
--  by jaranvil aka jared314
--
--  feel free to use and/or modify this code
--
--  Modified by Wolf1596Games
-----------------------------------------------

local version = 1.1
--is auto power enabled 
local auto_string = false 
--auto on value
local on = 0 
--auto off value
local off = 99 
--is auto control rods enabled 
local auto_rods = false 
--control rod auto value
local auto_fe = 0 

--peripherals
local reactor
local mon
local battery

--monitor size
local monX
local monY

---------------GitHub download info----------
--To get files from GitHub, use the "wget <file url> <local file name>" command. 
baseUrl = "https://raw.githubusercontent.com/preveyj/ExtremeReactorsControls/master/controls/"
installerFile = "installer.lua"

reactorControlFile = "reactorControl.lua"
turbineControlFile = "turbineControl.lua"

reactorStartupFile = "reactorStartup.lua"
turbineStartupFile = "turbineStartup.lua"

reactorUpdateCheck = "reactorUpdateCheck.txt"
turbineUpdateCheck = "turbineUpdateCheck.txt"
---------------------------------------------

term.clear()
-------------------FORMATTING-------------------------------
function clear()
    mon.setBackgroundColor(colors.black)
    mon.clear()
    mon.setCursorPos(1,1)
end

--display text on computer's terminal screen
function draw_text_term(x, y, text, text_color, bg_color)
    term.setTextColor(text_color)
    term.setBackgroundColor(bg_color)
    term.setCursorPos(x,y)
    write(text)
end

--display text text on monitor, "mon" peripheral
function draw_text(x, y, text, text_color, bg_color)
    mon.setBackgroundColor(bg_color)
    mon.setTextColor(text_color)
    mon.setCursorPos(x,y)
    mon.write(text)
end

--draw line on computer terminal
function draw_line(x, y, length, color)
    mon.setBackgroundColor(color)
    mon.setCursorPos(x,y)
    mon.write(string.rep(" ", length))
end

--draw line on computer terminal
function draw_line_term(x, y, length, color)
    term.setBackgroundColor(color)
    term.setCursorPos(x,y)
    term.write(string.rep(" ", length))
end

--create progress bar
--draws two overlapping lines
--background line of bg_color 
--main line of bar_color as a percentage of minVal/maxVal
function progress_bar(x, y, length, minVal, maxVal, bar_color, bg_color)
    draw_line(x, y, length, bg_color) --backgoround bar
    local barSize = math.floor((minVal/maxVal) * length) 
    draw_line(x, y, barSize, bar_color) --progress so far
end

--same as above but on the computer terminal
function progress_bar_term(x, y, length, minVal, maxVal, bar_color, bg_color)
    draw_line_term(x, y, length, bg_color) --backgoround bar
    local barSize = math.floor((minVal/maxVal) * length) 
    draw_line_term(x, y, barSize, bar_color)  --progress so far
end

--create button on monitor
function button(x, y, length, text, txt_color, bg_color)
    draw_line(x, y, length, bg_color)
    draw_text((x+2), y, text, txt_color, bg_color)
end

--header and footer bars on monitor
function menu_bar()
    draw_line(1, 1, monX, colors.blue)
    draw_text(2, 1, "Power    Tools    Settings", colors.white, colors.blue)
    draw_line(1, 19, monX, colors.blue)
    draw_text(2, 19, "     Reactor Control", colors.white, colors.blue)
end

--dropdown menu for power options
function power_menu()
    draw_line(1, 2, 9, colors.gray)
    draw_line(1, 3, 9, colors.gray)
    draw_line(1, 4, 9, colors.gray)
    if active then 
        draw_text(2, 2, "ON", colors.lightGray, colors.gray)
        draw_text(2, 3, "OFF", colors.white, colors.gray)
    else
        draw_text(2, 2, "ON", colors.white, colors.gray)
        draw_text(2, 3, "OFF", colors.lightGray, colors.gray)
    end
    draw_text(2, 4, "Auto", colors.white, colors.gray)
end

--dropbox menu for tools
function tools_menu()
    draw_line(10, 2, 14, colors.gray)
    draw_line(10, 3, 14, colors.gray)
    draw_line(10, 4, 14, colors.gray)
    draw_line(10, 5, 14, colors.gray)
    draw_text(11, 2, "Control Rods", colors.white, colors.gray)
    draw_text(11, 3, "Efficiency", colors.white, colors.gray) 
    draw_text(11, 4, "Fuel", colors.white, colors.gray)
    draw_text(11, 5, "Waste", colors.white, colors.gray)
end

--dropdown menu for settings
function settings_menu()
    draw_line(12, 2, 18, colors.gray)
    draw_line(12, 3, 18, colors.gray)
    draw_text(13, 2, "Check for Updates", colors.white, colors.gray)
    draw_text(13, 3, "Reset peripherals", colors.white, colors.gray)
end

--basic popup screen with title bar and exit button 
function popup_screen(y, title, height)
    clear()
    menu_bar()

    draw_line(4, y, 22, colors.blue)
    draw_line(25, y, 1, colors.red)

    for counter = y+1, height+y do
        draw_line(4, counter, 22, colors.white)
    end

    draw_text(25, y, "X", colors.white, colors.red)
    draw_text(5, y, title, colors.white, colors.blue)
end

--write settings to config file
function save_config()
    sw = fs.open("config.txt", "w")   
    sw.writeLine(version)
    sw.writeLine(auto_string)
    sw.writeLine(on)
    sw.writeLine(off)
    sw.writeLine(auto_rods)
    sw.writeLine(auto_fe)
    sw.close()
end

--read settings from file
function load_config()
    sr = fs.open("config.txt", "r")
    version = tonumber(sr.readLine())
    auto_string = sr.readLine()
    on = tonumber(sr.readLine())
    off = tonumber(sr.readLine())
    auto_rods = sr.readLine()
    auto_fe = tonumber(sr.readLine())
    sr.close()
end

------------------------END FORMATTING--------------------------

--
function homepage()
    while true do
        --clear()
        menu_bar()
        terminal_screen()

        energy_stored = battery.getCurrentEnergy()

        --reactor.getEnergyStored()
        --battery.getCurrentEnergy()

        --------POWER STAT--------------
        draw_text(2, 3, "Power:", colors.yellow, colors.black)
        active = reactor.getActive()
        if active then
            draw_text(10, 3, "ONLINE", colors.lime, colors.black)
        else
            draw_text(10, 3, "OFFLINE", colors.red, colors.black)
        end

        -----------FUEL---------------------
        draw_text(2, 5, "Fuel Level:", colors.yellow, colors.black)
        local maxVal = reactor.getFuelStats().fuelCapacity
        local minVal = reactor.getFuelStats().fuelAmount 
        local percent = math.floor((minVal/maxVal)*100)
        draw_text(15, 5, percent.."%", colors.white, colors.black)

        if percent < 25 then
            progress_bar(2, 6, monX-2, minVal, maxVal, colors.red, colors.gray)
        elseif percent < 50 then
            progress_bar(2, 6, monX-2, minVal, maxVal, colors.orange, colors.gray)
        elseif percent < 75 then 
            progress_bar(2, 6, monX-2, minVal, maxVal, colors.yellow, colors.gray)
        elseif percent <= 100 then
            progress_bar(2, 6, monX-2, minVal, maxVal, colors.lime, colors.gray)

        end

        -----------ROD HEAT---------------
        draw_text(2, 8, "Fuel Temp:", colors.yellow, colors.black)
        local maxVal = 2000
        local minVal = math.floor(reactor.getFuelStats().fuelTemperature)

        if minVal < 500 then
            progress_bar(2, 9, monX-2, minVal, maxVal, colors.lime, colors.gray)
        elseif minVal < 1000 then
            progress_bar(2, 9, monX-2, minVal, maxVal, colors.yellow, colors.gray)
        elseif minVal < 1500 then  
            progress_bar(2, 9, monX-2, minVal, maxVal, colors.orange, colors.gray)
        elseif minVal < 2000 then
            progress_bar(2, 9, monX-2, minVal, maxVal, colors.red, colors.gray)
        elseif minVal >= 2000 then
            progress_bar(2, 9, monX-2, 2000, maxVal, colors.red, colors.gray)

        end

        draw_text(15, 8, math.floor(minVal).."/"..maxVal, colors.white, colors.black)

        -----------CASING HEAT---------------
        draw_text(2, 11, "Casing Temp:", colors.yellow, colors.black)
        local maxVal = 2000
        local minVal = math.floor(reactor.getCasingTemperature())
        if minVal < 500 then
            progress_bar(2, 12, monX-2, minVal, maxVal, colors.lime, colors.gray)
        elseif minVal < 1000 then
            progress_bar(2, 12, monX-2, minVal, maxVal, colors.yellow, colors.gray)
        elseif minVal < 1500 then  
            progress_bar(2, 12, monX-2, minVal, maxVal, colors.orange, colors.gray)
        elseif minVal < 2000 then
            progress_bar(2, 12, monX-2, minVal, maxVal, colors.red, colors.gray)
        elseif minVal >= 2000 then
            progress_bar(2, 12, monX-2, 2000, maxVal, colors.red, colors.gray)
        end
        draw_text(15, 11, math.floor(minVal).."/"..maxVal, colors.white, colors.black)

        -------------OUTPUT-------------------

        draw_text(2, 14, "FE/tick:", colors.yellow, colors.black)
        fet = math.floor(reactor.getEnergyProducedLastTick())        
        draw_text(13, 14, fet.." FE/T", colors.white, colors.black)

        ------------STORAGE------------

        draw_text(2, 15, "FE Stored:", colors.yellow, colors.black)
        energy_stored_percent = math.floor((energy_stored/battery.getMaxEnergy())*100)
        
        draw_text(13, 15, energy_stored_percent.."% ("..tostring(energy_stored).." FE)", colors.white, colors.black)

        -------------AUTO CONTROL RODS-----------------------
        auto_rods_bool = auto_rods == "true"
        insertion_percent = reactor.getControlRodLevel(0)


        if auto_rods_bool then
            if active then
                if fet > auto_fe+50 then
                    reactor.setAllControlRodLevels(insertion_percent+1)
                elseif fet < auto_fe-50 then
                    reactor.setAllControlRodLevels(insertion_percent-1)

                end
            end

            draw_text(2, 16, "Control Rods:", colors.yellow, colors.black)
            draw_text(16, 16, insertion_percent.."%", colors.white, colors.black)
            draw_text(21, 16, "(Auto)", colors.red, colors.black)

        else
            draw_text(2, 16, "Control Rods:", colors.yellow, colors.black)
            draw_text(16, 16, insertion_percent.."%", colors.white, colors.black)
        end

        -------------AUTO SHUTOFF--------------------------

        auto = auto_string == "true"
        if auto then
            if active then
                draw_text(2, 17, "Auto off:", colors.yellow, colors.black)
                draw_text(13, 17, off.."% FE Stored", colors.white, colors.black)
                if energy_stored_percent >= off then
                    reactor.setActive(false)
                    call_homepage()
                end
            else
                draw_text(2, 17, "Auto on:", colors.yellow, colors.black)
                draw_text(13, 17, on.."% FE Stored", colors.white, colors.black)
                if energy_stored_percent <= on then
                    reactor.setActive(true)
                    call_homepage()
                end
            end
        else
            draw_text(2, 17, "Auto power:", colors.yellow, colors.black)
            draw_text(14, 17, "disabled", colors.red, colors.black)
        end

        sleep(0.5)
    end
end


--------------MENU SCREENS--------------

--auto power menu
function auto_off()

    auto = auto_string == "true"
    if auto then --auto power enabled

        popup_screen(3, "Auto Power", 11)
        draw_text(5, 5, "Enabled", colors.lime, colors.white)
        draw_text(15, 5, " disable ", colors.white, colors.black)

        draw_text(5, 7, "ON when storage =", colors.gray, colors.white)
        draw_text(5, 8, " - ", colors.white, colors.black)
        draw_text(13, 8, on.."% FE", colors.black, colors.white)
        draw_text(22, 8, " + ", colors.white, colors.black)

        draw_text(5, 10, "OFF when storage =", colors.gray, colors.white)
        draw_text(5, 11, " - ", colors.white, colors.black)
        draw_text(13, 11, off.."% FE", colors.black, colors.white)
        draw_text(22, 11, " + ", colors.white, colors.black)

        draw_text(11, 13, " Save ", colors.white, colors.black)

        local event, side, xPos, yPos = os.pullEvent("monitor_touch")

        --disable auto
        if yPos == 5 then
            if xPos >= 15 and xPos <= 21 then
                auto_string = "false"
                save_config()
                auto_off()
            else
                auto_off()
            end
        end

        --increase/decrease auto on %
        if yPos == 8 then
            if xPos >= 5 and xPos <= 8 then
                previous_on = on
                on = on-1
            end
            if xPos >= 22 and xPos <= 25 then
                previous_on = on
                on = on+1
            end
        end

        --increase/decrease auto off %
        if yPos == 11 then
            if xPos >= 5 and xPos <= 8 then
                previous_off = off
                off = off-1
            end
            if xPos >= 22 and xPos <= 25 then
                previous_off = off
                off = off+1
            end
        end

        if on < 0 then on = 0 end
        if off >99 then off = 99 end

        if on == off or on > off then
            on = previous_on
            off = previous_off
            popup_screen(5, "Error", 6)
            draw_text(5, 7, "Auto On value must be", colors.black, colors.white)
            draw_text(5, 8, "lower then auto off", colors.black, colors.white)
            draw_text(11, 10, "Okay", colors.white, colors.black)
            local event, side, xPos, yPos = os.pullEvent("monitor_touch")

            auto_off()
        end

        --Okay button
        if yPos == 13 and xPos >= 11 and xPos <= 17 then 
            save_config()
            call_homepage()
        end

        --Exit button
        if yPos == 3 and xPos == 25 then 
            call_homepage()
        end

        auto_off()
    else
        popup_screen(3, "Auto Power", 5)
        draw_text(5, 5, "Disabled", colors.red, colors.white)
        draw_text(15, 5, " enable ", colors.white, colors.gray)
        draw_text(11, 7, "Okay", colors.white, colors.black)

        local event, side, xPos, yPos = os.pullEvent("monitor_touch")

        --Okay button
        if yPos == 7 and xPos >= 11 and xPos <= 17 then 
            call_homepage()
        end

        if yPos == 5 then
            if xPos >= 15 and xPos <= 21 then
                auto_string = "true"
                save_config()
                auto_off()
            else
                auto_off()
            end
        else
            auto_off()
        end
    end
end

--efficiency menu
function efficiency()
    popup_screen(3, "Efficiency", 12)
    fuel_usage = reactor.getFuelStats().fuelConsumedLastTick

    fet = math.floor(reactor.getEnergyStats().energyProducedLastTick)

    femb = fet / fuel_usage

    draw_text(5, 5, "Fuel Consumption: ", colors.lime, colors.white)
    draw_text(5, 6, fuel_usage.." mB/t", colors.black, colors.white)
    draw_text(5, 8, "Energy per mB: ", colors.lime, colors.white)
    draw_text(5, 9, femb.." FE/mB", colors.black, colors.white)

    draw_text(5, 11, "RF/tick:", colors.lime, colors.white)
    draw_text(5, 12, fet.." FE/T", colors.black, colors.white)

    draw_text(11, 14, " Okay ", colors.white, colors.black)

    local event, side, xPos, yPos = os.pullEvent("monitor_touch")

    --Okay button
    if yPos == 14 and xPos >= 11 and xPos <= 17 then 
        call_homepage()
    end

    --Exit button
    if yPos == 3 and xPos == 25 then 
        call_homepage()
    end

    efficiency()
end


function fuel()
    popup_screen(3, "Fuel", 9)

    fuel_max = reactor.getFuelStats().fuelCapacity
    fuel_level = reactor.getFuelStats().fuelAmount
    fuel_reactivity = math.floor(reactor.getFuelStats().fuelReactivity)

    draw_text(5, 5, "Fuel Level: ", colors.lime, colors.white)
    draw_text(5, 6, fuel_level.."/"..fuel_max, colors.black, colors.white)

    draw_text(5, 8, "Reactivity: ", colors.lime, colors.white)
    draw_text(5, 9, fuel_reactivity.."%", colors.black, colors.white)

    draw_text(11, 11, " Okay ", colors.white, colors.black)

    local event, side, xPos, yPos = os.pullEvent("monitor_touch")


    --Okay button
    if yPos == 11 and xPos >= 11 and xPos <= 17 then 
        call_homepage()
    end

    --Exit button
    if yPos == 3 and xPos == 25 then 
        call_homepage()
    end

    fuel()
end

function waste()
    popup_screen(3, "Waste", 8)

    waste_amount = reactor.getFuelStats().wasteAmount
    draw_text(5, 5, "Waste Amount: ", colors.lime, colors.white)
    draw_text(5, 6, waste_amount.." mB", colors.black, colors.white)
    draw_text(8, 8, " Eject Waste ", colors.white, colors.red)
    draw_text(11, 10, " Close ", colors.white, colors.black)

    local event, side, xPos, yPos = os.pullEvent("monitor_touch")

    --eject button
    if yPos == 8 and xPos >= 8 and xPos <= 21 then 
        reactor.doEjectWaste()
        popup_screen(5, "Waste Eject", 5)
        draw_text(5, 7, "Waste Ejeceted.", colors.black, colors.white)
        draw_text(11, 9, " Close ", colors.white, colors.black)
        local event, side, xPos, yPos = os.pullEvent("monitor_touch")
        --Okay button
        if yPos == 7 and xPos >= 11 and xPos <= 17 then 
            call_homepage()
        end

        --Exit button
        if yPos == 3 and xPos == 25 then 
            call_homepage()
        end
    end

    --Okay button
    if yPos == 10 and xPos >= 11 and xPos <= 17 then 
        call_homepage()
    end

    --Exit button
    if yPos == 3 and xPos == 25 then 
        call_homepage()
    end
    waste()
end

function set_auto_fe()
    popup_screen(5, "Auto Adjust", 11)
    draw_text(5, 7, "Try to maintain:", colors.black, colors.white)

    draw_text(13, 9, " ^ ", colors.white, colors.gray)
    draw_text(10, 11, auto_fe.." FE/t", colors.black, colors.white)
    draw_text(13, 13, " v ", colors.white, colors.gray)
    draw_text(11, 15, " Okay ", colors.white, colors.gray)

    local event, side, xPos, yPos = os.pullEvent("monitor_touch")

    --increase button
    if yPos == 9 then 
        auto_fe = auto_fe + 100
        save_config()
        set_auto_fe()
    end

    --decrease button
    if yPos == 13 then 
        auto_fe = auto_fe - 100
        if auto_fe < 0 then auto_fe = 0 end
        save_config()
        set_auto_fe()
    end

    if yPos == 15 then 
        control_rods()
    end

    set_auto_fe()
end

function control_rods()



    popup_screen(3, "Control Rods", 13)
    insertion_percent = reactor.getControlRodLevel(0)

    draw_text(5, 5, "Inserted: "..insertion_percent.."%", colors.black, colors.white)
    progress_bar(5, 7, 20, insertion_percent, 100, colors.yellow, colors.gray)

    draw_text(5, 9, " << ", colors.white, colors.black)
    draw_text(10, 9, " < ", colors.white, colors.black)
    draw_text(17, 9, " > ", colors.white, colors.black)
    draw_text(21, 9, " >> ", colors.white, colors.black)

    draw_text(5, 11, "Auto:", colors.black, colors.white)
    draw_text(16, 11, " disable ", colors.white, colors.black)

    auto_rods_bool = auto_rods == "true"
    if auto_rods_bool then

        draw_text(5, 13, "FE/t: "..auto_fe, colors.black, colors.white)
        draw_text(18, 13, " set ", colors.white, colors.black)
    else
        draw_text(16, 11, " enable ", colors.white, colors.black)
        draw_text(5, 13, "disabled", colors.red, colors.white)
    end

    draw_text(11, 15, " Close ", colors.white, colors.gray)

    local event, side, xPos, yPos = os.pullEvent("monitor_touch")

    -----manual adjust buttons------------
    if yPos == 9 and xPos >= 5 and xPos <= 15 then 
        reactor.setAllControlRodLevels(insertion_percent-10)
    end

    if yPos == 9 and xPos >= 10 and xPos <= 13 then 
        reactor.setAllControlRodLevels(insertion_percent-1)
    end

    if yPos == 9 and xPos >= 17 and xPos <= 20 then 
        reactor.setAllControlRodLevels(insertion_percent+1)
    end

    if yPos == 9 and xPos >= 21 and xPos <= 25 then 
        reactor.setAllControlRodLevels(insertion_percent+10)
    end


    ------auto buttons-----------------
    if yPos == 11 and xPos >= 16 then 
        if auto_rods_bool then
            auto_rods = "false"
            save_config()
            control_rods()
        else
            auto_rods = "true"
            save_config()
            control_rods()
        end
    end

    if yPos == 13 and xPos >= 18 then 
        set_auto_fe()
    end

    ------Close button-------
    if yPos == 15 and xPos >= 11 and xPos <= 17 then 
        call_homepage()
    end

    ------Exit button------------
    if yPos == 5 and xPos == 25 then 
        call_homepage()
    end
    control_rods()

end

-----------------------Settings--------------------------------


function rf_mode()
    wait = read()
end

function steam_mode()
    wait = read()
end

function install_update()
    clear()
    draw_line(4, 5, 22, colors.blue)

    for counter = 6, 10 do
        draw_line(4, counter, 22, colors.white)
    end

    draw_text(5, 5, "Updating...", colors.white, colors.blue)
    draw_text(5, 7, "Open computer", colors.black, colors.white)
    draw_text(5, 8, "terminal.", colors.black, colors.white)

    if fs.exists("install") then fs.delete("install") end
    shell.run("wget "..baseUrl..installerFile.." install")
    shell.run("install")
end

function update()
    popup_screen(5, "Updates", 4)
    draw_text(5, 7, "Connecting ...", colors.black, colors.white)

    sleep(0.5)

    --reactor update check
    shell.run("wget "..baseUrl..reactorUpdateCheck.." current_version.txt")

    sr = fs.open("current_version.txt", "r")
    current_version = tonumber(sr.readLine())
    sr.close()
    fs.delete("current_version.txt")
    terminal_screen()

    if current_version > version then

        popup_screen(5, "Updates", 7)
        draw_text(5, 7, "Update Available!", colors.black, colors.white)
        draw_text(11, 9, " Install ", colors.white, colors.black)
        draw_text(11, 11, " Ignore ", colors.white, colors.black)

        local event, side, xPos, yPos = os.pullEvent("monitor_touch")

        --Instatll button
        if yPos == 9 and xPos >= 11 and xPos <= 17 then 
            install_update()
        end

        --Exit button
        if yPos == 5 and xPos == 25 then 
            call_homepage()
        end
        call_homepage()

    else
        popup_screen(5, "Updates", 5)
        draw_text(5, 7, "You are up to date!", colors.black, colors.white)
        draw_text(11, 9, " Okay ", colors.white, colors.black)

        local event, side, xPos, yPos = os.pullEvent("monitor_touch")

        --Okay button
        if yPos == 9 and xPos >= 11 and xPos <= 17 then 
            call_homepage()
        end

        --Exit button
        if yPos == 5 and xPos == 25 then 
            call_homepage()
        end
        call_homepage()
    end



end

function reset_peripherals()
    clear()
    draw_line(4, 5, 22, colors.blue)

    for counter = 6, 10 do
        draw_line(4, counter, 22, colors.white)
    end

    draw_text(5, 5, "Reset Peripherals", colors.white, colors.blue)
    draw_text(5, 7, "Open computer", colors.black, colors.white)
    draw_text(5, 8, "terminal.", colors.black, colors.white)
    setup_wizard()

end

--stop running status screen if monitors was touched
function stop()
    while true do
        local event, side, xPos, yPos = os.pullEvent("monitor_touch")
        x = xPos
        y = yPos
        stop_function = "monitor_touch"
        return
    end 
end

function mon_touch()
    --when the monitor is touch on the homepage
    if y == 1 then 
        if x < monX/3 then
            power_menu()
            local event, side, xPos, yPos = os.pullEvent("monitor_touch")
            if xPos < 9 then
                if yPos == 2 then
                    reactor.setActive(true)
                    timer = 0 --reset anytime the reactor is turned on/off
                    call_homepage()
                elseif yPos == 3 then
                    reactor.setActive(false)
                    timer = 0 --reset anytime the reactor is turned on/off
                    call_homepage()
                elseif yPos == 4 then
                    auto_off()
                else
                    call_homepage()

                end
            else
                call_homepage()
            end

        elseif x < 20 then
            tools_menu()
            local event, side, xPos, yPos = os.pullEvent("monitor_touch")
            if xPos < 25 and xPos > 10 then
                if yPos == 2 then
                    control_rods()
                elseif yPos == 3 then
                    efficiency()
                elseif yPos == 4 then
                    fuel()
                elseif yPos == 5 then
                    waste()
                else
                    call_homepage()

                end
            else
                call_homepage()
            end
        elseif x < monX then
            settings_menu()
            local event, side, xPos, yPos = os.pullEvent("monitor_touch")
            if xPos > 13 then
                if yPos == 2 then
                    update()
                elseif yPos == 3 then
                    reset_peripherals() 
                else
                    call_homepage()
                end
            else
                call_homepage()
            end
        end
    else
        call_homepage()
    end
end

function terminal_screen()
    term.clear()
    draw_line_term(1, 1, 55, colors.blue)
    draw_text_term(13, 1, "BiggerReactor Controls", colors.white, colors.blue)
    draw_line_term(1, 19, 55, colors.blue)
    draw_line_term(1, 18, 55, colors.blue)
    draw_text_term(13, 18, "by jaranvil aka jared314", colors.white, colors.blue)
    draw_text_term(13, 19, "modified by Wolf1596Games", colors.white, colors.blue)

    draw_text_term(1, 3, "Current program:", colors.white, colors.black)
    draw_text_term(1, 4, "Reactor Control v"..version, colors.blue, colors.black)

    draw_text_term(1, 6, "Installer:", colors.white, colors.black)
    draw_text_term(1, 7, "pastebin.com/EWwJwiM3", colors.blue, colors.black)

    draw_text_term(1, 9, "Please give me your feedback, suggestions,", colors.white, colors.black)
    draw_text_term(1, 10, "and errors!", colors.white, colors.black)

    draw_text_term(1, 11, "reddit.com/r/br_controls", colors.blue, colors.black)
end

--run both homepage() and stop() until one returns
function call_homepage()
    clear()
    parallel.waitForAny(homepage, stop) 

    if stop_function == "terminal_screen" then 
        stop_function = "nothing"
        setup_wizard()
    elseif stop_function == "monitor_touch" then
        stop_function = "nothing"
        mon_touch()
    end
end

--test if the entered monitor and reactor can be wrapped
function test_configs()
    term.clear()

    draw_line_term(1, 1, 55, colors.blue)
    draw_text_term(10, 1, "BiggerReactors Controls", colors.white, colors.blue)

    draw_line_term(1, 19, 55, colors.blue)
    draw_text_term(10, 19, "by jaranvil aka jared314", colors.white, colors.blue)

    draw_text_term(1, 3, "Searching for a peripherals...", colors.white, colors.black)
    sleep(1)

    reactor = reactorSearch()
    mon = monitorSearch()
    battery = batterySearch()


    draw_text_term(2, 5, "Connecting to reactor...", colors.white, colors.black)
    sleep(0.5)
    if reactor == null then
        draw_text_term(1, 8, "Error:", colors.red, colors.black)
        draw_text_term(1, 9, "Could not connect to reactor", colors.red, colors.black)
        draw_text_term(1, 10, "Reactor must be connected with networking cable", colors.white, colors.black)
        draw_text_term(1, 11, "and modems or the computer is directly beside", colors.white, colors.black)
        draw_text_term(1, 12,"the reactors computer port.", colors.white, colors.black)
        draw_text_term(1, 14, "Press Enter to continue...", colors.gray, colors.black)
        wait = read()
        setup_wizard()
    else
        draw_text_term(27, 5, "success", colors.lime, colors.black)
        sleep(0.5)
    end

    draw_text_term(2, 6, "Connecting to monitor...", colors.white, colors.black)
    sleep(0.5)
    if mon == null then
        draw_text_term(1, 7, "Error:", colors.red, colors.black)
        draw_text_term(1, 8, "Could not connect to a monitor. Place a 3x3 advanced monitor", colors.red, colors.black)
        draw_text_term(1, 11, "Press Enter to continue...", colors.gray, colors.black)
        wait = read()
        setup_wizard()
    else
        monX, monY = mon.getSize()
        draw_text_term(27, 6, "success", colors.lime, colors.black)
        sleep(0.5)
    end

    draw_text_term(2, 7, "Connecting to battery...", colors.white, colors.black)
    sleep(0.5)
    if battery == null then        
        draw_text_term(1, 8, "Error:", colors.red, colors.black)
        draw_text_term(1, 9, "Could not connect to reactor or battery", colors.red, colors.black)
        draw_text_term(1, 10, "Reactor must be connected with networking cable", colors.white, colors.black)
        draw_text_term(1, 11, "and modems or the computer is directly beside", colors.white, colors.black)
        draw_text_term(1, 12,"the reactors computer port.", colors.white, colors.black)
        draw_text_term(1, 14, "Press Enter to continue...", colors.gray, colors.black)
        wait = read()
        setup_wizard()
    else
        monX, monY = mon.getSize()
        draw_text_term(27, 7, battery.typeName, colors.lime, colors.black)
        sleep(0.5)
    end

    draw_text_term(2, 8, "saving configuration...", colors.white, colors.black)  

    save_config()

    sleep(0.1)
    draw_text_term(1, 10, "Setup Complete!", colors.lime, colors.black) 
    sleep(1)

    auto = auto_string == "true"
    call_homepage() 

end
----------------SETUP-------------------------------

function setup_wizard()

    term.clear()


    draw_text_term(1, 1, "BiggerReactor Controls v"..version, colors.lime, colors.black)
    draw_text_term(1, 2, "Peripheral setup", colors.white, colors.black)
    draw_text_term(1, 4, "Step 1:", colors.lime, colors.black)
    draw_text_term(1, 5, "-Place 3x3 advanced monitors next to computer.", colors.white, colors.black)
    draw_text_term(1, 7, "Step 2:", colors.lime, colors.black)
    draw_text_term(1, 8, "-Place a wired modem on this computer and on the ", colors.white, colors.black)
    draw_text_term(1, 9, " computer port of the reactor.", colors.white, colors.black)
    draw_text_term(1, 10, "-connect modems with network cable.", colors.white, colors.black)
    draw_text_term(1, 11, "-right click modems to activate.", colors.white, colors.black)
    draw_text_term(1, 13, "Press Enter when ready...", colors.gray, colors.black)

    wait = read()
    test_configs()


end

-- peripheral searching thanks to /u/kla_sch
-- http://pastebin.com/gTEBHv3D
function reactorSearch()
    local names = peripheral.getNames()
    local i, name
    for i, name in pairs(names) do
        if peripheral.getType(name) == "BigReactors-Reactor" then
            return peripheral.wrap(name)
        else
            --return null
        end
    end
end

function monitorSearch()
    local names = peripheral.getNames()
    local i, name
    for i, name in pairs(names) do
        if peripheral.getType(name) == "monitor" then
            test = name
            return peripheral.wrap(name)
        else
            --return null
        end
    end
end

function batterySearch()
    local names = peripheral.getNames()
    local i, name
    local reactorFound = false
    local batteryFound = false
    local foundReactor

    for i, name in pairs(names) do
        local periphType = peripheral.getType(name)
        if periphType == "ultimateEnergyCube" or periphType == "eliteEnergyCube" or periphType == "advancedEnergyCube" or periphType == "basicEnergyCube" or periphType == "inductionPort" then
            --mekanism energy cubes
            batteryFound = true
            test = name
            MekanismBattery.sourceCell = peripheral.wrap(name)
            MekanismBattery.typeName = periphType
            return MekanismBattery
        elseif periphType == "thermal:energy_cell" or periphType == "integrateddynamics:energy_battery" or periphType == "cyclic:battery_clay" or periphType == "cyclic:battery" then
            --thermal redstone flux cell
            batteryFound = true
            test = name
            ThermalFluxCell.sourceCell = peripheral.wrap(name)
            ThermalFluxCell.typeName = periphType
            return ThermalFluxCell
        elseif periphType == "BigReactors-Reactor" then
            reactorFound = true
            foundReactor = name
        end
    end

    --no "primary" battery found, fall back to reactor
    if reactorFound == true and batteryFound == false then
        ReactorBuffer.sourceCell = peripheral.wrap(foundReactor)
        ReactorBuffer.typeName = "reactor buffer"
        return ReactorBuffer
    end
end

function start()
    --if configs exists, load values and test
    if fs.exists("config.txt") then
        load_config()
        test_configs()
    else
        setup_wizard()
    end
end

-- Battery definitions --

--each should have two methods and two properties:
--getCurrentEnergy()
--getMaxEnergy()
--sourceCell
--typeName

--Mekanism energy cells
--Mekanism induction multiblocks - modem must be connected to an Induction Port
MekanismBattery = {
    sourceCell = {}, --should be whatever block is used for the battery
    typeName = {},

    getCurrentEnergy = function()
        return MekanismBattery.sourceCell.getEnergy()
    end,

    getMaxEnergy = function()
        return MekanismBattery.sourceCell.getMaxEnergy()
    end
}

--if no battery is found
ReactorBuffer = {
    sourceCell = {},
    typeName = {},

    getCurrentEnergy = function()
        return ReactorBuffer.sourceCell.getEnergyStored()
    end,

    getMaxEnergy = function()
        return ReactorBuffer.sourceCell.getEnergyCapacity()
    end
}

--Thermal Redstone Flux Cell
--Integrated Dynamics Battery Box
--Cyclic clay battery
ThermalFluxCell = {
    sourceCell = {},
    typeName = {},

    getCurrentEnergy = function()
        return ThermalFluxCell.sourceCell.getEnergy()
    end,

    getMaxEnergy = function()
        return ThermalFluxCell.sourceCell.getEnergyCapacity()
    end
}

--not supported:
--applied energistics energy cells
--ftb industrial contraptions battery boxes
--flux storage cells


start()