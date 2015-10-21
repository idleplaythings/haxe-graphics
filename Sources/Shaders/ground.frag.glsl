#ifdef GL_ES
precision mediump float;
#endif

// Interpolated values from the vertex shaders
varying vec2 vUV;
varying vec3 vNormal;

// Values that stay constant for the whole mesh.
uniform sampler2D tileAtlasSampler;
uniform sampler2D tileMapSampler;
uniform vec2 tileCounts;
uniform float tileMapSize;


vec4 sampleAtlasTexture(sampler2D tex, vec2 uv) {
  uv = clamp(uv, 0.0, 1.0);
  return texture2D(tex, uv) * vec4(255.0);
}

vec4 combineColors(vec4 c1, vec4 c2) {    
  float alpha = c1.a > c2.a ? c1.a : c2.a;
  vec4 color = (c1 * (1.0 - c2.a)) + (c2 * c2.a);
  color.a = alpha;
  return color;
}

//This returns vec2 with values 0.0 to 1.0, representing the 2d location in the tile
vec2 getTileUv(vec2 uv) {
  uv = clamp(uv, 0.0, 1.0);
  vec2 modulus = vec2(
    mod(uv.x, (1.0 / tileCounts.x)),
    mod(uv.y, (1.0 / tileCounts.y))
  );

  vec2 tileUv =  modulus / (1.0 / tileCounts.xy);
  return clamp(tileUv, 0.0, 1.0);
}


//This selects correct tile texture from tileMap and returns the color.
//tileIndex is the index of the texture in the tileMap
//tileAmount is the amount of tiles in both rows and columns the tilemap.
vec4 sampleTile(sampler2D tileMap, float tileIndex, float tileAmount, vec2 tileUv) {
  vec2 textureLocation = vec2(mod(tileIndex, tileAmount), floor(tileIndex / tileAmount)) * (1.0 / tileAmount);
  
  //tileUv = tileUv * vec2(0.8, 0.8) + vec2(0.1, 0.1);
  float tileSize = (1.0 / tileAmount);
  vec2 inTileUv = tileUv * (1.0 / tileAmount);
  inTileUv = clamp(inTileUv, 0.0, tileSize);

  return texture2D(tileMap, inTileUv + textureLocation);
}

float needTileBlend (float orginalTile, float newTile) {
  if (newTile == orginalTile) {
    return 0.0;
  }

  if (orginalTile > newTile) {
    return 0.0;
  }

  if (orginalTile + tileMapSize <= newTile ) {
    return 1.0;
  }

  if ((newTile > orginalTile) && (mod(newTile, tileMapSize) < mod(orginalTile, tileMapSize))) {
    return 1.0;
  }

  return 0.0;
}

vec2 offsetUvForTileBrush (vec2 tileUv, vec2 offsetPosition) {
  float scale = 0.4;
  vec2 samplePoint = (tileUv * scale + (1.0 - scale) * 0.5) + offsetPosition * -scale;
  
  return clamp(samplePoint, 0.0, 1.0);
  
}

vec4 tileBlend (vec2 uv) {
  
  vec4 tileAtlasInfo = sampleAtlasTexture(tileAtlasSampler, uv);
  vec2 tileUv = getTileUv(uv);
  vec4 baseColor = vec4(tileUv.x, tileUv.y, 1.0, 1.0);
  //vec4 baseColor = sampleTile(tileMapSampler, tileAtlasInfo.r, tileMapSize, tileUv);
  //normalMapColor = sampleTile(tileNormalMapSampler, tileAtlasInfo.r, tileMapSize, tileUv);
  
  /*
  for (float x = -1.0; x <= 1.0; x += 1.0) {
    for (float y = -1.0; y <= 1.0; y += 1.0) {
   
      vec2 offsetPosition = vec2(x, y);
      vec2 offsetUv = (offsetPosition * (vec2(1.0) / tileCounts));
      vec4 offsetTileAtlasInfo = sampleAtlasTexture(tileAtlasSampler, clamp(offsetUv + uv, 0.0, 1.0));

      if (needTileBlend(tileAtlasInfo.r, offsetTileAtlasInfo.r) < 1.0) {
        continue;
      } 

      vec2 offsetTileUv = offsetUvForTileBrush(tileUv, offsetPosition);
      vec4 offsetBrush = sampleTile(tileMapSampler, offsetTileAtlasInfo.g, tileMapSize, offsetTileUv);

      if (offsetBrush.a == 0.0) {
        continue;
      }

      vec4 blendColor = sampleTile(tileMapSampler, offsetTileAtlasInfo.r, tileMapSize, tileUv);
      blendColor.a = offsetBrush.a;

      baseColor = combineColors(baseColor, blendColor);
      
      //if (blendColor.a > 0.7) {
        //normalMapColor = sampleTile(tileNormalMapSampler, offsetTileAtlasInfo.r, tileMapSize, tileUv);
        //tileAtlasInfo = offsetTileAtlasInfo;
      //}
      //baseColor = sampleTile(tileMapSampler, offsetTileAtlasInfo.r, tileMapSize, tileUv);
     
    }
  }
  */

  return baseColor;
  /*
  if (tileAtlasInfo.b == 255.0) {
    return 0.0;
  }

  vec4 extraColor = sampleTile(tileMapSampler, tileAtlasInfo.b, tileMapSize, tileUv);
    
  if (extraColor.a == 0.0) {
    return 0.0;
  }

  
  //normalMapColor = sampleTile(tileNormalMapSampler, tileAtlasInfo.b, tileMapSize, tileUv);
  
  */
}

void kore() {

  vec4 baseColor = tileBlend(vUV);
  //gl_FragColor = baseColor;
  vec3 normal = vNormal;
  //gl_FragColor = vec4(normal.x, normal.y, normal.z, 1.0);
  gl_FragColor = texture2D(tileAtlasSampler, vUV);
}
