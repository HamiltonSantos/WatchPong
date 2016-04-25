//
//  TutorialPageViewController.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 4/25/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! TutorialContentViewController).index
        if ((index == 0) || (index == NSNotFound)) {
            return nil;
        
        }
        index = index-1
        
        return self.viewControllers![index]

        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
    }
    
    func pageviewcontroller
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return 4
        
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    

}
