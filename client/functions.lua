-- ============================================
-- NOXEN AFK - CLIENT FUNCTIONS
-- ============================================
-- This file contains functions that you must customize according to your server
-- Replace the print() statements with your own logic

-- ============================================
-- POSITION SAVING FUNCTION
-- ============================================
-- IMPORTANT: This prevents players from spawning in the AFK zone after disconnect/reconnect
-- When disabled: saves original position before AFK teleportation
-- When enabled: restores original position when leaving AFK
-- The script works perfectly without customization, but you can add your own position saving logic

function EnablePositionSaving(enable)
    if enable then
        -- HERE: Implement your logic to ENABLE position saving (when leaving AFK)
        -- This ensures players return to their original position, not the AFK zone
        print("[NOXEN AFK] FUNCTION TO CUSTOMIZE: Enabling position saving")
        print("[NOXEN AFK] INFO: This prevents spawning in AFK zone after disconnect/reconnect")
        print("[NOXEN AFK] TODO: Implement your logic here to restore original position")
        
        -- Example of what you could do:
        -- TriggerEvent('your_script:restorePosition')
        -- or
        -- exports['your_script']:enablePositionSaving(true)
        
    else
        -- HERE: Implement your logic to DISABLE position saving (when entering AFK)
        -- This saves the original position before teleporting to AFK zone
        print("[NOXEN AFK] FUNCTION TO CUSTOMIZE: Disabling position saving")
        print("[NOXEN AFK] INFO: Saving original position before AFK teleportation")
        print("[NOXEN AFK] TODO: Implement your logic here to save current position")
        
        -- Example of what you could do:
        -- local coords = GetEntityCoords(PlayerPedId())
        -- TriggerEvent('your_script:savePosition', coords)
        -- or
        -- exports['your_script']:enablePositionSaving(false)
    end
end

-- ============================================
-- STATUS PAUSE FUNCTION
-- ============================================
-- IMPORTANT: This maintains hunger/thirst levels during AFK to prevent death
-- When paused: keeps hunger/thirst at the same level as when entering AFK
-- Alternative: set hunger/thirst to 100% or any level you want
-- Prevents players from dying while AFK due to hunger/thirst

function PauseAllStatus(pause)
    if pause then
        -- HERE: Implement your logic to PAUSE all status (when entering AFK)
        -- This keeps hunger/thirst at current levels to prevent death during AFK
        print("[NOXEN AFK] FUNCTION TO CUSTOMIZE: Pausing all status")
        print("[NOXEN AFK] INFO: Maintains hunger/thirst levels during AFK")
        print("[NOXEN AFK] TODO: Pause needs or set them to 100% as desired")
        
        -- Examples of what you could do:
        -- Option 1: Pause status at current levels (RECOMMENDED)
        -- TriggerEvent("esx_status:pauseAllStatus", true)
        -- 
        -- Option 2: Set to 100% with loop to maintain levels
        -- TriggerEvent("esx_status:set", "hunger", 1000000)
        -- TriggerEvent("esx_status:set", "thirst", 1000000)
        -- -- You'll need a loop every 5 minutes to maintain 100%:
        -- -- Citizen.CreateThread(function()
        -- --     while isInAfk do
        -- --         TriggerEvent("esx_status:set", "hunger", 1000000)
        -- --         TriggerEvent("esx_status:set", "thirst", 1000000)
        -- --         Wait(5 * 60 * 1000) -- 5 minutes
        -- --     end
        -- -- end)
        -- 
        -- Option 3: Use your custom system
        -- exports['your_script']:pausePlayerNeeds(true)
        
    else
        -- HERE: Implement your logic to RESUME all status (when leaving AFK)
        -- This resumes normal hunger/thirst decrease after leaving AFK
        print("[NOXEN AFK] FUNCTION TO CUSTOMIZE: Resuming all status")
        print("[NOXEN AFK] INFO: Resuming normal hunger/thirst decrease")
        print("[NOXEN AFK] TODO: Resume normal needs system")
        
        -- Examples of what you could do:
        -- Option 1: Resume normal status decrease (if you used pause)
        -- TriggerEvent("esx_status:pauseAllStatus", false)
        -- 
        -- Option 2: Stop the loop and restore to normal levels (if you used 100% method)
        -- -- Stop the loop by setting isInAfk = false (already done by script)
        -- TriggerEvent("esx_status:set", "hunger", 500000)
        -- TriggerEvent("esx_status:set", "thirst", 500000)
        -- 
        -- Option 3: Use your custom system
        -- exports['your_script']:pausePlayerNeeds(false)
    end
end

-- ============================================
-- EXPORTS FOR OTHER SCRIPTS
-- ============================================

exports('EnablePositionSaving', EnablePositionSaving)
exports('PauseAllStatus', PauseAllStatus) 