import Foundation

#if os(iOS)
    import UIKit

    public typealias BaseView = UIView
    public typealias Color = UIColor
    public typealias Font = UIFont
#else
    //OSX
    import AppKit

    public typealias BaseView = NSView
    public typealias Color = NSColor
    public typealias Font = NSFont
#endif

open class BaseConfigView: BaseView {

    // Keep track of objects acted on to make sure nothing gets doulbe styled
    var fontified = [AnyObject]()
    var colorized = [AnyObject]()
    var bgColorized = [AnyObject]()
    var stringified = [AnyObject]()
    
    open override var frame: CGRect {
        get {return CGRect.zero }
        set {super.frame = CGRect.zero}
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        postInit()
    }
    
    public required override init(frame: CGRect) {
        super.init(frame: frame)
        postInit()
    }
    
    func postInit() {
        // Hide!
        frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        //self.backgroundColor = Color.clearColor()
    }
    
    fileprivate func checkBucket(_ bucket: inout [AnyObject], object: AnyObject) {
        //FIXME:  What if this called more than once on the same object?
        
        let doesContain = bucket.reduce(false){ accum, item in
            return accum || (item === object)
        }
        
        if doesContain {
            assertionFailure("Duplicate stylization for object: \(object)")
        }
        bucket.append(object)
    }
    
    open func fonterize(_ font: Font, items: [AnyObject]?) {
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

    open func colorize(_ color: Color, items: [AnyObject]?) {
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

    open func bgColorize(_ color: Color, items: [AnyObject]?) {
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

    open func stringify(_ string: String, items: [AnyObject]?) {
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
    func vizFigFonterize(_ font: Font)
    func vizFigBgColorize(_ color: Color)
    func vizFigColorize(_ color: Color)
    func vizFigStringify(_ string: String)
}

@objc public protocol DefaultVizFigable {
    func defaultVizFigFonterize(_ font: Font)
    func defaultVizFigBgColorize(_ color: Color)
    func defaultVizFigColorize(_ color: Color)
    func defaultVizFigStringify(_ string: String)
}

#if os(iOS)

    extension UIView: DefaultVizFigable {
        open func defaultVizFigFonterize(_ font: UIFont) {
            // no fonts for UIViews
        }
        open func defaultVizFigBgColorize(_ color: UIColor) {
            backgroundColor = color
        }
        open func defaultVizFigColorize(_ color: UIColor) {
            backgroundColor = color
        }
        open func defaultVizFigStringify(_ string: String) {
            // no string for basic view
        }
    }

    extension UILabel {
        open override func defaultVizFigFonterize(_ font: UIFont) {
            self.font = font
        }
        open override func defaultVizFigColorize(_ color: UIColor) {
            textColor = color
        }
        open override func defaultVizFigStringify(_ string: String) {
            text = string
        }
    }

    extension UITextField {
        open override func defaultVizFigFonterize(_ font: UIFont) {
            self.font = font
        }
        open override func defaultVizFigColorize(_ color: UIColor) {
            textColor = color
        }
        open override func defaultVizFigStringify(_ string: String) {
            text = string
        }
    }
    
    extension UITextView {
        open override func defaultVizFigFonterize(_ font: UIFont) {
            self.font = font
        }
        open override func defaultVizFigColorize(_ color: UIColor) {
            textColor = color
        }
        open override func defaultVizFigStringify(_ string: String) {
            text = string
        }
    }
    
    extension UIButton {
        open override func defaultVizFigFonterize(_ font: UIFont) {
            titleLabel?.font = font
        }
        open override func defaultVizFigColorize(_ color: UIColor) {
            setTitleColor(color, for: .highlighted)
            setTitleColor(color, for: .normal)
        }
        open override func defaultVizFigStringify(_ string: String) {
            setTitle(string, for: .highlighted)
            setTitle(string, for: .normal)
        }
    }

    extension UISwitch {
        open override func defaultVizFigColorize(_ color: UIColor) {
            onTintColor = color
        }
    }

    extension UIActivityIndicatorView {
        open override func defaultVizFigColorize(_ color: UIColor) {
            self.color = color
        }
    }
    
    extension UISlider {
        open override func defaultVizFigColorize(_ color: UIColor) {
            tintColor = color
        }
    }

    
    extension UISegmentedControl {
        
        fileprivate func updateTitleTextAttrs(_ attrName: NSAttributedString.Key, value: AnyObject, state: UIControl.State) {
                var attrs = titleTextAttributes(for: state) ?? [NSAttributedString.Key: Any]()
                attrs[attrName] = value
                setTitleTextAttributes(attrs, for: state)
        }
        
        open override func defaultVizFigFonterize(_ font: UIFont) {
            updateTitleTextAttrs(NSAttributedString.Key.font, value: font, state: .normal)
            updateTitleTextAttrs(NSAttributedString.Key.font, value: font, state: .highlighted)
        }
        open override func defaultVizFigColorize(_ color: UIColor) {
            updateTitleTextAttrs(NSAttributedString.Key.foregroundColor, value: color, state: .normal)
            updateTitleTextAttrs(NSAttributedString.Key.foregroundColor, value: color, state: .highlighted)
        }
    }

#else
    // OS X
    extension NSView: DefaultVizFigable {
        
        private func setBackgroundColor(color: NSColor){
            wantsLayer = true
            layer?.backgroundColor = color.cgColor
        }
        
        open func defaultVizFigFonterize(_ font: NSFont) {
            // no fonts for UIViews
        }
        open func defaultVizFigBgColorize(_ color: NSColor) {
            setBackgroundColor(color: color)
        }
        open func defaultVizFigColorize(_ color: NSColor) {
            setBackgroundColor(color: color)
        }
        open func defaultVizFigStringify(_ string: String) {
            // no string for basic view
        }
    }

    extension NSTextField {
        
        open override func defaultVizFigFonterize(_ font: NSFont) {
            cell?.font = font
        }
        open override func defaultVizFigColorize(_ color: NSColor) {
            if let textFieldCell = cell as? NSTextFieldCell {
                textFieldCell.textColor = color
            }
        }
        open override func defaultVizFigStringify(_ string: String) {
            cell?.title = string
        }
    }

#endif
