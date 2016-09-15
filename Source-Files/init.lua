pin = 5
gpio.mode(pin, gpio.INPUT)
gpio.mode(7,gpio.INT)
         gpio.trig(7,'up',onStop)
function onModeChange()
mode = gpio.read(pin)
if mode==1 then
    print("Config mode")    
    dofile("ap.lc")
else
    print("Data Collection Mode")    
    dofile("main.lc")  
end
end

onModeChange()
function onStop()
        tmr.stop(1) 
        gpio.write(1,gpio.LOW)
        print("Data Collection stopped.Please reset to start again")
    end


