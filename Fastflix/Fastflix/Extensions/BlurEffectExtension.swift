//
//  BlurEffectExtension.swift
//  Fastflix
//
//  Created by HongWeonpyo on 05/08/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import UIKit

// 블러이펙트
extension UIImageView {
  func addBlurEffect() {
    let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
    self.addSubview(blurEffectView)
  }
}
