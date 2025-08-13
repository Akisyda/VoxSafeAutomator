# VoxSafeAutomator
Safe automator script for Vox Seas (for testing and learning)
-- =======================
-- Vox Seas Safe Automator v2
-- =======================

local player = game.Players.LocalPlayer

           -- Автофарм уровня с заданиями
function autoFarmLevel()
    while true do
        local quest = getQuestForLevel(player.Level)
        if quest and not quest.IsActive then
            acceptQuest(quest)
        end
        
  local target = findClosestEnemy()
        if target then
            attack(target)
            if quest and target:IsPartOfQuest(quest) then
                updateQuestProgress(quest, target)
            end
        end

  if player.Level >= quest.BossLevelRequirement then
            local boss = findBoss()
            if boss then
                attack(boss)
                if quest then
                    updateQuestProgress(quest, boss)
                end
            end
        end

  if quest and quest.IsCompleted then
            completeQuest(quest)
        end

  wait(1)
    end
end

         -- Морские события с автопокупкой лодки
function autoSeaEvents()
    while true do
        -- Проверка лодки
        if not player.CurrentBoat or player.CurrentBoat:IsDestroyed() then
            local shop = findBoatShop()
            local bestBoat = shop:GetMostExpensiveBoat(player.Coins)
            if bestBoat then
                buy(bestBoat)
                player.CurrentBoat = bestBoat
                sitInBoat(bestBoat)
                goToLocation("SeaEventSpawnArea")
            end
        end

    -- Проверка событий на море
   local seaEvent = detectSeaEvent()
        if seaEvent then
            local enemy = seaEvent:GetEnemy()
            if enemy then
                attack(enemy)
                while enemy and enemy.Health > 0 do
                    wait(0.1)
                end
                                                                                       
   if player.CurrentBoat and not player.CurrentBoat:IsDestroyed() then
                    returnToBoat(player.CurrentBoat)
                end
            end
        end

   wait(1)
    end
end

           -- Автоподбор предметов
game.Workspace.ItemSpawn.OnChildAdded:Connect(function(item)
    if item:IsA("Tool") or item:IsA("Part") then
        pickUpItem(item)
        moveToInventory(item)
    end
end)

          -- Автопокупка фруктов
function autoBuyFruits()
    local shop = findFruitShop()
    for _, fruit in pairs(shop:GetFruits()) do
        if player.Coins >= fruit.Price then
            buy(fruit)
        end
    end
end

          -- Запуск всех функций
spawn(autoFarmLevel)
spawn(autoSeaEvents)
spawn(autoBuyFruits)
