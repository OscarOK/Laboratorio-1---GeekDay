class AI {
  private Ball ball;
  private Paddle paddle;
  float error = 50; 
  float time = millis();
  
  public AI(Ball ball, Paddle paddle) {
    this.ball = ball;
    this.paddle = paddle;
  }
  
  public float getTargetY() {
    if (ball.xDirection < 0) {
      return paddle.y;
    }
    
    return ball.y; 
  }
  
}
