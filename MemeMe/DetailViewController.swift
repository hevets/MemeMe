
import UIKit

class DetailViewController: UIViewController {

    var selectedMeme:Meme?
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let meme = self.selectedMeme {
            memeImageView.image = meme.memedImage
        }
    }

}
