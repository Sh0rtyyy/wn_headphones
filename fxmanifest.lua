fx_version 'cerulean'
game 'gta5'

author 'mrshortyno'
description 'Mute player with headphones script for ESX and QB-Core'
version '1.0.0'
lua54 'yes'

client_scripts {
    'client/*.lua',
}

server_scripts {
    'server/*.lua',
}

shared_scripts {
	'@ox_lib/init.lua',
	'config.lua',
}