//
//  ReusableBtn.swift
//  WeatherDemoApp
//
//  Created by ahmed on 03/04/2024.
//

import UIKit

final class ReusableButton: UIButton {
    
    var btnTappedAction: VoidCallback?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    // MARK: setupViews
    private func setupViews() {
        backgroundColor = Colors.mainBtnBackgroundColor
        tintColor = Colors.mainBtnTintColor
        
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 20
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize(width: 0, height: 8)
        layer.shadowRadius = 20
        addTarget(
            self,
            action: #selector(btnPressed),
            for: .touchUpInside
        )
        
    }
    
    @objc
    private func btnPressed() {
        btnTappedAction?()
    }
    
    func configureBtnWith(_ model: ReusableBtnModel) {
        setImage(model.btnImage, for: .normal)
        btnTappedAction = model.btnTappedAction
    }
    
    func setCornerRadius(_ radius: CGFloat) {
        layer.cornerRadius = radius
    }
}

// MARK: Model
struct ReusableBtnModel {
    var btnTappedAction: VoidCallback
    var btnImage: UIImage?
}
