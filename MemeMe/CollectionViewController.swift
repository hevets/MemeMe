import UIKit

private let reuseIdentifier = "memeCVCell"

class CollectionViewController: UICollectionViewController {

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
        
        for _ in 1...20 {
            let meme = Meme(topText: "Top Text", bottomText: "Bottom Text", image: UIImage(named: "LaunchImage")!, memedImage: UIImage(named: "LaunchImage")!)
            (UIApplication.sharedApplication().delegate as! AppDelegate).memes.append(meme)
        }
        
        
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
        let nextViewController = storyBoard.instantiateViewControllerWithIdentifier("memeViewController") as! ViewController
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
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let storyBoard = UIStoryboard(name: "Main", bundle:nil)
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
