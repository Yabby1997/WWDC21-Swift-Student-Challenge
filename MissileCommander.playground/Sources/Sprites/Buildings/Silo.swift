
import SpriteKit
import AVFoundation

public class Silo: SKSpriteNode{
    var gameScene: SKScene
    var numOfLoadedMissiles: Int {
        didSet { self.changeTexture() }
    }
    var isLoaded: Bool {
        return self.numOfLoadedMissiles > 0
    }
    
    init(position: CGPoint, gameScene: SKScene) {
        self.numOfLoadedMissiles = GameScene.playerMaximumMissileCapacity
        self.gameScene = gameScene
        super.init(texture: SKTexture(imageNamed: "Sprite/silo_\(GameScene.playerMaximumMissileCapacity).png"), color: .clear, size: CGSize(width: 30, height: 30))
        self.position = position
        
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = playerSiloCategory
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.usesPreciseCollisionDetection = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        if self.numOfLoadedMissiles < GameScene.playerMaximumMissileCapacity {
            self.numOfLoadedMissiles = self.numOfLoadedMissiles + 1
        }
    }
    
    func changeTexture() {
        let siloTexture = SKTexture(imageNamed: "Sprite/silo_\(numOfLoadedMissiles).png")
        let action = SKAction.setTexture(siloTexture, resize: false)
        self.run(action)
    }
    
    func shoot(coordinate: CGPoint, distance: CGFloat) {
        let playerWarhead = PlayerWarhead(position: self.position,
                                          distance: distance,
                                          velocity: GameScene.playerMissileVelocity,
                                          targetCoordinate: coordinate,
                                          blastRange: GameScene.playerExplosionBlastRange,
                                          gameScene: self.gameScene)
        
        self.numOfLoadedMissiles = self.numOfLoadedMissiles - 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + GameScene.playerMissileReloadTime) {
            self.reload()
        }
        
        self.gameScene.addChild(playerWarhead)
    }
}
