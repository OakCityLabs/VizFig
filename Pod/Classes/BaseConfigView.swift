#if os(iOS)
    import UIKit
    
    public typealias BaseView = UIView
    public typealias Color = UIColor
    public typealias Font = UIFont
#else
    //OSX
    public typealias BaseView = NSView
    public typealias Color = NSColor
    public typealias Font = NSFont
#endif

public class BaseConfigView: BaseView {

    // Keep track of objects acted on to make sure nothing gets doulbe styled
    var fontified = [AnyObject]()
    var colorized = [AnyObject]()
    var bgColorized = [AnyObject]()
    var stringified = [AnyObject]()
    
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
        frame = CGRectMake(0, 0, 0, 0)
        //self.backgroundColor = Color.clearColor()
    }
    
    private func checkBucket(inout bucket: [AnyObject], object: AnyObject) {
        //FIXME:  What if this called more than once on the same object?
        
        let doesContain = bucket.reduce(false){ accum, item in
            return accum || (item === object)
        }
        
        if doesContain {
            assertionFailure("Duplicate stylization for object: \(object)")
        }
        bucket.append(object)
    }
    
    public func fonterize(font: Font, items: [AnyObject]?) {
        let _ = items?.map{ item in
            checkBucket(&fontified, object: item)
            
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

    public func colorize(color: Color, items: [AnyObject]?) {
        let _ = items?.map{ item in
            checkBucket(&colorized, object: item)

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

    public func bgColorize(color: Color, items: [AnyObject]?) {
        let _ = items?.map{ item in
            checkBucket(&bgColorized, object: item)

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
        let _ = items?.map{ item in
            checkBucket(&stringified, object: item)
            
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
    func vizFigFonterize(font: Font)
    func vizFigBgColorize(color: Color)
    func vizFigColorize(color: Color)
    func vizFigStringify(string: String)
}

@objc public protocol DefaultVizFigable {
    func defaultVizFigFonterize(font: Font)
    func defaultVizFigBgColorize(color: Color)
    func defaultVizFigColorize(color: Color)
    func defaultVizFigStringify(string: String)
}

#if os(iOS)

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

    extension UITextField {
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

    extension UISwitch {
        public override func defaultVizFigColorize(color: UIColor) {
            onTintColor = color
        }
    }

    extension UISlider {
        public override func defaultVizFigColorize(color: UIColor) {
            tintColor = color
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

#else
    // OS X
    extension NSView: DefaultVizFigable {
        
        private func setBackgroundColor(color: NSColor){
            wantsLayer = true
            layer?.backgroundColor = color.CGColor
        }
        
        public func defaultVizFigFonterize(font: NSFont) {
            // no fonts for UIViews
        }
        public func defaultVizFigBgColorize(color: NSColor) {
            setBackgroundColor(color)
        }
        public func defaultVizFigColorize(color: NSColor) {
            setBackgroundColor(color)
        }
        public func defaultVizFigStringify(string: String) {
            // no string for basic view
        }
    }

    extension NSTextField {
        
        public override func defaultVizFigFonterize(font: NSFont) {
            cell?.font = font
        }
        public override func defaultVizFigColorize(color: NSColor) {
            if let textFieldCell = cell as? NSTextFieldCell {
                textFieldCell.textColor = color
            }
        }
        public override func defaultVizFigStringify(string: String) {
            cell?.title = string
        }
    }

#endif
