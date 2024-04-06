//
//  WeatherRowStackView.swift
//  WeatherDemoApp
//
//  Created by ahmed on 06/04/2024.
//

import UIKit

final class WeatherRowStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        translatesAutoresizingMaskIntoConstraints = false
        axis = .horizontal
        
        textLbl.textAlignment = .natural
        textLbl.changeFont(AppFonts.bold.size(16))
        
        valueLbl.textColor = Colors.mainBtnBackgroundColor
        valueLbl.changeFont(AppFonts.semibold.size(22))
        
        addArrangedSubview(textLbl)
        addArrangedSubview(valueLbl)
                
    }
    
    func configWith(_ model: WeatherRowStackView.RowModel) {
        
        textLbl.text = model.title
        valueLbl.text = model.value
    }
    
    private lazy var textLbl = ReusableBoldLabel()
    private lazy var valueLbl = ReusableBoldLabel()

}

extension WeatherRowStackView {
    struct RowModel {
        let title, value: String
    }
}
