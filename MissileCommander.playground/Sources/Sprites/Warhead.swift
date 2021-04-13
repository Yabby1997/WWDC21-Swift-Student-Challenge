import SpriteKit

public class Warhead: SKSpriteNode {
    var duration: TimeInterval
    var targetCoordinate: CGPoint
    
    public init(position: CGPoint, distance: CGFloat, velocity: CGFloat, targetCoordinate: CGPoint, blastRange: Int) {
        self.duration = TimeInterval(distance / velocity)
        self.targetCoordinate = targetCoordinate
        
        super.init(texture: SKTexture(imageNamed: "Sprite/warhead_\(blastRange).png"), color: .clear, size: CGSize(width: blastRange, height: blastRange))
        
        self.position = position
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
