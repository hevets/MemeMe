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
        
        self.setupBarButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    func setupBarButtons() {
        self.navigationItem.rightBarButtonItem = self.createButton()
    }
    
    func createButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TableViewController.createMeme))
    }
    
    func createMeme() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "memeViewController") as! MemeEditorViewController
        self.present(nextViewController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    func dataSource() -> [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource().count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let meme = self.dataSource()[(indexPath as NSIndexPath).row] as Meme
        
        let cell:MemeTableViewCell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! MemeTableViewCell
        
        cell.memeImageView.image = meme.memedImage
        cell.memeTextLabel.text = meme.getDisplayText()
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let vc = segue.destination as? DetailViewController {
                if let meme = self.selectedMeme {
                    vc.selectedMeme = meme
                }
            }
        }
    }
    
    // TODO: implement this later
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedMeme = dataSource()[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
}
