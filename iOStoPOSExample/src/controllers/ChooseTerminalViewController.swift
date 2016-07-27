//
//  ChooseTerminalViewController.swift
//  Poynt_iOS_SDK
//
//  Created by Eric McConkie on 6/22/16.
//  Copyright © 2016 poynt.co. All rights reserved.
//

import UIKit
import PoyntLib
class ChooseTerminalViewController: UITableViewController{
    let discovery = PoyntTerminalDiscover()
    var data: [PoyntTerminal] = []
    var selectedTerminal: PoyntTerminal?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Looking for terminals..."
        discovery.findTerminals { (terminals) in

            self.data = terminals
            self.tableView.reloadData()
            self.title = "\(self.data.count) terminals"
        }
    }
    @IBAction func onCancel(sender: AnyObject) {
        self.performSegueWithIdentifier("unwindToHome", sender: self)
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if let cell = self.tableView.dequeueReusableCellWithIdentifier("terminalCell") as UITableViewCell?{
            let poyntTerminal = self.data[indexPath.row]
            cell.textLabel!.text = poyntTerminal.name
            cell.detailTextLabel!.text = "\(poyntTerminal.ip!):\(poyntTerminal.service!.port)"
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let poyntTerminal = self.data[indexPath.row]
        self.selectedTerminal = poyntTerminal
        self.performSegueWithIdentifier("unwindToHome", sender: self)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }

}
