-- tmr.alarm(secrets.sensor_loop_tmr,1000, tmr.ALARM_AUTO, function() 
	-- return {}
-- end)
-- looping = true
-- bme_init = bme280.init(1, 2,nil,nil,nil,1)
bme_init = bme280.init(5, 6)
if bme_init == 2 then
	-- print("Woo")
	-- bme280.startreadout(0, function() 
		-- print("Reading out")
		P, T = bme280.baro()
		H, T = bme280.humi()
		val1={t="/temp",v=T/100,q=0,r=0}
		val2={t="/baro",v=P/1000,q=0,r=0}
		val3={t="/humidity",v=H/1000,q=0,r=0}
		-- print("Success")
		-- looping=false
		return {val1,val2,val3}
	-- end)
else
	print("Fail: "..bme_init)
	return {}
end

-- while looping do
	-- tmr.wdclr()
-- end


-- fail_count = 0
-- tmr.alarm(secrets.sensor_loop_tmr,500, tmr.ALARM_AUTO, function() 
	-- P, T = bme280.baro()
	-- H, T = bme280.humi()
	-- if T~=nil then
		-- val1={t="/temp",v=T/100,q=0,r=0}
		-- val2={t="/baro",v=P/1000,q=0,r=0}
		-- val3={t="/humidity",v=H/1000,q=0,r=0}
		-- print("Success")
		-- return {val1,val2,val3}
	-- else
		-- fail_count = fail_count + 1
		-- print("Fail")
		-- if fail_count > 5 then
			-- return {}
		-- end
	-- end
-- end)

	
	-- T, P, H, QNH = bme280.read(18)
		
-- QNH = bme280.qfe2qnh(P, 18)

-- if T<0 then
  -- print(string.format("T=-%d.%02d", -T/100, -T%100))
-- else
  -- print(string.format("T=%d.%02d", T/100, T%100))
-- end
-- print(string.format("QFE=%d.%03d", P/1000, P%1000))
-- print(string.format("QNH=%d.%03d", QNH/1000, QNH%1000))
-- print(string.format("humidity=%d.%03d%%", H/1000, H%1000))
-- D = bme280.dewpoint(H, T)
-- if D<0 then
  -- print(string.format("dew_point=-%d.%02d", -D/100, -D%100))
-- else
  -- print(string.format("dew_point=%d.%02d", D/100, D%100))
-- end
