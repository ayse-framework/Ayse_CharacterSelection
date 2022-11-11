author "helmimarif"
description "AyseFramework Character Selection"
version "1.0"

fx_version "cerulean"
game "gta5"
lua54 "yes"

files {
	"ui/index.html",
	"ui/script.js",
	"ui/style.css"
}
ui_page "ui/index.html"

shared_script "config.lua"
server_script "server.lua"
client_script "client.lua"

dependency "Ayse_Core"
