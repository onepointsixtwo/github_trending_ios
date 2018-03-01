//
//  AppDelegate.swift
//  github_trending_ios
//
//  Created by Kartupelis, John on 27/02/2018.
//  Copyright © 2018 Kartupelis, John. All rights reserved.
//

import Alamofire
import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, ViewManagerDelegate {

    let githubURL = URL(string: "https://api.github.com")!
    var window: UIWindow?
    var mainViewManager: ViewManager?
    var navigationController: UINavigationController?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupMainViewManager()
        return true
    }

    private func setupMainViewManager() {
        let githubClient = GitHubClient(baseURL: githubURL, network: AlamofireNetworkStack(sessionManager: SessionManager.default))
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)

        let trendingRepositoriesViewManager = TrendingRepositoriesViewManager(githubClient: githubClient, storyboard: storyboard)
        trendingRepositoriesViewManager.delegate = self

        mainViewManager = trendingRepositoriesViewManager
        mainViewManager?.start()
    }


    //MARK: - ViewManager Delegate

    func present(viewController: UIViewController) {
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: true)
        } else {
            setupRootNavigationController(viewController)
        }
    }

    func dismiss(viewController: UIViewController) {
        if let viewControllers = navigationController?.viewControllers,
            let index = viewControllers.index(of: viewController) {
            if (index - 1 >= 0) {
                let previousController = viewControllers[index - 1]
                navigationController?.popToViewController(previousController, animated: true)
            }
        }
    }


    //MARK: - Helpers

    private func setupRootNavigationController(_ rootViewController: UIViewController) {
        self.window = createWindow()
        self.navigationController = createRootNavigationController(rootViewController)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func createWindow() -> UIWindow {
        let window = UIWindow()
        window.backgroundColor = UIColor.white
        return window
    }

    private func createRootNavigationController(_ rootViewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.navigationBar.titleTextAttributes = [.foregroundColor: ColourPallette.blueGrey]
        navigationController.navigationBar.tintColor = ColourPallette.blueGrey
        navigationController.navigationBar.backgroundColor = ColourPallette.white
        navigationController.navigationBar.isTranslucent = false
        return navigationController
    }
}

