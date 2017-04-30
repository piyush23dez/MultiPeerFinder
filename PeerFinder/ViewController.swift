//
//  ViewController.swift
//  PeerFinder
//
//  Created by Piyush Sharma on 4/29/17.
//  Copyright © 2017 Piyush Sharma. All rights reserved.
//

import UIKit

extension UIViewController {
    
    class var topViewController: UIViewController? {
        var topController = UIApplication.shared.keyWindow?.rootViewController
        while topController != nil && topController!.presentedViewController != nil {
            topController = topController!.presentedViewController
        }
        return topController
    }
    
    func showToast(message: String) {
        if let view = view.viewWithTag(5) {
            view.removeFromSuperview()
        }
        
        let label = UILabel(frame: CGRect(x: self.view.center.x-225, y: 100, width: 500, height: 100))
        label.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        label.textColor = UIColor.white
        label.textAlignment = .center;
        label.font = UIFont(name: "Montserrat-Light", size: 12.0)
        label.text = message
        label.alpha = 1.0
        label.tag = 5
        label.layer.cornerRadius = 10
        label.clipsToBounds  =  true
        self.view.addSubview(label)
        UIView.animate(withDuration: 2.0, delay: 0.1, options: .curveEaseOut, animations: {
            label.alpha = 0.0
        }, completion: {(isCompleted) in })
    }
}

class ViewController: UIViewController {
    @IBOutlet weak var connections: UILabel!
   
    let peerService = PeerServiceManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peerService.delegate = self
    }
    
    @IBAction func yellowTapped(_ sender: Any) {
        self.change(color: .yellow)
        let dictionary = ["color": "yellow", "value1": "1"]
        peerService.send(message: dictionary)
    }
    
    @IBAction func redTapped(_ sender: Any) {
        self.change(color: .red)
        let dictionary = ["color": "red", "value1": "2"]
        peerService.send(message: dictionary)
    }
    
    func change(color : UIColor) {
        UIView.animate(withDuration: 2) {
            self.view.backgroundColor = color
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: PeerServiceManagerDelegate {
    
    func connectedDevicesChanged(manager: PeerServiceManager, connectedDevices: [String]) {
        self.connections.text = "Connections: \(connectedDevices)"
    }
    
    func messageReceived(manager: PeerServiceManager, message: [String : Any]) {
        OperationQueue.main.addOperation {
            if let color = message["color"] as? String {
                switch color {
                case "red":
                    self.change(color: .red)
                case "yellow":
                    self.change(color: .yellow)
                default:
                    NSLog("%@", "Unknown color value received: \(color)")
                }
            }
        }
    }
}

