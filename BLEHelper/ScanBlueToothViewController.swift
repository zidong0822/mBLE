//
//  ViewController.swift
//  BLEHelper
//
//  Created by Microduino on 11/4/15.
//  Copyright © 2015 Microduino. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScanBlueToothViewController: UIViewController{

    var bleMingle: BLEHelper!
    var perital:CBPeripheral!
    var tableView : UITableView?
    
    //保存收到的蓝牙设备
    var deviceList:NSMutableArray = NSMutableArray()
    var peripheralList:NSMutableArray = NSMutableArray()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initTableView()
      
        bleMingle = BLEHelper()
        bleMingle.delegate = self

        let workingQueue = dispatch_queue_create("my_queue", nil)
        dispatch_async(workingQueue) {
          
            NSThread.sleepForTimeInterval(2)

            dispatch_async(dispatch_get_main_queue()) {
              
                self.bleMingle.startScan()

            }
        }
     
        
    }
    //初始化tableview
    func initTableView(){
        // 初始化tableView的数据
        self.tableView=UITableView(frame:CGRectMake(0, 64,self.view.frame.width, self.view.frame.height),style:UITableViewStyle.Plain)
        // 设置tableView的数据源
        self.tableView?.dataSource = self
        // 设置tableView的委托
        self.tableView!.delegate = self
        self.tableView?.tableFooterView = UIView();
        self.tableView!.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView!)
    }
   
    func sendData(sender:UIButton){
        
        
        switch perital.state {
         case CBPeripheralState.Connected:
           bleMingle.writeValue(nil)
         case CBPeripheralState.Disconnected:
            UIAlertController.showAlert(self, title: "提醒", message: "未连接到蓝牙设备", cancelButtonTitle: "取消", okButtonTitle: "确定", okHandler: {
                (UIAlertAction) in
            self.bleMingle.connectPeripheral(self.perital);
            })
         default:
            print("中央管理器没有改变状态")
        }
      
    }
    func toggleSwitch() {
      
        bleMingle.startScan()
    
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }


}

extension ScanBlueToothViewController:UITableViewDelegate,UITableViewDataSource{


    //总行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
        return self.deviceList.count;
    }
    //加载数据
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "newsCell")
        let  cp = self.deviceList.objectAtIndex(indexPath.row) as!CBPeripheral
        
        let nameLabel = UILabel(frame: CGRectMake(10, 10, 300, 40));
        let  textFont = UIFont(name:"Arial", size: 18)
        nameLabel.font = textFont
        if(cp.name == nil){
            nameLabel.text = "Unknown Device";
        }
        else{
            nameLabel.text = cp.name;
        }
        let uuidLabel = UILabel(frame: CGRectMake(10, 50, self.view.frame.width, 30));
        uuidLabel.font = UIFont(name:"Arial", size: 13)
        uuidLabel.text = cp.identifier.UUIDString
        
        let detailbutton = UIButton(frame:CGRectMake(self.view.frame.width-60,20, 60, 40))
        detailbutton.setImage(UIImage(named:"go"),forState:UIControlState.Normal)
        
        cell.contentView.addSubview(nameLabel);
        cell.contentView.addSubview(uuidLabel);
        cell.contentView.addSubview(detailbutton);
        cell.imageView!.image = UIImage(named:"green.png")
        return cell;
        
    }
    
    //选择一行
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath){
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true);
        let  peripheral = self.deviceList.objectAtIndex(indexPath.row) as!CBPeripheral
        print(peripheral)
        
        if(self.peripheralList.containsObject(self.deviceList.objectAtIndex(indexPath.row))){
            self.peripheralList.removeObject(self.deviceList.objectAtIndex(indexPath.row))
            print("蓝牙已断开！")
        }else{
            self.peripheralList.addObject(self.deviceList.objectAtIndex(indexPath.row))
            print("蓝牙已连接！ \(self.peripheralList.count)")
        }
        
        
    }
    //行高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        return 80;
    }

}

extension ScanBlueToothViewController:BLECentralDelegate{

    func didDiscoverPeripheral(peripheral: CBPeripheral!){
        
        perital = peripheral;
        print("搜索到的蓝牙\(peripheral)");
        if(!self.deviceList.containsObject(peripheral)){
            self.deviceList.addObject(peripheral)
            self.tableView?.reloadData();
            
        }
        
    }

}
