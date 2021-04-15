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
    
    public override func removeFromParent() {
        guard let gameScene = gameScene as? GameScene else { return }
        if GameScene.playerExplosionBlastRange < 60 {
            GameScene.playerExplosionBlastRange = GameScene.playerExplosionBlastRange + 10
        } else {
            gameScene.score(amount: 10000)
        }
        super.removeFromParent()
    }
}

