//
//  HomePageViewController.swift
//  DashStori
//
//  Created by George on 20/03/17.
//  Copyright © 2017 QBurst. All rights reserved.
//

import UIKit
import Kingfisher

class HomePageViewController: BaseViewController {
    
    @IBOutlet weak var noStoriesCreated: UILabel!
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var myStoriesButton: UIButton!
    @IBOutlet weak var latestStoriesButton: UIButton!
    @IBOutlet weak var tableStoriList: UITableView!
    
    var logoutView: UIView?
    var profileView:UIView?
    
    var navigationMode:Bool = false
    var myStoriPageNumber = 1
    var latestStoriPageNumber = 1
    var currentTab: String = MY_STORI
    var myStoriList:[StoriDetailsList] = []
    var latestStoriList:[StoriDetailsList] = []
    var myStoriTotalPages = 0
    var latestStoriTotalPages = 0
    var storiId:Int = 0
    var cellNumber:Int = 0
    var token:String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableStoriList.delegate = self
        self.tableStoriList.dataSource = self
        
        Utilities.showNavigationHeader(currentViewController: self)
        tableStoriList.tableFooterView = UIView()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(!navigationMode){
            navigationMode = false
            myStoriList = []
            latestStoriList = []
            myStoriPageNumber = 1
            latestStoriPageNumber = 1
            checkIfLogined()
            super.viewWillAppear(animated)
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    override func isMenuHeaderHidden() -> Bool {
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "homeToStoriDetails"){
            let storiDetailsVC = segue.destination as! StoriDetailsViewController
            let storiId = sender as! Int
            
            let storiDetails = StoriDetails()
            var storiDetailsList = StoriDetailsList()
            
            if(currentTab == MY_STORI){
                storiDetailsList = myStoriList[cellNumber]
            }else {
                storiDetailsList = latestStoriList[cellNumber]
            }
            
            storiDetails.authorName = storiDetailsList.authorName
            storiDetails.authorPicUrl = storiDetailsList.authorPicUrl
            storiDetails.publishedOn = storiDetailsList.publishedOn
            
            storiDetailsVC.storiID = storiId
            storiDetailsVC.storiDetails = storiDetails
            
        }else if(segue.identifier == "navigateToWiteStori"){
            if(currentTab == MY_STORI){
                if(selectedOneisDraft){
                    let editStori = segue.destination as! WriteStoriViewController
                    editStori.editMode = true
                    editStori.storiId = storiId
                    editStori.saveAsDraftFlag = true
                }
            }
        }
    }
    
    //MARK: @IBAction
    @IBAction func latestStoriesTab(_ sender: Any) {
        currentTab = LATEST_STORI
        refreshView()
        self.tableStoriList.reloadData()
        if(latestStoriList.count == 0){
            self.noStoriesCreated.isHidden = false
        }else{
            self.noStoriesCreated.isHidden = true
        }
    }
    
    @IBAction func newStoriAction(_ sender: Any) {
        selectedOneisDraft = false
        navigateToCreateStori()
    }
    @IBAction func myStoriesTab(_ sender: Any) {
        currentTab = MY_STORI
        refreshView()
        self.tableStoriList.reloadData()
        if(myStoriList.count == 0){
            self.noStoriesCreated.isHidden = false
        }else{
            self.noStoriesCreated.isHidden = true
        }
    }
    
