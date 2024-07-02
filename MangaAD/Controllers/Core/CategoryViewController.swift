//
//  CategoryViewController.swift
//  MangaAD
//
//  Created by Nguyễn Tuấn Dũng on 8/6/24.
//

import UIKit
import FirebaseDatabase

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var categories: [Category] = []

    let tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        // Thiết lập giao diện
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Đăng ký cell và thiết lập dataSource, delegate
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        
        // Tải dữ liệu từ Firebase
        loadCategories()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Kiểm tra xem có hàng nào được chọn không và bỏ chọn nó
        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func loadCategories() {
        let ref = Database.database().reference(withPath: "Category")
        ref.observe(.value) { snapshot in
            var newCategories: [Category] = []
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                   let value = snapshot.value as? [String: Any],
                   let tag = value["tag"] as? String {
                    let category = Category(tag: tag)
                    newCategories.append(category)
                }
            }
            self.categories = newCategories
            self.tableView.reloadData()
        }
    }

    // MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = categories[indexPath.row].tag
        cell.textLabel?.textColor = .white
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        cell.backgroundColor = UIColor(red: 0x0B / 255.0, green: 0x0F / 255.0, blue: 0x2F / 255.0, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCategory = categories[indexPath.row].tag
        let mangaCollectionVC = MangaCollectionViewController(collectionViewLayout: UICollectionViewFlowLayout())
        mangaCollectionVC.selectedCategory = selectedCategory
        navigationController?.pushViewController(mangaCollectionVC, animated: true)
    }

    // MARK: - UITableViewDelegate

    // Các phương thức delegate khác nếu cần thiết

}

