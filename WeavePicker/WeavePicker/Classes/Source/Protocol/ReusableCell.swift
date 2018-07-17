/// `ReusableCell` is protocol that should be adopted by a `UITableViewCell`/`UICollectionViewCell` that is reusable.
///
/// Example:
/// class ProductCell: UITableViewCell, ReusableCell {
/// }
protocol ReusableCell: class {
    // Return the reuse identifier for the cell.
    static var reuseIdentifier: String { get }
}

/// Default implementation of `ReusableCell`.
extension ReusableCell {
    static var reuseIdentifier: String {
        return String(describing: Self.self)
    }
}

/// Extension to `UITableView` for registering a `ReusableCell`.
extension UITableView {
    func register<TableViewCell: UITableViewCell>(cellClass: TableViewCell.Type) where TableViewCell: ReusableCell, TableViewCell: NibLoadable {
        register(cellClass.nib, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func register<TableViewCell: UITableViewCell>(cellClass: TableViewCell.Type) where TableViewCell: ReusableCell {
        register(cellClass.self, forCellReuseIdentifier: cellClass.reuseIdentifier)
    }
}

/// Extension to `UICollectionView` for registering a `ReusableCell`.
extension UICollectionView {
    func register<CollectionViewCell: UICollectionViewCell>(cellClass: CollectionViewCell.Type) where CollectionViewCell: ReusableCell, CollectionViewCell: NibLoadable {
        register(cellClass.nib, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
    
    func register<CollectionViewCell: UICollectionViewCell>(cellClass: CollectionViewCell.Type) where CollectionViewCell: ReusableCell {
        register(cellClass.self, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
    }
}

/// Extension to `UITableView` for dequeuing a `ReusableCell`.
extension UITableView {
    func dequeueReusableCell<TableViewCell: ReusableCell>(for indexPath: IndexPath) -> TableViewCell where TableViewCell: UITableViewCell {
        guard let cell = dequeueReusableCell(withIdentifier: TableViewCell.reuseIdentifier, for: indexPath) as? TableViewCell else {
            return TableViewCell()
        }
        
        return cell
    }
}

/// Extension to `UICollectionView` for dequeuing a `ReusableCell`.
extension UICollectionView {
    func dequeueReusableCell<CollectionViewCell: ReusableCell>(for indexPath: IndexPath) -> CollectionViewCell where CollectionViewCell: UICollectionViewCell {
        guard let cell = dequeueReusableCell(withReuseIdentifier: CollectionViewCell.reuseIdentifier, for: indexPath) as? CollectionViewCell else {
            return CollectionViewCell()
        }
        
        return cell
    }
}
