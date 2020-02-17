import UIKit

class GamesViewController: UIViewController {

    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(cellClass: GamesView.self)
        return collectionView
    }()
    private let header = CutoutTabHeader(initialColor: .red)
    private var views: [UIView] {
        return [header, collectionView]
    }
    
    var dataSource: GamesDataSource?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        tabBarItem = UITabBarItem(tabBarSystemItem: .featured, tag: 1)
        title = "Games"
        view.backgroundColor = .white
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        views.forEach { view in
            self.view.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        header.pinTop(to: view.topAnchor)
        header.pinLeft(to: view.leftAnchor)
        header.pinRight(to: view.rightAnchor)
        header.pinHeight(toConstant: 50)

        collectionView.pinTop(to: header.bottomAnchor)
        collectionView.pinLeft(to: view.leftAnchor)
        collectionView.pinRight(to: view.rightAnchor)
        collectionView.pinBottom(to: view.bottomAnchor)
        
        setLoading(true)
        
        dataSource = GamesDataSource(self, header: header, collectionView: collectionView) { [weak self] in
            self?.setLoading(false)
            self?.dataSource?.data.forEach { dataSource in
                dataSource.tapAction = { indexPath in
                    let game = dataSource.games[indexPath.row]
                    self?.navigationController?.pushViewController(GameDetailViewController(game: game), animated: true)
                }
            }
        }
        
        collectionView.dataSource = dataSource
        collectionView.delegate = dataSource
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
