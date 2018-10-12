//
//  ServiceParsingClass.swift
//  SystemTest
//
//  Created by sanjay on 10/11/18.
//  Copyright © 2018 Aruna. All rights reserved.
//

import UIKit



protocol passWebServiceDelegate {
    func passWebServiceData(_ data: AnyObject!)
}

class ServiceParsingClass: UIViewController {
    //declare delegate
    var delegate: passWebServiceDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK:GET request
    func callServiceWithUrlUsingGetRequest(_ urlStr:String,inputVCFromOtherVC:UIViewController)  {
        MBProgressHUD.showAdded(to: inputVCFromOtherVC.view, animated: true)
        let request = NSMutableURLRequest(url: URL(string:urlStr)!)
        request.timeoutInterval = 60.0
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            if error != nil{
                print("Error -> \(String(describing: error?.localizedDescription))")
                DispatchQueue.main.async(execute: {
                    MBProgressHUD.hide(for: inputVCFromOtherVC.view, animated: true)
                })
                return
            }
            
            do {
                
                let res = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers)
                DispatchQueue.main.async(execute: {
                    MBProgressHUD.hide(for: inputVCFromOtherVC.view, animated: true)
                    self.delegate?.passWebServiceData(res as AnyObject!)
                })
                
            } catch {
                //No data available
                DispatchQueue.main.async(execute: {
                    MBProgressHUD.hide(for: inputVCFromOtherVC.view, animated: true)
                    // self.showAlertWithMessage(msgStr: "No data available", inputVC:inputVCFromOtherVC)
                })
            }
            
        })
        task.resume()
    }
        //MARK:POST request
        func callServiceWithUrlUsingPostRequest(_ urlStr:String, params: NSDictionary,inputVCFromOtherVC:UIViewController)  {
            MBProgressHUD.showAdded(to: inputVCFromOtherVC.view, animated: true)
            let request = NSMutableURLRequest(url: URL(string:urlStr)!)
            request.timeoutInterval = 60.0
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try! JSONSerialization.data(withJSONObject: params, options: [])
            let task = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
                if error != nil{
                    print("Error -> \(String(describing: error))")
                    DispatchQueue.main.async(execute: {
                        MBProgressHUD.hide(for: inputVCFromOtherVC.view, animated: true)
                    })
                    return
                }
                do {
                    let res = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! [String:Any]
                    
                    DispatchQueue.main.async(execute: {
                        MBProgressHUD.hide(for: inputVCFromOtherVC.view, animated: true)
                        self.delegate?.passWebServiceData(res as AnyObject!)
                    })
                    
                } catch {
                    DispatchQueue.main.async(execute: {
                        MBProgressHUD.hide(for: inputVCFromOtherVC.view, animated: true)
                        //self.showAlertWithMessage(msgStr: "No data available.", inputVC:inputVCFromOtherVC)
                    })
                }
            })
            task.resume()
        }

        //MARK: show  alert
        func showAlertWithMessage(msgStr:String, inputVC:UIViewController)  {
            if #available(iOS 8.0, *) {
                let alertController = UIAlertController(title: "Alert", message:msgStr, preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                inputVC.present(alertController, animated: true, completion: nil)
            } else {
                // callback on earlier versions
                let alert = UIAlertView()
                alert.title = "Alert"
                alert.message = msgStr
                alert.addButton(withTitle:"Ok")
                alert.show()
            }
        }
   

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

  

}
