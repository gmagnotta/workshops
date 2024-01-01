#include <stdio.h>
#include <unistd.h>

int main(void) {

  printf("Hello world from native application!\n");
  printf("This application will sleep for 30 seconds and then will exit\n");
  printf("Starting the countdown\n");
  fflush(stdout);

  for (int i = 30; i > 0; i--) {
    printf("Seconds remaining... %d\n", i);
    fflush(stdout);
    sleep(1);
  }

  printf("I will die. Goodbye!\n");

  return 0;    
}
