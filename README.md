# 🎮 NOXEN AFK SYSTEM

## 📋 Overview

**NOXEN AFK System** is a comprehensive FiveM script that allows players to enter AFK (Away From Keyboard) mode with an automatic reward system. The script provides an immersive experience with interactive NPCs, modern UI, and advanced security features.

**🔌 Plug & Play**: Compatible with ESX and QB-Core without additional modifications.

## ✨ Key Features

### 🎯 AFK System
- **Multiple Entry Points**: 6 strategically placed AFK points across the map with interactive NPCs
- **Secure AFK Zone**: Private teleportation zone with custom IPL interior
- **Teleportation Delay**: Configurable 1-minute delay before teleportation
- **Position Management**: Automatic position saving and restoration
- **Modern Interface**: Visual timer and animated reward notifications

### 🎁 Reward System
- **Automatic Rewards**: Configurable interval (default: 10 minutes)
- **Randomized Rewards**:
  - 💰 **Money**: $100-300 (85% chance)
  - 🪙 **Items**: water 1-2x (15% chance)
- **Anti-Cheat Protection**: Server-side validation with automatic kick system
- **Smart Validation**: Items are checked for existence before being given
- **Framework Notifications**: Uses native ESX/QBCore notification systems

### 🛡️ Security Features
- **Control Disabling**: Weapons and combat actions blocked during AFK
- **Death Monitoring**: Automatic AFK exit on player death
- **Anti-Spam Protection**: Configurable cooldown based on `Config.RewardInterval`
- **Automatic Cleanup**: Disconnected player data removal
- **Item Validation**: Prevents crashes by checking item existence before giving rewards
- **Framework Compatibility**: Enhanced ESX/QBCore player object handling

### 🔌 Framework Integration
- **ESX Legacy**: Full compatibility with ESX framework
- **QB-Core**: Full compatibility with QB-Core framework
- **PMA Voice**: Automatic voice mute during AFK
- **ESX Status**: Configurable needs management (hunger/thirst)
- **Web Interface**: Smooth fade transitions and visual feedback

## 📍 AFK Locations

| Location | Coordinates | Description |
|----------|-------------|-------------|
| **Route 68** | `vector3(1095.1377, 2633.0056, 38.0120)` | Highway rest stop |
| **Bennys** | `vector3(694.3072, 73.7141, 83.8567)` | Auto shop area |
| **Hospital** | `vector3(-1821.2596, -405.3518, 46.6492)` | Medical center |
| **Beach** | `vector3(-1253.8062, -1535.2080, 4.2962)` | Coastal area |
| **Paleto** | `vector3(136.5773, 6643.2241, 31.7411)` | Northern town |
| **Roxwood** | `vector3(-306.8768, 7073.5747, 12.1890)` | Rural area |

**VIP AFK Zone**: `vector3(-1266.0729, -3013.6370, -46.8537)` *(Private interior)*

## 🎛️ Commands

| Command | Description |
|---------|-------------|
| `/afk` | Create GPS waypoint to nearest AFK point |
| `/stopafk` | Force exit from AFK mode |

## ⚙️ Configuration

### Reward Settings
```lua
Config.Rewards = {
    {
        type = "money",
        min = 100,
        max = 300,
        chance = 85  -- 85% probability
    },
    {
        type = "item",
        items = {
            {name = "water", min = 1, max = 2, chance = 15}
        }
    }
}
```

### Timing Configuration
```lua
Config.RewardInterval = 10  -- Minutes between rewards
Config.TeleportDelay = 1    -- Minutes before teleportation
```

### Message Customization
```lua
Config.Messages = {
    starting_afk = "You will be teleported to AFK zone in 1 minute...",
    teleported = "You are now in AFK mode",
    reward_received = "You received %s",  -- Used by ESX/QB-Core notifications
    stopped_afk = "You are no longer in AFK mode",
    money_reward = "%d$ in cash"
    ...
}
```

### UI Position Configuration
```lua
Config.UI = {
    timer = {
        bottom = "18.75vw",  -- Timer position from bottom
        left = "0.73vw"      -- Timer position from left
    }
}
```

## 🔧 Installation

### Prerequisites
- **ESX Legacy** or **QB-Core** (Required - Choose one)
- **PMA Voice** (Optional - for voice mute feature)
- **ESX Status** (Optional - for needs management)

### Setup Steps

1. **Download & Extract**
   ```
   Place the 'noxen_afk' folder in your server's resources directory
   ```

2. **Server Configuration**
   ```cfg
   # Add to server.cfg
   ensure noxen_afk
   ```

3. **Customize Functions** *(See customization section below)*

4. **Restart Server**

## 📁 File Structure

```
noxen_afk/
├── 📁 client/
│   ├── 🔧 functions.lua    # Customizable client functions
│   └── 📄 main.lua         # Main client script
├── 📁 server/
│   └── 📄 main.lua         # Server logic & rewards
├── 📁 html/
│   ├── 🌐 index.html       # User interface
│   ├── 🎨 style.css        # Interface styling
│   ├── ⚡ script.js        # UI interactions
│   └── 📁 img/             # Interface assets
├── ⚙️ config.lua           # Main configuration
├── 📋 fxmanifest.lua       # FiveM manifest
└── 📖 README.md            # Documentation
```

## 🛠️ Customization Required

### ⚠️ Important: Before Use

**You MUST customize these functions in `client/functions.lua` according to your server setup:**

### 🔧 Position Saving Function

