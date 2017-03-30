
bme280.init(1, 2)

-- T, P, H, QNH = bme280.read(18)
P, T = bme280.baro()
-- QNH = bme280.qfe2qnh(P, 18)
H, T = bme280.humi()

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
val1={t="/temp",v=T/100,q=0,r=0}
val2={t="/baro",v=P/1000,q=0,r=0}
val3={t="/humidity",v=H/1000,q=0,r=0}
return {val1,val2,val3}