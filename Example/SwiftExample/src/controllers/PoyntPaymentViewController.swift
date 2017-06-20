// http://www.raywenderlich.com/3932/networking-tutorial-for-ios-how-to-create-a-socket-based-iphone-app-and-server
//  PoyntPaymentViewController.swift
//  TCPTest
//
//  Created by Eric McConkie on 2/18/16.
//  Copyright © 2016 poynt.co. All rights reserved.
//

import UIKit



class PoyntPaymentViewController: UIViewController ,UITableViewDataSource, UITableViewDelegate  {
    struct Constants {
        
        static let segueItemDetails = "segueForItemDetails"
        static let segueDiscovery   = "segueDiscovery"
        
    }
    @IBOutlet weak var spinnerContainer: UIView!
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
    var currentItem: PoyntOrderItemObject?
    var mostRecentTransactionId: String = "xxx"
    
    var initialLoad: Bool = true
    @IBOutlet weak var skipSignatureSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        
//        PoyntDebug.sharedDebugger().verbose = false
        self.setupSamplePayment()
//        self.setupDefaultUI()
        self.toggleHud(false)
        self.setupPaymentManager()
        self.tfCode.text = self.paymentManager.pairingCode
        self.tfIP.text = self.paymentManager.url


    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        
//        self.toggleHud(true)
        self.paymentManager.ping { (isPaired, error) in
            if isPaired {
                self.toggleHud(false)
            }else{
                self.performSegue(withIdentifier: Constants.segueDiscovery, sender: nil)
            }

        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
        updateUI()
    }
    // MARK: - segues and ux
    @IBAction func unwindToHome(_ segue: UIStoryboardSegue) {
        if segue.identifier == "unwindToHome" {
            self.toggleHud(false)
            if let vc = segue.source as? ChooseTerminalViewController,
                let terminal = vc.selectedTerminal as PoyntTerminal?{
                if let ip = terminal.ip as String?,
                    let port = terminal.service?.port as Int? {
                    self.tfIP.text = "\(ip):\(port)"                    
                    self.title = terminal.name
                }

            }
            
            if(self.paymentManager.pairingCode == nil){
                self.paymentManager.attemptPairing({ (flag, error) in
                    if let err = error as NSError?{
                        self.toggleHud(true)
                        self.performSegue(withIdentifier: Constants.segueDiscovery, sender: nil);
                        print("error pairing \(err.localizedDescription)")
                    }else{
                        self.toggleHud(false)
                    }
                })
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueForItemDetails" {

            if let nav = segue.destination as? UINavigationController,
                let vc = nav.topViewController as? PoyntOrderItemViewController {
                vc.order = payment.order
                vc.item = self.currentItem
            }
            self.currentItem = nil
        }
        
        if segue.identifier == "segueDiscovery" {
            if let nav = segue.destination as? UINavigationController,
                let vc = nav.topViewController as? ChooseTerminalViewController {
                vc.paymentManager = self.paymentManager
            }
            
            
            
            
        }
    }

    // MARK: - Sample Payment
    func setupSamplePayment() {

        //set up a payment transaction object to hold our items
        payment.currency = "USD"
        payment.tipAmount = 0        
        payment.disableTip = false
        payment.multiTender = false

        //add order object to the transaction
        payment.order = PoyntOrderObject()
        payment.order?.notes =  "i am a note"
        

        let item0 = PoyntOrderItemObject(sku: "testOrderItem_2", unitPrice: 100, quantity: 10.0)
        item0?.name = "Drip Coffee"
        item0?.unitOfMeasure = EACH
        item0?.status = "ORDERED"

        //discount example
        item0?.discounts = [PoyntDiscountObject(amount: 20, customName: "item discount")]

        //tax example
        item0?.taxes = [PoyntOrderItemTax(amount:100,type: "Plastic lids")]

        //add the items to the order
        payment.order?.items = [item0]
        payment.amounts?.currency = "USD"
    }

    func setupDefaultUI() {
//        self.btnPair.setTitle("Pair", forState: .Normal)
        self.textViewResponse.text = ""
        self.bottomContainer.isHidden = true

    }

    func toggleHud(_ show:Bool){
        UIView.animate(withDuration: 0.4, animations: { 
            self.spinnerContainer.alpha = (show) ? 1 : 0;
        }) 
    }
    
    func setupPaymentManager() {

        self.paymentManager.clientName = "Ralph"
        self.paymentManager.timeout = 60000 // 30 seconds

        // change to false to remove logging in console
        PoyntDebug.sharedDebugger().verbose = true


        //...because nothing is perfect
        paymentManager.onError = {(error, apiType) -> Void in
            self.toggleHud(false)
            //FIXME - error userInfo conversion
            if let ner = error as NSError?{
                let alert = UIAlertController(title: "Erorr.", message: "There was an error. \(ner.userInfo.description)", preferredStyle: .alert)

                let cancel = UIAlertAction(title: "ok", style: .default, handler:nil)
                alert.addAction(cancel)
                self.present(alert, animated: true, completion: nil)
            }
        }

        //...gets a transaction object
        paymentManager.onTransactionResponse = {(transactionObect ,apiType) -> Void in
            self.toggleHud(false)
            if let obj = transactionObect as PoyntTransactionResponseObject?,
                let type = apiType as PoyntActionType?{
                     
                if let json = obj.rawJson as AnyObject?{
                    let transIds = obj.transactions.map({
                        "id: \(($0 as AnyObject).transactionId ?? "")"
                    }).joined(separator: "\r\n")
                    self.mostRecentTransactionId = transIds
                    self.textViewResponse.text = "Transactions:\r\n\(transIds)\r\n\(json.description)"
                }



                var title = "Status: \(obj.status)"
                var msg = " response details below."
                var refund: UIAlertAction?
                var capture: UIAlertAction?
                if obj.status == "COMPLETED" || obj.status == "SUCCESS"{
                    self.bottomContainer.isHidden = false

                    if type == AuthorizePair || type == AuthorizePairWithKey {

                        self.dismiss(animated: false, completion: nil)
                        self.btnPair.setTitle("Device is Paired", for: UIControlState())
                        self.btnPair.backgroundColor = UIColor.lightGray
                    }
                    if type == AuthorizeSales || type == AuthorizePreSales {
                        refund = UIAlertAction(title: "Void", style: .destructive, handler: { (action) in
                            if let transaction = obj.transactions.first as? PoyntTransactionObject {
                                if type == AuthorizeSales {
                                    self.poyntAction(AuthorizeVoid, transaction: transaction)
                                }else{
                                    self.poyntAction(AuthorizeVoidPreSales, transaction: transaction)

                                }
                            }
                        })

                        capture = UIAlertAction(title: "Capture", style: .default, handler: { (action) in
                            if let transaction = obj.transactions.first as? PoyntTransactionObject {
                                self.poyntAction(AuthorizeCapture, transaction: transaction)
                            }
                        })
                    }
                }

                if obj.status == "" {
                    title = "Oh oh."
                    msg = "There was a problem with the transaction."
                }

                let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                let ok = UIAlertAction(title: "Ok", style: .default, handler: nil)
                alert.addAction(ok)

                //action options
                if let btn = capture as UIAlertAction? {
                    alert.addAction(btn)
                }
                if let btn = refund as UIAlertAction? {
                    alert.addAction(btn)
                }


                self.present(alert, animated: true, completion: nil)

                //set/ re-set a reference id for a new payment
                let newId = UUID().uuidString
                self.payment.referenceId = newId
                self.updateUI()
                
            }
        }
        //try to auto connect
//        self.paymentManager.authorizePairing(self.paymentManager.pairingCode)
    }

    func updateUI() {
        payment.update()
        if let order = payment.order as PoyntOrderObject?,
        let amnts = order.amounts as PoyntPaymentAmountObject? {

            let formatter = NumberFormatter()
            formatter.numberStyle = .currency


            lblSubtotal.text = "Subtotal:\t\(String.currencyForFloat(Float(amnts.subTotal)))"
            lblTax.text = "Tax:\t\(String.currencyForFloat(Float(amnts.taxTotal)))"
            lblDiscounts.text = "Discount:\t\(String.currencyForFloat(Float(payment.absoluteDiscountTotal)))"            
            lblTotal.text = "Total:\t\(String.currencyForFloat(Float(payment.absoluteTotal)))"
        }


        let bb = UIBarButtonItem(title: "...", style: .plain, target: self, action: #selector(PoyntPaymentViewController.onActionSheet))
        self.navigationItem.rightBarButtonItem = bb
    }

    func onDoAction(_ tpe:PoyntActionType){
        var ttle = ""
        switch tpe {
        case AuthorizeRefund:
            ttle = "Refund"
        case AuthorizeCapture:
            ttle = "Capture"
        case AuthorizeVoid:
            ttle = "Void"
        case AuthorizeCompletion:
            ttle = "Completion"
        case AuthorizePartialRefund:
            ttle = "Partial Refund"
        case AuthorizeAdjustment:
            ttle = "Adjustment"
        case AuthorizeSettlement:
            ttle = "Settlement"
        default:
            print("\(#function)\r\nunsupported type ---> \(tpe)")
        }
        let alert = UIAlertController(title: ttle, message: "Add a transactionId", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Do it.", style: .destructive, handler: { (action) in

            if let idd = alert.textFields?.first?.text as String?{
                if tpe == AuthorizeCompletion || tpe == AuthorizeAdjustment{
                    self.partialCompletionForTransactionId(idd, actionType: tpe)
                }else if tpe == AuthorizePartialRefund {
                    self.partialRefundForTransactionId(idd)
                }else{
                    let poyntTransacitonObject = PoyntTransactionObject()
                    poyntTransacitonObject.transactionId = idd
                    self.poyntAction(tpe, transaction: poyntTransacitonObject)
                }

            }
        }))

        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Enter transaction id"
        })
        self.present(alert, animated: true, completion: nil)
    }

    func onActionSheet(){
        let alert = UIAlertController(title: "Other Actions", message: "Choose an action below.", preferredStyle: UIAlertControllerStyle.actionSheet)

        alert.addAction(UIAlertAction(title: "Void", style: .default, handler: { (action) in
            self.onDoAction(AuthorizeVoid)
        }))

        alert.addAction(UIAlertAction(title: "Capture", style: .default, handler: { (action) in
            self.onDoAction(AuthorizeCapture)
        }))

        alert.addAction(UIAlertAction(title: "Refund", style: .default, handler: { (action) in
            self.onDoAction(AuthorizeRefund)
        }))
        alert.addAction(UIAlertAction(title: "Completion", style: .default, handler: { (action) in
            self.onDoAction(AuthorizeCompletion)
        }))
        alert.addAction(UIAlertAction(title: "Partial Refund", style: .default, handler: { (action) in
            self.onDoAction(AuthorizePartialRefund)
        }))
        alert.addAction(UIAlertAction(title: "Adjust Amount/Tip", style: .default, handler: { (action) in
            self.onDoAction(AuthorizeAdjustment)
        }))
        
        alert.addAction(UIAlertAction(title: "Settlement", style: .default, handler: { (action) in
            self.poyntAction(AuthorizeSettlement, transaction: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Show Items (2nd Screen)", style: .default, handler: { (action) in
            self.poyntAction(ShowItems, transaction: nil)
        }))
        alert.addAction(UIAlertAction(title: "Print Sample", style: .default, handler: { (action) in
            self.poyntAction(Print, transaction: nil)
        }))

        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler:nil))

        self.present(alert, animated: true, completion: nil)
    }


    func poyntAction(_ action:PoyntActionType,transaction:AnyObject?){

        self.toggleHud(true)
        if let payment = transaction as? PoyntPaymentObject{
            payment.skipSignatureScreen = self.skipSignatureSwitch.isOn
        }
        switch action {
        case AuthorizeSales:
            self.paymentManager.authorizeSales(transaction as! PoyntPaymentObject)
        case AuthorizeSettlement:
            self.paymentManager.authorizeSettlement()
        case AuthorizePair:
            self.paymentManager.authorizePairing(self.tfCode.text!);
        case AuthorizePreSales:
            self.paymentManager.authorizePreSales(transaction as! PoyntPaymentObject)
        case AuthorizeCapture:
            self.paymentManager.authorizeCapture(transaction as! PoyntTransactionObject)
        case AuthorizeVoid:
            self.paymentManager.authorizeVoid(transaction as! PoyntTransactionObject)
        case AuthorizeVoidPreSales:
            self.paymentManager.authorizeVoidPreSales(transaction as! PoyntTransactionObject)
        case AuthorizeRefund:
            self.paymentManager.authorizeRefund(transaction as! PoyntTransactionObject)
        case AuthorizeCompletion:
            self.paymentManager.authorizePreSales(transaction as! PoyntPaymentObject)
        case AuthorizePartialCompletion:
            self.paymentManager.authorizePartialCompletion(transaction as! PoyntPaymentObject)
        case AuthorizePartialRefund:
            self.paymentManager.authorizePartialRefund(transaction as! PoyntPaymentObject)
        case AuthorizeAdjustment:
            self.paymentManager.authorizeAdjustment(transaction as! PoyntPaymentObject)
        case ShowItems:
            let sso = PoyntSecondScreenObject()
            sso.currency = "USD"
            
            sso.items = []
            sso.totalAmount = 0;
            for  b in 0...3 {
                let price = 200
                sso.totalAmount = sso.totalAmount + price
                let tempItem = PoyntOrderItemObject(sku: "testsku_\(b)", unitPrice: price , quantity: 1)
                tempItem?.name = "item \(b)"
                tempItem?.status = "ORDERED"
                sso.items.append(tempItem)
            }
            
            self.paymentManager.showItems(sso)
        case Print:
            let ppo = PoyntPrintObject()
            ppo.content = "{\"content\":\"Your order #:\n553\n\n\n\n\n\"}"
            // can also do an orderId = {\"orderId\":\"$orderId\"}
            self.paymentManager.printNormal(ppo)
        default:
            self.toggleHud(false)
        }
    }

    // MARK: - IBACTIONS
    @IBAction func sendData(_ btn:UIButton){
        let code = self.tfCode.text!        
//        self.paymentManager.pairingCode = code;
        self.paymentManager.url = self.tfIP.text!;
        
        if(btn == self.btnSale){
            self.poyntAction(AuthorizeSales, transaction: payment)
        }

        if(btn == self.btnPreSale){
            self.poyntAction(AuthorizePreSales, transaction: payment)
        }

        if(btn == self.btnPair){
            self.poyntAction(AuthorizePair, transaction: payment)
        }
    }

    func partialRefundForTransactionId(_ trnxId:String){
        let alert = UIAlertController(title: "Partial Refund", message: "Enter the amount.", preferredStyle: .alert);
        let send = UIAlertAction(title: "Send", style: .default, handler: { (action) in

            var amt: Int = 0

            if let idd = alert.textFields?.first?.text as String?{
                let _amt = Int(idd)
                if let val = _amt as Int? {
                    amt = val
                }
            }



            let payment = PoyntPaymentObject()
            payment.transactionId = trnxId;
            payment.amount = amt
            self.poyntAction(AuthorizePartialRefund, transaction: payment);
        });
        alert.addAction(send)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Amount: 100 = $1.00"
        })
        self.present(alert, animated: true, completion: nil)
    }
    

    func partialCompletionForTransactionId(_ trnxId:String, actionType: PoyntActionType){
        let alert = UIAlertController(title: "Add Tip?", message: "Enter tip amount, or leave blank if you do not want to add a tip.", preferredStyle: .alert);
        let send = UIAlertAction(title: "Send", style: .default, handler: { (action) in

            var amt: Int = 0
            var tipAmount: Int = 0
            if let idd = alert.textFields?.first?.text as String?{
                let _amt = Int(idd)
                if let val = _amt as Int? {
                    amt = val
                }
            }

            if let idd = alert.textFields![1].text as String?{
                let _amt = Int(idd)
                if let val = _amt as Int? {
                    tipAmount = val
                }
            }
            

            let payment = PoyntPaymentObject()
            payment.transactionId = trnxId;
            payment.amount = amt
            payment.tipAmount = tipAmount
            self.poyntAction(actionType, transaction: payment);
        });
        alert.addAction(send)
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Amount: 100 = $1.00"
        })
        alert.addTextField(configurationHandler: {(textField: UITextField!) in
            textField.placeholder = "Tip: 100 = $1.00"
        })
        self.present(alert, animated: true, completion: nil)
    }
    //MARK: table view delegate
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ItemTableViewCell
        if let ordr = self.payment.order as PoyntOrderObject? ,
        let itms = ordr.items as? [PoyntOrderItemObject] {
            cell.lblTitle.text = "\(itms[indexPath.row].name!) x \(itms[indexPath.row].quantity)"
        }

        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let po = payment.order as PoyntOrderObject?,
            let items = po.items as? [PoyntOrderItemObject] {
                return items.count
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let ordr = payment.order as PoyntOrderObject?,
            let items = ordr.items as? [PoyntOrderItemObject],
            let item  = items[indexPath.row] as PoyntOrderItemObject? {
            self.currentItem = item

            self.performSegue(withIdentifier: Constants.segueItemDetails, sender: nil)

        }
    }


}

