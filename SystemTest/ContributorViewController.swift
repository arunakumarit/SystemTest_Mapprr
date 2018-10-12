//
//  ContributorViewController.swift
//  SystemTest
//
//  Created by sanjay on 10/12/18.
//  Copyright © 2018 Aruna. All rights reserved.
//

import UIKit

class ContributorViewController: BaseViewController,passWebServiceDelegate,UITableViewDelegate,UITableViewDataSource {
    
    var contributionDet:ContributorsModel?
    var allReposArr:NSMutableArray = NSMutableArray ()
    
    @IBOutlet weak var contributorImg: UIImageView!
    @IBOutlet weak var repoTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.serviceParsingObj.delegate = self
        self.repoTable.isHidden = true
        self.repoTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        self.contributorImg.sd_setImage(with: URL(string: (self.contributionDet?.urlStr!)!),
                                          placeholderImage: UIImage(named:"UserNo"),
                                          options: [],
                                          completed: nil)
        //api call
        if self.isConnectedToInternet()  {
            self.serviceParsingObj.callServiceWithUrlUsingGetRequest((self.contributionDet?.repoUrlStr!)!,inputVCFromOtherVC: self)
        }else{
            self.showNoInternetAlert()
        }
        
    }
  
   func passWebServiceData(_ data: AnyObject!) {
        //binding data to model class
        let  allReposArray:NSArray = (data as? NSArray)!
        for eachDict in allReposArray {
            let repoMdl:RepoModel = RepoModel()
            repoMdl.nameStr = (eachDict as? NSDictionary)?.value(forKey: "name") as? String
            repoMdl.fullNameStr = (eachDict as? NSDictionary)?.value(forKey: "full_name") as? String
            allReposArr.add(repoMdl)
        }
        
        self.repoTable.isHidden = false
        self.repoTable.reloadData()
    }
    
    
    
    // MARK: - TableView delegate methods
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        
        return allReposArr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let identifier = "repositoryCell"
        var cell: RepoTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RepoTableViewCell
        if cell == nil {
            self.repoTable.register(cell.classForCoder, forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? RepoTableViewCell
        }
        
        cell.selectionStyle = .none
        let repoMdl:RepoModel = allReposArr[indexPath.row] as! RepoModel
        cell.repoName.text = repoMdl.nameStr
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 55
    }


    @IBAction func backBtnAction(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   

}
