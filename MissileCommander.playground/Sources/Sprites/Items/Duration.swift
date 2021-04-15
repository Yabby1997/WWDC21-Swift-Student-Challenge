import SpriteKit

public class Duration: Item {
    init(position: CGPoint, gameScene: SKScene) {
        super.init(texture: SKTexture(imageNamed: "Sprite/duration.png"), position: position, gameScene: gameScene)
        
        self.physicsBody?.categoryBitMask = durationItemCategory
        
        self.color = .orange
        self.colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func removeFromParent() {
        guard let gameScene = gameScene as? GameScene else { return }
        if GameScene.explosionDuration < 2.0 {
            GameScene.explosionDuration = GameScene.explosionDuration + 0.5
        } else {
            gameScene.score(amount: 10000)
        }
        super.removeFromParent()
    }
}

