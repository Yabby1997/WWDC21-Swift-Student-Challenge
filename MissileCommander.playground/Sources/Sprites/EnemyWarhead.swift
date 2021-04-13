import SpriteKit

public class EnemyWarhead: Warhead {
    override init(position: CGPoint, distance: CGFloat, velocity: CGFloat, targetCoordinate: CGPoint, blastRange: Int, gameScene: SKScene) {
        super.init(position: position, distance: distance, velocity: velocity, targetCoordinate: targetCoordinate, blastRange: blastRange, gameScene: gameScene)
        
        self.color = .red
        self.colorBlendFactor = 1.0
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = enemyWarheadCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        launch()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func launch() {
        let actionMove = SKAction.move(to: self.targetCoordinate, duration: self.duration)
        let actionRemove = SKAction.removeFromParent()
        let actionExplode = SKAction.run { self.explode() }
        self.run(SKAction.sequence([actionMove, actionRemove, actionExplode]))
    }
    
    func explode() {
        let explosion = EnemyExplosion(position: self.position, blastRange: self.blastRange, chainingCombo: 0)
        self.gameScene.addChild(explosion)
    }
}
