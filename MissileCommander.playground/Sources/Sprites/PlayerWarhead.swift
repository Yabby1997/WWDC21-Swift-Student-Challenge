import SpriteKit

public class PlayerWarhead: Warhead {
    let missileLaunchSound = soundPlayer(sound: "Audio/launch.wav")
    
    override init(position: CGPoint, distance: CGFloat, velocity: CGFloat, targetCoordinate: CGPoint, blastRange: Int, gameScene: SKScene) {
        super.init(position: position, distance: distance, velocity: velocity, targetCoordinate: targetCoordinate, blastRange: blastRange, gameScene: gameScene)
        
        self.line.strokeColor = .white
        
        launch()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func playLaunchSound() {
        guard let missileLaunchSound = missileLaunchSound else { return }
        missileLaunchSound.play()
    }
    
    func launch() {
        playLaunchSound()
        let actionMove = SKAction.move(to: self.targetCoordinate, duration: self.duration)
        let actionRemove = SKAction.removeFromParent()
        let actionExplode = SKAction.run { self.explode() }
        self.run(SKAction.sequence([actionMove, actionRemove, actionExplode]))
    }

    func explode() {
        let explosion = PlayerExplosion(position: self.position, blastRange: self.blastRange)
        self.gameScene.addChild(explosion)
    }
}
