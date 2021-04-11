import SpriteKit

public class PlayerWarheadExplosion: SKSpriteNode {
    let explosionSound = soundPlayer(sound: "Audios/friendly_explosion.wav")
    
    public init(position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: "Sprites/player_warhead_explosion.png"), color: .clear, size: CGSize(width: 30, height: 30))
        self.position = position
        
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = playerExplosionCategory
        self.physicsBody?.contactTestBitMask = enemyWarheadCategory
        self.physicsBody?.collisionBitMask = 0
        
        guard let explosionSound = explosionSound else { return }
        explosionSound.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.removeFromParent()
        }
    }
    

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
