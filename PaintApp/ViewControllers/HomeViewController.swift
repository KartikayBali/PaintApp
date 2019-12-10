//
//  ViewController.swift
//  PaintApp
//
//  Created by Bali on 07/12/19.
//  Copyright © 2019 Kartikay Bali. All rights reserved.
//
// Reference: https://www.raywenderlich.com/5895-uikit-drawing-tutorial-how-to-make-a-simple-drawing-app
// The drawing mode that involved graphics methods were referred from this link

import UIKit

class HomeViewController: UIViewController {
  
  // MARK:- IBOutlets
  @IBOutlet var mainImageView: UIImageView!
  @IBOutlet var tempImageView: UIImageView!
  @IBOutlet var clearButton: UIButton!
  @IBOutlet var settingsButton: UIButton!
  @IBOutlet var drawButton: UIButton!
  @IBOutlet var colorSelectionView: ColorSelectionView!
  
  // MARK:- Variables
  var color: UIColor {
    return isPencilMode ? UIColor(red: CGFloat(UserDataManager.shared.red/255), green: CGFloat(UserDataManager.shared.green/255), blue: CGFloat(UserDataManager.shared.blue/255), alpha: CGFloat(UserDataManager.shared.opacity)) : UserDataManager.eraserColor
  }
  
  var brushWidth: CGFloat {
    return isPencilMode ? CGFloat(UserDataManager.shared.brushWidth) : UserDataManager.eraserWidth
  }
  
  var isPencilMode: Bool {
    return drawButton.isSelected
  }
  
  var lastPoint = CGPoint.zero
  var swiped = false
  
  // MARK:- IBActions
  @IBAction func buttonTapped(_ button: UIButton) {
    switch button {
    case clearButton:
      mainImageView.image = nil
      
    case settingsButton:
      performSegue(withIdentifier: "HomeToSettingsSegueIdentifier", sender: nil)
      
    case drawButton:
      button.isSelected = !button.isSelected
      
    default:
      break
    }
  }
  
  // MARK:- Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    enablePencilMode(true)
    colorSelectionView.delegate = self
    view.backgroundColor = UserDataManager.eraserColor
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    super.prepare(for: segue, sender: sender)
    
    if let viewController = segue.destination as? SettingsViewController {
      viewController.delegate = self
    }
  }

  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    
    swiped = false
    lastPoint = touch.location(in: mainImageView)
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }

    swiped = true
    let currentPoint = touch.location(in: mainImageView)
    drawLine(from: lastPoint, to: currentPoint)
      
    lastPoint = currentPoint
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if !swiped {
      drawLine(from: lastPoint, to: lastPoint)
    }
      
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    mainImageView.image?.draw(in: mainImageView.bounds, blendMode: .normal, alpha: 1.0)
    tempImageView?.image?.draw(in: mainImageView.bounds, blendMode: .normal, alpha: 1.0)
    mainImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
      
    tempImageView.image = nil
  }


  func drawLine(from fromPoint: CGPoint, to toPoint: CGPoint) {
    UIGraphicsBeginImageContext(mainImageView.frame.size)
    guard let context = UIGraphicsGetCurrentContext() else {
      return
    }
    tempImageView.image?.draw(in: mainImageView.bounds)
      
    context.move(to: fromPoint)
    context.addLine(to: toPoint)
    
    context.setLineCap(.round)
    context.setBlendMode(.normal)
    context.setLineWidth(brushWidth)
    context.setStrokeColor(color.cgColor)
    
    context.strokePath()
    
    tempImageView.image = UIGraphicsGetImageFromCurrentImageContext()
    tempImageView.alpha = 1.0
    UIGraphicsEndImageContext()
  }
  
  func enablePencilMode(_ enable: Bool) {
    drawButton.isSelected = enable
  }
}

// MARK:- ColorSelectionViewDelegate
extension HomeViewController: ColorSelectionViewDelegate {
  func didSelectedColor(_ color: UIColor) {
    if let components = color.cgColor.components, components.count > 1 {
      UserDataManager.shared.opacity = Float(components.last!)
      UserDataManager.shared.red = Float(components.first!) * 255
      if components.count == 4 {
        UserDataManager.shared.green = Float(components[1]) * 255
        UserDataManager.shared.blue = Float(components[2]) * 255
      } else {
        UserDataManager.shared.green = UserDataManager.shared.red
        UserDataManager.shared.blue = UserDataManager.shared.red
      }
      
      enablePencilMode(true)
    }
  }
}

// MARK:- SettingsViewControllerDelegate
extension HomeViewController: SettingsViewControllerDelegate {
  func didTapOnSaveButton() {
    enablePencilMode(true)
    dismiss(animated: true, completion: nil)
  }
}
