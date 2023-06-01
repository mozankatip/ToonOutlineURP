# OutlineShaderURP
## Introduction
"Outline Shader” is a Unity URP shader that provides an outline effect around objects. It allows you to specify the outline color, thickness, and fade. This shader has two passes: the outline pass and the texture pass.

![Screenshot 2023-06-01 120154](https://github.com/mozankatip/OutlineShaderURP/assets/47041584/9d299f84-e2ef-46c2-9370-c75d39af548b)

https://github.com/mozankatip/OutlineShaderURP/assets/47041584/bde51c6d-d3a8-48a8-918e-a4f712af720b

## Properties

* **_MainTex**: It controls the main texture of the object.
* **_Color**: Color property for the object color, especially used for objects don't have texture.
* **_OutColor**: It is for adjusting outline color.
* **_OutThickness**: Range property for the outline thickness.
* **_OutFade**: The outline fade property controls transparency of outline.
* **_ZTest**: Enum property for the ZTest mode. It allows you to set the draw order of geometry.
* **_Cull**:  Enum property for to set the culling mode of geometry.

![Screenshot 2023-06-01 110805](https://github.com/mozankatip/OutlineShaderURP/assets/47041584/bfb152da-ab8b-472c-98ca-6915fb1fc82c)


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
2. It may not work correctly with transparent objects or objects with complex material setups.
3. Now it is working like unlit material, as an improvement I will add toon lighting setup later.

* Unity Version: 2021.3.0
* Universal Render Pipeline (URP)
* Compatible with Unity 2019.3 and above