    func refreshView(){
        if(currentTab == MY_STORI){
            myStoriesButton.backgroundColor = Utilities.getColor(hex: COLOR_RED)
            latestStoriesButton.backgroundColor = Utilities.getColor(hex: COLOR_ASH)
        } else {
            latestStoriesButton.backgroundColor = Utilities.getColor(hex: COLOR_RED)
            myStoriesButton.backgroundColor = Utilities.getColor(hex: COLOR_ASH)
        }
    }
    //MARK: slidingMenu
    func slidingMenuAfterLogin(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let aVariable = appDelegate.leftViewController as! NavigationSlideMenuController
        aVariable.logoutView.isHidden = false
        aVariable.profileView.isHidden = false
        aVariable.loginView.isHidden = true
    }
    func slidingMenuBeforeLogin(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let aVariable = appDelegate.leftViewController as! NavigationSlideMenuController
        aVariable.logoutView.isHidden = true
        aVariable.profileView.isHidden = true
        aVariable.loginView.isHidden = false
    }
    //MARK: API call
    func showStories(myStori:Int,pageNumber:Int){
        Utilities.showActivityIndicatory()
        let storiManager = DashStoriManager()
        storiManager.getListOfStories(myStori: myStori, page: pageNumber){
            (data,error) in
            Utilities.hideActivityIndicatory()
            if(data != nil){
                let response=data as! ListOfStoriesResponse
                if(response.isMystori){
                    self.myStoriList = self.myStoriList + response.data
                    self.myStoriTotalPages = response.totalPages
                    if(response.data.count == 0){
                        if(self.currentTab == MY_STORI){
                            self.noStoriesCreated.isHidden = false
                        }
                    }else{
                        self.noStoriesCreated.isHidden = true
                    }
                }else{
                    self.latestStoriList = self.latestStoriList + response.data
                    self.latestStoriTotalPages = response.totalPages
                    if(response.data.count != 0 && self.currentTab != MY_STORI){
                        self.noStoriesCreated.isHidden = true
                    }else if(self.token == ""){
                        self.noStoriesCreated.isHidden = true
                    }
                }
                self.tableStoriList.reloadData()
            }else{
                self.showAlertMessage(errorMessage: error.message!)
            }
        }
    }
    
    //MARK: check If Logined in
    func checkIfLogined(){
        token = Utilities.getUserToken()
        if (token == ""){
            showStories(myStori:0,pageNumber: latestStoriPageNumber)
            myStoriesButton.isHidden = true
            latestStoriesButton.isEnabled = false
            self.latestStoriesTab(self)
            slidingMenuBeforeLogin()
        }else{
            showStories(myStori:1,pageNumber: myStoriPageNumber)
            showStories(myStori:0,pageNumber: latestStoriPageNumber)
            myStoriesButton.isHidden = false
            latestStoriesButton.isEnabled = true
            slidingMenuAfterLogin()
        }
        
    }
    //MARK: Navigate
    func navigateToCreateStori(){
        if(token == ""){
            navigateToLogin()
        }else{
            navigateToEditPage()
        }
    }
    func navigateToLogin(){
        self.performSegue(withIdentifier: "navigateToLogin", sender: self)
    }
    func navigateToEditPage(){
        self.performSegue(withIdentifier: "navigateToWiteStori", sender: self)
    }
    //MARK: Load more data
    func loadMoreData(){
        // call your API for more data
        if(currentTab == MY_STORI){
            if(myStoriPageNumber < self.myStoriTotalPages){
                myStoriPageNumber += 1
                showStories(myStori:1,pageNumber: myStoriPageNumber)
            }
        }else{
            if(latestStoriPageNumber < self.latestStoriTotalPages){
                latestStoriPageNumber += 1
                showStories(myStori:0,pageNumber: latestStoriPageNumber)
            }
//                else if(token == "") //aa
//            {
//                showAlertMessage(errorMessage: "Please login to continue")
//            }
        }
    }
}

