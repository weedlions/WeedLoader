require "UOL"

local predTable = {"None"}
local currentPred = nil
local myHero = GetMyHero()
local init
local ts
local minionmanager = nil
local modeTable = {"None"}
local EzLoaded, AliLoaded, SonaLoaded = false

if myHero.charName == "Ezreal" then EzLoaded = true
elseif myHero.charName == "Alistar" then AliLoaded = true
elseif myHero.charName == "Sona" then SonaLoaded = true
else return end

function OnLoad()

  minionmanager = minionManager(MINION_ALL, 1500)

  if(myHero.charName == "Ezreal") then
    PrintChat("Welcome to Weed Ezreal. Good Luck, Have Fun!")
  elseif(myHero.charName == "Alistar") then
    PrintChat("Welcome to Weed Alistar. Good Luck, Have Fun!")
    PrintChat("This Script requires VPrediction. Please install it if you havent already")
  elseif(myHero.charName == "Sona") then
    PrintChat("Welcome to Weed Sona. Good Luck, Have Fun!")
  end

  ts = TargetSelector(TARGET_LOW_HP_PRIORITY,1500)

  if EzLoaded then
    table.insert(modeTable, "Lasthit")
    table.insert(modeTable, "Push")
  end

  if AliLoaded then ts2 = TargetSelector(TARGET_LOW_HP_PRIORITY,350) end
  if SonaLoaded then ts2 = TargetSelector(TARGET_LOW_HP_PRIORITY,990) end

  initPreds()
  initMenu()

end

