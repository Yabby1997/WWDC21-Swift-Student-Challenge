import SpriteKit

public class EnemyExplosion: Explosion {
    let explosionSound = soundPlayer(sound: "Audio/hostile_explosion.wav")
    let chainingCombo: Int
    
    init(position: CGPoint, blastRange: Int, chainingCombo: Int) {
        self.chainingCombo = chainingCombo
        super.init(position: position, blastRange: blastRange)
        self.color = .systemGray6
        self.colorBlendFactor = 1.0
        
        self.physicsBody?.categoryBitMask = enemyExplosionCategory
        
        guard let explosionSound = explosionSound else { return }
        explosionSound.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + GameScene.playerExplosionDuration) {
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
