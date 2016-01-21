#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <stdbool.h>
void shuangse();
int main(int argc, char *argv[]) {
	srand((unsigned)time(NULL));
	for (int i = 0; i < 1; i++){
		shuangse();
	}
}
void shuangse() {
	int normalBall [6];
	int i = 1;
	int j = 0;
	while (i != 7) {
		bool exist = false;
		int random1 = rand() % 69 + 1;
		for (int k = 0; k < j; k++) {
			if (random1 == normalBall[k]) {
				exist = true;
			}
		}
		if (!exist) {
			normalBall[j] = random1;
			printf("%d ", random1);
			j++;
			i++;
		}
	}
	int random2 = rand() % 26 + 1;
	printf("   %d\n", random2);
	
}