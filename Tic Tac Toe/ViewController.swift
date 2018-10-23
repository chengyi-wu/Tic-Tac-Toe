//
//  ViewController.swift
//  Tic Tac Toe
//
//  Created by Chengyi Wu on 10/21/18.
//  Copyright © 2018 Chengyi Wu. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var lblStatus: UILabel!
    @IBOutlet weak var btn0: UIButton!
    @IBOutlet weak var btn1: UIButton!
    @IBOutlet weak var btn2: UIButton!
    @IBOutlet weak var btn3: UIButton!
    @IBOutlet weak var btn4: UIButton!
    @IBOutlet weak var btn5: UIButton!
    @IBOutlet weak var btn6: UIButton!
    @IBOutlet weak var btn7: UIButton!
    @IBOutlet weak var btn8: UIButton!
    
    var state : Array<String> = Array(repeating:" ", count:9)
    var cache: [String: Int] = [:]
    var stateCache : [String: Array<Array<String>>] = [:]

    let endStates = [
        [0, 1, 2],
        [3, 4, 5],
        [6, 7, 8],
        [0, 3, 6],
        [1, 4, 7],
        [2, 5, 8],
        [0, 4, 8],
        [2, 4, 6]
    ]
    
    func checkStates(_ state:Array<String>)-> Bool {
        for s in endStates {
            let a = s[0]
            let b = s[1]
            let c = s[2]
            if (state[a] == state[b] && state[b] == state[c] && state[a] != " ") {
                return true
            }
        }
        return false
    }
    
    func getWinner(_ state:Array<String>) -> String {
        for s in endStates {
            let a = s[0]
            let b = s[1]
            let c = s[2]
            if (state[a] == state[b] && state[b] == state[c] && state[a] != " ") {
                return state[a]
            }
        }
        return "";
    }
    
    func clearState(){
        state = Array(repeating:" ", count:9)
    }
    
    func play(state:Array<String>, sym:String) -> Array<Array<String>> {
        let key = state.joined()
        if(stateCache.keys.contains(key)) {
            return stateCache[key]!
        }
        var nextSym = "O"
        if (sym == nextSym) { nextSym = "X" }
        if (!state.contains(" "))
        {
            stateCache[key] = [state]
            return stateCache[key]!
        }
        var states = Array<Array<String>>()
        for i in 0...8
        {
            if(state[i] != " ") { continue }
            var t = state
            t[i] = sym
            if (checkStates(t)) { return [t] }
            for s in play(state:t, sym:nextSym) {
                states.append(s)
            }
        }
        stateCache[key] = states
        return states
    }
    
    var factorials = [1, 1, 2, 6, 24, 120, 720, 5040, 40320, 362880]
    
    func playmin(state:Array<String>) -> Int {
        let key = state.joined()
        var move = -1
        if (cache.keys.contains(key)) { move = cache[key]! }
        else {
            var count = Int.max
            for i in 0...8
            {
                if (state[i] != " ") { continue }
                var t = state
                t[i] = "O"
                var local = 0
                for s in play(state: t, sym: "X")
                {
                    var emptyCount = 0
                    for c in s {
                        if (c == " ") { emptyCount += 1 }
                    }
                    let winner = getWinner(s)
                    if (winner == "X") {
                        local += factorials[emptyCount + 1]
                    } else if (winner == "O") {
                        local -= factorials[emptyCount + 1]
                    }
                }
                // print(i, local)
                if (local < count) {
                    count = local
                    move = i
                }
            }
            cache[key] = move
        }
        print("Place O at", move)
        lblStatus.text = "Place O at " + String(move)
        return move
    }
    
    func clearBtn(_ btn: UIButton) {
        btn.setImage(nil, for: UIControl.State())
    }
    
    @IBAction func resetCallback(_ sender: UIButton) {
        clearState()
        
        clearBtn(btn0)
        clearBtn(btn1)
        clearBtn(btn2)
        clearBtn(btn3)
        clearBtn(btn4)
        clearBtn(btn5)
        clearBtn(btn6)
        clearBtn(btn7)
        clearBtn(btn8)
        
        lblStatus.text = ""
    }
    
    @discardableResult func showStatus() -> Bool {
        if (checkStates(state) || !state.contains(" ")) {
            let winner = getWinner(state)
            if (winner == "") {
                lblStatus.text = ">> DRAW <<"
            } else {
                lblStatus.text = winner + " WINS"
            }
            return true
        }
        return false
    }
    
    @IBAction func action(_ sender: AnyObject) {
        if (state[sender.tag] != " " || checkStates(state)) { return }
        let buttons = [
            btn0,
            btn1,
            btn2,
            btn3,
            btn4,
            btn5,
            btn6,
            btn7,
            btn8
        ]
        var move : Int = sender.tag
        sender.setImage(UIImage(named: "Cross.png"), for: UIControl.State())
        state[move] = "X"
        if(showStatus()) {return}
        move = playmin(state: state)
        state[move] = "O"
        let btn = buttons[move]
        btn?.setImage(UIImage(named: "Nought"), for: UIControl.State())
        showStatus()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }


}

