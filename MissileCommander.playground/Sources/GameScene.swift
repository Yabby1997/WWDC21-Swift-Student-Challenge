
import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    public var silos: [Silo] = []
    public var cities: [City] = []
    public var siloLocation = [1, 10, 19]
    public var cityLocation = [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13]
    public var raidClock: Timer!
    
    // MARK: - Player static status
    var playerScore: Int = 0 {
        didSet {
            scoreLabel?.text = "\(playerScore)"
        }
    }
    
    var scoreLabel: SKLabelNode?
    
    static var playerMaximumMissileCapacity: Int = 5
    static var playerMissileReloadTime: Double = 5.0
    static var playerMissileVelocity: CGFloat = 200
    static var playerMissileBlastRange: Int = 5
    static var playerExplosionDuration: Double = 1.0
    static var playerExplosionChainingDelay: Double = 0.2
    
    // MARK: - Enemy static status
    static var enemyWarheadsPerEachRaid: Int = 4
    static var enemyWarheadRaidDuration: Double = 10.0
    
    public override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.0
        
        self.backgroundColor = .black
        self.physicsWorld.contactDelegate = self
        
        generateScoreLabel()
        generateSilos()
        raid(timeInterval: GameScene.enemyWarheadRaidDuration)
    }
    
    // MARK: - Collision
    public func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        switch collision {
        case collisionBetweenPlayerExplosionAndEnemyWarhead:
            let enemyWarhead = (contact.bodyA.categoryBitMask == enemyWarheadCategory ? nodeA : nodeB) as! EnemyWarhead
            enemyWarhead.removeFromParent()
            
            self.playerScore = self.playerScore + 1
            
            DispatchQueue.main.asyncAfter(deadline: .now() + GameScene.playerExplosionChainingDelay) {
                let newExplosion = PlayerWarheadExplosion(position: contact.contactPoint)
                self.addChild(newExplosion)
            }
        default:
            print("missing collision type")
        }
    }
    
    func raid(timeInterval: TimeInterval) {
        raidClock?.invalidate()
        raidClock = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(generateEnemyWarhead), userInfo: nil, repeats: true)
    }
    
    // MARK: - Player click input
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            guard let closestAvailableSiloInfo = getClosestAvailableSiloInfo(targetCoordinate: location) else { return }
            let silo = closestAvailableSiloInfo.0
            let distance = closestAvailableSiloInfo.1
            silo.shoot(coordinate: location, distance: distance)
        }
    }
    
    func getClosestAvailableSiloInfo(targetCoordinate: CGPoint) -> (Silo, CGFloat)? {
        var closestDistance: CGFloat = 10_000
        var closestSilo: Silo?
        
        for silo in self.silos {
            if silo.isLoaded {
                let currentDistance = getDistance(from: silo.position, to: targetCoordinate)
                if currentDistance.isLess(than: closestDistance) {
                    closestDistance = currentDistance
                    closestSilo = silo
                }
            }
        }
        return (closestSilo, closestDistance) as? (Silo, CGFloat)
    }
    
    func getDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        let xDistance = from.x - to.x
        let yDistance = from.y - to.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
    
    // MARK: - Generating sprites
    @objc func generateEnemyWarhead() {
        let candidateLocation = cityLocation + siloLocation
        for _ in 1...GameScene.enemyWarheadsPerEachRaid {
            let fromX = Int.random(in: 1...600)
            let toX = candidateLocation.randomElement()! * 30
            let from = CGPoint(x: fromX, y: 500)
            let to = CGPoint(x: toX, y: 25)
            
            let distance = getDistance(from: from, to: to)
            let enemyWarhead = EnemyWarhead(position: from, distance: distance, velocity: 100, targetCoordinate: to, blastRange: 5)
            addChild(enemyWarhead)
        }
    }
    
    func generateScoreLabel() {
        let fontURL = Bundle.main.url(forResource: "Font/PressStart2P-vaV7", withExtension: "ttf")
        CTFontManagerRegisterFontsForURL(fontURL! as CFURL, CTFontManagerScope.process, nil)
        self.scoreLabel = SKLabelNode(fontNamed: "PressStart2P")
        
        self.scoreLabel?.text = "0"
        self.scoreLabel?.fontSize = 20
        self.scoreLabel?.fontColor = SKColor.white
        self.scoreLabel?.position = CGPoint(x: frame.midX, y: 470)
        self.addChild(scoreLabel!)
    }
    
    func generateSilos() {
        for i in siloLocation {
            let x = i * 30
            let y = 25
            let position = CGPoint(x: x, y: y)
            
            let silo = Silo(position: position, gameScene: self)
            silos.append(silo)
            
            addChild(silo)
        }
    }
    
    func generateCities() {
        for i in cityLocation {
            let x = 10 + i * 20
            let y = 25
            let position = CGPoint(x: x, y: y)
            
            let city = City(position: position)
            cities.append(city)
            addChild(city)
        }
    }
}