function initMenu()

  if EzLoaded then
    Config = scriptConfig("Weed Ezreal", "weedez")

    Config:addSubMenu("Combo Settings", "settComb")
    Config.settComb:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.settComb:addParam("Blank", "Min Mana for Q", SCRIPT_PARAM_INFO, "")
    Config.settComb:addParam("manaq", "Default value = 25", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
    Config.settComb:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.settComb:addParam("Blank", "Min Mana for W", SCRIPT_PARAM_INFO, "")
    Config.settComb:addParam("manaw", "Default value = 45", SCRIPT_PARAM_SLICE, 45, 0, 100, 0)

    Config:addSubMenu("Harass Settings", "settHar")
    Config.settHar:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.settHar:addParam("Blank", "Min Mana for Q", SCRIPT_PARAM_INFO, "")
    Config.settHar:addParam("manaq", "Default value = 25", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
    Config.settHar:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)
    Config.settHar:addParam("Blank", "Min Mana for W", SCRIPT_PARAM_INFO, "")
    Config.settHar:addParam("manaw", "Default value = 45", SCRIPT_PARAM_SLICE, 45, 0, 100, 0)

    Config:addSubMenu("Laneclear Settings", "settLC")
    Config.settLC:addParam("useq", "Use Q in Laneclear", SCRIPT_PARAM_ONOFF, true)
    Config.settLC:addParam("Blank", "Min Mana for Q", SCRIPT_PARAM_INFO, "")
    Config.settLC:addParam("mana", "Default value = 50", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
    Config.settLC:addParam("mode", "Use Q for", SCRIPT_PARAM_LIST, 1, modeTable)
    Config.settLC:addParam("Blank", "Damage Buffer for Push Mode", SCRIPT_PARAM_INFO, "")
    Config.settLC:addParam("dmgbuff", "Default value = 50", SCRIPT_PARAM_SLICE, 50, 0, 200, 0)

    Config:addSubMenu("Lasthit Settings", "settLH")
    Config.settLH:addParam("useq", "Use Q in Lasthit", SCRIPT_PARAM_ONOFF, true)
    Config.settLH:addParam("Blank", "Min Mana for Q", SCRIPT_PARAM_INFO, "")
    Config.settLH:addParam("mana", "Default value = 50", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)

    Config:addSubMenu("Killsteal Settings", "settSteal")
    Config.settSteal:addParam("useq", "Use Q for Killsteal", SCRIPT_PARAM_ONOFF, true)
    Config.settSteal:addParam("usew", "Use W for Killsteal", SCRIPT_PARAM_ONOFF, true)
    Config.settSteal:addParam("user", "Use R for Killsteal", SCRIPT_PARAM_ONOFF, true)
    Config.settSteal:addParam("Blank", "Max Range for R Steal", SCRIPT_PARAM_INFO, "")
    Config.settSteal:addParam("range", "Default value = 1000", SCRIPT_PARAM_SLICE, 200, 0, 5000, 0)

    Config:addSubMenu("Draw Settings", "settDraw")
    Config.settDraw:addParam("qrange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Config.settDraw:addParam("wrange", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    Config.settDraw:addParam("erange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu("Prediction Settings", "settPred")
    Config.settPred:addParam("pred", "Select Prediction", SCRIPT_PARAM_LIST, 1, predTable)

    Config:addSubMenu("Key Settings", "settKey")
    Config.settKey:addParam("Blank", "Use Orbwalker Keys", SCRIPT_PARAM_INFO, "")

    UOL:AddToMenu(scriptConfig("OrbWalker", "OrbWalker"))
  elseif AliLoaded then
    Config = scriptConfig("Weed Alistar", "weedali")

    Config:addSubMenu("Combo Settings", "settComb")
    Config.settComb:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.settComb:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu("Autoheal Settings", "settHeal")
    Config.settHeal:addParam("active", "Auto Heal Enable", SCRIPT_PARAM_ONOFF, true)
    Config.settHeal:addParam("Blank", "Min Allys to Heal", SCRIPT_PARAM_INFO, "")
    Config.settHeal:addParam("count", "Default value = 1", SCRIPT_PARAM_SLICE, 1, 0, 4, 0)
    Config.settHeal:addParam("Blank", "Min % HP for Autoheal", SCRIPT_PARAM_INFO, "")
    Config.settHeal:addParam("health", "Default value = 75", SCRIPT_PARAM_SLICE, 75, 0, 100, 0)
    Config.settHeal:addParam("Blank", "Min Mana for Autoheal", SCRIPT_PARAM_INFO, "")
    Config.settHeal:addParam("mana", "Default value = 25", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)

    Config:addSubMenu("Anti-Dash Settings", "settDash")
    Config.settDash:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.settDash:addParam("usew", "Use W", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu("Draw Settings", "settDraw")
    Config.settDraw:addParam("qrange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Config.settDraw:addParam("wrange", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    Config.settDraw:addParam("erange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)

    UOL:AddToMenu(scriptConfig("OrbWalker", "OrbWalker"))
  elseif SonaLoaded then
    Config = scriptConfig("Weed Sona", "weedsona")

    Config:addSubMenu("Combo Settings", "settComb")
    Config.settComb:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.settComb:addParam("user", "Use R", SCRIPT_PARAM_ONOFF, true)
    Config.settComb:addParam("Blank", "Enemys for Q", SCRIPT_PARAM_INFO, "")
    Config.settComb:addParam("enem", "Default value = 1", SCRIPT_PARAM_SLICE, 1, 1, 2, 0)
    Config.settComb:addParam("Blank", "Min % Mana for Q", SCRIPT_PARAM_INFO, "")
    Config.settComb:addParam("mana", "Default value = 20", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    Config:addSubMenu("Harass Settings", "settHar")
    Config.settHar:addParam("useq", "Use Q", SCRIPT_PARAM_ONOFF, true)
    Config.settHar:addParam("Blank", "Enemys for Q", SCRIPT_PARAM_INFO, "")
    Config.settHar:addParam("enem", "Default value = 1", SCRIPT_PARAM_SLICE, 1, 1, 2, 0)
    Config.settHar:addParam("Blank", "Min % Mana for Q", SCRIPT_PARAM_INFO, "")
    Config.settHar:addParam("mana", "Default value = 20", SCRIPT_PARAM_SLICE, 20, 0, 100, 0)

    Config:addSubMenu("Autoheal Settings", "settHeal")
    Config.settHeal:addParam("active", "Auto Heal Enable", SCRIPT_PARAM_ONOFF, true)
    Config.settHeal:addParam("Blank", "Min % HP for Autoheal", SCRIPT_PARAM_INFO, "")
    Config.settHeal:addParam("health", "Default value = 75", SCRIPT_PARAM_SLICE, 75, 0, 100, 0)
    Config.settHeal:addParam("Blank", "Min Mana for Autoheal", SCRIPT_PARAM_INFO, "")
    Config.settHeal:addParam("mana", "Default value = 25", SCRIPT_PARAM_SLICE, 25, 0, 100, 0)
    Config.settHeal:addParam("healalone", "Only heal if Ally Hit", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu("Draw Settings", "settDraw")
    Config.settDraw:addParam("qrange", "Draw Q Range", SCRIPT_PARAM_ONOFF, true)
    Config.settDraw:addParam("wrange", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
    Config.settDraw:addParam("erange", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
    Config.settDraw:addParam("rrange", "Draw R Range", SCRIPT_PARAM_ONOFF, true)

    Config:addSubMenu("Prediction Settings", "settPred")
    Config.settPred:addParam("pred", "Select Prediction", SCRIPT_PARAM_LIST, 1, predTable)

    UOL:AddToMenu(scriptConfig("OrbWalker", "OrbWalker"))
  end

end

function initPreds()

  if FileExist(LIB_PATH .. "SPrediction.lua") then
    table.insert(predTable, "SPrediction")
    loadedSP = false
  end
  if FileExist(LIB_PATH .. "VPrediction.lua") then
    table.insert(predTable, "VPrediction")
    loadedVP = false
  end
  if FileExist(LIB_PATH .. "HPrediction.lua") then
    table.insert(predTable, "HPrediction")
    loadedHP = false
  end
  if FileExist(LIB_PATH .. "KPrediction.lua") then
    table.insert(predTable, "KPrediction")
    loadedKP = false
  end
  if FileExist(LIB_PATH .. "DivinePred.lua") then
    table.insert(predTable, "DPrediction")
    loadedDP = false
  end

end

function activePreds()

  if EzLoaded then
    if predTable[Config.settPred.pred] == "SPrediction" and not loadedSP then
      require "SPrediction"
      loadedSP, currentPred = true, SPrediction()
      loadedVP, loadedHP, loadedKP, loadedDP = false
    elseif predTable[Config.settPred.pred] == "VPrediction" and not loadedVP then
      require "VPrediction"
      loadedVP, currentPred = true, VPrediction()
      loadedKP, loadedHP, loadedSP, loadedDP = false
    elseif predTable[Config.settPred.pred] == "HPrediction" and not loadedHP then
      require "Hprediction"
      loadedHP, currentPred = true, HPrediction()
      Q = currentPred.Presets["Ezreal"]["Q"]
      W = currentPred.Presets["Ezreal"]["W"]
      R = currentPred.Presets["Ezreal"]["R"]
      loadedVP, loadedKP, loadedSP, loadedDP = false
    elseif predTable[Config.settPred.pred] == "KPrediction" and not loadedKP then
      require "Kprediction"
      loadedKP, currentPred = true, KPrediction()
      Q = currentPred.Presets["Ezreal"]["Q"]
      W = currentPred.Presets["Ezreal"]["W"]
      R = currentPred.Presets["Ezreal"]["R"]
      loadedVP, loadedHP, loadedSP, loadedDP = false
    elseif predTable[Config.settPred.pred] == "DPrediction" and not loadedDP then
      require "DivinePred"
      loadedDP, currentPred = true, DivinePred()
      local Q = LineSS(2000,1200,50,0)
      local W = LineSS(1550,900,70,6)
      local R = LineSS(2000,20000,100,HUGE)

      local Q = currentPred:bindSS("ezQ",Q,50)
      local W = currentPred:bindSS("ezW",W,50)
      local R = currentPred:bindSS("ezR",R,50)
      loadedSP, loadedHP, loadedKP, loadedVP = false
    end
  elseif SonaLoaded then
    if predTable[Config.settPred.pred] == "SPrediction" and not loadedSP then
      require "SPrediction"
      loadedSP, currentPred = true, SPrediction()
      loadedVP, loadedHP, loadedKP, loadedDP = false
    elseif predTable[Config.settPred.pred] == "VPrediction" and not loadedVP then
      require "VPrediction"
      loadedVP, currentPred = true, VPrediction()
      loadedKP, loadedHP, loadedSP, loadedDP = false
    elseif predTable[Config.settPred.pred] == "HPrediction" and not loadedHP then
      require "Hprediction"
      loadedHP, currentPred = true, HPrediction()
      R = HPSkillshot({type = "DelayLine", delay = 0.25, range = 1200, width = 50, speed = 2000})
      loadedVP, loadedKP, loadedSP, loadedDP = false
    elseif predTable[Config.settPred.pred] == "KPrediction" and not loadedKP then
      require "Kprediction"
      loadedKP, currentPred = true, KPrediction()
      R = KPSkillshot({type = "DelayLine", delay = 0.25, range = 1200, width = 50, speed = 2000})
      loadedVP, loadedHP, loadedSP, loadedDP = false
    elseif predTable[Config.settPred.pred] == "DPrediction" and not loadedDP then
      require "DivinePred"
      loadedDP, currentPred = true, DivinePred()
      local R = LineSS(2000,900,100,HUGE)

      local R = currentPred:bindSS("sonaR",R,50)
      loadedSP, loadedHP, loadedKP, loadedVP = false
    end
  end

end

function OnTick()

  if not AliLoaded then activePreds() end

  if myHero.dead then return end

  ts:update()
  minionmanager:update()

  if(UOL:GetOrbWalkMode() == "LaneClear") then laneClearQ() end

  if(UOL:GetOrbWalkMode() == "LastHit") then lastHitQ() end

  if(UOL:GetOrbWalkMode() == "Combo") then onCombo() end

  if(UOL:GetOrbWalkMode() == "Harass") then onHarass() end

  killSteal()
  autoHeal()

end

function autoHeal()

  if AliLoaded then
    local allycount = 0
    local heal = false
    if not Config.settHeal.active then return end

    for i=1, heroManager.iCount do
      local ally = heroManager:getHero(i)

      if ally.team == myHero.team and not ally == myHero and myHero:CanUseSpell(_E) == READY and ((myHero.mana/myHero.maxMana)*100) > Config.settHeal.mana and ally.bTargetable and ally.visible == true and not ally.dead and ally.type == myHero.type and GetDistance(ally.pos) < 550 then
        allycount = allycount+1
        if(((ally.health/ally.maxHealth)*100) < Config.settHeal.health) then heal = true end
      end

      if(((ally.health/ally.maxHealth)*100) < Config.settHeal.health and ally == myHero) then heal = true end

      if(allycount >= Config.settHeal.count and heal) then CastSpell(_E) end
    end
  elseif SonaLoaded then
    if not Config.settHeal.active then return end

    for i=1, heroManager.iCount do
      local ally = heroManager:getHero(i)

      if ally.team == myHero.team and not ally == myHero and myHero:CanUseSpell(_W) == READY and ((myHero.mana/myHero.maxMana)*100) > Config.settHeal.mana and ally.bTargetable and ally.visible == true and not ally.dead and ally.type == myHero.type and GetDistance(ally.pos) < 990 then
        if(((ally.health/ally.maxHealth)*100) < Config.settHeal.health) then CastSpell(_W) end
      end
    end

    if(((myHero.health/myHero.maxHealth)*100) < Config.settHeal.health and not Config.settHeal.healalone) and ((myHero.mana/myHero.maxMana)*100) > Config.settHeal.mana then CastSpell(_W) end
  end

end

function killSteal()

  if EzLoaded then
    for i=1, heroManager.iCount do
      local enemy = heroManager:getHero(i)
      if(Config.settSteal.useq and myHero:CanUseSpell(_Q) == READY and enemy.health < (getDmg("Q", enemy, myHero)+((myHero.damage)*1.1)+(myHero.ap*0.4)) and not enemy.dead and enemy.bTargetable) then
        local castx, castz = predict(enemy, "Q")
        if(castx ~= nil) then CastSpell(_Q, castx, castz) end
      end

      if(Config.settSteal.usew and myHero:CanUseSpell(_W) == READY and enemy.health < (getDmg("W", enemy, myHero)+((myHero.ap)*0.8)) and not enemy.dead and enemy.bTargetable) then
        local castx, castz = predict(enemy, "W")
        if(castx ~= nil) then CastSpell(_W, castx, castz) end
      end

      if(Config.settSteal.user and myHero:CanUseSpell(_R) == READY and enemy.health < (getDmg("R", enemy, myHero)+((myHero.ap)*0.9)+(myHero.damage)) and not enemy.dead and enemy.bTargetable) then
        local castx, castz = predict(enemy, "R")
        if(castx ~= nil) then CastSpell(_R, castx, castz) end
      end
    end
  end

end

function laneClearQ()

  if EzLoaded then
    if not myHero:CanUseSpell(_Q) == READY then return end

    if(Config.settLC.useq and ((myHero.mana/myHero.maxMana)*100) > Config.settLC.mana and modeTable[Config.settLC.mode] == "Lasthit") then

      for i, minion in pairs(minionmanager.objects) do

        if(minion ~= nil and minion.bTargetable and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health < (getDmg("Q", minion, myHero)+((myHero.damage)*1.1)+(myHero.ap*0.4))) then

          --PrintChat("LCQ")
          local castx, castz = predict(minion, "Q")
          if(castx ~= nil) then CastSpell(_Q, castx, castz) end
        end
      end
    end

    if(Config.settLC.useq and ((myHero.mana/myHero.maxMana)*100) > Config.settLC.mana and modeTable[Config.settLC.mode] == "Push") then

      for i, minion in pairs(minionmanager.objects) do

        if(minion ~= nil and minion.bTargetable and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and (minion.health < (getDmg("Q", minion, myHero)+((myHero.damage)*1.1)+(myHero.ap*0.4)) or (minion.health > (getDmg("Q", minion, myHero)+((myHero.damage)*1.1))+50))) then

          --PrintChat("LCQ")
          local castx, castz = predict(minion, "Q")
          if(castx ~= nil) then CastSpell(_Q, castx, castz) end
        end
      end
    end
  end

end

function lastHitQ()

  if EzLoaded then
    if not myHero:CanUseSpell(_Q) == READY then return end

    if(Config.settLH.useq and ((myHero.mana/myHero.maxMana)*100) > Config.settLH.mana) then

      for i, minion in pairs(minionmanager.objects) do

        if(minion ~= nil and minion.bTargetable and minion.valid and minion.team ~= myHero.team and not minion.dead and minion.visible and minion.health < (getDmg("Q", minion, myHero)+((myHero.damage)*1.1)+(myHero.ap*0.4))) then

          --PrintChat("LHQ")
          local castx, castz = predict(minion, "Q")
          if(castx ~= nil) then CastSpell(_Q, castx, castz) end
        end
      end
    end
  end

end

function onCombo()

  if EzLoaded then
    if(ts.target ~= nil) then

      local enemy = GetTarget()

      if enemy == nil then return end

      if(myHero:CanUseSpell(_Q) == READY and Config.settComb.useq and ((myHero.mana/myHero.maxMana)*100) > Config.settComb.manaq) then
        if enemy.team ~= myHero.team and enemy.bTargetable and enemy.visible == true and not enemy.dead then

          --PrintChat("CoQ")
          local castx, castz = predict(enemy, "Q")
          if(castx ~= nil) then CastSpell(_Q, castx, castz) end
        end
      end

      if(myHero:CanUseSpell(_W) == READY and Config.settComb.usew and ((myHero.mana/myHero.maxMana)*100) > Config.settComb.manaw) then

        if enemy.team ~= myHero.team and enemy.bTargetable and enemy.visible == true and not enemy.dead then

          --PrintChat("CoW")
          local castx, castz = predict(enemy, "W")
          if(castx ~= nil) then CastSpell(_W, castx, castz) end
        end
      end
    end
  elseif AliLoaded then
    if(ts.target ~= nil) then

      local enemy = GetTarget()

      if enemy == nil then return end

      if(myHero:CanUseSpell(_Q) == READY and Config.settComb.useq and GetDistance(enemy.pos) < 350) then
        if enemy.team ~= myHero.team and enemy.bTargetable and enemy.visible == true and not enemy.dead then

          --PrintChat("CoQ")
          CastSpell(_Q)
        end
      end

      if(myHero:CanUseSpell(_W) == READY and Config.settComb.usew and myHero:CanUseSpell(_Q) == READY and GetDistance(enemy.pos) < 640) then

        if enemy.team ~= myHero.team and enemy.bTargetable and enemy.visible == true and not enemy.dead then

          --PrintChat("CoW")
          CastSpell(_W, enemy)
        end
      end
    end
  elseif SonaLoaded then
    local enemycount = 0

    for i=1, heroManager.iCount do
      local enemy = heroManager:getHero(i)

      if(myHero:CanUseSpell(_Q) == READY and Config.settComb.useq and GetDistance(enemy.pos) < 815) then
        if enemy.team ~= myHero.team and enemy.bTargetable and enemy.visible == true and not enemy.dead then
          enemycount = enemycount+1
        end
      end

      if(enemycount >= Config.settComb.enem) then CastSpell(_Q) end

      if(myHero:CanUseSpell(_R) == READY and Config.settComb.user and GetDistance(enemy.pos) < 890) then
        if enemy.team ~= myHero.team and enemy.bTargetable and enemy.visible == true and not enemy.dead then
          local castx, castz = predict(enemy, "R")
          if(castx ~= nil) then CastSpell(_R, castx, castz) end
        end
      end
    end
  end

end

function onHarass()

  if EzLoaded then
    if(ts.target ~= nil) then

      local enemy = GetTarget()

      if enemy == nil then return end

      if(myHero:CanUseSpell(_Q) == READY and Config.settHar.useq and ((myHero.mana/myHero.maxMana)*100) > Config.settHar.manaq) then
        if enemy.team ~= myHero.team and enemy.bTargetable and enemy.visible and not enemy.dead then

          --PrintChat("HaQ")
          local castx, castz = predict(enemy, "Q")
          if(castx ~= nil) then CastSpell(_Q, castx, castz) end
        end
      end

      if(myHero:CanUseSpell(_W) == READY and Config.settHar.usew and ((myHero.mana/myHero.maxMana)*100) > Config.settHar.manaw) then

        if enemy.team ~= myHero.team and enemy.bTargetable and enemy.visible and not enemy.dead then

          --PrintChat("HaW")
          local castx, castz = predict(enemy, "W")
          if(castx ~= nil) then CastSpell(_W, castx, castz) end
        end
      end
    end
  elseif SonaLoaded then
    local enemycount = 0

    for i=1, heroManager.iCount do
      local enemy = heroManager:getHero(i)

      if(myHero:CanUseSpell(_Q) == READY and Config.settComb.useq and GetDistance(enemy.pos) < 815) then
        if enemy.team ~= myHero.team and enemy.bTargetable and enemy.visible == true and not enemy.dead then
          enemycount = enemycount+1
        end
      end
    end

    if(enemycount >= Config.settComb.enem) then CastSpell(_Q) end
  end

end

function GetTarget()
  if UOL:GetTarget() ~= nil and UOL:GetTarget().type == myHero.type then return UOL:GetTarget() end

  ts:update()
  if ts.target and not ts.target.dead and ts.target.type == myHero.type then
    return ts.target
  else
    return nil
  end
end

function GetVPred(target, spell)

  if EzLoaded then
    if(spell == "Q") then
      local CastPosition, HitChance, Position = currentPred:GetLineCastPosition(target, 0.25, 50, 1200, 2000, myHero, true)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 1200 then
        return CastPosition.x, CastPosition.z
      end
    elseif(spell == "W") then
      local CastPosition, HitChance, Position = currentPred:GetLineCastPosition(target, 0.25, 50, 900, 1550, myHero, false)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 900 then
        return CastPosition.x, CastPosition.z
      end
    elseif(spell == "R") then
      local CastPosition, HitChance, Position = currentPred:GetLineCastPosition(target, 1, 100, 20000, 2000, myHero, false)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < Config.settSteal.range then
        return CastPosition.x, CastPosition.z
      end
    else return nil, nil
    end
  elseif SonaLoaded then
    if(spell == "R") then
      local CastPosition, HitChance, Position = currentPred:GetLineCastPosition(target, 0.1, 100, 900, 2000, myHero, false)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 890 then
        return CastPosition.x, CastPosition.z
      end
    else return nil, nil end
  end

end

function GetSPred(target, spell)

  if EzLoaded then
    if(spell == "Q") then
      local CastPosition, HitChance, Position = currentPred:Predict(target, 1200, 2000, 0.25, 50, true, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 1200 then
        return CastPosition.x, CastPosition.z
      end
    elseif(spell == "W") then
      local CastPosition, HitChance, Position = currentPred:Predict(target, 900, 1550, 0.25, 70, false, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 900 then
        return CastPosition.x, CastPosition.z
      end
    elseif(spell == "R") then
      local CastPosition, HitChance, Position = currentPred:Predict(target, 20000, 2000, 1, 100, false, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < Config.settSteal.range then
        return CastPosition.x, CastPosition.z
      end
    else return nil, nil
    end
  elseif SonaLoaded then
    if(spell == "R") then
      local CastPosition, HitChance, Position = currentPred:Predict(target, 900, 2000, 0.1, 100, false, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 890 then
        return CastPosition.x, CastPosition.z
      end
    else return nil, nil end
  end

end

function GetHPred(target, spell)

  if EzLoaded then
    if(spell == "Q") then
      local CastPosition, HitChance = currentPred:GetPredict(Q, target, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 1200 then
        return CastPosition.x, CastPosition.z
      end
    elseif(spell == "W") then
      local CastPosition, HitChance = currentPred:GetPredict(W, target, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 900 then
        return CastPosition.x, CastPosition.z
      end
    elseif(spell == "R") then
      local CastPosition, HitChance = currentPred:GetPredict(R, target, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < Config.settSteal.range then
        return CastPosition.x, CastPosition.z
      end
    else return nil, nil
    end
  elseif SonaLoaded then
    if(spell == "R") then
      local CastPosition, HitChance = currentPred:GetPredict(R, target, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 890 then
        return CastPosition.x, CastPosition.z
      end
    else return nil, nil end
  end

end

function GetKPred(target, spell)

  if EzLoaded then
    if(spell == "Q") then
      local CastPosition, HitChance = currentPred:GetPrediction(Q, target, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 1200 then
        return CastPosition.x, CastPosition.z
      end
    elseif(spell == "W") then
      local CastPosition, HitChance = currentPred:GetPrediction(W, target, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 900 then
        return CastPosition.x, CastPosition.z
      end
    elseif(spell == "R") then
      local CastPosition, HitChance = currentPred:GetPrediction(R, target, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < Config.settSteal.range then
        return CastPosition.x, CastPosition.z
      end
    else return nil, nil
    end
  elseif SonaLoaded then
    if(spell == "R") then
      local CastPosition, HitChance = currentPred:GetPrediction(R, target, myHero)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 890 then
        return CastPosition.x, CastPosition.z
      end
    else return nil, nil end
  end

end

function GetDPred(target, spell)

  if EzLoaded then
    if(spell == "Q") then
      local status,CastPosition,perc = currentPred:predict("ezQ",target)
      if CastPosition and GetDistance(CastPosition) < 1200 then
        return CastPosition.x, CastPosition.z
      end
    elseif(spell == "W") then
      local status,CastPosition,perc = currentPred:predict("ezW",target)
      if CastPosition and GetDistance(CastPosition) < 900 then
        return CastPosition.x, CastPosition.z
      end
    elseif(spell == "R") then
      local status,CastPosition,perc = currentPred:predict("ezR",target)
      if CastPosition and GetDistance(CastPosition) < Config.settSteal.range then
        return CastPosition.x, CastPosition.z
      end
    else return nil, nil
    end
  elseif SonaLoaded then
    if(spell == "R") then
      local  status,CastPosition,perc = currentPred:predict("sonaR", target)
      if CastPosition and HitChance >= 2 and GetDistance(CastPosition) < 890 then
        return CastPosition.x, CastPosition.z
      end
    else return nil, nil end
  end

end

function predict(target, spell)

  if loadedSP then return GetSPred(target, spell)
  elseif loadedVP then return GetVPred(target, spell)
  elseif loadedHP then return GetHPred(target, spell)
  elseif loadedKP then return GetKPred(target, spell)
  elseif loadedDP then return GetDPred(target, spell)
  end

end

function OnDraw()

  if EzLoaded then
    if(Config.settDraw.qrange) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 1200, 0x111111)
    end

    if(Config.settDraw.wrange) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 900, 0x111111)
    end

    if(Config.settDraw.erange) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 475, 0x111111)
    end
  elseif AliLoaded then
    if(Config.settDraw.qrange) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 365, 0x111111)
    end

    if(Config.settDraw.wrange) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 650, 0x111111)
    end

    if(Config.settDraw.erange) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 575, 0x111111)
    end
  elseif SonaLoaded then
    if(Config.settDraw.qrange) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 825, 0x111111)
    end

    if(Config.settDraw.wrange) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 1000, 0x111111)
    end

    if(Config.settDraw.erange) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 360, 0x111111)
    end

    if(Config.settDraw.rrange) then
      DrawCircle(myHero.x, myHero.y, myHero.z, 900, 0x111111)
    end
  end

end