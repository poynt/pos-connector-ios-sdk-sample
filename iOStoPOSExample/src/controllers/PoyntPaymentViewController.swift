// http://www.raywenderlich.com/3932/networking-tutorial-for-ios-how-to-create-a-socket-based-iphone-app-and-server
//  PoyntPaymentViewController.swift
//  TCPTest
//
//  Created by Eric McConkie on 2/18/16.
//  Copyright © 2016 poynt.co. All rights reserved.
//

import UIKit
import PoyntLib
import MBProgressHUD

class PoyntPaymentViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate  {

    @IBOutlet weak var tfIP:UITextField!
    @IBOutlet weak var tfCode:UITextField!
    @IBOutlet weak var btnSale: UIButton!
    @IBOutlet weak var btnPreSale: UIButton!
    @IBOutlet weak var btnPair: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textViewResponse: UITextView!

    
    @IBOutlet weak var lblSubtotal: UILabel!
    @IBOutlet weak var lblTax: UILabel!
    @IBOutlet weak var lblDiscounts: UILabel!
    @IBOutlet weak var lblTotal: UILabel!

    @IBOutlet weak var topContainer:UIView!
    @IBOutlet weak var bottomContainer:UIView!

    
    let paymentManager =  PoyntPOSConnectionManager()
    let payment = PoyntPaymentObject()
    var pastTransactions: [PoyntTransactionObject] = []
    var currentItem: PoyntOrderItemObject?
    var currentTransactionResult: String = ""
    var currentTransactionResponse: PoyntTransactionResponseObject?
    var selectingTerminal: Bool = false
    var initialLoad: Bool = true

    let titles: [String] = [
        "COMPLETED",
        "AUTHORIZED",
        "PROCESSED",
        "VOIDED",
        "REFUNDED",
        "CANCELED",
        "FAILED",
        "HOLD",
        "DECLINED"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentTransactionResult = self.titles[0]
        PoyntDebug.sharedDebugger.verbose = true
        self.setupSamplePayment()
        self.setupDefaultUI()
        self.setupPaymentManager()
        self.tfCode.text = self.paymentManager.pairingCode

    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if(self.paymentManager.url == nil && !self.selectingTerminal && self.initialLoad){
            self.initialLoad = false
            self.selectingTerminal = true
            self.performSegueWithIdentifier("segueDiscovery", sender: self)
        }
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        updateUI()
    }
    // MARK: - segues and ux
    @IBAction func unwindToHome(segue: UIStoryboardSegue) {
        self.dismissViewControllerAnimated(true) {
            if segue.identifier == "unwindToHome" {
                MBProgressHUD.hideHUDForView(self.view, animated: true)
                if let vc = segue.sourceViewController as? ChooseTerminalViewController,
                    let terminal = vc.selectedTerminal as PoyntTerminal?{
                    if let ip = terminal.ip as String?,
                        let port = terminal.service?.port as Int? {
                        self.tfIP.text = "\(ip):\(port)"
                        self.paymentManager.url = self.tfIP.text!;
                        self.title = terminal.name


                        print("\(#function)\r\nselected terminals ---> \(terminal)")
                        print("\(#function)\r\nurl for requests: ---> \(self.paymentManager.url!)")
                    }

                }
                self.selectingTerminal = false
            }
        }
    }


    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueForItemDetails" {

