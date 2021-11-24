local CrystalExtractor = Action()

function CrystalExtractor.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if item:getId() == US_CONFIG.CRYSTAL_EXTRACTOR and target:getId() == US_CONFIG.CRYSTAL_FOSSIL then
        local amount = target:getCount()
        for i = 1, amount do
            if math.random(US_CONFIG.CRYSTAL_BREAK_CHANCE) == 1 then
                player:sendTextMessage(MESSAGE_STATUS_WARNING, "Crystal inside broke!")
            else
                local rand = math.random(100)
                local crystals = 1
                if rand <= 20 then
                    crystals = 3
                elseif rand <= 50 then
                    crystals = 2
                end
                for i = 1, crystals do
                    local crystal = math.random(1, #US_CONFIG[1])
                    player:addItem(US_CONFIG[1][crystal])
                end
            end
        end
        target:remove(amount)
    end
    return true
end

CrystalExtractor:id(US_CONFIG.CRYSTAL_EXTRACTOR)
CrystalExtractor:register()
