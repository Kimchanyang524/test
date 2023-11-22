local robot = require("robot")

function forward (dist,place)
    for i=1, dist do
        robot.forward()
        if place == "down" then
            selectItem(16)
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
function countItem(number)
    local count=0
    for i=1,10 do
        robot.select(i)
        if robot.compareTo(number) then
            count = count + robot.count(i)
        end
    end
    return count
end
function selectItem(number)
    for i=1,10 do
        robot.select(i)
        if robot.compareTo(number) then
            return
        end
    end
end

function craftWall()
    selectItem(12)
    robot.place()
    up(1)
    selectItem(11)
    robot.place()
    up(5)
    robot.drop(1)
    down(6)
    os.sleep(5)
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
            selectItem(16)
            forward(1,"down")
            robot.turnRight()
        else
            robot.turnLeft()
            selectItem(16)
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
    while countItem(16) < 98 do
        craftWall()    
    end
    
    selectItem(16)
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
    selectItem(15)
    robot.placeDown()
    forward(2,false)
    robot.turnLeft()
    back(2,false)
    up(1)
    buildRing()
    robot.turnLeft()
    up(1)
    selectItem(16)
    robot.placeDown()
    buildPlatform()
    robot.turnLeft()
    forward(2,false)
    robot.turnRight()
    back(5,false)
    selectItem(14)
    up(1)
    robot.drop(1)
    down(6)
    os.sleep(33)
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