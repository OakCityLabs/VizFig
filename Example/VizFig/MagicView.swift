//
// Generated by VizFig available at https://github.com/OakCityLabs/VizFig
// Generated on 05/14/2016 at 06:34 PM based on class attributes of the 'Configuration' class.

import VizFig

class MagicView: BaseConfigView {
    @IBOutlet var colorizeRedColor: [UIView]? { 
        didSet { 
            colorize(Configuration.redColor, items: colorizeRedColor)
        } 
    }

    @IBOutlet var colorizeBlueColor: [UIView]? { 
        didSet { 
            colorize(Configuration.blueColor, items: colorizeBlueColor)
        } 
    }

    @IBOutlet var colorizeImgColor: [UIView]? { 
        didSet { 
            colorize(Configuration.imgColor, items: colorizeImgColor)
        } 
    }

    @IBOutlet var bgColorizeRedColor: [UIView]? { 
        didSet { 
            bgColorize(Configuration.redColor, items: bgColorizeRedColor)
        } 
    }

    @IBOutlet var bgColorizeBlueColor: [UIView]? { 
        didSet { 
            bgColorize(Configuration.blueColor, items: bgColorizeBlueColor)
        } 
    }

    @IBOutlet var bgColorizeImgColor: [UIView]? { 
        didSet { 
            bgColorize(Configuration.imgColor, items: bgColorizeImgColor)
        } 
    }

    @IBOutlet var stringifyCatchPhraseString: [UIView]? { 
        didSet { 
            stringify(Configuration.catchPhraseString, items: stringifyCatchPhraseString)
        } 
    }

    @IBOutlet var stringifyVersionString: [UIView]? { 
        didSet { 
            stringify(Configuration.versionString, items: stringifyVersionString)
        } 
    }

    @IBOutlet var fonterizeMediumFont: [UIView]? { 
        didSet { 
            fonterize(Configuration.mediumFont, items: fonterizeMediumFont)
        } 
    }

    @IBOutlet var fonterizeBigFont: [UIView]? { 
        didSet { 
            fonterize(Configuration.bigFont, items: fonterizeBigFont)
        } 
    }

    @IBOutlet var fonterizeBoringFont: [UIView]? { 
        didSet { 
            fonterize(Configuration.boringFont, items: fonterizeBoringFont)
        } 
    }

    @IBOutlet var fonterizeFooFont: [UIView]? { 
        didSet { 
            fonterize(Configuration.fooFont, items: fonterizeFooFont)
        } 
    }

}
