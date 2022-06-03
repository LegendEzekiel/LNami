EnemyCastSpellCantMoveList = {
    ['Janna'] = {
        ['ReapTheWhirlwind'] = {
            ['value'] = true,
            ['Cast'] = 0,
            ['Alias'] = "R"
        }
    },
    ['Nunu'] = {
        ['nunurshield'] = {
            ['value'] = true,
            ['Cast'] = 2,
            ['Alias'] = "R"
        }
    },

    ['Velkoz'] = {
        ['VelkozR'] = {
            ['value'] = true,
            ['Cast'] = 2,
            ['Alias'] = "R"
        }
    },
    ['Xerath'] = {
        ['xerathrshors'] = {
            ['value'] = true,
            ['Cast'] = 2,
            ['Alias'] = "R"
        }
    },
    ['Katarina'] = {
        ['katarinarsound'] = {
            ['value'] = true,
            ['Cast'] = 2,
            ['Alias'] = "R"
        }
    },

    ['Malzahar'] = {
        ['malzaharrsound'] = {
            ['value'] = true,
            ['Cast'] = 0,
            ['Alias'] = "R"
        }
    }
}

AnimSpell = {
    ['Jhin'] = {--R Anim
        ['Spell4_idle'] = {
            ['value'] = true,
            ['Cast'] = 0,
            ['Alias'] = "R Start"
        },
        ['Spell4'] = {
            ['value'] = true,
            ['Cast'] = 0,
            ['Alias'] = "R Continued"
        }
    },
    ['Nunu'] = {
        ['Spell4'] = {
            ['value'] = true,
            ['Cast'] = 2,
            ['Alias'] = "R"
        }
    },
    ['Katarina'] = {
        ['Spell4'] = {
            ['value'] = true,
            ['Cast'] = 2,
            ['Alias'] = "R"
        }
    },
    ['Janna'] = {
        ['Spell4'] = {
            ['value'] = true,
            ['Cast'] = 0,
            ['Alias'] = "R"
        }
    },
    ['Malzahar'] = {
        ['Spell4'] = {
            ['value'] = true,
            ['Cast'] = 0,
            ['Alias'] = "R"
        }
    },
    ['Velkoz'] = {
        ['Spell4'] = {
            ['value'] = true,
            ['Cast'] = 2,
            ['Alias'] = "R"
        }
    }

}

SpellData = {
    ["Q"] = {
        ['range'] = 875,
        ['delay'] = 1,
        ['width'] = 150,
        ['speed'] = math.huge,
        ['type'] = SkillshotType.SkillshotCircle,
        ['collision'] = true,
        ['collisionFlags'] = CollisionFlag.CollidesWithYasuoWall,
        ['minHitChance'] = HitChance.High,
        ['boundingRadiusMod'] = false
    },

    ["R"] = {
        ['maxRange'] = 2750,
        ['range'] = 1000,
        ['delay'] = 0.5,
        ['width'] = 450,
        ['speed'] = 850,
        ['type'] = SkillshotType.SkillshotLine,
        ['collision'] = true,
        ['collisionFlags'] = CollisionFlag.CollidesWithYasuoWall,
        ['minHitChance'] = HitChance.High,
        ['boundingRadiusMod'] = true
    },

}

My = Game.localPlayer;
Menu = UI.Menu.CreateMenu(My.charName, Game.localPlayer.displayName, 2);
Champions.CreateBaseMenu(Menu, 0);

Q = nil;
W = nil;
E = nil;
R = nil;

MenuConfig = {
    ["Combo"] = {
        ['Use Q'] = nil;
        ['Only Slow'] = nil;
        ['Use W'] = nil;
        ['Use W Objcet'] = {};
        ['Use W Level'] = {};
        ['Use R'] = nil;
        ['Use Key R'] = nil;
        ['Use R Number'] = nil;
    },
    ["Harass"] = {
        ['Use Q'] = nil;
        ['Use W'] = nil;
    },
    ["Auto"] = {
        ['CanNot Move Use Q'] = nil;
        ['Use E'] = nil,
        ['WhitelistE'] = {  },
        ['Gap Q'] = nil,
        ['Interrupt Q'] = nil
    },
    ['Use Range'] = {
        ['Q'] = nil;
        ['W'] = nil;
        ['E'] = nil;
        ['R'] = nil;

    },
    ['Draw'] = {

        ['Map R'] = nil;
    }


};

