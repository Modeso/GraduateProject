//
//  TeamStatsticsMenuViewController.swift
//  Euroleague-Graduate
//
//  Created by Modeso on 8/14/17.
//  Copyright © 2017 Modeso. All rights reserved.
//

import UIKit

class TeamStatisticsMenuViewController: UIViewController {
    
    @IBOutlet var menuButtons: [UIButton]!
    
    @IBOutlet weak var openMenuButton: UIButton!
    
    fileprivate var willSelect = false
    
    fileprivate var menu: Dictionary<Int,(text: String, priority: Int, round: String)> = [
        1 : ("Average Statistics - All phases", 100, ""),
    ]
    
    weak var delegate: MenuSwapped?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        menu = LeaguesCommenObjects.season.getTeamStatisticsMenuOptions()
        for button in menuButtons {
            button.isHidden = true
        }
        buttonsShouldHide(false, index: 0)
        delegate?.changeMenuSize(toHeight: menuButtons[0].frame.height)
        swapTheUIMenuOrder()
    }
    
    @IBAction func menuButtonPressed(_ sender: UIButton) {
        if !willSelect {
            willSelect = true
            for i in 0...menu.count {
                buttonsShouldHide(false, index: i)
            }
            openMenuButton.alpha = 0.5
            delegate?.changeMenuSize(toHeight: menuButtons[0].frame.height * CGFloat(menu.count))
        }
        else{
            willSelect = false
            if let text = sender.currentTitle,
                let currentText = menu[1]?.text,
                text.caseInsensitiveCompare("Average Statistics - \(currentText)") != .orderedSame {
                makeMenuStartWith(text)
                swapTheUIMenuOrder()
                if let round = menu[1]?.round {
                    delegate?.updateTableData(withRound: round)
                }
                
            }
            for i in 0...menu.count {
                buttonsShouldHide(false, index: i)
            }
            openMenuButton.alpha = 1.0
            delegate?.changeMenuSize(toHeight: menuButtons[0].frame.height)
        }
    }
    
    func getCurrentMenuRound() -> String {
        return menu[1]?.round ?? ""
    }
    
    deinit {
        print("deinit TeamStatisticsMenuViewController")
    }
}

fileprivate extension TeamStatisticsMenuViewController {
    
    func makeMenuStartWith(_ text: String) {
        var foundAt = 1
        for k in 1...menu.count {
            if let currentText = menu[k]?.text {
                let menuText = "Average Statistics - \(currentText)"
                if text.caseInsensitiveCompare(menuText) == .orderedSame {
                    if foundAt != 1 {               // Just to make sure
                        swapMenu(1, foundAt)
                        resortMenu()
                    }
                    break
                }
            }
            foundAt += 1
        }
    }
    
    func swapTheUIMenuOrder() {
        for i in 0...menu.count {
            if let text = menu[i+1]?.text {
                menuButtons[i].setTitle("Average Statistics - \(text)", for: .normal)
            }
        }
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
    
    func buttonsShouldHide(_ appear: Bool, index: Int) {
        menuButtons[index].isHidden = appear
    }
}


