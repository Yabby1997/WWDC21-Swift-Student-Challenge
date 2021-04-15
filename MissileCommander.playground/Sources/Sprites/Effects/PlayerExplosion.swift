import SpriteKit

public class PlayerExplosion: Explosion {
    let explosionSound = soundPlayer(sound: "Audio/friendly_explosion.wav")

    override init(position: CGPoint, blastRange: Int, gameScene: GameScene) {
        super.init(position: position, blastRange: blastRange, gameScene: gameScene)
        
        self.physicsBody?.categoryBitMask = playerExplosionCategory
        self.physicsBody?.contactTestBitMask = self.physicsBody!.contactTestBitMask | ammunitionItemCategory | blastItemCategory | speedItemCategory | durationItemCategory | reloadItemCategory
        
        guard let explosionSound = explosionSound else { return }
        explosionSound.play()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.gameScene.getExplosionDuration()) {
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
