import Foundation

let explosionCategory: UInt32 = 0x1 << 0
let enemyWarheadCategory: UInt32 = 0x1 << 1
let playerSiloCategory: UInt32 = 0x1 << 2

let collisionBetweenEnemyWarheadAndExplosion = enemyWarheadCategory | explosionCategory
let collisionBetweenPlayerSiloAndExplosion = playerSiloCategory | explosionCategory