//MARK: TableViewDelegate
extension HomePageViewController:UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(currentTab == MY_STORI){
            if(indexPath.row == myStoriList.count-2){
                loadMoreData()
            }
            if(indexPath.row == 0){/*for first row*/
                let storyListCell = tableView.dequeueReusableCell(withIdentifier: "firstStoryCell") as! PrimaryCell
                setView(cell:storyListCell,storiList: myStoriList,index:indexPath)
                return storyListCell
            }else {
                let storyListCell = tableView.dequeueReusableCell(withIdentifier: "storyListCell") as! SecondaryCell
                setSecondaryView(cell:storyListCell,storiList: myStoriList,index:indexPath)
                return storyListCell
            }
        }else{
            if(indexPath.row == latestStoriList.count-2){
                loadMoreData()
            }
            if(indexPath.row == 0){/*for first row*/
                let storyListCell = tableView.dequeueReusableCell(withIdentifier: "firstStoryCell") as! PrimaryCell
                setView(cell:storyListCell,storiList: latestStoriList,index:indexPath)
                return storyListCell
            }else {
                let storyListCell = tableView.dequeueReusableCell(withIdentifier: "storyListCell") as! SecondaryCell
                setSecondaryView(cell:storyListCell,storiList: latestStoriList,index:indexPath)
                return storyListCell
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 150
        }else{
            return 80
        }
    }
    
    func viewStoriDetails(){
        
        self.performSegue(withIdentifier: "homeToStoriDetails", sender: storiId)
    }
    
    func set(imageUrl:String,image:UIImageView,isRounded:Bool){
        if (imageUrl != "") {
            let url = URL(string: IMAGE_URL + imageUrl)
            image.kf.setImage(with: url)
            if(isRounded == true){
                Utilities.createCircularImage(imageview: image)
            }
        }else{
            if(isRounded == true){
                image.image = #imageLiteral(resourceName: "avtar_small")
            }else{
                image.image = #imageLiteral(resourceName: "avtar_big")
            }
        }
    }
    //MARK set Cell
    func setView(cell:PrimaryCell,storiList:[StoriDetailsList],index:IndexPath){
        if(index.row <= storiList.count && storiList.count != 0){
            
            set(imageUrl:storiList[index.row].coverPic,image:cell.coverPic,isRounded: false)
            cell.imageCount.text = String(storiList[index.row].imageCount)
            cell.videoCount.text = String(storiList[index.row].videoCount)
            cell.documentCount.text = String(storiList[index.row].docCount)
            cell.storiTitle.text = storiList[index.row].storiTitle
            cell.storiDescription.text = storiList[index.row].storiDescription
            cell.authorName.text = storiList[index.row].authorName
            cell.publishedOn.text = storiList[index.row].publishedOn
            set(imageUrl:storiList[index.row].authorPicUrl,image:cell.authorImage,isRounded: true)
            cell.storyStatus.text = getStoryStatus(storiList: storiList[index.row])
        }
    }
    
    func setSecondaryView(cell:SecondaryCell,storiList:[StoriDetailsList],index:IndexPath){
        if(index.row <= storiList.count && storiList.count != 0){
            set(imageUrl:storiList[index.row].coverPic,image:cell.coverPic,isRounded: false)
            cell.imageCount.text = String(storiList[index.row].imageCount)
            cell.videoCount.text = String(storiList[index.row].videoCount)
            cell.documentCount.text = String(storiList[index.row].docCount)
            cell.storiTitle.text = storiList[index.row].storiTitle
            cell.storiDescription.text = storiList[index.row].storiDescription
            cell.authorName.text = storiList[index.row].authorName
            cell.publishedOn.text = storiList[index.row].publishedOn
            set(imageUrl:storiList[index.row].authorPicUrl,image:cell.authorImage,isRounded: true)
            cell.storyStatus.text = getStoryStatus(storiList: storiList[index.row])
        }
    }
    
    func getStoryStatus(storiList: StoriDetailsList) -> String {
        if storiList.isDraft {
            return "DRAFT"
        }
        else if !storiList.verified {
            return "IN REVIEW"
        }
        else {
            return ""
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(currentTab == MY_STORI){
            return myStoriList.count
        }else {
            return latestStoriList.count
        }
    }
}
var selectedOneisDraft:Bool = false
extension HomePageViewController:UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if(token != ""){ //aa
            self.cellNumber = indexPath.row
            if(currentTab == MY_STORI){
                storiId = myStoriList[indexPath.row].storiId
            }else{
                storiId = latestStoriList[indexPath.row].storiId
            }
            if(currentTab == MY_STORI){
                if(myStoriList[indexPath.row].isDraft){
                    selectedOneisDraft = true
                    navigateToEditPage()
                    return
                }
            }
            viewStoriDetails()
//        }else{ //aa
//            navigateToLogin()
//        }
    }
}
