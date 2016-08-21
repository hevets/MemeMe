
import UIKit

class DetailViewController: UIViewController {

    var selectedMeme:Meme?
    
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }
    
    func setupView() {
        if let meme = self.selectedMeme {
            memeImageView.image = meme.memedImage
        }
        tabBarController?.tabBar.isHidden = true
    }
    
}
