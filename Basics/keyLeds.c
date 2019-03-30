#include <stdio.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <linux/kd.h>
#include <time.h>
#include <unistd.h>    /*Encabezado para la función sleep() and close() */ 

int get_state(int fd,int *estado)
{
    if (-1 == ioctl(fd, KDGKBLED, estado)){          
/*Si la función ioctl devuelve -1, hubo un error, que será especificado en la función perror(), si es cero significa que finalizo exitosamente*/
        perror("ioctl");
        close(fd);
        return -1;
    }
   return 0;    
}


void print_caps_lock_state(int estado)
{
    printf("Estado Caps Lock: %s (%d)\n",
           (estado & K_CAPSLOCK) == K_CAPSLOCK ? "on" : "off", estado);
}

int apaga(int fd,int *estado)
{
    get_state(fd,estado);
    if (-1 == ioctl(fd, KDSKBLED, *estado ^ K_CAPSLOCK)){
        perror("ioctl set");
        close(fd);
        return -1;
    }
    return 0;
}

int prende(int fd,int *estado)
{
    if (-1 == ioctl(fd, KDSKBLED, K_CAPSLOCK)){
        perror("ioctl set");
        close(fd);
        return -1;
    }
    get_state(fd,estado);
    return 0;
}

int main()
{
    int fd = open("/dev/tty0", O_NOCTTY);

    if (fd == -1){
        perror("open");
        return -1;
    }

    int estado = 0;  
    prende(fd,&estado);    
    sleep(1);
    apaga(fd,&estado);
    sleep(2);
    prende(fd,&estado);
    sleep(1);
    apaga(fd,&estado);
    close(fd);
    return 0;
}