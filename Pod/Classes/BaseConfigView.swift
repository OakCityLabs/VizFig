public class BaseConfigView: UIView {

    // Keep track of objects acted on to make sure nothing gets doulbe styled
    var fontified = [UIFont: AnyObject]()
    var colorized = [UIColor: AnyObject]()
    var bgColorized = [UIColor: AnyObject]()
    var stringified = [String: AnyObject]()
    
    public override var frame: CGRect {
        get {return CGRectZero }
        set {super.frame = CGRectZero}
    }
    
    public required init?(coder aDecoder: NSCoder) {
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
        items?.map{ item in
            if let targetItem = fontified[font] where targetItem !== item {
//                assertionFailure("Duplicate fonterize call for object:\(item)")
            }
            fontified[font] = item
            
            switch item {
            case let item as VizFigable:
                item.vizFigFonterize(font)
            case let item as DefaultVizFigable:
                item.defaultVizFigFonterize(font)
            default:
                assertionFailure("Unknown object: \(item) passed to VizFig's fonterize.")
            }
        }
    }

    public func colorize(color: UIColor, items: [AnyObject]?) {
        items?.map{ item in
            if let targetItem = colorized[color] where targetItem !== item {
//                assertionFailure("Duplicate colorize call for object:\(item)")
            }
            colorized[color] = item

            switch item {
            case let item as VizFigable:
                item.vizFigColorize(color)
            case let item as DefaultVizFigable:
                item.defaultVizFigColorize(color)
            default:
                assertionFailure("Unknown object: \(item) passed to VizFig's colorize.")
            }
        }
    }

    public func bgColorize(color: UIColor, items: [AnyObject]?) {
        items?.map{ item in
            if let targetItem = bgColorized[color] where targetItem !== item {
                //assertionFailure("Duplicate bgColorize call for object:\(item)")
            }
            bgColorized[color] = item

            switch item {
            case let item as VizFigable:
                item.vizFigBgColorize(color)
            case let item as DefaultVizFigable:
                item.defaultVizFigBgColorize(color)
            default:
                assertionFailure("Unknown object: \(item) passed to VizFig's bgColorize.")
            }
        }
    }

    public func stringify(string: String, items: [AnyObject]?) {
        items?.map{ item in
            if let targetItem = stringified[string] where targetItem !== item {
//                assertionFailure("Duplicate stringify call for object:\(item)")
            }
            stringified[string] = item
            
            switch item {
            case let item as VizFigable:
                item.vizFigStringify(string)
            case let item as DefaultVizFigable:
                item.defaultVizFigStringify(string)
            default:
                assertionFailure("Unknown object: \(item) passed to VizFig's stringify.")
            }
        }
    }
}

@objc public protocol VizFigable {
    func vizFigFonterize(font: UIFont)
    func vizFigBgColorize(color: UIColor)
    func vizFigColorize(color: UIColor)
    func vizFigStringify(string: String)
}


@objc public protocol DefaultVizFigable {
    func defaultVizFigFonterize(font: UIFont)
    func defaultVizFigBgColorize(color: UIColor)
    func defaultVizFigColorize(color: UIColor)
    func defaultVizFigStringify(string: String)
}

extension UIView: DefaultVizFigable {
    public func defaultVizFigFonterize(font: UIFont) {
        // no fonts for UIViews
    }
    public func defaultVizFigBgColorize(color: UIColor) {
        backgroundColor = color
    }
    public func defaultVizFigColorize(color: UIColor) {
        backgroundColor = color
    }
    public func defaultVizFigStringify(string: String) {
        // no string for basic view
    }
}

extension UILabel {
    public override func defaultVizFigFonterize(font: UIFont) {
        self.font = font
    }
    public override func defaultVizFigColorize(color: UIColor) {
        textColor = color
    }
    public override func defaultVizFigStringify(string: String) {
        text = string
    }
}

extension UIButton {
    public override func defaultVizFigFonterize(font: UIFont) {
        titleLabel?.font = font
    }
    public override func defaultVizFigColorize(color: UIColor) {
        setTitleColor(color, forState: .Highlighted)
        setTitleColor(color, forState: .Normal)
    }
    public override func defaultVizFigStringify(string: String) {
        setTitle(string, forState: .Highlighted)
        setTitle(string, forState: .Normal)
    }
}

extension UISegmentedControl {
    
    private func updateTitleTextAttrs(attrName: String, value: AnyObject, state: UIControlState) {
            var attrs = titleTextAttributesForState(state) ?? [NSObject: AnyObject]()
            attrs[NSString(string:attrName)] = value
            setTitleTextAttributes(attrs, forState: state)
    }
    
    public override func defaultVizFigFonterize(font: UIFont) {
        updateTitleTextAttrs(NSFontAttributeName, value: font, state: .Normal)
        updateTitleTextAttrs(NSFontAttributeName, value: font, state: .Highlighted)
    }
    public override func defaultVizFigColorize(color: UIColor) {
        updateTitleTextAttrs(NSForegroundColorAttributeName, value: color, state: .Normal)
        updateTitleTextAttrs(NSForegroundColorAttributeName, value: color, state: .Highlighted)
    }
}

