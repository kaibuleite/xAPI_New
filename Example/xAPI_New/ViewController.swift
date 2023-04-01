//
//  ViewController.swift
//  xAPI_New
//
//  Created by kaibuleite on 08/27/2021.
//  Copyright (c) 2021 kaibuleite. All rights reserved.
//

import UIKit
import xAPI_New

class ViewController: UIViewController {

    @IBOutlet weak var retArea: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    @IBAction func sendBtnClick(_ sender: UIButton) {
        var parameter = [String : String]()
        parameter["page"] = "1"
        API.post(urlStr: "c=Merchantapp&a=cityList", headers: nil, parameters: parameter) {
            [weak self] (rep) in
            guard let self = self else { return }
            // 响应失败不一定没数据，推荐用服务器实际返回的Data来判断接口是否成功
//            print(rep.apiData ?? "NULL")
            guard let data = rep.apiData else { return }
            self.retArea.text = "\(data)"
            
            guard arc4random() % 2 == 0 else { return }
            let alert = UIAlertController.init(title: "请求失败", message: "是否重新请求", preferredStyle: .alert)
            let sure = UIAlertAction.init(title: "确定", style: .default) {
                 (sender) in
                rep.request.send()
            }
            let cancel = UIAlertAction.init(title: "取消", style: .cancel)
            alert.addAction(sure)
            alert.addAction(cancel)
            self.present(alert, animated: true)
        }
    }
     
}

