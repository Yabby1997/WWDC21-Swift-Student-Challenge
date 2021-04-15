import SpriteKit

public class Speed: Item {
    init(position: CGPoint, mutateCount: Int = 0, gameScene: SKScene) {
        super.init(texture: SKTexture(imageNamed: "Sprite/speed.png"), position: position, mutateCount: mutateCount, gameScene: gameScene)
        
        self.physicsBody?.categoryBitMask = speedItemCategory
        
        self.color = .green
        self.colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

