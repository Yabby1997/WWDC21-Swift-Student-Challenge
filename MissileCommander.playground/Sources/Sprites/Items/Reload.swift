import SpriteKit

public class Reload: Item {
    init(position: CGPoint, gameScene: SKScene) {
        super.init(texture: SKTexture(imageNamed: "Sprite/reload.png"), position: position, gameScene: gameScene)
        
        self.physicsBody?.categoryBitMask = reloadItemCategory
        
        self.color = .blue
        self.colorBlendFactor = 1.0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func removeFromParent() {
        guard let gameScene = gameScene as? GameScene else { return }
        if GameScene.playerMissileReloadTime > 3.0 {
            GameScene.playerMissileReloadTime = GameScene.playerMissileReloadTime - 1.0
        } else {
            gameScene.score(amount: 10000)
        }
        super.removeFromParent()
    }
}

