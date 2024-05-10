--//Services
local DataStoreService = game:GetService("DataStoreService")
local DataClass = {}
DataClass.__index = DataClass
--Class Creation
function DataClass.new(Name : string)
  local self = setmetatable({}, DataClass)
  
  self.DataBase = DataStoreService:GetDataStore(Name)
  
  function self:SetKey(Key_ : string)
    self.Key = Key_
  end
  
  function self:SetDefaultData(data : {any})
    self.DefaultData = data
  end

  function self:Save()
    --Missing Data catching
    if not self.Key then warn("No key set up") return end
    if not self.DefaultData then warn("No Data set up") return end
    
    local Success, err = pcall(function()
      return self.DataBase:SetAsync(self.Key, self.DefaultData)
    end)
    
    if not Success then
      warn("Error saving data: "..err)
      return
    end
  end
function self:GetAndApply()
  if not self.Key then
    warn("No key set up")
    return
  end
  
  if not self.DefaultData then
    warn("No defaultData")
    return
  end
  
  local success, err = pcall(function()
    self.RecievedData = self.DataBase:GetAsync(self.Key)
  end)
  
  if not success then
    warn("Error loading data: "..err)
    return
  end
  
  if self.RecievedData == nil then
    for index, value in pairs(self.DefaultData) do
      self.DefaultData[index] = value
    end
  else
    for index, value in pairs(self.RecievedData) do
      self.DefaultData[index] = value
    end
  end
  return self
end