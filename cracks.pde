ArrayList<L> lines = new ArrayList<L>();

void setup(){
  frameRate(30);
  size(1080,1080);
  initialize();
}

void draw(){
  background(0,0);

  for (int i = 0; i< lines.size(); i++){
    lines.get(i).render();
    stroke(255);
    strokeWeight(3);
  }
  
  if (random(1) > 0.94){
    int indexPickA = (int)random(lines.size());
    int indexPickB = (int)random(lines.size());

    L lineA = lines.get(indexPickA);
    L lineB = lines.get(indexPickB);
    P pointA = lineA.onLine();
    P pointB = lineB.onLine();

    L newLine = new L(pointA,pointB);
    boolean conflict = false;
    for (int i = 0; i< lines.size(); i++){
       if (newLine.intersect(lines.get(i))){
         conflict = true;
         System.out.println("Found conflict with line: " + i);
       }
    }
    if (!conflict){
      lineA.split(pointA);
      lineB.split(pointB);
      lines.add(newLine);
    }
  }
  //saveFrame("C:/Users/Andrin Rehmann/Documents/Processing/NewRound/cracks/out/04/####.png");
}

void initialize(){
  P lt = new P(width / 4, width / 4);
  P rt = new P(3*width / 4, width / 4);
  P lb = new P(width / 4, 3*width / 4);
  P rb = new P(3*width / 4, 3*width / 4);
  this.lines.add(new L(lt,rt));
  this.lines.add(new L(rt,rb));
  this.lines.add(new L(rb,lb));
  this.lines.add(new L(lb,lt));
}

class P{
  double x,y;
  float w;
  P(double x,double y){
    this.x = x;
    this.y = y;
    this.w = random(-1,1);
  }
  void update(){
    x += w * 0.1;
  }
  float x(){
    return (float) x;
  }
  float y(){
    return (float) y;
  }
}

class L{
   P a,b;
   L(P a, P b){
     this.a = a;
     this.b = b;
   }
   
   void render() {
     a.update();
     b.update();
     line(a.x(),a.y(),b.x(),b.y());
   }
   
   P onLine(){
     float r = random(1);
     return new P(a.x + r* (b.x - a.x), a.y + r* (b.y - a.y));
   }
   
   void split(P point){
     lines.add(new L(point,b));
     b = point;
   }
   
   boolean intersect(L other){
     return a.x <= other.b.x &&
          b.x >= other.a.x &&
          a.y <= other.b.y &&
          b.y >= other.a.y;
   }
}
