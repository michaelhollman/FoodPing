//
//  ViewController.swift
//  FoodPing
//
//  Created by Michael Hollman on 8/7/14.
//  Copyright (c) 2014 Michael Hollman. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    let colorBlue  = UIColor(red: 105/255.0, green: 155/255.0, blue: 210/255.0, alpha: 1)
    let colorGreen = UIColor(red: 110/255.0, green: 200/255.0, blue: 140/255.0, alpha: 1)
    let colorRed   = UIColor(red: 210/255.0, green:  90/255.0, blue:  90/255.0, alpha: 1)

    @IBOutlet weak var button: UIButton?
    @IBOutlet weak var scheduleButton: UIButton?
    @IBOutlet weak var resetButton: UIButton?
    @IBOutlet weak var indicator: UIActivityIndicatorView?
    @IBOutlet weak var messageLabel: UILabel?

    @IBAction func unwindToMainViewController (segue : UIStoryboardSegue) {}

    let url = NSURL(string: "http://nugget:42420/display/food/data/food")

    override func viewDidLoad() {
        super.viewDidLoad()
        button?.layer.cornerRadius = 10
        resetButton?.layer.cornerRadius = 6
        scheduleButton?.layer.cornerRadius = 6
        self.reset()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func reset() {
        UIView.animateWithDuration(0.35, {
            self.view.backgroundColor = self.colorBlue
            self.indicator?.alpha = 0
            self.messageLabel?.alpha = 0
            self.button?.alpha = 1
            self.resetButton?.alpha = 0
            self.scheduleButton?.alpha = 1
        })
    }

    func makeRequest() {
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, {(data, response, error) in
            var message = NSString(data: data, encoding: NSUTF8StringEncoding)
            dispatch_async(dispatch_get_main_queue(), {
                self.messageRecieved(message)
            })
        })

        task.resume()
    }

    func messageRecieved(message: NSString) {
        var itsHere = !message.containsString("not here")
        messageLabel?.text = message

        UIView.animateWithDuration(0.35, {
            self.indicator?.alpha = 0
            self.view.backgroundColor = itsHere ? self.colorGreen : self.colorRed
            self.resetButton?.setTitleColor(itsHere ? self.colorGreen : self.colorRed, forState: UIControlState.Normal)
            self.messageLabel?.alpha = 1
            self.resetButton?.alpha = 1
            self.scheduleButton?.alpha = 0
        })
    }

    @IBAction func foodButtonTapped(AnyObject) {
        UIView.animateWithDuration(0.35, {
            self.button?.alpha = 0
            self.scheduleButton?.alpha = 0
            self.indicator?.alpha = 1
            }, { (finished) in
                self.makeRequest()
            })
    }

    @IBAction func resetButtonTapped(AnyObject) {
        self.reset()
    }
}

