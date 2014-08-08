//
//  WeekDayViewController.swift
//  FoodPing
//
//  Created by Michael Hollman on 8/7/14.
//  Copyright (c) 2014 Michael Hollman. All rights reserved.
//

import UIKit

class WeekDayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView?
    @IBOutlet weak var buttonBack: UIButton?

    var foods: Array<String> = Array<String>(count: 7, repeatedValue: "")

    override func viewDidLoad() {
        super.viewDidLoad()

        buttonBack?.layer.cornerRadius = 5

        tableView?.registerNib(UINib(nibName: "DayOfTheWeekTableViewCell", bundle: nil), forCellReuseIdentifier: "DayOfTheWeekTableViewCell")
        tableView?.tableFooterView = UIView(frame: CGRectZero)
        tableView?.backgroundColor = UIColor.clearColor()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        reloadFoods()
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func reloadFoods() {
        for d in 0...6 {
            makeRequestForDay(d)
        }
    }

    func makeRequestForDay(day: Int) {
        let url = NSURL(string: "http://nugget:42420/display/food/data/food?day=\(day)")
        var task = NSURLSession.sharedSession().dataTaskWithURL(url, {(data, response, error) in
            var message = NSString(data: data, encoding: NSUTF8StringEncoding)
            dispatch_async(dispatch_get_main_queue(), {
                    self.messageRecieved(message, day: day)
                })
            })
        task.resume()
    }

    func messageRecieved(message: NSString, day: Int) {
        var idx = message.rangeOfString("is ").location + 2
        var trimmedMessage = NSString(string: message.substringFromIndex(idx))
        if trimmedMessage.containsString(",") {
            trimmedMessage = trimmedMessage.substringToIndex(trimmedMessage.rangeOfString(",").location)
        }
        trimmedMessage = trimmedMessage.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())

        foods[day] = trimmedMessage
        tableView?.reloadData()
    }

    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        var cell = tableView.dequeueReusableCellWithIdentifier("DayOfTheWeekTableViewCell") as DayOfTheWeekTableViewCell
        let letters = ["s", "m", "t", "w", "t", "f", "s"]

        cell.dayLetter = letters[indexPath.row]
        cell.food = foods[indexPath.row]

        return cell
    }

    func tableView(tableView: UITableView!, heightForRowAtIndexPath indexPath: NSIndexPath!) -> CGFloat {

        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            return 100.0
        }

        return 60.0
    }
}
