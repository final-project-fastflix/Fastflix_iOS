//
//  ButtonExtension.swift
//  Fastflix
//
//  Created by HongWeonpyo on 03/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
  
  func AttributedTextwithImagePrefix(AttributeImage : UIImage , AttributedText : String , buttonBound : UIButton) -> NSMutableAttributedString {
    let fullString = NSMutableAttributedString(string: "   ")
    let image1Attachment = NSTextAttachment()
    image1Attachment.bounds = CGRect(x: 0, y: ((buttonBound.titleLabel?.font.capHeight)! - AttributeImage.size.height).rounded() / 2, width: AttributeImage.size.width, height: AttributeImage.size.height)
    image1Attachment.image = AttributeImage
    let image1String = NSAttributedString(attachment: image1Attachment)
    fullString.append(image1String)
    fullString.append(NSAttributedString(string: "  " + AttributedText))
    return fullString
  }
  
}
