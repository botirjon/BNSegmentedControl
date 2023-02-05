import UIKit.UIView

protocol ViewInstaller: AnyObject {
    /// The parent (root) view of all subviews
    var mainView: UIView { get }
    
    var safeAreaInsets: UIEdgeInsets { get }
    
    /// Installs all subviews (init, add, constraint)
    func installSubviews()
    
    /// Initializes all subview elements
    func initSubviews()
    
    /// Places each subview to its super-view
    func addSubviews()
    
    /// Adds constraints of placed subviews
    func addSubviewConstraints()
    
    /// Layout subviews
    func willLayout()
    func didLayout()
    
    func localizeTexts()
}


extension ViewInstaller {
    
    var safeAreaInsets: UIEdgeInsets { .zero }
    
    func installSubviews() {
        initSubviews()
        addSubviews()
        addSubviewConstraints()
    }
    
    func initSubviews() {
        fatalError("Implementation pending...")
    }
    
    func addSubviews() {
        fatalError("Implementation pending...")
    }
    
    func addSubviewConstraints() {
        fatalError("Implementation pending...")
    }
    
    func willLayout() {
        
    }
    
    func didLayout() {
        
    }
    
    func localizeTexts() {
        
    }
}

