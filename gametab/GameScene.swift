//
//  GameScene.swift
//  gametab
//
//  Created by Nissim Maruani on 09/08/2019.
//  Copyright © 2019 Nissim Maruani. All rights reserved.
//

import SpriteKit
import GameplayKit


class GameScene: SKScene {
    
    var dim = 5
    var nbcouleur = 3
    private var tabnode : [[SKShapeNode]] = []
    private var moves = 0
    private var tab : [[Int]] = []
    private var lbl2 = SKLabelNode(fontNamed: "Futura")
    private let wintext = ["CLEAR", "Bravo !", "The End...", "You rock !", "Congratss","Nice !","YASS !"]
    private let secondScene = Settingscene(fileNamed: "Settingscene")
    
   
    
    override func didMove(to view: SKView) {
        tab = Array(repeating: Array(repeating: 0, count: dim), count: dim)
        tabnode = Array(repeating: Array(repeating: SKShapeNode(), count: dim), count: dim)
        for i in 0..<dim {
            for j in 0..<dim {
                tab[i][j] = 0
                tabnode[i][j] = SKShapeNode(circleOfRadius: CGFloat(240/dim))
                tabnode[i][j].fillColor = SKColor.blue
                tabnode[i][j].lineWidth = 0
                tabnode[i][j].name = String(i+dim*j)
                tabnode[i][j].position.x = CGFloat( -300.0 + Double(i)/Double(dim-1)*(600.0))
                tabnode[i][j].position.y = CGFloat( -300.0 + Double(j)/Double(dim-1)*(600.0))
                self.addChild(tabnode[i][j])
            }
        }
        for _ in 0..<dim*dim*3 {
            touched(i: Int.random(in: 0..<dim),j: Int.random(in: 0..<dim))
        }
        update()
        
        
        
        //let lbl = SKLabelNode(fontNamed: "Futura")
        //lbl.fontSize = 100
        //lbl.text = "Reset"
        //lbl.name = "Reset"
       // lbl.position.y = -600
        //lbl.position.x = 100
        //self.addChild(lbl)
        
       
        lbl2.fontSize = 100
        lbl2.text = "Moves : 0"
        lbl2.position.y = +500
        self.addChild(lbl2)
    }
    
    func touched(i: Int,j: Int) {
        tab[(dim+i-1)%dim][j] += 1
        tab[(dim+i-1)%dim][j] %= nbcouleur
        tab[(i+1)%dim][j] += 1
        tab[(i+1)%dim][j] %= nbcouleur
        tab[i][(j+1)%dim] += 1
        tab[i][(j+1)%dim] %= nbcouleur
        tab[i][(dim+j-1)%dim] += 1
        tab[i][(dim+j-1)%dim] %= nbcouleur
    }
    func update() {
        
        var win = true
        for i in 0..<dim {
            for j in 0..<dim {
                if (tab[i][j]==0) {
                    tabnode[i][j].fillColor = SKColor.black
                }
                
                else if (tab[i][j]==1) {
                    win = false
                    tabnode[i][j].fillColor = SKColor.orange
                }
                else if (tab[i][j]==2) {
                    win = false
                    tabnode[i][j].fillColor = SKColor.blue
                }
                else {
                    win = false
                    tabnode[i][j].fillColor = SKColor.purple
                }
                
            }
        }
        if (win) {
            let str = wintext[Int.random(in: 0..<wintext.count)]
            
            lbl2.text? = "Score : " + String(moves)
            
            
            
            let lbln = SKLabelNode(fontNamed: "Futura")
            lbln.fontSize = 150
            lbln.text = str
            self.addChild(lbln)
            lbln.run(SKAction.sequence([SKAction.fadeIn(withDuration: 0.2), SKAction.wait(forDuration: 0.5),SKAction.rotate(byAngle: CGFloat(2*Double.pi), duration: 0.5),SKAction.fadeOut(withDuration: 0.2),
                                        SKAction.removeFromParent(),SKAction.run {
                                            self.reset()
                } ]))
            
        }
    }
 
    func reset() {
        moves = 0
        lbl2.text? = "Moves : " + String(moves)
        for i in 0..<dim {
            for j in 0..<dim {
                tab[i][j]=0
            }
        }
        for _ in 0..<20 {
            touched(i: Int.random(in: 0..<dim),j: Int.random(in: 0..<dim))
        }
        update()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for t in touches {
            let touchedNode = self.atPoint(t.location(in: self))
        
            if let nam = touchedNode.name {
                if (nam == "Reset") { // L'utilisateur Reset
                    reset()
                }
                else if (nam == "Settings") { // changement de scene
                    
                    
                    
                    let transition = SKTransition.push(with: SKTransitionDirection.left, duration: 0.4)
                    secondScene?.scaleMode = .aspectFit
                    secondScene?.coli = nbcouleur
                    secondScene?.dimi = dim
                    
                    scene?.view?.presentScene(secondScene!, transition: transition)
                }
                else { //L'utilisateur appuie sur une des cases
                    moves += 1
                    lbl2.text? = "Moves : " + String(moves)
                    let n = Int(nam)
                    let j = n!/(dim)
                    let i = n!%(dim)
                    touched(i: i,j: j)
                    update()
                }
            }

            
        }
    }
    
  
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}


class Settingscene: SKScene {
    var coli = 3 //ATTENTION : NBCOULEURS REELES = COULEUR +1
    var dimi = 5
    
    override func didMove(to view: SKView) {
        let sq = self.childNode(withName: "Dsquare")
        sq?.position.x = CGFloat((self.childNode(withName: "D"+String(dimi))?.position.x)!)
        
        let sq2 = self.childNode(withName: "Csquare")
        sq2?.position.x = CGFloat((self.childNode(withName: "C"+String(coli-1))?.position.x)!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let dtab = ["D4","D5","D6","D7"]
        let ctab = ["C1","C2","C3"]
        for t in touches {
            let touchedNode = self.atPoint(t.location(in: self))
            
            if let nam = touchedNode.name {
                if (nam == "Ok") { // L'utilisateur Reset
                    let secondScene = GameScene(fileNamed: "GameScene")
                    secondScene?.dim = dimi
                    secondScene?.nbcouleur = coli
                    secondScene?.scaleMode = .aspectFill

                    let transition = SKTransition.push(with: SKTransitionDirection.right, duration: 0.4)
                    scene?.view?.presentScene(secondScene!, transition: transition)
                }
                else if dtab.contains(nam) {
                    dimi = dtab.firstIndex(of: nam)!+4
                    let sq = self.childNode(withName: "Dsquare")
                    sq?.run(SKAction.moveTo(x: touchedNode.position.x, duration: 0.2))
                }
                else if ctab.contains(nam) {
                    coli = ctab.firstIndex(of: nam)!+2
                    let sq = self.childNode(withName: "Csquare")
                    sq?.run(SKAction.moveTo(x: touchedNode.position.x, duration: 0.2))
                }
                
            }
            
            
            
        }
    }
}
