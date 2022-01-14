version "4.7.1"

#include "source/Projectiles.zs"
#include "source/Classes.zs"
#include "source/Weapons/Paladin/FixationAura.zs"
#include "source/Weapons/weaponbase.zs"
#include "source/Weapons/Paladin/Mace.zs"
//#include "source/HUD.zs"





class GetInput : EventHandler
{

    override bool InputProcess (InputEvent e)
   {
      if (e.Type == InputEvent.Type_KeyDown && automapactive == false) // not when automap is active
        if(e.keyScan == 256 || e.keyScan == 257)
            sendnetworkEvent("mousepress", e.keyscan);
        else
         SendNetworkEvent("keypress", e.KeyScan);

      return false;
   }


   override void NetworkProcess(ConsoleEvent e)
   {
      if (e.Name == "keypress")
             //console.printf("%d", e.Args[0]);

             let player = players [e.Player].mo;
             //player.fireweapon(null);
        else if (e.Name == "mousepress")
        {
            switch(e.Args[0])
            {
                case 256:
                   // console.printf("pew pew");
                    break;
                case 257:
                    //console.printf("alt pew pew");
                    break;
            }
        }
   }




}
