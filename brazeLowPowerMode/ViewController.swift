//
//  ViewController.swift
//  brazeLowPowerMode
//
//  Created by Nigel Faustino on 12/28/22.
//

import UIKit

import BrazeKit
import BrazeUI

final class ViewController: UIViewController {
    private var label: UILabel = UILabel()
    private var label2: UILabel = UILabel()
    private var counter: Int = 0
    private var brazeLaunch: UIButton = UIButton()
    static var braze: Braze? = nil
    private var navController: UINavigationController = UINavigationController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        label = UILabel.init()
        label.numberOfLines = 0
        label.backgroundColor = .yellow
        label.textColor = .black
        label.font = .systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        label2 = UILabel.init()
        label2.numberOfLines = 0
        label2.backgroundColor = .yellow
        label2.textColor = .black
        label2.font = .systemFont(ofSize: 14)
        label2.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label2)
        
        brazeLaunch = UIButton()
        brazeLaunch.translatesAutoresizingMaskIntoConstraints = false
        brazeLaunch.setTitle("Launch Braze", for: .normal)
        brazeLaunch.setTitleColor(.black, for: .normal)
        brazeLaunch.addTarget(self, action: #selector(self.launchBrazeSDK), for: .touchUpInside)
        brazeLaunch.backgroundColor = .yellow
        view.addSubview(brazeLaunch)
        
        NSLayoutConstraint.activate([
                label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -200),
                label.widthAnchor.constraint(equalToConstant: 300),
                label.heightAnchor.constraint(equalToConstant: 150)])
        
        NSLayoutConstraint.activate([
                label2.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                label2.centerYAnchor.constraint(equalTo: label.centerYAnchor, constant: 200),
                label2.widthAnchor.constraint(equalToConstant: 300),
                label.heightAnchor.constraint(equalToConstant: 150)])
        
        NSLayoutConstraint.activate([
                brazeLaunch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                brazeLaunch.centerYAnchor.constraint(equalTo: label2.centerYAnchor, constant: 200),
                brazeLaunch.widthAnchor.constraint(equalToConstant: 150),
                brazeLaunch.heightAnchor.constraint(equalToConstant: 70)])
        
        self.label.text = "The value for low power mode is \(ProcessInfo.processInfo.isLowPowerModeEnabled)"
        
        self.label2.text = "The app becomes active is getting called \(counter) times."
        
        NotificationCenter.default.addObserver(self, selector: #selector(deviceLowPowerModeChanged), name: NSNotification.Name.NSProcessInfoPowerStateDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appHasBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        initializeBrazeSDK()
    }

    @objc func appHasBecomeActive() {
        counter += 1
        self.label.text = DeviceHelper.shared.labelText
        self.label2.text = "The app becomes active is getting called \(counter) times."
    }
    
    @objc func deviceLowPowerModeChanged() {
        DispatchQueue.main.async {
            print("The value for low power mode is \(ProcessInfo.processInfo.isLowPowerModeEnabled)")
            self.label.text = "The value for low power mode is \(ProcessInfo.processInfo.isLowPowerModeEnabled)"
        }
    }
    
    func initializeBrazeSDK() {
//        let configuration = Braze.Configuration(apiKey: brazeApiKey, endpoint: brazeEndpoint)
//        configuration.logger.level = .info
//        ViewController.braze = Braze(configuration: configuration)
    }
    
    @objc func launchBrazeSDK() {
        let readmeViewController = ReadmeViewController(readme: readme, actions: actions)
        navController = UINavigationController.init(rootViewController: readmeViewController)
        self.present(navController, animated: true)
    }
}


final class DeviceHelper {
    public private(set) static var shared = DeviceHelper()
    public var labelText: String = ""
    
    private init() {
        NotificationCenter.default.addObserver(self, selector: #selector(deviceLowPowerModeChanged1), name: NSNotification.Name.NSProcessInfoPowerStateDidChange, object: nil)
    }
    
    @objc func deviceLowPowerModeChanged1() {
        labelText = "The value for low power mode is \(ProcessInfo.processInfo.isLowPowerModeEnabled)"
    }
}


