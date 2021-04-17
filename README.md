# 🚀 Missile Commander
![Screenshots/missilecommander.gif](Screenshots/missilecommander.gif)
Missile Commander is a retro style shooting game inspired by Missile Command(1979). I used Spritekit to implement all the functionalities, pixilart.com to draw sprite textures, Bfxr to mix the sound effects. 
I made this game because I think making a game with a new language is one of the best way to learn that language.

## Goal
The goal of this game is to survive from enemy attack and earn as many score as possible. 

## Buildings
![Screenshots/silo_5.png](Screenshots/silo_5.png)
Silo can shoot missile to protect your city and silo itself. You can have 3 silos. If all of your silos destroyed, you lose the game.

![Screenshots/city.png](Screenshots/city.png) 
You should protect city from enemy attack. You can have 6 cities. If all of your cities destroyed, you lose the game.

## Enemy
![Screenshots/warhead_5.png](Screenshots/warhead_5.png)
![Screenshots/warhead_7.png](Screenshots/warhead_7.png)
Enemy warheads will appear and falling down to destroy all of your buildings. You should shoot the counter projectile to destroy warhead before it reach to the target.

![Screenshots/warhead_11.png](Screenshots/warhead_11.png)
Tzar is the biggest enemy warhead. It's blast range is so big that you have be careful to dealing with it.

![Screenshots/bomber.png](Screenshots/bomber.png)
 Bomber will fly by over your buildings and drop bunch of warheads. 

## Play
![Screenshots/shooting.gif](Screenshots/shooting.gif)
You can shoot counter projectile by clicking the exact point you want on the GameScene, and counter projectile will be launched from one of your silos, and terminate the enemy attack. 

## Items
Items will be appeared on GameScene to help you. 
![Screenshots/ammunition.gif](Screenshots/ammunition.gif)
A - Ammunition. It will increase your silo's maximum missile capacity and reload it.
![Screenshots/blast.gif](Screenshots/blast.gif)
B - Blast Range. It will increase your projectile's explosion blast range.
![Screenshots/city.gif](Screenshots/city.gif)
C - City. It will rebuild the city if available.
![Screenshots/duration.gif](Screenshots/duration.gif)
D - Duration, It will increase the duration of all explosions.
![Screenshots/reload.gif](Screenshots/reload.gif)
R - Reload Time. It will decrease the time to reload projectile.
![Screenshots/silo.gif](Screenshots/silo.gif)
S - Silo. It will rebuild the silo if available.
![Screenshots/velocity.gif](Screenshots/velocity.gif)
V - Velocity. It will increase the velocity of your projectiles.
![Screenshots/maxlevel.gif](Screenshots/maxlevel.gif)
If your ability is already at max level, you will get + 10000 score instead.
![Screenshots/mutating.gif](Screenshots/mutating.gif)
Item will be mutated every 5 seconds, so you can wait for what you want. But, it will be disappear after mutating 3 times so you have to be careful.

## Difficulty
Enemy attacks will be getting stronger every 30 seconds. Actually, difficulty of this game is designed to eliminate you in about 3 minutes. But if you managed to survive from 3 minutes of intense enemy attack, there will be "Hell" difficulty waiting for you. I'm pretty sure that you CAN NOT survive from it.

## Score
There is a chaining explosion combo system in this game. If you terminate the enemy attack, than it will explode too. So you can chaining these explosions. Combo will be multiply your score. So it really helps you to earn more score.