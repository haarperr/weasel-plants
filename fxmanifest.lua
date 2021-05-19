description "Weasel Plant System"

shared_scripts {
    'config.lua',
}
client_scripts {
    'client/*.lua',
}
server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server/*.lua',
}

fx_version 'adamant'
game 'gta5'