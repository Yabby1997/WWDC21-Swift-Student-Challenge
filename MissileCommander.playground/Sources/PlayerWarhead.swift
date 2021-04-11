import SpriteKit

public class PlayerWarhead: SKSpriteNode {
    var velocity: CGFloat
    var distance: CGFloat
    var explodeRadius: CGFloat
    var targetCoordinate: CGPoint
    let missileLaunchSound = soundPlayer(sound: "Audios/launch_2.wav")
    
    var duration: TimeInterval {
        return TimeInterval(self.distance / self.velocity)
    }
    
    public init(position: CGPoint, distance: CGFloat, velocity: CGFloat, explodeRadius: CGFloat, targetCoordinate: CGPoint) {
        self.velocity = velocity
        self.distance = distance
        self.explodeRadius = explodeRadius
        self.targetCoordinate = targetCoordinate
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
        let explode = SKAction.run {
            print("DEBUG : Explode at \(self.position)")
        }
        
        self.run(SKAction.sequence([action, explode, actionDone]))
    }
}
