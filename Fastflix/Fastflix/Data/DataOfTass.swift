//
//  DataOfTass.swift
//  Fastflix
//
//  Created by hyeoktae kwon on 2019/07/10.
//  Copyright © 2019 hyeoktae kwon. All rights reserved.
//

import Foundation
import UIKit

var topPadding: CGFloat = 0


enum ErrorType: Error {
  case networkError, NoData, FailToParsing
}

struct Token: Codable {
  let token: String
}

let streamingUrl = "http://movietrailers.apple.com/movies/lucasfilm/star-wars-the-last-jedi/the-last-jedi-worlds-of-the-last-jedi_i320.m4v"

let preViewUrl = "https://firebasestorage.googleapis.com/v0/b/test-64199.appspot.com/o/%E1%84%82%E1%85%A6%E1%86%BA%E1%84%91%E1%85%B3%E1%86%AF%E1%84%85%E1%85%B5%E1%86%A8%E1%84%89%E1%85%B3%E1%84%86%E1%85%B5%E1%84%85%E1%85%B5%E1%84%87%E1%85%A9%E1%84%80%E1%85%B5%E1%84%88%E1%85%A2%E1%86%BC%E1%84%87%E1%85%A1%E1%86%AB.mov?alt=media&token=3b5c22c5-5092-43a7-8400-659a4ff5d90c"

let preViewUrl2 = "https://firebasestorage.googleapis.com/v0/b/test-64199.appspot.com/o/%E1%84%82%E1%85%A6%E1%86%BA%E1%84%91%E1%85%B3%E1%86%AF%E1%84%85%E1%85%B5%E1%86%A8%E1%84%89%E1%85%B3%E1%84%86%E1%85%B5%E1%84%85%E1%85%B5%E1%84%87%E1%85%A9%E1%84%80%E1%85%B5%E1%84%80%E1%85%A1%E1%84%8B%E1%85%A9%E1%84%80%E1%85%A2%E1%86%AF2.mp4?alt=media&token=96a3f3ef-3ff9-4f05-9675-2f13232a72cf"

let imageUrls = ["https://lh6.googleusercontent.com/-55osAWw3x0Q/URquUtcFr5I/AAAAAAAAAbs/rWlj1RUKrYI/s1024/A%252520Photographer.jpg", "https://lh4.googleusercontent.com/--dq8niRp7W4/URquVgmXvgI/AAAAAAAAAbs/-gnuLQfNnBA/s1024/A%252520Song%252520of%252520Ice%252520and%252520Fire.jpg", "https://lh5.googleusercontent.com/-7qZeDtRKFKc/URquWZT1gOI/AAAAAAAAAbs/hqWgteyNXsg/s1024/Another%252520Rockaway%252520Sunset.jpg", "https://lh3.googleusercontent.com/--L0Km39l5J8/URquXHGcdNI/AAAAAAAAAbs/3ZrSJNrSomQ/s1024/Antelope%252520Butte.jpg", "https://lh6.googleusercontent.com/-8HO-4vIFnlw/URquZnsFgtI/AAAAAAAAAbs/WT8jViTF7vw/s1024/Antelope%252520Hallway.jpg", "https://lh4.googleusercontent.com/-WIuWgVcU3Qw/URqubRVcj4I/AAAAAAAAAbs/YvbwgGjwdIQ/s1024/Antelope%252520Walls.jpg",
                 "https://lh6.googleusercontent.com/-55osAWw3x0Q/URquUtcFr5I/AAAAAAAAAbs/rWlj1RUKrYI/s1024/A%252520Photographer.jpg", "https://lh4.googleusercontent.com/--dq8niRp7W4/URquVgmXvgI/AAAAAAAAAbs/-gnuLQfNnBA/s1024/A%252520Song%252520of%252520Ice%252520and%252520Fire.jpg", "https://lh5.googleusercontent.com/-7qZeDtRKFKc/URquWZT1gOI/AAAAAAAAAbs/hqWgteyNXsg/s1024/Another%252520Rockaway%252520Sunset.jpg", "https://lh3.googleusercontent.com/--L0Km39l5J8/URquXHGcdNI/AAAAAAAAAbs/3ZrSJNrSomQ/s1024/Antelope%252520Butte.jpg", "https://lh6.googleusercontent.com/-8HO-4vIFnlw/URquZnsFgtI/AAAAAAAAAbs/WT8jViTF7vw/s1024/Antelope%252520Hallway.jpg", "https://lh4.googleusercontent.com/-WIuWgVcU3Qw/URqubRVcj4I/AAAAAAAAAbs/YvbwgGjwdIQ/s1024/Antelope%252520Walls.jpg"]


