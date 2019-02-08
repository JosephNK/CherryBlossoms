//
//  RootContainerViewController.swift
//  CherryBlossoms
//
//  Created by JosephNK on 08/02/2019.
//  Copyright © 2019 JosephNK. All rights reserved.
//

import UIKit

class RootContainerViewController: UIViewController {

	fileprivate var rootViewController: UIViewController? = nil
	fileprivate var mainViewController: PlayListViewController? = nil
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.view.backgroundColor = UIColor.black
		
		showSplashWithMainViewController()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
	}
	
	// SplashViewController -> SimpleSlideoutNavigation transitions
	func showSplashWithMainViewController() {
		// Show SplashViewController
		self.showSplashViewController()
		
		if let _ =  rootViewController as? SplashViewController {
			DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
				// Show SimpleSlideoutNavigation
				self.showMainViewController()
			}
		}
	}
	
	// Does not transition to any other UIViewControllers, SplashViewController only
	func showSplashViewController() {
		if rootViewController is SplashViewController {
			return
		}
		
		rootViewController?.willMove(toParent: nil)
		rootViewController?.removeFromParent()
		rootViewController?.view.removeFromSuperview()
		rootViewController?.didMove(toParent: nil)
		
		let splashViewController = SplashViewController()
		rootViewController = splashViewController
		
		splashViewController.willMove(toParent: self)
		addChild(splashViewController)
		view.addSubview(splashViewController.view)
		splashViewController.didMove(toParent: self)
	}
	
	// Displays the PlayListViewController
	func showMainViewController() {
		guard !(rootViewController is PlayListViewController) else {
			return
		}
		
		mainViewController = PlayListViewController()
		
		if let mainViewController = self.mainViewController {
			self.addChild(mainViewController)
			
			if let rootViewController = self.rootViewController {
				self.rootViewController = mainViewController
				self.rootViewController?.willMove(toParent: nil)
				
				let duration: TimeInterval = 0.55
				
				self.transition(from: rootViewController,
								to: mainViewController,
								duration: duration,
								options: [.transitionCrossDissolve, .curveEaseOut],
								animations: { () -> Void in
									
				}, completion: { _ in
					mainViewController.didMove(toParent: self)
					rootViewController.removeFromParent()
					rootViewController.didMove(toParent: nil)
				})
			} else {
				rootViewController = mainViewController
				view.addSubview(mainViewController.view)
				mainViewController.didMove(toParent: self)
			}
		}
	}
	
	//    override var prefersStatusBarHidden : Bool {
	//        switch rootViewController  {
	//        case is SplashViewController:
	//            return true
	//        case is SimpleSlideoutNavigation:
	//            return false
	//        default:
	//            return false
	//        }
	//    }

}
