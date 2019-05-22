//
//  CurrentCountryViewController.swift
//  Country Search
//
//  Created by A. Hoffmann on 21.05.19.
//  Copyright © 2019 A. Hoffmann. All rights reserved.
//

import UIKit

class CurrentCountryViewController: UIViewController {

    @IBOutlet var flagView: UIImageView?
    @IBOutlet var nameLabel: UILabel?
    @IBOutlet var capitalLabel: UILabel?
    @IBOutlet var langCurrLabel: UILabel?
    @IBOutlet var regionLabel: UILabel?
    @IBOutlet var populationLabel: UILabel?
    @IBOutlet var regionalBlocsLabel: UILabel?

    @IBOutlet var noInfoLabel: UILabel?

    var country: Country? {
        didSet {

            if country == nil {
                showNoInfo(show: true)
                return
            } else {
                showNoInfo(show: false)
            }
            
            nameLabel?.text = country?.name
            capitalLabel?.text = country?.capital
            langCurrLabel?.text = "\(country?.languages.first ?? "unknown") – \(country?.currencies.first ?? "unknown")"
            regionLabel?.text = country?.region
            if let population = country?.population {
                populationLabel?.text = "Pop \(population)"
            }

            let regions = country?.regionalBlocks.joined(separator: ", ")
            regionalBlocsLabel?.text = regions
        }
    }

    private func showNoInfo(show: Bool) {
        nameLabel?.isHidden = show
        capitalLabel?.isHidden = show
        langCurrLabel?.isHidden = show
        regionLabel?.isHidden = show
        flagView?.isHidden = show
        regionalBlocsLabel?.isHidden = show
        populationLabel?.isHidden = show

        noInfoLabel?.isHidden = !show
    }
}
