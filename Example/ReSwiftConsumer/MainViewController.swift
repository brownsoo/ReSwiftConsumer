//
//  ViewController.swift
//  ReSwiftConsumer
//
//  Created by brownsoo on 12/21/2017.
//  Copyright (c) 2017 brownsoo. All rights reserved.
//

import UIKit
import ReSwiftConsumer

class MainViewController: StateViewController<MainState> {

    @IBOutlet weak var countLb: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var btn: UIButton!

    private var interactor: MainController? {
        return pageController as? MainController
    }
    private var activeController: UIViewController? {
        didSet {
            removeSubController(inactiveVc: oldValue)
            activateSubController()
            if activeController == nil {
                btn.setTitle("Add SharedState", for: .normal)
            } else {
                btn.setTitle("Remove SharedState", for: .normal)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad() // At this,asynchronous subscription made in StateViewController
        pageController = MainController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageConsumer.consumeInstantly = true
        pageConsumer.add({state in state?.count}, onCountChanged)
    }
    
    @IBAction func onClickPlus(_ sender: UIButton) {
        pageStore?.dispatch(MainActionIncreaseCount())
    }
    
    @IBAction func onClickMinus(_ sender: UIButton) {
        pageStore?.dispatch(MainActionDecreaseCount())
    }
    
    @IBAction func onClickAddShared(_ sender: UIButton) {
        
        if let _ = activeController {
            activeController = nil
        } else {
            let vc: SubViewController = SubViewController.newInstance()
            print("assign pageInteractor \(String(describing: pageController.debugDescription))")
            vc.pageController = self.pageController
            activeController = vc
        }
    }
    
    private func removeSubController(inactiveVc: UIViewController?) {
        if let vc = inactiveVc {
            vc.willMove(toParent: nil)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
    }
    
    private func activateSubController() {
        if let vc = activeController {
            addChild(vc)
            containerView.addSubview(vc.view)
            vc.view.translatesAutoresizingMaskIntoConstraints = false
            vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
            vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
            vc.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
            vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
            vc.didMove(toParent: self)
        }
    }
    
    
    private func onCountChanged(prev: Int?, curr: Int) {
        print("Main - onCountChanged")
        countLb.text = "count: \(curr)"
    }
    
}

