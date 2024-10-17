void main() {


  int a=3;
  int b=5;
  int total;

  total= add(firstno:a,secondno:b);

  print(total) ;
  total=substact(b,a,7);
  print(total);

}





add({required int firstno,required int secondno}){
  return (firstno+secondno);

}

substact( int firstno,int secondno, int third){
  return(firstno-secondno);
}