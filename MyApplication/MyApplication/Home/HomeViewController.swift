//
//  HomeViewController.swift
//  MyApplication
//
//  Created by NguyenHao on 4/1/20.
//  Copyright © 2020 NguyenHao. All rights reserved.
//

import UIKit

struct Player {
    let type: String
    let name: String
    let height: String
    let year: String
    
    init(type: String, name: String, height: String, year: String) {
        self.type = type
        self.name = name
        self.height = height
        self.year = year
    }
}

var dataPlayer = [Player(type: "SW", name: "Nguyễn Văn A", height: "1m7", year: "1999"),
            Player(type: "GK", name: "Nguyễn Văn B", height: "1m66", year: "2000"),
            Player(type: "CB", name: "Nguyễn Văn C", height: "1m77", year: "2001")
]

class HomeViewController: UIViewController {
    @IBOutlet weak var userTableView: UITableView!
    @IBOutlet weak var titleTopLabel: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        userTableView.reloadData()
    }
    
    override func viewDidLoad() {
        setupTableView()
        if UIDevice.current.userInterfaceIdiom == .pad { setupLayoutForIPad() }
    }
    
    func setupLayoutForIPad() {
        titleTopLabel.font = UIFont (name: "Helvetica Neue", size: 30)
    }
    
    func setupTableView() {
        let nib = UINib(nibName: "HomeViewTableViewCell", bundle: nil)
        userTableView.register(nib, forCellReuseIdentifier: "HomeViewTableViewCell")
    }
    
    @IBAction func addPlayerButton(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "HomeDetailViewController", bundle: nil)
        guard let vc = storyBoard.instantiateViewController(withIdentifier: "HomeDetailViewController") as? HomeDetailViewController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataPlayer.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeViewTableViewCell") as? HomeViewTableViewCell else { return UITableViewCell() }
        cell.config(type: dataPlayer[indexPath.row].type,
                    name: dataPlayer[indexPath.row].name,
                    height: dataPlayer[indexPath.row].height,
                    year: dataPlayer[indexPath.row].year)
        return cell
    }
}

