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
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            dimension = (self.view.frame.size.width - (2*space)) / 3.0
        } else {
            dimension = (self.view.frame.size.height - (2*space)) / 3.0
        }
        
        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimension, height: dimension)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        collectionView?.reloadData()
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
    
    func dataSource() -> [Meme] {
        return (UIApplication.shared.delegate as! AppDelegate).memes
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let meme = dataSource()[(indexPath as NSIndexPath).row]
        let cell:MemeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MemeCollectionViewCell
        cell.imageView.image = meme.memedImage
        
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
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedMeme = dataSource()[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "showDetail", sender: nil)
    }
}
