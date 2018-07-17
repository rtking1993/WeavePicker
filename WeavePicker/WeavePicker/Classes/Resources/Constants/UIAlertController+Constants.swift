// MARK: UIAlertController Constants

extension UIAlertController {
    func photoPermissionWarning() -> UIAlertController {
        let alert = UIAlertController(title: NSLocalizedString("Photo Permission Warning", comment: ""), message: NSLocalizedString("Go to settings and allow Weave to access photos to continue.", comment: ""), preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        alert.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: ""),
                                      style: .default, handler: { _ in
            if let appSettings = URL(string: UIApplicationOpenSettingsURLString) {
                UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
            }
        }))
        
        return alert
    }
}
