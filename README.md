# 🚀 Missile Commander
![screenshots/missilecommander.gif](screenshots/missilecommander.gif)  
Missile Commander is a retro style shooting game inspired by Missile Command(1979). I used Spritekit to implement all the functionalities, [pixilart](pixilart.com) to draw sprite textures, [Bfxr](https://www.bfxr.net/) to mix the sound effects. 
I made this game because I think making a game with a new language is one of the best way to learn that language.

## Goal
The goal of this game is to survive from enemy attack and earn as many score as possible.
## Buildings
![screenshots/silo_5.png](screenshots/silo_5.png)
Silo can shoot missile to protect your city and silo itself. You can have 3 silos. If all of your silos destroyed, you lose the game.

![screenshots/city.png](screenshots/city.png) 
You should protect city from enemy attack. You can have 6 cities. If all of your cities destroyed, you lose the game.

## Enemy
![screenshots/warhead_5.png](screenshots/warhead_5.png)
![screenshots/warhead_7.png](screenshots/warhead_7.png)
Enemy warheads will appear and falling down to destroy all of your buildings. You should shoot the counter projectile to destroy warhead before it reach to the target.

![screenshots/warhead_11.png](screenshots/warhead_11.png)
Tzar is the biggest enemy warhead. It's blast range is so big that you have be careful.

![screenshots/bomber.png](screenshots/bomber.png)
 Bomber will fly by and drop bunch of warheads all over your city. So it might be tricky to dealing with it. 

## Play
![screenshots/shooting.gif](screenshots/shooting.gif)  
You can shoot counter projectile by clicking on the game scene. Missile will be launched from the closest silo to the target point. If silo is out of missile, It takes time to reload. 

## Items
Items will be appeared on GameScene to help you.   
![screenshots/ammunition.gif](screenshots/ammunition.gif)  
A - Ammunition. It will increase your silo's maximum missile capacity and reload it.  
![screenshots/blast.gif](screenshots/blast.gif)  
B - Blast Range. It will increase your projectile's explosion blast range.  
![screenshots/city.gif](screenshots/city.gif)  
C - City. It will rebuild the city if available.  
![screenshots/duration.gif](screenshots/duration.gif)  
D - Duration, It will increase the duration of all explosions.  
![screenshots/reload.gif](screenshots/reload.gif)  
R - Reload Time. It will decrease the time to reload projectile.  
![screenshots/silo.gif](screenshots/silo.gif)  
S - Silo. It will rebuild the silo if available.  
![screenshots/velocity.gif](screenshots/velocity.gif)  
V - Velocity. It will increase the velocity of your projectiles.  
![screenshots/maxlevel.gif](screenshots/maxlevel.gif)  
If your ability is already at max level, you will get + 10000 score instead.  
![screenshots/mutating.gif](screenshots/mutating.gif)  
Item will be mutated every 5 seconds, so you can wait for what you want. But, it will be disappear after mutating 3 times so you have to be careful.

## Difficulty
![screenshots/difficulty.gif](screenshots/difficulty.gif)   
Enemy attacks will be getting stronger every 30 seconds. Actually, difficulty of this game is designed to eliminate you in less than 3 minutes. But if you managed to survive from 3 minutes and 30 seconds of intense enemy attack, there will be "Hell" difficulty waiting for you. I'm pretty sure that you CAN NOT survive from it.

## Combo system
![screenshots/combo.gif](screenshots/combo.gif) 
There is a chaining explosion combo system in this game. If you terminate the enemy attack, than it will explode too. So you can chaining these explosions. Combo will be multiply your score. So it really helps you to earn more score.