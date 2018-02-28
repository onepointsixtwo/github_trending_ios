//
//  TrendingRepositoriesViewController.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import UIKit

class TrendingRepositoriesViewController: UIViewController, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate {
    let cellIdentifier = "trendingCell"

    var viewModel: TrendingRepositoriesViewModel?

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var obscuringView: UIView!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var retryButton: UIButton!


    // MARK: - View controller overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupTableView()
        setupViewModelBindings()
        setupTaps()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.fetchRepositories()
    }

    override func viewWillDisappear(_ animated: Bool) {
        viewModel?.cancelFetchingRepositories()
    }


    // MARK: - Actions

    @IBAction func retry(_ sender: Any) {
        viewModel?.fetchRepositories()
    }

    @IBAction func tap() {
        searchBar.resignFirstResponder()
    }


    // MARK: - Setup

    private func setupViewModelBindings() {
        viewModel?.showError.observe { [unowned self] _ in self.handleObscuringViewUpdate() }
        viewModel?.showLoading.observe { [unowned self] _ in self.handleObscuringViewUpdate() }
        viewModel?.displayRepositories.observe { [unowned self] _ in self.handleRepositoriesUpdated() }
    }

    private func setupSearchBar() {
        searchBar.delegate = self
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    private func setupTaps() {
        let tapGestureRecogniser = UITapGestureRecognizer(target: self, action: #selector(TrendingRepositoriesViewController.tap))
        tapGestureRecogniser.cancelsTouchesInView = false
        self.tableView.addGestureRecognizer(tapGestureRecogniser)
    }

    
    // MARK: - View Model Updates

    private func handleObscuringViewUpdate() {
        obscuringView.isHidden = viewModel?.showLoading.value == false && viewModel?.showError.value == false
        loadingSpinner.isHidden = viewModel?.showLoading.value == false
        retryButton.isHidden = viewModel?.showError.value == false
    }

    private func handleRepositoriesUpdated() {
        tableView.reloadData()
    }


    // MARK: - Search Bar Delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel?.filterRepositoriesBySearch(search: searchText)
    }

    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }


    // MARK: - UITableView Data Source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = viewModel?.displayRepositories.value.count {
            return count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        if let cell =  cell as? TrendingRepositoryCell,
            let repository = viewModel?.displayRepositories.value[indexPath.row] {
            cell.name.text = repository.projectName
            cell.starsCount.text = repository.starsCount
            cell.projectDescription.text = repository.description
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }


    // MARK: - UITableView Delegate

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        viewModel?.repositoryAtIndexPressed(index: indexPath.row)
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.resignFirstResponder()
    }
}
