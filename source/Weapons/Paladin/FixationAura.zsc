class FixAuraPowerup : PowerProtection
{
    default
    {
        //DamageFactor .1, "fire", 0.25;
        DamageFactor "Fire", 0.5;
        activesound "FireHit";
    }
}

//small damage reduction to anything else
class Fixauradef : PowerPRotection
{
    default
    {
        DamageFactor "Normal", 0.9;
        activesound "DmgReduc";
    }
}
class Fixauradmg : powerDamage
{
    default
    {
        DamageFactor "Normal", 1.1;
        activesound "DmgSwing";
    }
}

//used to ensure aura is only given once
class fixationaura : inventory
{
    default
    {
        inventory.maxamount 1;
        Inventory.InterHubAmount 0;
    }
    states
    {
        held:
        tnt1 a 1;
        tnt1 a 1 a_jumpif(owner.bcorpse,"end");
        loop;
        end:
        tnt1 a 1;
        stop;
    }
    override void Travelled()
    {
        GoAwayAndDie();
    }
}


class fixationPowerupGiver : PowerupGiver abstract
{
    default
    {
        //Powerup.duration 0x7FFFFFFF; max duration
        Powerup.duration 2;
        inventory.maxamount 0;
        +INVENTORY.AUTOACTIVATE;
    }
}



class fixtauragiver : FixationPowerupGiver
{
    default
    {
        Powerup.type "FixAuraPowerUp";
    }
}
class fixtauradmggiver : FixationPowerupGiver
{
    default
    {
        Powerup.type "FixAuradmg";
    }
}

class fixtauradefgiver : FixationPowerupGiver
{
    default
    {
        Powerup.type "FixAuradef";
    }
}

class fixtauraitemothers : fixtauraitem
{
    //should in theory be done with a parameter for the default item
    // but string != class identifier apparently
    override bool TryPickup(out Actor toucher)
    {
        // Spawn an orbiting projectile at the toucher's position.
        let maxproj = 1;
        //console.printf(toucher.getclassname() );
        let itemamount = toucher.countinv("FixationAura");

        if (itemamount > 0)
        {
            goawayanddie();
            return false;
        }
        else
        {
            a_startsound("Fixation",0,0,1.0,ATTN_NONE);
            toucher.A_setblend("goldenrod",.8,50);
            toucher.giveinventorytype("FixtAuraTrianglesOthers");
            toucher.giveinventorytype("FixtAuraGiver");
            toucher.giveinventorytype("FixtAuradefGiver");
            toucher.giveinventorytype("FixtAuradmgGiver");
            toucher.giveinventorytype("fixationaura");


            for(int i = 0; i < maxproj;i++)
            {
                let proj = Spawn('FixationAuraCircleOthers', toucher.pos);
                if (proj)
                {
                    proj.angle = angle+(i*(360/maxproj));
                    // Assign the orbiting projectile's target
                    // so that it won't disapepar.
                    proj.target = toucher;

                }
            }


            // Remove this item from play.
            GoAwayAndDie();
            return true;
        }
    }
}

class FixtAuraItem : FixationPowerupGiver
{
    default
    {
        inventory.maxamount 1;
    }
    override bool TryPickup(out Actor toucher)
    {
        // Spawn an orbiting projectile at the toucher's position.
        let maxproj = 1;
        if (toucher.countinv("FixationAura") > 0)
        {
            goawayanddie();
            return false;
        }
        else
        {
            a_startsound("Fixation",0,CHANF_OVERLAP,1.0,ATTN_NONE);
            toucher.A_setblend("goldenrod",.8,50);
            toucher.giveinventorytype("FixtAuraTriangles");
            toucher.giveinventorytype("FixtAuraGiver");
            toucher.giveinventorytype("FixtAuradefGiver");
            toucher.giveinventorytype("FixtAuradmgGiver");
            toucher.giveinventorytype("fixationaura");
            for(int i = 0; i < maxproj;i++)
            {
                let proj = Spawn('FixationAuraCircle', toucher.pos);
                if (proj)
                {
                    proj.angle = angle+(i*(360/maxproj));
                    // Assign the orbiting projectile's target
                    // so that it won't disapepar.
                    proj.target = toucher;
                }
            }


            // Remove this item from play.
            GoAwayAndDie();
            return true;
        }
    }
}

class FixtAuraTriangles : Inventory
{
    override bool TryPickup(out Actor toucher)
    {
        // Spawn an orbiting projectile at the toucher's position.
        let maxproj = 8;
        for(int i = 0; i < maxproj;i++)
        {
            let proj = Spawn('FireAura', toucher.pos);
            if (proj)
            {
                proj.angle = angle+(i*(360/maxproj));
                // Assign the orbiting projectile's target
                // so that it won't disapepar.
                proj.target = toucher;
            }
        }
        // Remove this item from play.
        GoAwayAndDie();
        return true;
    }
}

