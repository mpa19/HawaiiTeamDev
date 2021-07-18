fx_version 'bodacious'
games { 'gta5' }

author 'Hawaii Team'
description 'HT_dla'
version '1.0.0'

client_scripts {
	'@es_extended/locale.lua',
	'locales/es.lua',
	'config.lua',
    'client/HT_dla_cl.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/es.lua',
	'config.lua',
    'server/HT_dla_sv.lua'
}
