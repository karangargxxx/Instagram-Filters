//https://www.aegisiscblog.com/how-to-implement-custom-dropdown-list-in-swift.html
import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet var imageView: UIImageView!
    
    @IBOutlet var btnFilter: UIButton!
    @IBOutlet weak var tblFilter: UITableView! {
        didSet{
            tblFilter.dataSource = self
            tblFilter.delegate = self
        }
    }

    let context = CIContext()
    var original: UIImage!
    let filtersArray: NSMutableArray = ["Original","Sepia", "Noir", "Vintage", "Instant"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnFilter.backgroundColor = UIColor.white
        btnFilter.layer.cornerRadius = 5
        btnFilter.layer.borderWidth = 1
        btnFilter.layer.borderColor = UIColor.black.cgColor
        
        tblFilter.backgroundColor = UIColor.white
        tblFilter.layer.cornerRadius = 5
        tblFilter.layer.borderWidth = 1
        tblFilter.layer.borderColor = UIColor.black.cgColor
        
        tblFilter.isHidden = true
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "filtersCell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = filtersArray[indexPath.row] as? String
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = filtersArray.object(at: indexPath.row) as! NSString
        btnFilter.setTitle(selectedItem as String, for: .normal)
        if selectedItem.isEqual(to: "Original") {
            applyOriginal()
        }else if selectedItem.isEqual(to: "Sepia") {
            applySepia()
        }else if selectedItem.isEqual(to: "Noir") {
            applyNoir()
        }else if selectedItem.isEqual(to: "Vintage") {
            applyVintage()
        }else if selectedItem.isEqual(to: "Instant") {
            applyInstant()
        }
        tblFilter.isHidden = true
    }
    
    func applyOriginal() {
        guard let original = original else {
            return
        }
        imageView.image = original
    }
    
    @IBAction func applyFilterButtonClick(sender: AnyObject) {
        if tblFilter.isHidden == true {
            tblFilter.isHidden = false
        } else {
            tblFilter.isHidden = true
        }
    }

    func applySepia() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CISepiaTone")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        filter?.setValue(1.0, forKey: kCIInputIntensityKey)
        display(filter: filter!)
    }

    func applyNoir() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectNoir")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }

    func applyVintage() {
        if original == nil {
            return
        }

        let filter = CIFilter(name: "CIPhotoEffectProcess")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }
    
    func applyInstant() {
        if original == nil {
            return
        }
        
        let filter = CIFilter(name: "CIPhotoEffectInstant")
        filter?.setValue(CIImage(image: original), forKey: kCIInputImageKey)
        display(filter: filter!)
    }

    @IBAction func choosePhoto(_ sender: UIBarButtonItem) {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .photoLibrary
            self.navigationController?.present(picker, animated: true, completion: nil)
        }
    }
    @IBAction func savePhoto() {
        guard let image = imageView.image else {
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }

    func display(filter: CIFilter) {
        let output = filter.outputImage!
        imageView.image = UIImage(cgImage: self.context.createCGImage(output, from: output.extent)!, scale: original.scale, orientation: original.imageOrientation)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
    ) {
        self.navigationController?.dismiss(animated: true, completion: nil)
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            original = image
            btnFilter.setTitle("Add sFilter", for: .normal)
        }
    }
}
