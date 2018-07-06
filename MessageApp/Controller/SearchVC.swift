//
//  SearchVC.swift
//  MessageApp
//
//  Created by Alex Pepke on 6/30/18.
//  Copyright © 2018 Alex Pepke. All rights reserved.
//

import UIKit
import Firebase
import SwiftKeychainWrapper

class SearchVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    var searchDetail = [Search]()
    var filteredData = [Search]()
    var isSearching = false
    var detail: Search!
    var recipient: String!
    var messageId: String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
        Database.database().reference().child("users").observe(.value, with: { (snapshot) in
                if let snapshot = snapshot.children.allObjects as? [DataSnapshot]{
                    self.searchDetail.removeAll()
                    for data in snapshot{
                        if let postDict = data.value as? Dictionary <String, AnyObject> {
                            let key = data.key
                            let post = Search(userKey: key, postData: postDict)
                            self.searchDetail.append(post)
                        }
                    }
                }
                self.tableView.reloadData()
            })
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationViewContronoller = segue.destination as? MessageVC {
            destinationViewContronoller.recipient = recipient
            destinationViewContronoller.messageId = messageId
    }
    }
        func numberOfSections(in: UITableView) -> Int{
            return 1
        }
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)-> Int {
            if isSearching {
                return filteredData.count
            } else {
                return searchDetail.count
            }
        }
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let searchData: Search!
            if isSearching {
                searchData = filteredData[indexPath.row]
            } else {
                searchData = searchDetail[indexPath.row]
            }
            if let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell") as? searchCell {
                cell.configCell(searchDetail: searchData)
                return cell
            } else {
                return searchCell()
            }
        }
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
            if isSearching {
                recipient = filteredData[indexPath.row].userKey
                
            } else {
                recipient = searchDetail[indexPath.row].userKey
            }
            performSegue(withIdentifier: "toMessage", sender: nil)
        }
        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String){
            if searchBar.text == nil || searchBar.text == "" {
                isSearching = false
                view.endEditing(true)
                self.tableView.reloadData()
            } else {
                isSearching = true
                filteredData = searchDetail.filter({ $0.username == searchBar.text!})
                self.tableView.reloadData()
            }
        }
    func goBack(_ sender: AnyObject){
        dismiss(animated: true, completion: nil)
    }
}
