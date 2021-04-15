import SpriteKit

public class Warhead: SKSpriteNode {
    var duration: TimeInterval
    var targetCoordinate: CGPoint
    var blastRange: Int
    var gameScene: GameScene
    var line: SKShapeNode = SKShapeNode()
    var lineWidth: CGFloat
    var lineColor: UIColor = .white
    
    public init(position: CGPoint, distance: CGFloat, velocity: CGFloat, targetCoordinate: CGPoint, blastRange: Int, gameScene: GameScene) {
        self.duration = TimeInterval(distance / velocity)
        self.targetCoordinate = targetCoordinate
        self.blastRange = blastRange
        self.gameScene = gameScene
        self.lineWidth = getLineWidth(blastRange: self.blastRange)
        
        let warheadSize = getWarheadSize(blastRange: self.blastRange)
        
        super.init(texture: SKTexture(imageNamed: "Sprite/warhead_\(warheadSize).png"), color: .clear, size: CGSize(width: warheadSize, height: warheadSize))
        
        self.zPosition = -10
        self.position = position
        
        let wait = SKAction.wait(forDuration: 0.01)
        let updatePath = SKAction.run {
            self.visualizePath(from: position, to: self.position)
        }
        self.run(SKAction.repeatForever(SKAction.sequence([updatePath, wait])))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func visualizePath(from: CGPoint, to: CGPoint) {
        line.removeFromParent()
        let path = CGMutablePath()
        path.move(to: from)
        path.addLine(to: to)
        line = SKShapeNode(path: path)
        line.strokeColor = self.lineColor
        line.lineWidth = self.lineWidth
        line.zPosition = -10
        self.gameScene.addChild(line)
    }
    
    func removePath(delay: Double) {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.line.removeFromParent()
        }
    }
    
    public override func removeFromParent() {
        self.removePath(delay: self.gameScene.getExplosionDuration())
        super.removeFromParent()
    }
}
