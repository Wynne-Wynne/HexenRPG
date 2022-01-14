class PaladinMace : WeaponBase //CWeapMace
{
    int User_macedmg;
    Default
	{
		Weapon.SelectionOrder 3500;
		Weapon.KickBack 1500;
		Weapon.YAdjust -8;
		+BLOODSPLATTER
        +Weapon.noalert
        WeaponBase.MainAttackCost 0,10; // multiples of this are used for different combo costs
        weaponbase.ChargeAttackCost 0,30;
        weaponbase.SecondaryAttackCost 0,15;
        weaponbase.SpecialAttackCost 80,0;
        weaponbase.SupportSkillCost 0,0;
		Tag "Mace of Attrition";

	}
    override void PostBeginPlay()
    {
        super.PostBeginPlay();
        User_macedmg = 0;
    }

	States
	{
	Select:
		CMCE A 1 A_Raise;
		Loop;
	Deselect:
		CMCE A 1 A_Lower;
		Loop;
	Ready:
        TNT1 a 0
        {
            invoker.User_macedmg = 0;
        }
    RealReady:
		CMCE A 1 A_WeaponReady(WRF_allowReload|WRF_ALLOWZOOM);
		Loop;
    Hold:
        CMCE A 1 A_WeaponReady(WRF_NOFIRE|WRF_allowReload|WRF_ALLOWZOOM);
        CMCE A 0 A_Refire("Hold");
        goto ready;
    AltHold:
        CMCE A 32 A_WeaponReady(WRF_NOSecondary|WRF_allowReload|WRF_ALLOWZOOM);
        CMCE A 0 A_Refire("Hold");
        goto ready;
    //normal mace attack (raise up)
    Fire:
        tnt1 a 0 A_CheckAttackResource(WAC_MAINATTACK,null,"hold");
        tnt1 a 0 a_takeResource(WAC_MAINATTACK);
        CMCE A 1 Offset (4,34) ;
        CMCE B 1 Offset (15, 16);
        CMCE B 3 Offset (30, 33);
        CMCE B 5 Offset (60, 20)
        {
            A_Setpitch(pitch-1, SPF_INTERPOLATE);
            A_setangle(angle-1, SPF_INTERPOLATE);
        }
    //"charge up" mace
        tnt1 a 0 a_refire("MaceHold");
        goto macecontinue;
    MaceHold:
        CMCE B 2
        {
            paladin(self).StaminaRegeneration = false;
            if(invoker.User_macedmg < 20)
            {
                invoker.User_macedmg+=1;
                if(countinv("mana2") > 0) takeinventory("mana2",1);
            }

            A_CheckResource(1,"mana2",null,"MaceContinue");
        }
        tnt1 a 0 a_refire("MaceHold");
        tnt1 a 0 { paladin(self).StaminaRegeneration = true; }
    //swing mace down (combo 1)
    MaceContinue:
        CMCE B 2 Offset (60, 20);
		CMCE B 1 Offset (30, 33);
		CMCE B 2 Offset (8, 45);
		CMCE C 1 Offset (8, 45) a_recoil(-8-(invoker.User_maceDMG/10.0));
		CMCE D 1 Offset (8, 45);
		CMCE E 1 Offset (8, 45);
		CMCE E 1 Offset (-11, 58)
        {
            A_setpitch(pitch+1,SPF_INTERPOLATE);
            A_setangle(angle+1,SPF_INTERPOLATE);
            A_MaceAttack(invoker.User_macedmg + 35,invoker.User_macedmg + 60);

        }
		CMCE F 1 Offset (8, 45);
		CMCE F 2 Offset (-8, 74);
		CMCE F 1 Offset (-20, 96);
		CMCE F 4 Offset (-33, 160);
        CMCE F 4
        {
            A_settics(invoker.User_macedmg/4.0);
            invoker.User_macedmg = 0;
        }
        CMCE FFFFFFFFFFFFFFFFFF 1 a_checkcombocontinue("fire2","altfire");
    //weapon rise attack (combo 2)
    raisewep:
		CMCE A 2 Offset (8, 75);
		CMCE A 1 Offset (8, 65);
		CMCE A 2 Offset (8, 60);
		CMCE A 1 Offset (8, 55) a_setpitch(Pitch-1, SPF_INTERPOLATE);
		CMCE A 2 Offset (8, 50)
        {
            a_setpitch(Pitch-1, SPF_INTERPOLATE);
            A_SetAngle(Angle-1, SPF_INTERPOLATE);
        }
        CMCE A 0 A_Refire("Hold");
		CMCE A 1 Offset (8, 45);
		Goto Ready;

    fire2:
        tnt1 a 0 a_takeresource(WAC_MAINATTACK);
        CMCE F 2 Offset (-33,160);
        CMCE F 1 Offset (-20,160);
        CMCE E 1 Offset (-6,96) a_recoil(-3);
        CMCE D 1 Offset (-4,90);
        CMCE D 1 Offset (2,90)
        {
            A_setpitch(pitch-1,SPF_INTERPOLATE);
            A_setangle(angle-1,SPF_INTERPOLATE);
            A_MaceAttack(30,45,5,1);
        }
        CMCE C 1 Offset (22,96);
        CMCE C 2 Offset (55,110);
        CMCE C 2 Offset (55,120);
        CMCE C 5 Offset (60,130);
        CMCE CCCCCCCCCCCCCCC 1 a_checkcombocontinue("fire3","altfire");
    lowerwep:
        CMCE C 2 Offset (55,130);
        CMCE C 2 Offset (50,140);
        CMCE C 1 Offset (40,150);
        CMCE C 1 Offset (30,155);
        CMCE D 1 Offset (27,150);
        CMCE D 1 Offset (20,160)
        {
            a_setpitch(Pitch+1, SPF_INTERPOLATE);
            A_SetAngle(Angle+1, SPF_INTERPOLATE);
        }
        CMCE A 1 Offset (10,160);
        goto raisewep;

    fire3:
        tnt1 a 0 a_takeresource(WAC_MAINATTACK);
        CMCE C 1 Offset (30, 130);
        CMCE C 1 Offset (50, 115);
        CMCE C 1 Offset (90, 100);
        CMCE C 1 Offset (150, 90);
        CMCE C 2 Offset (180, 80);
        TNT1 A 4;
        CMCE G 2 Offset (0,60);
        CMCE G 1 Offset (-20,60);
        CMCE H 1 Offset (-55, 60)
        {
            A_setangle(angle+1,SPF_INTERPOLATE);
            A_MaceAttack(75,100,16);
            A_startsound("PalaGrunt",2);
            A_recoil(-5);
        }
        CMCE H 1 Offset (-75, 60);
        CMCE I 1 ;
        CMCE I 1 Offset (-90, 60);
        CMCE I 2 Offset (-100, 60);
        CMCE I 12 Offset (-105, 60);
        CMCE I 4 Offset (-110, 80) A_setangle(angle-1,SPF_INTERPOLATE);
        CMCE I 1 Offset (-112, 100);// A_setangle(angle-1,SPF_INTERPOLATE);
        CMCE I 1 Offset (-112, 100);// A_setangle(angle-1,SPF_INTERPOLATE);
        CMCE I 1 Offset (-113, 130);// A_setangle(angle-1,SPF_INTERPOLATE);
        CMCE I 1 Offset (-115, 160);// A_setangle(angle-1,SPF_INTERPOLATE);
        TNT1 A 0 A_refire("hold");
        goto ready;
    //shove
    altfire:
        tnt1 a 0 a_checkattackresource(WAC_SECONDARYATTACK,null,"althold");
        tnt1 a 0 A_weaponready(WRF_NoSwitch|WRF_NOFIRE|WRF_allowReload|WRF_ALLOWZOOM);
        CMCE A 1;
        MACB F 1 A_recoil(-5);
        MACB E 1 A_setangle(angle+1,SPF_INTERPOLATE);
        MACB D 1;
        MACB C 1;
        MACB B 8
        {
            a_takeresource(WAC_SECONDARYATTACK);
            A_macePush(18);
        }
        MACB B 5 Offset (-4,28);
        MACB C 5 Offset (-8,25);
        MACB D 4 Offset (-10,20);
        MACB E 3 A_Setangle(angle-1,SPF_INTERPOLATE);
        MACB F 2;
        MACB F 2 Offset (-8,25);
        MACB F 2 Offset (-4,28);
        goto altHold;

    Zoom:
        tnt1 a 0
        {
            if(countinv("fixationaura") < 1)
                giveinventory("fixtauraitem",1);
        }
        goto ready;
    Reload:
        tnt1 a 0 a_checkattackresource(WAC_SPECIALATTACK,null,"reloadhold",WSC_NOMANA);
        tnt1 a 0 a_jumpifinventory("Powerpetrifycooldown",1,"reloadhold");
        tnt1 a 0 a_jumpifinventory("Powerpetrifycooldownshort",1,"reloadhold");
        MPTR A 2
        {
            a_startsound("Petrcharge");
            if(countinv("fixationaura") > 0)
                A_setblend("goldenrod",.1,25,"goldenrod",0.3);
        }
        MPTR B 2;
        MPTR C 13;
        MPTR D 2 BRIGHT;
        MPTR E 2 BRIGHT;
        MPTR E 2 BRIGHT;
        MPTR F 2 BRIGHT
        {
            a_alertmonsters();
            A_explode(60,360.,XF_NOTMISSILE,true);
            a_light(2);

            if(countinv("fixationaura") > 0)
            {
                A_setblend("light goldenrod",.9,25);
                a_macespray();
                a_Startsound("Petr");
                a_giveinventory("PetrifyCooldown",1);
                a_takeresource(WAC_SPECIALATTACK);
            }
            else
            {
                A_setblend("goldenrod",.9,15);
                a_Startsound("Petr2");
                a_giveinventory("PetrifyCooldownshort",1);
                A_explode(40,360.,XF_NOTMISSILE,true);
                a_takeresource(WAC_SPECIALATTACK);
                a_giveinventory("mana1",40); //manually override it here, not normal behavior
            }

        }
        MPTR C 1 a_light(1);
        MPTR C 4 a_light(0);
        MPTR B 4;
        MPTR A 3;

        ReloadHold:
        CMCE A 1 A_WeaponReady(WRF_ALLOWZOOM);
        CMCE A 1
        {
            A_WeaponReady(WRF_ALLOWZOOM);
            int input = GetPlayerInput(INPUT_BUTTONS);
            if ( (input & BT_Reload))
            {
               return resolvestate("RELOADHOLD");
            }
            return resolvestate(null);
        }
        goto ready;

	}




    action void A_MacePush(int recoil)
    {
        FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, 1 * DEFMELEERANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, 1 * DEFMELEERANGE, slope, 10, 'Melee', "PainPuff", true, t);

					if (t.linetarget != null)
					{
						AdjustPlayerAngle(t);
                        A_alertMonsters();
                        if (t.linetarget.bIsMonster || t.linetarget.player)
						{
							t.linetarget.Thrust(recoil, t.attackAngleFromSource);
						}
						return;
					}
				}
			}
		}
		// didn't find any creatures, so try to strike any walls
		weaponspecial = 0;

		double slope = AimLineAttack (angle, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle, DEFMELEERANGE, slope, 1, 'Melee', "PainPuff");
    }

    action void A_MaceAttack(int min_dmg, int max_dmg, int recoil = 8, int dist_fact = 2)
	{
		FTranslatedLineTarget t;

		if (player == null)
		{
			return;
		}

		int damage = random[MaceAtk](min_dmg, max_dmg);// 25-40 default
		for (int i = 0; i < 16; i++)
		{
			for (int j = 1; j >= -1; j -= 2)
			{
				double ang = angle + j*i*(45. / 16);
				double slope = AimLineAttack(ang, dist_fact * DEFMELEERANGE, t, 0., ALF_CHECK3D);
				if (t.linetarget)
				{
					LineAttack(ang, dist_fact * DEFMELEERANGE, slope, damage, 'Melee', "HammerPuff", true, t);
					if (t.linetarget != null)
					{
						AdjustPlayerAngle(t);
                        A_alertMonsters();
                        if (t.linetarget.bIsMonster || t.linetarget.player)
						{
							t.linetarget.Thrust(recoil, t.attackAngleFromSource);
						}
						return;
					}
				}
			}
		}
		// didn't find any creatures, so try to strike any walls
		weaponspecial = 0;

		double slope = AimLineAttack (angle, DEFMELEERANGE, null, 0., ALF_CHECK3D);
		LineAttack (angle, DEFMELEERANGE, slope, damage, 'Melee', "HammerPuff");
	}

	action void A_MaceSpray()
	{
		int damage;
		FTranslatedLineTarget t;

		//Set parameters
		class<Actor> spraytype = "PetrifiedPuff";
		int numrays = 160;
		double ang = 360.;
		double distance = 360.;
		double vrange = 64.;
        int defdamage = 1;

		Actor originator = self;

		// offset angles from its attack ang
		for (int i = 0; i < numrays; i++)
		{
			double an = angle - ang / 2 + ang / numrays*i;

			originator.AimLineAttack(an, distance, t, vrange);
            actor target = self;

            //we found a monster we didn't hit already
			if (t.linetarget != null && t.linetarget.findinventory("petrify")==null && t.linetarget.bISMONSTER && !t.linetarget.bBoss)
			{
                t.linetarget.giveinventory("petrify",1);
				Actor spray = Spawn(spraytype, t.linetarget.pos + (0, 0, t.linetarget.Height / 4), ALLOW_REPLACE);

				int dmgFlags = 0;
				Name dmgType = 'MaceSplash';

                //check if spray spawned succesfully
				if (spray != null)
				{
					if ((target.GetSpecies() == t.linetarget.GetSpecies()) ||
					target == t.linetarget)
					{
						spray.Destroy();
						continue;
					}
					spray.target = target;
                    spray.tracer = t.linetarget;
					dmgType = spray.DamageType;
				}

                damage = defdamage;
                //apply damage
				int newdam = t.linetarget.DamageMobj(originator, self, damage, dmgType, dmgFlags|DMG_USEANGLE, t.angleFromSource);
				t.TraceBleed(newdam > 0 ? newdam : damage, self);
			}
		}
	}
}

