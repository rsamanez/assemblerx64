 /*
   Simple Xlib application drawing a box in a window.
   To Compile: gcc -O2 -Wall -o xhell xhell.c -L /usr/X11R6/lib -lX11 -lm
 */

 #include<X11/Xlib.h>
 #include<stdio.h>
 #include<stdlib.h> /* prevents error for exit on line 18 when compiling with gcc */
 #include<math.h>
 int main() {
   Display *d;
   int s;
   int xx,yy,i,xa,ya;
   float t;
   Window w;
   XEvent e;
	 Atom delWindow;

                        /* open connection with the server */
   d=XOpenDisplay(NULL);
   if(d==NULL) {
     printf("Cannot open display\n");
     exit(1);
   }
   s=DefaultScreen(d);

                        /* create window */
   w=XCreateSimpleWindow(d, RootWindow(d, s), 10, 10, 500, 500, 1,
                         BlackPixel(d, s), WhitePixel(d, s));

   /* Process Window Close Event through event handler so XNextEvent does Not fail */
   delWindow = XInternAtom( d, "WM_DELETE_WINDOW", 0 );
   XSetWMProtocols(d , w, &delWindow, 1);

                        /* select kind of events we are interested in */
   XSelectInput(d, w, ExposureMask | KeyPressMask);

                        /* map (show) the window */
   XMapWindow(d, w);

                        /* event loop */
	
   while(1) {
     XNextEvent(d, &e);
                        /* draw or redraw the window */
     if(e.type==Expose) {
       XFillRectangle(d, w, DefaultGC(d, s), 0, 0, 10, 10);
       XDrawLine(d, w, DefaultGC(d, s), 0, 0, 490, 490);
       XDrawRectangle(d, w, DefaultGC(d, s), 10, 10, 490, 490);
      t=0;
      xa=250;
      ya=250;
      for(i=0;i<3000;i++){
        xx=250+100*sin(5*t+t)-100*cos(t/5);
        yy=250+100*cos(3*t)-100*sin(t/3);
        t=t+0.01;
        XDrawLine(d, w, DefaultGC(d, s), xa, ya, xx, yy);
        xa=xx;
        ya=yy;
      }
     }
                        /* exit on key press */
     if(e.type==KeyPress)
       break;

     /* Handle Windows Close Event */
     if(e.type==ClientMessage)
        break;
   }
                        /* destroy our window */
   XDestroyWindow(d, w);

                        /* close connection to server */
   XCloseDisplay(d);

   return 0;
 }