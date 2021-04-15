import SpriteKit

public class Ammunition: Item {
    init(position: CGPoint, gameScene: SKScene) {
        super.init(texture: SKTexture(imageNamed: "Sprite/ammunition.png"), position: position, gameScene: gameScene)
        
        self.physicsBody?.categoryBitMask = ammunitionItemCategory
        
        self.color = .yellow
        self.colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

