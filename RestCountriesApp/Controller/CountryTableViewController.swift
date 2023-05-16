//
//  CountryTableViewController.swift
//  RestCountriesApp
//
//  Created by jazeps.ivulis on 16/05/2023.
//

import UIKit
import SDWebImage

class CountryTableViewController: UITableViewController {
    
    private let cellID = "cell"
    private let url = "https://restcountries.com/v3.1/all"
    private var countries: [Country] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        NetworkManager.fetchData(url: url) { countries in
            self.countries = countries
            dump(self.countries)
            DispatchQueue.main.async {
                self.tableView.reloadData()
                
            }
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    private func setupView() {
        view.backgroundColor = .secondarySystemBackground
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavBar()
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressed(sender: )))
        view.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc private func longPressed(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.began {
            let touchPoint = sender.location(in: tableView)
            if let indexPath = tableView.indexPathForRow(at: touchPoint) {
                basicActionSheet(title: countries[indexPath.row].name.common, message: countries[indexPath.row].name.official)
            }
        }
    }
    
    private func setupNavBar() {
        title = "Country List"
        let titleImage = UIImage(systemName: "globe")
        let imageView = UIImageView(image: titleImage)
        self.navigationItem.titleView = imageView
        let showAlertBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "hazardsign"), style: .plain, target: self, action: #selector(basicAlert))
        self.navigationItem.rightBarButtonItem = showAlertBarButtonItem
        
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.label]
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .label
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath as IndexPath)
        cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: cellID)
        
        let country = countries[indexPath.row]
        cell.textLabel?.text = country.name.common
        cell.detailTextLabel?.text = country.name.official
        cell.imageView?.sd_setImage(with: URL(string: country.flags.png))
        
        return cell
    }
}

extension CountryTableViewController {
    
    private func basicActionSheet(title: String?, message: String?) {
        DispatchQueue.main.async {
            let actionSheet: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(cancelAction)
            self.present(actionSheet, animated: true)
        }
    }
    
    @objc private func basicAlert() {
        DispatchQueue.main.async {
            let alert: UIAlertController = UIAlertController(title: "Alert title", message: "Alert message", preferredStyle: .alert)
            
            self.present(alert, animated: true) {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlert))
                alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            }
        }
    }
    
    @objc func dismissAlert() {
        self.dismiss(animated: true, completion: nil)
    }
}
