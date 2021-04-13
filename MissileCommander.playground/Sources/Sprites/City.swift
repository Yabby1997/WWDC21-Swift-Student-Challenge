
import SpriteKit

public class City: SKSpriteNode {
    init(position: CGPoint) {
        super.init(texture: SKTexture(imageNamed: "Sprites/silo.png"), color: .clear, size: CGSize(width: 50, height: 50))
        self.zPosition = -1
        self.position = position
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
