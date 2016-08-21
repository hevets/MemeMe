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
    var selectedMeme:Meme?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for _ in 1...20 {
            let meme = Meme(topText: "Top Text", bottomText: "Bottom Text", image: UIImage(named: "LaunchImage")!, memedImage: UIImage(named: "LaunchImage")!)
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        }
        
        self.setupBarButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
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
        
        cell.memeImageView.image = meme.memedImage
        cell.memeTextLabel.text = meme.getDisplayText()
        
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let vc = segue.destinationViewController as? DetailViewController {
                if let meme = self.selectedMeme {
                    vc.selectedMeme = meme
                }
            }
        }
    }
    
    // TODO: implement this later
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedMeme = dataSource()[indexPath.row]
        self.performSegueWithIdentifier("showDetail", sender: nil)
    }
}
