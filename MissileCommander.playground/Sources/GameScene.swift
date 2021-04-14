
import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    private var siloLocation: [Int] = [1, 10, 19]
    private var silos: [Silo] = []
    private var cityLocation: [Int] = [] //[1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13]
    private var cities: [City] = []
    private var randomTargetLocation: Int? {
        let candidates = cityLocation + siloLocation
        if candidates.isEmpty {
            self.gameOver()
            return nil
        } else {
            return candidates.randomElement()
        }
    }
    
    private var isGameOver: Bool = false
    private var raidClock: Timer!
    private var explosionChainingDelay: Double = 0.2
    
    // MARK: - Player static status
    private var playerScore: UInt64 = 0 {
        didSet {
            scoreLabel?.text = "\(playerScore)"
        }
    }
    
    var scoreLabel: SKLabelNode?
    
    static var playerMaximumMissileCapacity: Int = 5
    static var playerMissileReloadTime: Double = 2.0
    static var playerMissileVelocity: CGFloat = 200
    static var playerExplosionBlastRange: Int = 60
    static var playerExplosionDuration: Double = 1.0
    
    // MARK: - Enemy static status
    static var enemyWarheadsPerEachRaid: Int = 30
    static var enemyWarheadRaidDuration: Double = 10.0
    static var enemyExplosionDuration: Double = 1.0
    
    public override func didMove(to view: SKView) {
        print("TEST21")
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.0
        
        self.backgroundColor = .black
        self.physicsWorld.contactDelegate = self
        
        loadFont(font: "PressStart2P-vaV7")
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
        
        case collisionBetweenEnemyWarheadAndPlayerExplosion:
            let enemyWarhead = (contact.bodyA.categoryBitMask == enemyWarheadCategory ? nodeA : nodeB) as! EnemyWarhead
            enemyWarhead.removeFromParent()
            let blastRange = enemyWarhead.blastRange
            self.playerScore = self.playerScore + UInt64(blastRange)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + explosionChainingDelay) {
                let newExplosion = EnemyExplosion(position: contact.contactPoint, blastRange: blastRange, chainingCombo: 1)
                self.addChild(newExplosion)
            }
            
        case collisionBetweenEnemyWarheadAndEnemyExplosion:
            let enemyWarhead = (contact.bodyA.categoryBitMask == enemyWarheadCategory ? nodeA : nodeB) as! EnemyWarhead
            let enemyExplosion = (contact.bodyA.categoryBitMask == enemyExplosionCategory ? nodeA : nodeB) as! EnemyExplosion
            enemyWarhead.removeFromParent()
            let blastRange = enemyWarhead.blastRange
            let combo = enemyExplosion.chainingCombo
            self.playerScore = self.playerScore + UInt64(blastRange * (combo * 10) * (combo < 5 ? 1 : 10))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + explosionChainingDelay) {
                let newExplosion = EnemyExplosion(position: contact.contactPoint, blastRange: blastRange, chainingCombo: combo == 0 ? 0 : combo + 1)
                self.generateComboLabel(combo: combo, position: contact.contactPoint, range: blastRange)
                self.addChild(newExplosion)
            }
            
        case collisionBetweenPlayerSiloAndEnemyExplosion, collisionBetweenPlayerSiloAndPlayerExplosion:
            let silo = (contact.bodyA.categoryBitMask == playerSiloCategory ? nodeA : nodeB) as! Silo
            removeSiloFromGameScene(targetSilo: silo)
            silo.removeFromParent()
            
        default:
            print("missing collision type")
        }
    }
    
    func raid(timeInterval: TimeInterval) {
        if !isGameOver {
            raidClock?.invalidate()
            raidClock = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(generateEnemyWarhead), userInfo: nil, repeats: true)
        }
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
    
    func removeSiloFromGameScene(targetSilo: Silo) {
        guard let targetIndex = self.silos.firstIndex(of: targetSilo) else { return }
        self.silos.remove(at: targetIndex)
        self.siloLocation.remove(at: targetIndex)
    }
    
    func getDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        let xDistance = from.x - to.x
        let yDistance = from.y - to.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
    
    func gameOver() {
        self.isGameOver = true
        self.raidClock.invalidate()
        generateGameOverLabel()
    }
    
    // MARK: - Generating sprites
    func generateGameOverLabel() {
        let gameOverLabel = SKLabelNode(fontNamed: "PressStart2P")
        gameOverLabel.text = "GAME OVER"
        gameOverLabel.fontSize = 30
        gameOverLabel.fontColor = .white
        gameOverLabel.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOverLabel.zPosition = 1
        self.addChild(gameOverLabel)
    }
    
    func generateComboLabel(combo: Int, position: CGPoint, range: Int) {
        if combo != 0 {
            let comboLabel = SKLabelNode(fontNamed: "PressStart2P")
            comboLabel.text = combo == 1 ? "\(combo) COMBO" : "\(combo) COMBOS"
            comboLabel.fontSize = 12
            comboLabel.fontColor = combo < 5 ? SKColor.yellow : SKColor.red
            comboLabel.position = CGPoint(x: position.x, y: position.y + CGFloat(range / 2))
            comboLabel.zPosition = 1
            self.addChild(comboLabel)
            
            let wait = SKAction.wait(forDuration: 2)
            let remove = SKAction.run { comboLabel.removeFromParent() }
            self.run(SKAction.sequence([wait, remove]))
        }
    }
    
    @objc func generateEnemyWarhead() {
        for _ in 1...GameScene.enemyWarheadsPerEachRaid {
            guard let randomTargetX = self.randomTargetLocation else {
                print("no targets are available")
                return
            }
            
            let toX = randomTargetX * 30
            let to = CGPoint(x: toX, y: 25)
            let fromX = Int.random(in: 1...600)
            let from = CGPoint(x: fromX, y: 500)
            
            let distance = getDistance(from: from, to: to)
            let velocity = CGFloat.random(in: 50...125)
            let blastRange = [30, 40, 50, 60].randomElement()!
            let enemyWarhead = EnemyWarhead(position: from, distance: distance, velocity: velocity, targetCoordinate: to, blastRange: blastRange, gameScene: self)
            addChild(enemyWarhead)
        }
        
        guard let randomTargetX = self.randomTargetLocation else {
            print("no targets are available")
            return
        }
        
        let toX = randomTargetX * 30
        let to = CGPoint(x: toX, y: 25)
        let fromX = Int.random(in: 1...600)
        let from = CGPoint(x: fromX, y: 500)
        
        let distance = getDistance(from: from, to: to)
        let velocity = CGFloat.random(in: 50...125)
        let blastRange = 300
        let enemyWarhead = EnemyWarhead(position: from, distance: distance, velocity: velocity, targetCoordinate: to, blastRange: blastRange, gameScene: self)
        addChild(enemyWarhead)
    }
    
    func generateScoreLabel() {
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
