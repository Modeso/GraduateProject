//
//  TeamStatsticsMenuViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/14/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

protocol MenuSwapped {
    
    func changeMenuSize(toHeight height: CGFloat)
    
    func updateTableData(withRound round: String)
    
}

class TeamStatisticsMenuViewController: UIViewController {
    
    @IBOutlet weak var firstButton: UIButton!
    
    @IBOutlet weak var secondButton: UIButton!
    
    @IBOutlet weak var thirdButton: UIButton!
    
    @IBOutlet weak var fourthButton: UIButton!
    
    @IBOutlet weak var openMenuButton: UIButton!
    
    fileprivate var willSelect = false
    
    var delegate: MenuSwapped?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.changeMenuSize(toHeight: firstButton.frame.height)
    }
    
    fileprivate var menu: Dictionary<Int,(text: String, priority: Int, round: String)> = [
        1 : ("Average Statistics - All phases", 4, ""),
        2 : ("Average Statistics - Regular Season", 3, "RS"),
        3 : ("Average Statistics - Play Offs", 2, "PO"),
        4 : ("Average Statistics - Final Four", 1, "F4")
    ]
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        if !willSelect {
            willSelect = true
            buttonsShouldHide(false)
            openMenuButton.alpha = 0.5
            delegate?.changeMenuSize(toHeight: firstButton.frame.height * CGFloat(menu.count))
        }
        else{
            willSelect = false
            if let text = sender.currentTitle,
                let currentText = menu[1]?.text,
                text.caseInsensitiveCompare(currentText) != .orderedSame {
                makeMenuStartWith(text)
                swapTheUIMenuOrder()
                if let round = menu[1]?.round {
                    delegate?.updateTableData(withRound: round)
                }
                
            }
            buttonsShouldHide(true)
            openMenuButton.alpha = 1.0
            delegate?.changeMenuSize(toHeight: firstButton.frame.height)
        }
    }
    
    func getCurrentMenuRound() -> String {
        return menu[1]?.round ?? ""
    }
    
}

fileprivate extension TeamStatisticsMenuViewController {
    
    func makeMenuStartWith(_ text: String) {
        var foundAt = 1
        for k in 1...menu.count {
            let menuText = menu[k]
            if menuText?.text.caseInsensitiveCompare(text) == .orderedSame {
                if foundAt != 1 {               // Just to make sure
                    swapMenu(1, foundAt)
                    resortMenu()
                }
                break
            }
            foundAt += 1
        }
    }
    
    func swapTheUIMenuOrder() {
        firstButton.setTitle(menu[1]?.text, for: .normal)
        secondButton.setTitle(menu[2]?.text, for: .normal)
        thirdButton.setTitle(menu[3]?.text, for: .normal)
        fourthButton.setTitle(menu[4]?.text, for: .normal)
    }
    
    func resortMenu () {
        var swapped = true
        repeat{
            swapped = false
            for i in 2...menu.count - 1 {
                let j = i + 1
                if let firstPriority = menu[j-1]?.priority,
                    let secondPriority = menu[j]?.priority,
                    firstPriority < secondPriority {
                    swapMenu(j-1, j)
                    swapped = true
                }
            }
        } while swapped
    }
    
    func swapMenu(_ i: Int, _ j: Int){
        let temp = menu[i]
        menu[i] = menu[j]
        menu[j] = temp
    }
    
    func buttonsShouldHide(_ appear: Bool) {
        secondButton.isHidden = appear
        thirdButton.isHidden = appear
        fourthButton.isHidden = appear
    }
}


