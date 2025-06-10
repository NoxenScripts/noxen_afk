fx_version 'cerulean'
game 'gta5'

author 'NOXEN AFk SYSTEM'
description 'AFK System with Pnj and rewards'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'client/functions.lua',
    'client/main.lua'
}

server_scripts {
    'server/*.lua',
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/img/*.webp'
} 