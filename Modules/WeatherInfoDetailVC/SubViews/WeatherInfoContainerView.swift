//
//  WeatherInfoContainerView.swift
//  WeatherDemoApp
//
//  Created by ahmed on 06/04/2024.
//

import UIKit
import SDWebImage

final class WeatherInfoContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setSubViewsConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
        setSubViewsConstraints()
    }
    
    private func setSubViewsConstraints() {
        addWeatherImageConstraints()
        addcontainerStackConstraints()
    }
    
    // MARK: setupViews
    private func setupViews() {
       backgroundColor = Colors.weatherContainerColor
       translatesAutoresizingMaskIntoConstraints = false
       layer.cornerRadius = 40
       layer.shadowColor = UIColor.black.cgColor
       layer.shadowOpacity = 0.2
       layer.shadowOffset = CGSize(width: 0, height: 8)
       layer.shadowRadius = 20
        
    }
    
    // MARK: Subviews
    private lazy var weatherImage = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
        
    private lazy var containerStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        return stack
    }()
    
    private lazy var weatherDescRow = WeatherRowStackView()
    private lazy var weatherTempRow = WeatherRowStackView()
    private lazy var weatherHumidityRow = WeatherRowStackView()
    private lazy var weatherWindSpeedRow = WeatherRowStackView()

    func configRowsWith(_ models: [WeatherRowStackView.RowModel],
                        _ imageId: String) {
        
        let weatherRows = [weatherDescRow,
                           weatherTempRow,
                           weatherHumidityRow,
                           weatherWindSpeedRow]
        
        for (index, model) in models.enumerated() {
            weatherRows[index].configWith(model)
        }
        
        weatherImage.sd_setImage(
            with: URL(string: "https://openweathermap.org/img/w/\(imageId).png"),
            placeholderImage: UIImage(named: "sun_ic")
        )
        
    }
    
    // MARK: Constraints
    private func addWeatherImageConstraints() {
        addSubview(weatherImage)
        
        NSLayoutConstraint.activate([
            weatherImage.topAnchor.constraint(equalTo: topAnchor, constant: 45),
            weatherImage.heightAnchor.constraint(equalToConstant: 150),
            
            weatherImage.widthAnchor.constraint(equalToConstant: 150),
            weatherImage.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0)
        ])
    }
    
    private func addcontainerStackConstraints() {
        addSubview(containerStack)
        
        containerStack.addArrangedSubview(weatherDescRow)
        containerStack.addArrangedSubview(weatherTempRow)
        containerStack.addArrangedSubview(weatherHumidityRow)
        containerStack.addArrangedSubview(weatherWindSpeedRow)
        
        NSLayoutConstraint.activate([
            containerStack.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 20),
            containerStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            containerStack.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            containerStack.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10)
            
        ])

    }
}
