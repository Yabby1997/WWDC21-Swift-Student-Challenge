
import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    // MARK: - Labels
    var scoreLabel: SKLabelNode?
    var timeLabel: SKLabelNode?
    
    // MARK: - Score and Time
    private var playerScore: UInt64 = 0 {
        didSet {
            scoreLabel?.text = "\(playerScore)"
        }
    }
    
    private var time: Int = 0 {
        didSet {
            setTimeLabel(alwaysDisplayColon: false)
        }
    }
    
    // MARK: - Player buildings
    private var siloLocation: [Int] = [2, 10, 18] {
        didSet {
            if siloLocation.isEmpty {
                self.gameOver()
            }
        }
    }
    private var silos: [Silo] = []
    private var cityLocation: [Int] = [4, 6, 8, 12, 14, 16] {
        didSet {
            if cityLocation.isEmpty {
                self.gameOver()
            }
        }
    }
    
    private var cities: [City] = []
    private var randomTargetLocation: Int? {
        let candidates = cityLocation + siloLocation
        if candidates.isEmpty {
            return nil
        } else {
            return candidates.randomElement()
        }
    }
    
    // MARK: - Game Status
    private var isGameOver: Bool = false
    private var explosionChainingDelay: Double = 0.2
    
    private var isWarheadRaidOn: Bool = true
    private var warheadRaidTimer: Timer!
    private var warheadRaidInterval: Double = 10.0
    private var warheadPerRaid: Int = 10
    
    private var isBomberRaidOn: Bool = true
    private var bomberRaidTimer: Timer!
    private var bomberRaidInterval: Double = 15.0
    private var bomberPerRaid: Int = 1
    
    private var isTzarRaidOn: Bool = true
    private var tzarRaidTimer: Timer!
    private var tzarRaidInterval: Double = 18.0
    private var tzarPerRaid: Int = 1
    
    static var playerMaximumMissileCapacity: Int = 5
    static var playerMissileReloadTime: Double = 1.0
    static var playerMissileVelocity: CGFloat = 200
    static var playerExplosionBlastRange: Int = 60
    static var explosionDuration: Double = 1.0
    
    // MARK: - Entrypoint to GameScene
    public override func didMove(to view: SKView) {
        print("TEST45")
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.0
        
        self.backgroundColor = .black
        self.physicsWorld.contactDelegate = self
        
        loadFont(font: "PressStart2P-vaV7")
        generateTimeLabel()
        generateScoreLabel()
        generateSilos()
        generateCities()
        
        warheadRaid(timeInterval: warheadRaidInterval)
        bomberRaid(timeInterval: bomberRaidInterval)
        tzarRaid(timeInterval: tzarRaidInterval)
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
            
            
        case collisionBetweenEnemyBomberAndPlayerExplosion:
            let bomber = (contact.bodyA.categoryBitMask == enemyBomberCategory ? nodeA : nodeB) as! Bomber
            bomber.removeFromParent()
            let blastRange = 150
            self.playerScore = self.playerScore + UInt64(blastRange)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + explosionChainingDelay) {
                let newExplosion = EnemyExplosion(position: contact.contactPoint, blastRange: blastRange, chainingCombo: 1)
                self.addChild(newExplosion)
            }
            
        case collisionBetweenEnemyBomberAndEnemyExplosion:
            let bomber = (contact.bodyA.categoryBitMask == enemyBomberCategory ? nodeA : nodeB) as! Bomber
            let enemyExplosion = (contact.bodyA.categoryBitMask == enemyExplosionCategory ? nodeA : nodeB) as! EnemyExplosion
            bomber.removeFromParent()
            let blastRange = 150
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
            
        case collisionBetweenPlayerCityAndEnemyExplosion, collisionBetweenPlayerCityAndPlayerExplosion:
            let city = (contact.bodyA.categoryBitMask == playerCityCategory ? nodeA : nodeB) as! City
            removeCityFromGameScene(targetCity: city)
            city.removeFromParent()
            
        default:
            print("missing collision type")
        }
    }
    
    // MARK: - Enemy Raid Methods
    func warheadRaid(timeInterval: TimeInterval) {
        if !isGameOver && isWarheadRaidOn {
            warheadRaidTimer?.invalidate()
            warheadRaidTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(generateEnemyWarhead), userInfo: nil, repeats: true)
        }
    }
    
    func bomberRaid(timeInterval: TimeInterval) {
        if !isGameOver && isBomberRaidOn {
            bomberRaidTimer?.invalidate()
            bomberRaidTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(generateEnemyBomber), userInfo: nil, repeats: true)
        }
    }
    
    func tzarRaid(timeInterval: TimeInterval) {
        if !isGameOver && isTzarRaidOn {
            tzarRaidTimer?.invalidate()
            tzarRaidTimer = Timer.scheduledTimer(timeInterval: TimeInterval(timeInterval), target: self, selector: #selector(generateEnemyTzar), userInfo: nil, repeats: true)
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
    
    // MARK: - Building related methods
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
    
    func removeCityFromGameScene(targetCity: City) {
        guard let targetIndex = self.cities.firstIndex(of: targetCity) else { return }
        self.cities.remove(at: targetIndex)
        self.cityLocation.remove(at: targetIndex)
    }
    
    // MARK: - Game related methods
    func setTimeLabel(alwaysDisplayColon: Bool) {
        let minutes = Int(self.time / 60)
        let seconds = Int(self.time - minutes * 60)
        
        if minutes > 0 {
            self.timeLabel?.text = (seconds % 2 == 0 || alwaysDisplayColon) ? String(format: "%02d:%02d", minutes, seconds) : String(format: "%02d %02d", minutes, seconds)
        } else {
            self.timeLabel?.text = String(format: "%02d", seconds)
        }
    }
    
    func gameOver() {
        self.isGameOver = true
        self.removeAction(forKey: "countSeconds")
        self.setTimeLabel(alwaysDisplayColon: true)
        if isWarheadRaidOn { self.warheadRaidTimer.invalidate() }
        if isBomberRaidOn { self.bomberRaidTimer.invalidate() }
        if isTzarRaidOn { self.tzarRaidTimer.invalidate() }
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
        let wait = SKAction.wait(forDuration: 2)
        let show = SKAction.run { self.addChild(gameOverLabel) }
        self.run(SKAction.sequence([wait, show]))
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
        for _ in 1...warheadPerRaid {
            guard let randomTargetX = self.randomTargetLocation else {
                print("no targets are available")
                return
            }
            
            let toX = randomTargetX * 30
            let to = CGPoint(x: toX, y: 25)
            let fromX = Int.random(in: 1...600)
            let from = CGPoint(x: fromX, y: 500)
            
            let distance = getDistance(from: from, to: to)
            let velocity = CGFloat([50, 75, 100].randomElement()!)
            let blastRange =  [40, 50, 60].randomElement()!
            let enemyWarhead = EnemyWarhead(position: from, distance: distance, velocity: velocity, targetCoordinate: to, blastRange: blastRange, gameScene: self)
            addChild(enemyWarhead)
        }
    }
    
    @objc func generateEnemyBomber() {
        for _ in 1...bomberPerRaid {
            let fromY = Int.random(in: 400...500)
            let bombingDuration = Double.random(in: 0.2...0.5)
            let blastRange = [40, 50, 60].randomElement()!
            let bomber = Bomber(yPosition: CGFloat(fromY), fromRight: Bool.random(), bombingDuration: bombingDuration, blastRange: blastRange, gameScene: self)
            addChild(bomber)
        }
    }
    
    @objc func generateEnemyTzar() {
        for _ in 1...tzarPerRaid {
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
    }
    
    func generateScoreLabel() {
        self.scoreLabel = SKLabelNode(fontNamed: "PressStart2P")
        self.scoreLabel?.text = "0"
        self.scoreLabel?.fontSize = 20
        self.scoreLabel?.fontColor = SKColor.white
        self.scoreLabel?.position = CGPoint(x: frame.midX, y: 440)
        self.addChild(scoreLabel!)
    }
    
    func generateTimeLabel() {
        self.timeLabel = SKLabelNode(fontNamed: "PressStart2P")
        self.timeLabel?.text = "00"
        self.timeLabel?.fontSize = 20
        self.timeLabel?.fontColor = SKColor.white
        self.timeLabel?.position = CGPoint(x: frame.midX, y: 470)
        self.addChild(timeLabel!)
        let countOneSecond = SKAction.run {
            self.time = self.time + 1
        }
        let waitOneSecond = SKAction.wait(forDuration: 1)
        self.run(SKAction.repeatForever(SKAction.sequence([waitOneSecond, countOneSecond])), withKey: "countSeconds")
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
            let x = i * 30
            let y = 25
            let position = CGPoint(x: x, y: y)
            
            let city = City(position: position)
            cities.append(city)
            
            addChild(city)
        }
    }
}
