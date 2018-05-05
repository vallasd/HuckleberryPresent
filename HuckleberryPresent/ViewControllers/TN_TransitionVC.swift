//
//  TN_TransitionVC.swift
//  FunctionalSwift
//
//  Created by David Vallas on 4/11/18.
//  Copyright © 2018 David Vallas. All rights reserved.
//

import UIKit

class TN_TransitionVC: UIViewController {
    
    @IBOutlet weak var positionControl: UISegmentedControl!
    @IBOutlet weak var directionInControl: UISegmentedControl!
    @IBOutlet weak var directionOutControl: UISegmentedControl!
    @IBOutlet weak var fadeIn: UISwitch!
    @IBOutlet weak var fadeOut: UISwitch!
    
    @IBOutlet weak var transitionSpeedSlider: UISlider!
    @IBOutlet weak var sizeWSlider: UISlider!
    @IBOutlet weak var sizeHSlider: UISlider!
    @IBOutlet weak var startSizeWSlider: UISlider!
    @IBOutlet weak var startSizeHSlider: UISlider!
    @IBOutlet weak var endSizeWSlider: UISlider!
    @IBOutlet weak var endSizeHSlider: UISlider!
    @IBOutlet weak var colorPickerHolder: UIView!
    @IBOutlet weak var chromeAlphaSlider: UISlider!
    @IBOutlet weak var entireScreen: UISwitch!
    @IBOutlet weak var chromeDismiss: UISwitch!
    
    
    fileprivate var colorPicked: UIColor = UIColor.red
    fileprivate var transitionDelegate: HGTransDelegate?
    fileprivate weak var presentedVC: UIViewController?
    
    fileprivate var transitionSettings: HGTransitionSettings {
        let alpha = chromeAlphaSlider.value
        let c = colorPicked.components
        let color = alpha == 0 ? nil : UIColor(displayP3Red: c.red, green: c.green, blue: c.blue, alpha: CGFloat(alpha))
        let transitionSize = HGTransitionSize(start: HGSize(wFPercent: startSizeWSlider.value, hFPercent: startSizeHSlider.value),
                                               displayed: HGSize(wFPercent: sizeWSlider.value, hFPercent: sizeHSlider.value),
                                               end: HGSize(wFPercent: endSizeWSlider.value, hFPercent: endSizeHSlider.value))
        let settings =  HGTransitionSettings(position: HGLocation(position: positionControl.selectedSegmentIndex.HGPosition),
                                              directionIn: HGLocation(position: directionInControl.selectedSegmentIndex.HGPosition),
                                              directionOut: HGLocation(position: directionOutControl.selectedSegmentIndex.HGPosition),
                                              fade: HGFade(fadeIn: fadeIn.isOn, fadeOut: fadeOut.isOn),
                                              speed: transitionSpeedSlider.value.sliderSpeed,
                                              chrome: color,
                                              entireScreen: entireScreen.isOn,
                                              chromeDismiss: chromeDismiss.isOn,
                                              iphoneSize: transitionSize,
                                              ipadSize: nil)
        return settings
    }
    
    @IBAction func slidSizeW(_ sender: UISlider) {
        startSizeWSlider.value = sender.value
        endSizeWSlider.value = sender.value
    }
    
    @IBAction func slidSizeH(_ sender: UISlider) {
        startSizeHSlider.value = sender.value
        endSizeHSlider.value = sender.value
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tap)
        addColorPicker()
        updateValues()
        view.tag = 999
    }
    
    @objc func viewTapped() {
        if let vc = presentedVC {
            vc.dismiss(animated: true) {}
        } else {
            presentVC()
        }
    }
    
    fileprivate func presentVC() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: "TN_HelloWorldVC")
        transitionDelegate = HGTransDelegate(settings: transitionSettings, viewController: self)
        vc.modalPresentationStyle = .custom
        vc.transitioningDelegate = transitionDelegate
        present(vc, animated: true, completion: nil)
        presentedVC = vc
    }
    
    fileprivate func updateValues() {
        sizeWSlider.value = 0.28
        startSizeWSlider.value = 0.28
        endSizeWSlider.value = 0.28
        sizeHSlider.value = 0.05
        startSizeHSlider.value = 0.05
        endSizeHSlider.value = 0.05
        transitionSpeedSlider.value = 0.90
    }
    
    fileprivate func addColorPicker() {
        let bounds = colorPickerHolder.bounds
        let colorPicker = ChromaColorPicker(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height))
        colorPicker.delegate = self //ChromaColorPickerDelegate
        colorPicker.padding = 5
        colorPicker.stroke = 3
        colorPicker.hexLabel.textColor = UIColor.white
        colorPickerHolder.addSubview(colorPicker)
    }
    
    
}

extension TN_TransitionVC: ChromaColorPickerDelegate {
    
    func colorPickerDidChooseColor(_ colorPicker: ChromaColorPicker, color: UIColor) {
        colorPicked = color
    }
    
}
