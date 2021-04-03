//#-hidden-code
//
//  Main.swift
//  What If Earth
//
//  Created by Ryan D on 3/30/21.
//
import PlaygroundSupport
import Views
import SwiftUI
//#-end-hidden-code
/*:
# Hey There, I'm Ryan 👋!
 I have created this interactive playground to showcase what would happen if some _wild-what-if-scenerios_ about earth actually came true. What kind of _wild-what-if-scenerios_, you ask? Well, for starters imagine strapping a few rocket boosters 🚀 on the side of earth and speeding earth's rotation up. What would happen if earth's rotation sped up? Um. Well. That depends on how much you want to speed it up. Continue reading to find out more! 🤓
 
 ## Hold Up
 Now before we dive into the simulation, lets talk about WHY what you will see happen happens. Thanks to the Centrifigual Force, gravity on the surface of earth would be reduced, water will be pulled from the poles to the equator flooding costal cities near the equator, and earth would start to buldge a bit near the equator.
 
 #### The Centrifigual Force
 Is **not** real. Yep you read that right. The Centrifigual force is an illusion. As Earth is rotating and we are rotating with it, at every given moment, everything on the surface of earth wants to fly off into space in the direction and never slow down. Now the only reason why you and I are not hurtling across space right now is because Earth's gravity counteracts that force by a LOT and pins us down on the surface of earth. The faster the rotation, the greater the 'centrifigual force'. It is just like a person in a car when the car makes a turn.
 
 #### Different Centrifigual Forces
 The Centrifigual force on earth is not constant. It is greater at the equater and lesser at the poles. This is also why a person would weigh slightly more at the north or south pole than they would weigh on the equator.

 #### Calculating The Centrifigual Force
 To calculate the Centrifigual Force, we can use the equation **F = mω^2 R cosθ** where *F* is the net Centrifigual Force, *m* is the mass of the object, *ω* is the angular velocity, *R* is the radius of earth, and θ is the latitude.
 
 To calculate the weight of a 150 lb / 68 kg person standing on the equator of earth, we first have to calculate the angular velocity of earth. To calculate the angular velocity, we have to use the equation **ω = 2π/T** where T is time. Where the time period is 24 hours. **ω = 2(3.14)/(24 * 60 * 60) = 0.00007268**. Now we can plug in all the variables into the original equation to calculate the Centrifigual Force of a 150 lb / 68 kg person standing on the equator of earth. **F = 68kg * 0.00007268^2 * 6400000m * cos(0°) = 2.2989 Newtons**. The about 2 Newtons of force counteracting gravity for a 150 lb / 68 Kg person standing on the equator is barley noticable compared to the force of gravity for them which is about 667 Newtons. If we want to derive the Centrifugal Force for Earth that is spinning at a differnt rate, then we would modify the Time variable when we derived ω.
 
 ### Speeding Up 🌎's Rotation
 Right now our beautiful earth is spinning as fast as it always has - 1,038 mph / 1670 km/h at the equator. Before we can start the simulation, edit the spin rate below to determine how many times faster earth should spin.
 */
let spinRate = /*#-editable-code rate of Earth's spin*/1.0/*#-end-editable-code*/
/*:
 Now, lets make sure you entered a Double and initialize the Live View
 */
let spinRate_ = Double(spinRate)
let view = instantiateFasterSpinLiveView(spinRate:spinRate_)
/*:
 
 ### Finally
 When all is done and you are happy, hit **Run My Code** to see the results which will appear right above the blue blob of mass 🌎. After you have finished playing around with changing the speed of earth's rotation, lets [**Make the Moon Disappear On the Next Page**](@next) 👩‍💻🧑‍💻
 */

