-----BigReactor Control
-----by jaranvil aka jared314

-----feel free to use and/or modify this code

-----Modified by Wolf1596Games
-----------------------------------------------

version = 1.1
term.clear()
-------------------FORMATTING-------------------------------
function clear()
	mon.setBackgroundColor(colors.black)
	mon.clear()
	mon.setCursorPos(1,1)
end

function draw_text_term(x, y, text, text_color, bg_color)
	term.setTextColor(text_color)
	term.setBackgroundColor(bg_color)
	term.setCursorPos(x,y)
	write(text)
end

function draw_text(x, y, text, text_color, bg_color)
	mon.setBackgroundColor(bg_color)
	mon.setTextColor(text_color)
	mon.setCursorPos(x,y)
	mon.write(text)
end

function draw_line(x, y, length, color)
		mon.setBackgroundColor(color)
		mon.setCursorPos(x,y)
		mon.write(string.rep(" ", length))
end

function draw_line_term(x, y, length, color)
		term.setBackgroundColor(color)
		term.setCursorPos(x,y)
		term.write(string.rep(" ", length))
end

function progress_bar(x, y, length, minVal, maxVal, bar_color, bg_color)
	draw_line(x, y, length, bg_color) --backgoround bar
	local barSize = math.floor((minVal/maxVal) * length) 
	draw_line(x, y, barSize, bar_color)	--progress so far
end

function progress_bar_term(x, y, length, minVal, maxVal, bar_color, bg_color)
	draw_line_term(x, y, length, bg_color) --backgoround bar
	local barSize = math.floor((minVal/maxVal) * length) 
	draw_line_term(x, y, barSize, bar_color)	--progress so far
end

function button(x, y, length, text, txt_color, bg_color)
	draw_line(x, y, length, bg_color)
	draw_text((x+2), y, text, txt_color, bg_color)
end

function menu_bar()
	draw_line(1, 1, monX, colors.blue)
	draw_text(2, 1, "Power    Tools    Settings", colors.white, colors.blue)
	draw_line(1, 19, monX, colors.blue)
	draw_text(2, 19, "     Turbine Control", colors.white, colors.blue)
end

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

function tools_menu()
	draw_line(10, 2, 14, colors.gray)
	draw_line(10, 3, 14, colors.gray)
	draw_text(11, 2, "Flow Rate", colors.white, colors.gray)
	draw_text(11, 3, "Coils", colors.white, colors.gray)
	
	
end

function settings_menu()
	draw_line(12, 2, 18, colors.gray)
	draw_line(12, 3, 18, colors.gray)
	draw_text(13, 2, "Check for Updates", colors.white, colors.gray)
	draw_text(13, 3, "Reset peripherals", colors.white, colors.gray)
end

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

function save_config()
	sw = fs.open("turbine_config.txt", "w")		
		sw.writeLine(version)
		sw.writeLine(side)
		sw.writeLine(name)
		sw.writeLine(auto_string)
		sw.writeLine(on)
		sw.writeLine(off)
	sw.close()
end

function load_config()
	sr = fs.open("turbine_config.txt", "r")
		version = tonumber(sr.readLine())
		side = sr.readLine()
		name = sr.readLine()
		auto_string = sr.readLine()
		on = tonumber(sr.readLine())
		off = tonumber(sr.readLine())
	sr.close()
end

--------------------------------------------------



