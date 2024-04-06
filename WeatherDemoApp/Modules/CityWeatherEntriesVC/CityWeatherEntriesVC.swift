//
//  CityWeatherEntriesVC.swift
//  WeatherDemoApp
//
//  Created by ahmed on 05/04/2024.
//


import UIKit

final class CityWeatherEntriesVC: UIViewController {
    
    let cityWeatherInfo: LocalStorageCity
    private var gradientView: CAGradientLayer?
    
    init(cityWeatherInfo: LocalStorageCity) {
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
        
        setupPageTitleLbl()
        setupLeftBtn()
        addSearchResultsTableConstaints()
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
            navigationController?.popViewController(animated: true)
        }
        
        let model = ReusableBtnModel(btnTappedAction: addBtnAction,
                                     btnImage: UIImage(systemName: "arrow.left"))
        leftBtn.configureBtnWith(model)
    }
    
   
    private func setupPageTitleLbl() {
        let titleTxt = "\(cityWeatherInfo.cityName) \n Historical"
        pageTitleLbl.setTitle(titleTxt)
    }
    
    // MARK: SubViews
    private lazy var pageTitleLbl = ReusableBoldLabel()
    private lazy var leftBtn = ReusableButton()
    private lazy var historicalResultsTable: UITableView! = {
        let myTableView = UITableView()
        myTableView.showsVerticalScrollIndicator = false
        myTableView.backgroundColor = .clear
        myTableView.translatesAutoresizingMaskIntoConstraints = false
        myTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        myTableView.dataSource = self
        myTableView.delegate = self
        myTableView.rowHeight = 60
        myTableView.register(
            CityTableCell.self,
            forCellReuseIdentifier: CityTableCell.identifier
        )
       
        return myTableView
    }()
    private lazy var bottomImage = ReusableBottomImage(
        frame: CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: 0
        )
    )
}

// MARK: Constraints

extension CityWeatherEntriesVC {
    
    private func addBtnViewConstaints() {
        
        view.addSubview(leftBtn)
        NSLayoutConstraint.activate(
            [
                leftBtn.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
                leftBtn.leadingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                    constant: -10
                ),
                leftBtn.heightAnchor.constraint(equalToConstant: 50),
                leftBtn.widthAnchor.constraint(equalToConstant: 80)
            ]
        )
    }
    
    private func addPageTitleLabelConstaints() {
        
        view.addSubview(pageTitleLbl)
        NSLayoutConstraint.activate([
            pageTitleLbl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            pageTitleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
    }
    
    private func addBottomImageConstaints() {
        
        view.addSubview(bottomImage)
        NSLayoutConstraint.activate([
            bottomImage.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            bottomImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomImage.heightAnchor.constraint(equalToConstant: 200)
            
        ])
    }
    private func addSearchResultsTableConstaints() {
        view.addSubview(historicalResultsTable)

        NSLayoutConstraint.activate([
            historicalResultsTable.topAnchor.constraint(equalTo: leftBtn.bottomAnchor, constant: 40),
            historicalResultsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            historicalResultsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            historicalResultsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
    }
}

extension CityWeatherEntriesVC {
    // MARK: Table Datasource
    func getCellDataFormattedFor(_ indexPath: IndexPath) -> CityTableCell.CellModel {
        let primary = getHistoryEntityFor(indexPath).getDateTimeFormatted()
        
        let secondary = getHistoryEntityFor(indexPath).getWeatherDescAndTemp()
        
        return CityTableCell.CellModel(
            primaryText: primary,
            secondaryText: secondary
        )
    }
    
    func getHistoryEntitiesCount() -> Int {
        cityWeatherInfo.weatherInfoList.count
    }
    
    func getHistoryEntityFor(_ indexPath: IndexPath) -> FormattedCityWeatherModel {
        cityWeatherInfo.weatherInfoList[indexPath.row]
    }
}

// MARK: Historical Table
extension CityWeatherEntriesVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        getHistoryEntitiesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableCell.identifier, for: indexPath) as? CityTableCell else {
            return UITableViewCell()
        }
        
        let primaryFont = AppFonts.bold.size(12)
        let secondaryFont = AppFonts.regular.size(17)
        cell.configWith(
            getCellDataFormattedFor(indexPath),
            primaryFont,
            secondaryFont
        )

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let historyEntityForCity = getHistoryEntityFor(indexPath)

        let weatherInfoDetailVC = WeatherInfoDetailVC(cityWeatherInfo: historyEntityForCity)
        present(weatherInfoDetailVC, animated: true)
    }
    
}
