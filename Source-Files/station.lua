wifi.setmode(wifi.STATION)
wifi.sta.config("wifi_ssid","password")
wifi.sta.connect()
tmr.alarm(1, 1000, 1, function() 
if wifi.sta.getip()== nil then print("WiFi not connected") 
else tmr.stop(1) print("Connection done, IP is "..wifi.sta.getip())
end end)
