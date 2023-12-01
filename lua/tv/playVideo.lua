local gpu = peripheral.find("tm_gpu")
gpu.refreshSize()
gpu.setSize(64)
gpu.refreshSize()
local image
local px_w, px_h, mon_w, mon_h, res = gpu.getSize()

local imgRequest = { url = "https://SERVER_URI/channel/01/"..px_w, binary = true }
local imgBuf = http.get(imgRequest)
local nextImgBuf

local function writeImageToScreen()
    gpu.fill()
    local b = imgBuf.read(1)
    local imgBin = {}
    while b do
        imgBin[#imgBin+1] = ("<I1"):unpack(b)
        b = imgBuf.read(1)
    end
    image = gpu.decodeImage(table.unpack(imgBin))
    gpu.drawBuffer(1, 1, px_w, 1, image.getAsBuffer())
    gpu.sync()
end

local function downloadImage()    
    -- local event, url, handle
    -- if url ~= imgRequest.url then
    --     event, url, handle = os.pullEvent("http_success")
    --     if url == imgRequest.url then
    --         nextImgBuf = handle
    --     end
    -- end
    nextImgBuf = http.get(imgRequest)
end

while true do
    -- http.request(imgRequest)
    parallel.waitForAll(writeImageToScreen, downloadImage)
    imgBuf = nextImgBuf
end