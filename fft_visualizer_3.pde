import ddf.minim.*;
import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;


Minim minim;
AudioInput   myAudio;   //get microphone audio from minim
FFT          fft;

void setup() {
  size(500, 500);
  minim = new Minim(this);
  myAudio     = minim.getLineIn(Minim.MONO); // myAudio go to minim inside getlinein(minim, mono)

  fft = new FFT( myAudio.bufferSize(), myAudio.sampleRate() );
}

void draw() {
  float vol = map(mouseX, 0, width, -60, 0);  
  myAudio.setGain(vol);
  background(0);
  stroke(255);

  // perform a forward FFT on the samples in jingle's mix buffer,
  // which contains the mix of both the left and right channels of the file
  fft.forward( myAudio.mix );

  float a = 0.0;
  float inc = TWO_PI/25.0;



  for (int i = 0; i < fft.specSize(); i++) {
    // draw the line for frequency band i, scaling it up a bit so we can see it
    //line( i, height, i, height - fft.getBand(i)*8 );

    ellipse( height/2, width/2, fft.getBand(i)*sin(a), fft.getBand(i)*cos(a));
    a = a + inc;

    if (fft.getBand(i) < 20.0) {
      fill(0, 0, 0);
    } else if (fft.getBand(i)< 40.0) {
      fill(255, 0, 0);
    } else if (fft.getBand(i)< 80.0) {
      fill(200, 0, 0);
    }
    println(fft.getBand(i));
  }
}

void stop() {
  myAudio.close();
  minim.stop();
  super.stop();
}
