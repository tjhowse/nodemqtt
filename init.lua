secrets = dofile("secrets.lc")
tmr.alarm(secrets.deadman_tmr, 10000, tmr.ALARM_SINGLE, function ()
	node.dsleep(secrets.sleep_duration)
end)

raw,detail=node.bootreason()
badboot = raw == 4  or (detail >= 1 and detail <= 3)
for name,size in pairs(file.list()) do
	len = string.len(name)
	if string.sub(name,len-2,len) == ".kg" and badboot then
		file.remove(string.sub(name,1,len-3))
		file.rename(name,string.sub(name,1,len-3))
	end
	if string.sub(name,len-2,len) == ".up" and not badboot then
		file.remove(string.sub(name,0,len-3)..".kg")
		file.rename(string.sub(name,1,len-3),string.sub(name,0,len-3)..".kg")		
		file.rename(name,string.sub(name,1,len-3))
	end
	len=nil
end
name=nill
size=nill
badboot=nil
raw=nil
detail=nil

wifi.setmode(wifi.STATION)  
wifi.sta.config(secrets.ssid,secrets.wifi_key)

tmr.alarm(secrets.connect_retry_tmr,500, tmr.ALARM_AUTO, function() 
	if wifi.sta.getip()~=nil then
		tmr.stop(secrets.connect_retry_tmr)
		tmr.stop(secrets.deadman_tmr)
		if file.exists("main.lc") then
			dofile("main.lc")
		else
			dofile("main.lua")
		end
	end
end)
