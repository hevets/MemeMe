import UIKit

private let reuseIdentifier = "memeCVCell"

class CollectionViewController: UICollectionViewController {

    var selectedMeme:Meme?
    @IBOutlet weak var flowLayout:UICollectionViewFlowLayout!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupBarButtons()
        
        let space:CGFloat = 3.0
        var dimension:CGFloat
        
        if UIDeviceOrientationIsPortrait(UIDevice.currentDevice().orientation) {
            dimension = (self.view.frame.size.width - (2*space)) / 3.0
        } else {
            dimension = (self.view.frame.size.height - (2*space)) / 3.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setupBarButtons() {
        self.navigationItem.rightBarButtonItem = self.createButton()
    }
    
    func createButton() -> UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(TableViewController.createMeme))
    }
    
    func createMeme() {
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("memeViewController") as! MemeEditorViewController
        self.presentViewController(nextViewController, animated: true, completion: nil)
    }
    
    func dataSource() -> [Meme] {
        return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
    }
    
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource().count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let meme = dataSource()[indexPath.row]
        let cell:MemeCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MemeCollectionViewCell
        cell.imageView.image = meme.memedImage
        
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        self.selectedMeme = dataSource()[indexPath.row]
        self.performSegueWithIdentifier("showDetail", sender: nil)
    }
}
