import processing.sound.*;

import processing.net.*;
import de.voidplus.myo.*;
import static javax.swing.JOptionPane.*;
import javax.swing.*;
  
Myo myo;

private Paddle leftPlayer;
private Paddle rightPlayer;
private Ball ball;
private Ball invisibleBall;
private AI ai;

private SoundFile sound;
private SoundFile point;
private SoundFile endGame;

//private color gameColor = #fff016;
private color gameColor = #ffffff;
//private color backgroundColor = #424242;
private color backgroundColor = #000000;

private float paddleHeight = 100;
private float paddleWidth = 20;

private int leftPlayerScore = 0;
private int rightPlayerScore = 0;

private float leftPlayerTargetY;
private float rightPlayerTargetY;

boolean game = true;

void setup() {
  background(backgroundColor);
  
  sound = new SoundFile(this, "hit.mp3");
  point = new SoundFile(this, "point.mp3");
  endGame = new SoundFile(this, "end.mp3");
  
  try {
    myo = new Myo(this);
  } catch (Exception e) {
    println(e);
  }
  
  //size(1000, 600);
  fullScreen();
  //frameRate(100);
  
  leftPlayer = new Paddle(paddleWidth, height / 2f, paddleWidth, paddleHeight);
  rightPlayer = new Paddle(width - paddleWidth, height / 2f, paddleWidth, paddleHeight);
  
  ball = new Ball(width/2f, height/2f, 20f);
  invisibleBall = new Ball(width/2f, height/2f, 15f);
  invisibleBall.speed += 0.1;
  invisibleBall.ballColor = #ff0000;
  ball.randomService(width/2f, height/2f, 0, 0.2);
  
  ai = new AI(invisibleBall, rightPlayer);
  
  String developed = "Developed by Oscar Eduardo Ordoñez Medina - 310898 \n Erick Jassiel Blanco Sausameda - 311008";

  showMessageDialog(null, developed, "Credits", INFORMATION_MESSAGE);
}

Device leftDevice;
Device rightDevice;

void draw() {
  
  boolean flag = true;
  
  try {
    leftDevice = myo.getDevices().get(0);
    rightDevice = myo.getDevices().get(1);
  } catch (Exception e) {
    //println(e);
    flag = false;
  }
  
  
  if (game) {
    background(backgroundColor);
    rectMode(CENTER);
    fill(gameColor);
    
    if (flag && myo.getOrientation() != null && myo.getDevices().size() > 1) {
      leftPlayerTargetY = map(leftDevice.getOrientation().y, 0.4, 0.8, height, 0);
      println(leftDevice.getOrientation());
   
      rightPlayerTargetY = map(rightDevice.getOrientation().y, 0.4, 0.8, height, 0);
      println(rightDevice.getOrientation());
    }
    
    //rightPlayerTargetY = mouseY;
    //leftPlayerTargetY = mouseY;
    
    rect(width/2f, height/2f, 5, height);
    
    ball.checkPaddleCollision(leftPlayer);
    ball.checkPaddleCollision(rightPlayer);
    ball.applyForce();
    ball.display();
    //invisibleBall.checkPaddleCollision(rightPlayer);
    //invisibleBall.applyForce();
    //invisibleBall.display();
    
    rightPlayer.setToTargetY(rightPlayerTargetY, 10);
    rightPlayer.display();
    
    leftPlayer.setToTargetY(leftPlayerTargetY, 10);
    leftPlayer.display();
    
    displayScore();
    checkWinner();
  } else {
    
    endGame.play();
  
    if (leftPlayerScore > rightPlayerScore) {
      showMessageDialog(null, "Left player won!", "End of the game", INFORMATION_MESSAGE);
      resetSketch();
    } else {
      showMessageDialog(null, "Right player won!", "End of the game", INFORMATION_MESSAGE);
      resetSketch();
    }
  }
}

void resetSketch() {
  leftPlayerScore = 0;
  rightPlayerScore = 0;
  leftPlayerTargetY = 0;
  rightPlayerTargetY = 0;
  game = true;
  background(backgroundColor);
  setup();
}

void checkWinner() {
  int finalScore = 5;
  
  if (leftPlayerScore == finalScore || rightPlayerScore == finalScore) {
    game = false;
  }
}

void displayScore() {
  updateScore();
  
  float middleMargin = 100;
  float topMargin = 50;
  
  textAlign(RIGHT);
  textSize(30);
  fill(gameColor);
  text(String.valueOf(leftPlayerScore), width/2f - middleMargin, topMargin);
  textAlign(LEFT);
  textSize(30);
  fill(gameColor);
  text(String.valueOf(rightPlayerScore), width/2f + middleMargin, topMargin);
}

void updateScore() {
  if (invisibleBall.x <= 0) {
    invisibleBall.applyDirectionChange();
    invisibleBall.yDirection = ball.yDirection;
    invisibleBall.xDirection = ball.xDirection;
  }
  
  if (ball.x > width) {
    invisibleBall.x = width/2f;
    invisibleBall.y = height/2f;
    
    point.play();
    leftPlayerScore++;
    ball.randomService(width/2f, height/2f, 1, 0.2);
    leftPlayer.updateHeight(1);
    rightPlayer.updateHeight(-1);
    
    invisibleBall.yDirection = ball.yDirection;
    invisibleBall.xDirection = ball.xDirection;
  }
  
  if (ball.x < 0) {
    point.play();
    invisibleBall.x = width/2f;
    invisibleBall.y = height/2f;
    
    rightPlayerScore++;
    ball.randomService(width/2f, height/2f, 0, 0.2);
    leftPlayer.updateHeight(-1);
    rightPlayer.updateHeight(1);
    
    invisibleBall.yDirection = ball.yDirection;
    invisibleBall.xDirection = ball.xDirection;
  }
}
