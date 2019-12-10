//
//  ColorSelectionView.swift
//  PaintApp
//
//  Created by Bali on 09/12/19.
//  Copyright © 2019 Kartikay Bali. All rights reserved.
//

import UIKit

protocol ColorSelectionViewDelegate: class {
  func didSelectedColor(_ color: UIColor)
}

class ColorSelectionView: UIView {

  let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.distribution = .fillEqually
    stackView.translatesAutoresizingMaskIntoConstraints = false
    stackView.clipsToBounds = true
    
    return stackView
  }()
  
  let buttons: [UIButton] = {
    var buttons = [UIButton]()
    for (index, color) in UserDataManager.defaultColors.enumerated() {
      let button = UIButton(type: .custom)
      button.backgroundColor = color
      button.tag = index
      button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
      button.translatesAutoresizingMaskIntoConstraints = false
      button.clipsToBounds = true
      buttons.append(button)
    }
    
    return buttons
  }()
  
  weak var delegate: ColorSelectionViewDelegate?
  
  // MARK:- Lifecycle
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupView()
  }
  
  required init?(coder: NSCoder) {
    super.init(coder: coder)
    
    setupView()
  }
  
  // MARK:- Private Methods
  @objc private func buttonTapped(_ button: UIButton) {
    delegate?.didSelectedColor(UserDataManager.defaultColors[button.tag])
  }
  
  private func setupView() {
    setupStackView()
    addSubview(stackView)
    
    NSLayoutConstraint.activate([stackView.topAnchor.constraint(equalTo: topAnchor), stackView.bottomAnchor.constraint(equalTo: bottomAnchor), stackView.trailingAnchor.constraint(equalTo: trailingAnchor), stackView.leadingAnchor.constraint(equalTo: leadingAnchor)])
  }
  
  private func setupStackView() {
    for button in buttons {
      stackView.addArrangedSubview(button)
    }
  }
}
