    dofile("station.lua")    
         
    function httpclient()   
    local check = gpio.read(pin)
        if check==1 then            
            tmr.stop(1)
            gpio.write(2,gpio.HIGH)
            gpio.write(1,gpio.LOW)
            dofile("ap.lc") 
        else
            gpio.write(2,gpio.LOW)
            gpio.write(1,gpio.HIGH)
            dofile("sendData.lc")
        end
    end
    httpclient()
    tmr.alarm(1,5000,1,function() httpclient() end)

    
