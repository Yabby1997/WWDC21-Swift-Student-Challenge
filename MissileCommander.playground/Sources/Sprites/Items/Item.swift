import SpriteKit

public class Item: SKSpriteNode {
    let gameScene: SKScene
    var mutateCount: Int
    
    public init(texture: SKTexture, position: CGPoint, mutateCount: Int = 0, gameScene: SKScene) {
        self.gameScene = gameScene
        self.mutateCount = mutateCount
        super.init(texture: texture, color: .clear, size: CGSize(width: 30, height: 30))
        
        self.zPosition = 1
        self.position = position
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.mutate()
        }
    }
    
    func mutate() {
        if mutateCount < 3 {
            let randomPick = Int.random(in: 1...5)
            var randomItem: Item?
            switch randomPick {
            case 1:
                randomItem = Ammunition(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            case 2:
                randomItem = Blast(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            case 3:
                randomItem = Duration(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            case 4:
                randomItem = Reload(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
            case 5:
                randomItem = Speed(position: self.position, mutateCount: self.mutateCount + 1, gameScene: self.gameScene)
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
