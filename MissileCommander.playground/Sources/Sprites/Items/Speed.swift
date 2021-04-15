import SpriteKit

public class Speed: Item {
    init(position: CGPoint, gameScene: SKScene) {
        super.init(texture: SKTexture(imageNamed: "Sprite/speed.png"), position: position, gameScene: gameScene)
        
        self.physicsBody?.categoryBitMask = speedItemCategory
        
        self.color = .green
        self.colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func removeFromParent() {
        guard let gameScene = gameScene as? GameScene else { return }
        if GameScene.playerMissileVelocity < 450 {
            GameScene.playerMissileVelocity = GameScene.playerMissileVelocity + 150
        } else {
            gameScene.score(amount: 10000)
        }
        super.removeFromParent()
    }
}

