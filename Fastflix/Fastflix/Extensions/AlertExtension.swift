//
//  File.swift
//  Fastflix
//
//  Created by Jeon-heaji on 26/07/2019.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
  
  func alert(title: String, message: String, okCompletion: @escaping () -> ()) {
   
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let cencelAction = UIAlertAction(title: "아니오", style: .default, handler: nil)
    let oKAction = UIAlertAction(title: title, style: .destructive) { _ in
      okCompletion()
      self.dismiss(animated: true)
    }
    
    alert.addAction(cencelAction)
    alert.addAction(oKAction)
    
    present(alert, animated: true, completion: nil)
    
  }
  
}
