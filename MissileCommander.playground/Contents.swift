import SpriteKit
import PlaygroundSupport

let skView = SKView(frame: CGRect(x: 0, y: 0, width: 1000, height: 1500))

let gameScene = GameScene(size: CGSize(width: 1000, height: 1500))
gameScene.scaleMode = .aspectFit
skView.presentScene(gameScene)
skView.preferredFramesPerSecond = 60
skView.showsFPS = true
skView.showsNodeCount = true

PlaygroundPage.current.liveView = skView
