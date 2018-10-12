//
//  ViewController.swift
//  SystemTest
//
//  Created by sanjay on 10/11/18.
//  Copyright © 2018 Aruna. All rights reserved.
//

import UIKit



class ViewController: BaseViewController,passWebServiceDelegate,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate {
    
    var allReposArr:NSMutableArray = NSMutableArray ()
     var filteredArr:NSMutableArray = NSMutableArray ()
    //declare a variable
    var searchBarActive : Bool? = false
    var filtered:[String] = []
    
    @IBOutlet weak var repoSearchBarObj: UISearchBar!
    @IBOutlet weak var repoTable: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.serviceParsingObj.delegate = self
        self.repoTable.isHidden = true
        self.repoTable.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        

        //api call for getting all repositories
        self.getApiCallForRepositories(urlStr: "https://api.github.com/search/repositories?q=watchers_count&order=desc&page=1&per_page=10")
    }
    
    func getApiCallForRepositories(urlStr: String) {
        if self.isConnectedToInternet()  {
            
            self.serviceParsingObj.callServiceWithUrlUsingGetRequest(urlStr,inputVCFromOtherVC: self)
            
        }else{
            self.showNoInternetAlert()
        }
    }
    func passWebServiceData(_ data: AnyObject!) {
       
        //binding data to model class
        let data = (data as? NSDictionary)!
        let allReposArray:NSArray = data.value(forKey: "items") as! NSArray
        allReposArr.removeAllObjects()
        for eachDict in allReposArray {
            let repoMdl:RepoModel = RepoModel()
            repoMdl.nameStr = (eachDict as? NSDictionary)?.value(forKey: "name") as? String
            repoMdl.fullNameStr = (eachDict as? NSDictionary)?.value(forKey: "full_name") as? String
            repoMdl.urlStr = (eachDict as? NSDictionary)?.value(forKeyPath: "owner.avatar_url") as? String
            repoMdl.projectUrl = (eachDict as? NSDictionary)?.value(forKeyPath: "owner.html_url") as? String
              repoMdl.descrStr = (eachDict as? NSDictionary)?.value(forKey: "description") as? String
            repoMdl.watcherCount = String(format:"%@",((eachDict as? NSDictionary)?.value(forKey: "watchers_count") as? NSNumber)!)
            repoMdl.contributorsUrl = String(format:"%@",((eachDict as? NSDictionary)?.value(forKey: "contributors_url") as? String)!)
            allReposArr.add(repoMdl)
        }
        
        self.repoTable.isHidden = false
        self.repoTable.reloadData()
    }
     // MARK: - TableView delegate methods
    func tableView(_ tableView:UITableView, numberOfRowsInSection section:Int) -> Int{
        if(searchBarActive!){
        return filteredArr.count
        }else{
          return allReposArr.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let identifier = "repoCell"
        var cell: RepositoryTableViewCell! = tableView.dequeueReusableCell(withIdentifier: identifier) as? RepositoryTableViewCell
        if cell == nil {
            self.repoTable.register(cell.classForCoder, forCellReuseIdentifier: identifier)
            cell = tableView.dequeueReusableCell(withIdentifier: identifier) as? RepositoryTableViewCell
        }
        
        cell.selectionStyle = .none
        let repoMdl:RepoModel;
        
        if(searchBarActive!){
            repoMdl = filteredArr[indexPath.row] as! RepoModel
            
        }else{
             repoMdl = allReposArr[indexPath.row] as! RepoModel
        }
        cell.repoLbl.text = repoMdl.nameStr
        cell.repoFullNameLbl.text = repoMdl.fullNameStr
        cell.repoWatcherCount.text = repoMdl.watcherCount
        
        cell.repoImg.sd_setImage(with: URL(string: repoMdl.urlStr!),
                              placeholderImage: nil,
                              options: [],
                              completed: nil)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 89
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.performSegue(withIdentifier: "detailsSegue", sender: indexPath)
    }
     // MARK: - filter button action
    @IBAction func filterBtnAction(_ sender: Any) {
        let alert = UIAlertController(title: "Filter", message: "Please Select an Option", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Watchers_Count", style: .default , handler:{ (UIAlertAction)in
            //api call for getting all repositories
            self.getApiCallForRepositories(urlStr: "https://api.github.com/search/repositories?q=watchers_count&order=desc&page=1&per_page=10")
        }))
        
        alert.addAction(UIAlertAction(title: "Name", style: .default , handler:{ (UIAlertAction)in
            //api call for getting all repositories
            self.getApiCallForRepositories(urlStr: "https://api.github.com/search/repositories?q=name&order=desc&page=1&per_page=10")
        }))
        alert.addAction(UIAlertAction(title: "Stars", style: .default , handler:{ (UIAlertAction)in
            //api call for getting all repositories
            self.getApiCallForRepositories(urlStr: "https://api.github.com/search/repositories?q=stars&order=desc&page=1&per_page=10")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive , handler:{ (UIAlertAction)in
            //nothing
        }))
        
        self.present(alert, animated: true, completion: {
            print("completion block")
        })
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "detailsSegue") {
            
            let indexPath:NSIndexPath = (sender as? NSIndexPath)!
            // pass data to next view
            let repoDetVC:RepoDetailsViewController = segue.destination as! RepoDetailsViewController
                repoDetVC.repoDet = allReposArr[indexPath.row] as? RepoModel
            
        }
    }
//MARK: - SearchBar delegate methods
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.characters.count == 0 {
            
            return
            
        }else{
            
            if filteredArr.count > 0{
                
                filteredArr.removeAllObjects()
                
            }
            
            let searchPredicate = NSPredicate(format: "nameStr contains[c] %@",searchText)
            
            let dataArra = allReposArr.filtered(using: searchPredicate)
            
            filteredArr.addObjects(from:dataArra)
            
            print(filteredArr)
            
        }
        
        
        if filteredArr.count > 0{
            searchBarActive = true;
            
        }else{
            searchBarActive = false;
            
        }
        
        self.repoTable.reloadData()
    }
    
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.searchBarActive = false
        self.repoSearchBarObj.text = ""
        self.repoSearchBarObj.resignFirstResponder()
        self.repoTable.reloadData()
        
    }
    
}

