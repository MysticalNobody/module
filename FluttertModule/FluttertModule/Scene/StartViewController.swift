//
//  StartViewController.swift
//  FluttertModule
//
//  Created by Stanislav Rychagov on 02.08.2021.
//

import UIKit
import Flutter
import FlutterPluginRegistrant

public class StartViewController: UIViewController {

    lazy var flutterEngine = FlutterEngine(name: "my flutter engine")

    public override func viewDidLoad() {
        super.viewDidLoad()
        flutterEngine.run();
        GeneratedPluginRegistrant.register(with: self.flutterEngine)
        setup()
    }

    func setup(){
        let vc = FlutterViewController(engine: flutterEngine, nibName: nil, bundle: nil)
        addChild(vc)
        vc.view.frame = view.frame
        view.addSubview(vc.view)
        vc.didMove(toParent: self)
    }

}
