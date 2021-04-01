//#-hidden-code
//
//  Main.swift
//  What If Earth
//
//  Created by Ryan D on 3/30/21.
//

//#-end-hidden-code
/*:
# Hey There, I'm Ryan 👋!
 I have created this interactive playground to showcase what would happen if some _wild-what-if-scenerios_ about earth actually came true. What kind of _wild-what-if-scenerios_, you ask? Well, for starters imagine strapping a few rocket boosters 🚀 on the side of earth and speeding earth's rotation up. What would happen if earth's rotation sped up? Um. Well. That depends on how much you want to speed it up. So go speed earth up and see what happens! 🤓
 ### Speeding Up 🌎's Rotation
 Right now our beautiful earth is spinning as fast as it always has - 1,038 mph at the equator. Before we can start the simulation, lets set it up. First import the needed frameworks
 */
import PlaygroundSupport
import Views
//We Love SwiftUI
import SwiftUI

/*:
 Now to speed earth up, edit the spin rate below to determine how many times faster earth should spin.
 */
let spinRate = /*#-editable-code rate of Earth's spin*/1.0/*#-end-editable-code*/
/*:
 Almost there, lets make sure you entered a Double and initialize the Live View
 */
let spinRate_ = Double(spinRate)
let view = instantiateFasterSpinLiveView(spinRate:spinRate_)
/*:
 When all is done and you are happy, hit **Run My Code** to see the results which will appear right above the blue blob of mass 🌎. After you have finished playing around with changing the speed of earth's rotation, lets [**Make the Moon Disappear On the Next Page**](@next) 👩‍💻🧑‍💻
 */

