fx_version 'cerulean'
game 'gta5'

description 'QB-CivilianBilling'
version '1.2.0'

ui_page 'scr/dist/index.html'

shared_scripts {
    'config.lua',
    '@qb-core/shared/locale.lua',
}

client_scripts {
    'client/main.lua',
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

files {
    'scr/dist/*',
    'scr/dist/assets/*',
}

lua54 'yes'
