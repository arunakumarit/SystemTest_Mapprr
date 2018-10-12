//
//  RepoDetailsViewController.swift
//  SystemTest
//
//  Created by sanjay on 10/12/18.
//  Copyright © 2018 Aruna. All rights reserved.
//

import UIKit


class RepoDetailsViewController: BaseViewController,UICollectionViewDataSource, UICollectionViewDelegate ,passWebServiceDelegate{
    
    var repoDet:RepoModel?
    var allContributorsArr:NSMutableArray?
    
    @IBOutlet weak var repoImg: UIImageView!
    @IBOutlet weak var repoDesc: UILabel!
    @IBOutlet weak var repoLink: UITextView!
    @IBOutlet weak var repoName: UILabel!
    @IBOutlet weak var contributorsCollectionView: UICollectionView!
   
    override func viewDidLoad() {
        super.viewDidLoad()
        allContributorsArr = NSMutableArray()
        self.serviceParsingObj.delegate = self
        self.repoImg.sd_setImage(with: URL(string: (repoDet?.urlStr!)!),
                                 placeholderImage: nil,
                                 options: [],
                                 completed: nil)
        self.repoName.text = repoDet?.nameStr
        self.repoLink.text = repoDet?.projectUrl
        self.repoDesc.text = repoDet?.descrStr
        self.repoLink.isEditable = false
        self.repoLink.dataDetectorTypes = .link
        
        //service call
        if self.isConnectedToInternet()  {
            self.serviceParsingObj.callServiceWithUrlUsingGetRequest((repoDet?.contributorsUrl)!,inputVCFromOtherVC: self)
            
        }else{
            self.showNoInternetAlert()
        }

    }
    
    
    func passWebServiceData(_ data: AnyObject!) {
        //binding data to model class
     let  contributorsArr:NSArray = (data as? NSArray)!
        for eachDict in contributorsArr {
            let contributorMdl:ContributorsModel = ContributorsModel()
            contributorMdl.urlStr = (eachDict as? NSDictionary)?.value(forKey: "avatar_url") as? String
            contributorMdl.nameStr = (eachDict as? NSDictionary)?.value(forKey: "login") as? String
            contributorMdl.repoUrlStr = (eachDict as? NSDictionary)?.value(forKey: "repos_url") as? String
            allContributorsArr?.add(contributorMdl)
        }
       self.contributorsCollectionView.reloadData()
    }
    
    // MARK: - Back button action
    @IBAction func backBtnAction(_ sender: Any) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    // MARK: - collection view delegate methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (allContributorsArr?.count)!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell:ContributorsCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "contributorsCell", for: indexPath as IndexPath) as! ContributorsCollectionViewCell
        let contributionMdl:ContributorsModel = allContributorsArr![indexPath.row] as! ContributorsModel
        myCell.nameLbl.text = contributionMdl.nameStr
        myCell.contributorImg.sd_setImage(with: URL(string: contributionMdl.urlStr!),
                                 placeholderImage: UIImage(named:"UserNo"),
                                 options: [],
                                 completed: nil)
        myCell.contributorImg.layer.cornerRadius = myCell.contributorImg.frame.height/2
        myCell.contributorImg.clipsToBounds = true
        return myCell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        return CGSize(width:134,height:111)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        self.performSegue(withIdentifier: "contributorSegue", sender: indexPath)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - segue methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "contributorSegue") {
            
            let indexPath:NSIndexPath = (sender as? NSIndexPath)!
            // pass data to next view
            let repoDetVC:ContributorViewController = segue.destination as! ContributorViewController
            repoDetVC.contributionDet = allContributorsArr?[indexPath.row] as? ContributorsModel
            
        }
    }

}
