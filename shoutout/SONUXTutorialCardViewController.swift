//
//  SONUXTutorialCardViewController.swift
//  shoutout
//
//  Created by Raj Ramamurthy on 1/25/16.
//  Copyright © 2016 Mayank Jain. All rights reserved.
//

import Foundation
import UIKit

class SONUXTutorialCardViewController: UIViewController {
    
    @IBOutlet var contentView: UIView!
    @IBOutlet var slideTitle: UILabel!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var noButton: UIButton!
    
    var currentSlide = 0
    var contentViewControllers: [UIViewController!]
    weak var popover: SOPopoverViewController!
    weak var delegate: ViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createViewControllers()
    }
    
    @IBAction func noButtonPressed(sender: AnyObject) {
        if (contentView.subviews.count > 0) {
            contentView.subviews[0].removeFromSuperview()
        }
        if (currentSlide == 3) {
            currentSlide = (currentSlide + 1) % contentViewControllers.count
            displayViewController(currentSlide)
        } else if (currentSlide == 5) {
            let alertview = JSSAlertView().show(self, title: "Sorry, this is a location-based app", text: "We can’t let you explore it if you don't share your location.\n\nWe hope you change your mind, otherwise, it’s been really nice chilling with you.", buttonText: "Okay, fine", color:UIColor(CSS: "2ECEFF"), cancelButtonText: "Still no")
            alertview.addAction {
                self.delegate.completeNUX()
            }
            alertview.addCancelAction({ 
                self.delegate.completeNUX()
            })
            alertview.setTitleFont("Titillium-Bold")
            alertview.setTextFont("Titillium")
            alertview.setButtonFont("Titillium-Light")
            alertview.setTextTheme(.Light)
        }
    }
    
    @IBAction func nextButtonPressed(sender: UIButton) {
        if (contentView.subviews.count > 0) {
            contentView.subviews[0].removeFromSuperview()
        }
        if (currentSlide == 3) {
            let application = UIApplication.sharedApplication();
            
            let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
            application.registerUserNotificationSettings(settings)
            application.registerForRemoteNotifications()
            PFAnalytics.trackEvent("allowedPush", dimensions:nil)
            currentSlide = (currentSlide + 1) % contentViewControllers.count
            displayViewController(currentSlide)
        } else if (currentSlide == 5) {
            delegate.completeNUX()
        } else {
            currentSlide = (currentSlide + 1) % contentViewControllers.count
            displayViewController(currentSlide)
        }
    }
    
    func displayViewController(index: Int) {
        contentView.addSubview(contentViewControllers[index].view)
        let contentViewController = contentViewControllers[index]
        var constraints: [NSLayoutConstraint] = []
        let attributes = [NSLayoutAttribute.Width, NSLayoutAttribute.Height, NSLayoutAttribute.CenterX, NSLayoutAttribute.CenterY]
        for attr in attributes {
            constraints.append(NSLayoutConstraint(item: contentViewController.view, attribute: attr, relatedBy: .Equal, toItem: contentView, attribute: attr, multiplier: 1.0, constant: 0))
        }
        NSLayoutConstraint.activateConstraints(constraints)
        
        switch index {
        case 0:
            popover.pip?.hidden = true
            nextButton.setTitle("OK! Let's get on with it", forState: .Normal)
            slideTitle.text = "Welcome to Shoutout"
            noButton.hidden = true
        case 1:
            popover.pip?.hidden = false
            popover.updatePipLocationAndAnimate(self.delegate.listButton.frame.origin.x, duration: 0.3)
            nextButton.setTitle("Next", forState: .Normal)
            noButton.hidden = true
            slideTitle.text = "List View"
        case 2:
            popover.pip?.hidden = false
            popover.updatePipLocationAndAnimate(self.delegate.inboxButton.frame.origin.x, duration: 0.3)
            print(self.delegate.inboxButton.frame.origin.x)
            nextButton.setTitle("Next", forState: .Normal)
            noButton.hidden = true
            slideTitle.text = "Inbox View"
        case 3:
            popover.pip?.hidden = false
            popover.updatePipLocationAndAnimate(self.delegate.composeButton.frame.origin.x, duration: 0.3)
            nextButton.setTitle("Got it!", forState: .Normal)
            noButton.setTitle("No, I hate everyone", forState: .Normal)
            noButton.hidden = false
            slideTitle.text = "Shout! Let it all out!"
        case 4:
            popover.pip?.hidden = false
            popover.updatePipLocationAndAnimate(self.delegate.settingsButton.frame.origin.x, duration: 0.3)
            nextButton.setTitle("Next", forState: .Normal)
            noButton.hidden = true
            slideTitle.text = "Settings"
        case 5:
            popover.pip?.hidden = false
            popover.updatePipLocationAndAnimate(self.delegate.locateButton.frame.origin.x, duration: 0.3)
            nextButton.setTitle("Enable Location Permissions", forState: .Normal)
            slideTitle.text = "Last but not least"
            noButton.hidden = false
            noButton.setTitle("No! The NSA is after me!", forState: .Normal)
        default:
            return
        }
    }
    
    func showInitialController() {
        displayViewController(0)
    }
    
    func createViewControllers() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let introSlide = storyboard.instantiateViewControllerWithIdentifier("soTutorialText") as? SONUXTutorialTextViewController
        introSlide?.view

        introSlide?.textView.text = "Shoutout is all about getting on the map.\n\nIn order for this to work, we need to get your permissions and show you how everything works."
        contentViewControllers.append(introSlide)
        
        let listSlide = storyboard.instantiateViewControllerWithIdentifier("soTutorialTextImage") as? SONUXTutorialTextImageViewController
        listSlide?.view
        listSlide?.textView.text = "Too many people on the map?\n\nTry using List View to help sort through the filthy masses."
        listSlide?.imageView.image = UIImage(named: "nux1.png")
        contentViewControllers.append(listSlide)
        
        let inboxSlide = storyboard.instantiateViewControllerWithIdentifier("soTutorialTextImage") as? SONUXTutorialTextImageViewController
        inboxSlide?.view
        inboxSlide?.textView.text = "If someone shouts back at you, it will show up here. From here, you can also block the haters and find your homies."
        inboxSlide?.imageView.image = UIImage(named: "nux2.png")
        contentViewControllers.append(inboxSlide)
        
        let notificationsSlide = storyboard.instantiateViewControllerWithIdentifier("soTutorialTextPermission") as? SONUXTutorialTextPermissionViewController
        notificationsSlide?.view
        notificationsSlide?.textView.text = "This is how you let anyone on the map know what you're up to or thinking about."
        notificationsSlide?.textBelowImageView.text = "We need your permission to let you know when others direct message you."
        notificationsSlide?.imageView.image = UIImage(named: "nux3.png")
        contentViewControllers.append(notificationsSlide)
        
        let settingsSlide = storyboard.instantiateViewControllerWithIdentifier("soTutorialTextPermission") as? SONUXTutorialTextPermissionViewController
        settingsSlide?.view
        settingsSlide?.textView.text = "This is where you can change your settings and tweak your profile."
        settingsSlide?.textBelowImageView.text = "You can also switch to anonymous mode if you want to be a shade-ball."
        settingsSlide?.imageView.image = UIImage(named: "nux4.png")
        contentViewControllers.append(settingsSlide)
        
        let locationSlide = storyboard.instantiateViewControllerWithIdentifier("soTutorialText") as? SONUXTutorialTextViewController
        locationSlide?.view
        locationSlide?.textView.text = "Shoutout relies on all users sharing their location. In order to use the app, please enable location permissions.\n\n(You can turn this off at any time)"
        contentViewControllers.append(locationSlide)
        
        if(UIDevice.currentDevice().userInterfaceIdiom == .Phone && UIScreen.mainScreen().bounds.size.height < 667.0){
            let iPhone5Font = UIFont(name: "Titillium", size: (introSlide?.textView.font?.pointSize)!-4)
            let iPhone5FontSmall = UIFont(name: "Titillium", size: (introSlide?.textView.font?.pointSize)!-6)
            listSlide?.textView.font = iPhone5Font;
            inboxSlide?.textView.font = iPhone5Font;
            notificationsSlide?.textView.font = iPhone5FontSmall;
            notificationsSlide?.textBelowImageView.font = iPhone5FontSmall;
            settingsSlide?.textView.font = iPhone5FontSmall;
            settingsSlide?.textBelowImageView.font = iPhone5FontSmall;
        }
        
        for contentViewController in contentViewControllers {
            addChildViewController(contentViewController)
            contentViewController.didMoveToParentViewController(self)
            contentViewController.view.translatesAutoresizingMaskIntoConstraints = false
        }
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        contentViewControllers = []
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        contentViewControllers = []
        super.init(coder: aDecoder)
    }

}