function homepage()
	while true do
		clear()
		menu_bar()
		terminal_screen()

		active = turbine.getActive()
		energy_stored = turbine0.getEnergyStats().energyStored
		

		--------POWER STAT--------------
		draw_text(2, 3, "Power: ", colors.yellow, colors.black)
		
		if active then
			draw_text(10, 3, "ONLINE", colors.lime, colors.black)
		else
			draw_text(10, 3, "OFFLINE", colors.red, colors.black)
		end


		-----------Rotor speed---------------------
		draw_text(2, 5, "Rotor Speed: ", colors.yellow, colors.black)
		local maxVal = 2000
		local minVal = math.floor(turbine.getRotorSpeed())
		draw_text(19, 5, minVal.." rpm", colors.white, colors.black)

		if minVal < 700 then
		progress_bar(2, 6, monX-2, minVal, maxVal, colors.lightBlue, colors.gray)
		else if minVal < 900 then	
		progress_bar(2, 6, monX-2, minVal, maxVal, colors.lime, colors.gray)
		else if minVal < 1700 then
		progress_bar(2, 6, monX-2, minVal, maxVal, colors.lightBlue, colors.gray)
		else if minVal < 1900 then
		progress_bar(2, 6, monX-2, minVal, maxVal, colors.lime, colors.gray)
		else if minVal < 2000 then
		progress_bar(2, 6, monX-2, minVal, maxVal, colors.yellow, colors.gray)
		else if minVal >= 2000 then
		progress_bar(2, 6, monX-2, minVal, maxVal, colors.red, colors.gray)
		end
		end
		end
		end
		end
		end

		-----------Steam Level---------------------
		draw_text(2, 8, "Steam Amount: ", colors.yellow, colors.black)
		local maxVal = turbine.getFluidAmountMax()
		local minVal = math.floor(turbine.getInputAmount())
		draw_text(19, 8, minVal.." mB", colors.white, colors.black)
		progress_bar(2, 9, monX-2, minVal, maxVal, colors.lightGray, colors.gray)
		

		-----------Water Level---------------------
		draw_text(2, 11, "Water Amount: ", colors.yellow, colors.black)
		local maxVal = turbine.getFluidAmountMax()
		local minVal = math.floor(turbine.getOutputAmount())
		draw_text(19, 11, minVal.." mB", colors.white, colors.black)
		progress_bar(2, 12, monX-2, minVal, maxVal, colors.blue, colors.gray)
	

		-------------OUTPUT-------------------
		draw_text(2, 14, "FE/tick: ", colors.yellow, colors.black)
		rft = math.floor(turbine.getEnergyStats().energyProducedLastTick)
		draw_text(19, 14, rft.." FE/T", colors.white, colors.black)

		-----------RF STORAGE---------------
		draw_text(2, 15, "RF Stored:", colors.yellow, colors.black)
		local maxVal = turbine.getEnergyStats().energyCapacity
		local minVal = energy_stored
		local percent = math.floor((energy_stored/maxVal)*100)
		draw_text(19, 15, percent.."%", colors.white, colors.black)

		------------FLOW RATE----------------
		draw_text(2, 16, "Flow Rate: ", colors.yellow, colors.black)
		flow_rate = turbine.getFluidFlowRate()
		draw_text(19, 16, flow_rate.." mB/t", colors.white, colors.black)

		------------COILS---------------------------
		engaged = turbine.getInductorEngaged()
		draw_text(2, 17, "Coils: ", colors.yellow, colors.black)

		if engaged then 
			draw_text(19, 17, "Engaged", colors.white, colors.black)
		else
			draw_text(19, 17, "Disengaged", colors.white, colors.black)
		end

		------------AUTO SHUTOFF-------------
		auto = auto_string == "true"
		if auto then
			if active then
				draw_text(2, 18, "Auto off:", colors.yellow, colors.black)
				draw_text(13, 18, off.."% FE Stored", colors.white, colors.black)
				if percent >= off then
					turbine.setActive(false)
					call_homepage()
				end
			else
				draw_text(2, 18, "Auto on:", colors.yellow, colors.black)
				draw_text(13, 18, on.."% FE Stored", colors.white, colors.black)
				if percent <= on then
					turbine.setActive(true)
					call_homepage()
				end
			end
		else
			draw_text(2, 18, "Auto power:", colors.yellow, colors.black)
			draw_text(14, 18, "disabled", colors.red, colors.black)
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


-------------------Tools----------------------

function flow_rate_menu()
	popup_screen(3, "Flow Rate", 12)
	flow_rate = turbine.getFluidFlowRateMax()
	current_flow = turbine.getFluidFlowRate()

	draw_text(5, 5, "Steam consumption", colors.lime, colors.white)
	draw_text(5, 6, "last tick:", colors.lime, colors.white)
	draw_text(13, 8, current_flow.." mB", colors.black, colors.white)

	draw_text(5, 10, "Flow Rate Setting:", colors.lime, colors.white)
	draw_text(8, 12, " < ", colors.white, colors.black)
	draw_text(13, 12, flow_rate.." mB", colors.black, colors.white)
	draw_text(21, 12, " > ", colors.white, colors.black)

	draw_text(13, 14, " Okay ", colors.white, colors.black)

	local event, side, xPos, yPos = os.pullEvent("monitor_touch")

	--decrease
	if yPos == 12 and xPos >= 8 and xPos <= 11 then 
		turbine.setFluidFlowRateMax(flow_rate-10)
		flow_rate_menu()
	--increase
	else if yPos == 12 and xPos >= 21 and xPos <= 24 then 
		turbine.setFluidFlowRateMax(flow_rate+10)
		flow_rate_menu()
	end
	end

	--Okay button
	if yPos == 14 and xPos >= 13 and xPos <= 19 then 
		call_homepage()
	end

	--Exit button
	if yPos == 3 and xPos == 25 then 
		call_homepage()
	end
	flow_rate_menu()
