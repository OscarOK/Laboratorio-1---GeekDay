private class Paddle {
  public float x;
  public float y;
  public float paddleHeight;
  public float paddleWidth;
  public color paddleColor = gameColor;
  private float MAX_PADDLE_HEIGHT = 120;
  private float MIN_PADDLE_HEIGHT = 40;
  
  public Paddle(float x, float y, float paddleWidth, float paddleHeight) {
    this.x = x;
    this.y = y;
    this.paddleHeight = paddleHeight;
    this.paddleWidth = paddleWidth;
  }
  
  public void setX(float x) {
    float w = paddleWidth / 2f;
    this.x = constrain(x, w, width - w);
  }
  
  public void setY(float y) {
    float h = paddleHeight / 2f;
    this.y = constrain(y, h, height - h);
  }
  
  public void setToTargetY(float targetY, float speed) {
    setY(y + (speed * compare(targetY, y, 5)));
  }
  
  public void display() {
    fill(paddleColor);
    noStroke();
    rectMode(CENTER);
    smooth();
    rect(this.x, this.y, this.paddleWidth, this.paddleHeight);
  }
  
  public void updateHeight(int sign) {
    float factor = 2;
    float heightFactor = factor * sign;
    
    if ((paddleHeight + heightFactor) <= MAX_PADDLE_HEIGHT && (paddleHeight - heightFactor) >= MIN_PADDLE_HEIGHT) {
      paddleHeight += heightFactor;
    }
  }
  
  private int compare(float a, float b, float diffFactor) {
    if(abs(a-b) <= diffFactor) {
      return 0;
    }
    return (a > b) ? 1 : -1;
  }
}
