/// `ConfigurableCell` is protocol that should be adopted by a `UITableViewCell`/`UICollectionViewCell`,
/// that is configured with a domain type.
///
/// Example:
/// class ProductCell: UITableViewCell, ConfigurableCell {
///
///     func configure(with product: Product) {
///         textLabel.text = product.name
///     }
///
/// }
protocol ConfigurableCell {
    // The associated type.
    associatedtype Configuration
    
    /// Configure the cell with the configuration.
    func configure(with: Configuration)
}
