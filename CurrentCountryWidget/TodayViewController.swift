//
//  TodayViewController.swift
//  CurrentCountryWidget
//
//  Created by A. Hoffmann on 21.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {

    private let kEmbedSegue = "twEmbedSegue"

    private let viewModel = TodayViewModel()

    private var currentCountryViewController: CurrentCountryViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.fetchCountryList {
            self.reloadView()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        NotificationCenter.default.addObserver(forName: kDidUpdatePlacemarkNotification, object: nil, queue: nil) { _ in
            self.viewModel.reloadAfterUpdate()
        }

        viewModel.update {
            self.reloadView()
        }
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }

    private func reloadView() {
        self.currentCountryViewController?.country = self.viewModel.currentCountry

        if let code = self.viewModel.currentCountry?.code {
            viewModel.flagImage(for: code, completion: { image in
                DispatchQueue.main.async {
                    self.currentCountryViewController?.flagView?.image = image
                }
            })
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == kEmbedSegue {
            currentCountryViewController = segue.destination as? CurrentCountryViewController
        }
    }
}
