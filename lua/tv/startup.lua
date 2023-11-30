-- This relies on the presence of the following mods:
-- ComputerCraft: Tweaked (https://modrinth.com/mod/cc-tweaked)
-- Tom's Peripherals (https://modrinth.com/mod/toms-peripherals)
-- You will need to build a GPU, a 4x3 or 8x6 monitor (using the Tom's Peripherals monitor), a speaker, and an advanced computer

local gpu = peripheral.find("tm_gpu")
gpu.refreshSize()
gpu.setSize(64)
gpu.refreshSize()
local px_w, px_h, mon_w, mon_h, res = gpu.getSize()

local speaker = peripheral.find("speaker")

local function drawTv()
    gpu.fill()
end

local function controlTV()
    
end

while true do
    drawTv()
end