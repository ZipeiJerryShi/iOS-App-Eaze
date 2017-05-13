//
//  ViewController.swift
//  Eaze
//
//  Created by Jerry Shi on 1/17/17.
//  Copyright © 2017 easeapp. All rights reserved.
//

import UIKit
import CoreData

var onboardingAnimatedOnce: Bool = false


class ViewController: UIViewController, FBSDKLoginButtonDelegate, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var users: [NSManagedObject] = []

    
    var pageViewController: UIPageViewController!
    var pageTitles: NSArray!
    var pageSubTitles: NSArray!
    var pageImages: NSArray!
    
    let bgImageView = UIImageView(image: UIImage(named: "onboarding_bg"))
    let kOnboarding = "Onboarding"
    
    
    let loginButton: FBSDKLoginButton = {
        let button = FBSDKLoginButton()
        button.readPermissions = ["email"]
        return button
    }()
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //onboarding pageview
        setupPageViewController()
        
        
        
        //login
        view.addSubview(loginButton)
        //loginButton.center = view.center
        
        loginButton.frame = CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height - 100, width: 300, height: 50)
        
        loginButton.delegate = self
        if let token = FBSDKAccessToken.current() {
            fetchProfile()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        fetch()
    }
    
    
    func fetch() {
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "User")
        
        //3
        do {
            users = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        //mixpanelHelper(kViewAppearedEvent, parameters: nil, view: kOnboarding)
//        animateSubViews()
//        LoginMethods.logoutUser(self, userLogout: false)
//        self.timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(self.timeOutAlertWhenNoInternet), userInfo: nil, repeats: false)
//        self.timer2 = Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.delayForMigrationToStart), userInfo: nil, repeats: false)
//    }
//    
//    var alert = UIAlertController()
//    var spinner = UIActivityIndicatorView()
//    var delayRanOnce = false
//    var timer2 = Timer()
//    var timer = Timer()
//    var failedMigrationAlertShownOnce = false
//    
//    @objc func timeOutAlertWhenNoInternet() {
//        timer.invalidate()
//        log("timeOutAlertWhenNoInternet ran")
//        if failedMigrationAlertShownOnce == false {
//            failedMigrationAlertShownOnce = true
//            if PFUser.current() != nil {
//                self.spinner.stopAnimating()
//                self.spinner.removeFromSuperview()
//                self.dismiss(animated: true, completion: {})
//                self.alert.message = "Migration Failed! Please log in. If you've forgotten your password tap Forgot Password."
//                self.alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (UIAlertAction) in }))
//                self.present(self.alert, animated: true, completion: {})
//            }
//        }
//    }
    
    //setup pageViewController
    func setupPageViewController() {
        UIApplication.shared.statusBarStyle = .lightContent
        
        navigationController?.isNavigationBarHidden = true
        
        pageTitles = NSArray(objects: "Welcome to Eaze!", "Locate Nearby Salon", "Book Appointments", "Receive Rewards")
        let initialSubtitle = "Swipe to Learn More :)"
        let whatSubtitle = "Eaze provides you with a list of nearby salons that you can choose from, simply select and explore the salon shop with barber details and reviews :)"
        let howSubtitle = "After you select your salon and barber, make an appointment with the barber so you can skip the  waiting line, you can even pay for the services in the app :)"
        let whySubtitle = "Every appointment you book, you receive Eaze credits, enough Eaze credit can reward you free haircuts and more! Start your Eaze journey right now :)"
        
        pageSubTitles = NSArray(objects: initialSubtitle, whatSubtitle, howSubtitle, whySubtitle)
        let imageView1 = UIImageView(image: UIImage(named: "eazeBigbig1x"))
        let imageView2 = UIImageView(image: UIImage(named: "nearbyBigbig1x"))
        let imageView3 = UIImageView(image: UIImage(named: "bookBigbig1x"))
        let imageView4 = UIImageView(image: UIImage(named: "rewardBigbig1x"))
        pageImages = NSArray(objects: imageView1, imageView2, imageView3, imageView4)
        
        
        // Create page view controller
        pageViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnboardingPageViewController") as! UIPageViewController
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        let startingViewController: OnboardingSubViewController = self.viewControllerAtIndex(0)
        let viewControllers: [UIViewController]?
        viewControllers = [startingViewController]
        pageViewController.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
        
        // Change the size of page view controller
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height - 154)
        
        self.addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        pageViewController.didMove(toParentViewController: self)
        
        //self.signUpButton.addTarget(self, action: #selector(self.openSignUpViewController), for: .touchUpInside)
        //self.loginButton.addTarget(self, action: #selector(self.openLoginViewController), for: .touchUpInside)
        
        self.view.addSubview(bgImageView)
        self.view.sendSubview(toBack: bgImageView)
        bgImageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(self.view).inset(UIEdgeInsetsMake(0, 0, 0, 0))
        }
        
    }
    
    func viewControllerAtIndex(_ index: Int) -> OnboardingSubViewController {
        if self.pageTitles.count == 0 || index >= pageTitles.count {
            return OnboardingSubViewController()
        }
        
        let vc: OnboardingSubViewController = self.storyboard?.instantiateViewController(withIdentifier: "OnboardingSubViewController") as! OnboardingSubViewController
        vc.titleText = self.pageTitles[index] as! String
        vc.subTitleText = self.pageSubTitles[index] as! String
        vc.imageView = self.pageImages[index] as! UIImageView
        vc.pageIndex = index
        
        return vc
    }
    
    func animateSubViews() {
        if !onboardingAnimatedOnce {
            onboardingAnimatedOnce = true
            let translation = CGAffineTransform(translationX: 0, y: 3)
            let scale = CGAffineTransform(scaleX: 0.99, y: 0.99)
            for subview in self.view.subviews {
                if subview != bgImageView {
                    //                    log("subview = \(subview)")
                    UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .allowAnimatedContent, animations: {
                        subview.transform = translation.concatenating(scale)
                    }, completion: { (complete) in })
                }
            }
        }
    }
    
    //MARK: PageViewController DataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! OnboardingSubViewController
        var index = vc.pageIndex as Int
        
        if index == 0 || index == NSNotFound {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = viewController as! OnboardingSubViewController
        var index = vc.pageIndex as Int
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == self.pageTitles.count {
            return nil
        }
        
        return self.viewControllerAtIndex(index)
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pageTitles.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
//        for vc in pendingViewControllers {
//            let v = vc as! OnboardingSubViewController
//            let i = v.pageIndex as Int
//            if i == 0 {
//                log("page1")
//                mixpanelHelper(kSwipedViewEvent, parameters: ["View": "Onboarding Page 1"], view: self.kOnboarding)
//            } else if i == 1 {
//                log("page2")
//                mixpanelHelper(kSwipedViewEvent, parameters: ["View": "Onboarding Page 2"], view: self.kOnboarding)
//            } else if i == 2 {
//                log("page3")
//                mixpanelHelper(kSwipedViewEvent, parameters: ["View": "Onboarding Page 3"], view: self.kOnboarding)
//            } else if i == 3 {
//                log("page4")
//                mixpanelHelper(kSwipedViewEvent, parameters: ["View": "Onboarding Page 4"], view: self.kOnboarding)
//            }
//        }
    }
    
    
    //login with Facebook
    func fetchProfile(){
        print("Fetch Profile")
        
        let localProfilePicImage: NSData? = nil
        let phoneNumber = 0
        FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "email, first_name, last_name, id, gender, picture.type(large)"])
            .start(completionHandler:  {
                (connection, result, error) in
                guard
                    let result = result as? NSDictionary,
                    let email = result["email"] as? String,
                    let first_name = result["first_name"] as? String,
                    let last_name = result["last_name"] as? String,
                    let user_gender = result["gender"] as? String,
                    let user_id_fb = result["id"]  as? String
                    //let picture = result["picture.type(large)"] as? NSDictionary, let data = picture["data"] as? NSDictionary, let url = data["url"] as? String
                    else {
                        return
                }
                
                GlobalVariables.userFirstName = first_name
                GlobalVariables.userLastName = last_name
                GlobalVariables.userId = user_id_fb
                GlobalVariables.userEmail = email
                GlobalVariables.userGender = user_gender
                
                print(email) //getting the email of the user
                print(first_name) //user name
                print(last_name)
                print(user_gender) //user gender
                print(user_id_fb) //facebook id
                
                checkAndStoreOrUpdateUser(user_id_fb, firstName: first_name, lastName: last_name, phoneNumber: Int32(phoneNumber), email: email)
                
                /*
                if let picture = result["picture.type(large)"] as? [String:Any] ,
                    let imgData = picture["data"] as? [String:Any] ,
                    let imgUrl = imgData["url"] as? String {
                    GlobalVariables.userPicUrl = imgUrl
                    print(imgUrl)   //profile image url
                }*/
                
                let profilePicUrl = "https://graph.facebook.com/\(user_id_fb)/picture?type=large&return_ssl_resources=1"
                GlobalVariables.userPicUrl = profilePicUrl
                print(GlobalVariables.userPicUrl)
                self.performSegue(withIdentifier: "loginToAppSegue", sender: self)
            
                
            })
    }
    
//    func save(firstName: String, lastName: String, email: String) {
//        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
//            return
//        }
//        let managedContext = appDelegate.persistentContainer.viewContext
//        let entity = NSEntityDescription.entity(forEntityName: "User", in: managedContext)!
//        let user = NSManagedObject(entity: entity, insertInto: managedContext)
//        
//        user.setValue(firstName, forKeyPath: "firstName")
//        user.setValue(lastName, forKeyPath: "lastName")
//        user.setValue(email, forKeyPath: "email")
//        
//        do {
//            try managedContext.save()
//            users.append(user)
//        } catch let error as NSError {
//            print("Could not save. \(error), \(error.userInfo)")
//        }
//    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //delegate methods
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        print("Completed login")
        self.performSegue(withIdentifier: "loginToAppSegue", sender: self)
    }
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
    }
    func loginButtonWillLogin(_ loginButton: FBSDKLoginButton!) -> Bool {
        return true
    }
}

