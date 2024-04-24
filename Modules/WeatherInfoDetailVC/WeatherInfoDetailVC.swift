//
//  WeatherInfoDetailVC.swift
//  WeatherDemoApp
//
//  Created by ahmed on 05/04/2024.
//

import UIKit
import SDWebImage

final class WeatherInfoDetailVC: UIViewController {
    
    private let cityWeatherInfo: FormattedCityWeatherModel
    private var gradientView: CAGradientLayer?
    
    init(cityWeatherInfo: FormattedCityWeatherModel) {
        self.cityWeatherInfo = cityWeatherInfo
        super.init(nibName: nil, bundle: nil)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    // MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        addBottomImageConstaints()
        addPageTitleLabelConstaints()
        addBtnViewConstaints()
        addbottomTimeLblConstaints()
        
        setupBottomTimeLbl()
        setupPageTitleLbl()
        setupLeftBtn()
        addWeatherInfoContainerConstraints()
        passDataToWeatherInfoContainer()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // to activate gradient
        gradientView?.frame = view.bounds
    }
    
    // MARK: View Configurators
    private func addGradient() {
        let pageGradient = Colors.pageGradient
        
        gradientView = view.setGradient(colors: pageGradient.colors,
                                        locations: pageGradient.locations,
                                        startPoint: pageGradient.startPoint,
                                        endPoint: pageGradient.endPoint)
    }
    
    private func setupLeftBtn() {
        leftBtn.setCornerRadius(14)
        
        /// Action
        let addBtnAction: VoidCallback = { [unowned self] in
            dismiss(animated: true)
        }
        
        let model = ReusableBtnModel(btnTappedAction: addBtnAction,
                                     btnImage: UIImage(systemName: "xmark"))
        leftBtn.configureBtnWith(model)
    }
    
    private func passDataToWeatherInfoContainer() {
        let models = [WeatherRowStackView.RowModel(
            title: "Description",
            value: cityWeatherInfo.desc
        ), WeatherRowStackView.RowModel(
            title: "Temperature",
            value: cityWeatherInfo.temp
        ), WeatherRowStackView.RowModel(
            title: "Humidity",
            value: cityWeatherInfo.humidity
        ), WeatherRowStackView.RowModel(
            title: "Wind Speed",
            value: cityWeatherInfo.windSpeed
        )]
        
        weatherInfoContainer.configRowsWith(
            models,
            cityWeatherInfo.icon
        )
    }
    
    private func setupBottomTimeLbl() {
        let timeText = "Weather information for \(cityWeatherInfo.cityName) received on \n \(cityWeatherInfo.getDateTimeFormatted())"
        bottomTimeLbl.setTitle(timeText)
        bottomTimeLbl.changeFont(AppFonts.regular.size(12))
        bottomTimeLbl.textColor = UIColor(hex: "3D4548")
    }
    
    private func setupPageTitleLbl() {
        pageTitleLbl.setTitle(cityWeatherInfo.cityName)
    }
    
    // MARK: SubViews
    private lazy var pageTitleLbl = ReusableBoldLabel()
    private lazy var bottomTimeLbl = ReusableBoldLabel()
    private lazy var leftBtn = ReusableButton()
    private lazy var bottomImage = ReusableBottomImage(
        frame: CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: 0
        )
    )
    
    private lazy var weatherInfoContainer = WeatherInfoContainerView()

}

// MARK: Constraints

extension WeatherInfoDetailVC {
    
    private func addBtnViewConstaints() {
        
        view.addSubview(leftBtn)
        NSLayoutConstraint.activate(
            [
                leftBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: -10),
                leftBtn.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: -10
                ),
                leftBtn.heightAnchor.constraint(equalToConstant: 60),
                leftBtn.widthAnchor.constraint(equalToConstant: 80)
            ]
        )
    }
    
    private func addPageTitleLabelConstaints() {
        
        view.addSubview(pageTitleLbl)
        NSLayoutConstraint.activate([
            pageTitleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            pageTitleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
    }
    
    private func addbottomTimeLblConstaints() {
        
        view.addSubview(bottomTimeLbl)
        NSLayoutConstraint.activate([
            bottomTimeLbl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40),
            bottomTimeLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
    }
    
    private func addBottomImageConstaints() {
        
        view.addSubview(bottomImage)
        NSLayoutConstraint.activate([
            bottomImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomImage.heightAnchor.constraint(equalToConstant: 300)
            
        ])
    }
    
    func addWeatherInfoContainerConstraints() {
        view.addSubview(weatherInfoContainer)
        
        NSLayoutConstraint.activate([
            weatherInfoContainer.topAnchor.constraint(equalTo: pageTitleLbl.bottomAnchor, constant: 40),
            weatherInfoContainer.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8),
            weatherInfoContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
            
        ])
    }
    
}
