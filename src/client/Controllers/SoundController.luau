--!strict
local SoundService = game:GetService("SoundService")


local SOUND_IDS: {[string]: string} = {
    Win = "rbxassetid://127039883737564",
    Buy = "rbxassetid://133292918309565",
    Error = "rbxassetid://132281440773764",
}

local sounds: {[string]: Sound} = {}


local SoundController = {}

function SoundController.start()
    for name, id in SOUND_IDS do
        local sound = Instance.new("Sound")
        sound.SoundId = id
        sound.Name = name
        sound.Volume = 0.5
        sound.Parent = SoundService
        sounds[name] = sound
    end
end

function SoundController.play(name: string)
    local sound = sounds[name]
    if sound then
        sound:Play()
    end
end

return SoundController
