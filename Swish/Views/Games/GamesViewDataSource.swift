import UIKit

class GamesViewDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    
    let title: String
    let games: [Game]
    var tapAction: ((IndexPath) -> Void)?

    init(date: Date, games: [Game]) {
        self.title = Utility.dateLabelFormatter.string(from: date)
        self.games = games
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: GameCell = tableView.dequeue()
        cell.setup(withGame: games[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 108
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tapAction?(indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
