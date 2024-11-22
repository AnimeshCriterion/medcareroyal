import 'medcare_utill.dart';

void main() {


  int a=3;
  int b=5;
  int total;

  total= add(firstno:a,secondno:b);

  dPrint(total) ;
  total=substact(b,a,7);
  dPrint(total);

}





add({required int firstno,required int secondno}){
  return (firstno+secondno);

}

substact( int firstno,int secondno, int third){
  return(firstno-secondno);
}