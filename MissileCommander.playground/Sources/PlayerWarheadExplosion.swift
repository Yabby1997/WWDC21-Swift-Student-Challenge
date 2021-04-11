import SpriteKit

public class PlayerWarheadExplosion: SKSpriteNode {
    let explosionSound = soundPlayer(sound: "Audios/friendly_explosion.wav")
    
    public init(position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: "Sprites/player_warhead_explosion.png"), color: .clear, size: CGSize(width: 30, height: 30))
        self.position = position
        
        guard let explosionSound = explosionSound else { return }
        explosionSound.play()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
