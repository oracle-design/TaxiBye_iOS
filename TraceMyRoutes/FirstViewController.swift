//
//  FirstViewController.swift
//  TraceMyRoutes
//
//  Created by sean on 2017/1/24.
//  Copyright © 2017年 oddesign. All rights reserved.
//

import UIKit
import SVProgressHUD

class FirstViewController: UIViewController {

    @IBOutlet weak var trackButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var line: UIView!
    @IBOutlet weak var plateNumberTextfield: UITextField!

    @IBOutlet weak var trackButtonHeightConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)

        SVProgressHUD.setMinimumDismissTimeInterval(2)
    }

    override func viewWillAppear(_ animated: Bool) {

        initUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func initUI() {


        settingUIForTrackButton()
        settingUIForLine()
        settingUIForPlateNumberTextfield()

        
    }
    func settingUIForTrackButton() {
        trackButtonHeightConstraint.constant = AppConfig.buttonHeight
        trackButton.layer.cornerRadius = AppConfig.buttonHeight / 2.0
    }
    func settingUIForLine() {

    }
    func settingUIForPlateNumberTextfield() {

    }


}
