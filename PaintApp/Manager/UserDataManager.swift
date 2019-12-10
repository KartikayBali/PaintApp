//
//  UserDataManager.swift
//  PaintApp
//
//  Created by Bali on 08/12/19.
//  Copyright © 2019 Kartikay Bali. All rights reserved.
//

import UIKit

class UserDataManager {
  static let shared = UserDataManager()
  
  static let brushWidth: Float = 5
  static let opacity: Float = 1
  static let red: Float = 0
  static let blue: Float = 0
  static let green: Float = 0
  
  static let eraserColor = UIColor.white
  static let eraserWidth: CGFloat = 20
  
  static let defaultColors: [UIColor] = [.black, .red, .blue, .green, .yellow, .brown, .purple, .gray]
  
  var brushWidth = UserDataManager.brushWidth
  var opacity = UserDataManager.opacity
  var red = UserDataManager.red
  var green = UserDataManager.green
  var blue = UserDataManager.blue
}
