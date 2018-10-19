//
//  MoviesListViewController.swift
//  Star Wars Movies
//
//  Created by Nicolas Fontaine on 12/10/2018.
//  Copyright © 2018 Nicolas Fontaine. All rights reserved.
//

import UIKit

class MoviesListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    var firstAppearance = true
    var movies: [Movie] = []

    // This var is lazy --> It will instanciate with the code bellow when called for the first time
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: .valueChanged)
        refreshControl.tintColor = #colorLiteral(red: 1, green: 0.7486202346, blue: 0.1792230156, alpha: 1)

        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Add refreshControll (used for pull to refresh) to the tableview
        tableView.addSubview(refreshControl)

        tableView.estimatedRowHeight = 110
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Deselect row if one is selected on viewWillAppear, so when we go back
        // From the crawl opening of the movie, all cells are deselected
        if let selectedRowPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedRowPath, animated: false)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // On first appearance, make the refreshControll appear by scrolling up with animation
        // And launch refresh manually
        if firstAppearance {
            firstAppearance = false
            UIView.animate(withDuration: 0.25, animations: { [weak self] in
                self?.tableView.setContentOffset(CGPoint(x: 0, y: -(self?.refreshControl.frame.height ?? 0)), animated: false)
            }) { [weak self] (_) in
                self?.refreshControl.beginRefreshing()
                self?.handleRefresh(self?.refreshControl)
            }
        }
    }

    // This methods is used to "customize" the segue before it is performed
    // I'm using this to give data to the next screen.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let openingCrawlVC = segue.destination as? OpeningCrawlViewController,
            let selectedRowPath = tableView.indexPathForSelectedRow {
            openingCrawlVC.title = movies[selectedRowPath.row].title
            openingCrawlVC.openingCrawl = movies[selectedRowPath.row].opening_crawl
        }
    }

    // MARK: - Refresh

    @objc func handleRefresh(_ refreshControl: UIRefreshControl?) {

        // Grab all movies from the Api
        Api.shared.getAllMovies { [weak self] (retrievedMovies, error) in

            // Save the movies in the viewController property so the tableview can use it
            self?.movies = retrievedMovies ?? [] // If no movies retrieved (nil), save and empty array

            if let unwrappedError = error {
                // Instanciate a native popup to display an error
                let alertController = UIAlertController(title: "Oh oh...", message: unwrappedError.localizedDescription, preferredStyle: .alert)
                // Add an "OK" button to the popup (no need for an handler, it will close the popup)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                //Present the popup
                self?.present(alertController, animated: true, completion: nil)
            }
            
            refreshControl?.endRefreshing()

            // Refresh the content of the table view now that we have retrieved
            // the movies
            self?.tableView.reloadData()
        }
    }
}
    // MARK: - TableView delegate / datasource

extension MoviesListViewController: UITableViewDataSource, UITableViewDelegate {

    // This method specify the number of rows that will appear for a section in the tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // We only need one section in the tableView
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Try to dequeue the cell we have prototyped
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellIdentifiers.movieCell) as? MovieTableViewCell else {
            return UITableViewCell()
        }

        // Fill the cell with the data we have on the movies array
        cell.titleLabel.text = movies[indexPath.row].title
        cell.releaseDateLabel.text = movies[indexPath.row].release_date
        cell.accessoryType = .disclosureIndicator // This displays the chevron on the right of the cell

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension // Used to compute the height of cells (rows) automatically
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // When a row is selected, we launch the segue to go to the next screen
        performSegue(withIdentifier: Constants.Segues.openingCrawlSegue, sender: self)
    }
}

