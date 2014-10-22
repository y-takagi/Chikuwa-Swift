//
//  ViewController.swift
//  SwiftPractice
//
//  Created by Yukiya Takagi on 2014/10/19.
//  Copyright (c) 2014年 Yukiya Takagi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var images: [ImageModel] = [ImageModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        ImageModel.newest({ (images) -> Void in
            self.images = images
            self.tableView.reloadData()
        }, errorBlock: { (completedOperation, error) -> Void in
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> ImageTableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("ImageTableViewCell", forIndexPath: indexPath) as ImageTableViewCell
        let model = self.images[indexPath.row]
        cell.tiqavImageView.sd_setImageWithURL(model.originalUrl())
        return cell
    }
}

