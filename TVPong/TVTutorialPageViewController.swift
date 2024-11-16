//
//  TVTutorialViewController.swift
//  TVPong
//
//  Created by Hamilton Carlos da Silva Santos on 25/07/23.
//  Copyright © 2023 Hamilton Santos. All rights reserved.
//

import UIKit

class TVTutorialPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pageImageNames = ["bigHand","tuto2","table"]
    var pageTitles = ["Hold the Apple Watch","Connection Error?","Movement"]
    var pageSubtitles = ["Now the watch is your Racket","Check if the Watch is connected with the iPhone","Move the Watch to the side where the ball goes"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let firstContent = viewcontrollerAtIndex(0)!
        let viewcontrollers = [firstContent]
        delegate = self
        dataSource = self
        setViewControllers(viewcontrollers, direction: .forward, animated: true, completion: nil)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = (viewController as! TutorialContentViewController).index
        if ((index == 0) || (index == NSNotFound)) {
            return nil;
            
        }
        index = index-1
        
        return viewcontrollerAtIndex(index)
        
        
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
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
    
    func viewcontrollerAtIndex(_ index: Int) -> TutorialContentViewController? {
        if self.pageImageNames.count != 0 || index < self.pageImageNames.count {
            
            if let contentVC = self.storyboard?.instantiateViewController(withIdentifier: "tutorialContent") as? TutorialContentViewController {
                contentVC.imageName = pageImageNames[index]
                contentVC.tutoTitle = pageTitles[index]
                contentVC.tutoSubtitle = pageSubtitles[index]
                contentVC.index = index
                return contentVC
            }
        }
        return nil
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        
        return pageImageNames.count
        
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
    
}
