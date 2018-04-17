
import UIKit

class LocationSearchController: UISearchController {
    
    var customSearchBar = LocationSearchBar()
    override var searchBar: UISearchBar {
        get {
            return customSearchBar
        }
    }
}

class LocationSearchBar: UISearchBar {
    
    override func draw(_ rect: CGRect) {
        
        self.isHidden            = true
        self.searchBarStyle      = .prominent
        self.backgroundImage     = UIImage()
        self.backgroundColor     = UIColor(white: 1, alpha: 0)
        self.layer.cornerRadius  = 5
        self.layer.masksToBounds = true
        
        self.layer.shadowColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        self.layer.shadowOffset  = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 4
    }
}
