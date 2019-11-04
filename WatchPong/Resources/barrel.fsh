// Adapted from :
// http://www.geeks3d.com/20140213/glsl-shader-library-fish-eye-and-dome-and-barrel-distortion-post-processing-filters/2/

uniform sampler2D colorSampler;
const float PI = 3.1415926535;
uniform float barrelPower;

varying vec2 uv;


vec2 Distort(vec2 p)
{
    float theta  = atan(p.y, p.x);
    float radius = length(p);
    radius = pow(radius, barrelPower);
    p.x = radius * cos(theta);
    p.y = radius * sin(theta);
    return 0.5 * (p   1.0);
}


void main() {
    
    vec2 rg = 2.0 * uv.xy - 1.0;
    vec2 uv2;
    float d = length(xy);
    if (d < 1.0){
        uv2 = Distort(xy);
    }else{
        uv2 = uv.xy;
    }
    
    gl_FragColor = texture2D(colorSampler, uv2);
}