            if let nav = segue.destinationViewController as? UINavigationController,
                let vc = nav.topViewController as? PoyntOrderItemViewController {
                vc.order = payment.order
                vc.item = self.currentItem
            }
            self.currentItem = nil
        }
    }

    // MARK: - Sample Payment
    func setupSamplePayment() {

        //set up a payment transaction object to hold our items
        payment.currency = "USD"
        payment.tipAmount = 0
        payment.authzOnly = true
        payment.disableTip = false
        payment.multiTender = false

        //add order object to the transaction
        payment.order = PoyntOrderObject()
        payment.order?.notes =  "i am a note"
        //payment.order?.orderNumber = "#987as9f0a"

        let item0 = PoyntOrderItemObject(sku: "testOrderItem_2", unitPrice: 100, quantity: 10.0)
        item0.name = "Drip Coffee"
        item0.unitOfMeasure = .EACH
        item0.status = "ORDERED"

        //discount example
        item0.discounts = [PoyntDiscountObject(amount: 20, customName: "item discount")]

        //tax example
        item0.taxes = [PoyntOrderItemTax(amount:100,type: "Plastic lids")]

        //add the items to the order
        payment.order?.items = [item0]
        payment.amounts?.currency = "USD"
    }

    func setupDefaultUI() {
        self.textViewResponse.text = ""
        self.bottomContainer.hidden = true

    }

    func updateUI() {
        payment.update()
        if let order = payment.order as PoyntOrderObject?,
        let amnts = order.amounts as PoyntPaymentAmountObject? {

            let formatter = NSNumberFormatter()
            formatter.numberStyle = .CurrencyStyle


            lblSubtotal.text = "Subtotal:\t\(String.currencyForFloat(Float(amnts.subTotal!)))"
            lblTax.text = "Tax:\t\(String.currencyForFloat(Float(amnts.taxTotal!)))"
            lblDiscounts.text = "Discount:\t\(String.currencyForFloat(Float(-payment.absoluteDiscountTotal)))"
            var ttl = 0
            if let total = payment.amount as Int? {
                ttl = total
            }
            lblTotal.text = "Total:\t\(String.currencyForFloat(Float(payment.absoluteTotal)))"
        }


        let bb = UIBarButtonItem(title: "...", style: .Plain, target: self, action: #selector(PoyntPaymentViewController.onActionSheet))
        self.navigationItem.rightBarButtonItem = bb
    }

    func onDoAction(tpe:PoyntActionType){
        var ttle = ""
        switch tpe {
        case .AuthorizeRefund:
            ttle = "Refund"
        case .AuthorizeCapture:
            ttle = "Capture"
        case .AuthorizeVoid:
            ttle = "Void"
        default:
            print("\(#function)\r\nunsupported type ---> \(tpe)")
        }
        let alert = UIAlertController(title: ttle, message: "Add a transactionId", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Do it.", style: .Destructive, handler: { (action) in
            if let idd = alert.textFields?.first?.text as String?{
                let poyntTransacitonObject = PoyntTransactionObject()
                poyntTransacitonObject.transactionId = idd
                self.poyntAction(tpe, transaction: poyntTransacitonObject)
            }
        }))

        alert.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "Enter transaction id"
        })
        self.presentViewController(alert, animated: true, completion: nil)
    }

    func onActionSheet(){
        let alert = UIAlertController(title: "Other Actions", message: "Choose an action below.", preferredStyle: UIAlertControllerStyle.ActionSheet)

        alert.addAction(UIAlertAction(title: "Void", style: .Default, handler: { (action) in
            self.onDoAction(.AuthorizeVoid)
        }))

        alert.addAction(UIAlertAction(title: "Capture", style: .Default, handler: { (action) in
            self.onDoAction(.AuthorizeCapture)
        }))

        alert.addAction(UIAlertAction(title: "Refund", style: .Default, handler: { (action) in
            self.onDoAction(.AuthorizeRefund)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler:nil))

        self.presentViewController(alert, animated: true, completion: nil)
    }

    func poyntAction(action:PoyntActionType,transaction:AnyObject){
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        switch action {
        case .AuthorizeSales:
            self.paymentManager.authorizeSales(transaction as! PoyntPaymentObject)
        case .AuthorizePair:
            self.paymentManager.authorizePairing(self.tfCode.text!);
        case .AuthorizePreSales:
            self.paymentManager.authorizePreSales(transaction as! PoyntPaymentObject)
        case .AuthorizeCapture:
            self.paymentManager.authorizeCapture(transaction as! PoyntTransactionObject)
        case .AuthorizeVoid:
            self.paymentManager.authorizeVoid(transaction as! PoyntTransactionObject)
        case .AuthorizeVoidPreSales:
            self.paymentManager.authorizeVoidPreSales(transaction as! PoyntTransactionObject)
        case .AuthorizeRefund:
            self.paymentManager.authorizeRefund(transaction as! PoyntTransactionObject)

        default:
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
    }

    func setupPaymentManager() {

        self.paymentManager.clientName = "Ralph"
        self.paymentManager.timeout = 30000 // 30 seconds

        // change to false to remove logging in console
        PoyntDebug.sharedDebugger.verbose = true


        //...because nothing is perfect
        paymentManager.onError = {(error) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            print("\(#function)\r\nerror for transaction ---> \(error)")

            let alert = UIAlertController(title: "Erorr.", message: "There was an error. \(error.localizedDescription)", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "ok", style: .Default, handler:nil)
            alert.addAction(cancel)
            self.presentViewController(alert, animated: true, completion: nil)
        }

        //...gets a transaction object
        paymentManager.onTransactionResponse = {(obj:PoyntTransactionResponseObject,type:PoyntActionType) -> Void in
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            print("\(#function)\r\nreceived response for \(type) ---> \(obj)")
            if let json = obj.rawJson as AnyObject?{
                let transIds = obj.transactions.map({
                    "id: \($0.transactionId ?? "")"
                }).joinWithSeparator("\r\n")
                self.textViewResponse.text = "Transactions:\r\n\(transIds)\r\n\(json.description)"
            }


            
            var title = "Status: \(obj.status)"
            var msg = "\(type) response details below."
            var refund: UIAlertAction?
            var capture: UIAlertAction?
            if obj.status == "COMPLETED" || obj.status == "SUCCESS"{
                self.bottomContainer.hidden = false
                if type == .AuthorizeSales || type == .AuthorizePreSales {
                    refund = UIAlertAction(title: "Void", style: .Destructive, handler: { (action) in
                        if let transaction = obj.transactions.first as PoyntTransactionObject? {
                            if type == .AuthorizeSales {
                                self.poyntAction(.AuthorizeVoid, transaction: transaction)
                            }else{
                                self.poyntAction(.AuthorizeVoidPreSales, transaction: transaction)

                            }
                        }
                    })

                    capture = UIAlertAction(title: "Capture", style: .Default, handler: { (action) in
                        if let transaction = obj.transactions.first as PoyntTransactionObject? {
                            self.poyntAction(.AuthorizeCapture, transaction: transaction)
                        }
                    })
                }
            }

            if obj.status == "" {
                title = "Oh oh."
                msg = "There was a problem with the transaction."
            }

            let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
            let ok = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alert.addAction(ok)

            //action options
            if let btn = capture as UIAlertAction? {
                alert.addAction(btn)
            }
            if let btn = refund as UIAlertAction? {
                alert.addAction(btn)
            }


            self.presentViewController(alert, animated: true, completion: nil)

            //set/ re-set a reference id for a new payment
            let newId = NSUUID().UUIDString
            self.payment.referenceId = newId
            self.updateUI()
        }

    }

    // MARK: - IBACTIONS
    @IBAction func sendData(btn:UIButton){
        let code = self.tfCode.text!        
        self.paymentManager.pairingCode = code;
        self.paymentManager.url = self.tfIP.text!;
        if self.paymentManager.url == nil {
            let alert = UIAlertController(title: "Terminal Unspecified", message: "You have not specified a terminal to which you will send this transaction. Would you like to select one now?", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Default, handler: { (action) in

            })
            alert.addAction(cancel)
            let ok = UIAlertAction(title: "Let's do it.", style: .Default, handler: { (action) in
                self.performSegueWithIdentifier("segueDiscovery", sender: self)
            })
            alert.addAction(ok)
            self.presentViewController(alert, animated: true, completion: nil)
            return
        }
        if(btn == self.btnSale){
            self.poyntAction(.AuthorizeSales, transaction: payment)
        }

        if(btn == self.btnPreSale){
            self.poyntAction(.AuthorizePreSales, transaction: payment)
        }

        if(btn == self.btnPair){
            self.poyntAction(.AuthorizePair, transaction: payment)
        }


    }

    


    //MARK: table view delegate
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! ItemTableViewCell
        if let ordr = self.payment.order as PoyntOrderObject? ,
        let itms = ordr.items as [PoyntOrderItemObject]? {
            cell.lblTitle.text = "\(itms[indexPath.row].name!) x \(itms[indexPath.row].quantity)"
        }

        return cell
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let po = payment.order as PoyntOrderObject?,
            let items = po.items as [PoyntOrderItemObject]? {
                return items.count
        }
        return 0
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let item  = payment.order?.items?[indexPath.row] as PoyntOrderItemObject? {
            self.currentItem = item
            self.performSegueWithIdentifier("segueForItemDetails", sender: nil)
        }
    }


}

