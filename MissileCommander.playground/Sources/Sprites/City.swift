
import SpriteKit

public class City: SKSpriteNode {
    init(position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: "Sprite/city.png"), color: .clear, size: CGSize(width: 30, height: 30))
        self.position = position
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = playerCityCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
