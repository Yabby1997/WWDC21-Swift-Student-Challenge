import SpriteKit

public class Explosion: SKSpriteNode {
    let hostileExplosionSound = soundPlayer(sound: "Audio/hostile_explosion.wav")
    let friendlyExplosionSound = soundPlayer(sound: "Audio/friendly_explosion.wav")

    public init(position: CGPoint, isHostile: Bool, blastRange: Int) {
        super.init(texture: SKTexture(imageNamed: "Sprite/explosion_\(blastRange).png"), color: .clear, size: CGSize(width: blastRange, height: blastRange))
        self.position = position
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = explosionCategory
        self.physicsBody?.contactTestBitMask = enemyWarheadCategory | playerSiloCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        
        if isHostile {
            self.color = .red
            guard let explosionSound = hostileExplosionSound else { return }
            explosionSound.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + GameScene.enemyExplosionDuration) {
                self.removeFromParent()
            }
        } else {
            guard let explosionSound = friendlyExplosionSound else { return }
            explosionSound.play()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + GameScene.playerExplosionDuration) {
                self.removeFromParent()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