local function Init()


    Champions.Q = (SDKSpell.Create(SpellSlot.Q, MenuConfig['Use Range']['Q'].value, DamageType.Magical))
    Champions.W = (SDKSpell.Create(SpellSlot.W, MenuConfig['Use Range']['W'].value, DamageType.Magical))
    Champions.E = (SDKSpell.Create(SpellSlot.E, MenuConfig['Use Range']['E'].value, DamageType.Magical))
    Champions.R = (SDKSpell.Create(SpellSlot.R, MenuConfig['Use Range']['R'].value, DamageType.Magical))

    Champions.Q:SetSkillshot(
            SpellData['Q']['delay'],
            SpellData['Q']['width'],
            SpellData['Q']['speed'],
            SpellData['Q']['type'],
            SpellData['Q']['collision'],
            SpellData['Q']['collisionFlags'],
            SpellData['Q']['minHitChance'],
            SpellData['Q']['boundingRadiusMod']
    );

    Champions.R:SetSkillshot(
            SpellData['R']['delay'],
            SpellData['R']['width'],
            SpellData['R']['speed'],
            SpellData['R']['type'],
            SpellData['R']['collision'],
            SpellData['R']['collisionFlags'],
            SpellData['R']['minHitChance'],
            SpellData['R']['boundingRadiusMod']
    );

    Q = Champions.Q;

    W = Champions.W;
    E = Champions.E;
    R = Champions.R;
end

local function LoadMenu()


    local Combo = Menu:AddMenu("Combo", "Combo");
    MenuConfig['Combo']['Use Q'] = Combo:AddCheckBox("useQ", 'Use Q');
    MenuConfig['Combo']['Only Slow'] = Combo:AddCheckBox("slowQ", 'Only Slow Use', false);
    MenuConfig['Combo']['Use W'] = Combo:AddCheckBox("useW", 'Use W');
    local Wmenu = Combo:AddMenu("Wsetting", "W Settings");
    for _, ally in ObjectManager.allyHeroes:pairs() do
        local charMenu = Wmenu:AddMenu(ally.charName .. "Menu", ally.charName);
        MenuConfig['Combo']['Use W Objcet'][ally.charName] = charMenu:AddCheckBox(ally.charName .. "Use", "Use");
        MenuConfig['Combo']['Use W Level'][ally.charName] = charMenu:AddSlider(ally.charName .. "Level", "Priority Level", 1, 1, 5);
    end

    MenuConfig['Combo']['Use R'] = Combo:AddCheckBox("useR", 'Use R');
    MenuConfig['Combo']['Use Key R'] = Combo:AddKeyBind("keyR", ("Key R"), 84, false, false);
    MenuConfig['Combo']['Use Key R']:PermaShow(true, true);
    MenuConfig['Combo']['Use R Number'] = Combo:AddSlider("useRrange", 'Use R >= X Enemy', 3, 1, 5)

    MenuConfig['Combo']['Use R Number']:PermaShow(true, true);

    local Harass = Menu:AddMenu("Harass", "Harass");
    MenuConfig['Harass']['Use Q'] = Harass:AddCheckBox("useQ", 'Use Q')
    MenuConfig['Harass']['Use W'] = Harass:AddCheckBox("useW", 'Use W');
    local Auto = Menu:AddMenu("Auto", "Auto");
    -- MenuConfig['Auto']['Interrupt Q'] = Auto:AddCheckBox("Interrupt", 'Interrupt Dangerous Skills Use Q or R(Q Not Ready)');
    --local Skills=  Auto:AddMenu("Skills","Skills")
    --
    -- for name,spell in pairs(EnemyCastSpellCantMoveList) do
    --    local enemyMenu= Skills:AddMenu(name,name)
    --     for ii,vv in  pairs(spell) do
    --      local spellMenu=  enemyMenu:AddMenu(vv['Alias'],vv['Alias'])
    --         spellMenu:AddList("CastSA", "Skill Type", { "Q", "R","QR"}, vv['Cast']);
    --     end
    -- end
    --
    -- for name,spell in pairs(AnimSpell) do
    --     local enemyMenu= Skills:AddMenu(name,name)
    --     for ii,vv in  pairs(spell) do
    --         local spellMenu=  enemyMenu:AddMenu(vv['Alias'],vv['Alias'])
    --         spellMenu:AddList("CastSA", "Skill Type", { "Q", "R","QR"}, vv['Cast']);
    --     end
    -- end

    MenuConfig['Auto']['Interrupt Q'] = Auto:AddCheckBox("InterruptQ", 'Interrupt Q');

    MenuConfig['Auto']['Gap Q'] = Auto:AddCheckBox("gapQ", 'Gap Q');
    MenuConfig['Auto']['CanNot Move Use Q'] = Auto:AddCheckBox("canNot Move Use Q", 'cant move Q');
    MenuConfig['Auto']['Use E'] = Auto:AddCheckBox("useE", 'Use E (Auto Attck)');
    local WhitelistE = Auto:AddMenu("Ewhitelist", "Whitelist E");
    for _, ally in ObjectManager.allyHeroes:pairs() do
        MenuConfig['Auto']['WhitelistE'][ally.charName] = WhitelistE:AddCheckBox(ally.charName, ally.charName)
    end

    local UseRange = Menu:AddMenu("useRange", "Use Range Settings");
    MenuConfig['Use Range']['Q'] = UseRange:AddSlider("useQRange", 'Use Q Range', 875, 1, 875, 1, function(s)
        Champions.Q = (SDKSpell.Create(SpellSlot.Q, MenuConfig['Use Range']['Q'].value, DamageType.Magical))
    end)
    MenuConfig['Use Range']['W'] = UseRange:AddSlider("useWRange", 'Use W Range', 725, 1, 725, 1, function(s)
        Champions.W = (SDKSpell.Create(SpellSlot.W, MenuConfig['Use Range']['W'].value, DamageType.Magical))
    end)
    MenuConfig['Use Range']['E'] = UseRange:AddSlider("useERange", 'Use E Range', 800, 1, 800, 1, function(s)
        Champions.E = (SDKSpell.Create(SpellSlot.E, MenuConfig['Use Range']['E'].value, DamageType.Magical))
    end)
    MenuConfig['Use Range']['R'] = UseRange:AddSlider("useRRange", 'Use R Range', 1000, 1, 2500, 10, function(s)
        Champions.R = (SDKSpell.Create(SpellSlot.R, MenuConfig['Use Range']['R'].value, DamageType.Magical))
    end)

    --draw
    local draw = Menu:AddMenu("draw", "Drawing", false);

    Init();
    Champions.CreateColorMenu(draw, true)

