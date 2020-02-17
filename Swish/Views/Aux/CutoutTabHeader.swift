import UIKit

@objc protocol CutoutTabHeaderDelegate: class {
    func numberOfTabs() -> Int
    func titleForTab(index: Int) -> String
    @objc optional func colorForTab(index: Int) -> UIColor
    @objc optional func didTapTab(index: Int, completion: ((Bool) -> Void)?)
    @objc optional var fullPageScrollView: UIScrollView? { get }
}

class CutoutTabHeader: UIScrollView {

    static let tabHeight = Layout.marginStandard * 4
    static let createView: (UIColor) -> UIView = { color in
        let view = UIView()
        view.backgroundColor = color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }

    weak var tabDelegate: CutoutTabHeaderDelegate? {
        didSet {
            reloadData()
        }
    }

    var initialColor: UIColor
    var unselectedColor: UIColor
    var font: UIFont
    var currentPage: Int = 1
    var isScrollingForSelection = false
    private var titles: [String] = []
    private var buttons: [UIImageView] = []
    private var colors: [(red: CGFloat, green: CGFloat, blue: CGFloat)] = []
    private var tabWidth: CGFloat {
        return (Layout.viewWidth / CGFloat(titles.count))
            .keepBetween(min: Layout.minTabWidth, max: Layout.viewWidth / 2)
    }

    private lazy var headerBackground = CutoutTabHeader.createView(unselectedColor)
    private lazy var headerSlider = CutoutTabHeader.createView(initialColor)
    private var headerSliderLeftConstraint: NSLayoutConstraint!
    private var headerSliderWidthConstraint: NSLayoutConstraint!
    private var views: [UIView] {
        return [headerBackground, headerSlider]
    }
    
    init(initialColor: UIColor = .black, unselectedColor: UIColor = UIColor(white: 0.85, alpha: 1), font: UIFont = .boldSystemFont(ofSize: 14)) {
        self.initialColor = initialColor
        self.unselectedColor = unselectedColor
        self.font = font
        super.init(frame: .zero)

        setup()
    }

    func setup() {
        clipsToBounds = false
        translatesAutoresizingMaskIntoConstraints = false
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = .white
        headerSlider.backgroundColor = initialColor

        views.forEach { view in
            addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
        }

        headerSlider.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerSlider.heightAnchor.constraint(equalTo: heightAnchor).isActive = true
        headerSliderWidthConstraint = headerSlider.widthAnchor.constraint(equalToConstant: 0)
        headerSliderWidthConstraint.isActive = true
        headerSliderLeftConstraint = headerSlider.leftAnchor.constraint(equalTo: leftAnchor)
        headerSliderLeftConstraint.isActive = true

        headerBackground.leftAnchor.constraint(equalTo: leftAnchor, constant: Layout.marginMedium).isActive = true
        headerBackground.rightAnchor.constraint(equalTo: rightAnchor, constant: -Layout.marginMedium).isActive = true
        headerBackground.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        headerBackground.heightAnchor.constraint(equalToConstant: Layout.marginStandard * 2).isActive = true
    }

