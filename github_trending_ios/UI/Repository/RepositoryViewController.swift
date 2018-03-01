//
//  RepositoryViewController.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import UIKit
import SDWebImage

class RepositoryViewController: UITableViewController {

    var viewModel: RepositoryViewModel?

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.height)! / 2
            avatarImageView?.clipsToBounds = true
            avatarImageView?.backgroundColor = UIColor.gray
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsAndForksSegmentedControl: UISegmentedControl!
    @IBOutlet weak var readmeContent: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var retryButton: UIButton!


    //MARK: - View Controller Overrides

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupTableView()
        setupActions()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel?.loadReadme()
    }

    override func viewDidDisappear(_ animated: Bool) {
        viewModel?.cancelLoad()
    }


    //MARK: - Setup

    private func setupNavigationBar() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.backgroundColor = ColourPallette.white
        navigationController?.navigationBar.shadowImage = UIImage()
    }

    private func setupTableView() {
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 200
        self.tableView.delegate = self
    }

    //TODO: move this
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }

    private func setupActions() {
        starsAndForksSegmentedControl.addTarget(self, action: #selector(self.segmentedControlAction(sender:)), for: .valueChanged)
    }

    private func bindViewModel() {
        viewModel?.projectName.observe { [unowned self] projectName in self.title = projectName }
        viewModel?.userName.observe { [unowned self] userName in self.userNameLabel.text = userName }
        viewModel?.description.observe { [unowned self] description in self.descriptionLabel.text = description }
        viewModel?.starCount.observe { [unowned self] starCount in self.starsAndForksSegmentedControl.setTitle(starCount, forSegmentAt: 0) }
        viewModel?.forksCount.observe { [unowned self] forksCount in self.starsAndForksSegmentedControl.setTitle(forksCount, forSegmentAt: 1) }
        viewModel?.readmeMarkdown.observe { [unowned self] markdown in
            self.readmeContent.attributedText = markdown
            // Forces the tableview to re-measure and allow room for the text
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        viewModel?.imageURL.observe { [unowned self] imageURL in self.avatarImageView.sd_setImage(with: imageURL, completed: nil) }
        viewModel?.readmeLoadingVisible.observe { [unowned self] _ in self.updateLoadingVisibility() }
        viewModel?.readmeFailedLoadingVisible.observe { [unowned self] value in self.retryButton.isHidden = !value }
    }


    // MARK: - Actions

    @IBAction func segmentedControlAction(sender: AnyObject) {
        if let viewModel = viewModel {
            if starsAndForksSegmentedControl.selectedSegmentIndex == 0 {
                openURL(url: viewModel.stargazersURL.value)
            } else {
                openURL(url: viewModel.forksURL.value)
            }
        }
    }

    @IBAction func retry(_ sender: Any) {
        viewModel?.loadReadme()
    }


    //MARK: - Helpers
    
    private func updateLoadingVisibility() {
        if viewModel?.readmeLoadingVisible.value == true {
            spinner.startAnimating()
        } else {
            spinner.stopAnimating()
        }
    }

    private func openURL(url: URL) {
        UIApplication.shared.open(url, options: [String: Any](), completionHandler: nil)
    }
}
