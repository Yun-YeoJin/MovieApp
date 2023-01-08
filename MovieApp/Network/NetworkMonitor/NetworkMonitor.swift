//
//  NetworkMonitor.swift
//  MovieApp
//
//  Created by 윤여진 on 2022/12/27.
//

import UIKit
import Network

final class NetworkMonitor {
    
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    
    public private(set) var isConnected: Bool = false
    public private(set) var connectionType: ConnectionType = .unknown
    
    enum ConnectionType {
        case wifi
        case cellular
        case ethernet
        case unknown
    }
    
    private init() {
        monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else {return}
            
            self.isConnected = path.status == .satisfied
            if #available(iOS 13.0, *) {
                if self.isConnected == false {
                    DispatchQueue.main.async {
                        guard let viewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController?.topViewController else { return }
                        viewController.present(self.showNetworkAlert(), animated: true)
                    }
                }
            } else {
                print(#function, "Networking off")
            }
        }
    }
    
    public func stopMonitoring(){
        monitor.cancel()
    }
    
    private func getConenctionType(_ path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
            print("wifi에 연결")
            
        } else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
            print("cellular에 연결")
            
        } else if path.usesInterfaceType(.wiredEthernet) {
            connectionType = .ethernet
            print("wiredEthernet에 연결")
            
        } else {
            connectionType = .unknown
            print("unknown ..")
        }
    }
    
    private func showNetworkAlert() -> UIAlertController {
        
        let alert = UIAlertController(title: "인터넷 연결이 원할하지 않습니다.", message: "wifi 또는 셀룰러를 활성화 해주세요.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
            guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        [ok, cancel].forEach {
            alert.addAction($0)
        }
        
        return alert
        
    }
}
