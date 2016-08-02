//
//  TCPTestTests.swift
//  TCPTestTests
//
//  Created by Eric McConkie on 2/18/16.
//  Copyright © 2016 poynt.co. All rights reserved.
//

import XCTest
import PoyntLib

class TCPTestTests: XCTestCase {
    var discount : PoyntDiscountObject!
    var funding : PoyntFundingSource!
    var orderItemObject : PoyntOrderItemObject!
    var tax : PoyntOrderItemTax!
    var order :  PoyntOrderObject!
    var manager : PoyntPOSConnectionManager!

    
    override func setUp() {
        super.setUp()
         discount = PoyntDiscountObject(amount: 10, customName: "test discount")
         funding = PoyntFundingSource()
         orderItemObject = PoyntOrderItemObject(sku: "test", unitPrice: 200, quantity: 10.0)
         tax = PoyntOrderItemTax(amount: 100, type: "test tax")
         order = PoyntOrderObject()
         manager = PoyntPOSConnectionManager()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testCanModifyTax(){
        XCTAssertTrue(tax.amount == 100)
        XCTAssertTrue(tax.type == "test tax")

        tax.amount = 50
        tax.type = "newtype"

        XCTAssertTrue(tax.amount == 50)
        XCTAssertTrue(tax.type == "newtype")
    }

    func testCanModifyPaymentObject(){
        let payment = PoyntPaymentObject()
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

        let item0 = orderItemObject
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

        payment.update()
        XCTAssertTrue(payment.absoluteTotal == 2080)
        XCTAssertTrue(payment.absoluteDiscountTotal == 20)
        XCTAssertTrue(payment.absoulteTaxTotal == 100)
        XCTAssertTrue(payment.tipAmount == 0)
        XCTAssertTrue(payment.amount == 0)
    }
    
    func testPoyntPaymentAmountObject(){
        order.items = [orderItemObject]

        let payment = PoyntPaymentAmountObject(order: order)
        payment.currency = "USD"

        payment.calculate(order)
        XCTAssertTrue(payment.subTotal == 2000)

        //two discounts
        orderItemObject.discounts?.append(discount)
        orderItemObject.discounts?.append(discount)
        payment.calculate(order)
        XCTAssertTrue(payment.discountTotal == 20)
        XCTAssertTrue(payment.subTotal == 2000)

        //two tax
        orderItemObject.taxes?.append(tax)
        orderItemObject.taxes?.append(tax)
        payment.calculate(order)
        payment.taxTotal = 200

    }

    func testCanModifyOrderItem(){
        let obj = orderItemObject
        XCTAssertTrue(obj.sku == "test")
        XCTAssertNotNil(obj.sku)
        obj.sku = "heloo"
        XCTAssertTrue(obj.sku == "heloo")


        obj.unitOfMeasure = UnitOfMeasure.EACH
        XCTAssertTrue(obj.unitOfMeasure == UnitOfMeasure.EACH)
        obj.unitOfMeasure = UnitOfMeasure.ANNUAL
        XCTAssertTrue(obj.unitOfMeasure == UnitOfMeasure.ANNUAL)

        XCTAssertNil(obj.clientNotes)
        obj.clientNotes = "this is a note"
        XCTAssertNotNil(obj.clientNotes)

        XCTAssertNil(obj.status)
        obj.status = "good"
        XCTAssertNotNil(obj.status)

        XCTAssertNil(obj.name)
        obj.name = "test"
        XCTAssertNotNil(obj.name)

        // can modify unitprice
        XCTAssertTrue(obj.unitPrice == 200)
        obj.unitPrice = 100;
        XCTAssertTrue(obj.unitPrice == 100)

        XCTAssert(obj.taxes?.count == 0)
        obj.taxes?.append(tax)
        XCTAssert(obj.taxes?.count == 1)

        XCTAssert(obj.discounts?.count == 0)
        obj.discounts?.append(discount)
        XCTAssert(obj.discounts?.count == 1)

        XCTAssertTrue(obj.quantity == 10.0)
        obj.quantity = 10.1
        XCTAssertTrue(obj.quantity == 10.1)


        XCTAssert(obj.tax == 100)
        
    }
}
