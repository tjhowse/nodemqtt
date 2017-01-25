temp_pin = 4

require("ow")
ow.setup(temp_pin)
ow.reset_search(temp_pin)
addr = ow.search(temp_pin)

ow.reset(temp_pin)
ow.select(temp_pin, addr)
ow.write(temp_pin,0x4E,1)
ow.write(temp_pin,0x1,1)
ow.write(temp_pin,0x1,1)
ow.write(temp_pin,0x7F,1)
ow.reset(temp_pin)
ow.write(temp_pin,0x48,1)
package.loaded["ow"]=nil
temp = require("ds18b20")
temp.setup(temp_pin) -- GPIO2
t = temp.read()
temp = nil
temp_pin = nil
package.loaded["ds18b20"]=nil
if t~=85 then
	val1={t="myHouse/roof/temp",v=t,q=0,r=0}
	return {val1}
else
	return {}
end
