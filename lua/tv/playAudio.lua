local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")
local decoder = dfpwm.make_decoder()

local audioRequest = { url = "https://SERVER_URI/channel/01/audio" }
local rawAudio = http.get(audioRequest)
local audioBuffer = { rawAudio }
local dontCancel = false

local function buffer()
    sleep(5)
    repeat
        sleep(0.05)
    until not dontCancel
end

local function downloadAudio()
    while true do
        dontCancel = true
        local nextAudio = http.get(audioRequest)
        table.insert(audioBuffer, nextAudio)
        dontCancel = false
        sleep(0.2)
    end
end

local function playAudio()
    rawAudio = table.remove(audioBuffer, 1)    
    local line = rawAudio.readLine()
    while line ~= nil do
        local buffer = decoder(line)

        while #buffer ~= 0 and not speaker.playAudio(buffer) do
            os.pullEvent("speaker_audio_empty")
        end

        line = rawAudio.readLine()
    end
    repeat
        sleep(0.05)
    until not dontCancel
end

while #audioBuffer < 10 do
    parallel.waitForAny(downloadAudio, buffer)
end

while true do
    alarmId = os.setAlarm(os.time() + 0.002778)
    parallel.waitForAny(playAudio, downloadAudio)
end