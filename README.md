# ToonOutlineURP
## Introduction
"Toon Outline Shader” is a Unity URP shader that provides an outline effect around objects and also giving your objects a stylized toon-like appearance. It allows you to specify the outline color, thickness, fade an toon lighting features.

![Screenshot 2023-06-06 162643](https://github.com/mozankatip/ToonOutlineURP/assets/47041584/2c2457f9-8767-4c43-8d8e-dc125e91c6de)

https://github.com/mozankatip/OutlineShaderURP/assets/47041584/bde51c6d-d3a8-48a8-918e-a4f712af720b

https://github.com/mozankatip/ToonOutlineURP/assets/47041584/06394293-9af3-4322-8ec5-74b20775c934

## Properties

* **Texture**: Controls the main texture of the object.
* **Outline Color**: Specifies the color of the outline.
* **Outline Thickness**: Defines the thickness of the outline
* **Outline Fade**: Controls the transparency of outline.
* **ZTest**: Allows you to set the draw order of geometry.
* **Brightness**: Adjusts the brightness of the object's lighting.
* **Tint Strength**: Determines the strength of the tint color.
* **Tint Color**: Specifies the color used for tinting the object.
* **Ramp**: Controls the way the color changes in the shading.


![Screenshot 2023-06-06 155315](https://github.com/mozankatip/ToonOutlineURP/assets/47041584/796b480c-d840-4f68-b713-a8cc44e2da0b)

## Usage 
You can use “TestScene” to see how the “Outline Shader” is used in action in different meshes. To use the shader in your own Unity URP project, follow these steps:

1. Copy the "Outline.shader" file into your Unity project.
2. Set the shader of the object’s material to "mozan/Outline".
3. Adjust the shader properties (outline color, thickness, fade, etc.) through the material inspector.

## Notes

1. The outline effect works best on closed mesh objects. For open or complex meshes, artifacts may occur.
2. It may not work correctly with transparent objects or objects with complex material setups.
3. It currently does not support receiving shadows but will be added in future updates.

* Unity Version: 2021.3.0
* Universal Render Pipeline (URP)
* Compatible with Unity 2019.3 and above

