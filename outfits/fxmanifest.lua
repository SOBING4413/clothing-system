fx_version "cerulean"

games { "gta5" }

description "Sobing4413 Outfit System 4.0"

version "0.1.0"

ui_page 'nui/dist/index.html'

files {
    "nui/dist/**/*",
}

server_scripts { "build/sv_*.js" }
client_scripts { "build/cl_*.js" }

lua54 'yes'