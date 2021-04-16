import SpriteKit

public class Item: SKSpriteNode {
    let gameScene: SKScene
    var mutateCount: Int
    
    public init(texture: SKTexture = SKTexture(imageNamed: "Sprite/ammunition.png"), position: CGPoint, mutateCount: Int = -1, gameScene: SKScene) {
        self.gameScene = gameScene
        self.mutateCount = mutateCount
        super.init(texture: texture, color: .clear, size: CGSize(width: 30, height: 30))
        
        self.zPosition = 1
        self.position = position
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        let wait = SKAction.wait(forDuration: 3)
        let mutating = SKAction.run { self.mutate() }
        self.run(SKAction.sequence([wait, mutating]))
    }
    
    func mutate() {
        if mutateCount < 3 {
            let randomPick = Int.random(in: 1...7)
            var randomItem: Item?
            switch randomPick {
            case 1:
                randomItem = AmmunitionItem(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            case 2:
                randomItem = BlastItem(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            case 3:
                randomItem = DurationItem(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            case 4:
                randomItem = ReloadItem(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            case 5:
                randomItem = VelocityItem(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            case 6:
                randomItem = SiloItem(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            case 7:
                randomItem = CityItem(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            default:
                print("missing item pick")
            }
            guard let pickedItem = randomItem else { return }
            self.gameScene.addChild(pickedItem)
        }
        self.removeFromParent()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
