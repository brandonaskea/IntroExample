//
//  ViewController.swift
//  IntroExample
//
//  Created by Brandon Askea on 1/20/19.
//  Copyright © 2019 Brandon Askea. All rights reserved.
//

import UIKit
import CouchbaseLiteSwift

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    var episodes:[Episode] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 150
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }

    func loadData() {
        
        //Get Database
        guard let database = DatabaseManager.instance.getDatabaseWith(name: "bigbang") else { return }
        
        var query: Query!
        
        guard let text = searchBar.text else { return }
        if text.isEmpty {
            
            // Load All Episodes
            
            //Form Query
            query = QueryBuilder
            .select(SelectResult.expression(Meta.id))
            .from(DataSource.database(database))
            
        }
        else {
            
            // Load Episodes From Search Text
            
            // Create index
            do {
                let index = IndexBuilder.fullTextIndex(items: FullTextIndexItem.property("summary")).ignoreAccents(false)
                try database.createIndex(index, withName: "FTSIndex")
            } catch let error {
                print(error.localizedDescription)
            }
            
            // Form Query
            let fullTextSearch = FullTextExpression.index("FTSIndex").match("'\(text)'")
            query = QueryBuilder
            .select(SelectResult.expression(Meta.id))
            .from(DataSource.database(database))
            .where(fullTextSearch)
            
        }
        
        self.episodes.removeAll()
        
        // Perform Query
        do {
            for result in try query.execute() {
                guard let documentID = result.string(at: 0) else { continue }
                guard let document = database.document(withID: documentID) else { continue }
                guard let episode = Episode.createFrom(document) else { continue }
                self.episodes.append(episode)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        // Load Data
        tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? BigBangTableViewCell else { return UITableViewCell() }
        
        // Show Episode
        cell.configureWith(episodes[indexPath.row])
        return cell
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        loadData()
    }
}

