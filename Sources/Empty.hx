package ;

import kha.Game;
import kha.Framebuffer;
import kha.Color;
import kha.Loader;
import kha.LoadingScreen;
import kha.Configuration;
import kha.Image;
import kha.graphics4.TextureUnit;
import kha.graphics4.Program;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.FragmentShader;
import kha.graphics4.VertexShader;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.graphics4.ConstantLocation;
import kha.graphics4.CompareMode;
import kha.graphics4.BlendingOperation;
import kha.math.Matrix4;
import kha.math.Vector3;
import kha.Sys;

import camera.OrthographicCamera;
import mesh.Cube;
import mesh.Ground;
import shaders.CubeShaderProgram;

class Empty extends Game {
	
	private var program:CubeShaderProgram;
    private var image:Image;
    private var cube:Cube;
    private var ground:Ground;
    private var camera:OrthographicCamera;

	public function new() {
		super("Empty");
	}

	override public function init() {
        Configuration.setScreen(new LoadingScreen());

        // Load room with our texture
        Loader.the.loadRoom("room0", loadingFinished);
    }

	function loadingFinished() {
		cube = new Cube();
		ground = new Ground();
		program = new CubeShaderProgram();
		program.link(cube);

		image = Loader.the.getImage("uvtemplate");

		camera = new OrthographicCamera();
		
		Configuration.setScreen(this);
    }

	override public function render(frame:Framebuffer) {
		// A graphics object which lets us perform 3D operations
		var g = frame.g4;
		// Begin rendering
        g.begin();

        // Set depth mode
        g.setDepthMode(true, CompareMode.Less);

        // Clear screen
		g.clear(Color.fromFloats(0.3, 0.3, 0.3), 1.0);

		ground.render(g, camera);
		
		//g.setBlendingMode(BlendingOperation.SourceAlpha, BlendingOperation.InverseSourceAlpha);
   
		// Bind shader program we want to draw with
		g.setProgram(program.getShaderProgram());

		
		// Bind data we want to draw
		g.setVertexBuffer(cube.getVertexBuffer());
		g.setIndexBuffer(cube.getIndexBuffer());

		program.setProjectionView(g, camera.getProjectionViewMatrix());
		program.setModelView(g, cube.getModelViewMatrix());
		program.setTexture(g, image);
		
		// Draw!
		g.drawIndexedVertices();
		
		g.end();
    }
}
