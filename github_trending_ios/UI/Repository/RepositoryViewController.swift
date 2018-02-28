//
//  RepositoryViewController.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 28/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import UIKit
import SDWebImage

class RepositoryViewController: UIViewController {

    var viewModel: RepositoryViewModel?

    @IBOutlet weak var avatarImageView: UIImageView! {
        didSet {
            avatarImageView?.layer.cornerRadius = (avatarImageView?.frame.height)! / 2
            avatarImageView?.clipsToBounds = true
        }
    }
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var starsAndForksSegmentedControl: UISegmentedControl!
    @IBOutlet weak var readmeContent: UITextView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var retryButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        starsAndForksSegmentedControl.addTarget(self, action: #selector(self.segmentedControlAction(sender:)), for: .valueChanged)

        viewModel?.projectName.observe { [unowned self] projectName in self.title = projectName }
        viewModel?.userName.observe { [unowned self] userName in self.userNameLabel.text = userName }
        viewModel?.description.observe { [unowned self] description in self.descriptionLabel.text = description }
        viewModel?.starCount.observe { [unowned self] starCount in self.starsAndForksSegmentedControl.setTitle(starCount, forSegmentAt: 0) }
        viewModel?.forksCount.observe { [unowned self] forksCount in self.starsAndForksSegmentedControl.setTitle(forksCount, forSegmentAt: 1) }
        viewModel?.readmeMarkdown.observe { [unowned self] markdown in self.readmeContent.attributedText = markdown }
        viewModel?.imageURL.observe { [unowned self] imageURL in self.avatarImageView.sd_setImage(with: imageURL, completed: nil) }
        viewModel?.readmeLoadingVisible.observe { [unowned self] _ in self.updateLoadingVisibility() }
        viewModel?.readmeFailedLoadingVisible.observe { [unowned self] value in self.retryButton.isHidden = !value }

        viewModel?.loadReadme()
    }

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
