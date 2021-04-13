import SpriteKit

public class EnemyExplosion: Explosion {
    let explosionSound = soundPlayer(sound: "Audio/hostile_explosion.wav")

    override init(position: CGPoint, blastRange: Int) {
        super.init(position: position, blastRange: blastRange)
        self.color = .systemGray6
        self.colorBlendFactor = 1.0
        
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
