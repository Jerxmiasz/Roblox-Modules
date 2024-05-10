--//Services
local DatastoreService = game:GetService("DatastoreService")
local HttpService = game:GetService("HttpService")

--//Creation of DataClass
local PlayerData = {}
PlayerData.__index = PlayerData

function PlayerData.new(DataName : string)
  
  local self = setmetatable({}, PlayerData)
  
  self.dataBase = DatastoreService:GetDataStore(DataName)
  
  function self:SetKey(Player : Player, Key:string)
    self.key = Key..Player.UserId
  end
  
  function self:SetData(Data : {any})
    self.Data = Data
  end
  
  function self:Apply()
    --Error Handling
    if not self.Data then warn("No data set up")
      return 
    end
    if not self.key then warn("No key set up")
      return
    end
    --Getting Data
    local success, err = pcall(function()
      self.RecievedData = self.dataBase:GetAsync(self.key)
    end)
    --Data Decoding
    self.DecodedData = HttpService:JSONDecode(self.RecievedData)
    --Error Handling
    if not success then warn ("Couldnt Get Data:"..err) return 
    end
    if not self.RecievedData then return end
    
    for key, value in pairs(self.RecievedData) do
      self.Data[key] = value
    end
  end
  --Save
  function self:Save()
    --Error Handling
    if not self.key then warn("No key set up")  return 
    end
    if not self.Data then warn("No Data Set up")
      return
    end
    --Data Encoding
    self.EncodedData = HttpService:JSONEncode(self.Data)
    --Data Calling
    local success, err = pcall(function()
      return self.dataBase:SetAsync(self.key, self.EncodedData)
    end)
    --Error handling
    if not success then warn("Error while Saving data"..err) return
    end
  end
  return self
end
