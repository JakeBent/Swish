import UIKit

class GamesViewController: UIViewController {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(cellClass: GamesView.self)
        return collectionView
    }()
    
    var dataSource: GamesDataSource?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        title = "Games"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.pinToEdges(of: view)
        
        dataSource = GamesDataSource() { [weak self] in            
            self?.dataSource?.data.forEach { dataSource in
                dataSource.tapAction = {
                    self?.navigationController?.pushViewController(GameDetailViewController(), animated: true)
                }
            }
        }
        
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        dataSource?.refresh()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
