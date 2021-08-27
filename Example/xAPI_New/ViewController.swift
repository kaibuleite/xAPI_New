//
//  ViewController.swift
//  xAPI_New
//
//  Created by kaibuleite on 08/27/2021.
//  Copyright (c) 2021 kaibuleite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var retArea: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func sendBtnClick(_ sender: UIButton) {
        API.testReq {
            [weak self] (isSuccess, data) in
            guard let self = self else { return }
            self.retArea.text = "\(data)"
        }
    }
}

