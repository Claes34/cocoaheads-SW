//
//  OpeningCrawlViewController.swift
//  Star Wars Movies
//
//  Created by Nicolas Fontaine on 15/10/2018.
//  Copyright © 2018 Nicolas Fontaine. All rights reserved.
//

import UIKit

class OpeningCrawlViewController: UIViewController {

    @IBOutlet weak var textView: UITextView?
    @IBOutlet weak var thxLabel: UILabel!
    @IBOutlet weak var voteButtons: UIStackView!

    var openingCrawl: String? {
        didSet {
            textView?.text = openingCrawl
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        textView?.text = openingCrawl

        for subview in voteButtons.arrangedSubviews {
            subview.layer.cornerRadius = 8.0
        }
    }

    @IBAction func voteButtonPressed(_ sender: Any) {
        self.voteButtons.isHidden = true
        self.thxLabel.isHidden = false
        UIView.animate(withDuration: 0.4, animations: { [weak self] in
            self?.view.layoutIfNeeded()
        })
    }
}
