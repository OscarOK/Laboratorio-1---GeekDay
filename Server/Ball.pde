

class Ball {
  public float x;
  public float y;
  public float size;
  public float speed = 1;
  public float xDirection = 1;
  public float yDirection = 1;
  public color ballColor = gameColor;
  
  
  public Ball(float x, float y, float size) {
    this.x = x;
    this.y = y;
    this.size = size;
  }
  
  public void applyForce() {
    windowHeightConstraint();
    x += xDirection * speed;
    y += yDirection * speed;
  }
  
  private void windowHeightConstraint() {
    float radius = size / 2f;
    
    if (y + radius >= height || y - radius <= 0) {
      yDirection *= -1;
    }
  }
  
  public void randomService(float x, float y, int side, float force) {
    this.x = x;
    this.y = y;
    
    float angle = radians(random(0, 45));
    
    /*if (((int) random(2)) == 0) {
      angle = 45;
    }*/
    
    if (((int) random(2)) == 0) {
      angle *= -1;
    }
    
    println(angle);
    
    switch(side) {
      // Throwing to the left side
      case 0:
        yDirection = degrees(sin(angle)) * force;
        xDirection = -1 * degrees(cos(angle)) * force;
      break;
      
      // Throwing to the right side
      case 1:
        yDirection = degrees(sin(angle)) * force;
        xDirection = degrees(cos(angle)) * force;
      break;
      
      default:
        throw new IllegalArgumentException("Invalid side value");
    }
  }
  
  public void checkPaddleCollision(Paddle p) {
    float left = p.x - (p.paddleWidth / 2);
    float right = p.x + (p.paddleWidth / 2);
    float top = p.y - (p.paddleHeight / 2);
    float bottom = p.y + (p.paddleHeight / 2);
    float radius = size / 2f;
    
    if (x + radius >= left && x - radius <= right && y + radius <= bottom && y - radius >= top) {
      sound.play();
      applyDirectionChange();
    }
  }
  
  public void applyDirectionChange() {
    xDirection *= -1;
        
        if (random(-1, 1) > 0) {
          yDirection *= -1; 
        }
  }
  
  public void display() {
    fill(ballColor);
    noStroke();
    ellipseMode(CENTER);
    smooth();
    ellipse(x, y, size, size);
  }
}
