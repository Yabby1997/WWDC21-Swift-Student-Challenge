import SpriteKit

public class Blast: Item {
    init(position: CGPoint, gameScene: SKScene) {
        super.init(texture: SKTexture(imageNamed: "Sprite/blast.png"), position: position, gameScene: gameScene)
        
        self.physicsBody?.categoryBitMask = blastItemCategory
        
        self.color = .red
        self.colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

