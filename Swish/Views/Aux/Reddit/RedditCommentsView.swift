import UIKit

class RedditCommentsView: UITableView {
    
    let source = RedditCommentsDataSource()
    lazy var spinner: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    init() {
        super.init(frame: .zero, style: .plain)
        translatesAutoresizingMaskIntoConstraints = false
        estimatedRowHeight = 200
        backgroundColor = .white
        separatorStyle = .none
        allowsSelection = false
        register(cellClass: CommentContainerCell.self)
        source.didFinishLoading = { [weak self] in
            self?.reloadData()
            self?.spinner.endRefreshing()
        }
        refreshControl = spinner
        
        dataSource = source
    }
    
    @objc func refresh() {
        source.refresh()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class RedditCommentsDataSource: NSObject, UITableViewDataSource {

    var comments: [Comment] = []
    var didFinishLoading: (() -> Void)?
    
    func refresh() {
        RedditService.shared.fetchComments(path: "") { [weak self] err, comments in
            self?.comments = comments
            self?.didFinishLoading?()
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: CommentContainerCell = tableView.dequeue()
        cell.setup(with: comments[indexPath.row], tableView: tableView)
        return cell
    }
}
