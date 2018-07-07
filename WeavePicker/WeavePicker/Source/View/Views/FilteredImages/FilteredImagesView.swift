// MARK: FilteredImagesViewDelegate

protocol FilteredImagesViewDelegate: class {
    func filteredImagesView(_ filteredImagesView: FilteredImagesView, didSelect image: Image)
}

// MARK: FilteredImagesView

class FilteredImagesView: View {
    
    // MARK: Delegate
    
    weak var delegate: FilteredImagesViewDelegate?
    
    // MARK: Outlets
    
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var pageControl: UIPageControl!
    
    // MARK: Variables
    
    var images: [Image] = [] {
        didSet {
            refreshCollectionView()
        }
    }
    
    // MARK: View Methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        registerCells()
    }
    
    // MARK: Configure Methods
    
    func configure(with images: [Image]) {
        self.images = images
        pageControl.numberOfPages = images.count
    }
    
    func imageAdjusted(_ image: Image?) {
        guard let image = image else {
            return
        }
        
        images[pageControl.currentPage] = image
    }
    
    // MARK: Action Methods
    
    @IBAction func pageControlTap(_ sender: Any?) {
        guard let pageControl: UIPageControl = sender as? UIPageControl else {
            return
        }
        
        collectionView.scrollToItem(at: IndexPath(row: pageControl.currentPage, section: 0), at: .left, animated: true)
    }
    
    // MARK: Helper Methods
    
    func invalidateLayout() {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    private func registerCells() {
        collectionView.register(cellClass: ImageCell.self)
    }
    
    private func refreshCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

// MARK: UICollectionViewDelegate, UICollectionViewDataSource Methods

extension FilteredImagesView: UICollectionViewDelegate, UICollectionViewDataSource {
    @objc func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCell = collectionView.dequeueReusableCell(for: indexPath)
        let image = images[indexPath.row]
        cell.configure(with: image)
        return cell
    }
}

// MARK: UICollectionViewDelegateFlowLayout Methods

extension FilteredImagesView: UICollectionViewDelegateFlowLayout {
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.frame.width
        return CGSize(width: width, height: width)
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

// MARK: UIScrollViewDelegate Methods

extension FilteredImagesView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth: CGFloat = scrollView.frame.width
        let currentPage: CGFloat = floor((scrollView.contentOffset.x-pageWidth/2)/pageWidth)+1
        let currentPageIndex: Int = Int(currentPage)
        pageControl.currentPage = currentPageIndex
        delegate?.filteredImagesView(self, didSelect: images[currentPageIndex])
    }
}
