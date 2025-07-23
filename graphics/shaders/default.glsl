uniform number opacity = 1.0;
uniform vec4 color = vec4(0.5, 0.5, 0.5, 0.5);
uniform vec4 flash = vec4(1.0, 1.0, 1.0, 0.0);
uniform vec4 displayColor = vec4(0.5, 0.5, 0.5, 0.5);
uniform vec4 displayFlash = vec4(1.0, 1.0, 1.0, 0.0);

vec3 rgb2hsv(vec3 c) {
	vec4 K = vec4(0.0, -1.0 / 3.0, 2.0 / 3.0, -1.0);
	vec4 p = mix(vec4(c.bg, K.wz), vec4(c.gb, K.xy), step(c.b, c.g));
	vec4 q = mix(vec4(p.xyw, c.r), vec4(c.r, p.yzx), step(p.x, c.r));
	float d = q.x - min(q.w, q.y);
	float e = 1.0e-10;
	return vec3(abs(q.z + (q.w - q.y) / (6.0 * d + e)), d / (q.x + e), q.x);
}

vec3 hsv2rgb(vec3 c) {
	vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
	vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
	return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

vec4 hardLight(vec4 c1, vec3 c2) {
	number r = c2.r < 0.5 ? 2.0 * c1.r * c2.r : 1.0 - 2.0 * (1.0 - c1.r) * (1.0 - c2.r);
	number g = c2.g < 0.5 ? 2.0 * c1.g * c2.g : 1.0 - 2.0 * (1.0 - c1.g) * (1.0 - c2.g);
	number b = c2.b < 0.5 ? 2.0 * c1.b * c2.b : 1.0 - 2.0 * (1.0 - c1.b) * (1.0 - c2.b);
	return vec4(r, g, b, c1.a);
}

vec4 applyColor(vec4 c, vec4 t) {
	vec3 hsv = rgb2hsv(hardLight(c, t.rgb).rgb);
	hsv.y = clamp(hsv.y * t.w * 2, 0, 1);
	return vec4(hsv2rgb(hsv), c.a);
}

vec4 applyFlash(vec4 c, vec4 g) {
	return vec4(c.rgb + (g.rgb - c.rgb) * g.w, c.a);
}

vec4 effect(vec4 defaultColor, Image texture, vec2 textureCoords, vec2 screenCoords) {
    vec4 textureColor = Texel(texture, textureCoords);
    // Default blending
    textureColor = textureColor * defaultColor;
    // Opacity
    textureColor.a = textureColor.a * opacity;
    // Color
    textureColor = applyColor(textureColor, color);
    textureColor = applyColor(textureColor, displayColor);
    // Flash
    textureColor = applyFlash(textureColor, flash);
    textureColor = applyFlash(textureColor, displayFlash);
    // Return
    return textureColor;
}