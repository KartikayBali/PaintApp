//
//  SliderView.swift
//  PaintApp
//
//  Created by Bali on 08/12/19.
//  Copyright © 2019 Kartikay Bali. All rights reserved.
//

import UIKit

protocol SliderViewDelegate: class {
  func sliderValueDidChanged(_ sliderView: SliderView)
}

class SliderView: UIView {

  let slider: UISlider = {
    let slider = UISlider(frame: .zero)
    slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
    slider.translatesAutoresizingMaskIntoConstraints = false
    slider.clipsToBounds = true
    return slider
  }()

  let headerLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.font = UIFont.boldSystemFont(ofSize: 16)
    label.textAlignment = .right
    label.translatesAutoresizingMaskIntoConstraints = false
    label.clipsToBounds = true
    return label
  }()
  
  let valueLabel: UILabel = {
    let label = UILabel(frame: .zero)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.clipsToBounds = true
    return label
  }()
  
  weak var delegate: SliderViewDelegate?
  
  // MARK:- Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupView()
  }
  
  // MARK:- Public Methods
  func loadViewWithValues(_ header: String, _ sliderCurrentVal: Float, _ sliderMinVal: Float, _ sliderMaxVal: Float) {
    headerLabel.text = header
    valueLabel.text = "\(sliderCurrentVal)"
    slider.maximumValue = sliderMaxVal
    slider.minimumValue = sliderMinVal
    slider.value = sliderCurrentVal
  }
  
  // MARK:- Private Methods
  @objc func sliderValueChanged(_ slider: UISlider) {
    delegate?.sliderValueDidChanged(self)
  }
  
  private func setupView() {
    addSubview(headerLabel)
    addSubview(slider)
    addSubview(valueLabel)
    
    NSLayoutConstraint.activate(getHeaderLabelConstraints() + getSliderConstraints() + getValueLabelConstraints())
  }
  
  private func getHeaderLabelConstraints() -> [NSLayoutConstraint] {
    return [
      headerLabel.widthAnchor.constraint(equalToConstant: 70),
      headerLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
      headerLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]
  }
  
  private func getSliderConstraints() -> [NSLayoutConstraint] {
    return [
      slider.leadingAnchor.constraint(equalTo: headerLabel.trailingAnchor, constant: 5),
      slider.centerYAnchor.constraint(equalTo: centerYAnchor),
      slider.trailingAnchor.constraint(equalTo: valueLabel.leadingAnchor, constant: -5)
    ]
  }
  
  private func getValueLabelConstraints() -> [NSLayoutConstraint] {
    return [
      valueLabel.widthAnchor.constraint(equalToConstant: 70),
      valueLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 8),
      valueLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
    ]
  }
}
