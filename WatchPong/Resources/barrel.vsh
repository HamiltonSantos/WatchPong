attribute vec4 a_position;
varying vec2 uv;

void main() {
gl_Position = a_position;
uv = a_position.xy;
}