    func reloadData() {
        guard let tabDelegate = tabDelegate else { return }

        var constraintsToRemove: [NSLayoutConstraint] = []
        constraints.forEach { constraint in
            buttons.forEach { button in
                if constraint.firstItem === button || constraint.secondItem === button {
                    constraintsToRemove.append(constraint)
                }
            }
        }
        removeConstraints(constraintsToRemove)
        buttons.forEach { $0.removeFromSuperview() }

        let numberOfTabs = tabDelegate.numberOfTabs()
        titles = []
        colors = []
        buttons = []

        (0..<numberOfTabs).forEach { index in
            titles.append(tabDelegate.titleForTab(index: index))
            colors.append(tabDelegate.colorForTab?(index: index).rgb ?? initialColor.rgb)
            buttons.append(
                CutoutTabHeaderCell(
                    text: titles[index],
                    numTitles: numberOfTabs,
                    font: font
                ) ?? UIImageView()
            )
        }

        var previousAnchor: NSLayoutAnchor = leftAnchor
        buttons.forEach { button in
            button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedButton(sender:))))
            addSubview(button)
            button.topAnchor.constraint(equalTo: topAnchor).isActive = true
            button.bottomAnchor.constraint(equalTo: headerSlider.bottomAnchor, constant: -Layout.marginSmall).isActive = true
            button.widthAnchor.constraint(equalToConstant: tabWidth + 1).isActive = true
            button.leftAnchor.constraint(equalTo: previousAnchor, constant: -1).isActive = true
            previousAnchor = button.rightAnchor
        }
        previousAnchor.constraint(equalTo: rightAnchor).isActive = true

        headerSliderWidthConstraint.constant = tabWidth
    }

    @objc func tappedButton(sender: UITapGestureRecognizer) {
        guard let button = sender.view as? UIImageView else { return }
        let index = buttons.firstIndex(of: button) ?? 0

        isScrollingForSelection = true
        headerSliderLeftConstraint.constant = headerSliderOffset(for: tabDelegate?.fullPageScrollView!, offset: CGPoint(x: Layout.viewWidth * CGFloat(index), y: 0))
        UIView.animate(withDuration: 0.2, animations: { [weak self] in
            self?.layoutIfNeeded()
        })
        tabDelegate?.didTapTab?(index: index) { [weak self] scrollView in
            self?.isScrollingForSelection = false
        }
    }

    func fullPageViewDidScroll(_ scrollView: UIScrollView) -> UIColor {
        let headerOffset = headerSliderOffset(for: scrollView)

        if !isScrollingForSelection {
            headerSliderLeftConstraint.constant = headerOffset
        }

        currentPage = Int(floor((scrollView.contentOffset.x + Layout.viewWidth) / Layout.viewWidth))
            .keepBetween(min: 1, max: titles.count - 1)

        let leftColor = colors[currentPage - 1]
        let rightColor = colors[currentPage]

        let maxRedDelta = rightColor.red - leftColor.red
        let maxGreenDelta = rightColor.green - leftColor.green
        let maxBlueDelta = rightColor.blue - leftColor.blue

        let percentage = (scrollView.contentOffset.x / Layout.viewWidth) - CGFloat(currentPage - 1)

        let color = UIColor(
            red: percentage * maxRedDelta + leftColor.red,
            green: percentage * maxGreenDelta + leftColor.green,
            blue: percentage * maxBlueDelta + leftColor.blue,
            alpha: 1
        )
        headerSlider.backgroundColor = color

        if headerOffset < (Layout.viewWidth / 2) - (tabWidth / 2) {
            contentOffset = CGPoint(x: 0, y: 0)
        } else if headerOffset < contentSize.width - (Layout.viewWidth / 2) - (tabWidth / 2) {
            contentOffset = CGPoint(x: abs((Layout.viewWidth / 2) - (tabWidth / 2) - headerOffset), y: 0)
        } else {
            contentOffset = CGPoint(x: contentSize.width - frame.width, y: 0)
        }

//        print("scrollViewOffset: ", scrollView.contentOffset)
//        print("numberOfTabs: ", numberOfTabs)
//        print("maxOffset: ", maxOffset)
//        print("headerOffsetPercentage: ", headerOffsetPercentage)
//        print("headerOffset: ", headerOffset)
//        print("currentPage: ", currentPage)
//        print("leftColor: ", leftColor)
//        print("rightColor: ", rightColor)
//        print("maxRedDelta: ", maxRedDelta)
//        print("maxGreenDelta: ", maxGreenDelta)
//        print("maxBlueDelta: ", maxBlueDelta)
//        print("percentage: ", percentage)
//        print("color: ", color)
//        print("\n\n")

        return UIColor.red//color
    }

    func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: nil) { _ in
            self.reloadData()
        }
    }

    private func headerSliderOffset(for scrollView: UIScrollView?, offset: CGPoint? = nil) -> CGFloat {
        guard let scrollView = scrollView else { return 0 }
        let offset = offset ?? scrollView.contentOffset
        let numberOfTabs = CGFloat(titles.count)
        let maxOffset = (tabWidth * numberOfTabs) - tabWidth
        let headerOffsetPercentage = (offset.x / scrollView.contentSize.width)
        return contentSize.width * headerOffsetPercentage
            .keepBetween(min: 0, max: maxOffset)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


