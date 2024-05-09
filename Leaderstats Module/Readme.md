# Introduction
This module helps making leaderstats with datastore
# Features
* You just need a table for making leaderstats
* Saves and loads player data from datastore
* Suport for different data types
# Setting up
1.-Create a new DataStore in Roblox using the DataStoreService.

2.-Copy the contents of this module to a new Module script in your Roblox game.
# Code Sample
```lua
--//Module
local Leaderstats = require(game:GetService("ReplicatedStorage").Leaderstats)
--//Stats
local StatsTable = {
	
	Cash = 0;
	
	Experience = 0;
	
}
--//Variables

local PlayerData

--//Function
game.Players.PlayerAdded:Connect(function(Player)
	
	PlayerData = Leaderstats.new(Player, StatsTable)
	
	PlayerData:Get()
	
end)

game.Players.PlayerRemoving:Connect(function(Player)
	
	PlayerData:Save()
	
end)

```
# Troubleshooting
If you encounter any issues, make sure that the DataStore name is correct and that the Game has the necessary permissions to access the DataStore.

# License
Published under the MIT License
