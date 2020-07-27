//
//  ViewController.swift
//  ListView
//
//  Created by Piyush Kachariya on 7/27/20.
//  Copyright © 2020 Kachariya. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var topHeaderView: UIView!
    var titleLabel: UILabel!
    var tableViewList: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupViews()
        
        let frame = self.view.frame
        tableViewList = UITableView(frame: frame, style: .plain)
        self.view.addSubview(tableViewList)
        
        tableViewList.translatesAutoresizingMaskIntoConstraints = false
        tableViewList.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableViewList.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableViewList.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableViewList.topAnchor.constraint(equalTo: topHeaderView.bottomAnchor).isActive = true
    
        tableViewList.register(ListViewCell.self, forCellReuseIdentifier: "tableCell")
        tableViewList.dataSource = self
        tableViewList.delegate = self
    }


    private func setupViews() {
        
        // Create view and add it into view controller
        topHeaderView = UIView()
        topHeaderView.backgroundColor = .white
        self.view.addSubview(topHeaderView)
                
        // Create title for view
        titleLabel = UILabel()
        titleLabel.text = "List View"
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont(name: titleLabel.font.fontName, size: 20)
        topHeaderView.addSubview(titleLabel)
        
        // Set position of views using constraints
        topHeaderView.translatesAutoresizingMaskIntoConstraints = false
        topHeaderView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        topHeaderView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        topHeaderView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 1).isActive = true
        topHeaderView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.1).isActive = true
        
        // Set position of title inside topHeaderView
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.centerXAnchor.constraint(equalTo: topHeaderView.centerXAnchor).isActive = true
        titleLabel.bottomAnchor.constraint(equalTo: topHeaderView.bottomAnchor).isActive = true
        titleLabel.widthAnchor.constraint(equalTo: topHeaderView.widthAnchor, multiplier: 0.4).isActive = true
        titleLabel.heightAnchor.constraint(equalTo: topHeaderView.heightAnchor, multiplier: 0.5).isActive = true
        
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewList.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ListViewCell
        cell.label.text = "Help \(indexPath.row)"
        return cell
    }
    

}