end

LoadMenu();

local function UseQBindPred()
    if Q:Ready() then

        local T = TargetSelector.GetTarget(Q.range, DamageType.Magical);
        if T and T:IsValidTarget(Q.range) then
            local Pred = Q:GetPrediction(T);
            if Pred and Pred.hitchance >= HitChance.High then
                if My.position:Distance(Pred.castPosition) <= Q.range then
                    Q:Cast(Pred.castPosition);
                end
            end
        end
    end

end

local function UseQ(T)
    if Q:Ready() then
        local Pred = Q:GetPrediction(T);
        if Pred and Pred.hitchance >= HitChance.High then
            if My.position:Distance(Pred.castPosition) <= Q.range then
                Q:Cast(Pred.castPosition);
            end
        end
    end

end

local function UseR()
    if R:Ready() then
        local AoePosition = R:GetCastOnBestAOEPosition(MenuConfig['Combo']['Use R Number'].value)

        if AoePosition:IsValid() then
            R:Cast(AoePosition);
        end
    end


end

local function GetWRangeUseEnemyIsAlly(T, Range)
    for _, ally in ObjectManager.allyHeroes:pairs() do
        if T.position:Distance(ally.position) <= Range then
            return T;
        end
    end
    return nil;
end

local function GetWRangeUseAlly(Range)
    for _, ally in ObjectManager.allyHeroes:pairs() do
        if ally.isAlive and ally:IsValidTarget(Range) then
            for _, enemy in ObjectManager.enemyHeroes:pairs() do
                if enemy and enemy.isAlive and ally.position:Distance(enemy.position) <= 650  and enemy.isVisible then
                    return ally;
                end
            end
        end
    end
    return nil;
end

