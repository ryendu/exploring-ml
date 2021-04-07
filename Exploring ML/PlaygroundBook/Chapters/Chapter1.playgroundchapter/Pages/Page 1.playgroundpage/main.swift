//#-hidden-code
//
// Main.swift
// Exploring ML
//
// Created by Ryan D on 3/30/21.
//
import PlaygroundSupport
import Views
import SwiftUI
//#-end-hidden-code
/*:
# Welcome to Exploring ML!
Hey there, I'm Ryan 👋, and I'll be taking you through a journey exploring the wonders of _machine learning_ 🤖. The term Machine Learning might sound daunting and kinda is, but in this playground, we'll dive into a high-level overview of ml and what's happening under the hood 👩‍💻👨‍💻.

## Neural Networks 🧠
To understand how more complex forms of Neural Networks work, we first have to understand the most basic form of Neural networks, Deep Neural networks. On your right, you will see a model of a plain vanilla DNN with no toppings added 🍦. a DNN consists of multiple layers of neurons. The first layer and last layer are both respectively called the input and output layers. All the layers in between are called the hidden layers. Data gets passed sequentially in one direction from the input layer to the hidden layers, to the output layer.

A neuron in ml is just a number from 0 - 1. Each neuron in each layer is connected to each neuron in the next layer. Each connection is also associated with a number called its weight ⚖️. The input layer's neurons are simply the input data that the model receives. The value of a neuron in a non-input layer can be determined by adding up ∑ all the neurons for the previous layer multiplied by its connection weights. The weights of a neuron's connections directly determine which neuron values from the previous layer are more important. This sum, plus a bias that shifts the overall value and is often crucial to the model's success determines how active the neuron is. This sum then gets squished into a number between 0 and 1 using an activation function.

This process is repeated for every neuron in every non-input layer. The last layer, aka the output layer, could consist of one neuron, indicating a yes or a no, multiple neurons each indicating the possibility of a different outcome, or just about anything else. ML Models trains by tweaking 🎛 the weights and biases for each neuron and each connection until it has achieved a high accuracy at the given task.

## MNIST
the DNN you see in the live view is pre-trained on the MNIST dataset, a classic handwritten number classification dataset that contains 10 classes/categories, the images of handwritten numbers 0 - 9. The images are 28 pixels by 28 pixels, totaling 784 pixels corresponding to each neuron in the input layer. The number of hidden layers and the number of their neurons are randomly chosen as most combinations work well for MNIST. The output layer consists of 10 Neurons corresponding to the 10 classes. The Neuron that is brightest in the output layer will be the model's prediction. Click **Predict** on the live view to see the model work in action.
 */
