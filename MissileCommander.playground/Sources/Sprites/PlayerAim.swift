import SpriteKit

public class PlayerAim: SKSpriteNode {
    
    public init(position: CGPoint, duration: TimeInterval) {
        super.init(texture: SKTexture(imageNamed: "Sprite/aim.png"), color: .clear, size: CGSize(width: 15, height: 15))
        self.position = position
        
        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            self.removeFromParent()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
