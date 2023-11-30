-- This relies on the presence of the following mods:
-- ComputerCraft: Tweaked (https://modrinth.com/mod/cc-tweaked)
-- Tom's Peripherals (https://modrinth.com/mod/toms-peripherals)
-- You will need to build a GPU, a 4x3 or 8x6 monitor (using the Tom's Peripherals monitor), a speaker, and an advanced computer

local gpu = peripheral.find("tm_gpu")
gpu.refreshSize()
gpu.setSize(64)
gpu.refreshSize()
local image
local px_w, px_h, mon_w, mon_h, res = gpu.getSize()

local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")
local decoder = dfpwm.make_decoder()

local function doTV()
    gpu.fill()
    local imgBuf = http.get("https://SERVER_URI/channel/01/"..px_w, {}, true)
    local b = imgBuf.read(1)
    local imgBin = {}
    while b do
        imgBin[#imgBin+1] = ("<I1"):unpack(b)
        b = imgBuf.read(1)
    end
    image = gpu.decodeImage(table.unpack(imgBin))
    gpu.drawBuffer(1, 1, px_w, 1, image.getAsBuffer())
    gpu.sync()

    local rawAudio = http.get("https://SERVER_URI/channel/01/audio")
    local line = rawAudio.readLine()
    while line ~= nil do
        local buffer = decoder(line)

        while #buffer ~= 0 and not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end

        line = rawAudio.readLine()
    end
end

local function controlTV()
    
end

while true do
    doTV()
end