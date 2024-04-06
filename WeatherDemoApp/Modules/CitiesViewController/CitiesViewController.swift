//
//  ViewController.swift
//  WeatherDemoApp
//
//  Created by ahmed on 01/04/2024.
//

import UIKit
import Combine

final class CitiesViewController: UITableViewController {
    
    private let viewModel: CitiesViewModel!
    private var gradientView: CAGradientLayer?
    private var disposables = Set<AnyCancellable>()
    
    init(viewModel: CitiesViewModel) {
        self.viewModel = viewModel
        super.init(style: .insetGrouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: false)
        
        setupRightBtn()
        setupPageTitleLbl()
        addGradient()
        
        addPageTitleLabelConstaints()
        addBtnViewConstaints()
        addBottomImageConstaints()
        
        setupTableView()
        
        assignViewModelClosures()
        
        /// watch RealmDB on Simulator
        /// print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!.path())
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        // to activate gradient
        gradientView?.frame = tableView.bounds
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.bringSubviewToFront(rightBtn)
    }
    
    // MARK: View Configurators
    private func setupTableView() {
        tableView.rowHeight = 60
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = Colors.pageGradientFirstColor
        tableView.register(
            CityTableCell.self,
            forCellReuseIdentifier: CityTableCell.identifier
        )
        //        tableView.bounces = false
    }
    private func addGradient() {
        let pageGradient = Colors.pageGradient
        
        gradientView = tableView.setGradient(colors: pageGradient.colors,
                                             locations: pageGradient.locations,
                                             startPoint: pageGradient.startPoint,
                                             endPoint: pageGradient.endPoint)
    }
    
    private func setupPageTitleLbl() {
        pageTitleLbl.setTitle("Cities")
    }
    
    // MARK: Navigation Methods
    private func presentWeatherDetailScreen(_ cityWeatherInfo: LocalStorageCity) {
        let detailVC = CityWeatherEntriesVC(cityWeatherInfo: cityWeatherInfo)
        navigationController?.pushViewController(detailVC, animated: true)
    }
    
    private func setupRightBtn() {
        /// Action
        let addBtnAction: VoidCallback = { [unowned self] in
            
            let viewModel = SearchCityViewModel(weatherFetcher: WeatherFetcher(),
                                                localStorageHelper: LocalStorageManager.shared)
            
            let didSelectCityCompletion: ((LocalStorageCity) -> Void) = { [unowned self] cityWeatherInfo in
                
                /// selected city ? dismiss search screen then present weather details screen
                dismiss(animated: true)
                
                presentWeatherDetailScreen(cityWeatherInfo)
                
            }
            
            /// present search screen
            let viewC = SearchCityViewController(viewModel: viewModel,
                                                 openCityWeatherInfo: didSelectCityCompletion)
            present(viewC, animated: true, completion: nil)
        }
        
        let model = ReusableBtnModel(btnTappedAction: addBtnAction,
                                     btnImage: UIImage(systemName: "plus"))
        rightBtn.configureBtnWith(model)
    }
    
    // MARK: SubViews
    private lazy var rightBtn = ReusableButton()
    private lazy var pageTitleLbl = ReusableBoldLabel()
    private lazy var bottomImage = ReusableBottomImage(
        frame: CGRect(
            x: 0,
            y: 0,
            width: 0,
            height: 0
        )
    )
}


// MARK: Constaints
extension CitiesViewController {
    
    private func addBtnViewConstaints() {
        
        view.addSubview(rightBtn)
        
        NSLayoutConstraint.activate(
            [
                rightBtn.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                rightBtn.trailingAnchor.constraint(
                    equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                    constant: 20
                ),
                rightBtn.heightAnchor.constraint(equalToConstant: 53),
                rightBtn.widthAnchor.constraint(equalToConstant: 90)
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
    
    private func addBottomImageConstaints() {
        
        view.addSubview(bottomImage)
        NSLayoutConstraint.activate([
            bottomImage.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 35),
            bottomImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            bottomImage.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            bottomImage.heightAnchor.constraint(equalToConstant: 250)
            
        ])
    }
}

// MARK: AssignViewModelClosures
extension CitiesViewController {
    func assignViewModelClosures() {
        viewModel.reloadTableView = { [unowned self] in
            tableView.reloadData()
        }
        
        /// listeners
        viewModel.serverError.sink { [unowned self] error in
            showAlert(error.message)
        }
        .store(in: &disposables)
        
        viewModel.localStorageError.sink { [unowned self] error in
            showAlert(error.localizedDescription)
        }
        .store(in: &disposables)
    }
}

// MARK: Table
extension CitiesViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getCitiesCount()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableCell.identifier, for: indexPath) as? CityTableCell else {
            return UITableViewCell()
        }
        
        cell.pageTitleLbl.text = viewModel.getCityNameFor(indexPath.row)
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityWeatherInfo = viewModel.getCityFor(indexPath.row)
        presentWeatherDetailScreen(cityWeatherInfo)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cityWeatherInfo = viewModel.getCityFor(indexPath.row)
        presentWeatherDetailScreen(cityWeatherInfo)
    }
    
    // to make spacing on top of each section
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView(
            frame: CGRect(
                x: 0,
                y: 0,
                width: 0,
                height: 100
            )
        )
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            viewModel.deleteCity(indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        default:
            break
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
}
