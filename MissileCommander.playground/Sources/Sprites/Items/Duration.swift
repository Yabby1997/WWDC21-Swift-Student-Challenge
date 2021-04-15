import SpriteKit

public class Duration: Item {
    init(position: CGPoint, mutateCount: Int = 0, gameScene: SKScene) {
        super.init(texture: SKTexture(imageNamed: "Sprite/duration.png"), position: position, mutateCount: mutateCount, gameScene: gameScene)
        
        self.physicsBody?.categoryBitMask = durationItemCategory
        
        self.color = .orange
        self.colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

