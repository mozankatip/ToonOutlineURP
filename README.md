# OutlineShaderURP
## Introduction
"Outline Shader” is a Unity URP shader that provides an outline effect around objects. It allows you to specify the outline color, thickness, and fade. This shader has two passes: the outline pass and the texture pass.

## Properties

* **_MainTex ("Texture", 2D)**: Texture property for the main texture of the object.
* **_Color ("Object Color", Color)**: Color property for the object color.
* **_OutThickness ("Outline Thickness", Range(0.0, 0.2))**: Range property for the outline thickness.
* **_OutFade ("Outline Fade", Range(0.0, 1.0))**: Range property for the outline fade.
* **_ZTest ("ZTest", Float)**: Enum property for the ZTest mode. It allows you to set the draw order of geometry.
* **Cull ("Cull Mode, Integer)**:  Enum property for to set the culling mode of geometry.

## Code Structure

**Outline Pass:** 
The outline pass is responsible for rendering the outline effect around the object.

* **Vertex Shader:** The vertex shader for the outline pass inflates the vertices of the object based on the outline thickness. It calculates the inflated position and transforms it to clip space.
* **Fragment Shader:** The fragment shader for the outline pass calculates the outline color and the transparency.

**Texture Pass:**
The texture pass renders the texture of the object without the outline effect.

* **Vertex Shader:** The vertex shader for the texture pass simply transforms the vertex position to clip space.
* **Fragment Shader:** The fragment shader for the texture pass retrieves the texture color or the object color and returns it as the final color.

## Usage 
You can use “TestScene” to see how the “Outline Shader” is used in action in different meshes. To use the shader in your own Unity URP project, follow these steps:

1. Copy the "Outline.shader" file into your Unity project.
2. Set the shader of the object’s material to "mozan/Outline".
3. Adjust the shader properties (outline color, thickness, fade, etc.) through the material inspector.

## Notes

1. The outline effect works best on closed mesh objects. For open or complex meshes, artifacts may occur.
2. The outline effect may not work correctly with transparent objects or objects with complex material setups.

* Unity Version: 2021.3.0
* Universal Render Pipeline (URP)
* Compatible with Unity 2019.3 and above

