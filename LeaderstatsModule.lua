--Created by Jerxmiasz
--9/5/24

--//Services
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")
local StatsDataStore = DataStoreService:GetDataStore("Estadisticas")
--//Class
local PlayerStats = {}
PlayerStats.__index = PlayerStats

function PlayerStats.new(Player : Player, DataTable : {any})

	local self = setmetatable({}, PlayerStats)

	self.Player = Player
	self.DataTable = DataTable

	local Stat

	local ls

	if not Player:FindFirstChild("leaderstats") then

		ls = Instance.new("Folder")
		ls.Name = "leaderstats"
		ls.Parent = Player

	end

	self.ls = ls

	for index, value in pairs(DataTable) do

		if typeof(value) == "number" then

			Stat = Instance.new("IntValue", ls); Stat.Name = index
		end

		if typeof(value) == "string" then

			Stat = Instance.new("StringValue", ls); Stat.Name = index

		end
		if typeof(value) == "boolean" then

			Stat = Instance.new("BoolValue", ls); Stat.Name = index

		end

	end


	function self:Save()

		local LsChildren = self.ls:GetChildren()
		local SavingData = {}

		for _, StatValue in pairs(LsChildren) do

			SavingData[StatValue.Name] = StatValue.Value

		end

		local EncodedData = HttpService:JSONEncode(SavingData)

		local success, err = pcall(function()

			return StatsDataStore:SetAsync("Stats:"..self.Player.UserId, EncodedData)

		end)
		print(EncodedData)
		if not success then warn("Error saving stats; Error message:"..err) return end

	end
	function self:Get()

		local Data

		local Success, err = pcall(function()

			Data = StatsDataStore:GetAsync("Stats:"..self.Player.UserId)

		end)

		if not Success then

			warn("error retrieving data"..err)

			return PlayerStats.new(self.Player, self.DataTable)

		end

		if Data == nil then

			warn("error retrieving data"..err)

			return PlayerStats.new(self.Player, self.DataTable)

		end

		local DecodedData = HttpService:JSONDecode(Data)

		for index, value in pairs(DecodedData) do

			if self.ls:FindFirstChild(index) then

				self.ls[index].Value = value
			end

			print(index)
		end
	end

	return self

end
return PlayerStats
