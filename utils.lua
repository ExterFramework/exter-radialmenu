local QBCore = exports['qb-core']:GetCoreObject()

function isCloseVeh()
    local ped = PlayerPedId()
    local coordA = GetEntityCoords(ped, 1)
    local coordB = GetOffsetFromEntityInWorldCoords(ped, 0.0, 100.0, 0.0)
    local vehicle = getVehicleInDirection(coordA, coordB)
    if DoesEntityExist(vehicle) and NetworkHasControlOfEntity(vehicle) then
        return true
    end
    return false
end

function getVehicleInDirection(coordFrom, coordTo)
	local offset = 0
	local rayHandle
	local vehicle
	for i = 0, 100 do
		rayHandle = CastRayPointToPoint(coordFrom.x, coordFrom.y, coordFrom.z, coordTo.x, coordTo.y, coordTo.z + offset, 10, PlayerPedId(), 0)	
		local _, _, _, _, hitVehicle = GetRaycastResult(rayHandle)
        vehicle = hitVehicle
		offset = offset - 1
		if vehicle ~= 0 then break end
	end
    if vehicle == 0 then
        return 0
    end

	local distance = Vdist2(coordFrom, GetEntityCoords(vehicle))
	if distance > 25 then vehicle = nil end
    return vehicle ~= nil and vehicle or 0
end

function hasEnoughOfItem(item, cb)
	QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if cb then
            cb(result == true)
        end
	end, item)
end
