--[[
                                                          _         _ _ 
    /\                                              /\   | |       | (_)
   /  \__      _____  ___  ___  _ __ ___   ___     /  \  | | ____ _| |_ 
  / /\ \ \ /\ / / _ \/ __|/ _ \| '_ ` _ \ / _ \   / /\ \ | |/ / _` | | |
 / ____ \ V  V /  __/\__ \ (_) | | | | | |  __/  / ____ \|   < (_| | | |
/_/    \_\_/\_/ \___||___/\___/|_| |_| |_|\___| /_/    \_\_|\_\__,_|_|_|
                                                                        
AddOn for 2.0 by DeadDevil2
]]


local TS = TargetSelector(TargetSelector_Mode.LESS_CAST, TargetSelector_DamageType.MAGIC) 


Callback.Bind('Load', function()

  Callback.Bind('GameStart', function() OnStart() end)

end)

function OnStart()
	if myHero.charName ~= 'Akali' then return end

		Akali = MenuConfig("Awesome Akali")
		Akali:Icon("fa-user")

		Akali:Menu("Combo", "Combo Settings")
		Akali.Combo:Icon("fa-folder-o")
		Akali.Combo:Section("Combo Settings", "Combo Settings")  
		Akali.Combo:Boolean("useq", "Use Q", true)
		Akali.Combo:Boolean("usee", "Use E", true)
		Akali.Combo:Boolean("user", "Use R", true)
		
		Akali.Combo:Section("Advanced", "Advanced")  
		Akali.Combo:Boolean("onlyeq", "Only E if Q is on target", true)
		Akali.Combo:Boolean("onlyriqe", "Only R > Q > E", false)

		Akali:Menu("Stealth", "Stealth Settings")
		Akali.Stealth:Icon("fa-folder-o")
		Akali.Stealth:Section("Stealth Settings", "Stealth Settings")  
		Akali.Stealth:Boolean("usew", "Auto-Stealth", true)
		Akali.Stealth:DropDown("autow", "Auto-Stealth if in range of", 3, {"2 Enemys","3 Enemys","4 Enemys","5 Enemys"})

		Akali:Menu("Harass", "Harass Settings")
		Akali.Harass:Icon("fa-folder-o")
		Akali.Harass:Section("Harass Settings", "Harass Settings")  
		Akali.Harass:Boolean("useq", "Use Q", true)

		Akali:Menu("Ks", "KS Settings")
		Akali.Ks:Icon("fa-github-alt")
		Akali.Ks:Section("KS Settings", "KS Settings")  
		Akali.Ks:Boolean("useq", "Use Q", true)
		Akali.Ks:Boolean("usee", "Use E", true)
		Akali.Ks:Boolean("user", "Use R", true)

		Akali:Menu("Draw", "Draw Settings")
		Akali.Draw:Boolean("Enable", "Enable Drawings", true)
		Akali.Draw:Section("drawrange", "Draw Skill Range") 
		Akali.Draw:Boolean("drawq", "Draw Q Range")
		Akali.Draw:Boolean("draww", "Draw W Range")
		Akali.Draw:Boolean("drawe", "Draw E Range")
		Akali.Draw:Boolean("drawr", "Draw R Range")
		Akali.Draw:DropDown("Colors", "Colors", 1, {"Red","Green","Blue","White"})
		Akali.Draw:Icon('fa-pencil')

		Akali:Menu("Adds", "Additionals")
		Akali.Adds:Icon("fa-folder-o")
		Akali.Adds:Section("Additionals", "Additionals")  
		Akali.Adds:Boolean("orbwalk", "Orbwalk", true)
		--Akali.Adds:Boolean("usez", "Auto Zhonya's", true)
		--Akali.Adds:Slider("hz", "Zhonya's if Health under -> %", 75, 0, 100)


		Akali:Section('Keys', 'Keys')
		Akali:KeyBinding('combokey', 'Combo', 'SPACE')
		Akali:KeyBinding('harasskey', 'Harass', 'A')


		Color = { Red = Graphics.ARGB(0xFF,0xFF,0,0),
	            Green = Graphics.ARGB(0xFF,0,0xFF,0),
	            Blue = Graphics.ARGB(0xFF,0,0,0xFF),
	            White = Graphics.ARGB(0xFF,0xFF,0xFF,0xFF)
	            }

	Callback.Bind('Tick', function() OnTick() end)
	Callback.Bind('Draw', function() OnDraw() end)


	Game.Chat.Print("<font color=\"#F5F5F5\">Awesome Akali 1.0 by DeadDevil2 loaded! </font>")

end

function OnTick()

	Target = TS:GetTarget(800) 
	Checks()
	Combo()
	Orbwalk()
	Autokill()
	Autostealth()
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

	if Target ~= nil and Target.type == myHero.type and Target.team == TEAM_ENEMY and not Target.dead then

	local tdis 	= 	Allclass.GetDistance(Target)
	local onlyeq 	= 	Akali.Combo.onlyeq:Value()
	local hbuff 	= 	TargetHasBuff(Target, "AkaliMota")

		if Akali.combokey:IsPressed() and not Akali.Combo.onlyriqe:Value() then

			if Akali.Combo.useq:Value() and tdis < 600 and Qready then 
				myHero:CastSpell(0, Target)
			

			elseif Akali.Combo.usee:Value() and tdis < 300 and Eready and not onlyeq then 
				myHero:CastSpell(2)
			

			elseif Akali.Combo.usee:Value() and tdis < 300 and Eready and onlyeq and hbuff then 
				myHero:CastSpell(2)
		

			elseif Akali.Combo.user:Value() and tdis < 800 and Rready then 
				myHero:CastSpell(3, Target)
			end

		elseif Akali.combokey:IsPressed() and Akali.Combo.onlyriqe:Value() then

			if (myHero.level < 6 or myHero:GetSpellData(0).currentCd < myHero:GetSpellData(3).currentCd) and Qready and tdis < 600 then
				myHero:CastSpell(0, Target)
			

			elseif (myHero.level < 6 or myHero:GetSpellData(2).currentCd < myHero:GetSpellData(3).currentCd) and hbuff and onlyeq and Eready and tdis < 300 then
				myHero:CastSpell(2)
			

			elseif (myHero.level < 6 or myHero:GetSpellData(2).currentCd < myHero:GetSpellData(3).currentCd) and not onlyeq and Eready and tdis < 300 then
				myHero:CastSpell(2)
			

			elseif Rready and Qready and Eready and tdis < 800 then
				myHero:CastSpell(3, Target)

				if tdis < 600 then
					myHero:CastSpell(0, Target)

					if tdis < 300 and hbuff then
						myHero:CastSpell(2)
					end
				end
			end
		end
	end
end


function Harass()
	if Akali.harasskey:IsPressed() then

		if Target ~= nil and Target.type == myHero.type and Target.team == TEAM_ENEMY and not Target.dead then

			if Akali.Harass.useq:Value() and Allclass.GetDistance(Target) < 600 and Qready then
			myHero:CastSpell(0, Target)
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

function Autostealth()
	if Akali.Stealth.usew:Value() and Wready then
		if Akali.Stealth.autow:Value() == 1 then
			if CountEnemyHeroInRange(700, myHero) >= 2 then
				myHero:CastSpell(1, myHero.x, myHero.z)
			end
		

		elseif Akali.Stealth.autow:Value() == 2 then
			if CountEnemyHeroInRange(700, myHero) >= 3 then
				myHero:CastSpell(1, myHero.x, myHero.z)
			end
		

		elseif Akali.Stealth.autow:Value() == 3 then
			if CountEnemyHeroInRange(700, myHero) >= 4 then
				myHero:CastSpell(1, myHero.x, myHero.z)
			end
		

		elseif Akali.Stealth.autow:Value() == 4 then
			if CountEnemyHeroInRange(700, myHero) == 5 then
				myHero:CastSpell(1, myHero.x, myHero.z)
			end
		end
	end						
end

function Autozhonya()
	if Akali.Adds.usez:Value() then
		if myHero.health <= (myHero.maxHealth*(Akali.Adds.hz:Value()/100)) then Allclass.CastItem(3157) 
		end
	end
end

function Orbwalk()
	if (Akali.combokey:IsPressed() or Akali.harasskey:IsPressed()) and Akali.Adds.orbwalk:Value() then
		myHero:Move(mousePos.x, mousePos.z)
	end
end

function Autokill()
	for i = 1, Game.HeroCount() do
		hero = Game.Hero(i)
		heroDistance = Allclass.GetDistanceSqr(hero)
		if heroDistance < 640000 and hero ~= nil and hero.type == myHero.type and hero.team == TEAM_ENEMY and not hero.dead then

			local qdmg = myHero:CalcMagicDamage(hero, (20*myHero:GetSpellData(0).level+15+.4*myHero.ap))
			local edmg = myHero:CalcMagicDamage(hero, (25*myHero:GetSpellData(2).level+5+0.3*myHero.ap+0.6*myHero.totalDamage))
			local rdmg = myHero:CalcMagicDamage(hero, (75*myHero:GetSpellData(3).level+25+.5*myHero.ap))

			if Qready and hero.health < qdmg and heroDistance < 360000 and Akali.Ks.useq:Value() then
				myHero:CastSpell(0, Target)
			

			elseif Eready and hero.health < edmg and heroDistance < 105625 and Akali.Ks.usee:Value() then
				myHero:CastSpell(2, Target)
			

			elseif Rready and heroDistance < 640000 and Akali.Ks.user:Value() then
				if hero.health < rdmg then
					myHero:CastSpell(3, Target)

				elseif Eready and hero.health < (rdmg+edmg) and Akali.Ks.usee:Value() then
					myHero:CastSpell(3, Target)

				end
			end
		end
	end
end

function OnDraw()
	-- Thanks to Woody for this cool idea!
	if Akali.Draw.Colors:Value() == 1 then 
		Farbe = Color.Red
	elseif Akali.Draw.Colors:Value() == 2 then
		Farbe = Color.Green
	elseif Akali.Draw.Colors:Value() == 3 then
		Farbe = Color.Blue
	elseif Akali.Draw.Colors:Value() == 4 then
		Farbe = Color.White
	end
	
	if Akali.Draw.Enable:Value() then
		if (Akali.Draw.drawq:Value()) then
			Graphics.DrawCircle(myHero, 600, Farbe)
		end
		if (Akali.Draw.draww:Value()) then
			Graphics.DrawCircle(myHero, 700, Farbe)
		end
		if (Akali.Draw.drawe:Value()) then
			Graphics.DrawCircle(myHero, 325, Farbe)
		end
		if (Akali.Draw.drawr:Value()) then
			Graphics.DrawCircle(myHero, 800, Farbe)
		end
	end
end
