class Paladin : clericplayer
{
    int tickcount;
    bool ManaRegeneration;
    bool StaminaRegeneration;

    property ManaRegeneration : ManaRegeneration;
    property StaminaRegeneration : StaminaRegeneration;
    default
    {
        Player.displayName "Paladin";
        Player.StartItem "PaladinMace";
        Player.WeaponSlot 1, "PaladinMace";
        Player.startitem "mana2",200;
        Player.startitem "mana1",200;
        +dontBlast
        Paladin.StaminaRegeneration true;
        Paladin.ManaRegeneration true;
    }
    override void Tick()
	{
        Super.Tick();
		if (!player || !player.mo || player.mo != self)
        {
            return;
        }
        tickcount++;
        if(tickcount == 5) // regen every 5th tick
        {
            ManaRegen();
            tickcount = 0;
        }

	}
    void ManaRegen()
    {
        //mana and stamina is 200 base for cleric
        if(countinv("Mana1") >= 200)
            setinventory("mana1",200);
        else if(ManaRegeneration)
            giveinventory("Mana1",1);

         if(countinv("Mana2") >= 200)
            setinventory("mana2",200);
        else if(StaminaRegeneration)
            giveinventory("Mana2",1);
    }
}