//
//  SearchTableViewController.swift
//  ChuckFirst
//
//  Created by Олеся on 06.01.2023.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate {

    var jokesArray: [String] = []
     var searchwindow = UISearchController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = searchwindow
        searchwindow.searchBar.delegate = self
}
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar){
        guard let searchText = searchBar.text, searchText.count >= 3  else {
            jokesArray = ["Search word must contains 3 or more letters"]
            tableView.reloadData()
            return
        }
        
        
        
            Model().downloadJokesList(queryText: searchText) { [weak self] jokesArray in
                DispatchQueue.main.async {
                    let joAR = jokesArray ?? []
                    if joAR.count  > 0 {
                        self?.jokesArray = jokesArray ?? []
                    } else {
                        self?.jokesArray = ["EMMPPTTYYNNEESS....try another word"]
                    }
                self?.tableView.reloadData()
            }
        }
    }
    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return jokesArray.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)

        let jokeText = jokesArray[indexPath.row]
        cell.textLabel?.text = jokeText
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let textJoke = tableView.cellForRow(at: indexPath)?.textLabel?.text else { print("text joke is emty")
            return
            
        }
        var activityControoller = UIActivityViewController(activityItems: [textJoke], applicationActivities: nil)
        present(activityControoller, animated: true)
    }
}
