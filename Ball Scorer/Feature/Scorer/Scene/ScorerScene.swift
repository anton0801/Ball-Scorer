import SwiftUI
import SpriteKit
import GameKit

class ScorerScene: SKScene, SKPhysicsContactDelegate {
    
    private var level: Int
    
    private var items = [
        1: "block_1",
        2: "block_2",
        3: "block_3",
        4: "block_4",
        5: "block_5",
        6: "block_6",
        7: "block_7",
        8: "block_8",
        9: "block_9",
        10: "block_10",
    ]
    
//    private var rowFieldItems: [[CGFloat: CGFloat]] = [[:]]
//    private var rowNodeItems: [SKSpriteNode] = []
//    private var rowNodeLabels: [SKLabelNode] = []
    
    func restartGame() {
        ball.position.y = 230
          ball.position.x = size.width / 2
          ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        
        currentScore = 0
        
        for (key, block) in blocks {
            block.removeFromParent()
            blockNumbers[key]?.removeFromParent()
        }
        
        blocks = [:]
        
        rowNodeLabels = []
        rowNodeItems = []
        rowFieldItems = []
    }
    
    private var ball: SKSpriteNode!
    private var ballDirection: SKSpriteNode!
    
    private var currentScore: Int = 0 {
        didSet {
            currentScoreLabel.text = "\(currentScore)"
            if currentScore == (200 + (level * 50)) {
                NotificationCenter.default.post(name: Notification.Name("win"), object: nil)
            }
        }
    }
    
    private var currentScoreLabel: SKLabelNode = SKLabelNode(text: "0")
    
    init(level: Int) {
        self.level = level
        super.init(size: CGSize(width: 800, height: 1400))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        
        let backgroundColor = SKSpriteNode(imageNamed: "background_color")
        backgroundColor.position = CGPoint(x: size.width / 2, y: size.height / 2)
        backgroundColor.size = size
        backgroundColor.zPosition = 0
        addChild(backgroundColor)
        
        let backgroundDown = SKSpriteNode(imageNamed: "background_color")
        backgroundDown.size = size
        backgroundDown.position = CGPoint(x: size.width / 2, y: -470)
        backgroundDown.zPosition = 2
        backgroundDown.zRotation = CGFloat.pi * 1
        addChild(backgroundDown)
        
        createButtons()
        createScoreLabels()
        
        let lineOne = SKSpriteNode(imageNamed: "line")
        lineOne.position = CGPoint(x: size.width / 2, y: size.height - 230)
        lineOne.size = CGSize(width: size.width, height: 1)
        addChild(lineOne)
        
        let lineTwo = SKSpriteNode(imageNamed: "line")
        lineTwo.position = CGPoint(x: size.width / 2, y: 230)
        lineTwo.size = CGSize(width: size.width, height: 1)
        addChild(lineTwo)
        
        ball = SKSpriteNode(imageNamed: "ball")
        ball.position = CGPoint(x: size.width / 2, y: 255)
        ball.size = CGSize(width: 42, height: 40)
        ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.height / 2)
        ball.physicsBody?.isDynamic = true
        ball.physicsBody?.affectedByGravity = false
        ball.physicsBody?.categoryBitMask = 1
        ball.physicsBody?.collisionBitMask = 2 | 3
        ball.physicsBody?.contactTestBitMask = 2 | 3
        ball.physicsBody?.restitution = 1.0 // Коэффициент упругости
        ball.physicsBody?.linearDamping = 0.0 // Линейное демпфирование
        ball.physicsBody?.angularDamping = 0.0
        ball.zPosition = 3
        ball.name = "ball"
        addChild(ball)
        
        ballDirection = SKSpriteNode(imageNamed: "ball_pull_direction")
        ballDirection.position = CGPoint(x: size.width / 2, y: 250)
        ballDirection.size = CGSize(width: ballDirection.size.width, height: 300)
        ballDirection.anchorPoint = CGPoint(x: 0.5, y: 0.0)
        addChild(ballDirection)
        
        createGameField()
        