local function GetWRangeUseAllyCombo(Range)

    local UseObj = nil;
    local Level = 0;

    for _, ally in ObjectManager.allyHeroes:pairs() do
        if ally.isAlive and ally:IsValidTarget(Range) and MenuConfig['Combo']['Use W Objcet'][ally.charName].value then
            local allyLevel = MenuConfig['Combo']['Use W Level'][ally.charName].value;
            for _, enemy in ObjectManager.enemyHeroes:pairs() do
                if enemy and enemy.isAlive and ally.position:Distance(enemy.position) <= 650  and enemy.isVisible then
                    if allyLevel > Level then
                        UseObj = ally;
                        Level = allyLevel;
                        break ;
                    end
                end
            end
        end
    end
    return UseObj;
end

local function UseWCombo()

    if W:Ready() then
        --Ally->Enemy
        local castAllyObj = GetWRangeUseAllyCombo(W.range);
        if castAllyObj then
            W:Cast(castAllyObj);
            return ;
        end

    end

end

local function UseW()
    if W:Ready() then
        --Enemy->Ally
        local T = TargetSelector.GetTarget(W.range, DamageType.Magical);
        if T and T:IsValidTarget(W.range) then
            local castObj = GetWRangeUseEnemyIsAlly(T, W.range)
            if castObj then
                W:Cast(castObj);
                return ;
            end

        end

        --Ally->Enemy
        local castAllyObj = GetWRangeUseAlly(W.range);
        if castAllyObj then
            W:Cast(castAllyObj);
            return ;
        end

    end

end

local function Combo()
    if not My.isAlive then
        return ;
    end
    if MenuConfig['Combo']['Use Q'].value then
        if MenuConfig['Combo']['Only Slow'].value then
            for _, T in ObjectManager.enemyHeroes:pairs() do
                if T and T:IsValidTarget(Q.range) then
                    if T:HasBuffOfType(BuffType.Slow) then
                        UseQ(T);
                    end
                end
            end

        else
            UseQBindPred();
        end
    end
    if MenuConfig['Combo']['Use R'].value then
        UseR();
    end

    if MenuConfig['Combo']['Use W'].value then
        UseWCombo();
    end
end

local function Harass()
    if MenuConfig['Harass']['Use Q'].value then
        UseQBindPred();
    end

    if MenuConfig['Harass']['Use W'].value then
        UseW();
    end
end

local function UseQByCantMove()

    if Q:Ready() then

        for _, enemy in ObjectManager.enemyHeroes:pairs() do

            if enemy and enemy.isAlive and enemy:IsValidTarget(875) then

                if enemy:HasBuffOfType(BuffType.Stun) then
                    Q:Cast(enemy);
                    return ;
                end

                if enemy:HasBuffOfType(BuffType.Taunt) then
                    Q:Cast(enemy);
                    return ;
                end

                if enemy:HasBuffOfType(BuffType.Polymorph) then
                    Q:Cast(enemy);
                    return ;
                end

                if enemy:HasBuffOfType(BuffType.Snare) then
                    Q:Cast(enemy);
                    return ;
                end

                if enemy:HasBuffOfType(BuffType.Charm) then
                    Q:Cast(enemy);
                    return ;
                end

                if enemy:HasBuffOfType(BuffType.Suppression) then
                    Q:Cast(enemy);
                    return ;
                end

                if enemy:HasBuffOfType(BuffType.Shred) then
                    Q:Cast(enemy);
                    return ;
                end

                if enemy:HasBuffOfType(BuffType.Knockup) then
                    Q:Cast(enemy);
                    return ;
                end

                if enemy:HasBuffOfType(BuffType.Asleep) then
                    Q:Cast(enemy);
                    return ;
                end

            end


        end
    end


end

local function GetBuffByName(t, buffName)
    for i, v in t.buffManager.buffs:pairs() do
        if v.isValid and v.GetName() == buffName then
            return true
        end
    end
end

local function UseQBySpellCantMove()
    if Q:Ready() then
        for _, enemy in ObjectManager.enemyHeroes:pairs() do

            if enemy:IsValidTarget(875) then
                --Not Nil
                if AnimSpell[enemy.charName] then
                    if enemy.isAlive then
                        for index, data in pairs(AnimSpell[enemy.charName]) do
                            if He:IsPlayingAnimation(Game.fnvhash(index)) then
                                Q:Cast(enemy.position);
                                return ;
                            end

                        end
                    end
                end
            end
        end

    end


