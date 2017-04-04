//
//  ViewController.swift
//  Example
//
//  Created by Lasha Efremidze on 3/8/17.
//  Copyright © 2017 efremidze. All rights reserved.
//

import SpriteKit
import Magnetic

class ViewController: UIViewController {
    var teamImageArray = [String]()
    var teamNameArray = [String]()
    @IBOutlet weak var magneticView: MagneticView! {
        didSet {
            magnetic.magneticDelegate = self
            #if DEBUG
                //magneticView.showsFPS = true
                //magneticView.showsDrawCount = true
                //magneticView.showsQuadCount = true
            #endif
        }
    }
    
    var magnetic: Magnetic {
        return magneticView.magnetic
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        teamImageArray = ["AC-Milan-icon.png",
                          "Arsenal-FC-icon.png",
                          "AS-Roma-icon.png",
                          "Atletico-Madrid-icon.png",
                          "BayernMunchen-icon.png",
                          "Benfica-icon.png",
                          "Borussia-Dortmund-icon.png",
                          "Chelsea-FC-icon.png",
                          "Everton-FC-icon.png",
                          "FC-Barcelona-icon.png",
                          "FC-Porto-icon.png",
                          "Internazionale-icon.png",
                          "Liverpool-FC-icon.png",
                          "Manchester-City-icon.png",
                          "Manchester-United-icon.png",
                          "Napoli-icon.png",
                          "Paris-Saint-Germain-icon.png",
                          "Real-Madrid-icon.png",
                          "Tottenham-Hotspur-icon.png",
                          "Juventus-icon.png"
                          
        ]
        teamNameArray = ["AC Milan",
                         "Arsenal",
                         "AS Roma",
                         "Atletico Madrid",
                         "Bayern Munchen",
                         "Benfica",
                         "Borussia Dortmund",
                         "Chelsea",
                         "Everton",
                         "Barcelona",
                         "Porto",
                         "Inter Milan",
                         "Liverpool",
                         "Manchester City",
                         "Manchester United",
                         "Napoli",
                         "Paris Saint-Germain",
                         "Real Madrid",
                         "Tottenham Hotspur",
                         "Juventus"]
        for i in 0..<teamNameArray.count {
            addTeam(teamName: teamNameArray[i], teamImage: teamImageArray[i])
        }
    }
    func addTeam(teamName:String,teamImage:String){
        let name = ""//teamName
        let color = UIColor.colors.randomItem()
        let node = Node(text: name.capitalized, image: UIImage(named: teamImage), color: color, radius: 40)
        magnetic.addChild(node)
    }
    @IBAction func add(_ sender: UIControl?) {
        let name = UIImage.names.randomItem()
        let color = UIColor.colors.randomItem()
        let node = Node(text: name.capitalized, image: UIImage(named: name), color: color, radius: 40)
        magnetic.addChild(node)
    }
    
    @IBAction func reset(_ sender: UIControl?) {
        let speed = magnetic.physicsWorld.speed
        magnetic.physicsWorld.speed = 0
        let sortedNodes = magnetic.children.flatMap { $0 as? Node }.sorted { node, nextNode in
            let distance = node.position.distance(from: magnetic.magneticField.position)
            let nextDistance = nextNode.position.distance(from: magnetic.magneticField.position)
            return distance < nextDistance && node.selected
        }
        var actions = [SKAction]()
        for node in sortedNodes {
            node.physicsBody = nil
            let action = SKAction.run { [unowned magnetic, unowned node] in
                if node.selected {
                    let point = CGPoint(x: magnetic.size.width / 2, y: magnetic.size.height + 40)
                    let movingXAction = SKAction.moveTo(x: point.x, duration: 0.2)
                    let movingYAction = SKAction.moveTo(y: point.y, duration: 0.4)
                    let resize = SKAction.scale(to: 0.3, duration: 0.4)
                    let throwAction = SKAction.group([movingXAction, movingYAction, resize])
                    node.run(throwAction) { [unowned node] in
                        node.removeFromParent()
                    }
                } else {
                    node.removeFromParent()
                }
            }
            actions.append(action)
        }
        magnetic.run(SKAction.sequence(actions)) { [unowned magnetic] in
            magnetic.physicsWorld.speed = speed
        }
        for i in 0..<teamNameArray.count {
            addTeam(teamName: teamNameArray[i], teamImage: teamImageArray[i])
        }
    }
    
}

// MARK: - MagneticDelegate
extension ViewController: MagneticDelegate {
    
    func magnetic(_ magnetic: Magnetic, didSelect node: Node) {
        print("didSelect -> \(node)")
    }
    
    func magnetic(_ magnetic: Magnetic, didDeselect node: Node) {
        print("didDeselect -> \(node)")
    }
    
}
