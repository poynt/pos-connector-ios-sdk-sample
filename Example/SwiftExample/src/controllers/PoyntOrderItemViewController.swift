//
//  PaymentOrderViewController.swift
//  TCPTest
//
//  Created by Eric McConkie on 2/24/16.
//  Copyright © 2016 poynt.co. All rights reserved.
//

import UIKit


class PoyntOrderItemViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    var order: PoyntOrderObject?
    var item: PoyntOrderItemObject?
    var isNewItem:Bool = true

    @IBOutlet weak var tfSku: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfQuantity: UITextField!
    @IBOutlet weak var tfUnitPrice: UITextField!
    @IBOutlet weak var tfNotes: UITextField!
    @IBOutlet weak var addDiscount: UIButton!
    @IBOutlet weak var tableViewDiscounts: UITableView!
    @IBOutlet weak var tableViewTaxes: UITableView!

    override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.tableViewDiscounts.isEditing = true
        self.tableViewTaxes.isEditing = true
        self.title = "Payment"
        if let itm = self.item as PoyntOrderItemObject? {
            self.isNewItem = false
            if let sku = itm.sku as String? {
                self.tfSku.text = sku
            }

            if let nme = itm.name as String? {
                self.tfName.text = nme
            }
            if let nts = itm.clientNotes as String? {
                self.tfNotes.text = nts
            }

            if let qt = itm.quantity as Float? {
                self.tfQuantity.text = "\(qt)"
            }
            if let up = itm.unitPrice as Int? {
                            self.tfUnitPrice.text = "\(up)"
            }
        }else {
            self.item = PoyntOrderItemObject(sku: nil, unitPrice: 0, quantity: 0)
        }
    }

    @IBAction func onExitAndSave(){
        //add item
        let qty = Float(self.tfQuantity.text!)
        if isNewItem {
            if let ordr = self.order as PoyntOrderObject? {
                ordr.items?.append(self.item!)
            }

        }
        if let itm = self.item as PoyntOrderItemObject? {
            itm.name = self.tfName.text
            itm.quantity = qty ?? 1
            itm.sku = self.tfSku.text
            itm.name = self.tfName.text
            if let txt = self.tfUnitPrice.text as String?{
                itm.unitPrice = Int(txt)!
            }

            itm.clientNotes = tfNotes.text
        }
        //close
        if let pres = self.presentingViewController as UIViewController? {
            pres.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func onExit(){

        //close
        if let pres = self.presentingViewController as UIViewController? {
            pres.dismiss(animated: true, completion: nil)
        }
    }

    @IBAction func onAddTax(_ sender: UIButton) {
        self.alertFor("Tax")
    }

    @IBAction func onAddDiscount(_ sender: UIButton) {
        self.alertFor("Discount")
    }

    func alertFor(_ type:String) {
        var ttl = "Add Discount"
        if type == "Tax" {
            ttl = "Add Tax"
        }


        let alert = UIAlertController(title: ttl, message: "Add amount in cents", preferredStyle: .alert)
        alert.addTextField { (textfield) -> Void in
            textfield.placeholder = "Name"
            if type == "Tax" {
                textfield.placeholder = "Type"
            }
        }

        alert.addTextField { (textfield) -> Void in
            textfield.placeholder = "amount"
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default) { (alertAction) -> Void in

        }
        alert.addAction(cancel)
        let ok = UIAlertAction(title: "Ok", style: .default) { (alertAction) -> Void in
            if let tfs = alert.textFields as [UITextField]? {
                if type == "Tax" {
                    let tx = PoyntOrderItemTax(amount: Int(tfs[1].text!)!, type: tfs[0].text!)
                    self.item?.taxes?.append(tx)
                }else {
                    let discount = PoyntDiscountObject(amount: Int(tfs[1].text!)!, customName: tfs[0].text!)
                    self.item?.discounts?.append(discount)

                }
                self.tableViewDiscounts.reloadData()
                self.tableViewTaxes.reloadData()
            }
        }
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func onExitAndRemove(){
        //remove item
        if let ordr = self.order as PoyntOrderObject? ,
        let items = ordr.items as? [PoyntOrderItemObject] {
            var newItems: [PoyntOrderItemObject] = []
            for itm in items {
                if itm != self.item {
                    newItems.append(itm)
                }

            }
            self.order?.items = newItems
        }
        
        //close
        if let pres = self.presentingViewController as UIViewController? {
            pres.dismiss(animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idSt = "ItemDiscountCell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: idSt) as UITableViewCell? {
            if let itm = self.item as PoyntOrderItemObject? {
                if tableView == self.tableViewDiscounts{
                    if let discounts = itm.discounts as? [PoyntDiscountObject] {
                        let discount = discounts[indexPath.row]
                        cell.textLabel?.text = "\(String.currencyForFloat(Float(discount.amount)))- \(discount.customName!)"
                    }
                }

                if tableView == self.tableViewTaxes {
                    if let txs = itm.taxes as? [PoyntOrderItemTax] {
                        let tx = txs[indexPath.row]
                        cell.textLabel?.text = "\(String.currencyForFloat(Float(tx.amount))) - \(tx.type!)"
                    }
                }
            }
            return cell
        }
        return UITableViewCell(style: .default, reuseIdentifier: idSt)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let itm = self.item as PoyntOrderItemObject?{

            if tableView == self.tableViewDiscounts{
                if let discounts = itm.discounts as? [PoyntDiscountObject] {
                    return discounts.count
                }
            }

            if tableView == self.tableViewTaxes {
                if let txs = itm.taxes as? [PoyntOrderItemTax] {
                    return txs.count
                }
            }


        }
        return 0
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if let itm = self.item as PoyntOrderItemObject?{
            if tableView == self.tableViewDiscounts{
                if var objs = itm.discounts as? [PoyntDiscountObject] {

                    //remove the data
                    objs.remove(at: indexPath.row)
                    self.item?.discounts = objs

                    //animate
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }

            if tableView == self.tableViewTaxes {
                if var objs = itm.taxes as? [PoyntOrderItemTax] {

                    //remove the data
                    objs.remove(at: indexPath.row)
                    self.item?.taxes = objs

                    //animate
                    tableView.beginUpdates()
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                    tableView.endUpdates()
                }
            }
        }
    }
}
