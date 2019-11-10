//
//  DetailsViewController.swift
//  tipME
//
//  Created by Derek Chang on 11/9/19.
//  Copyright © 2019 Derek Chang. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController, UITableViewDataSource {
    
    
    @IBOutlet weak var tableview: UITableView!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var ordersTableview: UITableView!
    
    //Input chanels from the viewController - updated upon segues
    var tip: Int = 0
    var total: Float = 0.0
    
    
    var data: [String : [String : Float]] = [
        "Derek": ["Ramen": 15.90, "Soda": 2.50],
        "Ashley": ["Ramen": 12.50, "Oolong Tea": 2.50]
    ]
    
    //All queues used to keep track of row information in ordersTableview
    var orderQueue = Queue<Int>()
    var peopleQueue = Queue<String>()
    var itemQueue = Queue<String>()
    var priceQueue = Queue<Float>()
    var infoQueue = Queue<Float>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableview.dataSource = self
        ordersTableview.dataSource = self
        
        tableview.alwaysBounceVertical = false
        tableview.tableFooterView = UIView()
        
//        tableview.maxHeight = 128.0

        //establish queue used for building orderTableView
        orderQueue = initOrderQueue()
        peopleQueue = initPeopleQueue()
        itemQueue = initItemQueue()
        priceQueue = initPriceQueue()
        infoQueue = initInfoQueue()
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
    
        //hides the top of the navigation bar
        self.navigationController?.navigationBar.isHidden = true
        self.totalLabel.text = String(format: "$%.2f", total)
        
        tableview.invalidateIntrinsicContentSize()

    }
    
    //Allows the swipe left gesture to navigate back to home screen
    @IBAction func goBackHome(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableview{
            return data.count
        }
        else if tableView == self.ordersTableview{
            return data.count * 2 + getOrderCount()
        }
        else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if tableView == self.tableview{
            let cell = tableView.dequeueReusableCell(withIdentifier: "NameCell", for: indexPath) as! NameCell
            cell.name.text = [String](data.keys)[indexPath.row]
            
            let tempPrice: [Float] = [23.46, 19.13]
            cell.personPrice.text = String(format: "%@%.2f", "$", tempPrice[indexPath.row])
            return cell
        }
        else if tableView == self.ordersTableview{
            
            
            if !orderQueue.isEmpty(){
                let currentCellChoice = orderQueue.dequeue()
                
                /*
                 0 - HeaderCell
                 1 - OrderCell
                 2 - InfoCell
                 */
                if currentCellChoice == 0{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
                    
                    //get name from queue but do not delete
                    let name = peopleQueue.dequeue()
                    //assign name to label
                    cell.nameLabel.text = name
                    
                    
                    
                    return cell
                }
                else if currentCellChoice == 1{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCell", for: indexPath) as! OrderCell
                    
                    let currentItem = itemQueue.dequeue()!
                    let currentItemPrice = priceQueue.dequeue()!
                    cell.itemLabel.text = currentItem
                    cell.priceLabel.text = String(format: "$%.2f", currentItemPrice)
                    
                    
                    return cell
                }
                else if currentCellChoice == 2{
                    let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath) as! InfoCell
                    
                    let currentInfo = infoQueue.dequeue()!
                    
                    cell.tipTitleLabel.text = String(format: "%@%d%@", "Tip (" , tip, "$)")
                    cell.subTotalLabel.text = String(format: "$%.2f", currentInfo)
                    
                    //calculate tax [assuming tax is 7.75%]
                    let tax:Float = currentInfo * 0.075
                    cell.TaxLabel.text = String(format: "%@%.2f", "$", tax)
                    
                    //calculate tip
                    let currentTip = currentInfo * Float(tip) / 100.0
                    cell.tipLabel.text = String(format: "%@%.2f", "$", currentTip)
                    
                    
                    return cell
                }
            }
            
            
            
            
        }
        
        
        
        //worst case
        return UITableViewCell()
    }
    
    //gets subtotal of a person given their name
    func getPersonPrice(targetName: String) -> Float{
        
        var subTotal: Float = 0
        for (person, orders) in data{
            if person == targetName{
                for (_, price) in orders{
                    subTotal += price
                }
            }
        }
        return subTotal
    }
    
    //returns the amount of items on the order
    //function used when asked how many rows in ordertableview
    func getOrderCount() -> Int{
        
        var orderCount = 0
        for (_, orders) in data{
            orderCount += orders.count
        }
        
        
        
        return orderCount
    }
    struct Queue<T>{
        
        var items:[T] = []
        
        
        mutating func enqueue(element: T)
        {
            items.append(element)
        }
        
        mutating func dequeue() -> T?
        {
            
            if items.isEmpty {
                return nil
            }
            else{
                let tempElement = items.first
                items.remove(at: 0)
                return tempElement
            }
        }

        mutating func dequeueWithoutReturn()
        {
            
            if !items.isEmpty {
                items.remove(at: 0)
            }
        
        }
        func count() -> Int{
            return items.count
        }
        
        func isEmpty() -> Bool{
            return items.isEmpty
        }
        
        func front() -> T{
            return items[0]
        }
    }
    
    func initOrderQueue() -> Queue<Int>{
        
        var orderQueue: Queue = Queue<Int>()
        
        for (_, orders) in data{
            orderQueue.enqueue(element: 0)
            for (_, _) in orders{
                orderQueue.enqueue(element: 1)
            }
            orderQueue.enqueue(element:2)
        }
        return orderQueue
    }
    
    func initPeopleQueue() -> Queue<String>{
        
        var peopleQueue: Queue = Queue<String>()
        
        for (people, _) in data{
            peopleQueue.enqueue(element: people)
        }
        return peopleQueue
    }
    func initItemQueue() -> Queue<String>{
        
        var itemQueue: Queue = Queue<String>()
        
        for (_, orders) in data{
            
            for (item, _) in orders{
                itemQueue.enqueue(element: item)
            }
           
        }
        return itemQueue
    }
    func initPriceQueue() -> Queue<Float>{
        
        var priceQueue: Queue = Queue<Float>()
        
        for (_, orders) in data{
            
            for (_, price) in orders{
                priceQueue.enqueue(element: price)
            }
           
        }
        return priceQueue
    }
    func initInfoQueue() -> Queue<Float>{
        
        var infoQueue: Queue = Queue<Float>()
        
        for (_, orders) in data{
            var subTotal:Float = 0.0
            for (_, price) in orders{
                subTotal += price
            }
            infoQueue.enqueue(element: subTotal)
           
        }
        return infoQueue
    }
}