extension UIImage {
  
  public class func gifImageWithData(data: NSData) -> UIImage? {
    guard let source = CGImageSourceCreateWithData(data, nil) else {
      print("image doesn't exist")
      return nil
    }
    
    return UIImage.animatedImageWithSource(source: source)
  }
  
  public class func gifImageWithURL(gifUrl:String) -> UIImage? {
    guard let bundleURL = NSURL(string: gifUrl)
      else {
        print("image named \"\(gifUrl)\" doesn't exist")
        return nil
    }
    guard let imageData = NSData(contentsOf: bundleURL as URL) else {
      print("image named \"\(gifUrl)\" into NSData")
      return nil
    }
    
    return gifImageWithData(data: imageData)
  }
  
  public class func gifImageWithName(name: String) -> UIImage? {
    guard let bundleURL = Bundle.main
      .url(forResource: name, withExtension: "gif") else {
        print("SwiftGif: This image named \"\(name)\" does not exist")
        return nil
    }
    
    guard let imageData = NSData(contentsOf: bundleURL) else {
      print("SwiftGif: Cannot turn image named \"\(name)\" into NSData")
      return nil
    }
    
    return gifImageWithData(data: imageData)
  }
  
  class func delayForImageAtIndex(index: Int, source: CGImageSource!) -> Double {
    var delay = 0.1
    
    let cfProperties = CGImageSourceCopyPropertiesAtIndex(source, index, nil)
    let gifProperties: CFDictionary = unsafeBitCast(CFDictionaryGetValue(cfProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDictionary).toOpaque()), to: CFDictionary.self)
    
    var delayObject: AnyObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFUnclampedDelayTime).toOpaque()), to: AnyObject.self)
    
    if delayObject.doubleValue == 0 {
      delayObject = unsafeBitCast(CFDictionaryGetValue(gifProperties, Unmanaged.passUnretained(kCGImagePropertyGIFDelayTime).toOpaque()), to: AnyObject.self)
    }
    
    delay = delayObject as! Double
    
    if delay < 0.1 {
      delay = 0.1
    }
    
    return delay
  }
  
  class func gcdForPair(a: Int?, _ b: Int?) -> Int {
    var a = a
    var b = b
    if b == nil || a == nil {
      if b != nil {
        return b!
      } else if a != nil {
        return a!
      } else {
        return 0
      }
    }
    
    if a! < b! {
      let c = a!
      a = b!
      b = c
    }
    
    var rest: Int
    while true {
      rest = a! % b!
      
      if rest == 0 {
        return b!
      } else {
        a = b!
        b = rest
      }
    }
  }
  
  class func gcdForArray(array: Array<Int>) -> Int {
    if array.isEmpty {
      return 1
    }
    
    var gcd = array[0]
    
    for val in array {
      gcd = UIImage.gcdForPair(a: val, gcd)
    }
    
    return gcd
  }
  
  class func animatedImageWithSource(source: CGImageSource) -> UIImage? {
    let count = CGImageSourceGetCount(source)
    var images = [CGImage]()
    var delays = [Int]()
    
    for i in 0..<count {
      if let image = CGImageSourceCreateImageAtIndex(source, i, nil) {
        images.append(image)
      }
      
      let delaySeconds = UIImage.delayForImageAtIndex(index: Int(i), source: source)
      delays.append(Int(delaySeconds * 1000.0)) // Seconds to ms
    }
    
    let duration: Int = {
      var sum = 0
      
      for val: Int in delays {
        sum += val
      }
      
      return sum
    }()
    
    let gcd = gcdForArray(array: delays)
    var frames = [UIImage]()
    
    var frame: UIImage
    var frameCount: Int
    for i in 0..<count {
      frame = UIImage(cgImage: images[Int(i)])
      frameCount = Int(delays[Int(i)] / gcd)
      
      for _ in 0..<frameCount {
        frames.append(frame)
      }
    }
    
    let animation = UIImage.animatedImage(with: frames, duration: Double(duration) / 1000.0)
    
    return animation
  }
}
