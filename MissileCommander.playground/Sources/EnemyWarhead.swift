
import SpriteKit

public class EnemyWarhead: SKSpriteNode {
    var velocity: CGFloat
    var distance: CGFloat
    var explodeRadius: CGFloat
    var targetCoordinate: CGPoint
    
    var duration: TimeInterval {
        return TimeInterval(self.distance / self.velocity)
    }
    
    public init(position: CGPoint, velocity: CGFloat, distance: CGFloat, explodeRadius: CGFloat, targetCoordinate: CGPoint) {
        self.velocity = velocity
        self.distance = distance
        self.explodeRadius = explodeRadius
        self.targetCoordinate = targetCoordinate
        super.init(texture: SKTexture(imageNamed: "Sprites/warhead_small_enemy.png"), color: .clear, size: CGSize(width: 5, height: 5))
        self.position = position
        
        move()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func move() {
        let action = SKAction.move(to: self.targetCoordinate, duration: duration)
        let actionDone = SKAction.removeFromParent()
        self.run(SKAction.sequence([action, actionDone]))
    }
}
