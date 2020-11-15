import 'package:flutter/material.dart';
import 'package:telaa_app/screen/add_client.dart';
import 'package:telaa_app/styleguide/constants.dart';

class EmailFAB extends StatelessWidget {
  final VoidCallback onPressed;
  EmailFAB({this.onPressed});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: primaryColor,
      child: Icon(Icons.add,color: Colors.white,),
      //Theme.of(context).brightness==Brightness.dark?null:Colors.white,
   /*   child: CustomPaint(
        child: Container(),
        foregroundPainter: FloatingPainter(),
      ),*/
      foregroundColor: Colors.amberAccent,
      focusColor: Color(0xFF872954),
      onPressed: (){
        Navigator.push(context,MaterialPageRoute(
            builder: (context) =>
                AddClientPage(ClientMode.Adding,null)));

      },
    );
  }
}
class FloatingPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Paint amberPaint = Paint()..color= Colors.amber..strokeWidth=5;
    Paint greenPaint = Paint()..color= Colors.green..strokeWidth=5;
    Paint bluePaint = Paint()..color= Colors.blue..strokeWidth=5;
    Paint redPaint = Paint()..color= Colors.redAccent..strokeWidth=5;
    canvas.drawLine(Offset(size.width*0.27, size.height*0.5),
        Offset(size.width*0.5, size.height*0.5), amberPaint);
    canvas.drawLine(Offset(size.width*0.5, size.height*0.5),
        Offset(size.width*0.5, size.height - (size.height*0.27)), greenPaint);
    canvas.drawLine(Offset(size.width*0.5, size.height*0.5),
        Offset(size.width-(size.width*0.27), size.height*0.5), bluePaint);
    canvas.drawLine(Offset(size.width*0.5, size.height*0.5),
        Offset(size.width*0.5, size.height*0.27), redPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate)=>false;

  @override
  bool shouldRebuildSemantics(CustomPainter oldDelegate) =>false;
}
