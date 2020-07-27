//
//  ViewController.swift
//  ListView
//
//  Created by Piyush Kachariya on 7/27/20.
//  Copyright © 2020 Kachariya. All rights reserved.
//

import UIKit
import IHProgressHUD
import Toast_Swift
import Reachability
import Alamofire

class ViewController: UIViewController {

    var topHeaderView: UIView!
    var titleLabel: UILabel!
    var tableViewList: UITableView!
    var reach: Reachability?

    var array_data_list = [AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        checkInterConnection()

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
        
        // Call API to get data
        getDataAPI()
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
    
    func checkInterConnection() {
        
        // Allocate a reachability object
        self.reach = Reachability.forInternetConnection()
        
        // Tell the reachability that we DON'T want to be reachable on 3G/EDGE/CDMA
        self.reach!.reachableOnWWAN = false
        
        // Here we set up a NSNotification observer. The Reachability that caused the notification
        // is passed in the object parameter
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged),
            name: NSNotification.Name.reachabilityChanged,
            object: nil
        )
        
        self.reach!.startNotifier()
        
    }
    
    @objc func reachabilityChanged(notification: NSNotification) {
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            print("Service available!!!")
        } else {
            print("No service available!!!")
            self.view.makeToast("Internet Connection Problem!", duration: 1.0, position: .bottom)
        }
    }
    
    //MARK: - API calling methods
    
    func isInterntAvailable() -> Bool {
        
        if self.reach!.isReachableViaWiFi() || self.reach!.isReachableViaWWAN() {
            print("Service available!!!")
            return true
        } else {
            print("No service available!!!")
            return false
        }
    }
    
    func getDataAPI() {
        
        if (!isInterntAvailable()) {
            self.view.makeToast("Internet Connection Problem!", duration: 1.0, position: .bottom)
            return
        }
        
        IHProgressHUD.show(withStatus: "Loading...")
        
        guard let api_url = URL(string: "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master/challenge.json") else {return}
        
        var request = URLRequest(url: api_url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        AF.request(request).responseJSON{ (response) in
            
            if response.data != nil {
                
                print("Result PUT Request:")
                                
                switch response.result
                {
                    
                case .success(let value):
                    
                    let array_temp = value as! NSArray

                    for i in (0..<array_temp.count)
                    {
                        let temp_obj = array_temp[i] as! NSDictionary
                        self.array_data_list.append(temp_obj)
                    }
                    print("array count \(self.array_data_list.count)")
                    self.tableViewList.reloadData()
                    IHProgressHUD.dismiss()
                case .failure(let error):
                    print(error)
                }
            }else{
                
            }
        }
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.array_data_list.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let temp_obj = self.array_data_list[indexPath.row] as! NSDictionary
        let type = temp_obj.value(forKey: "type") as! String
        if type == "image" {
            return 100
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableViewList.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! ListViewCell
        
        let temp_obj = self.array_data_list[indexPath.row] as! NSDictionary

        let id = temp_obj.value(forKey: "id") as! String
        let type = temp_obj.value(forKey: "type") as! String
        
        var data = ""
        
        if let val = temp_obj.value(forKey: "data") {
            if temp_obj.value(forKey: "data") != nil {
                data = val as! String
            }
        }
        

        cell.label.text = id + ". " + type.capitalized
        cell.selectionStyle = .none
        
        if type == "image" {
            cell.imageView?.isHidden = false
            cell.label?.isHidden = true
            
            if data == "" {

            } else {
                let url = URL(string: data)
                
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url!)
                    DispatchQueue.main.async {
                        cell.imgview.image = UIImage(data: data!)
                    }
                }
            }
        } else {
            cell.imageView?.isHidden = true
            cell.label?.isHidden = false
        }
        return cell
    }
    

}

