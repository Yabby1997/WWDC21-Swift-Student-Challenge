
import SpriteKit
import AVFoundation

protocol siloDelegate {
    func silo(warhead: PlayerWarhead, scene: SKScene)
}

public class Silo: SKSpriteNode{
    var delegate: siloDelegate?
    var nextLaunchTime: TimeInterval
    var numOfLoadedMissiles: Int
    var reloadClock: Timer!
    
    var currentTime: TimeInterval {
        return (scene as! GameScene).globalCurrentTime!
    }
    
    var reloadTime: Double {
        let reloadTimeBonus = (scene as! GameScene).cities.count
        return 5.0 - (0.2 * Double(reloadTimeBonus))
    }
    
    var isLoaded: Bool {
        return self.numOfLoadedMissiles > 0
    }
    
    init(position: CGPoint) {
        nextLaunchTime = 0.0
        self.numOfLoadedMissiles = GameScene.maximumMissileCapacity
        super.init(texture: SKTexture(imageNamed: "Sprites/silo_\(GameScene.maximumMissileCapacity).png"), color: .clear, size: CGSize(width: 30, height: 30))
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        if self.numOfLoadedMissiles < GameScene.maximumMissileCapacity {
            self.numOfLoadedMissiles = self.numOfLoadedMissiles + 1
            self.changeTexture()
        }
    }
    
    func changeTexture() {
        let siloTexture = SKTexture(imageNamed: "Sprites/silo_\(numOfLoadedMissiles).png")
        let action = SKAction.setTexture(siloTexture, resize: false)
        self.run(action)
    }
    
    // make a new instance of friendly warhead and make it's destination to coordinate
    func shoot(coordinate: CGPoint, distance: CGFloat) {
        guard let currentTime = (scene as! GameScene).globalCurrentTime else { return }
        self.nextLaunchTime = currentTime + Double(reloadTime)
        let projectile = PlayerWarhead(position: self.position, distance: distance, velocity: 200, explodeRadius: 0.5, targetCoordinate: coordinate)
        
        self.numOfLoadedMissiles = self.numOfLoadedMissiles - 1
        changeTexture()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + reloadTime) {
            self.reload()
        }
        
        delegate?.silo(warhead: projectile, scene: self.delegate as! SKScene)
    }
}
