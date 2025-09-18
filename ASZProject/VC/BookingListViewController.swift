//
//  BookingListViewController.swift
//  ASZProject
//
//  Created by Tang on 2025/9/18.
//

import UIKit

class BookingListViewController: UIViewController {
    private let tableView = UITableView()
    private var booking: Booking?
    private var dataLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadBookingData()
    }
    
    private func setupUI() {
        title = "Booking Segments"
        view.backgroundColor = .white
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // 添加刷新控制
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    @objc private func handleRefresh() {
        loadBookingData(forceRefresh: true)
    }
    
    private func loadBookingData(forceRefresh: Bool = false) {
        guard !dataLoading else { return }
        dataLoading = true
        
        BookingDataManager.shared.getBookingData(forceRefresh: forceRefresh) { [weak self] result in
            DispatchQueue.main.async {
                self?.tableView.refreshControl?.endRefreshing()
                self?.dataLoading = false
                
                switch result {
                case .success(let booking):
                    self?.booking = booking
                    self?.tableView.reloadData()
                    
                    // 打印数据到控制台
                    self?.printBookingData(booking)
                    
                case .failure(let error):
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    private func printBookingData(_ booking: Booking) {
        print("=== Booking Data ===")
        print("Ship Reference: \(booking.shipReference)")
        print("Ship Token: \(booking.shipToken)")
        print("Can Issue Ticket: \(booking.canIssueTicketChecking)")
        print("Expiry Time: \(Date(timeIntervalSince1970: TimeInterval(booking.expiryTime) ?? 0))")
        print("Duration: \(booking.duration) seconds")
        print("Number of Segments: \(booking.segments.count)")
        
        for segment in booking.segments {
            print("\nSegment ID: \(segment.id)")
            print("Origin: \(segment.originAndDestinationPair.origin.displayName) (\(segment.originAndDestinationPair.origin.code))")
            print("Destination: \(segment.originAndDestinationPair.destination.displayName) (\(segment.originAndDestinationPair.destination.code))")
        }
        print("===================\n")
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension BookingListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booking?.segments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let segment = booking?.segments[indexPath.row] else {
            cell.textLabel?.text = "Loading..."
            return cell
        }
        
        let origin = segment.originAndDestinationPair.origin
        let destination = segment.originAndDestinationPair.destination
        
        cell.textLabel?.text = "\(origin.displayName) → \(destination.displayName)"
        cell.detailTextLabel?.text = "Segment ID: \(segment.id)"
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Booking Segments"
    }
}
