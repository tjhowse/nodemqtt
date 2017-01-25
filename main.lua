secrets = dofile("secrets.lua")
my_name = secrets.mqtt_tld.."/desk"
function sleep()
	node.dsleep(secrets.sleep_duration)
end

tmr.alarm(secrets.deadman_tmr, 25000, tmr.ALARM_SINGLE, function ()
	sleep()
end)

function do_update(update_info)
	print("Doing update")
	httpDL = require("httpDL")
	httpDL.download(update_info.host, update_info.port, update_info.src, update_info.dst.."temp", function (payload)
		print("Update downloaded: "..payload)
		httpDL = nil
		package.loaded["httpDL"]=nil
		if file.list()[update_info.dst.."temp"] == 0 then
			print("mt")
			m:publish(my_name.."/update_failed","DL Fail",0,0)
			return
		end
		hash = crypto.fhash("md5",update_info.dst.."temp")
		hash = crypto.toHex(hash)
		print("hd")
		if hash == update_info.hash then
			print("gh")
			file.rename(update_info.dst.."temp",update_info.dst..".up")
			m:publish(my_name.."/update","",0,1, sleep)
		else
			print("bh")
			m:publish(my_name.."/update_failed","Bad hash",0,0, sleep)
		end
	end)
	httpDL = nil
	package.loaded["httpDL"]=nil
end

function send_data(m,data)
	for k,v in pairs(data) do
		m:publish(my_name..""..v.t,v.v,v.q,v.r)	
	end	
	tmr.alarm(secrets.post_publish_tmr, 2000, tmr.ALARM_SINGLE, function ()
		sleep()
	end)
end

data = {}
for name,size in pairs(file.list()) do
	if string.sub(name,1,4)=="run_" then
		for i,val in pairs(dofile(name)) do
			data[#data+1]=val
		end
	end
end

net.cert.verify(true)
m = mqtt.Client(node.chipid(), 10, secrets.mqtt_user, secrets.mqtt_pwd)
m:on("connect", function(client)
	print("Connected")
	m:subscribe(my_name.."/update",0)
	m:subscribe(my_name.."/delete",0)
	tmr.alarm(secrets.post_publish_tmr, 2000, tmr.ALARM_SINGLE, function ()
		send_data(m,data)
	end)
end)
m:on("message", function(client, topic, message)
	if topic == my_name.."/update" and message ~= "" and message ~= nil then
		tmr.stop(secrets.post_publish_tmr)
		update_info = cjson.decode(message)
		do_update(update_info)
	elseif topic == my_name.."/delete" and message ~= "" and message ~= nil then
		print("deleting "..message)
		file.remove(message)
		m:publish(my_name.."/delete","",0,1)
	end
end)
m:connect(secrets.mqtt_hostname, secrets.mqtt_port, 1,0,nil,function(client, reason)
	m:close()
end)