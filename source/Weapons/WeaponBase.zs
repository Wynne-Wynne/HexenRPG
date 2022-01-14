//thank you to mr  Matt hideous kojima destructor sir for the shortcutenings
//https://forum.zdoom.org/viewtopic.php?f=39&t=62228
Class WeaponBase : Weapon
{
    //extra stuff for a_weaponready
    enum ComboWeaponConstants
    {
        WRF_ALL = WRF_ALLOWRELOAD|WRF_ALLOWZOOM|
                WRF_ALLOWUSER1|WRF_ALLOWUSER2|
                WRF_ALLOWUSER3|WRF_ALLOWUSER4,
        WRF_NONE = WRF_NOFIRE|WRF_DISABLESWITCH,
    };

    Enum WeaponSoundConstants
    {
        WSC_NOMANA,
        WSC_NOSTAMINA,
    };

    Enum WeaponAttackConstants
    {
        WAC_MAINATTACK,
        WAC_CHARGEATTACK,
        WAC_SECONDARYATTACK,
        WAC_SPECIALATTACK,
        WAC_SUPPORTSKILL,
    }

    //boy howdy would i love to have a tuple or a struct for this but
    //le no chicken said it doesnt work that way so fug
    int MainAttackManaCost;
    int MainAttackStaminaCost;
    int ChargeAttackManaCost;
    int ChargeAttackStaminaCost;
    int SecondaryAttackManaCost;
    int SecondaryAttackStaminaCost;
    int SpecialAttackManaCost;
    int SpecialAttackStaminaCost;
    int SupportSkillManaCost;
    int SupportSkillStaminaCost;

    Property MainAttackCost : MainAttackManaCost, MainAttackStaminaCost;
    Property ChargeAttackCost : ChargeAttackManaCost, ChargeAttackStaminaCost;
    Property SecondaryAttackCost : SecondaryAttackManaCost, SecondaryAttackStaminaCost;
    Property SpecialAttackCost : SpecialAttackManaCost, SpecialAttackStaminaCost;
    Property SupportSkillCost :  SupportSkillManaCost, SupportSkillStaminaCost;

    default
    {
        WeaponBase.MainAttackCost 0, 0;
        weaponbase.ChargeAttackCost 0, 0;
        weaponbase.SecondaryAttackCost 0, 0;
        weaponbase.SpecialAttackCost 0, 0;
        weaponbase.SupportSkillCost 0, 0;
    }

    action void A_TakeResource(int AttackType)
    {
        switch(AttackType)
        {
            case WAC_MAINATTACK:
                takeinventory("mana1",invoker.MainAttackManaCost);
                takeinventory("mana2",invoker.MainAttackStaminaCost);
                break;
            case WAC_CHARGEATTACK:
                takeinventory("mana1",invoker.ChargeAttackManaCost);
                takeinventory("mana2",invoker.ChargeAttackStaminaCost);
                break;
            case WAC_SECONDARYATTACK:
                takeinventory("mana1",invoker.SecondaryAttackManaCost);
                takeinventory("mana2",invoker.SecondaryAttackStaminaCost);
                break;
            case WAC_SPECIALATTACK:
                takeinventory("mana1",invoker.SpecialAttackManaCost);
                takeinventory("mana2",invoker.SpecialAttackStaminaCost);
                break;
            case WAC_SUPPORTSKILL:
                takeinventory("mana1",invoker.SupportSkillManaCost);
                takeinventory("mana2",invoker.SupportSkillStaminaCost);
                break;
        }
    }

    //sets a weapon sprite
    action void SetWeaponState(statelabel st,int layer=PSP_WEAPON)
    {
        if(player) player.setpsprite(layer,invoker.findstate(st));
    }

    //player input checks
    action bool PressingFire(){return player.cmd.buttons & BT_ATTACK;}
    action bool PressingAltfire(){return player.cmd.buttons & BT_ALTATTACK;}
    action bool PressingReload(){return player.cmd.buttons & BT_RELOAD;}
    action bool PressingZoom(){return player.cmd.buttons & BT_ZOOM;}
    action bool PressingUser1(){return player.cmd.buttons & BT_USER1;}
    action bool PressingUser2(){return player.cmd.buttons & BT_USER2;}
    action bool PressingUser3(){return player.cmd.buttons & BT_USER3;}
    action bool PressingUser4(){return player.cmd.buttons & BT_USER4;}

    //useful for combos
    action bool JustPressedFire()
    {
        return (player.cmd.buttons & BT_ATTACK && !(player.oldbuttons & BT_ATTACK));
    }
    action bool JustPressedAltFire()
    {
        return (player.cmd.buttons & BT_ALTATTACK && !(player.oldbuttons & BT_ALTATTACK));
    }

    action state A_CheckAttackResource(int AttackType, statelabel StateSuccess, statelabel StateFail, int PlaySound = 0)
    {
        switch(AttackType)
        {
            case WAC_MAINATTACK:
                if(countinv("mana1") >= invoker.mainattackManacost &&
                    countinv("mana2") >= invoker.mainattackStaminacost)
                        return resolvestate(statesuccess);

                break;
            case WAC_CHARGEATTACK:
                 if(countinv("mana1") >= invoker.ChargeattackManacost &&
                    countinv("mana2") >= invoker.ChargeattackStaminacost)
                        return resolvestate(statesuccess);
                break;
            case WAC_SECONDARYATTACK:
                if(countinv("mana1") >= invoker.SecondaryattackManacost &&
                    countinv("mana2") >= invoker.SecondaryattackStaminacost)
                        return resolvestate(statesuccess);
                break;
            case WAC_SPECIALATTACK:
                if(countinv("mana1") >= invoker.SpecialattackManacost &&
                    countinv("mana2") >= invoker.SpecialattackStaminacost)
                        return resolvestate(statesuccess);
                break;
            case WAC_SUPPORTSKILL:
                if(countinv("mana1") >= invoker.SupportSkillManaCost &&
                    countinv("mana2") >= invoker.SupportSkillStaminaCost)
                        return resolvestate(statesuccess);
                break;
        }
        switch(playsound)
        {
            case WSC_NOMANA:
            a_startsound("nomana",0,CHANF_OVERLAP|CHANF_LOCAL);
            break;
            case WSC_NOSTAMINA:
            default:
            break;
        }
        return resolvestate(statefail);
    }

    // customizable version for checking individual costs of any inventory item
    // no function overloading with the previous one because le no chicken
    action state A_CheckResource(int cost, class<Inventory> resource, statelabel statesuccess, statelabel statefail, int playsound = 0)
    {
        if(countinv(resource) > cost)
        {
            return resolvestate(statesuccess);
        }
        switch(playsound)
        {
            case WSC_NOMANA:
            a_startsound("nomana",0,CHANF_OVERLAP|CHANF_LOCAL);
            break;
            case WSC_NOSTAMINA:
            default:
            break;
        }
        return resolvestate(statefail);

    }

    action state A_CheckComboContinue(statelabel ComboContinueState, statelabel AltComboContinueState)
    {
        if(JustPressedfire())
        {
            return a_checkattackresource(WAC_MAINATTACK,ComboContinueState,null);
        }
        if(JustPressedaltfire())
        {
            return a_checkattackresource(WAC_secondaryattack,AltComboContinueState,null);
        }
        return resolvestate(null);
    }
}