```lua
function EnablePositionSaving(enable)
    -- Purpose: Prevents players from spawning in AFK zone after disconnect/reconnect
    -- When disabled: Saves original position before AFK teleportation
    -- When enabled: Restores original position when leaving AFK
    
    if enable then
        -- CUSTOMIZE: Add your position restoration logic here
        print("[NOXEN AFK] TODO: Restore original position")
        -- Example: TriggerEvent('your_script:restorePosition')
    else
        -- CUSTOMIZE: Add your position saving logic here
        print("[NOXEN AFK] TODO: Save current position")
        -- Example: TriggerEvent('your_script:savePosition', coords)
    end
end
```

### 🔧 Status Management Function

```lua
function PauseAllStatus(pause)
    -- Purpose: Maintains hunger/thirst levels during AFK to prevent death
    -- Options: Pause at current levels, set to 100% with loop, or custom system
    
    if pause then
        -- CUSTOMIZE: Choose your preferred method
        print("[NOXEN AFK] TODO: Pause needs or set to 100%")
        
        -- Option 1 (RECOMMENDED): Pause at current levels
        -- TriggerEvent("esx_status:pauseAllStatus", true)
        
        -- Option 2: Set to 100% with maintenance loop
        -- TriggerEvent("esx_status:set", "hunger", 1000000)
        -- TriggerEvent("esx_status:set", "thirst", 1000000)
        -- + Create loop every 5 minutes to maintain levels
        
    else
        -- CUSTOMIZE: Resume normal status system
        print("[NOXEN AFK] TODO: Resume normal needs system")
        
        -- Option 1: Resume normal decrease
        -- TriggerEvent("esx_status:pauseAllStatus", false)
        
        -- Option 2: Stop loop + restore normal levels
        -- TriggerEvent("esx_status:set", "hunger", 500000)
    end
end
```

## 🎨 User Interface

### Interface Components
- **🔄 Circular Timer**: Visual countdown to next reward with persistent display
- **🎁 Framework Notifications**: Uses native ESX/QBCore notification systems
- **🌊 Smooth Transitions**: Fade in/out effects during teleportation
- **📱 Configurable Position**: Customizable timer position via config
- **🎯 Persistent Messages**: Timer messages remain visible throughout cycles

### UI Features
- Real-time reward countdown
- Configurable UI positioning
- Smooth fade transitions
- Framework-integrated notifications
- Modern visual design with persistent text display

## 🔒 Security System

### Anti-Cheat Measures
- **Server-Side Validation**: All rewards validated on server
- **Dynamic Cooldown Protection**: Configurable intervals based on `Config.RewardInterval`
- **Automatic Kicking**: Instant kick for exploitation attempts with detailed logging
- **Data Cleanup**: Automatic removal of disconnected player data

### Monitoring Features
- Player death detection with automatic AFK exit
- Connection status monitoring
- Reward timing validation
- Position verification

## 🐛 Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **NPCs not spawning** | Check model loading, restart script |
| **Rewards not working** | Verify ESX/QB-Core configuration, check server logs |
| **UI not visible** | Ensure HTML files present, restart client |
| **Position not saving** | Customize `EnablePositionSaving()` function |
| **Players dying in AFK** | Customize `PauseAllStatus()` function |

### Debug Information
- All logs prefixed with `[NOXEN AFK]`
- Check both client and server console
- Verify configuration syntax
- Test with single player first

## 📊 Performance

### Optimizations
- **Efficient Threading**: Minimal performance impact
- **Smart Cleanup**: Automatic data management
- **Optimized Loops**: Reduced server load
- **Memory Management**: Proper resource cleanup

### Resource Usage
- **Client**: ~0.0ms without use
- **Client**: ~0.1ms
- **Server**: ~0.005ms average

## 🔄 Updates & Maintenance

### Version Information
- **Current Version**: 1.1.0
- **Compatibility**: ESX Legacy & QB-Core
- **Recent Updates**: Enhanced stability, UI positioning, QBCore fixes

### Maintenance Tips
- Regular log monitoring
- Periodic configuration review
- Player feedback integration
- Performance monitoring

## 📞 Support

### Getting Help
1. **Check Documentation**: Review this README thoroughly
2. **Check Logs**: Examine server/client console output
3. **Verify Configuration**: Ensure proper setup
4. **Test Functions**: Verify custom function implementation

### Support Channels
- **Discord**: [Join Noxen Community](https://discord.com/invite/a9d5k3GUen)
- Check server logs for error messages
- Verify ESX/QB-Core framework compatibility

## 📄 License

This script is provided as-is under standard usage terms. You are free to modify and adapt it according to your server's needs.

---

## 🔄 Recent Updates (v1.1.0)

### 🛠️ Bug Fixes
- **Fixed QBCore Compatibility**: Resolved `xPlayer.source` being `nil` in QBCore
- **Enhanced Timer System**: Replaced `os.time()` with `GetGameTimer()` for better reliability
- **JavaScript Error Resolution**: Fixed DOM element selection issues
- **Persistent UI Messages**: Timer text no longer disappears after cycles
- **Item Validation**: Added checks to prevent crashes from invalid items

### ✨ New Features
- **Configurable UI Position**: Timer position can now be set via `Config.UI`
- **Dynamic Cooldown System**: Anti-spam protection now uses `Config.RewardInterval`
- **Enhanced Debug System**: Better logging and error reporting
- **Framework Notifications**: Integrated with native ESX/QBCore notification systems

### 🔧 Improvements
- **Better Error Handling**: More robust error checking throughout the script
- **Performance Optimization**: Reduced resource usage and improved efficiency
- **Code Cleanup**: Removed redundant notification systems
- **Enhanced Security**: Better validation and anti-cheat measures

---

**🚀 Developed by HARPIK**  
*Version 1.1.0 - Professional AFK Management Solution* 