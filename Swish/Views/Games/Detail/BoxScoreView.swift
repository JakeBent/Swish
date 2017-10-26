import UIKit

class BoxScoreView: UIView {
    
    let scrollView = UIScrollView()
    
    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.pinToEdges(of: self)
    }
    
    func setup() {
        var rows: [BoxScoreRow] = [BoxScoreRow.createKey()]
        
        for _ in 0...17 {
            let row = BoxScoreRow()
            row.setup()
            rows.append(row)
        }
        
        var previousAnchor = scrollView.topAnchor
        rows.forEach { row in
            scrollView.addSubview(row)
            row.pinLeft(to: scrollView.leftAnchor)
            row.pinRight(to: scrollView.rightAnchor)
            row.pinTop(to: previousAnchor)
            row.pinHeight(toConstant: 30)
            previousAnchor = row.bottomAnchor
        }
        
        rows[rows.count - 1].pinBottom(to: scrollView.bottomAnchor)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class BoxScoreRow: UIView {
    
    var isKey = false
    var isSelected = false
    let nameLabel = Generators.makeLabel(fontSize: 12)
    let minLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let ptsLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let fgLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let fg3Label = Generators.makeLabel(fontSize: 12, align: .center)
    let ftLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let offrebLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let defrebLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let rebLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let astLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let stlLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let blkLabel = Generators.makeLabel(fontSize: 12, align: .center)
    let tovLabel = Generators.makeLabel(fontSize: 12, align: .center)
    
    var numberLabels: [UILabel] {
        return [ minLabel, ptsLabel, fgLabel, fg3Label, ftLabel, offrebLabel,
            defrebLabel, rebLabel, astLabel, stlLabel, blkLabel, tovLabel ]
    }

    init() {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        isUserInteractionEnabled = true
        
        addSubview(nameLabel)
        
        nameLabel.pinLeft(to: leftAnchor, constant: 8)
        nameLabel.pinTop(to: topAnchor)
        nameLabel.pinBottom(to: bottomAnchor)
        nameLabel.pinWidth(toConstant: 100)
        
        var previousAnchor = nameLabel.rightAnchor
        
        numberLabels.forEach { label in
            addSubview(label)
            label.pinTop(to: topAnchor)
            label.pinBottom(to: bottomAnchor)
            label.pinLeft(to: previousAnchor)
            label.pinWidth(toConstant: 34)
            previousAnchor = label.rightAnchor
        }
        tovLabel.pinRight(to: rightAnchor, constant: -8)
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rowTapped)))
    }
    
    @objc func rowTapped() {
        isSelected = !isSelected
        redraw()
    }
    
    func redraw() {
        if !isKey {
            backgroundColor = isSelected ? .lightGray : .white
        }
    }
    
    func setup() {
        nameLabel.text = "J.Benton"
        minLabel.text = "35"
        ptsLabel.text = "25"
        fgLabel.text = "8/14"
        fg3Label.text = "3/5"
        ftLabel.text = "10/14"
        offrebLabel.text = "3"
        defrebLabel.text = "12"
        rebLabel.text = "15"
        astLabel.text = "11"
        stlLabel.text = "5"
        blkLabel.text = "7"
        tovLabel.text = "11"
    }
    
    static func createKey() -> BoxScoreRow {
        let row = BoxScoreRow()
        row.isKey = true
        row.nameLabel.text = "NAME"
        row.minLabel.text = "MIN"
        row.ptsLabel.text = "PTS"
        row.fgLabel.text = "FG%"
        row.fg3Label.text = "3FG%"
        row.ftLabel.text = "FT%"
        row.offrebLabel.text = "OFF"
        row.defrebLabel.text = "DEF"
        row.rebLabel.text = "REB"
        row.astLabel.text = "AST"
        row.stlLabel.text = "STL"
        row.blkLabel.text = "BLK"
        row.tovLabel.text = "TOV"
        
        row.nameLabel.font = .mainBold(fontSize: row.nameLabel.font.pointSize)
        row.numberLabels.forEach { label in
            label.font = .mainBold(fontSize: label.font.pointSize)
        }
        
        return row
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
