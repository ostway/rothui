
  --get the addon namespace
  local addon, ns = ...

  --object container
  local lib = CreateFrame("Frame")
  ns.lib = lib

  local cfg = ns.cfg

  ---------------------------------------------
  -- variables
  ---------------------------------------------

  local rad = rad
  local sqrt = sqrt
  local floor = floor
  local tinsert = tinsert

  --    ring segment layout
  --     ____ ____
  --    /    |    \
  --    |  4 | 1  |
  --     ----+----
  --    |  3 | 2  |
  --    \____|____/
  --


  local ringSegmentSettings = {
    { defaultRotation = 0,    primeNum = 2,   point = "TOPRIGHT",     }, --segment 1
    { defaultRotation = 270,  primeNum = 3,   point = "BOTTOMRIGHT",  }, --segment 2
    { defaultRotation = 180,  primeNum = 5,   point = "BOTTOMLEFT",   }, --segment 3
    { defaultRotation = 90,   primeNum = 7,   point = "TOPLEFT",      }, --segment 4
  }

  ---------------------------------------------
  -- lib functions
  ---------------------------------------------

  --castbar OnValueChanged
  function lib:CastbarOnValueChanged(bar,...)
    local self = bar:GetParent()
    local numSeg = self.template.castring.numSegmentsUsed
    local direction = self.template.castring.fillDirection
    local bmin, bmax = bar:GetMinMaxValues()
    local bcur = bar:GetValue()
    local perc = 0
    if bmax > 0 then
      perc = floor(bcur/bmax*100)
    end
    local percPerSeg = 100/numSeg
    if perc == 0 or UnitIsDeadOrGhost(self.unit) then
      for i=1, numSeg do
        --self.castring[i].castringBg:Show()
        self.castring[i].castringFill:Hide()
        self.castring[i].castringSpark:Hide()
      end
    elseif perc == 100 then
      for i=1, numSeg do
        --self.castring[i].castringBg:Show()
        self.castring[i].castringFill:Show()
        self.castring[i].castringFill:SetRotation(rad(self.castring[i].defaultRotation))
        self.castring[i].castringSpark:Hide()
      end
    else
      for i=1, numSeg do
        if(perc >= (i*percPerSeg)) then
          --self.castring[i].castringBg:Show()
          self.castring[i].castringFill:Show()
          self.castring[i].castringFill:SetRotation(rad(self.castring[i].defaultRotation))
          self.castring[i].castringSpark:Hide()
        elseif ((perc > ((i-1)*percPerSeg)) and (perc < (i*percPerSeg))) then
          local value = floor(((perc-((i-1)*percPerSeg))/percPerSeg)*100)
          local angle = 0
          if direction == 1 then
            angle = self.castring[i].defaultRotation + 90 - (value*90/100)
          else
            angle = (value*90/100) + self.castring[i].defaultRotation - 90
          end
          local arad = rad(angle)
          --self.castring[i].castringBg:Show()
          self.castring[i].castringFill:Show()
          self.castring[i].castringFill:SetRotation(arad)
          self.castring[i].castringSpark:Show()
          self.castring[i].castringSpark:SetRotation(arad)
        else
          --self.castring[i].castringBg:Show()
          self.castring[i].castringFill:Hide()
          self.castring[i].castringSpark:Hide()
        end--if
      end --for
    end--if
  end--func

  --castbar OnShow
  function lib:CastbarOnShow(bar,...)
    local self = bar:GetParent()
    ---print(self.styleUnit.. " "..self.unit.." Castbar OnShow")
    ---print(bar:GetMinMaxValues())
    ---print(...)
    for i=1, self.template.castring.numSegmentsUsed do
      self.castring[i].castringBg:Show()
      --self.castring[i].castringFill:Hide()
      --self.castring[i].castringSpark:Hide()
    end
  end

  --castbar OnHide
  function lib:CastbarOnHide(bar, ...)
    local self = bar:GetParent()
    --print(self.styleUnit.. " "..self.unit.." Castbar OnHide")
    --print(...)
    for i=1, self.template.castring.numSegmentsUsed do
      self.castring[i].castringBg:Hide()
      self.castring[i].castringFill:Hide()
      self.castring[i].castringSpark:Hide()
    end
  end

  --powerbar OnValueChanged
  function lib:PowerbarOnValueChanged(bar, ...)
    local self = bar:GetParent()
    local numSeg = self.template.powerring.numSegmentsUsed
    local direction = self.template.powerring.fillDirection
    local bmin, bmax = bar:GetMinMaxValues()
    local bcur = bar:GetValue()
    local perc = 0
    if bmax > 0 then
      perc = floor(bcur/bmax*100)
    end
    local percPerSeg = 100/numSeg
    if bmax == 0 and self.template.powerring.hideWhenMaxIsZero then
      if bar:IsShown() then bar:Hide() end
      return
    elseif not bar:IsShown() then
      bar:Show()
    end
    if perc == 0 or UnitIsDeadOrGhost(self.unit) then
      for i=1, numSeg do
        self.powerring[i].powerringBg:Show()
        self.powerring[i].powerringFill:Hide()
        self.powerring[i].powerringSpark:Hide()
      end
    elseif perc == 100 then
      for i=1, numSeg do
        self.powerring[i].powerringBg:Show()
        self.powerring[i].powerringFill:Show()
        self.powerring[i].powerringFill:SetRotation(rad(self.powerring[i].defaultRotation))
        self.powerring[i].powerringSpark:Hide()
      end
    else
      for i=1, numSeg do
        if(perc >= (i*percPerSeg)) then
          self.powerring[i].powerringBg:Show()
          self.powerring[i].powerringFill:Show()
          self.powerring[i].powerringFill:SetRotation(rad(self.powerring[i].defaultRotation))
          self.powerring[i].powerringSpark:Hide()
        elseif ((perc > ((i-1)*percPerSeg)) and (perc < (i*percPerSeg))) then
          local value = floor(((perc-((i-1)*percPerSeg))/percPerSeg)*100)
          local angle = 0
          if direction == 1 then
            angle = self.powerring[i].defaultRotation + 90 - (value*90/100)
          else
            angle = (value*90/100) + self.powerring[i].defaultRotation - 90
          end
          local arad = rad(angle)
          self.powerring[i].powerringBg:Show()
          self.powerring[i].powerringFill:Show()
          self.powerring[i].powerringFill:SetRotation(arad)
          self.powerring[i].powerringSpark:Show()
          self.powerring[i].powerringSpark:SetRotation(arad)
        else
          self.powerring[i].powerringBg:Show()
          self.powerring[i].powerringFill:Hide()
          self.powerring[i].powerringSpark:Hide()
        end--if
      end --for
    end--if
  end

  --powerbar OnShow
  function lib:PowerbarOnShow(bar,...)
    local self = bar:GetParent()
    ---print(self.styleUnit.. " "..self.unit.." Powerbar OnShow")
    ---print(bar:GetMinMaxValues())
    ---print(...)
    for i=1, self.template.powerring.numSegmentsUsed do
      self.powerring[i].powerringBg:Show()
      --self.powerring[i].powerringFill:Hide()
      --self.powerring[i].powerringSpark:Hide()
    end
  end

  --powerbar OnHide
  function lib:PowerbarOnHide(bar, ...)
    local self = bar:GetParent()
    --print(self.styleUnit.. " "..self.unit.." Powerbar OnHide")
    --print(...)
    for i=1, self.template.powerring.numSegmentsUsed do
      self.powerring[i].powerringBg:Hide()
      self.powerring[i].powerringFill:Hide()
      self.powerring[i].powerringSpark:Hide()
    end
  end

  --healthbar OnValueChanged
  function lib:HealthbarOnValueChanged(bar, ...)
    local self = bar:GetParent()
    local numSeg = self.template.healthring.numSegmentsUsed
    local direction = self.template.healthring.fillDirection
    local bmin, bmax = bar:GetMinMaxValues()
    local bcur = bar:GetValue()
    local perc = 0
    if bmax > 0 then
      perc = floor(bcur/bmax*100)
    end
    local percPerSeg = 100/numSeg
    if perc == 0 or UnitIsDeadOrGhost(self.unit) then
      for i=1, numSeg do
        self.healthring[i].healthringBg:Show()
        self.healthring[i].healthringFill:Hide()
        self.healthring[i].healthringSpark:Hide()
      end
    elseif perc == 100 then
      for i=1, numSeg do
        self.healthring[i].healthringBg:Show()
        self.healthring[i].healthringFill:Show()
        self.healthring[i].healthringFill:SetRotation(rad(self.healthring[i].defaultRotation))
        self.healthring[i].healthringSpark:Hide()
      end
    else
      for i=1, numSeg do
        if(perc >= (i*percPerSeg)) then
          self.healthring[i].healthringBg:Show()
          self.healthring[i].healthringFill:Show()
          self.healthring[i].healthringFill:SetRotation(rad(self.healthring[i].defaultRotation))
          self.healthring[i].healthringSpark:Hide()
        elseif ((perc > ((i-1)*percPerSeg)) and (perc < (i*percPerSeg))) then
          local value = floor(((perc-((i-1)*percPerSeg))/percPerSeg)*100)
          local angle = 0
          if direction == 1 then
            angle = self.healthring[i].defaultRotation + 90 - (value*90/100)
          else
            angle = (value*90/100) + self.healthring[i].defaultRotation - 90
          end
          local arad = rad(angle)
          self.healthring[i].healthringBg:Show()
          self.healthring[i].healthringFill:Show()
          self.healthring[i].healthringFill:SetRotation(arad)
          self.healthring[i].healthringSpark:Show()
          self.healthring[i].healthringSpark:SetRotation(arad)
        else
          self.healthring[i].healthringBg:Show()
          self.healthring[i].healthringFill:Hide()
          self.healthring[i].healthringSpark:Hide()
        end--if
      end --for
    end--if
  end

  --Healthbar OnShow
  function lib:HealthbarOnShow(bar,...)
    local self = bar:GetParent()
    ---print(self.styleUnit.. " "..self.unit.." Healthbar OnShow")
    ---print(bar:GetMinMaxValues())
    ---print(...)
    for i=1, self.template.healthring.numSegmentsUsed do
      self.healthring[i].healthringBg:Show()
      --self.healthring[i].healthringFill:Hide()
      --self.healthring[i].healthringSpark:Hide()
    end
    if self.styleUnit == "target" then
      PlaySound("igcreatureaggroselect")
    end
  end

  --Healthbar OnHide
  function lib:HealthbarOnHide(bar, ...)
    local self = bar:GetParent()
    --print(self.styleUnit.. " "..self.unit.." Healthbar OnHide")
    --print(...)
    for i=1, self.template.healthring.numSegmentsUsed do
      self.healthring[i].healthringBg:Hide()
      self.healthring[i].healthringFill:Hide()
      self.healthring[i].healthringSpark:Hide()
    end
    if self.styleUnit == "target" then
      PlaySound("interfacesound_losttargetunit")
    end
  end

  --calculate the segment id based on direction, index and starting point
  function lib:GetSegmentId(start,direction,i)
    i = i - 1
    if direction == 0 then
      if start-i < 1 then
        return start-i+4
      else
        return start-i
      end
    else
      if start+i > 4 then
        return start+i-4
      else
        return start+i
      end
    end
  end

  --function to create ring textures on the scrollchild
  function lib:CreateRingTexture(self,parent,type,textureLevel,texture,radius,color,rotation)
    local tex = parent:CreateTexture(nil,"BACKGROUND",nil,textureLevel)
    tex:SetTexture(texture)
    tex:SetSize(sqrt(2)*256*radius,sqrt(2)*256*radius)
    tex:SetPoint("CENTER",self,"CENTER",0,0)
    tex:SetVertexColor(color.r,color.g,color.b)
    if type == "bg" then
      tex:SetAlpha(color.a or 1)
      --tex:SetBlendMode("ADD")
    elseif type == "spark" or type == "latency" then
      tex:SetAlpha(color.a or 1)
      tex:SetBlendMode("ADD")
    end
    tex:SetRotation(rad(rotation))
    return tex
  end

  --create the scrollframe and all elements for a ring segment
  function lib:CreateRingSegment(self, parent, i)

    local template = self.template

    --each ring segment consists of 2 frames and 9 textures
    --one scrollframe
    --one scrollchild (any data overflowing the scrollChild will be cropped)
    --3 rings (cast, power, health) consisting of 3 textures each (background, filling and spark)

    --scrollframe
    local scrollFrame = CreateFrame("ScrollFrame", "$parentScrollFrame", parent)
    scrollFrame:SetSize(128,128)
    scrollFrame:SetPoint(ringSegmentSettings[i].point,self)
    scrollFrame.defaultRotation = ringSegmentSettings[i].defaultRotation
    scrollFrame.primeNum = ringSegmentSettings[i].primeNum
    scrollFrame.segmentId = i

    --scrollchild
    local scrollChild = CreateFrame("Frame", "$parentScrollChild", scrollFrame)
    scrollChild:SetSize(128,128)
    --scrollChild:SetBackdrop(cfg.backdrop)
    scrollFrame:SetScrollChild(scrollChild)
    scrollFrame.scrollChild = scrollChild

    --CASTRING
    if template.castring.enable then
      --background
      local castringBg = lib:CreateRingTexture(self, scrollChild, "bg", template.castring.sublevel.bg, template.castring.textures.bg, template.castring.radius, template.castring.colors.bg, scrollFrame.defaultRotation)
      --filling
      local castringFill = lib:CreateRingTexture(self, scrollChild, "fill", template.castring.sublevel.fill, template.castring.textures.fill, template.castring.radius, template.castring.colors.fill, scrollFrame.defaultRotation)
      --spark
      local castringSpark = lib:CreateRingTexture(self, scrollChild, "spark", template.castring.sublevel.spark, template.castring.textures.spark, template.castring.radius, template.castring.colors.spark, scrollFrame.defaultRotation)
      --latency
      if self.styleUnit == "player" then
        --create latency
        local castringLatency = lib:CreateRingTexture(self, scrollChild, "latency", template.castring.sublevel.latency, template.castring.textures.latency, template.castring.radius, template.castring.colors.latency, scrollFrame.defaultRotation)
        scrollFrame.castringLatency = castringLatency
        scrollFrame.castringLatency:Hide()
      end
      scrollFrame.castringBg       = castringBg
      scrollFrame.castringFill     = castringFill
      scrollFrame.castringSpark    = castringSpark
      scrollFrame.castringBg:Hide()
      scrollFrame.castringFill:Hide()
      scrollFrame.castringSpark:Hide()
    end

    --POWERRING
    if template.powerring.enable then
      --background
      local powerringBg = lib:CreateRingTexture(self, scrollChild, "bg", template.powerring.sublevel.bg, template.powerring.textures.bg, template.powerring.radius, template.powerring.colors.bg, scrollFrame.defaultRotation)
      --filling
      local powerringFill = lib:CreateRingTexture(self, scrollChild, "fill", template.powerring.sublevel.fill, template.powerring.textures.fill, template.powerring.radius, template.powerring.colors.fill, scrollFrame.defaultRotation)
      --spark
      local powerringSpark = lib:CreateRingTexture(self, scrollChild, "spark", template.powerring.sublevel.spark, template.powerring.textures.spark, template.powerring.radius, template.powerring.colors.spark, scrollFrame.defaultRotation)
      scrollFrame.powerringBg      = powerringBg
      scrollFrame.powerringFill    = powerringFill
      scrollFrame.powerringSpark   = powerringSpark
      scrollFrame.powerringBg:Hide()
      scrollFrame.powerringFill:Hide()
      scrollFrame.powerringSpark:Hide()
    end

    --HEALTHRING
    if template.healthring.enable then
      --healthring background
      local healthringBg = lib:CreateRingTexture(self, scrollChild, "bg", template.healthring.sublevel.bg, template.healthring.textures.bg, template.healthring.radius, template.healthring.colors.bg, scrollFrame.defaultRotation)
      --healthring filling
      local healthringFill = lib:CreateRingTexture(self, scrollChild, "fill", template.healthring.sublevel.fill, template.healthring.textures.fill, template.healthring.radius, template.healthring.colors.fill, scrollFrame.defaultRotation)
      --healthring spark
      local healthringSpark = lib:CreateRingTexture(self, scrollChild, "spark", template.healthring.sublevel.spark, template.healthring.textures.spark, template.healthring.radius, template.healthring.colors.spark, scrollFrame.defaultRotation)
      scrollFrame.healthringBg     = healthringBg
      scrollFrame.healthringFill   = healthringFill
      scrollFrame.healthringSpark  = healthringSpark
      scrollFrame.healthringBg:Hide()
      scrollFrame.healthringFill:Hide()
      scrollFrame.healthringSpark:Hide()
    end

    return scrollFrame

  end

  --create all the frames and make sure they stack correctly
  function lib:CreateFrameStack(self)

    local template = self.template

    --create the framestack
    local back = CreateFrame("Frame", "$parentBackground", self)
    back:SetAllPoints(self)
    self.back = back
    local lastParent = back

    --local t = back:CreateTexture(nil, "BACKGROUND", nil, -8)
    --t:SetTexture(1,1,1)
    --t:SetVertexColor(0.1,0.1,0.1)
    --t:SetAllPoints(self)

    --create the 4 ring segments
    self.ringSegments = {}
    for i=1, 4 do
      local ringSegment = lib:CreateRingSegment(self,lastParent, i)
      tinsert(self.ringSegments, ringSegment)
      lastParent = ringSegment
    end

    --highlight
    local highlight = CreateFrame("Frame", nil, lastParent)
    highlight:SetAllPoints(self)
    self.highlight = highlight
    lastParent = highlight

    --local t = highlight:CreateTexture(nil, "BACKGROUND", nil, -8)
    --t:SetTexture(1,1,1)
    --t:SetVertexColor(0,1,1)
    --t:SetAllPoints()

    --border
    local border = CreateFrame("Frame", nil, lastParent)
    border:SetAllPoints(self)
    self.border = border
    lastParent = border

    --local t = border:CreateTexture(nil, "BACKGROUND", nil, -8)
    --t:SetTexture(1,1,1)
    --t:SetVertexColor(1,0,1)
    --t:SetAllPoints()

    --first we set up the ring segments
    --but later on we need each ring in a specific order based on starting point an direction

    --CASTRING
    if template.castring.enable then
      --castring table
      self.castring = {}
      self.castringModulo = 1
      for i=1, template.castring.numSegmentsUsed do
        local id = lib:GetSegmentId(template.castring.startSegment,template.castring.fillDirection,i)
        self.castring[i] = self.ringSegments[id]
        self.castringModulo = self.castringModulo * self.ringSegments[id].primeNum
      end
      --fake castbar
      local castbar = CreateFrame("StatusBar", nil, self)
      castbar:SetScript("OnValueChanged", function(...) lib:CastbarOnValueChanged(...) end)
      castbar:HookScript("OnShow", function(...) lib:CastbarOnShow(...) end)
      castbar:HookScript("OnHide", function(...) lib:CastbarOnHide(...) end)
      self.Castbar = castbar
    end

    --POWERRING
    if template.powerring.enable then
      --powerring table
      self.powerring = {}
      self.powerringModulo = 1
      for i=1, template.powerring.numSegmentsUsed do
        local id = lib:GetSegmentId(template.powerring.startSegment,template.powerring.fillDirection,i)
        self.powerring[i] = self.ringSegments[id]
        self.powerringModulo = self.powerringModulo * self.ringSegments[id].primeNum
      end
      --fake power
      local powerbar = CreateFrame("StatusBar", nil, self)
      powerbar:SetScript("OnValueChanged", function(...) lib:PowerbarOnValueChanged(...) end)
      powerbar:HookScript("OnShow", function(...) lib:PowerbarOnShow(...) end)
      powerbar:HookScript("OnHide", function(...) lib:PowerbarOnHide(...) end)
      self.Power = powerbar
    end

    --HEALTHRING
    if template.healthring.enable then
      --healthring table
      self.healthring = {}
      self.healthringModulo = 1
      for i=1, template.healthring.numSegmentsUsed do
        local id = lib:GetSegmentId(template.healthring.startSegment,template.healthring.fillDirection,i)
        self.healthring[i] = self.ringSegments[id]
        self.healthringModulo = self.healthringModulo * self.ringSegments[id].primeNum
      end
      --fake health
      local healthbar = CreateFrame("StatusBar", nil, self)
      healthbar:SetScript("OnValueChanged", function(...) lib:HealthbarOnValueChanged(...) end)
      healthbar:HookScript("OnShow", function(...) lib:HealthbarOnShow(...) end)
      healthbar:HookScript("OnHide", function(...) lib:HealthbarOnHide(...) end)
      self.Health = healthbar
    end

  end