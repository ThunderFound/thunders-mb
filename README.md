![banner](https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/thunders-motion-blur-banner.png?raw=true)
# Thunder's Motion Blur
Lightweight and performant shader for motion blur. Looks good even at 4 samples. Great for PVP.  
Also, please try playing with settings. You may not like the default config, maybe try turning dithering off or changing the intensity.

Shader Settings
---
![shader settings](https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/thunders-mb-settings.png?raw=true)

Intensity - how strong blur is  
Max Velocity - limits blur streak length  
Hand Blur - whether hand should be blurred too  
Dither Mode - dithering algorithm for debanding  
Depth Dilation - reduces blur bleeding at edges

![sampling settings](https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/thunders-mb-settings-sampling.png?raw=true)
Samples - more = smoother, but slower  
Dynamic Sampling - change samples value based on velocity

Dither modes
---
### Off
![off](https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/off.png?raw=true)

### IGN
![ign](https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/ign.png?raw=true)

### Blue Noise
![blue noise](https://github.com/ThunderFound/thunders-motion-blur/blob/main/images/blue_noise.png?raw=true)