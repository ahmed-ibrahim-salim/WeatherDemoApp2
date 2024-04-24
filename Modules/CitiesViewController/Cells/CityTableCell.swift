//
//  CityTableCell.swift
//  WeatherDemoApp
//
//  Created by ahmed on 04/04/2024.
//

import UIKit

final class CityTableCell: UITableViewCell {
    
    lazy var labelsStack = { 
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    var pageTitleLbl = ReusableBoldLabel()
    var pageSecondaryLbl = ReusableBoldLabel() {
        didSet {
            pageSecondaryLbl.isHidden = true
        }
    }

    static let identifier = "CityTableCell"
    
    // MARK: initialiser
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setViewSpecs()
        setConstaints()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Set view props
    private func setViewSpecs() {
        pageTitleLbl.setAlignment(.natural)
        pageSecondaryLbl.setAlignment(.natural)

        accessoryType = .detailDisclosureButton
//        accessoryView = UIImageView(
//            image: UIImage(systemName: "chevron.right")
//        )
        tintColor = Colors.mainBtnBackgroundColor
        pageSecondaryLbl.textColor = Colors.mainBtnBackgroundColor
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    func configWith(
        _ model: CityTableCell.CellModel,
        _ primaryFont: UIFont,
        _ secondaryFont: UIFont
    ) {
        pageTitleLbl.text = model.primaryText
        pageSecondaryLbl.text = model.secondaryText
        
        
        pageTitleLbl.font = primaryFont
        pageSecondaryLbl.font = secondaryFont
        
    }
    
    // MARK: Set constaints

    private func setConstaints() {
        
        contentView.addSubview(labelsStack)
        labelsStack.addArrangedSubview(pageTitleLbl)
        labelsStack.addArrangedSubview(pageSecondaryLbl)
        
        NSLayoutConstraint.activate([
            labelsStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: 0),
            labelsStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            labelsStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
    }
    
}

// MARK: Model
extension CityTableCell {
    struct CellModel {
        let primaryText, secondaryText: String
    }
}
