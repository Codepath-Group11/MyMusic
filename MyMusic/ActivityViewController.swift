//
//  ActivityViewController.swift
//  MyMusic
//
//  Created by Yerneni, Naresh on 5/11/17.
//  Copyright © 2017 Yerneni, Naresh. All rights reserved.
//

import UIKit
import BubbleTransition


class ActivityViewController: UIViewController,UIViewControllerTransitioningDelegate {

    @IBOutlet weak var activityButton: UIButton!
    let transition = BubbleTransition()

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }

    @IBAction func activityClick(_ sender: Any) {
        let playlistStoryBoard = UIStoryboard(name: "PlayList", bundle: nil)
        let playlistNVC = playlistStoryBoard.instantiateViewController(withIdentifier: "PlaylistNVC") as! UINavigationController
        
        playlistNVC.transitioningDelegate = self
        playlistNVC.modalPresentationStyle = .custom
        //self.show(playlistNVC, sender: nil)
        dismiss(animated: true, completion: nil)

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .present
        transition.startingPoint = activityButton.center
        transition.bubbleColor = activityButton.backgroundColor!
        return transition
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .dismiss
        transition.startingPoint = activityButton.center
        transition.bubbleColor = activityButton.backgroundColor!
        return transition
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
