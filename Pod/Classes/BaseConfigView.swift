public class BaseConfigView: UIView {

    public override var frame: CGRect {
        get {return CGRectZero }
        set {super.frame = CGRectZero}
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    
    func postInit() {
        // Hide!
        self.frame = CGRectMake(0, 0, 0, 0)
        self.backgroundColor = UIColor.clearColor()
    }
    
    
    public func fonterize(font: UIFont, items: [AnyObject]?) {
        if let items = items {
            for item in items {
                switch item {
                case let label as UILabel:
                    label.font = font
                case let button as UIButton:
                    button.titleLabel?.font = font
                case let segSwitch as UISegmentedControl:
                    segSwitch.setTitleTextAttributes([NSFontAttributeName: font], forState: .Highlighted)
                    segSwitch.setTitleTextAttributes([NSFontAttributeName: font], forState: .Normal)
                default:
                    continue    // skip stuff we don't understand
                }
            }
        }
    }
    
    public func colorize(color: UIColor, items: [AnyObject]?) {
        if let items = items {
            for item in items {
                switch item {
                case let label as UILabel:
                    label.textColor = color
                case let button as UIButton:
                    button.setTitleColor(color, forState: UIControlState.Highlighted)
                    button.setTitleColor(color, forState: UIControlState.Normal)
                case let navBar as UINavigationBar:
                    navBar.backgroundColor = color
                case let segSwitch as UISegmentedControl:
                    segSwitch.setTitleTextAttributes([NSForegroundColorAttributeName: color], forState: .Highlighted)
                    segSwitch.setTitleTextAttributes([NSForegroundColorAttributeName: color], forState: .Normal)
                    segSwitch.tintColor = color
                case let view as UIView:
                    view.backgroundColor = color
                default:
                    continue    // skip stuff we don't understand
                }
            }
        }
    }
    
    public func bgColorize(color: UIColor, items: [AnyObject]?) {
        if let items = items {
            for item in items {
                switch item {
                case let view as UIView:
                    view.backgroundColor = color
                default:
                    continue    // skip stuff we don't understand
                }
            }
        }
    }
    
    public func stringify(string: String, items: [AnyObject]?) {
        
    }

}

