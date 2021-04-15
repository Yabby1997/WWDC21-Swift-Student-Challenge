
import SpriteKit
import AVFoundation

public class Silo: SKSpriteNode{
    var gameScene: GameScene
    var numOfLoadedMissiles: Int {
        didSet { self.changeTexture() }
    }
    var isLoaded: Bool {
        return self.numOfLoadedMissiles > 0
    }
    
    init(position: CGPoint, gameScene: GameScene) {
        self.gameScene = gameScene
        self.numOfLoadedMissiles = self.gameScene.getMissileCapacity()
        super.init(texture: SKTexture(imageNamed: "Sprite/silo_\(self.numOfLoadedMissiles).png"), color: .clear, size: CGSize(width: 30, height: 30))
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
        if self.numOfLoadedMissiles < self.gameScene.getMissileCapacity() {
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
                                          velocity: self.gameScene.getMissileVelocity(),
                                          targetCoordinate: coordinate,
                                          blastRange: self.gameScene.getExplosionBlastRange(),
                                          gameScene: self.gameScene)
        
        self.numOfLoadedMissiles = self.numOfLoadedMissiles - 1
        
        DispatchQueue.main.asyncAfter(deadline: .now() + self.gameScene.getMissileReloadTime()) {
            self.reload()
        }
        
        self.gameScene.addChild(playerWarhead)
    }
}
