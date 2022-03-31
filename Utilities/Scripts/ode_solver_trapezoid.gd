extends Node
#
#var a := 0.0
#var b := PI
#var n := 11
#var h = (b - a) / (n - 1)
#var x = linspace(a, b, n)
#var f = sin(x)
#
#var I_trap = (h/2)*(f[0] + 2 * sum(f[1:n-1]) + f[n-1])
#var err_trap = 2 - I_trap
#
#print(I_trap)
#print(err_trap)
#
#func f(x):
#
#
#func linspace(start, stop, num=50, endpoint=True):
#    num = int(num)
#    start = start * 1.
#    stop = stop * 1.
#
#    if num == 1:
#        yield stop
#        return
#    if endpoint:
#        step = (stop - start) / (num - 1)
#    else:
#        step = (stop - start) / num
#
#    for i in range(num):
#        yield start + step * i
#
#
##
##
### Declare member variables here. Examples:
### var a = 2
### var b = "text"
##
##export var a : float
##export var b : float
##export var eps : float
##
##
### Called when the node enters the scene tree for the first time.
##
##
##
##func function_to_integrate(independent_variable):
##	return independent_variable * independent_variable
##
##func trapezoidal(function_to_integrate, a, b, n):
##	var x : float
##	var h : float
##	var sum := 0.0
##	var integral
##
##
##	h = float(abs(b-a)) / n
##
##	for i in n:
##		x = a + i * h
##		sum = sum + function_to_integrate(x)
##
##	integral = (h/2)*(function_to_integrate(a) + function_to_integrate(b) + 2 * sum)
##
##	return integral
##
##
##func _ready():
###  int n,i=2;
###  double a,b,h,eps,sum=0,integral,integral_new;
###
###  /*Ask the user for necessary input */
###  printf("\nEnter the initial limit: ");
###  scanf("%lf",&a);
###  printf("\nEnter the final limit: ");
###  scanf("%lf",&b);
###  printf("\nEnter the desired accuracy: ");
###  scanf("%lf",&eps);
###  integral_new=trapezoidal(f,a,b,i);
##
##	var n : int
##	var i := 2
##	var h : float 
##	var integral : float 
##	var integral_new : float 
##	var sum := 0.0
##	var f = function_to_integrate(x)
##	integral_new = trapezoidal(f, a, b, i)
##
### Called every frame. 'delta' is the elapsed time since the previous frame.
###func _process(delta):
###	pass
##
###/* Define the function to be integrated here: */
###double f(double x){
###  return x*x;
###}
###
###/*Function definition to perform integration by Trapezoidal Rule */
###double trapezoidal(double f(double x), double a, double b, int n){
###  double x,h,sum=0,integral;
###  int i;
###  h=fabs(b-a)/n;
###  for(i=1;i<n;i++){
###    x=a+i*h;
###    sum=sum+f(x);
###  }
###  integral=(h/2)*(f(a)+f(b)+2*sum);
###  return integral;
###}
###
###/*Program begins*/
###main(){
###  int n,i=2;
###  double a,b,h,eps,sum=0,integral,integral_new;
###
###  /*Ask the user for necessary input */
###  printf("\nEnter the initial limit: ");
###  scanf("%lf",&a);
###  printf("\nEnter the final limit: ");
###  scanf("%lf",&b);
###  printf("\nEnter the desired accuracy: ");
###  scanf("%lf",&eps);
###  integral_new=trapezoidal(f,a,b,i);
###
###  /* Perform integration by trapezoidal rule for different number of sub-intervals until they converge to the given accuracy:*/
###  do{
###    integral=integral_new;
###    i++;
###    integral_new=trapezoidal(f,a,b,i);
###  }while(fabs(integral_new-integral)>=eps);
###
###  /*Print the answer */
###  printf("The integral is: %lf\n with %d intervals",integral_new,i);
###}
###
