Config = {}

-- To enable discord logs go to line 2 of the server.lua and paste your discord webhook between the quotes.
Config.admin_groups = {"admin","superadmin"} -- groups that can use admin commands
Config.banformat = "BANEADO\nRazon: %s\nExpiracion: %s\nBaneado por: %s (Ban ID: #%s)" -- message shown when banned (1st %s = reason, 2nd %s = expire, 3rd %s = banner, 4th %s = ban id)
Config.warning_screentime = 7.5 -- warning display length (in seconds)
Config.backup_kick_method = false -- set this to true if banned players don't get kicked when banned or they can re-connect after being banned.
Config.kick_without_steam = true -- prevent a player from joining your server without a steam identifier.
Config.page_element_limit = 250
