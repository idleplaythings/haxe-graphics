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

class CubeShaderProgram{

  // Load shaders - these are located in 'Sources/Shaders' directory
    // and Kha includes them automatically
  private var fragmentShader:FragmentShader;
  private var vertexShader:VertexShader;
  private var program:Program;

  private var projectionViewID:ConstantLocation;
  private var modelViewID:ConstantLocation;
  private var textureID:TextureUnit;

  public function new() {
    program = new Program();
    fragmentShader = new FragmentShader(Loader.the.getShader("simple.frag"));
    vertexShader = new VertexShader(Loader.the.getShader("simple.vert"));
  
    program.setFragmentShader(fragmentShader);
    program.setVertexShader(vertexShader);
    projectionViewID = program.getConstantLocation("projectionView");
    modelViewID = program.getConstantLocation("modelView");
    textureID = program.getTextureUnit("myTextureSampler");
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

  public function setTexture(graphics, image:Image):Void {
    graphics.setTextureParameters(
      textureID,
      TextureAddressing.Clamp,
      TextureAddressing.Clamp,
      TextureFilter.AnisotropicFilter,
      TextureFilter.AnisotropicFilter,
      MipMapFilter.NoMipFilter
    ); 

    graphics.setTexture(textureID, image);
  }

  public function setModelView(graphics, modelView:Matrix4):Void {
    graphics.setMatrix(modelViewID, modelView);
  }
  
}