end

local function ontick()
    if My.isAlive == false then
        return ;
    end

    if My.canCast then
        UseQBySpellCantMove();
    end

    if MenuConfig['Auto']['CanNot Move Use Q'].value then
        UseQByCantMove();
    end

    if Champions.Combo then

        Combo();

    end
    if Champions.Harass then

        Harass();

    end
    --Key R
    if MenuConfig['Combo']['Use Key R'].value then
        UseR();
    end

end

Callback.Bind(CallbackType.OnTick, ontick)

local function OnDraw()
    --Renderer.DrawCircle3D(My.position2D,800,255,2,3154116607)
end

Callback.Bind(CallbackType.OnDraw, OnDraw)

local function OnImguiDraw()
    --Renderer.DrawText("21",Vector2:new(100,200),20,3154116607)
    --Renderer.DrawWorldText("1",My.position,0,20,3154116607)
end

Callback.Bind(CallbackType.OnImguiDraw, OnImguiDraw)

local function OnSpellCastComplete(sender, castArgs)
    if sender.isHero and sender.isEnemy == false then
        if castArgs.target and castArgs.target.isHero then
            if castArgs.spell:GetName():find("Attack") and
                    MenuConfig['Auto']['Use E'].value and
                    MenuConfig['Auto']['WhitelistE'][sender.charName].value and
                    sender:IsValidTarget(E.range)
            then
                E:Cast(sender)
            end
        end
    end
end

Callback.Bind(CallbackType.OnSpellCastComplete, OnSpellCastComplete);

local function OnNewPath(sender, isDash, dashSpeed, path)

    if MenuConfig['Auto']['Gap Q'].value then
        if isDash and Q:Ready() and sender.isHero and sender.isEnemy and sender.charName ~= 'Kalista' then
            local pathStart = path[1];
            local pathEnd = path[2];
            if pathStart and pathEnd then
                if sender:IsValidTarget(875) then
                    Q:Cast(pathEnd);
                end


            end


        end

    end


end

Callback.Bind(CallbackType.OnNewPath, OnNewPath);

SpecialSpellGap = {
    ['Ezreal'] = {
        [2] = {
            ['value'] = true
        },
        [3] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        }
    },
    ['Shaco'] = {
        [0] = {
            ['value'] = true
        }
    },
    ['Thresh'] = {
        [0] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        }

    },
    ['Jinx'] = {
        [1] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        }
    },
    ['Caitlyn'] = {
        [0] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        }
    },
    ['Jhin'] = {
        [1] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        },
        [3] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        },
    },
    ['Malzahar'] = {
        [3] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        }
    },
    ['Sion'] = {
        [0] = {
            ['value'] = true,
            ['type'] = 'interrupt'

        }
    },
    ['Katarina'] = {
        [3] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        }
    },
    ['Xerath'] = {
        [3] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        }
    },
    ['Velkoz'] = {
        [3] = {
            ['value'] = true,
            ['type'] = 'interrupt'

        }
    },
    ['Nunu'] = {
        [3] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        }
    },
    ['Janna'] = {
        [3] = {
            ['value'] = true,
            ['type'] = 'interrupt'
        }
    }


}

local function OnSpellAnimationStart(sender, castArgs)
    if sender and sender.isHero and sender.isEnemy and Q:Ready() and MenuConfig['Auto']['Interrupt Q'].value then
        if SpecialSpellGap[sender.charName] and SpecialSpellGap[sender.charName][castArgs.slot] and SpecialSpellGap[sender.charName][castArgs.slot]['value'] then
            local SpellRange = sender.spellBook:GetSpellEntry(castArgs.slot):DisplayRange();
            local CastPos = nil;
            if castArgs.from:Distance(castArgs.to) > SpellRange then
                CastPos = castArgs.from:RelativePos(castArgs.to, SpellRange)
            else
                CastPos = castArgs.to
            end
            if SpecialSpellGap[sender.charName][castArgs.slot]['type'] and SpecialSpellGap[sender.charName][castArgs.slot]['type'] == "interrupt" then
                CastPos = castArgs.from;
            end

            if My.position:Distance(CastPos) <= 875 then
                Q:Cast(CastPos);
            end
        end


    end
end
Callback.Bind(CallbackType.OnSpellAnimationStart, OnSpellAnimationStart)