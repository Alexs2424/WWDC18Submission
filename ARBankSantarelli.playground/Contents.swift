//: A UIKit based Playground for presenting user interface
  
import UIKit
import ARKit
import PlaygroundSupport

/* HELLO, THESE ARE THE DIRECTIONS FOR THIS PROJECT */

//: OVERVIEW:
/* this app shows what currency visualization might be like in the future when we don't carry around cash anymore. it displays money in different stacks to show how much you have spent. It pulls information from a Capital One Hackathon API with real accounts made, it pulls the data and then displays it, in real time except for the recent purchase. */

//: IN ORDER TO WORK:
/* this app needs to be connected to the internet (simply for grabbing the data from the capital one API, and you need someplace with a plane so that it can set the table somewhere. THIS NEEDS TO BE RUN ON AN iPAD Playground becuase it uses ARKIt and needs the MyViewController() to be complied first before the playground can run it.
 */

/* Everytime you tap on a button after already selecting a button, you have to tap the butotn again because the second tap clears the nodes so that you can use another mode. Thank you and have an awesome day! - Alex Santarelli */

PlaygroundPage.current.liveView = MyViewController()
PlaygroundPage.current.needsIndefiniteExecution = true
