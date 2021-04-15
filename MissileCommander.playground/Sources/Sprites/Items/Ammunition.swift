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
    
    public override func removeFromParent() {
        guard let gameScene = gameScene as? GameScene else { return }
        if GameScene.playerMaximumMissileCapacity < 5 {
            GameScene.playerMaximumMissileCapacity = GameScene.playerMaximumMissileCapacity + 1
            gameScene.reloadAllSilos()
        } else {
            gameScene.score(amount: 10000)
        }
        super.removeFromParent()
    }
}

