local robot = require("robot")
local component = require("component")
local slot = component.inventory_controller.getStackInInternalSlot
local sides = require("sides")
local max = robot.inventorySize()

function forward (dist,place)
    for i=1, dist do
        robot.forward()
        if place == "down" then
            selectItem("Compact Machine Wall")
            robot.placeDown()
        end
    end
end
function back (dist,place)
    for i=1, dist do
        robot.back()
        if place == "down" then
            robot.placeDown()
        elseif place == "up" then
            robot.placeUp()
        elseif place == "forward" then
            robot.place()
        end
    end
end
function up (dist)
    for i=1, dist do
        robot.up()
    end
end
function down (dist)
    for i=1, dist do
        robot.down()
    end
end
function countItem(block, num)
    local count=0
    for i=1,max do
        local item = slot(i)
        if item then
            if item.label == block then
                count = count + item.size
                if count > num then
                    return false
                end
            end
        end
    end
    return true
end
function selectItem(block)
    for i=1,max do
        local item = slot(i)
        if item then
            if item.label == block then
                robot.select(i)
                return
            end
        end
    end
end

function craftWall()
    if countItem("Block of Nickel", 1) then
        print("Block of Nickel is needed")
        os.exit()
    end
    if countItem("Redstone", 2) then
        print("Redstone is needed")
        os.exit()
    end
    selectItem("Block of Nickel")
    robot.place()
    up(1)
    selectItem("Redstone")
    robot.place()
    up(5)
    robot.drop(1)
    down(6)
    os.sleep(3)
    forward(2,false)
    robot.suck()
    back(2,false)
end

function buildPlatform()
    for i=1,5 do
        forward(4,"down")
        if i == 5 then
            return
        end       
        if i%2 == 1 then
            robot.turnRight()
            selectItem("Compact Machine Wall")
            forward(1,"down")
            robot.turnRight()
        else
            robot.turnLeft()
            selectItem("Compact Machine Wall")
            forward(1,"down")
            robot.turnLeft()
        end 
    end
end
function buildRing()
    for i=1,4 do
        forward(4,"down")
        robot.turnLeft()
    end
end


function craftMachine()
    while countItem("Compact Machine Wall", 98) do
        craftWall()    
    end
    if countItem("End Steel Block", 1) then
        print("End Steel Block is needed")
        os.exit()
    end
    if countItem("Ender Pearl", 2) then
        print("Ender Pearl is needed")
        os.exit()
    end
    selectItem("Compact Machine Wall")
    robot.turnLeft()
    forward(2,false)  
    robot.turnRight()
    up(1)
    forward(1,"down")
    buildPlatform()
    up(1)
    robot.turnLeft()
    buildRing()
    up(1)
    buildRing()
    forward(2,false)
    robot.turnLeft()
    forward(2,false)
    selectItem("End Steel Block")
    robot.placeDown()
    forward(2,false)
    robot.turnLeft()
    back(2,false)
    up(1)
    buildRing()
    robot.turnLeft()
    up(1)
    selectItem("Compact Machine Wall")
    robot.placeDown()
    buildPlatform()
    robot.turnLeft()
    forward(2,false)
    robot.turnRight()
    back(5,false)
    selectItem("Ender Pearl")
    up(1)
    robot.drop(1)
    down(6)
    os.sleep(27)
    forward(2,false)
    robot.suck()
    back(2,false)
end

args = {...}

if #args ~= 2 then
    print("Usage: build <item> <num> \n machine, wall, tunnel")
    return
end

for i=1,args[2] do
    if args[1] == "machine" then
        craftMachine()
    elseif args[1] == "wall" then
        craftWall()
    end
end
