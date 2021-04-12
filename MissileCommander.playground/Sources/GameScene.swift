
import SpriteKit

public class GameScene: SKScene, SKPhysicsContactDelegate {
    public var globalCurrentTime: TimeInterval!
    public var silos: [Silo] = []
    public var cities: [City] = []
    public var siloLocation = [1, 10, 19]
    public var cityLocation = [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13]
    public var enemyWarheads: [EnemyWarhead] = []
    public var friendlyWarhead: [PlayerWarhead] = []
    public var doomsdayClock: Timer!
    
    static var maximumMissileCapacity: Int = 5
    
    public override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.0
        
        self.backgroundColor = .black
        self.physicsWorld.contactDelegate = self
        
        generateSilos()
        doomsdayMachine()
    }
    
    // MARK: - collision
    public func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask

        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }

        if collision == enemyWarheadCategory | playerExplosionCategory {
            let enemyWarhead = (contact.bodyA.categoryBitMask == enemyWarheadCategory ? nodeA : nodeB) as! EnemyWarhead

            enemyWarhead.removeFromParent()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                let newExplosion = PlayerWarheadExplosion(position: contact.contactPoint)
                self.addChild(newExplosion)
            }
        }
    }
    
    // update game
    public override func update(_ currentTime: TimeInterval) {
        globalCurrentTime = currentTime
    }
    
    func doomsdayMachine() {
        doomsdayClock?.invalidate()
        doomsdayClock = Timer.scheduledTimer(timeInterval: TimeInterval(3), target: self, selector: #selector(generateEnemyWarhead), userInfo: nil, repeats: true)
    }
    
    // mouse clicked
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch: AnyObject in touches {
            let location = touch.location(in: self)
            guard let closestSiloInfo = getClosestAvailableSilo(coordinate: location) else { return }
            let silo = closestSiloInfo.0
            let range = closestSiloInfo.1
            silo.shoot(coordinate: location, distance: range)
        }
    }
    
    func getClosestAvailableSilo(coordinate: CGPoint) -> (Silo, CGFloat)? {
        var distance = CGFloat(10_000)
        var closestSilo: Silo?
        
        for silo in self.silos {
            if silo.isLoaded {
                let currentDistance = distanceToTarget(from: silo.position, to: coordinate)
                if currentDistance.isLess(than: CGFloat(distance)) {
                    distance = currentDistance
                    closestSilo = silo
                }
            }
        }
        
        if distance != 10_000 {
            return (closestSilo, distance) as! (Silo, CGFloat)
        } else {
            return nil
        }
    }
    
    // if silo is loaded, return the distance between silo and designated coordinate. else, it can not fire so return maximum distance
    func distanceToTarget(from: CGPoint, to: CGPoint) -> CGFloat {
        let xDistance = from.x - to.x
        let yDistance = from.y - to.y
        return sqrt(xDistance * xDistance + yDistance * yDistance)
    }
    
    @objc func generateEnemyWarhead() {
        let candidateLocation = cityLocation + siloLocation
        for i in 0...3 {
            let fromX = Int.random(in: 1...600)
            let toX = candidateLocation.randomElement()! * 30
            let from = CGPoint(x: fromX, y: 500)
            let to = CGPoint(x: toX, y: 25)
            
            let distance = distanceToTarget(from: from, to: to)
            let enemyWarhead = EnemyWarhead(position: from, velocity: 50, distance: distance, explodeRadius: 50, targetCoordinate: to)
            addChild(enemyWarhead)
        }
    }
    
    // generate terrains and buildings
    func generateBackground() {
        let backgroundImage = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "background.png")))
        backgroundImage.setScale(CGFloat(750) / CGFloat(170))
        backgroundImage.zPosition = -10
        backgroundImage.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(backgroundImage)
    }
    
    func generateSilos() {
        for i in siloLocation {
            let x = i * 30
            let y = 25
            let position = CGPoint(x: x, y: y)
            
            let silo = Silo(position: position)
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
