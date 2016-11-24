//
//  Extensions.swift
//  FlexboxLayout
//
//  Created by Alex Usbergo on 04/03/16.
//  Copyright © 2016 Alex Usbergo. All rights reserved.
//

import UIKit
import FlexboxLayout

extension UIView {
  convenience init(color: UIColor) {
    self.init()
    self.backgroundColor = color
  }
}

extension UILabel {
  convenience init(color: UIColor, text: String) {
    self.init()
    self.backgroundColor = color
    self.text = text
    self.textColor = UIColor.white
    self.numberOfLines = 0
  }
}

extension UIColor {

  class public var a: UIColor {
    return UIColor(red: 238/255, green: 238/255, blue: 238/255, alpha: 1)
  }

  class public var b: UIColor {
    return UIColor(red: 0/255, green: 188/255, blue: 212/255, alpha: 1)
  }

  class public var c: UIColor {
    return UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1)
  }

  class public var d: UIColor {
    return UIColor(red: 165/255, green: 214/255, blue: 167/255, alpha: 1)
  }

  class public var e: UIColor {
    return UIColor(red: 46/255, green: 125/255, blue: 50/255, alpha: 1)
  }

  class public var f: UIColor {
    return UIColor(red: 244/255, green: 67/255, blue: 54/255, alpha: 1)
  }

  class public var g: UIColor {
    return UIColor(red: 33/255, green: 150/255, blue: 243/255, alpha: 1)
  }
}

func randomString(_ length: Int) -> String {

  let allowedChars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 "
  let allowedCharsCount = UInt32(allowedChars.characters.count)
  var randomString = ""

  for _ in (0..<length) {
    let randomNum = Int(arc4random_uniform(allowedCharsCount))
    let newCharacter = allowedChars[allowedChars.characters.index(allowedChars.startIndex, offsetBy: randomNum)]
    randomString += String(newCharacter)
  }

  return randomString
}

func randomInt(_ min: Int, max:Int) -> Int {
  return min + Int(arc4random_uniform(UInt32(max - min + 1)))
}


