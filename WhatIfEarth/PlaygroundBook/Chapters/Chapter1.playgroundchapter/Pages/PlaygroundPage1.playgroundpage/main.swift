//#-hidden-code
//
// Main.swift
// What If Earth
//
// Created by Ryan D on 3/30/21.
//
import PlaygroundSupport
import Views
import SwiftUI
//#-end-hidden-code
/*:
# Hey There, I'm Ryan 👋!
 I have created this interactive playground to showcase what would happen if some fun _what-if scenerios_ about earth came true. What kind of _what-if scenerios_, you ask? Well, for starters imagine speeding up the earth's rotation. What would happen if the earth's rotation sped up? Let's find out! 🤓
 
 ## Hold Up
 First, let's explain some of what you will see. The reason behind most of the effects of spinning the earth faster is the Centrifgufal Force which alters gravity.
 
 #### The Centrifugal Force
The Centrifugal force is an illusion. Yep, you read that right. As Earth is rotating and we are rotating with it, at every given moment, everything on the surface of the earth wants to fly off into space in the direction and never slow down (we don't because gravity pins us down). That may seem to be a mysterious force (the centrifugal force) acting, but it is just the force of inertia. We don't think about the Centrifigual Force in our day-to-day lives because it is small and barely noticeable.
 
To calculate the Centrifigual Force, we can use the equation **F = mω^2 R cosθ** where *F* is the net Centrifigual Force, *m* is the mass of the object, *ω* is the angular velocity, *R* is the radius of the earth, and θ is the latitude.
 
 ### Speeding Up 🌎's Rotation
 Right now our beautiful planet is spinning as fast as it always has - 1,038 mph or 1670 km/h at the equator. Before we can start the simulation, edit the spin rate below to determine how many times faster earth should spin.
 */
let spinRate = /*#-editable-code rate of Earth's spin*/1.0/*#-end-editable-code*/
/*:
 Now, lets make sure you entered a Double and initialize the Live View
 */
let spinRate_ = Double(spinRate)
let view = instantiateFasterSpinLiveView(spinRate:spinRate_)
/*:

 ### Finally
When all is done and you are happy, hit **Run My Code** to see the results which will appear right above the blue blob of mass 🌎. After you have finished playing around with changing the speed of the earth's rotation, let's see [**how artificial intelligence would rule society**](@next) on the next page.👩‍💻🧑‍💻
 */
