--// DAFZZ SKY + TEXTURE + SOUND REPLACEMENT
--// Luau / iPad / Delta

local W,A=writefile,getcustomasset or getsynasset

if not(W and A)then
    warn("custom asset APIs missing")
    return
end

--==================================================
-- ASSET DOWNLOADER
--==================================================

local function get(n,u)
    local ok,r=pcall(function()
        W(n,game:HttpGet(u))
        return A(n)
    end)

    if ok then
        return r
    end

    warn(r)
end

--==================================================
-- TEXTURE REPLACEMENT
--==================================================

local TARGET_ID="7658055825"
local NEW_TEXTURE="rbxassetid://85511471808017"

local function replaceTexture(obj)
    if not(obj:IsA("Decal") or obj:IsA("Texture"))then
        return
    end

    local currentId=tostring(obj.Texture):match("%d+")

    if currentId==TARGET_ID then
        obj.Texture=NEW_TEXTURE
    end
end

for _,obj in ipairs(game:GetDescendants())do
    replaceTexture(obj)
end

game.DescendantAdded:Connect(function(obj)
    task.wait(.2)
    replaceTexture(obj)
end)

--==================================================
-- DAFZZ SKY
--==================================================

local U={
    ft="https://raw.githubusercontent.com/louisvilleabsalon8-hue/dafzzz-gay-sky/refs/heads/main/sky512_ft.png",
    lf="https://raw.githubusercontent.com/louisvilleabsalon8-hue/dafzzz-gay-sky/refs/heads/main/sky512_lf.png",
    rt="https://raw.githubusercontent.com/louisvilleabsalon8-hue/dafzzz-gay-sky/refs/heads/main/sky512_rt.png",
    dn="https://raw.githubusercontent.com/louisvilleabsalon8-hue/dafzzz-gay-sky/refs/heads/main/sky512_dn.png",
    bk="https://raw.githubusercontent.com/louisvilleabsalon8-hue/dafzzz-gay-sky/refs/heads/main/sky512_bk.png",
    up="https://raw.githubusercontent.com/louisvilleabsalon8-hue/dafzzz-gay-sky/refs/heads/main/sky512_up.png"
}

local P={
    bk="SkyboxBk",
    dn="SkyboxDn",
    ft="SkyboxFt",
    lf="SkyboxLf",
    rt="SkyboxRt",
    up="SkyboxUp"
}

local SA={}

for _,f in ipairs({"bk","dn","ft","lf","rt","up"})do
    SA[f]=get("dafzzz_"..f..".png",U[f])
    task.wait(.12)
end

local L=game:GetService("Lighting")
local creating=false

local function freshSky()
    if creating then
        return
    end

    creating=true

    for _,v in ipairs(L:GetChildren())do
        if v:IsA("Sky")then
            pcall(function()
                v:Destroy()
            end)
        end
    end

    local x=Instance.new("Sky")
    x.Name="DAFZZSky"

    for f,a in pairs(SA)do
        if a then
            pcall(function()
                x[P[f]]=a
            end)
        end
    end

    x.Parent=L
    creating=false
end

freshSky()

for _,t in ipairs({.5,1.5,3,6,10})do
    task.delay(t,freshSky)
end

local last=0

L.ChildAdded:Connect(function(x)
    if x:IsA("Sky") and x.Name~="DAFZZSky"then
        local now=os.clock()

        if now-last>.5 then
            last=now
            task.delay(.15,freshSky)
        end
    end
end)

--==================================================
-- SOUND EFFECT ASSETS
--==================================================

local Sounds={

    ["kill sound"]={
        ids={16530229616,16530229541,16530229695},
        url="https://github.com/leitopatatua-lab/imaen/raw/refs/heads/main/nino-nakano-bye-bye.mp3",
        file="dafzzz_kill.mp3"
    },

    ["matchpoint"]={
        ids={17026600996},
        url="https://github.com/uokkna/idfk/raw/refs/heads/main/doki.MP3",
        file="dafzzz_matchpoint.mp3"
    },

    ["win game"]={
        ids={18239670056},
        url="https://github.com/leitopatatua-lab/skibidi/raw/refs/heads/main/day%201.MP3",
        file="dafzzz_win.mp3"
    },

    ["Die"]={
        ids={17016581922},
        url="https://github.com/leitopatatua-lab/skibidi/raw/refs/heads/main/0821%20(1)(3).MP3",
        file="dafzzz_die.mp3"
    },

    ["Load sound"]={
        ids={6384899588},
        url="https://github.com/leitopatatua-lab/skibidi/raw/refs/heads/main/0821%20(1).MP3",
        file="dafzzz_load.mp3"
    },

    ["4-4"]={
        ids={17467242617},
        url="https://github.com/leitopatatua-lab/echo-imagen-README.md/raw/refs/heads/main/4-4%20sudden%20death.MP3",
        file="dafzzz_44.mp3"
    },

    ["lobby sound"]={
        ids={
            17697682466,
            17733314783,
            100081814360953,
            86062306109271,
            82135261819112,
            96771526359691,
            120824068504773,
            114306049661290,
            91718252417630,
            119694504935889
        },
        url="https://github.com/leitopatatua-lab/echo-imagen-README.md/raw/refs/heads/main/lobby%20song.MP3",
        file="dafzzz_lobby.mp3"
    },

    ["Stolen slide lel"]={
        ids={16737738420},
        url="https://github.com/leitopatatua-lab/imaen/raw/refs/heads/main/sparkle.wav",
        file="dafzzz_slide.wav"
    },

    ["Double jump"]={
        ids={16770456156},
        url="https://github.com/leitopatatua-lab/echo-imagen-README.md/raw/refs/heads/main/bell%20ding%20sfx.ogg",
        file="dafzzz_doublejump.ogg"
    },

    ["Click sfc"]={
        ids={177266782},
        url="https://github.com/leitopatatua-lab/imaen/raw/refs/heads/main/osu%20hitsound.ogg",
        file="dafzzz_click.ogg"
    }
}

--==================================================
-- DOWNLOAD + BUILD SOUND ID MAP
--==================================================

local SoundAssets={}
local SoundIdMap={}

for name,data in pairs(Sounds)do
    local asset=get(data.file,data.url)
    SoundAssets[name]=asset

    if asset then
        for _,id in ipairs(data.ids)do
            SoundIdMap[tostring(id)]=asset
        end
    end

    task.wait(.12)
end

--==================================================
-- SOUND REPLACEMENT
--==================================================

local function getSoundId(sound)
    if not sound:IsA("Sound")then
        return nil
    end

    return tostring(sound.SoundId):match("%d+")
end

local function replaceSound(sound)
    if not sound:IsA("Sound")then
        return
    end

    local id=getSoundId(sound)

    if not id then
        return
    end

    local replacement=SoundIdMap[id]

    if not replacement then
        return
    end

    pcall(function()
        local wasPlaying=sound.Playing
        sound.SoundId=replacement

        if wasPlaying then
            sound.TimePosition=0
            sound:Play()
        end
    end)
end

for _,obj in ipairs(game:GetDescendants())do
    replaceSound(obj)
end

game.DescendantAdded:Connect(function(obj)
    task.wait(.05)
    replaceSound(obj)
end)

print("DAFZZ texture + sky + sound replacement loaded.")
