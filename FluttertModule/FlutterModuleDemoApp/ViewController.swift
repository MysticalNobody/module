//
//  ViewController.swift
//  FlutterModuleDemoApp
//
//  Created by Stanislav Rychagov on 02.08.2021.
//

import UIKit
import FluttertModule

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
      //  let vc = StartViewController()
        let vc = StartViewController()
        addChild(vc)
        vc.view.frame = view.frame
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }


}

