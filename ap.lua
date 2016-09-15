print("Initialising server")
wifi.setmode(wifi.SOFTAP)
local cfg
cfg = {
    ip = "10.10.10.10",
    netmask = "255.255.255.0",
    gateway = "10.10.10.10"
}
wifi.ap.setip(cfg)
print(wifi.ap.getip())
cfg = {
    ssid = "configMode",
    pwd = "password1234",
    ecn = 0,
    chl = 6
}
wifi.ap.config(cfg)
  

local username=""
local password=""
local pubkey=""
local subkey=""
local channel=""
local sensorOne=""

function him ()
srv=net.createServer(net.TCP)
end
if pcall(him) then
print("Successfully created server")
else

print("Server creation failed")
end

srv:listen(80,function(conn)
    conn:on("receive", function(client,request)     
        print("Receiving payload") 
        local buf = "";
        local _, _, method, path, vars = string.find(request, "([A-Z]+) (.+)?(.+) HTTP");
        if(method == nil)then
            _, _, method, path = string.find(request, "([A-Z]+) (.+) HTTP");
        end
        local _GET = {}
        if (vars ~= nil)then
            for k, v in string.gmatch(vars, "(%w+)=(%S-)%&") do
                _GET[k] = v
            end
        end
           username=_GET.username
           password=_GET.pwd
           pubkey=_GET.apipubkey
           subkey=_GET.apisubkey
           channel=_GET.channel
           sensorOne=_GET.sensorOneName
           sensorTwo=_GET.sensorTwoName

           print(username)
           print(password)
           print(pubkey)
           print(subkey)
           print(channel)
           print(sensorOne)   
           print(sensorTwo)         
           
            if(username and password)then 
              print("writing station.lua")             
              file.open("station.lua","w")
              file.writeline('wifi.setmode(wifi.STATION)')
              file.writeline('wifi.sta.config("'..username..'","'..password..'")') 
              file.writeline('wifi.sta.connect()')
              file.writeline('tmr.alarm(1, 1000, 1, function() ')
              file.writeline('if wifi.sta.getip()== nil then print("WiFi not connected") ')
              file.writeline('else tmr.stop(1) print("Connection done, IP is "..wifi.sta.getip())')             
              file.writeline('end end)')
              file.close()
            end
            if(pubkey and channel)then              
              file.open("api_file.lua","w")
              file.writeline('conn1:send(\'GET /publish/'..pubkey..'/'..subkey..'/0/'..channel..'/0/{"eon": { "'..sensorOne..'":\'..adc.read(0)..\', "'..sensorTwo..'":\'..gpio.read(2)..\' }} \\r\\n\')')
              file.close()
            end
        srv:close()   
        collectgarbage()
        errorCheck=1  
        
    end)
    end)
    
tmr.alarm(3, 5000, 1, function() 
mode = gpio.read(pin)
if errorCheck ~= 1 or mode==1 then 
    print("Not yet configured") 
    gpio.write(2,gpio.HIGH)  
    gpio.write(1,gpio.LOW)
else 
    tmr.stop(3) 
    gpio.write(2,gpio.LOW)
    gpio.write(1,gpio.HIGH)
    node.restart()
end end)



