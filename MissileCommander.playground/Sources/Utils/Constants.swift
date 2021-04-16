import Foundation

let playerExplosionCategory: UInt32 = 0x1 << 0
let enemyExplosionCategory: UInt32 = 0x1 << 1
let enemyWarheadCategory: UInt32 = 0x1 << 2
let playerSiloCategory: UInt32 = 0x1 << 3
let playerCityCategory: UInt32 = 0x1 << 4
let enemyBomberCategory: UInt32 = 0x1 << 5
let ammunitionItemCategory: UInt32 = 0x1 << 6
let blastItemCategory: UInt32 = 0x1 << 7
let durationItemCategory: UInt32 = 0x1 << 8
let reloadItemCategory: UInt32 = 0x1 << 9
let velocityItemCategory: UInt32 = 0x1 << 10
let siloItemCategory: UInt32 = 0x1 << 11
let cityItemCategory: UInt32 = 0x1 << 12

let collisionBetweenEnemyWarheadAndPlayerExplosion = enemyWarheadCategory | playerExplosionCategory
let collisionBetweenEnemyWarheadAndEnemyExplosion = enemyWarheadCategory | enemyExplosionCategory
let collisionBetweenPlayerSiloAndEnemyExplosion = playerSiloCategory | enemyExplosionCategory
let collisionBetweenPlayerSiloAndPlayerExplosion = playerSiloCategory | playerExplosionCategory
let collisionBetweenPlayerCityAndEnemyExplosion = playerCityCategory | enemyExplosionCategory
let collisionBetweenPlayerCityAndPlayerExplosion = playerCityCategory | playerExplosionCategory
let collisionBetweenEnemyBomberAndPlayerExplosion = enemyBomberCategory | playerExplosionCategory
let collisionBetweenEnemyBomberAndEnemyExplosion = enemyBomberCategory | enemyExplosionCategory
let collisionBetweenAmmunitionItemAndPlayerExplosion = ammunitionItemCategory | playerExplosionCategory
let collisionBetweenBlastItemAndPlayerExplosion = blastItemCategory | playerExplosionCategory
let collisionBetweenDurationItemAndPlayerExplosion = durationItemCategory | playerExplosionCategory
let collisionBetweenReloadItemAndPlayerExplosion = reloadItemCategory | playerExplosionCategory
let collisionBetweenVelocityItemAndPlayerExplosion = velocityItemCategory | playerExplosionCategory
let collisionBetweenSiloItemAndPlayerExplosion = siloItemCategory | playerExplosionCategory
let collisionBetweenCityItemAndPlayerExplosion = cityItemCategory | playerExplosionCategory
