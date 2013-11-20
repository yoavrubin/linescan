function timeVal = pixelToTime(pixel)
global data
    timeVal = pixel*data.timePerLine/data.pixelResamplingFactor;