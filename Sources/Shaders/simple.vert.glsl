#ifdef GL_ES
precision highp float;
#endif

// Input vertex data, different for all executions of this shader
attribute vec3 pos;
attribute vec2 uv;

// Output data: will be interpolated for each fragment.
varying vec2 vUV;

// Values that stay constant for the whole mesh
uniform mat4 projectionView;

uniform mat4 modelView;

void kore() {
	// Output position of the vertex, in clip space: MVP * position
	gl_Position = projectionView * modelView * vec4(pos, 1.0);

	// UV of the vertex. No special space for this one.
	vUV = uv;
}
