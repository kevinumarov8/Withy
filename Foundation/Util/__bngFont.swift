//
//  __bngFont.swift
//  ChocspoApp
//
//  Created by 김봉희 on 2019/12/09.
//  Copyright © 2019 김봉희. All rights reserved.
//

import Foundation
import UIKit

public extension UIFont {
    
    public func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
        
    public var italic : UIFont {
        return withTraits(.traitItalic)
    }
        
    public var bold : UIFont {
        return withTraits(.traitBold)
    }
    
    public var bold_italic : UIFont {
        return withTraits(.traitItalic, .traitBold)
    }
}
