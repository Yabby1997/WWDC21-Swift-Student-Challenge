import SpriteKit

public class Item: SKSpriteNode {
    let gameScene: SKScene
    
    public init(texture: SKTexture, position: CGPoint, gameScene: SKScene) {
        self.gameScene = gameScene
        super.init(texture: texture, color: .clear, size: CGSize(width: 30, height: 30))
        
        self.zPosition = 1
        self.position = position
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
