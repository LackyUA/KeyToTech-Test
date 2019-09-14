//
//  CommentsViewController.swift
//  KeyToTech-Test
//
//  Created by Dima Dobrovolskyy on 9/13/19.
//  Copyright © 2019 Dima Dobrovolskyy. All rights reserved.
//

import UIKit

final class CommentsViewController: UIViewController {

    private let step = 10
    
    // MARK: - Properties
    
    private var backButton = UIBarButtonItem()
    private var displayedComments = [Comment]()
    private var comments = [Comment]() {
        didSet {
            if bounds.upper > comments.count {
                bounds.upper = comments.count
            }
        }
    }
    
    /// Flag to determine the need for display loading cell.
    private var shouldShowLoadingCell = false
    
    /// Array of dynamic cell heights to prevent jumping.
    private var cellHeights = [CGFloat]()
    
    /// Max count of comment to display.
    private var limit = Int()
    
    /// Inputed bounds.
    var bounds: (lower: Int, upper: Int)! {
        didSet {
            self.limit = self.bounds.lower
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: 23, height: 8))
            self.tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 23, height: 8))
            
            self.tableView.register(
                UINib(nibName: String(describing: CommentCell.self), bundle: nil),
                forCellReuseIdentifier: String(describing: CommentCell.self)
            )
            
            self.tableView.register(
                UINib(nibName: String(describing: ActivityIndicatorCell.self), bundle: nil),
                forCellReuseIdentifier: String(describing: ActivityIndicatorCell.self)
            )
        }
    }
    
    // MARK: - Actions
    
    @objc private func backButtonTapped() {
        self.dismiss(animated: true)
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        fetchComments()
    }
    
    // MARK: - UI configuration
    
    /// Initial configurations
    private func configure() {
        configureNavigationBar()
    }

    /// Method for configuration navigation bar appearance
    private func configureNavigationBar() {
        backButton = UIBarButtonItem(
            title: "Back",
            style: .done,
            target: self,
            action: #selector(backButtonTapped)
        )
        
        backButton.tintColor = .darkBlue()
        
        navigationItem.leftBarButtonItem = backButton
        navigationItem.title = "Comments"
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkBlue()]
        navigationController?.navigationBar.isTranslucent = false
    }
    
    // MARK: - Networking
    
    /// Method for fetching comments from server.
    func fetchComments() {
        CommentsService.shared.fetchComments { [weak self] response in
            guard let self = self else { return }
            switch response {
            case .success(let result):
                self.comments = result
                if result.count > self.bounds.lower {
                    self.displayNewComments()
                }
                
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.showAlert(with: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    /// Method for displaying networking error.
    private func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Infinity scroll helpers
    
    /// Method for taking 10 next comments and display them in table view.
    private func displayNewComments() {
        DispatchQueue.main.async {
            self.shouldShowLoadingCell = true
            self.tableView.reloadSections(IndexSet(arrayLiteral: 1), with: .none)
        }
    
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let lastTaken = self.limit
            
            if self.limit + self.step > self.bounds.upper {
                self.limit = self.bounds.upper
                self.addComments(fromRange: lastTaken..<self.limit + 1)
            } else {
                self.limit += self.step
                self.addComments(fromRange: lastTaken..<self.limit)
            }
            
            self.shouldShowLoadingCell = false
            
            self.tableView.reloadData()
        }
    }
    
    /// Method for calculating last displayed comment
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        guard limit < bounds.upper else { return false }
        
        return indexPath.row == displayedComments.count - 1
    }
    
    /// Method for adding new comments to displayComments array.
    private func addComments(fromRange range: Range<Int>) {
        for index in range {
            if !self.displayedComments.contains(self.comments[index - 1]) {
                self.displayedComments.append(self.comments[index - 1])
            }
        }
    }
    
}

// MARK: - Table view data source

extension CommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0, !(bounds.lower > comments.count) {
            return displayedComments.count
        } else if section == 1, shouldShowLoadingCell {
            return 1
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: CommentCell.self), for: indexPath) as? CommentCell else { return UITableViewCell() }
            
            cell.configure(with: displayedComments[indexPath.row])
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ActivityIndicatorCell.self), for: indexPath)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row > cellHeights.count - 1 {
            cellHeights.append(cell.bounds.height)
        } else {
            cellHeights[indexPath.row] = cell.bounds.height
        }
        
        guard isLoadingIndexPath(indexPath) else { return }
        
        self.displayNewComments()
    }
    
}

// MARK: - Table view delegate

extension CommentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 {
            return 44
        }
        
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < cellHeights.count - 1 {
            return cellHeights[indexPath.row]
        }
        
        return 100
    }
    
}
