
import SpriteKit
import AVFoundation

protocol siloDelegate {
    func silo(warhead: PlayerWarhead, scene: SKScene)
}

public class Silo: SKSpriteNode{
    var delegate: siloDelegate?
    var nextLaunchTime: TimeInterval
    
    var reloadTime: CGFloat {
        let reloadTimeBonus = CGFloat((scene as! GameScene).cities.count)
        return 5.0 - (0.2 * reloadTimeBonus)
    }
    
    var isLoaded: Bool {
        guard let currentTime = (scene as! GameScene).globalCurrentTime else { return false }
        let loaded = self.nextLaunchTime <= currentTime
        return loaded
    }
    
    init(position: CGPoint) {
        nextLaunchTime = 0.0
        super.init(texture: SKTexture(imageNamed: "Sprites/silo.png"), color: .clear, size: CGSize(width: 50, height: 50))
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // make a new instance of friendly warhead and make it's destination to coordinate
    func shoot(coordinate: CGPoint, distance: CGFloat) {
        playSound(sound: "Audios/launch.wav")
        guard let currentTime = (scene as! GameScene).globalCurrentTime else { return }
        self.nextLaunchTime = currentTime + Double(reloadTime)
        let projectile = PlayerWarhead(position: self.position, distance: distance, velocity: 75, explodeRadius: 0.5, targetCoordinate: coordinate)
        delegate?.silo(warhead: projectile, scene: self.delegate as! SKScene)
    }
}
