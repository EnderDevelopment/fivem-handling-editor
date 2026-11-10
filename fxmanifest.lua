fx_version 'cerulean'
game 'gta5'
lua54 'yes'

name 'handling_editor'
author 'EnderDevelopment'
description 'In-game vehicle handling editor with persistent server-wide settings'
version '1.0.0'

ui_page 'web/index.html'

files {
    'web/index.html',
    'web/style.css',
    'web/app.js'
}

shared_script 'shared/config.lua'
client_script 'client/main.lua'
server_script 'server/main.lua'
