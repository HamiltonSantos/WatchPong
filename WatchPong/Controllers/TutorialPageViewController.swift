//
//  TutorialPageViewController.swift
//  WatchPong
//
//  Created by Hamilton Carlos da Silva Santos on 4/25/16.
//  Copyright © 2016 Hamilton Santos. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageImageNames = ["tuto1","tuto2","tuto3"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstContent = viewcontrollerAtIndex(0)!
        let viewcontrollers = [firstContent]
        delegate = self
        dataSource = self
        setViewControllers(viewcontrollers, direction: .Forward, animated: true, completion: nil)
        
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
        
        return viewcontrollerAtIndex(index)
        
        
        
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! TutorialContentViewController).index
        
        if (index == NSNotFound) {
            return nil
        }
        
        index = index+1
        if index == self.pageImageNames.count {
            return nil;
        }
        return viewcontrollerAtIndex(index)
    }
    
    func viewcontrollerAtIndex(index: Int) -> TutorialContentViewController? {
        if self.pageImageNames.count != 0 || index < self.pageImageNames.count {
            
            if let contentVC = self.storyboard?.instantiateViewControllerWithIdentifier("tutorialContent") as? TutorialContentViewController {
                contentVC.imageName = pageImageNames[index]
                contentVC.index = index
                return contentVC
            }
        }
        return nil
    }
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        
        return pageImageNames.count
        
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
}
