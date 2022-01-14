class OrbitingProjectile : Actor
{
    Default
    {
        +nointeraction
    }

    States
    {
        Spawn:
            TNT1 A 1 BRIGHT A_Orbit(32, 32, 20);
            Loop;
    }

    //===========================================================================
    //
    // OrbitingProjectile::A_Orbit
    //
    // Orbits around this actor's target. Destroys itself without a target.
    // Parameters:
    // - orbitDist: distance from the target actor's center;
    // - orbitHeight: distance from the target actor's feet;
    // - angleDelta: amount to increase the angle with each call.
    //
    // To make the projectile orbit faster:
    // 1) increase angleDelta (but at the cost of losing precision) OR
    // 2) call this function more often. In this example it is called
    //    every 4 ticks as defined in the Spawn state. Try calling it more often
    //    and see what happens.
    //
    //===========================================================================
    void A_Orbit(double orbitDist, double orbitHeight, double angleDelta, bool reverseRotation = false)
    {
        // Disappear without a target.
        if (!target)
        {
            Destroy();
        }
        else
        {
            // Calculate the new position.
            let newPos = target.Vec3Angle(orbitDist, angle, target.Floorclip + orbitHeight);

            // Move to the newly calculated position.
            SetOrigin(newPos, true);
            // Increase the angle.
            if (reverseRotation)
                angle -=angleDelta;
            else
                angle += angleDelta;
        }
    }
}