class nullpuff : bulletpuff
{
    default
    {
        +BLOODLESSIMPACT
    }
    states
    {
        tnt1 a 0;
        stop;
    }
}

class PowerPetrifyCooldown : Powerup
{
    default
    {
        Powerup.duration -12;
    }
}

class powerPetrifyCooldownShort : PowerPetrifyCooldown
{
    default
    {
        powerup.duration -6;
    }
}

class PetrifyCooldown : Powerupgiver
{
    default
    {
        Powerup.Type "PowerPetrifyCooldown";
        +inventory.AUTOACTIVATE
    }
}

class PetrifyCooldownshort : Powerupgiver
{
    default
    {
        Powerup.Type "PowerPetrifyCooldownshort";
        +inventory.AUTOACTIVATE
    }
}

class petrify : inventory
{
    default
    {
        inventory.maxamount 1;
    }
    states
    {
        held:
        tnt1 a 210;
        stop;
    }
}

class PetrifiedPuff : Actor
{
    default
    {
        scale 0.4;
        +NOBLOCKMAP
		+NOGRAVITY
        +FORCEXYBILLBOARD
        +PUFFONACTORS
        +PUFFGETSOWNER
        +HITTRACER
        //+forcepain
    }
    states
    {
        spawn:
        PETR AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 light("WraithSprite") BRIGHT
        {

            A_Warp(AAPTR_TRACER, 2, 0, 32, 0, WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE,null,0);
            if ( !tracer ) return ResolveState(null);
           // tracer.bDORMANT = true;
            tracer.a_settranslation("petrify");
            tracer.BNOBLOOD = true;
            tracer.bBuddha = true;
            tracer.bNOPAIN = true;
             for ( int i=0; i<8; i++ ) tracer.A_StopSound(i);
            if ( tracer.FindState("Pain") )
				tracer.SetStateLabel("Pain");
			tracer.A_SetTics(-1);
            for ( int i=0; i<8; i++ ) tracer.A_StopSound(i);
			return ResolveState(null);


        }
        PETR AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 light("WraithSprite") BRIGHT
        {

            A_Warp(AAPTR_TRACER, 2, 0, 32, 0, WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE,null,0);
            if ( !tracer ) return ResolveState(null);
           // tracer.bDORMANT = true;

            //tracer.a_pain();
            for ( int i=0; i<8; i++ ) tracer.A_StopSound(i);
            if ( tracer.FindState("Pain") )
				tracer.SetStateLabel("Pain");
			tracer.A_SetTics(-1);
            for ( int i=0; i<8; i++ ) tracer.A_StopSound(i);
			return ResolveState(null);
        }

        PETR AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 light("WraithSprite") BRIGHT
        {
            if ( !tracer ) return ResolveState(null);
            A_Warp(AAPTR_TRACER, 2, 0, 32, 0, WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE,null,0);
            return ResolveState(null);

        }
        tnt1 a 0
        {
            if ( !tracer ) return ResolveState(null);
            tracer.bBuddha = false;
            tracer.BNOBLOOD = false;
            tracer.bNOPAIN = true;
            tracer.a_SetTics(1);
            tracer.a_settranslation("normal");

            int gibscount = random(16,24);
            a_startsound("rocksmash");
            tracer.a_pain();
            a_damagetracer(10);
            for(int i = 0;i<gibscount;i++)
            {
                Actor gibs = Spawn("PetrifyChunk",tracer.pos);
                gibs.vel = (frandom(-3,3), frandom(-3,3), frandom(3,6));
            }


            return ResolveState(null);
        }
        PETR AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA 1 light("WraithSprite") BRIGHT
        {
             A_Warp(AAPTR_TRACER, 2, 0, 32, 0, WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE,null,0);
        }
        decay:
        PETR A  1 light("WraithSprite") BRIGHT
        {
             A_Warp(AAPTR_TRACER, 2, 0, 32, 0, WARPF_NOCHECKPOSITION|WARPF_INTERPOLATE,null,0);
            A_fadeout();
        }
        loop;
        Crash:
        tnt1 a 0;
        stop;
    }
}

class PetrifyChunk : icechunk
{
    default
    {
        Translation "Petrify";
        +bright
    }
}

class PainPuff : PunchPuff
{
    default
    {
        +forcepain
        +NOBLOOD
        +BLOODLESSIMPACT
        damagetype "Normal";
    }

    states
    {
        spawn:

            tnt1 a 0 nodelay
            {
                A_Blast(BF_DONTWARN|BF_ONLYVISIBLETHINGS,64,32,8,null,"null");
            }
            //FHFX STUVW 4;
            stop;
    }
}
