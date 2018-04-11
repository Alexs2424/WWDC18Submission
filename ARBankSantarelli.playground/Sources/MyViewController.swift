import Foundation
import UIKit
import ARKit

public class MyViewController : UIViewController, ARSCNViewDelegate, ARSessionDelegate {
    
    var sceneView: ARSCNView!
    
    let API_KEY = "ba3ee3150714a055100f2aacbb61fab3"
    
    var nodesAdded = false
    var lastZPos: Float = 0.0
    var titleLabel: UILabel = UILabel()
    var tablePlaced: Bool = false
    
    var balanceButton: UIButton = UIButton()
    var compareButton:UIButton = UIButton()
    var showLastPurchase:UIButton = UIButton()
    var detailText: UITextView = UITextView()
    var recentPurchase: UIImageView = UIImageView()
    
    
    override public func loadView() {
        sceneView = ARSCNView(frame: CGRect(x: 0.0, y: 0.0, width: 932.0, height: 568.0))//width 1024 height 768
        sceneView.delegate = self
        sceneView.showsStatistics = true
        
        let config = ARWorldTrackingConfiguration()
        config.planeDetection = .horizontal
        sceneView.session.delegate = self
        self.view = sceneView
        sceneView.session.run(config)
        
        
        //        let view = UIView()
        //        view.backgroundColor = .white
        //
        //        let label = UILabel()
        //        label.frame = CGRect(x: 150, y: 200, width: 200, height: 20)
        //        label.text = "Hello World!"
        //        label.textColor = .black
        //
        //        view.addSubview(label)
        //        self.view = view
    }
    
