//
//  BaseViewController.swift
//  SystemTest
//
//  Created by sanjay on 10/11/18.
//  Copyright © 2018 Aruna. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
  let serviceParsingObj = ServiceParsingClass()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    //MARK: show  alert
    func showAlertWithMessage(msgStr:String)  {
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: "Tutoree", message:msgStr, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            // callback on earlier versions
            let alert = UIAlertView()
            alert.title = "Alert!"
            alert.message = msgStr
            alert.addButton(withTitle:"Ok")
            alert.show()
        }
    }
    //MARK: show  internet alert
    func showNoInternetAlert()  {
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: "Network", message:"No Internet Connection", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            // callback on earlier versions
            let alert = UIAlertView()
            alert.addButton(withTitle:"Ok")
            alert.show()
        }
    }
    //checking network
    func isConnectedToInternet() -> Bool {
        
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
        let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
        return (isReachable && !needsConnection)
        
    }
    //MARK:ProgressIndicator methods
    func showProgressIndicator()  {
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
    func hideProgressIndicator()  {
        DispatchQueue.main.async(){
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    


}
