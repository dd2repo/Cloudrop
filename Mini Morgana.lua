--[[
 __  __ _       _   __  __                                   
|  \/  (_)     (_) |  \/  |                                  
| \  / |_ _ __  _  | \  / | ___  _ __ __ _  __ _ _ __   __ _ 
| |\/| | | '_ \| | | |\/| |/ _ \| '__/ _` |/ _` | '_ \ / _` |
| |  | | | | | | | | |  | | (_) | | | (_| | (_| | | | | (_| |
|_|  |_|_|_| |_|_| |_|  |_|\___/|_|  \__, |\__,_|_| |_|\__,_|
                                      __/ |                  
                                     |___/  

AddOn for 2.0 by DeadDevil2
]]


local TS = TargetSelector(TargetSelector_Mode.LESS_CAST, TargetSelector_DamageType.MAGIC) 


Callback.Bind('Load', function()

  Callback.Bind('GameStart', function() OnStart() end)

end)

function OnStart()
    if myHero.charName ~= 'Morgana' then return end

	Morgana = MenuConfig("Mini Morgana")
    	Morgana:Icon("fa-user")

  	 Morgana:Menu("Combo", "Combo Settings")
      	Morgana.Combo:Icon("fa-folder-o")
     	Morgana.Combo:Section("Combo Settings", "Combo Settings")  
    	Morgana.Combo:Boolean("useq", "Use Q", true)
    	Morgana.Combo:Boolean("usew", "Use W", true)
    	Morgana.Combo:Section("Advanced", "Advanced")  
    	Morgana.Combo:Boolean("onlywq", "Only W if Q or R connects", true)

    	Morgana:Menu("Ultimate", "Ultimate Settings")
    	Morgana.Ultimate:Icon("fa-folder-o")
    	Morgana.Ultimate:Section("Ultimate Settings", "Ultimate Settings")  
    	Morgana.Ultimate:Boolean("user", "Auto-ultimate", true)
    	Morgana.Ultimate:DropDown("targets", "Auto-ultimate if it will hit", 4, {"2 Targets","3 Targets","4 Targets","5 Targets"})

  	Morgana:Menu("Harass", "Harass Settings")
      	Morgana.Harass:Icon("fa-folder-o")
     	Morgana.Harass:Section("Harass Settings", "Harass Settings")  
	Morgana.Harass:Boolean("usew", "Use W", true)

	Morgana:Menu("Ks", "KS Settings")
      	Morgana.Ks:Icon("fa-github-alt")
      	Morgana.Ks:Section("KS Settings", "KS Settings")  
      	Morgana.Ks:Boolean("useq", "Use Q", true)
      	Morgana.Ks:Boolean("usew", "Use W", true)
      	Morgana.Ks:Boolean("user", "Use R", true)

    	Morgana:Menu("Draw", "Draw Settings")
      	Morgana.Draw:Boolean("Enable", "Enable Drawings", true)
      	Morgana.Draw:Section("drawrange", "Draw Skill Range") 
      	Morgana.Draw:Boolean("drawq", "Draw Q Range")
      	Morgana.Draw:Boolean("draww", "Draw W Range")
      	Morgana.Draw:Boolean("drawe", "Draw E Range")
      	Morgana.Draw:Boolean("drawr", "Draw R Range")
      	Morgana.Draw:DropDown("Colors", "Colors", 1, {"Red","Green","Blue","White"})
      	Morgana.Draw:Icon('fa-pencil')

      	Morgana:Menu("Adds", "Additionals")
      	Morgana.Adds:Icon("fa-folder-o")
      	Morgana.Adds:Section("Additionals", "Additionals")  
      	Morgana.Adds:Boolean("orbwalk", "Orbwalk", true)
      	--Morgana.Adds:Boolean("usez", "Auto Zhonya's", true)
      	--Morgana.Adds:Slider("hz", "Zhonya's if Health under -> %", 75, 0, 100)


      	Morgana:Section('Keys', 'Keys')
    	Morgana:KeyBinding('combokey', 'Combo', 'SPACE')
    	Morgana:KeyBinding('harasskey', 'Harass', 'A')

		
    	BasicPrediction.EnablePrediction()


	    Color = { Red = Graphics.ARGB(0xFF,0xFF,0,0),
	            Green = Graphics.ARGB(0xFF,0,0xFF,0),
	            Blue = Graphics.ARGB(0xFF,0,0,0xFF),
	            White = Graphics.ARGB(0xFF,0xFF,0xFF,0xFF)
	            }

    Callback.Bind('Tick', function() OnTick() end)
    Callback.Bind('Draw', function() OnDraw() end)


    Game.Chat.Print("<font color=\"#F5F5F5\">Mini Morgana 1.0 by DeadDevil2 loaded! </font>")

end

function OnTick()
	Target = TS:GetTarget(1300) 
	Checks()
	Combo()
	Orbwalk()
	Autokill()
	Autoult()
	Harass()
end

function Checks()

    Qready = myHero:CanUseSpell(0) == Game.SpellState.READY
    Wready = myHero:CanUseSpell(1) == Game.SpellState.READY
    Eready = myHero:CanUseSpell(2) == Game.SpellState.READY
    Rready = myHero:CanUseSpell(3) == Game.SpellState.READY

end

function TargetHasBuff(unit, name)
    for i = 1, unit.buffCount do
        local buff = unit:GetBuff(i)
        if buff and buff.name == name and buff.startT <= Game.ServerTimer() and buff.endT >= Game.ServerTimer() then
            return true
        end
    end
    return false
end

function Combo()
	if Morgana.combokey:IsPressed() then
		if Target ~= nil and Target.type == myHero.type and Target.team == TEAM_ENEMY and not Target.dead then
			if Morgana.Combo.useq:Value() and Allclass.GetDistance(Target) < 1300 and Qready then 
	 			local PPos, WHC  = BasicPrediction.GetPredictedPosition(Target, 1300, 1200, 0.5, 110, true, false, myHero)
	 			local isCollision, CollisionObjects = BasicCollision.GetCollision(Target, myHero, 110)
	      		if PPos and PPos.x and PPos.y and PPos.z and not isCollision and WHC >= 2 then
	        		myHero:CastSpell(0, PPos.x, PPos.z)

	        	end
	        end 
	        if Morgana.Combo.usew:Value() and Morgana.Combo.onlywq:Value() and Allclass.GetDistance(Target) < 1075 and Wready and (TargetHasBuff(Target, "DarkBindingMissile") or TargetHasBuff(Target, "Stun")) then 
	        	myHero:CastSpell(1, Target.x, Target.z)
	        end
	        if Morgana.Combo.usew:Value() and not Morgana.Combo.onlywq:Value() and Allclass.GetDistance(Target) < 1075 and Wready then
	        	myHero:CastSpell(1, Target.x, Target.z)
	        end
	    end
	end
end

function Harass()
	if Morgana.harasskey:IsPressed() then
		if Target ~= nil and Target.type == myHero.type and Target.team == TEAM_ENEMY and not Target.dead then
			if Morgana.Harass.usew:Value() and Allclass.GetDistance(Target) < 1075 and Wready then
	        	myHero:CastSpell(1, Target.x, Target.z)
	        end
	    end
	end
end


function CountEnemyHeroInRange(range,object)
    object = object or myHero
    range = range and range * range or myHero.range * myHero.range
    local enemyInRange = 0
    for i = 1, Game.HeroCount(), 1 do
        local hero = Game.Hero(i)
        if hero.team == TEAM_ENEMY and not hero.dead and GetDistanceSqr(object, hero) <= range then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end

function GetDistanceSqr(v1, v2)
    v2 = v2 or player
    return (v1.x - v2.x) ^ 2 + ((v1.z or v1.y) - (v2.z or v2.y)) ^ 2
end

function Autoult()
	if Morgana.Ultimate.user:Value() and Rready then
		if Morgana.Ultimate.targets:Value() == 1 then
			if CountEnemyHeroInRange(600, myHero) >= 2 then
				myHero:CastSpell(3)
			end
		end
		if Morgana.Ultimate.targets:Value() == 2 then
			if CountEnemyHeroInRange(600, myHero) >= 3 then
				myHero:CastSpell(3)
			end
		end
		if Morgana.Ultimate.targets:Value() == 3 then
			if CountEnemyHeroInRange(600, myHero) >= 4 then
				myHero:CastSpell(3)
			end
		end
		if Morgana.Ultimate.targets:Value() == 4 then
			if CountEnemyHeroInRange(600, myHero) == 5 then
				myHero:CastSpell(3)	
			end
		end
	end						
end

function Autozhonya()
	if Morgana.Adds.usez:Value() then
		if myHero.health <= (myHero.maxHealth*(Morgana.Adds.hz:Value()/100)) then Allclass.CastItem(3157) 
		end
	end
end

function Orbwalk()
	if (Morgana.combokey:IsPressed() or Morgana.harasskey:IsPressed()) and Morgana.Adds.orbwalk:Value() then
		myHero:Move(mousePos.x, mousePos.z)
	end
end

function Autokill()
	for i = 1, Game.HeroCount() do
    hero = Game.Hero(i)

    local qdmg = myHero:CalcMagicDamage(hero, (25+55*myHero:GetSpellData(0).level+myHero.ap*0.9))
    local wdmg = myHero:CalcMagicDamage(hero, (((5+7*myHero:GetSpellData(1).level)*(1+(1-hero.health/hero.maxHealth)*0.5))+(myHero.ap*0.11)*(1+(1-hero.health/hero.maxHealth)*0.5)))
    local rdmg = myHero:CalcMagicDamage(hero, (75*myHero:GetSpellData(3).level)+75+0.7*myHero.ap)

        if hero ~= nil and hero.type == myHero.type and hero.team == TEAM_ENEMY and not hero.dead then
        	if Qready and hero.health < qdmg and Allclass.GetDistance(hero) < 1300 and Morgana.Ks.useq:Value() then
        		local PPos, WHC  = BasicPrediction.GetPredictedPosition(hero, 1300, 1200, 0.5, 110, true, true, myHero)
        		local isCollision, CollisionObjects = BasicCollision.GetCollision(hero, myHero, 110)
	      		if PPos and PPos.x and PPos.y and PPos.z and not isCollision and WHC >= 2 then
	        		myHero:CastSpell(0, PPos.x, PPos.z)
	        	end
	        end
	        if Wready and hero.health < wdmg*2 and Allclass.GetDistance(hero) < 1075 and Morgana.Ks.usew:Value() then
	        	myHero:CastSpell(1, hero.x, hero.z)
	        end
	        if Wready and hero.health < wdmg*4 and Allclass.GetDistance(hero) < 1075 and (TargetHasBuff(hero, "DarkBindingMissile") or TargetHasBuff(hero, "Stun")) and Morgana.Ks.usew:Value() then
	        	myHero:CastSpell(1, hero.x, hero.z)
	        end
	        if Rready and hero.health < rdmg*2 and Allclass.GetDistance(hero) < 600 and Morgana.Ks.user:Value() then
	        	myHero:CastSpell(3)
	        end
	    end
	end
end

function OnDraw()
	-- Thanks to Woody for this cool idea!
	if Morgana.Draw.Colors:Value() == 1 then 
      Farbe = Color.Red
    elseif Morgana.Draw.Colors:Value() == 2 then
      Farbe = Color.Green
    elseif Morgana.Draw.Colors:Value() == 3 then
      Farbe = Color.Blue
    elseif Morgana.Draw.Colors:Value() == 4 then
      Farbe = Color.White
    end
	
	if Morgana.Draw.Enable:Value() then
        if (Morgana.Draw.drawq:Value()) then
          Graphics.DrawCircle(myHero, 1300, Farbe)
        end
        if (Morgana.Draw.draww:Value()) then
          Graphics.DrawCircle(myHero, 1075, Farbe)
        end
        if (Morgana.Draw.drawe:Value()) then
          Graphics.DrawCircle(myHero, 750, Farbe)
        end
        if (Morgana.Draw.drawr:Value()) then
          Graphics.DrawCircle(myHero, 600, Farbe)
        end
    end
end
