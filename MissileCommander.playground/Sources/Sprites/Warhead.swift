import SpriteKit

public class Warhead: SKSpriteNode {
    var duration: TimeInterval
    var targetCoordinate: CGPoint
    var blastRange: Int
    var gameScene: SKScene
    
    public init(position: CGPoint, distance: CGFloat, velocity: CGFloat, targetCoordinate: CGPoint, blastRange: Int, gameScene: SKScene) {
        self.duration = TimeInterval(distance / velocity)
        self.targetCoordinate = targetCoordinate
        self.blastRange = blastRange
        self.gameScene = gameScene
        
        let warheadSize = getWarheadSize(blastRange: self.blastRange)
        
        super.init(texture: SKTexture(imageNamed: "Sprite/warhead_\(warheadSize).png"), color: .clear, size: CGSize(width: warheadSize, height: warheadSize))
        
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
