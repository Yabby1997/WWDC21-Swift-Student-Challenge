import SpriteKit

public class PlayerExplosion: Explosion {
    let explosionSound = soundPlayer(sound: "Audio/friendly_explosion.wav")

    override init(position: CGPoint, blastRange: Int) {
        super.init(position: position, blastRange: blastRange)
        
        self.physicsBody?.categoryBitMask = playerExplosionCategory
        
        guard let explosionSound = explosionSound else { return }
        explosionSound.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + GameScene.explosionDuration) {
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
