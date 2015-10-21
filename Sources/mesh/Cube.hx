package mesh;
import kha.graphics4.VertexStructure;
import kha.graphics4.VertexBuffer;
import kha.graphics4.IndexBuffer;
import kha.graphics4.VertexData;
import kha.graphics4.Usage;
import kha.math.Matrix4;
import kha.Scheduler;
import kha.math.Vector3;

class Cube {
  
  static var vertices:Array<Float> = [
    -1.0,-1.0,-1.0,
    -1.0,-1.0, 1.0,
    -1.0, 1.0, 1.0,
     1.0, 1.0,-1.0,
    -1.0,-1.0,-1.0,
    -1.0, 1.0,-1.0,
     1.0,-1.0, 1.0,
    -1.0,-1.0,-1.0,
     1.0,-1.0,-1.0,
     1.0, 1.0,-1.0,
     1.0,-1.0,-1.0,
    -1.0,-1.0,-1.0,
    -1.0,-1.0,-1.0,
    -1.0, 1.0, 1.0,
    -1.0, 1.0,-1.0,
     1.0,-1.0, 1.0,
    -1.0,-1.0, 1.0,
    -1.0,-1.0,-1.0,
    -1.0, 1.0, 1.0,
    -1.0,-1.0, 1.0,
     1.0,-1.0, 1.0,
     1.0, 1.0, 1.0,
     1.0,-1.0,-1.0,
     1.0, 1.0,-1.0,
     1.0,-1.0,-1.0,
     1.0, 1.0, 1.0,
     1.0,-1.0, 1.0,
     1.0, 1.0, 1.0,
     1.0, 1.0,-1.0,
    -1.0, 1.0,-1.0,
     1.0, 1.0, 1.0,
    -1.0, 1.0,-1.0,
    -1.0, 1.0, 1.0,
     1.0, 1.0, 1.0,
    -1.0, 1.0, 1.0,
     1.0,-1.0, 1.0
  ];
  
  // Array of texture coords for each cube vertex
  
  static var uvs:Array<Float> = [
    0.000059, 0.000004, 
    0.000103, 0.336048, 
    0.335973, 0.335903, 
    1.000023, 0.000013, 
    0.667979, 0.335851, 
    0.999958, 0.336064,
    0.667979, 0.335851, 
    0.336024, 0.671877, 
    0.667969, 0.671889, 
    1.000023, 0.000013, 
    0.668104, 0.000013, 
    0.667979, 0.335851, 
    0.000059, 0.000004, 
    0.335973, 0.335903, 
    0.336098, 0.000071, 
    0.667979, 0.335851, 
    0.335973, 0.335903, 
    0.336024, 0.671877, 
    1.000004, 0.671847, 
    0.999958, 0.336064, 
    0.667979, 0.335851, 
    0.668104, 0.000013, 
    0.335973, 0.335903, 
    0.667979, 0.335851, 
    0.335973, 0.335903,
    0.668104, 0.000013, 
    0.336098, 0.000071, 
    0.000103, 0.336048, 
    0.000004, 0.671870, 
    0.336024, 0.671877, 
    0.000103, 0.336048, 
    0.336024, 0.671877, 
    0.335973, 0.335903, 
    0.667969, 0.671889, 
    1.000004, 0.671847, 
    0.667979, 0.335851
  ];

  private static var structureLength:Int = 5;

  private var vertexBuffer:VertexBuffer;
  private var indexBuffer:IndexBuffer;
  private var modelViewMatrix:Matrix4;

  private var position:Vector3 = new Vector3(5, 0, 0);
  
  public function new () {};

  public function getModelViewMatrix():Matrix4 {
    if (modelViewMatrix != null) {
      return modelViewMatrix;
    }

    modelViewMatrix = Matrix4.translation(position.x, position.y, position.z);
      //.multmat(Matrix4.rotationY(Scheduler.time()))
      //.multmat(Matrix4.rotationX(Scheduler.time()));
    //return Matrix4.identity();

    return modelViewMatrix;
  }

  public function getVertexStructure():VertexStructure {
    var structure = new VertexStructure();
    structure.add("pos", VertexData.Float3);
    structure.add("uv", VertexData.Float2);
    return structure;
  }

  public function getVertexBuffer():VertexBuffer {
    if (vertexBuffer != null) {
      return vertexBuffer;
    }

    vertexBuffer = new VertexBuffer(
      Std.int(vertices.length / 3), // Vertex count - 3 floats per vertex
      this.getVertexStructure(), // Vertex structure
      Usage.StaticUsage // Vertex data will stay the same
    );


  // Copy vertices and uvs to vertex buffer
    var vbData = vertexBuffer.lock();
    for (i in 0...Std.int(vbData.length / structureLength)) {
      vbData.set(i * structureLength, vertices[i * 3]);
      vbData.set(i * structureLength + 1, vertices[i * 3 + 1]);
      vbData.set(i * structureLength + 2, vertices[i * 3 + 2]);
      vbData.set(i * structureLength + 3, uvs[i * 2]);
      vbData.set(i * structureLength + 4, uvs[i * 2 + 1]);
    }
    vertexBuffer.unlock();

    return vertexBuffer;
  }

  public function getIndexBuffer():IndexBuffer {
    if (indexBuffer != null) {
      return indexBuffer;
    }
    // A 'trick' to create indices for a non-indexed vertex data
    var indices:Array<Int> = [];
    for (i in 0...Std.int(vertices.length / 3)) {
      indices.push(i);
    }

    // Create index buffer
    indexBuffer = new IndexBuffer(
      indices.length, // Number of indices for our cube
      Usage.StaticUsage // Index data will stay the same
    );

      // Copy indices to index buffer
    var iData = indexBuffer.lock();
    for (i in 0...iData.length) {
      iData[i] = indices[i];
    }
    indexBuffer.unlock();

    return indexBuffer;
  }
}