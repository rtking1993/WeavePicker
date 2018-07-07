// MARK: AlbumPickerPresenterDelegate

protocol AlbumPickerPresenterDelegate: class {
    func albumPickerPresenter(_ albumPickerPresenter: AlbumPickerPresenter, show albums: [Album])
}

// MARK: AlbumPickerPresenter

class AlbumPickerPresenter {
    
    // MARK: Delegate
    
    weak var delegate: AlbumPickerPresenterDelegate?
    
    // MARK: Variables
    
    var albumPickerInteractor: AlbumPickerInteractor
    
    // MARK: Init Methods
    
    init() {
        albumPickerInteractor = AlbumPickerInteractor()
        albumPickerInteractor.delegate = self
    }
}

// MARK: AlbumPickerInteractorDelegate

extension AlbumPickerPresenter: AlbumPickerInteractorDelegate {
    func albumPickerInteractor(_ albumPickerInteractor: AlbumPickerInteractor, didObserve albums: [Album]) {
        delegate?.albumPickerPresenter(self, show: albums)
    }
}
