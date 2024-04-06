//
//  SearchCityViewController.swift
//  WeatherDemoApp
//
//  Created by ahmed on 03/04/2024.
//

import UIKit
import Combine


final class SearchCityViewController: UIViewController {
    
    private let viewModel: SearchCityViewModel!
    private let openCityWeatherInfo: ((LocalStorageCity) -> Void)
    private var gradientView: CAGradientLayer?
    private var disposables = Set<AnyCancellable>()

    init(viewModel: SearchCityViewModel,
         openCityWeatherInfo: @escaping ((LocalStorageCity) -> Void)) {

        self.viewModel = viewModel
        self.openCityWeatherInfo = openCityWeatherInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addGradient()
        setupPageTitleLbl()
        addCancelAction()
        
        assignViewModelClosures()

        
        addPageTitleLabelConstaints()
        addSearchStackConstaints()
        addSearchBarConstaints()
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
    
    private func setupPageTitleLbl() {
        pageTitleLbl.setTitle("Enter city, postcode or airoport location")
        pageTitleLbl.changeFont(AppFonts.regular.size(13))
        pageTitleLbl.changeTextColor(.label)
    }
    
    // MARK: Actions
    private func addCancelAction() {
        let action = UIAction { [unowned self] _ in
            self.dismiss(animated: true)
        }
        cancelBtn.addAction(action, for: .touchUpInside)
    }
    
    // MARK: startSendingText
//    @objc
//    func textDidChange() {
//        viewModel.startSearching(searchBar.text)
//    }
    
    @objc
    func clickedSearchBtn() {
        viewModel.clickedSearchBtn(searchBar.text)
    }
    
    // MARK: Subviews
    private lazy var pageTitleLbl = ReusableBoldLabel()
    private lazy var searchStack = {
        let stack = UIStackView()
        stack.translatesAutoresizingMaskIntoConstraints = false

        stack.axis = .horizontal
        stack.spacing = 10
        return stack
    }()
    private lazy var cancelBtn = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.tintColor = Colors.cancelBtnTint
        return button
    }()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = " Search..."
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        return searchBar
        
    }()
    
    private lazy var searchResultsTable: UITableView! = {
        let myTableView = UITableView()
        myTableView.backgroundColor = .clear
        myTableView.showsVerticalScrollIndicator = false
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
    
}

// MARK: assignVMClosures
extension SearchCityViewController {
    
    func assignViewModelClosures() {
        
        /// listeners
        viewModel.serverError.sink { [unowned self] error in
            showAlert(error.message)
        }
        .store(in: &disposables)
        
        viewModel.localStorageError.sink { [unowned self] error in
            showAlert(error.localizedDescription)
        }
        .store(in: &disposables)
        
        viewModel.reloadTableView = { [unowned self] in
            searchResultsTable.reloadData()
        }

        /// indicators
        viewModel.showIndicator = { [unowned self] in
            showProgress()
        }
        viewModel.hideIndicator = { [unowned self] in
            hideProgress()
        }
    }
}

// MARK: Constraints

extension SearchCityViewController {
    private func addPageTitleLabelConstaints() {
        
        view.addSubview(pageTitleLbl)
        NSLayoutConstraint.activate([
            pageTitleLbl.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            pageTitleLbl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0)
        ])
    }
    
    private func addSearchStackConstaints() {
        
        view.addSubview(searchStack)
        NSLayoutConstraint.activate([
            searchStack.topAnchor.constraint(equalTo: pageTitleLbl.bottomAnchor, constant: 20),
            searchStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)

        ])
        
    }
    
    private func addSearchBarConstaints() {
        searchStack.addArrangedSubview(searchBar)
        searchStack.addArrangedSubview(cancelBtn)
        
        NSLayoutConstraint.activate([
            searchBar.heightAnchor.constraint(equalToConstant: 36)
        ])
        
    }
    
    private func addSearchResultsTableConstaints() {
        view.addSubview(searchResultsTable)

        NSLayoutConstraint.activate([
            searchResultsTable.topAnchor.constraint(equalTo: searchStack.bottomAnchor, constant: 20),
            searchResultsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            searchResultsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            searchResultsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ])
        
    }

}

// MARK: Search Results Table
extension SearchCityViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.getCitiesCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityTableCell.identifier, for: indexPath) as? CityTableCell else {
            return UITableViewCell()
        }
        
        cell.pageTitleLbl.text = viewModel.getCityNameFor(indexPath.row)

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityWeatherInfo = viewModel.getCityFor(indexPath.row)
        
        openCityWeatherInfo(cityWeatherInfo)
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cityWeatherInfo = viewModel.getCityFor(indexPath.row)
        
        openCityWeatherInfo(cityWeatherInfo)
    }
    
}