end


function coil_menu()
	engaged = turbine.getInductorEngaged()

	popup_screen(3, "Induction Coils", 8)
	draw_text(5, 5, "Coil Status:", colors.black, colors.white)

	if engaged then
		draw_text(5, 6, "Engaged", colors.lime, colors.white)
		draw_text(10, 8, " Disengage ", colors.white, colors.black)
	else
		draw_text(5, 6, "Disengaged", colors.red, colors.white)
		draw_text(10, 8, " Engage ", colors.white, colors.black)
	end

	draw_text(12, 10, " Okay ", colors.white, colors.black)


	local event, side, xPos, yPos = os.pullEvent("monitor_touch")

	if yPos == 8 and xPos >= 10 and xPos <= 21 then
		if engaged then
			turbine.setInductorEngaged(false)
			coil_menu()
		else
			turbine.setInductorEngaged(true)
			coil_menu()
		end
	end

	--okay button
	if yPos == 10 and xPos >= 12 and xPos <= 18 then
		call_homepage()
	end


	coil_menu()
end

-----------------------Settings--------------------------------



function install_update(program, pastebin)
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
	
    shell.run("wget "..baseUrl..turbine_update_check.." install")
	sr = fs.open("current_version.txt", "r")
	current_version = tonumber(sr.readLine())
	sr.close()
	fs.delete("current_version.txt")
	terminal_screen()

	if current_version > version then

		popup_screen(5, "Updates", 7)
		draw_text(5, 7, "Update Available!", colors.black, colors.white)
		draw_text(11, 9, " Intall ", colors.white, colors.black)
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
						turbine.setActive(true)
						call_homepage()
					else if yPos == 3 then
						turbine.setActive(false)
						call_homepage()
					else if yPos == 4 then
						auto_off()
					else
						call_homepage()
					end
					end
					end
				else
					call_homepage()
				end
				
			else if x < 20 then
				tools_menu()
				local event, side, xPos, yPos = os.pullEvent("monitor_touch")
				if xPos < 25 and xPos > 10 then
					if yPos == 2 then
						flow_rate_menu()
					else if yPos == 3 then
						coil_menu()
					else if yPos == 4 then
						
					else if yPos == 5 then
					
					else
						call_homepage()
					end
					end
					end
					end
				else
					call_homepage()
				end
			else if x < monX then
				settings_menu()
				local event, side, xPos, yPos = os.pullEvent("monitor_touch")
				if xPos > 13 then
					if yPos == 2 then
						update()
					else if yPos == 3 then
						reset_peripherals()	
					else
						call_homepage()
					end
					end
				else
					call_homepage()
				end
			end
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
	draw_line_term(1, 18, 55, colors.blue)
	draw_line_term(1, 19, 55, colors.blue)
	draw_text_term(13, 18, "by jaranvil aka jared314", colors.white, colors.blue)
	draw_text_term(13, 19, "modified by Wolf1596Games", colors.white, colors.blue)

	draw_text_term(1, 3, "Current program:", colors.white, colors.black)
	draw_text_term(1, 4, "Turbine Control v"..version, colors.blue, colors.black)
	
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
	else if stop_function == "monitor_touch" then
		stop_function = "nothing"
		mon_touch()
	end
	end
end

--try to wrap peripherals
--catch any errors
	function test_turbine_connection()
		turbine = peripheral.wrap(name)  --wrap reactor
		c = turbine.mbIsConnected()
	    if unexpected_condition then error() end   
	end

	function test_monitor_connection()
		mon = peripheral.wrap(side) --wrap mon
		monX, monY = mon.getSize() --get mon size () 
	    if unexpected_condition then error() end   
	end

