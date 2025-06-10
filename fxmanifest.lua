server_script '@ElectronAC/src/include/server.lua'
client_script '@ElectronAC/src/include/client.lua'
client_script "@EasyCore/client/watchdog/external_modules.lua"
server_script "@EasyCore/server/watchdog/external_modules.lua"

server_script "@watchers/server/_rewriter.lua"
fx_version 'cerulean'
game 'gta5'

author 'RSD AFk SYSTEM'
description 'Système AFK avec PNJ et récompenses'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client/functions.lua',
    'client/*.lua'
}

server_scripts {
    'server/*.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/*.webp'
} 