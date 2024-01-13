LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Items.Components.Reactor"], "lastReceivedTurbineOutputSignalTime")
LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Items.Components.Reactor"], "signalControlledTargetTurbineOutput")
LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Items.Components.Reactor"], "lastReceivedFissionRateSignalTime")
LuaUserData.MakeFieldAccessible(Descriptors["Barotrauma.Items.Components.Reactor"], "signalControlledTargetFissionRate")
Hook.Patch(
	"Barotrauma.Items.Components.Reactor",
	"Update",
	function(instance, ptable)
		if instance.signalControlledTargetTurbineOutput ~= nil and instance.lastReceivedTurbineOutputSignalTime > Timer.Time - 1 then
			instance.TargetTurbineOutput = instance.signalControlledTargetTurbineOutput
			if CLIENT then
				instance.TurbineOutputScrollBar.BarScroll = instance.TargetTurbineOutput / 100;
			end
			--print("turbine output time received: ", instance.lastReceivedTurbineOutputSignalTime)
		end
		if instance.signalControlledTargetFissionRate ~= nil and instance.lastReceivedFissionRateSignalTime > Timer.Time - 1 then
			instance.TargetFissionRate = instance.signalControlledTargetFissionRate
			if CLIENT then
				instance.FissionRateScrollBar.BarScroll = instance.TargetFissionRate / 100;
			end
			--print("fission rate time received: ", instance.lastReceivedFissionRateSignalTime)
		end
	end, Hook.HookMethodType.Before)