import UIKit

class GamesDataSource: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, CutoutTabHeaderDelegate {
    
    var data: [GamesViewDataSource] = [] {
        didSet {
            collectionView?.reloadData()
            header?.tabDelegate = self
        }
    }
    
    weak var parent: GamesViewController?
    weak var header: CutoutTabHeader?
    weak var collectionView: UICollectionView?
    var didFinishLoading: (() -> Void)?
    var todayIndex = 0
    
    var fullPageScrollView: UIScrollView? { return collectionView }
    
    init(_ parent: GamesViewController, header: CutoutTabHeader, collectionView: UICollectionView, didFinishLoading: (() -> Void)?) {
        super.init()
        self.didFinishLoading = didFinishLoading
        self.collectionView = collectionView
        self.header = header
        self.parent = parent
        
        NBAService.shared.getSeasonGames(progress: { progress in
            DispatchQueue.main.async { [weak self] in
                self?.parent?.view.setProgress(progress)
            }
        }) { [weak self] err, games in
            var hasGamesToday = false
            let sortedKeys = Array(games.keys).sorted(by: <)
            self?.data = sortedKeys.enumerated().map { index, key in
                if Utility.dateLabelFormatter.string(from: key) == Utility.dateLabelFormatter.string(from: Date()) {
                    self?.todayIndex = index
                    hasGamesToday = true
                }
                return GamesViewDataSource(date: key, games: games[key] ?? [])
            }
            
            let index = hasGamesToday ? self?.todayIndex : sortedKeys.firstIndex(where: { $0.timeIntervalSinceNow > 0 }) as Int?

            if let collectionView = self?.collectionView {
                UIView.animate(withDuration: 0.1, animations: {
                    let offset = CGPoint(x: CGFloat(index ?? 0) * Layout.viewWidth, y: 0)
                    collectionView.contentOffset = offset
                }) { _ in
                    _ = self?.header?.fullPageViewDidScroll(collectionView)
                }
            }
            
            self?.didFinishLoading?()
        }
    }
    
    func refresh() {
        self.didFinishLoading?()
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: GamesView = collectionView.dequeue(indexPath: indexPath)
        cell.dataSource = data[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return collectionView.frame.size
    }
    
    func numberOfTabs() -> Int {
        return data.count
    }

    func titleForTab(index: Int) -> String {
        return data[index].title
    }

    func colorForTab(index: Int) -> UIColor {
        return .main
    }

    func didTapTab(index: Int, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.3, animations: { [weak self] in
            self?.collectionView?.contentOffset = CGPoint(x: CGFloat(index) * Layout.viewWidth, y: 0)
        }, completion: completion)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        _ = header?.fullPageViewDidScroll(scrollView)
    }
}
