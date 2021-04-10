
import SpriteKit

public class GameScene: SKScene {
    public var globalCurrentTime: TimeInterval!
    public var silos: [Silo] = []
    public var cities: [City] = []
    public var siloLocation = [0, 7, 14]
    public var cityLocation = [1, 2, 3, 4, 5, 6, 8, 9, 10, 11, 12, 13]
    public var enemyWarheads: [EnemyWarhead] = []
    public var friendlyWarhead: [PlayerWarhead] = []
    public var doomsdayClock: Timer!
    
    public override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsBody?.friction = 0.0
        
        //generateBackground()
        generateSilos()
        //generateCities()
        //generateSurface()
        //generateUnderground()
        doomsdayMachine()
        
    }
    
    func doomsdayMachine() {
        doomsdayClock?.invalidate()
        doomsdayClock = Timer.scheduledTimer(timeInterval: TimeInterval(10), target: self, selector: #selector(generateEnemyWarhead), userInfo: nil, repeats: true)
    }
    
    // update game
    public override func update(_ currentTime: TimeInterval) {
        globalCurrentTime = currentTime
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
            let fromX = Int.random(in: 1...750)
            let toX = 25 + candidateLocation.randomElement()! * 50
            let from = CGPoint(x: fromX, y: 900)
            let to = CGPoint(x: toX, y: 125)
            
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
            let x = 25 + i * 50
            let y = 125
            let position = CGPoint(x: x, y: y)
            
            let silo = Silo(position: position)
            silo.delegate = self
            silos.append(silo)
            
            addChild(silo)
        }
    }
    
    func generateCities() {
        for i in cityLocation {
            let x = 25 + i * 50
            let y = 125
            let position = CGPoint(x: x, y: y)
            
            let city = City(position: position)
            cities.append(city)
            addChild(city)
        }
    }
    
    func generateSurface() {
        for i in 0...15 {
            let x = 25 + i * 50
            let y = 75
            let position = CGPoint(x: x, y: y)
            
            let groundSurface = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "surface_up.png")))
            groundSurface.position = CGPoint(x: x, y: y)
            addChild(groundSurface)
        }
    }
    
    func generateUnderground() {
        for i in 0...15 {
            let x = 25 + i * 50
            let y = 25
                
            let underground = SKSpriteNode(texture: SKTexture(image: #imageLiteral(resourceName: "underground.png")))
            underground.position = CGPoint(x: x, y: y)
            addChild(underground)
        }
    }
}

extension GameScene: siloDelegate {
    func silo(warhead: PlayerWarhead, scene: SKScene) {
        scene.addChild(warhead)
    }
}