--test if the entered monitor and reactor can be wrapped
	function test_configs()

		term.clear()
		draw_line_term(1, 1, 55, colors.blue)
		draw_text_term(10, 1, "BiggerReactor Controls v"..version, colors.white, colors.blue)
		draw_line_term(1, 18, 55, colors.blue)
		draw_line_term(1, 19, 55, colors.blue)
		draw_text_term(10, 18, "by jaranvil aka jared314", colors.white, colors.blue)
		draw_text_term(10, 19, "modified by Wolf1596Games", colors.white, colors.blue)

		draw_text_term(1, 3, "Wrapping peripherals...", colors.blue, colors.black)
		draw_text_term(2, 5, "wrap montior...", colors.white, colors.black)
		sleep(0.1)
		if pcall(test_monitor_connection) then 
			draw_text_term(18, 5, "success", colors.lime, colors.black)
		else
			draw_text_term(1, 4, "Error:", colors.red, colors.black)
			draw_text_term(1, 8, "Could not connect to monitor on "..side.." side", colors.red, colors.black)
			draw_text_term(1, 9, "Valid sides are 'left', 'right', 'top', 'bottom' and 'back'", colors.white, colors.black)
			draw_text_term(1, 11, "Press Enter to continue...", colors.gray, colors.black)
			wait = read()
			setup_wizard()
		end
		sleep(0.1)
		draw_text_term(2, 6, "wrap turbine...", colors.white, colors.black)
		sleep(0.1)
		if pcall(test_turbine_connection) then 
			draw_text_term(18, 6, "success", colors.lime, colors.black)
		else
			draw_text_term(1, 8, "Error:", colors.red, colors.black)
			draw_text_term(1, 9, "Could not connect to "..name, colors.red, colors.black)
			draw_text_term(1, 10, "Turbine must be connected with networking cable and wired modem", colors.white, colors.black)
			draw_text_term(1, 12, "Press Enter to continue...", colors.gray, colors.black)
			wait = read()
			setup_wizard()
		end
		sleep(0.1)
		draw_text_term(2, 8, "saving settings to file...", colors.white, colors.black)	

		save_config()

		sleep(0.1)
		draw_text_term(1, 10, "Setup Complete!", colors.lime, colors.black)	
		sleep(3)

		auto = auto_string == "true"
		call_homepage() 

end
----------------SETUP-------------------------------

function setup_wizard()
	term.clear()
	draw_text_term(1, 1, "BiggerReactor Controls v"..version, colors.lime, colors.black)
	draw_text_term(1, 2, "Peripheral setup wizard", colors.white, colors.black)
	draw_text_term(1, 4, "Step 1:", colors.lime, colors.black)
	draw_text_term(1, 5, "-Place 3x3 advanced monitors next to computer.", colors.white, colors.black)
	draw_text_term(1, 7, "Step 2:", colors.lime, colors.black)
	draw_text_term(1, 8, "-Place a wired modem on this computer and on the ", colors.white, colors.black)
	draw_text_term(1, 9, " computer port of the turbine.", colors.white, colors.black)
	draw_text_term(1, 10, "-connect modems with network cable.", colors.white, colors.black)
	draw_text_term(1, 11, "-right click modems to activate.", colors.white, colors.black)
	draw_text_term(1, 13, "Press Enter when ready...", colors.gray, colors.black)
	
	wait = read()
	
	term.clear()
	draw_text_term(1, 1, "Peripheral Setup", colors.lime, colors.black)
	draw_text_term(1, 3, "What side is your monitor on?", colors.yellow, colors.black)

	term.setTextColor(colors.white) 
	term.setCursorPos(1,4)
	side = read()

	term.clear()
	draw_text_term(1, 1, "Peripheral Setup", colors.lime, colors.black)
	draw_text_term(1, 3, "What is the turbine's name?", colors.yellow, colors.black)
	draw_text_term(1, 4, "type 'default' for  'BigReactors-Turbine_0'", colors.gray, colors.black)

	term.setTextColor(colors.white) 
	term.setCursorPos(1,5)
	name = read()

	if name == "default" then name = "BigReactors-Turbine_0" end
	auto_string = false
	on = 0
	off = 99

	test_configs()
end

function start()
	--if configs exists, load values and test
	if fs.exists("turbine_config.txt") then
			load_config()

			test_configs()
	else
		setup_wizard()
	end
end

start()