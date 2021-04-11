import SpriteKit
import PlaygroundSupport
import CoreGraphics

let skView = SKView(frame: CGRect(x: 0, y: 0, width: 600, height: 500))

let gameScene = GameScene(size: CGSize(width: 1200, height: 1000))
gameScene.scaleMode = .aspectFit
skView.presentScene(gameScene)
skView.preferredFramesPerSecond = 60
skView.showsFPS = true
skView.showsNodeCount = true

PlaygroundPage.current.liveView = skView
