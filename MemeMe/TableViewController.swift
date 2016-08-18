//
//  TableViewController.swift
//  MemeMe
//
//  Created by Steve Henderson on 2016-08-16.
//  Copyright © 2016 Steve Henderson. All rights reserved.
//

import UIKit

private let reuseIdentifier = "memeTVCell"

class TableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.setupBarButtons()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupBarButtons() {
        self.navigationItem.rightBarButtonItem = self.createButton()
    }
    
    func createButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(TableViewController.createMeme))
    }
    
    func createMeme() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("memeViewController") as! ViewController
        self.presentViewController(nextViewController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    func dataSource() -> [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource().count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let meme = self.dataSource()[indexPath.row] as Meme
        
        let cell:MemeTableViewCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeTableViewCell
        
        cell.imageView?.contentMode = .ScaleAspectFill
        cell.imageView?.image = meme.memedImage
        cell.textLabel!.text = meme.topText
        
        if (cell.detailTextLabel != nil) {
            cell.detailTextLabel!.text = meme.bottomText
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 44.0 * 2;
    }
    
    // TODO: implement this later
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let memeViewController = storyBoard.instantiateViewControllerWithIdentifier("memeViewController") as! ViewController
        
        let meme = dataSource()[indexPath.row]
        
        presentViewController(memeViewController, animated: true) {
            memeViewController.imageView.image = meme.image
            memeViewController.topTextField.text = meme.bottomText
            memeViewController.bottomTextField.text = meme.bottomText
            memeViewController.imagePicked()
        }
        
    }
}
