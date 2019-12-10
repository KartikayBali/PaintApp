//
//  SettingsViewController.swift
//  PaintApp
//
//  Created by Bali on 07/12/19.
//  Copyright © 2019 Kartikay Bali. All rights reserved.
//

import UIKit

protocol SettingsViewControllerDelegate: class {
  func didTapOnSaveButton()
}

class SettingsViewController: UIViewController {
  
  // MARK:- IBOutlets
  @IBOutlet var colorView: UIView!
  @IBOutlet var brushSliderView: SliderView!
  @IBOutlet var opacitySliderView: SliderView!
  @IBOutlet var redSliderView: SliderView!
  @IBOutlet var greenSliderView: SliderView!
  @IBOutlet var blueSliderView: SliderView!
  
  // MARK:- Variables
  var info: [SliderView: (String, Float, Float, Float)] {
    return [brushSliderView: ("Brush", brushWidth, 0, 10),
            opacitySliderView: ("Opacity", opacity, 0, 1),
            redSliderView: ("Red", red, 0, 255),
            greenSliderView: ("Green", green, 0, 255),
            blueSliderView: ("Blue", blue, 0, 255)]
  }
  
  var brushWidth = UserDataManager.shared.brushWidth
  var opacity = UserDataManager.shared.opacity
  var red = UserDataManager.shared.red
  var green = UserDataManager.shared.green
  var blue = UserDataManager.shared.blue
  
  weak var delegate: SettingsViewControllerDelegate?
  
  // MARK:- Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupContentView()
    colorView.layer.cornerRadius = colorView.frame.width / 2
  }
  
  // MARK:- IBActions
  @IBAction func cancelButtonTapped(_ button: UIButton) {
    dismiss(animated: true, completion: nil)
  }
  
  @IBAction func saveButtonTapped(_ button: UIButton) {
    UserDataManager.shared.brushWidth = brushWidth
    UserDataManager.shared.opacity = opacity
    UserDataManager.shared.red = red
    UserDataManager.shared.green = green
    UserDataManager.shared.blue = blue
    
    delegate?.didTapOnSaveButton()
  }

  // MARK:- Private Methods
  private func setupContentView() {
    let sliderViews: [SliderView] = [brushSliderView, opacitySliderView, redSliderView, greenSliderView, blueSliderView]
    for sliderView in sliderViews {
      if let value = info[sliderView] {
        sliderView.loadViewWithValues(value.0, value.1, value.2, value.3)
        sliderView.delegate = self
      }
    }
    
    updateColorView()
  }
  
  private func updateColorView() {
    colorView.backgroundColor = UIColor(red: CGFloat(red/255), green: CGFloat(green/255), blue: CGFloat(blue/255), alpha: CGFloat(opacity))
  }
}

// MARK:- SliderViewDelegate
extension SettingsViewController: SliderViewDelegate {
  func sliderValueDidChanged(_ sliderView: SliderView) {
    switch sliderView {
    case brushSliderView:
      brushWidth = round(sliderView.slider.value)
    case opacitySliderView:
      opacity = round(sliderView.slider.value * 10) / 10
    case redSliderView:
      red = round(sliderView.slider.value * 10) / 10
    case greenSliderView:
      green = round(sliderView.slider.value * 10) / 10
    case blueSliderView:
      blue = round(sliderView.slider.value * 10) / 10
    default:
      break
    }
    
    setupContentView()
  }
}