class FixtAuraTrianglesOthers : Inventory
{
    override bool TryPickup(out Actor toucher)
    {
        // Spawn an orbiting projectile at the toucher's position.
        let maxproj = 8;
        for(int i = 0; i < maxproj;i++)
        {
            let proj = Spawn('FireAuraOthers', toucher.pos);
            if (proj)
            {
                proj.angle = angle+(i*(360/maxproj));
                // Assign the orbiting projectile's target
                // so that it won't disapepar.
                proj.target = toucher;
            }
        }
        // Remove this item from play.
        GoAwayAndDie();
        return true;
    }
}

class FireAura: FixationAuraCircle
{
    states
    {
        spawn:

        rotate:

            FRAU AAAABBBBBCCCCDDDDDEEEEFFFFGGGG 1 light("FireSprite") BRIGHT
            {
                A_Orbit(48, 1, 3, TRUE);
            }
            tnt1 a 0 a_jumpifintargetinventory("FixationAura",1,"rotate");
            stop;

    }
}


class FireAuraOthers: FireAura
{
    states
    {
        spawn:
        checkded:
            //dont know why it has to check twice, but it works if either one of them is missing le shrug
            tnt1 a 0 a_jumpif(countinv("fixationaura",aaptr_target) > 0,"rotate");
            tnt1 a 0 a_jumpifintargetinventory("fixationaura",1,"rotate");
            tnt1 a 0 { return resolvestate("NULL"); }
        rotate:
            FRAU AAAABBBBBCCCCDDDDDEEEEFFFFGGGG 1 light("FireSprite") BRIGHT
            {
                A_Orbit(48, 1, 3, TRUE);
            }

            tnt1 a 0 a_checkProximity("Checkded","fixationauracircle",512,1);
            stop;

    }
}

class FixationAuraCircleOthers : FixationAuraCircle
{
    states
    {
        spawn:
        checkded:
            tnt1 a 0 a_jumpif(countinv("fixationaura",aaptr_target) > 0,"rotate");
            tnt1 a 0 a_jumpifintargetinventory("fixationaura",1,"rotate");
            tnt1 a 0 { return resolvestate("spinend"); }
        rotate:
            Fixt a 1 light("wraithSprite") BRIGHT
            {
               A_Orbit(0, 1, 3);
               a_giveinventory("fixtauradmggiver",1,AAPTR_Target);
                a_giveinventory("fixtauradefgiver",1,AAPTR_Target);
                a_giveinventory("fixtauragiver",1,AAPTR_Target);
            }
            tnt1 a 0 a_checkProximity("Checkded","fixationauracircle",512,1);
            tnt1 a 0 a_takeinventory("fixationaura",1,0,aaptr_target);
            //stop;
            goto spinend;
    }
}

class FixationAuraCircle : OrbitingProjectile
{
    int user_ticcount;
    default
    {
        +flatSprite
        Renderstyle "AddStencil";
        +bright
        Stencilcolor "Goldenrod";
        +nointeraction
        +floorhugger
        -CastSpriteShadow
       // Alpha 0.45;
        scale 0.5;
    }
    states
    {
        spawn:
        tnt1 a 0 { user_ticcount = 0; }
        rotate:
            FIXT A 1 light("WraithSprite") BRIGHT
            {
                A_Orbit(0, 1, 3);
                a_giveinventory("fixtauradmggiver",1,AAPTR_Target);
                a_giveinventory("fixtauradefgiver",1,AAPTR_Target);
                a_giveinventory("fixtauragiver",1,AAPTR_Target);
                if (++user_ticcount % 5 == 0)
                {
                    a_radiusgive("fixtauraitemothers",512.0,RGF_PLAYERS|RGF_NOSIGHT,1);
                }
                if(user_ticcount > 60)
                    user_ticcount = 0;
            }
            tnt1 a 0 a_jumpifintargetinventory("FixationAura",1,"rotate");
        spinend:
            FIXT A 1 light("WraithSprite") BRIGHT
            {
               // a_log("aura going down");
                  A_Orbit(0, 1, 3);
                  if (alpha > 0.0)
                  {
                    alpha -=0.1;
                    a_setrenderstyle(alpha,STYLE_AddStencil);
                  }
                  else
                  {
                    //a_log("no more aura");
                    return resolvestate("trueend");
                  }
                  return resolvestate(Null);
            }
            loop;
            trueend:
            tnt1 a 0;
            stop;

    }
}
