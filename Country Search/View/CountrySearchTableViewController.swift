//
//  CountrySearchTableViewController.swift
//  Country Search
//
//  Created by A. Hoffmann on 17.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import UIKit

private let kCCellReuseIdentifier = "CountryCellIdentifier"

class CountrySearchTableViewController: UITableViewController {

    @IBOutlet var orderBarButton: UIBarButtonItem?

    var viewModel = CountrySearchViewModel()

    private var searchController: UISearchController?
    private var searchResultsController = UITableViewController()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = viewModel.title

        viewModel.loadCountries {
            DispatchQueue.main.sync {
                self.tableView.reloadData()
            }
        }

        definesPresentationContext = true

        configureSearchController()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(forName: kDidUpdateLocationNotification, object: nil, queue: nil) { _ in
            self.tableView.reloadData()
        }

        NotificationCenter.default.addObserver(forName: kDidUpdatePlacemarkNotification, object: nil, queue: nil) { _ in
            self.tableView.reloadData()
            debugPrint("\(self.viewModel.currentCountry?.name ?? "")")
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    private func configureSearchController() {
        searchResultsController.tableView.dataSource = self

        searchController = UISearchController(searchResultsController: searchResultsController)
        searchController?.searchResultsUpdater = self
        searchController?.searchBar.autocapitalizationType = .none
        searchController?.delegate = self

        navigationItem.searchController = searchController
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: kCCellReuseIdentifier) {
            guard let country = viewModel.country(for: indexPath) else {
                return UITableViewCell()
            }

            cell.textLabel?.text = country.name
            cell.detailTextLabel?.text = "Pop: \(country.population) – Size: \(country.area) km2"

            viewModel.flagImage(for: indexPath) { image in
                DispatchQueue.main.async {
                    if let cell = tableView.cellForRow(at: indexPath) {
                        cell.imageView?.image = image
                        cell.layoutSubviews()
                    }
                }
            }

            return cell
        }

        return UITableViewCell(style: .subtitle, reuseIdentifier: kCCellReuseIdentifier)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCountries
    }

    @IBAction func orderBarButtonSelected(sender: UIBarButtonItem) {
        viewModel.orderAscending.toggle()
        tableView.reloadData()

        orderBarButton?.title = viewModel.orderButtonTitle
    }
}

extension CountrySearchTableViewController: UISearchControllerDelegate {

    func didPresentSearchController(_ searchController: UISearchController) {
        viewModel.isSearchActive = true
    }

    func didDismissSearchController(_ searchController: UISearchController) {
        viewModel.isSearchActive = false
        tableView.reloadData()
    }
}

extension CountrySearchTableViewController: UISearchResultsUpdating {

    func updateSearchResults(for searchController: UISearchController) {
        guard let term = searchController.searchBar.text else {
            return
        }

        if term.count > 1 {
            viewModel.search(with: term)
            searchResultsController.tableView.reloadData()
        }
    }
}
