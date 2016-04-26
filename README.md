# mBLE
# mBLE
   bleMingle = BLEHelper()
   bleMingle.delegate = self
   蓝牙初始化
   
  bleMingle.startScan()
  蓝牙扫描
  
  func didDiscoverPeripheral(peripheral: CBPeripheral!){
        //搜索到的蓝牙设备
  }

  bleMingle.connectPeripheral(self.perital);
  蓝牙连接
  
  bleMingle.writeValue(nil)
  数据发送
  
  满足最基本的蓝牙连接需求，适用于学习和简单使用
  
