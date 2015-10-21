package shaders;

import kha.Loader;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.Program;
import kha.graphics4.ConstantLocation;
import kha.math.Matrix4;
import kha.graphics4.TextureUnit;
import kha.Image;
import kha.graphics4.TextureFilter;
import kha.graphics4.TextureAddressing;
import kha.graphics4.MipMapFilter;
import kha.math.Vector2;

class GroundShaderProgram{

  // Load shaders - these are located in 'Sources/Shaders' directory
    // and Kha includes them automatically
  private var fragmentShader:FragmentShader;
  private var vertexShader:VertexShader;
  private var program:Program;

  private var projectionViewID:ConstantLocation;
  private var modelViewID:ConstantLocation;
  private var tileCountsID:ConstantLocation;
  private var tileMapSizeID:ConstantLocation;
  private var tileAtlasTextureID:TextureUnit;
  private var tileMapTextureID:TextureUnit;

  private static var tileMap:Image;

  public function new() {
    program = new Program();
    fragmentShader = new FragmentShader(Loader.the.getShader("ground.frag"));
    vertexShader = new VertexShader(Loader.the.getShader("ground.vert"));
    tileMap = Loader.the.getImage("tileMap");

    trace(tileMap.lock().length);

    program.setFragmentShader(fragmentShader);
    program.setVertexShader(vertexShader);
    projectionViewID = program.getConstantLocation("projectionView");
    modelViewID = program.getConstantLocation("modelView");
    tileCountsID = program.getConstantLocation("tileCounts");
    tileMapSizeID = program.getConstantLocation("tileMapSize");
    tileAtlasTextureID = program.getTextureUnit("tileAtlasSampler");
    tileMapTextureID = program.getTextureUnit("tileMapSampler");
  }

  public function init(graphics):Void {
    graphics.setTextureParameters(
      tileMapTextureID,
      TextureAddressing.Clamp,
      TextureAddressing.Clamp,
      TextureFilter.AnisotropicFilter,
      TextureFilter.AnisotropicFilter,
      MipMapFilter.NoMipFilter
    ); 

    graphics.setTexture(tileMapTextureID, tileMap);

    graphics.setVector2(tileCountsID, new Vector2(32, 32));
    graphics.setFloat(tileMapSizeID, 8);
  }

  public function getShaderProgram():Program {
    return this.program;
  }

  public function link(mesh):Void {
    program.link(mesh.getVertexStructure());
  }

  public function setProjectionView(graphics, projectionView:Matrix4):Void {
    graphics.setMatrix(projectionViewID, projectionView);
  }

  public function setTileAtlasTexture(graphics, image:Image):Void {
    graphics.setTextureParameters(
      tileAtlasTextureID,
      TextureAddressing.Clamp,
      TextureAddressing.Clamp,
      TextureFilter.AnisotropicFilter,
      TextureFilter.AnisotropicFilter,
      MipMapFilter.NoMipFilter
    ); 

    graphics.setTexture(tileAtlasTextureID, image);
  }

  public function setModelView(graphics, modelView:Matrix4):Void {
    graphics.setMatrix(modelViewID, modelView);
  }
  
}