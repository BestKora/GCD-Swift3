//
//  ViewController.swift
//  Tsan
//
//  Created by Tatiana Kornilova on 1/22/17.
//  Copyright © 2017 Tatiana Kornilova. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        var usualString = ""
        
        func task(_ symbol: String) {
            for i in 1...10 {
                print("\(symbol) \(i) приоритет = \(qos_class_self().rawValue)");
               usualString = usualString + symbol
            }
        }
        let workerQueue1 = DispatchQueue(label: "com.bestkora.worker_concurrent1",  qos: .userInitiated, attributes: .concurrent)
        let workerQueue2 = DispatchQueue(label: "com.bestkora.worker_concurrent2",  qos: .background, attributes: .concurrent)
        
       
        workerQueue1.async  {task("😀")}
        workerQueue2.async {task("👿")}

        }
}

