import Foundation

let playerExplosionCategory: UInt32 = 0x1 << 0
let enemyExplosionCategory: UInt32 = 0x1 << 1
let enemyWarheadCategory: UInt32 = 0x1 << 2
let playerSiloCategory: UInt32 = 0x1 << 3
let playerCityCategory: UInt32 = 0x1 << 4
let enemyBomberCategory: UInt32 = 0x1 << 5

let collisionBetweenEnemyWarheadAndPlayerExplosion = enemyWarheadCategory | playerExplosionCategory
let collisionBetweenEnemyWarheadAndEnemyExplosion = enemyWarheadCategory | enemyExplosionCategory
let collisionBetweenPlayerSiloAndEnemyExplosion = playerSiloCategory | enemyExplosionCategory
let collisionBetweenPlayerSiloAndPlayerExplosion = playerSiloCategory | playerExplosionCategory
let collisionBetweenPlayerCityAndEnemyExplosion = playerCityCategory | enemyExplosionCategory
let collisionBetweenPlayerCityAndPlayerExplosion = playerCityCategory | playerExplosionCategory
let collisionBetweenEnemyBomberAndPlayerExplosion = enemyBomberCategory | playerExplosionCategory
let collisionBetweenEnemyBomberAndEnemyExplosion = enemyBomberCategory | enemyExplosionCategory
