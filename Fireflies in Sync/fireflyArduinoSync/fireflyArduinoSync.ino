// This code runs the arduino demonstration of fireflies coming into sync
// Ari Rubinsztejn
// ari@gereshes.com
// www.gereshes.com
#include <math.h>
double mtime;
double mtimeOld=0;
double dt;
double omega = 10;
double cycleCutoff=0;
double theta1Dot;
double theta2Dot;
double theta3Dot;
double theta4Dot;
double theta5Dot;
long pi = 3.14159;
double theta1 = random(-pi, pi);
double theta2 = random(-pi, pi);
double theta3 = random(-pi, pi);
double theta4 = random(-pi, pi);
double theta5 = random(-pi, pi);
double K = .2;
double N = 5;
byte writeCode;
int writeNum;
int led1 = 9;
int led2=10;
int led3=11;
int led4=12;
int led5=13;

   
void setup() {
  //Setting and turnign off pins
  Serial.begin(9600);
  pinMode(led1, OUTPUT);
  pinMode(led2, OUTPUT);
  pinMode(led3, OUTPUT);
  pinMode(led4, OUTPUT);
  pinMode(led5, OUTPUT);
  digitalWrite(led1, LOW);
  digitalWrite(led2, LOW);
  digitalWrite(led3, LOW);
  digitalWrite(led4, LOW);
  digitalWrite(led5, LOW);

}

void loop() {
  
  mtime = millis()/1000.0;

  //Calculating the theta update
  theta1Dot=omega+((K/N)*(sin(theta1-theta1)+sin(theta2-theta1)+sin(theta3-theta1)+sin(theta4-theta1)+sin(theta5-theta1)));
  theta2Dot=omega+((K/N)*(sin(theta1-theta2)+sin(theta2-theta2)+sin(theta3-theta2)+sin(theta4-theta2)+sin(theta5-theta2)));
  theta3Dot=omega+((K/N)*(sin(theta1-theta3)+sin(theta2-theta3)+sin(theta3-theta3)+sin(theta4-theta3)+sin(theta5-theta3)));
  theta4Dot=omega+((K/N)*(sin(theta1-theta4)+sin(theta2-theta4)+sin(theta3-theta4)+sin(theta4-theta4)+sin(theta5-theta4)));
  theta5Dot=omega+((K/N)*(sin(theta1-theta5)+sin(theta2-theta5)+sin(theta3-theta5)+sin(theta4-theta5)+sin(theta5-theta5)));
  
  //Calculating dt
  dt=mtime-mtimeOld;
  mtimeOld=mtime;

  //Forward Euler
  theta1=theta1+(theta1Dot*dt);
  theta2=theta2+(theta2Dot*dt);
  theta3=theta3+(theta3Dot*dt);
  theta4=theta4+(theta4Dot*dt);
  theta5=theta5+(theta5Dot*dt);

  //Using ports to write to all LED's simultaneously
  writeNum = 0;
  mtime=mtime*omega;
  if(sin(mtime+theta1)>cycleCutoff){
    writeNum=writeNum+2;
  }
  if(sin(mtime+theta2)>cycleCutoff){
    writeNum=writeNum+4;
  }
  if(sin(mtime+theta3)>cycleCutoff){
    writeNum=writeNum+8;
  }
  if(sin(mtime+theta4)>cycleCutoff){
    writeNum=writeNum+16;
  }
  if(sin(mtime+theta5)>cycleCutoff){
    writeNum=writeNum+32;
  }
  writeCode=byte(writeNum);
  PORTB=writeCode;

}


