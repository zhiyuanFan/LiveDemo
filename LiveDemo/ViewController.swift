//
//  ViewController.swift
//  TestIjkplayerSDK
//
//  Created by Jason Fan on 2018/7/23.
//  Copyright © 2018 zyFan. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var navTableView: UITableView!
    var screenW: CGFloat {
        return UIScreen.main.bounds.size.width
    }
    var screenH: CGFloat {
        return UIScreen.main.bounds.size.height
    }
    var cellTitle: [String] {
        return ["Pull Stream", "Push Stream"]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Live"
        
        navTableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenW, height: screenH - 64))
        navTableView.delegate = self
        navTableView.dataSource = self
        navTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
        view.addSubview(navTableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellTitle.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellId")!
        cell.textLabel?.text = cellTitle[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let pullVC = PullStreamViewController()
            self.navigationController?.pushViewController(pullVC, animated: true)
        } else {
            let pushVC = PushStreamViewController()
            self.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
    
}