    override public func viewDidLoad() {
        
        //Creating the title label
        titleLabel = UILabel(frame: CGRect(x: self.view.frame.midX - 150, y: 30, width: 300, height: 20)) //x had - 150 0r 130
        
        titleLabel.font = UIFont(name: "AvenirNext-Medium", size: 20.0)
        titleLabel.text = "Please Select Action"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        
        view.addSubview(titleLabel)
        
        //Creating the balance button
        self.balanceButton = UIButton(type: .custom)
        //self.view.frame.maxY - 82
        self.balanceButton.frame = CGRect(x: 40, y: 350, width: 150, height: 42)
        self.balanceButton.backgroundColor = .gray
        self.balanceButton.layer.cornerRadius = 10
        self.balanceButton.setTitle("Show Balance", for: .normal)
        //        balanceButton.setImage(UIImage(named: "BalancesButtonSelected.png"), for: .normal)
        self.balanceButton.addTarget(self, action: #selector(MyViewController.showBalance), for: .touchUpInside)
        
        view.addSubview(self.balanceButton)
        
        //Creating the compare button
        self.compareButton = UIButton(type: .custom)
        
        self.compareButton.frame = CGRect(x: 40, y: 400, width: 150, height: 42)
        self.compareButton.backgroundColor = .gray
        self.compareButton.layer.cornerRadius = 10
        self.compareButton.setTitle("Compare", for: .normal)
        self.compareButton.addTarget(self, action: #selector(MyViewController.showCompare), for: .touchUpInside)
        
        view.addSubview(self.compareButton)
        
        //Creating the Recent Purchase Button
        self.showLastPurchase = UIButton(type: .custom)
        
        self.showLastPurchase.frame = CGRect(x: 40, y: 450, width: 150, height: 42)
        self.showLastPurchase.backgroundColor = .gray
        self.showLastPurchase.layer.cornerRadius = 10
        self.showLastPurchase.setTitle("Last Purchase", for: .normal)
        self.showLastPurchase.addTarget(self, action: #selector(MyViewController.showRecentPurchase), for: .touchUpInside)
        
        view.addSubview(self.showLastPurchase)
        
        //adding the imageview
        self.recentPurchase = UIImageView(frame: CGRect(x: 780, y: 350, width: 120.0, height: 120.0))
        self.recentPurchase.image = UIImage(named: "ipad image.jpeg")
        self.recentPurchase.layer.cornerRadius = 10
        
        view.addSubview(self.recentPurchase)
        self.recentPurchase.isHidden = true

        
        //adding the textview
        self.detailText = UITextView(frame: CGRect(x: 680.0, y: 100, width: 225.0, height: 170.0))
        self.detailText.textColor = .white
        self.detailText.font = .systemFont(ofSize: 14)
        self.detailText.backgroundColor = .gray
        self.detailText.layer.cornerRadius = 10
        self.detailText.text = "Tap a button to see a representation in a stack of cash. each stack represents a different amount in USD, so be sure to look here for the specific amount. This app represents what visualization of currency might look like when we don't have cash anymore."
        self.detailText.isEditable = false
        
        view.addSubview(self.detailText)
        
        
    }
    
    @objc
    public func showBalance() {
        if nodesAdded {
            self.balanceButton.backgroundColor = .gray
            self.compareButton.backgroundColor = .gray
            self.showLastPurchase.backgroundColor = .gray
            //remove all of them
            self.removeChildrenNodes()
            nodesAdded = false
//            self.showBalance() this line allows you to click from another button onto this one, ADD TO THIS
            self.titleLabel.text = "Please Select Action"
            self.detailText.text = "Tap a button to see a representation in a stack of cash. each stack represents $150 USD. This app represents what visualization of currency might look like when we don't have cash anymore."
            self.recentPurchase.isHidden = true
            //            self.billSwitch.isHidden = true
        } else {
            self.balanceButton.backgroundColor = UIColor(red: 0.91, green: 0.35, blue: 0.22, alpha: 1.0)
            self.compareButton.backgroundColor = .gray
            self.showLastPurchase.backgroundColor = .gray
            self.recentPurchase.isHidden = true
            nodesAdded = true
            self.titleLabel.text = "Account Balance –– $1,891.74"
            self.detailText.text = "This shows the current account balance in $150 stacks of money. If you look closely each bill is separately rendered."
            
            //Creating the table
            let rectGeo = SCNBox(width: 0.3, height: 0.75, length: 0.05, chamferRadius: 0.0) //length was 0.6, height was 0.06
            rectGeo.firstMaterial?.diffuse.contents = UIColor(red: 0.90, green: 0.72, blue: 0.54, alpha: 1.0)
            let rect = SCNNode(geometry: rectGeo)

            rect.eulerAngles.x = -.pi / 2
            //rect.eulerAngles.y = -.pi / 5

            rect.simdWorldPosition = simd_float3(x: 0.0, y: -0.1, z: -0.59)//let's see how this changes things. z: was -0.
            sceneView.scene.rootNode.addChildNode(rect)
            //End of adding and creating the table
            
            //Getting the account information to create the money for
            _ = getAccountNames(completion: { (output: [String]) in
                print("There are \(output.count) accounts.")
                print("Account Name: \(output[0])")
                
                let acctBalance = Double(output[1])
                self.addMoneyForAmount(amt: acctBalance!, title: "BAL") //BAL for denomination in 150 dollar stacks
                //            self.addMoneyForAmount(amt: 21, title: "")
                
            })
        }
        
    }
    
    @objc
    func showCompare() {
        if nodesAdded {
            //remove all of them
            self.removeChildrenNodes()
            nodesAdded = false
            self.titleLabel.text = "Please Select Action"
            self.detailText.text = "Tap a button to see a representation in a stack of cash. each stack represents $200 USD. This app represents what visualization of currency might look like when we don't have cash anymore."
            self.balanceButton.backgroundColor = .gray
            self.compareButton.backgroundColor = .gray
            self.showLastPurchase.backgroundColor = .gray
            self.recentPurchase.isHidden = true
        } else {
            self.balanceButton.backgroundColor = .gray
            self.compareButton.backgroundColor = UIColor(red: 0.91, green: 0.35, blue: 0.22, alpha: 1.0)
            self.showLastPurchase.backgroundColor = .gray
            self.recentPurchase.isHidden = true
            nodesAdded = true
            
            //            billSwitch.isHidden = true
            
            self.titleLabel.text = "Deposits vs. Withdrawls"
            self.detailText.text = "This views compares how much you are spending (in the orange dollars) and how much money you are depositing into your account (in the green dollars). The stacks displayed have $200 each stack."
            
            //Creating the table
            let rectGeo = SCNBox(width: 0.3, height: 0.75, length: 0.05, chamferRadius: 0.0) //length was 0.6, height was 0.06
            rectGeo.firstMaterial?.diffuse.contents = UIColor(red: 0.90, green: 0.72, blue: 0.54, alpha: 1.0) // Dark Brown Table UIColor(red: 0.30, green: 0.17, blue: 0.14, alpha: 1.0)
            let rect = SCNNode(geometry: rectGeo)
            
            rect.eulerAngles.x = -.pi / 2
            //rect.eulerAngles.y = -.pi / 5
            
            rect.simdWorldPosition = simd_float3(x: 0.0, y: -0.1, z: -0.59)//let's see how this changes things. z: was -0.
            sceneView.scene.rootNode.addChildNode(rect)
            
            _ = getWithdrawls(completion: { (totalWithdrawlAmt: Double) in
                print("Total Amount of withdrawls is: $\(totalWithdrawlAmt)")
                
                //draw the orange bills with the table
                self.addOrangeMoneyForAmount(amt: totalWithdrawlAmt)
            })
            
            _ = getDeposits(completion: { (totalDepositAmt: Double) in
                print("Total Amount of deposits is: $\(totalDepositAmt)")
                
                //draw the green bills normally
                self.addMoneyForAmount(amt: totalDepositAmt, title: "")
            })
        }
    }
    
    @objc
    func showRecentPurchase() {
        if nodesAdded {
            //remove all of them
            self.removeChildrenNodes()
            nodesAdded = false
            self.titleLabel.text = "Please Select Action"
            self.detailText.text = "Tap a button to see a representation in a stack of cash. each stack represents $200 USD. This app represents what visualization of currency might look like when we don't have cash anymore."
            self.balanceButton.backgroundColor = .gray
            self.compareButton.backgroundColor = .gray
            self.showLastPurchase.backgroundColor = .gray
            self.recentPurchase.isHidden = true
        } else {
            self.titleLabel.text = "Your Last Purchase of $348.47"
            self.detailText.text = "The last item you pruchased was a new iPad on March 28th, 2018. Below is an image of your last purchase. The stacks displayed have $200 each stack."
            
            //updating the UI
            self.showLastPurchase.backgroundColor = UIColor(red: 0.91, green: 0.35, blue: 0.22, alpha: 1.0)
            self.balanceButton.backgroundColor = .gray
            self.compareButton.backgroundColor = .gray
            self.recentPurchase.isHidden = false
            
            //Creating the table
            let rectGeo = SCNBox(width: 0.3, height: 0.75, length: 0.05, chamferRadius: 0.0) //length was 0.6, height was 0.06
            rectGeo.firstMaterial?.diffuse.contents = UIColor(red: 0.90, green: 0.72, blue: 0.54, alpha: 1.0)
            let rect = SCNNode(geometry: rectGeo)
            
            rect.eulerAngles.x = -.pi / 2
            //rect.eulerAngles.y = -.pi / 5
            
            rect.simdWorldPosition = simd_float3(x: 0.0, y: -0.1, z: -0.59)//let's see how this changes things. z: was -0.
            sceneView.scene.rootNode.addChildNode(rect)
            //End of adding and creating the table
            
            //Add the money for the amount right here
            self.addMoneyForAmount(amt: 348.47, title: "")
        }
    }
    
    
    /* ADDING AND REMOVING NODES TO THE VIEWS */
    public func addMoneyForAmount(amt: Double, title:String) {
        //figuring out how much cash to stack
        var dollars = Int(amt)
        let purchaseCashIndicator:Double = Double(dollars) + 0.5
        
        if (Double(dollars) >= purchaseCashIndicator) {
            dollars += 1
        }
        var highestYPos:Float = 0.00
        var zPos:Float = -0.25
        if title == "2P" {
            
            zPos += lastZPos
            
            print("zPos with 2P: \(zPos)")
        }
        var yPos = -0.070
        var numDollar = 0
        var amtInStack = 200
        
        
        if title == "BAL" {
            amtInStack = 150
        }
        
        for dollar in stride(from: 0, to: dollars, by: 1) {
            
            //z & y position to vary
            if dollar % amtInStack == 0 { //amtInStack was 200
                numDollar += amtInStack //was 200
                
                if dollar == 0 {
                    zPos = -0.25
                    if title == "2P" {
                        zPos += -0.15
                        //                        zPos += -0.15
                    }
                    numDollar = 0
                }
                
            } else {
                yPos = -0.070 + (Double((dollar - numDollar)) * 0.00130) //was 0.0130
            }
            
            //            let yPos = -0.070 + (Double(dollar) * 0.0130)
            
            //end of stack or last dollar
            if ((dollar % amtInStack == 0) && (dollar != 0)) || (dollar == dollars - 1)  { //amtInStack was 200
                print("Top of the stack!")
//                let moneyScene = SCNScene(named: "NessieBucks.dae", inDirectory: "Resources") //was art.scnassets
//                let moneyNode = moneyScene!.rootNode.childNode(withName: "SketchUp", recursively: true)
//                moneyNode?.scale = SCNVector3(0.01, 0.01, 0.01)
//                //y: was -0.070
//                moneyNode?.simdWorldPosition = simd_float3(x: 0.0 - 0.03, y: Float(yPos), z: Float(zPos + 0.014)) //was -0.5 //z was -0.35
//                sceneView.scene.rootNode.addChildNode(moneyNode!)
                zPos -= 0.05 //was 0.125
                yPos = -0.070

                //zPos will be shifted -0.15
                lastZPos = zPos
                
            } else {
                let moneyGeo = SCNBox(width: 0.0267, height: 0.06, length: 0.0009, chamferRadius: 0.0) //width was 0.05 //not height  //length was 0.01
                //width 0.1     height 0.06
                moneyGeo.firstMaterial?.diffuse.contents = UIColor(red:0.35, green:0.53, blue:0.46, alpha:1.00) //UIColor(red: 0.20, green: 0.26, blue: 0.16, alpha: 1.0)
                let moneyNode = SCNNode(geometry: moneyGeo)
                
                moneyNode.eulerAngles.x = -.pi / 2
                moneyNode.eulerAngles.y = -.pi / 2
                
                moneyNode.simdWorldPosition = simd_float3(x: 0.0, y: Float(yPos), z: Float(zPos)) //was -0.5 //z was -0.35
//                moneyNode.position =
                sceneView.scene.rootNode.addChildNode(moneyNode)
            }
            
            
            highestYPos = Float(yPos)
        }
        
        
        //eventually we will add the purchase title over top the cash
    }
    
    public func addOrangeMoneyForAmount(amt: Double) {
        //figuring out how much cash to stack
        var dollars = Int(amt)
        let purchaseCashIndicator:Double = Double(dollars) + 0.5
        
        if (Double(dollars) >= purchaseCashIndicator) {
            dollars += 1
        }
        var highestYPos:Float = 0.00
        var zPos:Float = -0.45 //was -0.25
        var yPos = -0.070
        var numDollar = 0
        for dollar in stride(from: 0, to: dollars, by: 1) {
            //            let moneyScene = SCNScene(named: "", inDirectory: "art.scnassets")
            //            let moneyNode = moneyScene!.rootNode.childNode(withName: "SketchUp", recursively: true)
            //            moneyNode?.scale = SCNVector3(0.01, 0.01, 0.01)
            //            let moneyGeo = SCNBox(width: 0.1, height: 0.06, length: 0.01, chamferRadius: 0.0) //width was 0.05
            //            moneyGeo.firstMaterial?.diffuse.contents = UIColor(red: 0.20, green: 0.26, blue: 0.16, alpha: 1.0)
            //            let moneyNode = SCNNode(geometry: moneyGeo)
            
            //            moneyNode?.eulerAngles.x = -.pi / 2
            
            
            //z & y position to vary
            if dollar % 200 == 0 {
                numDollar += 200
                
                if dollar == 0 {
                    zPos = -0.45 //was -0.25
                    numDollar = 0
                }
                
            } else {
                yPos = -0.070 + (Double((dollar - numDollar)) * 0.00130) //was 0.0130
            }
            
            //            let yPos = -0.070 + (Double(dollar) * 0.0130)
            
            //end of stack or last dollar
            if ((dollar % 200 == 0) && (dollar != 0)) || (dollar == dollars - 1)  {
//                print("Top of the stack!")
//                let moneyScene = SCNScene(named: "NessieOrange.dae", inDirectory: "art.scnassets") //change the nessie bucks to the orange one
//                let moneyNode = moneyScene!.rootNode.childNode(withName: "SketchUp", recursively: true)
//                moneyNode?.scale = SCNVector3(0.01, 0.01, 0.01)
//                //y: was -0.070
//                moneyNode?.simdWorldPosition = simd_float3(x: 0.0 - 0.03, y: Float(yPos), z: Float(zPos + 0.014)) //was -0.5 //z was -0.35
//                sceneView.scene.rootNode.addChildNode(moneyNode!)
                zPos -= 0.05 //was 0.125
                yPos = -0.070

                //zPos will be shifted -0.15
                lastZPos = zPos
                
            } else {
                let moneyGeo = SCNBox(width: 0.0267, height: 0.06, length: 0.0009, chamferRadius: 0.0) //width was 0.05 //not height  //length was 0.01
                //width 0.1     height 0.06
                //change to the orange color
                moneyGeo.firstMaterial?.diffuse.contents = UIColor(red:0.95, green:0.61, blue:0.29, alpha:1.00) //UIColor(red: 0.20, green: 0.26, blue: 0.16, alpha: 1.0)
                let moneyNode = SCNNode(geometry: moneyGeo)
                
                moneyNode.eulerAngles.x = -.pi / 2
                moneyNode.eulerAngles.y = -.pi / 2
                
                moneyNode.simdWorldPosition = simd_float3(x: 0.0, y: Float(yPos), z: Float(zPos)) //was -0.5 //z was -0.35
                sceneView.scene.rootNode.addChildNode(moneyNode)
            }
            
            
            highestYPos = Float(yPos)
        }
    }
    
    public func removeChildrenNodes() {
        let children = self.sceneView.scene.rootNode.childNodes
        for child in children {
            child.removeFromParentNode()
        }
    }
    
    /* END ADDING AND REMOVING NODES TO THE VIEW */
    
    /** MARK: - ARSCNVIEWDELEGATE **/
//    public func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
//        if tablePlaced {
//            return nil
//        } else {
//            //            DispatchQueue.main.async {
//            //                self.tablePlaced = true
//            //            }
//            tablePlaced = true
//
//            let rectGeo = SCNBox(width: 0.3, height: 0.05, length: 0.75, chamferRadius: 0.0) //length was 0.05, height was 0.75
//            rectGeo.firstMaterial?.diffuse.contents = UIColor(red: 0.90, green: 0.72, blue: 0.54, alpha: 1.0) // Dark Brown Table UIColor(red: 0.30, green: 0.17, blue: 0.14, alpha: 1.0)
//            let rect = SCNNode(geometry: rectGeo)
//
//            //rect.eulerAngles.x = -.pi / 2
//            //rect.eulerAngles.y = -.pi / 5
//
//            //rect.simdWorldPosition = simd_float3(x: 0.0, y: -0.1, z: -0.59)//let's see how this changes things. z: was -0.
//            //            sceneView.scene.rootNode.addChildNode(rect)
//            return rect
//        }
//    }
    
    /** END ARSCNVIEWDELEGATE **/
    
    /** NESSIE API WRAPPER **/
    public func getAccountNames(completion: @escaping (_ accountNames: [String]) -> Void) -> [String] {
        let url = URL(string: "http://api.reimaginebanking.com/customers/59bc89a8a73e4942cdafdcdd/accounts?key=" + API_KEY)
        
        var output = [String]()
        
        
        let task = URLSession.shared.dataTask(with: url!){
            (data, response, error) in
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let json = json as? [[String: Any]] {
                    // now you have a top-level json dictionary
                    for account in json {
                        for key in account {
                            if (key.key == "nickname") {
                                output.append(key.value as! String)
                            } else if (key.key == "balance") {
                                let balance = key.value as! Double
                                output.append("\(balance)")
                            }
                        }
                    }
                }
                completion(output)
            } catch let error as NSError {
                print("error: \(error)")
                completion([String]())
            }
        }
        task.resume()
        return output
    }
    
    func getWithdrawls(completion: @escaping (_ totalWithdrawlAmt: Double) -> Void) -> Double {
        let url = URL(string: "http://api.reimaginebanking.com/accounts/59bc89aaa73e4942cdafdce1/withdrawals?key=" + API_KEY)
        
        var totalAmt = 0.0
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let json = json as? [[String: Any]] {
                    for obj in json {
                        for key in obj {
                            if(key.key == "amount") {
                                let amt = key.value as! Double
                                totalAmt += amt
                            }
                        }
                    }
                }
                completion(totalAmt)
            } catch let error as NSError {
                print("error: \(error)")
                completion(0.0)
            }
        }
        task.resume()
        return totalAmt
    }
    
    func getDeposits(completion: @escaping (_ totalDepositAmt: Double) -> Void) -> Double {
        let url = URL(string: "http://api.reimaginebanking.com/accounts/59bc89aaa73e4942cdafdce1/deposits?key=" + API_KEY)
        
        var totalAmt = 0.0
        let task = URLSession.shared.dataTask(with: url!) {
            (data, response, error) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: [])
                
                if let json = json as? [[String: Any]] {
                    for obj in json {
                        for key in obj {
                            if(key.key == "amount") {
                                let amt = key.value as! Double
                                totalAmt += amt
                            }
                        }
                    }
                }
                completion(totalAmt)
            } catch let error as NSError {
                print("error: \(error)")
                completion(0.0)
            }
        }
        task.resume()
        return totalAmt
    }
    
    /* END NESSIE API WRAPPER */
}
