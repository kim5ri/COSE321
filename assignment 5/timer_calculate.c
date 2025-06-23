static int arr[6];
static int timer = 0;

int* time_info()
{
	int hour, min, sec;

	timer++;

	sec = timer % 60;
	min = (timer / 60) % 60;
	hour = (timer / 3600) % 24;

	arr[0] = hour / 10;
	arr[1] = hour % 10;

	arr[2] = min / 10;
	arr[3] = min % 10;

	arr[4] = sec / 10;
	arr[5] = sec % 10;

	return arr;
}
