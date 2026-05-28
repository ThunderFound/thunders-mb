![banner](https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/banner.svg?raw=true)
<br/>

# Thunder's Motion Blur
Lightweight and performant shader for motion blur. Looks good even at 4 samples. Great for PVP.  
Also, please try playing with settings. You may not like the default config, so maybe try turning dithering off or changing the intensity.

Shader Settings
---
![shader settings](https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/thunders-mb-settings.png?raw=true)  
Intensity - how strong blur is  
Max Velocity - limits blur streak length  
Hand Blur - whether hand should be blurred too  
Dither Mode - dithering algorithm for debanding (examples further down)  
Depth Dilation - reduces blur bleeding at edges  
<br/>

![sampling settings](https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/thunders-mb-settings-sampling.png?raw=true)  
Samples - more = smoother, but slower  
Dynamic Sampling - change samples value based on velocity  
<br/>

![extra settings](https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/thunders-mb-settings-extra.png?raw=true)  
Directional Shading (examples further down)  
<br/>

Dither modes
---
<table frame="void" rules="none">
  <tr>
    <td align="center">
      Off<br>
      <img src="https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/off.png?raw=true" width="100%">
    </td>
    <td align="center">
      IGN<br>
      <img src="https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/ign.png?raw=true" width="100%">
    </td>
    <td align="center">
      Blue Noise<br>
      <img src="https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/blue_noise.png?raw=true" width="100%">
    </td>
  </tr>
</table>
<br/>

Directional Shading
---
<table frame="void" rules="none">
  <tr>
    <td align="center">
      Off<br>
      <img src="https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/directional-shading-off.jpg?raw=true" width="100%">
    </td>
    <td align="center">
      On<br>
      <img src="https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/directional-shading-on.jpg?raw=true" width="100%">
    </td>
  </tr>
</table>