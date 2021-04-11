import SpriteKit

public class PlayerWarhead: SKSpriteNode {
    var velocity: CGFloat
    var distance: CGFloat
    var explodeRadius: CGFloat
    var targetCoordinate: CGPoint
    let missileLaunchSound = soundPlayer(sound: "Audios/launch.wav")
    var gameScene: SKScene
    
    var duration: TimeInterval {
        return TimeInterval(self.distance / self.velocity)
    }
    
    public init(position: CGPoint, distance: CGFloat, velocity: CGFloat, explodeRadius: CGFloat, targetCoordinate: CGPoint, gameScene: SKScene) {
        self.velocity = velocity
        self.distance = distance
        self.explodeRadius = explodeRadius
        self.targetCoordinate = targetCoordinate
        self.gameScene = gameScene
        super.init(texture: SKTexture(imageNamed: "Sprites/warhead_small_friendly.png"), color: .clear, size: CGSize(width: 5, height: 5))
        self.position = position
        
        guard let missileLaunchSound = missileLaunchSound else { return }
        missileLaunchSound.play()
        
        move()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move() {
        let action = SKAction.move(to: self.targetCoordinate, duration: duration)
        let actionDone = SKAction.removeFromParent()
        let actionExplode = SKAction.run { self.explode() }
        self.run(SKAction.sequence([action, actionDone, actionExplode]))
    }
    
    func explode() {
        let explosion = PlayerWarheadExplosion(position: self.position)
        gameScene.addChild(explosion)
    }
}