        spawnNewRowItems()
        let _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
            if !self.isPaused {
                self.spawnNewRowItems()
            }
        }
    }
    
    private func createGameField() {
        let gameRowItem1 = SKSpriteNode(color: .clear, size: CGSize(width: 2, height: size.height - 460))
        gameRowItem1.position = CGPoint(x: 1, y: size.height / 2)
        createBaseInvisibleItem(node: gameRowItem1)
        addChild(gameRowItem1)
        
        let gameRowItem2 = SKSpriteNode(color: .clear, size: CGSize(width: 2, height: size.height - 460))
        gameRowItem2.position = CGPoint(x: size.width - 1, y: size.height / 2)
        createBaseInvisibleItem(node: gameRowItem2)
        addChild(gameRowItem2)
        
        let gameRowItem3 = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: 2))
        gameRowItem3.position = CGPoint(x: size.width / 2, y: size.height - 230)
        createBaseInvisibleItem(node: gameRowItem3)
        addChild(gameRowItem3)
        
        let gameRowItem4 = SKSpriteNode(color: .clear, size: CGSize(width: size.width, height: 2))
        gameRowItem4.position = CGPoint(x: size.width / 2, y: 230)
        gameRowItem4.physicsBody = SKPhysicsBody(rectangleOf: gameRowItem4.size)
        gameRowItem4.physicsBody?.isDynamic = true
        gameRowItem4.physicsBody?.affectedByGravity = false
        gameRowItem4.physicsBody?.categoryBitMask = 4
        gameRowItem4.physicsBody?.collisionBitMask = 2
        gameRowItem4.physicsBody?.contactTestBitMask = 2
        gameRowItem4.name = "invisible"
        addChild(gameRowItem4)
    }
    
    private func createBaseInvisibleItem(node: SKSpriteNode) {
        node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
        node.physicsBody?.isDynamic = false
        node.physicsBody?.affectedByGravity = false
        node.physicsBody?.categoryBitMask = 3
        node.physicsBody?.collisionBitMask = 1
        node.physicsBody?.contactTestBitMask = 1
        node.name = "invisible"
    }
    
    private func createButtons() {
        let homeButton = SKSpriteNode(imageNamed: "home_btn")
        homeButton.position = CGPoint(x: 80, y: size.height - 80)
        homeButton.name = "home_btn"
        homeButton.size = CGSize(width: 100, height: 90)
        addChild(homeButton)
        
        let pauseBtn = SKSpriteNode(imageNamed: "pause_btn")
        pauseBtn.position = CGPoint(x: size.width - 80, y: size.height - 80)
        pauseBtn.name = "pause_btn"
        pauseBtn.size = CGSize(width: 100, height: 90)
        addChild(pauseBtn)
    }
    
    private func createScoreLabels() {
        let objectiveScoreLabel = SKLabelNode(text: "\(200 + (level * 50)) /")
        objectiveScoreLabel.fontName = "Slamming"
        objectiveScoreLabel.fontSize = 62
        objectiveScoreLabel.fontColor = .white
        objectiveScoreLabel.position = CGPoint(x: size.width / 2 - 30, y: size.height - 180)
        addChild(objectiveScoreLabel)
        
        currentScoreLabel = SKLabelNode(text: "\(currentScore)")
        currentScoreLabel.fontName = "Slamming"
        currentScoreLabel.fontSize = 62
        currentScoreLabel.fontColor = UIColor.init(red: 153/255, green: 0, blue: 73/255, alpha: 1)
        currentScoreLabel.position = CGPoint(x: size.width / 2 + 70, y: size.height - 180)
        addChild(currentScoreLabel)
    }
    
    private var rowFieldItems: [[CGFloat: CGFloat]] = [[:]]
    private var rowNodeItems: [SKSpriteNode] = []
    private var rowNodeLabels: [SKLabelNode] = []
    
    private func spawnNewRowItems() {
        var nonEmptyGameRowItems: [[CGFloat: CGFloat]] = []
        for row in rowFieldItems {
            if !row.isEmpty {
                nonEmptyGameRowItems.append(row)
            }
        }
        rowFieldItems = nonEmptyGameRowItems
        
        let randomSource = GKRandomSource.sharedRandom()
        var itemsInRow = [Int]()
        for _ in 0...5 {
            let randomValue = randomSource.nextInt(upperBound: 2)
            itemsInRow.append(randomValue)
        }
        
        var tempGameRowItems: [[CGFloat: CGFloat]] = [[:]]
        tempGameRowItems.append(contentsOf: rowFieldItems)
        
        for (index, row) in tempGameRowItems.enumerated() {
            for (positionX, positionY) in row {
                let rowDictionary = rowFieldItems[index - 1]
                if let value = rowDictionary[positionX] {
                    rowFieldItems[index - 1][positionX] = value - 100
                }
                for node in nodes(at: CGPoint(x: positionX, y: positionY)) {
                    if node.name?.contains("block") == true || node.name == "game_item_row_number" {
                        node.position.y = rowFieldItems[index - 1][positionX]!
                    }
                }
            }
        }
        
        var itemsInRowTemp: [CGFloat: CGFloat] = [:]

        for (index, item) in itemsInRow.enumerated() {
            if item >= 1 {
                let x = index * 130 + 80
                let y = size.height - 290
                itemsInRowTemp[CGFloat(x)] = y
                makeItemGameItemColumn(x: CGFloat(x), y: y, number: Int.random(in: 1...10))
            }
        }
        
        rowFieldItems.append(itemsInRowTemp)
    }
    
    private var blocks: [String: SKNode] = [:]
    private var blockNumbers: [String: SKLabelNode] = [:]
    
    private func makeItemGameItemColumn(x: CGFloat, y: CGFloat, number: Int) {
        let blockBackName = items[number] ?? "block_1"
        let blockId = UUID().uuidString
        let blockBackNode = SKSpriteNode(imageNamed: blockBackName)
        blockBackNode.position = CGPoint(x: x, y: y)
        blockBackNode.size = CGSize(width: 120, height: 80)
        blockBackNode.physicsBody = SKPhysicsBody(rectangleOf: blockBackNode.size)
        blockBackNode.physicsBody?.isDynamic = false
        blockBackNode.physicsBody?.affectedByGravity = false
        blockBackNode.physicsBody?.categoryBitMask = 2
        blockBackNode.physicsBody?.collisionBitMask = 1
        blockBackNode.physicsBody?.contactTestBitMask = 1
        blockBackNode.name = "block_\(blockId)"
        addChild(blockBackNode)
       
        let itemNum = SKLabelNode(text: "\(number)")
        itemNum.position = CGPoint(x: x, y: y - 10)
        itemNum.fontName = "Slamming"
        itemNum.name = "game_item_row_number"
        addChild(itemNum)

        blocks[blockId] = blockBackNode
        rowNodeItems.append(blockBackNode)
        rowNodeLabels.append(itemNum)
        blockNumbers[blockId] = itemNum

        let actionFadeOut = SKAction.fadeOut(withDuration: 0.001)
        let actionFadeOut2 = SKAction.fadeOut(withDuration: 0.001)
        let actionFadeIn = SKAction.fadeIn(withDuration: 0.2)
        let actionFadeIn2 = SKAction.fadeIn(withDuration: 0.2)
        let sequince = SKAction.sequence([actionFadeOut, actionFadeIn])
        let sequince2 = SKAction.sequence([actionFadeOut2, actionFadeIn2])
        blockBackNode.run(sequince)
        itemNum.run(sequince2)
   }
    
    var launchAngle: CGFloat = 0.0
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }

        // Получаем текущую позицию пальца
        let touchLocation = touch.location(in: self)

        // Получаем позицию индикатора (центра сцены)
        let indicatorPosition = ballDirection.position

        // Вычисляем разницу по осям X и Y
        let dx = touchLocation.x - indicatorPosition.x
        let dy = touchLocation.y - indicatorPosition.y

        // Вычисляем угол в радианах
        let angleInRadians = atan2(dy, dx) - .pi / 2

        // Применяем угол поворота к индикатору
        ballDirection.zRotation = angleInRadians

        // Сохраняем угол наклона для использования при отпускании пальца
        launchAngle = atan2(dy, dx)
   }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
          // Когда палец отпущен, запускаем мячик в направлении launchAngle
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let obj = atPoint(loc)
            if obj.name != "pause_btn" {
                launchBall(at: launchAngle)
            }
        }
      }
    
    func launchBall(at angle: CGFloat) {
        // Устанавливаем начальную скорость
        let speed: CGFloat = 1000.0 // Вы можете настроить скорость по своему усмотрению

        // Вычисляем вектор направления на основе угла
        let dx = cos(angle) * speed
        let dy = sin(angle) * speed

        // Применяем вектор скорости к мячика с помощью physicsBody
        if ball.physicsBody == nil {
            ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2)
        }
        
        ball.physicsBody?.velocity = CGVector(dx: dx, dy: dy)
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if (bodyA.categoryBitMask == 1 && bodyB.categoryBitMask == 2) ||
            (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 1) {
            let blockBody: SKPhysicsBody
            
            if bodyA.categoryBitMask == 1 {
                blockBody = bodyB
            } else {
                blockBody = bodyA
            }
            
            if let blockNode = blockBody.node {
                let blockName = blockNode.name
                let blockId = blockName!.components(separatedBy: "_")[1]
                if let blockNumberNode = blockNumbers[blockId] {
                    let number = Int(blockNumberNode.text ?? "0") ?? 0
                    if number > 0 {
                        blockNumberNode.text = "\(number - 1)"
                        currentScore += 1
                        if number - 1 == 0 {
                            currentScore += 10
                            removeBlockNode(node: blockNode, labelNode: blockNumberNode)
                        }
                    } else {
                        removeBlockNode(node: blockNode, labelNode: blockNumberNode)
                    }
                }
            }
        }
        
        if (bodyA.categoryBitMask == 2 && bodyB.categoryBitMask == 4) ||
            (bodyA.categoryBitMask == 4 && bodyB.categoryBitMask == 2) {
            isPaused = true
            NotificationCenter.default.post(name: Notification.Name("lose"), object: nil)
        }
    }
    
    private func removeBlockNode(node: SKNode, labelNode: SKLabelNode) {
        let fadeOut = SKAction.fadeOut(withDuration: 0.5)
        let remove = SKAction.removeFromParent()
        let seq = SKAction.sequence([fadeOut, remove])
        node.run(seq)
        labelNode.run(seq)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if ball.position.y < 200 {
            ball.position.y = 230
            ball.position.x = size.width / 2
            ball.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let loc = touch.location(in: self)
            let obj = atPoint(loc)
            
            if obj.name == "home_btn" {
                NotificationCenter.default.post(name: Notification.Name("back"), object: nil)
            }
            
            if obj.name == "pause_btn" {
                NotificationCenter.default.post(name: Notification.Name("pause"), object: nil)
            }
        }
    }
    
}

#Preview {
    VStack {
        SpriteView(scene: ScorerScene(level: 1))
            .ignoresSafeArea()
    }
}
